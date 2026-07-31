using System.Net;
using System.Text.Json;
using Appoynt.API.Middlewares;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Moq;

namespace Appoynt.Tests.UnitTests.API;

/// <summary>
/// Tests GlobalExceptionHandler exception mapping, logging, and RFC 7807 ProblemDetails output.
/// </summary>
public sealed class GlobalExceptionHandlerTests
{
    [Theory]
    [InlineData(typeof(UnauthorizedAccessException), StatusCodes.Status401Unauthorized, "Unauthorized")]
    [InlineData(typeof(KeyNotFoundException), StatusCodes.Status404NotFound, "Resource Not Found")]
    [InlineData(typeof(InvalidOperationException), StatusCodes.Status400BadRequest, "Bad Request")]
    [InlineData(typeof(Exception), StatusCodes.Status500InternalServerError, "An unexpected error occurred")]
    public async Task TryHandleAsync_ShouldMapExceptionToCorrectProblemDetails(
        Type exceptionType,
        int expectedStatusCode,
        string expectedTitle)
    {
        var loggerMock = new Mock<ILogger<GlobalExceptionHandler>>();
        var envMock = new Mock<IHostEnvironment>();
        envMock.Setup(e => e.EnvironmentName).Returns("Development");

        var handler = new GlobalExceptionHandler(loggerMock.Object, envMock.Object);

        var context = new DefaultHttpContext();
        context.Response.Body = new MemoryStream();

        var exception = (Exception)Activator.CreateInstance(exceptionType, "Test error message")!;

        bool result = await handler.TryHandleAsync(context, exception, CancellationToken.None);

        result.Should().BeTrue();
        context.Response.StatusCode.Should().Be(expectedStatusCode);
        context.Response.ContentType.Should().Be("application/problem+json");

        context.Response.Body.Seek(0, SeekOrigin.Begin);
        using var reader = new StreamReader(context.Response.Body);
        string responseBody = await reader.ReadToEndAsync();

        var problemDetails = JsonSerializer.Deserialize<ProblemDetails>(responseBody, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });

        problemDetails.Should().NotBeNull();
        problemDetails!.Status.Should().Be(expectedStatusCode);
        problemDetails.Title.Should().Be(expectedTitle);
    }
}

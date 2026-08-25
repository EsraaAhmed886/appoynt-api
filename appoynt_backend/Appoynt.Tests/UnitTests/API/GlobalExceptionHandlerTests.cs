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

    [Fact]
    public async Task TryHandleAsync_InDevelopment_ShouldExposeRawExceptionMessage()
    {
        // Arrange a handler running in the Development environment.
        var loggerMock = new Mock<ILogger<GlobalExceptionHandler>>();
        var envMock = new Mock<IHostEnvironment>();
        envMock.Setup(e => e.EnvironmentName).Returns("Development");
        var handler = new GlobalExceptionHandler(loggerMock.Object, envMock.Object);

        var context = new DefaultHttpContext();
        context.Response.Body = new MemoryStream();

        // Act handling an argument exception carrying a sensitive message.
        await handler.TryHandleAsync(context, new ArgumentException("Connection string revealed", "param"), CancellationToken.None);

        // Assert Development keeps full diagnostics for engineers.
        string body = await ReadResponseBodyAsync(context);
        var problemDetails = DeserializeProblemDetails(body);
        problemDetails!.Detail.Should().Contain("Connection string revealed");
    }

    [Theory]
    [InlineData(typeof(ArgumentException))]
    [InlineData(typeof(InvalidOperationException))]
    [InlineData(typeof(UnauthorizedAccessException))]
    public async Task TryHandleAsync_OutsideDevelopment_ShouldMaskRawExceptionMessage(Type exceptionType)
    {
        // Arrange a handler simulating the Production environment.
        var loggerMock = new Mock<ILogger<GlobalExceptionHandler>>();
        var envMock = new Mock<IHostEnvironment>();
        envMock.Setup(e => e.EnvironmentName).Returns("Production");
        var handler = new GlobalExceptionHandler(loggerMock.Object, envMock.Object);

        var context = new DefaultHttpContext();
        context.Response.Body = new MemoryStream();

        // Act handling an exception whose message would disclose internals.
        var exception = (Exception)Activator.CreateInstance(exceptionType, "Sensitive internal detail")!;

        // Assert Production never echoes raw messages back to callers.
        bool result = await handler.TryHandleAsync(context, exception, CancellationToken.None);

        result.Should().BeTrue();
        string body = await ReadResponseBodyAsync(context);
        var problemDetails = DeserializeProblemDetails(body);
        problemDetails!.Detail.Should().NotContain("Sensitive internal detail");
    }

    /// <summary>
    /// Reads the fully written response body from the simulated context.
    /// </summary>
    /// <param name="context">The HTTP context holding the response.</param>
    /// <returns>The raw JSON body text.</returns>
    private static async Task<string> ReadResponseBodyAsync(DefaultHttpContext context)
    {
        // Rewind before reading so the full payload is captured.
        context.Response.Body.Seek(0, SeekOrigin.Begin);
        using var reader = new StreamReader(context.Response.Body);
        return await reader.ReadToEndAsync();
    }

    /// <summary>
    /// Deserializes a ProblemDetails payload using case-insensitive options.
    /// </summary>
    /// <param name="json">The raw JSON text.</param>
    /// <returns>The parsed ProblemDetails instance.</returns>
    private static ProblemDetails? DeserializeProblemDetails(string json)
    {
        // Parse with relaxed casing matching ASP.NET serialization defaults.
        return JsonSerializer.Deserialize<ProblemDetails>(json, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });
    }
}

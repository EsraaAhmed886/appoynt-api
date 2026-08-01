/**
 * File Name      : GlobalExceptionHandler.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : Microsoft.AspNetCore.Diagnostics, ProblemDetails, IHostEnvironment
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 27/07/2026
 * Description    : Provides centralized, structured RFC 7807 ProblemDetails
 *                  exception handling across the HTTP request pipeline.
 */

using System.Diagnostics;
using System.Text.Json;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace Appoynt.API.Middlewares;

/// <summary>
/// Catches unhandled exceptions across the application HTTP pipeline and
/// maps them to standardized RFC 7807 ProblemDetails responses.
/// </summary>
public sealed class GlobalExceptionHandler : IExceptionHandler
{
    private readonly ILogger<GlobalExceptionHandler> _logger;
    private readonly IHostEnvironment _environment;

    /// <summary>
    /// Initializes a new instance of the <see cref="GlobalExceptionHandler"/> class.
    /// </summary>
    /// <param name="logger">The logger instance.</param>
    /// <param name="environment">The hosting environment.</param>
    public GlobalExceptionHandler(
        ILogger<GlobalExceptionHandler> logger,
        IHostEnvironment environment)
    {
        _logger = logger;
        _environment = environment;
    }

    /// <inheritdoc />
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(httpContext);
        ArgumentNullException.ThrowIfNull(exception);

        _logger.LogError(
            exception,
            "An unhandled exception of type '{ExceptionType}' occurred while processing request '{Path}'.",
            exception.GetType().Name,
            httpContext.Request.Path);

        (int statusCode, string title, string detail) = MapException(exception);

        var problemDetails = new ProblemDetails
        {
            Status = statusCode,
            Title = title,
            Detail = detail,
            Instance = httpContext.Request.Path
        };

        string? traceId = Activity.Current?.Id ?? httpContext.TraceIdentifier;
        if (!string.IsNullOrEmpty(traceId))
        {
            problemDetails.Extensions["traceId"] = traceId;
        }
        else
        {
        }

        httpContext.Response.StatusCode = statusCode;
        httpContext.Response.ContentType = "application/problem+json";

        string json = JsonSerializer.Serialize(problemDetails);
        await httpContext.Response.WriteAsync(json, cancellationToken).ConfigureAwait(false);

        return true;
    }

    /// <summary>
    /// Maps an unhandled exception to an HTTP status code, title, and detailed message.
    /// </summary>
    private (int StatusCode, string Title, string Detail) MapException(Exception exception)
    {
        return exception switch
        {
            UnauthorizedAccessException => (
                StatusCodes.Status401Unauthorized,
                "Unauthorized",
                exception.Message),

            KeyNotFoundException => (
                StatusCodes.Status404NotFound,
                "Resource Not Found",
                exception.Message),

            ArgumentException or InvalidOperationException => (
                StatusCodes.Status400BadRequest,
                "Bad Request",
                exception.Message),

            _ => (
                StatusCodes.Status500InternalServerError,
                "An unexpected error occurred",
                _environment.IsDevelopment()
                    ? exception.Message
                    : "An unexpected internal server error occurred while processing your request.")
        };
    }
}

/**
 * File Name      : GlobalExceptionHandler.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 27/07/2026
 * Version        : v1.0.0
 * Dependencies   : Microsoft.AspNetCore.Diagnostics, ProblemDetails, IHostEnvironment
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Provides centralized, structured RFC 7807 ProblemDetails
 *                  exception handling across the HTTP request pipeline.
 *                  Raw exception details are disclosed only in Development.
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
    /// Raw exception messages are exposed only in Development; all other environments
    /// receive a generic, non-revealing detail to avoid information disclosure.
    /// </summary>
    private (int StatusCode, string Title, string Detail) MapException(Exception exception)
    {
        // Determine whether raw exception details may be disclosed to the caller.
        bool isDevelopment = _environment.IsDevelopment();

        return exception switch
        {
            UnauthorizedAccessException => (
                StatusCodes.Status401Unauthorized,
                "Unauthorized",
                isDevelopment ? exception.Message : GenericClientErrorDetail),

            KeyNotFoundException => (
                StatusCodes.Status404NotFound,
                "Resource Not Found",
                isDevelopment ? exception.Message : GenericNotFoundErrorDetail),

            ArgumentException or InvalidOperationException => (
                StatusCodes.Status400BadRequest,
                "Bad Request",
                isDevelopment ? exception.Message : GenericClientErrorDetail),

            _ => (
                StatusCodes.Status500InternalServerError,
                "An unexpected error occurred",
                isDevelopment
                    ? exception.Message
                    : "An unexpected internal server error occurred while processing your request.")
        };
    }

    /// <summary>
    /// Generic detail used for client-error classes outside Development.
    /// </summary>
    private const string GenericClientErrorDetail = "The request could not be processed.";

    /// <summary>
    /// Generic detail used for not-found error classes outside Development.
    /// </summary>
    private const string GenericNotFoundErrorDetail = "The requested resource was not found.";
}

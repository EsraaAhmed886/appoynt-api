/**
 * File Name      : Program.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 08/07/2026
 * Version        : v1.0.0
 * Dependencies   : Application, Infrastructure
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 21/07/2026
 * Description    : Configures the application's services, middleware,
 *                  and HTTP request pipeline.
 */

using Appoynt.Application;
using Appoynt.Infrastructure;
using Appoynt.Infrastructure.Persistence.Extensions;

namespace Appoynt.API;

/// <summary>
/// Application entry point.
/// </summary>
public class Program
{
    /// <summary>
    /// Configures and starts the web application.
    /// </summary>
    /// <param name="args">
    /// Command-line arguments.
    /// </param>
    public static async Task Main(string[] args)
    {
        // Create the application builder.
        var builder = WebApplication.CreateBuilder(args);

        #region Service Registration

        // Register the Application layer services.
        builder.Services.AddApplication();

        // Register the Infrastructure layer services.
        builder.Services.AddInfrastructure(builder.Configuration);
        // Register MVC controllers.
        builder.Services.AddControllers();

        // Register Swagger/OpenAPI services.
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen(options =>
        {
            options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
            {
                Title = "Appoynt API",
                Version = "v1",
                Description = "API documentation for the Appoynt application",
                Contact = new Microsoft.OpenApi.Models.OpenApiContact
                {
                    Name = "Appoynt Team",
                    Email = "support@appoynt.com"
                }
            });

            options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Name = "Authorization",
                Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
                Scheme = "bearer",
                BearerFormat = "JWT",
                In = Microsoft.OpenApi.Models.ParameterLocation.Header,
                Description = "Enter a valid JWT Bearer token."
            });

            options.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
            {
                {
                    new Microsoft.OpenApi.Models.OpenApiSecurityScheme
                    {
                        Reference = new Microsoft.OpenApi.Models.OpenApiReference
                        {
                            Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        }
                    },
                    Array.Empty<string>()
                }
            });
        });

        #endregion

        // Build the application.
        var app = builder.Build();

        await app.InitializeDatabaseAsync();

        #region HTTP Request Pipeline

        // Enable Swagger only in the Development environment.
        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI(options =>
            {
                options.SwaggerEndpoint("/swagger/v1/swagger.json", "Appoynt API v1");
                options.RoutePrefix = string.Empty; // Set Swagger UI as the root page
            });
        }

        // Redirect HTTP requests to HTTPS.
        app.UseHttpsRedirection();

        // Authenticate requests using the configured authentication scheme.
        app.UseAuthentication();

        // Authorization middleware.
        app.UseAuthorization();

        // Map controller endpoints.
        app.MapControllers();

        #endregion

        // Start the application.
        app.Run();
    }
}

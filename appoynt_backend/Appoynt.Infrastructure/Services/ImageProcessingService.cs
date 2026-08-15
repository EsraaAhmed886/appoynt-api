/**
 * File Name      : ImageProcessingService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : IImageProcessingService, SixLabors.ImageSharp
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Implements image resizing and JPEG compression using SixLabors.ImageSharp.
 */

using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Processing;

namespace Appoynt.Infrastructure.Services;

/// <summary>
/// Service responsible for resizing and compressing images before storage.
/// </summary>
public sealed class ImageProcessingService : IImageProcessingService
{
    /// <inheritdoc />
    public async Task<Stream> ProcessProfileImageAsync(
        Stream inputStream,
        int maxDimension,
        int jpegQuality,
        CancellationToken cancellationToken = default)
    {
        // Guard against null input stream.
        ArgumentNullException.ThrowIfNull(inputStream);

        // Ensure stream position is at the beginning if seekable.
        if (inputStream.CanSeek && inputStream.Position != 0)
        {
            inputStream.Position = 0;
        }
        else
        {
            // No action required.
        }

        // Load the image asynchronously using ImageSharp.
        using var image = await Image.LoadAsync(inputStream, cancellationToken);

        // Check whether resizing is necessary (only downscale, never upscale).
        if (image.Width > maxDimension || image.Height > maxDimension)
        {
            // Configure resize options to cap maximum dimension while preserving aspect ratio.
            var resizeOptions = new ResizeOptions
            {
                Size = new Size(maxDimension, maxDimension),
                Mode = ResizeMode.Max,
                Sampler = KnownResamplers.Lanczos3
            };

            // Apply the resize mutation.
            image.Mutate(context => context.Resize(resizeOptions));
        }
        else
        {
            // Image is already within the dimension limits; no resize needed.
        }

        // Configure JPEG encoder with the specified quality setting.
        var jpegEncoder = new JpegEncoder
        {
            Quality = Math.Clamp(jpegQuality, 1, 100)
        };

        // Create an in-memory destination stream for the compressed JPEG output.
        var outputStream = new MemoryStream();

        // Encode and save the image as JPEG into the memory stream.
        await image.SaveAsJpegAsync(outputStream, jpegEncoder, cancellationToken);

        // Reset the stream position to the beginning so consumers can read immediately.
        outputStream.Position = 0;

        // Return the readable stream.
        return outputStream;
    }
}

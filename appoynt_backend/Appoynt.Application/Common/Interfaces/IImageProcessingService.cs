/**
 * File Name      : IImageProcessingService.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-14
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-14
 * Description    : Defines the contract for processing, resizing, and re-encoding uploaded images.
 */

using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace Appoynt.Application.Common.Interfaces;

/// <summary>
/// Provides methods for processing and compressing image streams.
/// </summary>
public interface IImageProcessingService
{
    /// <summary>
    /// Processes an input image by resizing it to fit within the specified maximum dimension (preserving aspect ratio, without upscaling)
    /// and re-encoding it to JPEG format at the specified compression quality.
    /// </summary>
    /// <param name="inputStream">The input stream containing the raw uploaded image.</param>
    /// <param name="maxDimension">The maximum width or height in pixels.</param>
    /// <param name="jpegQuality">The JPEG quality level (0 to 100).</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A new readable stream containing the processed JPEG image.</returns>
    Task<Stream> ProcessProfileImageAsync(
        Stream inputStream,
        int maxDimension,
        int jpegQuality,
        CancellationToken cancellationToken = default);
}

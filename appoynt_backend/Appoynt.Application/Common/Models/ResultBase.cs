/**
 * File Name      : ResultBase.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-24
 * Version        : v1.0.0
 * Dependencies   : None
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-24
 * Description    : Minimal shared foundation for feature operation results,
 *                  carrying only success state and structured errors so each
 *                  concrete result keeps its own public JSON contract.
 */

using System.Collections.Generic;

namespace Appoynt.Application.Common.Models;

/// <summary>
/// Carries the members common to every operation result. Concrete results
/// derive from this class solely to reuse success/error plumbing; they remain
/// responsible for their own identifiers and serialization shapes.
/// </summary>
public abstract class ResultBase
{
    /// <summary>
    /// Gets a value indicating whether the operation succeeded.
    /// </summary>
    public bool Succeeded { get; protected init; }

    /// <summary>
    /// Gets the collection of errors when the operation failed.
    /// </summary>
    public IReadOnlyList<AuthenticationError> Errors { get; protected init; } = [];

    /// <summary>
    /// Initializes a new instance of the <see cref="ResultBase"/> class.
    /// </summary>
    /// <param name="succeeded">Indicates whether the operation succeeded.</param>
    /// <param name="errors">Optional errors carried by a failed operation.</param>
    protected ResultBase(bool succeeded, IReadOnlyList<AuthenticationError>? errors)
    {
        Succeeded = succeeded;
        Errors = errors ?? [];
    }
}

/*
 * File Name: failures.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V2.0.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Defines the comprehensive failure hierarchy used to represent
 *   every category of domain-level error across the application's clean architecture
 *   layers. Each subclass maps to a distinct localization key group so that no raw
 *   server messages are ever surfaced directly to the user.
 */

// Importing Equatable for value-based failure comparison
import 'package:equatable/equatable.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BASE
// ─────────────────────────────────────────────────────────────────────────────

// Abstract base class for all domain-level failure representations
abstract class Failure extends Equatable {
  // Optional human-readable localization key referencing the failure
  final String? message_key;

  // Constructor accepting optional message localization key reference
  const Failure([this.message_key]);

  // Equatable props including the message key for value comparisons
  @override
  List<Object?> get props {
    // Return list including message key
    return [message_key];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NETWORK & SECURITY FAILURES
// ─────────────────────────────────────────────────────────────────────────────

// Failure triggered when the device has no active internet connection
class NoInternetFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const NoInternetFailure()
      : super('error_no_internet');
}

// Failure triggered when a connection or response timeout threshold is exceeded
class TimeoutFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const TimeoutFailure()
      : super('error_timeout');
}

// Failure triggered by SSL certificate validation or TLS handshake rejection
class SslHandshakeFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const SslHandshakeFailure()
      : super('error_ssl_handshake');
}

// Failure triggered when a network request is explicitly cancelled mid-flight
class RequestCancelledFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const RequestCancelledFailure()
      : super('error_request_cancelled');
}

// ─────────────────────────────────────────────────────────────────────────────
// AUTH & ACCESS CONTROL FAILURES
// ─────────────────────────────────────────────────────────────────────────────

// Failure triggered on HTTP 401 — session token expired or missing
class UnauthorizedFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const UnauthorizedFailure()
      : super('error_session_expired');
}

// Failure triggered on HTTP 403 — caller lacks required resource permissions
class ForbiddenFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const ForbiddenFailure()
      : super('error_forbidden');
}

// ─────────────────────────────────────────────────────────────────────────────
// CLIENT & BUSINESS LOGIC FAILURES
// ─────────────────────────────────────────────────────────────────────────────

// Failure triggered on HTTP 400 — request payload violates contract schema
class BadRequestFailure extends Failure {
  // Constructor accepting optional server-driven message for display
  const BadRequestFailure([String? message_key])
      : super(message_key ?? 'error_bad_request');
}

// Failure triggered on HTTP 404 — requested resource does not exist
class NotFoundFailure extends Failure {
  // Constructor accepting optional server-driven message for display
  const NotFoundFailure([String? message_key])
      : super(message_key ?? 'error_not_found');
}

// Failure triggered on HTTP 409 — operation conflicts with existing state
class ConflictFailure extends Failure {
  // Constructor accepting optional server-driven message for display
  const ConflictFailure([String? message_key])
      : super(message_key ?? 'error_conflict');
}

// Failure triggered on HTTP 413 — file or payload exceeds the size limit
class PayloadTooLargeFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const PayloadTooLargeFailure()
      : super('error_payload_too_large');
}

// Failure triggered on HTTP 422 — request is well-formed but semantically invalid
class UnprocessableFailure extends Failure {
  // Constructor accepting optional server-driven message for display
  const UnprocessableFailure([String? message_key])
      : super(message_key ?? 'error_unprocessable');
}

// Failure triggered on HTTP 429 — caller has exceeded the API rate limit quota
class RateLimitFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const RateLimitFailure()
      : super('error_rate_limit');
}

// ─────────────────────────────────────────────────────────────────────────────
// SYSTEM & APP LIFECYCLE FAILURES
// ─────────────────────────────────────────────────────────────────────────────

// Failure triggered on HTTP 426 — client app version is outdated, upgrade required
class AppUpdateRequiredFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const AppUpdateRequiredFailure()
      : super('error_app_update_required');
}

// Failure triggered on HTTP 5xx — unrecoverable server-side error condition
class ServerFailure extends Failure {
  // Constructor accepting optional server-driven message for display
  const ServerFailure([String? message_key])
      : super(message_key ?? 'error_server');
}

// Failure triggered on HTTP 503 — backend is in planned maintenance mode
class MaintenanceFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const MaintenanceFailure()
      : super('error_maintenance');
}

// Failure triggered when a JSON response body cannot be deserialized correctly
class DataParsingFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const DataParsingFailure()
      : super('error_data_parsing');
}

// Failure triggered for all uncategorized, unexpected error conditions
class UnknownFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const UnknownFailure()
      : super('error_unknown');
}

// Failure triggered for local database or secure-storage access errors
class CacheFailure extends Failure {
  // Constructor forwarding the localization key to base class
  const CacheFailure()
      : super('error_cache');
}

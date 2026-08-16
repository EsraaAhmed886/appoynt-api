/*
 * File Name: error_handler.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dio/dio.dart, failures.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Centralized error processing utility that maps every
 *   Dio/HTTP exception, SSL/handshake error, and JSON parsing failure to a
 *   strongly-typed Failure subclass. No raw exception or server message is
 *   ever exposed directly to the UI layer.
 */

// Importing Dio for DioException and response types
import 'package:dio/dio.dart';
// Importing the full failure hierarchy
import 'package:appoynt_mobile_app/core/error/failures.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ApiFailure — structured DTO wrapping a typed Failure and optional raw detail
// ─────────────────────────────────────────────────────────────────────────────

// Immutable model representing a processed API error with a typed Failure object
class ApiFailure {
  // Strongly-typed failure category derived from the exception classification
  final Failure failure;
  // Optional server-driven message field extracted from response data map
  final String? server_message;

  // Constructor initializing both required and optional members
  const ApiFailure({
    // Required typed failure instance
    required this.failure,
    // Optional raw server message for diagnostic logging
    this.server_message,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// ErrorHandler — static utility mapping exceptions to ApiFailure objects
// ─────────────────────────────────────────────────────────────────────────────

// Static utility class for mapping all exception types to ApiFailure instances
class ErrorHandler {
  // Private constructor preventing instantiation of this utility class
  ErrorHandler._();

  // Primary entry point: maps any thrown exception to an ApiFailure instance
  static ApiFailure handle(Object exception) {
    // Check if the exception originates from the Dio networking layer
    if (exception is DioException) {
      // Delegate to the specialized Dio exception mapper
      return _map_dio_exception(exception);
    } else if (exception is FormatException) {
      // Map JSON or data format parsing failures
      return const ApiFailure(failure: DataParsingFailure());
    } else {
      // Catch-all for unanticipated exception types
      return const ApiFailure(failure: UnknownFailure());
    }
  }

  // Maps a DioException to the appropriate typed Failure subclass
  static ApiFailure _map_dio_exception(DioException exception) {
    // Branch on the Dio exception type enumeration
    switch (exception.type) {
      // Connection timeout — server did not accept connection in time
      case DioExceptionType.connectionTimeout:
        return const ApiFailure(failure: TimeoutFailure());

      // Send timeout — request data could not be sent within the deadline
      case DioExceptionType.sendTimeout:
        return const ApiFailure(failure: TimeoutFailure());

      // Receive timeout — server began but didn't finish sending response
      case DioExceptionType.receiveTimeout:
        return const ApiFailure(failure: TimeoutFailure());

      // HTTP error response received — delegate to HTTP status code mapper
      case DioExceptionType.badResponse:
        return _map_http_status(exception);

      // Request explicitly cancelled by the caller mid-flight
      case DioExceptionType.cancel:
        return const ApiFailure(failure: RequestCancelledFailure());

      // Low-level connection errors including SSL/TLS handshake failures
      case DioExceptionType.connectionError:
        return _map_connection_error(exception);

      // Unknown Dio error type — wrap in generic unknown failure
      case DioExceptionType.unknown:
        return _map_unknown_dio(exception);

      // Default case satisfying Dart exhaustive switch requirement
      default:
        return const ApiFailure(failure: UnknownFailure());
    }
  }

  // Maps the HTTP status code from a badResponse DioException to a typed Failure
  static ApiFailure _map_http_status(DioException exception) {
    // Extract the HTTP status code from the response object
    final int? status_code = exception.response?.statusCode;
    // Extract the optional server-driven message from the response data map
    final String? server_msg = _extract_server_message(exception.response);

    // Branch on the numeric HTTP status code value
    if (400 == status_code) {
      // Bad request — schema or contract violation
      return ApiFailure(
        failure: BadRequestFailure(server_msg),
        server_message: server_msg,
      );
    } else if (401 == status_code) {
      // Unauthorized — session token is expired or missing
      return ApiFailure(
        failure: const UnauthorizedFailure(),
        server_message: server_msg,
      );
    } else if (403 == status_code) {
      // Forbidden — caller lacks required permissions
      return ApiFailure(
        failure: const ForbiddenFailure(),
        server_message: server_msg,
      );
    } else if (404 == status_code) {
      // Not found — requested resource does not exist on the server
      return ApiFailure(
        failure: NotFoundFailure(server_msg),
        server_message: server_msg,
      );
    } else if (409 == status_code) {
      // Conflict — operation conflicts with existing resource state
      return ApiFailure(
        failure: ConflictFailure(server_msg),
        server_message: server_msg,
      );
    } else if (413 == status_code) {
      // Payload too large — file or body exceeds server size limit
      return ApiFailure(
        failure: const PayloadTooLargeFailure(),
        server_message: server_msg,
      );
    } else if (422 == status_code) {
      // Unprocessable entity — semantic validation failed on the server
      return ApiFailure(
        failure: UnprocessableFailure(server_msg),
        server_message: server_msg,
      );
    } else if (426 == status_code) {
      // Upgrade required — client must update the application version
      return ApiFailure(
        failure: const AppUpdateRequiredFailure(),
        server_message: server_msg,
      );
    } else if (429 == status_code) {
      // Too many requests — rate limit quota has been exceeded
      return ApiFailure(
        failure: const RateLimitFailure(),
        server_message: server_msg,
      );
    } else if (null != status_code && 500 <= status_code && 599 >= status_code) {
      // Server error — check for 503 maintenance specifically
      if (503 == status_code) {
        // Service unavailable — server is in planned maintenance mode
        return ApiFailure(
          failure: const MaintenanceFailure(),
          server_message: server_msg,
        );
      } else {
        // Generic 5xx server-side unrecoverable error condition
        return ApiFailure(
          failure: const ServerFailure(),
          server_message: server_msg,
        );
      }
    } else {
      // Unmapped status code — use generic server failure representation
      return ApiFailure(
        failure: ServerFailure(server_msg),
        server_message: server_msg,
      );
    }
  }

  // Maps a connectionError DioException to SSL or no-internet failure types
  static ApiFailure _map_connection_error(DioException exception) {
    // Convert the inner exception message to lowercase for keyword detection
    final String error_message =
        exception.error?.toString().toLowerCase() ?? '';
    // Check for SSL/TLS handshake error signature keyword
    if (error_message.contains('handshake') ||
        error_message.contains('certificate') ||
        error_message.contains('ssl') ||
        error_message.contains('tls')) {
      // SSL certificate or TLS handshake failure detected
      return const ApiFailure(failure: SslHandshakeFailure());
    } else if (error_message.contains('socketexception') ||
        error_message.contains('network') ||
        error_message.contains('unreachable') ||
        error_message.contains('connection refused')) {
      // Device has no active internet connection
      return const ApiFailure(failure: NoInternetFailure());
    } else {
      // Generic connection error without identifiable sub-type
      return const ApiFailure(failure: UnknownFailure());
    }
  }

  // Maps an unknown-type DioException to the appropriate typed Failure subclass
  static ApiFailure _map_unknown_dio(DioException exception) {
    // Inspect inner error string for network connectivity keywords
    final String inner = exception.error?.toString().toLowerCase() ?? '';
    // Check for no-internet connectivity signal in the inner error message
    if (inner.contains('socketexception') || inner.contains('network')) {
      // No active internet connection detected in the inner exception message
      return const ApiFailure(failure: NoInternetFailure());
    } else {
      // No specific pattern identified — treat as a generic unknown failure
      return const ApiFailure(failure: UnknownFailure());
    }
  }

  // Extracts the `message` field from a Dio response data map if it exists
  static String? _extract_server_message(Response<dynamic>? response) {
    // Guard against null response object
    if (null == response) {
      // No response object available to extract message from
      return null;
    } else {
      // Proceed with extraction attempt on the response data
    }
    // Cast response data to a map if it is of the correct runtime type
    if (response.data is Map<String, dynamic>) {
      // Extract the response data map reference
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      // Prioritize 'message' key, then 'error', then 'detail' from the map
      final Object? raw_message = data['message'] ?? data['error'] ?? data['detail'];
      // Return string message if present, null otherwise
      if (null != raw_message && raw_message is String && raw_message.isNotEmpty) {
        // Return clean server message string
        return raw_message;
      } else {
        // No recognizable message field found in response data map
        return null;
      }
    } else {
      // Response data is not a map — cannot extract message from it
      return null;
    }
  }
}

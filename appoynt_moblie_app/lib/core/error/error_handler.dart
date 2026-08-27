/*
 * File Name: error_handler.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V2.0.0
 * Dependencies: dart:ui, package:dio/dio.dart, failures.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 27/08/2026]
 * File Description: Centralized error processing utility that maps every
 *   Dio/HTTP exception, SSL/handshake error, and JSON parsing failure to a
 *   strongly-typed Failure subclass or user-friendly localized message string.
 *   No raw technical exception dumps or untranslated keys are ever exposed directly to the UI.
 */

// Importing dart:ui for platform locale resolution
import 'dart:ui';
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
// ErrorHandler — static utility mapping exceptions to ApiFailure objects & messages
// ─────────────────────────────────────────────────────────────────────────────

// Static utility class for mapping all exception types to user-friendly messages and ApiFailure instances
class ErrorHandler {
  // Private constructor preventing instantiation of this utility class
  ErrorHandler._();

  // Resolves the current system or application active language code ('en' or 'ar')
  static String getCurrentLanguageCode() {
    if (true == PlatformDispatcher.instance.locale.languageCode.startsWith('ar')) {
      return 'ar';
    } else {
      return 'en';
    }
  }

  // Maps any DioException scenario to a user-friendly, localized error message string
  static String handleDioError(DioException error, {String? languageCode}) {
    final String lang = languageCode ?? getCurrentLanguageCode();

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        if ('ar' == lang) {
          return 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مجدداً.';
        } else {
          return 'Connection timed out. Please check your internet connection and try again.';
        }

      case DioExceptionType.connectionError:
        if ('ar' == lang) {
          return 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.';
        } else {
          return 'No internet connection. Please check your network and try again.';
        }

      case DioExceptionType.badResponse:
        final int? statusCode = error.response?.statusCode;
        final dynamic responseData = error.response?.data;
        final bool isPasswordEndpoint = error.requestOptions.path.contains('password');

        // Extract backend error message or error key if available in response data map
        if (responseData is Map<String, dynamic>) {
          final dynamic message = responseData['message'] ??
              responseData['error'] ??
              responseData['code'] ??
              responseData['title'] ??
              responseData['detail'];

          if (null != message && message.toString().isNotEmpty) {
            final String rawMsg = message.toString();
            if (isPasswordEndpoint && (rawMsg == 'Password update failed.' || rawMsg == 'Password update failed' || rawMsg == 'password_update_failed')) {
              return 'ar' == lang
                  ? 'كلمة المرور الحالية غير صحيحة.'
                  : 'Incorrect current password. Please try again.';
            } else {
              return mapBackendErrorKey(rawMsg, languageCode: lang);
            }
          } else if (responseData.containsKey('errors') && responseData['errors'] is Map) {
            final Map errors = responseData['errors'] as Map;
            if (errors.isNotEmpty) {
              final dynamic firstVal = errors.values.first;
              if (firstVal is List && firstVal.isNotEmpty) {
                return mapBackendErrorKey(firstVal.first.toString(), languageCode: lang);
              } else {
                return mapBackendErrorKey(firstVal.toString(), languageCode: lang);
              }
            } else {
              // No error entries in map
            }
          } else {
            // No recognizable message key in response
          }
        } else {
          // Response data is not a map
        }

        if (isPasswordEndpoint && (400 == statusCode || 401 == statusCode || 422 == statusCode)) {
          if ('ar' == lang) {
            return 'كلمة المرور الحالية غير صحيحة.';
          } else {
            return 'Incorrect current password. Please try again.';
          }
        } else if (401 == statusCode || 403 == statusCode) {
          if ('ar' == lang) {
            return 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';
          } else {
            return 'Your session has expired. Please log in again.';
          }
        } else if (404 == statusCode) {
          if ('ar' == lang) {
            return 'العنصر المطلوب غير موجود.';
          } else {
            return 'Requested resource was not found.';
          }
        } else if (null != statusCode && 500 <= statusCode) {
          if ('ar' == lang) {
            return 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.';
          } else {
            return 'Server error occurred. Please try again later.';
          }
        } else {
          if ('ar' == lang) {
            return 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
          } else {
            return 'An unexpected error occurred. Please try again.';
          }
        }

      case DioExceptionType.cancel:
        if ('ar' == lang) {
          return 'تم إلغاء الطلب.';
        } else {
          return 'Request was cancelled.';
        }

      default:
        if ('ar' == lang) {
          return 'حدث خطأ غير متوقع. يرجى المحاولة مجدداً.';
        } else {
          return 'An unexpected error occurred. Please try again.';
        }
    }
  }

  // Maps technical error keys or backend translation codes into clean localized strings
  static String mapBackendErrorKey(String key, {String? languageCode}) {
    final String lang = languageCode ?? getCurrentLanguageCode();
    final String cleanKey = key.trim();

    final Map<String, Map<String, String>> localizedKeys = {
      'en': {
        'error_session_expired': 'Your session has expired. Please log in again.',
        'session_expired': 'Your session has expired. Please log in again.',
        'unauthorized': 'You are not authorized to perform this action.',
        'error_unauthorized': 'You are not authorized to perform this action.',
        'error_no_internet': 'No internet connection. Please check your network and try again.',
        'error_timeout': 'Connection timed out. Please check your internet connection and try again.',
        'error_server': 'Server error occurred. Please try again later.',
        'error_not_found': 'Requested resource was not found.',
        'error_bad_request': 'Invalid request parameters. Please verify your information.',
        'error_unknown': 'An unexpected error occurred. Please try again.',
        'invalid_current_password': 'Incorrect current password. Please try again.',
        'incorrect_password': 'Incorrect current password. Please try again.',
        'incorrect_current_password': 'Incorrect current password. Please try again.',
        'wrong_password': 'Incorrect current password. Please try again.',
        'wrong_current_password': 'Incorrect current password. Please try again.',
        'invalid_password': 'Incorrect current password. Please try again.',
        'current_password_incorrect': 'Incorrect current password. Please try again.',
        'Password update failed.': 'Incorrect current password. Please try again.',
        'Password update failed': 'Incorrect current password. Please try again.',
        'password_update_failed': 'Incorrect current password. Please try again.',
      },
      'ar': {
        'error_session_expired': 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مجدداً.',
        'session_expired': 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مجدداً.',
        'unauthorized': 'غير مصرح لك بإجراء هذه العملية.',
        'error_unauthorized': 'غير مصرح لك بإجراء هذه العملية.',
        'error_no_internet': 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة.',
        'error_timeout': 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مجدداً.',
        'error_server': 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.',
        'error_not_found': 'العنصر المطلوب غير موجود.',
        'error_bad_request': 'البيانات المدخلة غير صحيحة. يرجى التأكد من صحة البيانات.',
        'error_unknown': 'حدث خطأ غير متوقع. يرجى المحاولة مجدداً.',
        'invalid_current_password': 'كلمة المرور الحالية غير صحيحة.',
        'incorrect_password': 'كلمة المرور الحالية غير صحيحة.',
        'incorrect_current_password': 'كلمة المرور الحالية غير صحيحة.',
        'wrong_password': 'كلمة المرور الحالية غير صحيحة.',
        'wrong_current_password': 'كلمة المرور الحالية غير صحيحة.',
        'invalid_password': 'كلمة المرور الحالية غير صحيحة.',
        'current_password_incorrect': 'كلمة المرور الحالية غير صحيحة.',
        'Password update failed.': 'كلمة المرور الحالية غير صحيحة.',
        'Password update failed': 'كلمة المرور الحالية غير صحيحة.',
        'password_update_failed': 'كلمة المرور الحالية غير صحيحة.',
      },
    };

    // If key is a known dictionary identifier, return translation
    if (localizedKeys[lang]?.containsKey(cleanKey) == true) {
      return localizedKeys[lang]![cleanKey]!;
    } else {
      // If the backend returned a readable human sentence (not a snake_case key), return it directly if reasonable
      if (cleanKey.contains(' ') && !cleanKey.startsWith('error_') && !cleanKey.contains('Exception')) {
        return cleanKey;
      } else {
        // Fallback to standard generic message
        if ('ar' == lang) {
          return 'حدث خطأ أثناء المعالجة.';
        } else {
          return 'An error occurred while processing your request.';
        }
      }
    }
  }

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
    if (true == error_message.contains('handshake') ||
        true == error_message.contains('certificate') ||
        true == error_message.contains('ssl') ||
        true == error_message.contains('tls')) {
      // SSL certificate or TLS handshake failure detected
      return const ApiFailure(failure: SslHandshakeFailure());
    } else if (true == error_message.contains('socketexception') ||
        true == error_message.contains('network') ||
        true == error_message.contains('unreachable') ||
        true == error_message.contains('connection refused')) {
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
    if (true == inner.contains('socketexception') || true == inner.contains('network')) {
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
      // Prioritize 'message' key, then 'error', then 'detail', 'title', 'code' from the map
      final Object? raw_message = data['message'] ?? data['error'] ?? data['detail'] ?? data['title'] ?? data['code'];
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
// End of error_handler.dart

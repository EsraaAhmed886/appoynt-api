/*
 * File Name: auth_interceptor.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V3.2.0
 * Dependencies: package:dio/dio.dart, token_storage.dart, error_handler.dart,
 *   failures.dart, session_manager.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 31/08/2026]
 * File Description: Network interceptor to append authorization token headers,
 *   map all HTTP/DioExceptions through ErrorHandler to typed Failure objects,
 *   and delegate session expiry handling to SessionManager on HTTP 401 or error_session_expired.
 *   SessionManager owns the navigator key and orchestrates the full logout flow.
 */

// Importing async library for StreamController broadcast support
import 'dart:async';
// Importing token secure storage layer for reading access tokens on request
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
// Importing error handler for centralized exception-to-Failure mapping
import 'package:appoynt_mobile_app/core/error/error_handler.dart';
// Importing failure hierarchy for typed 401 UnauthorizedFailure detection
import 'package:appoynt_mobile_app/core/error/failures.dart';
// Importing SessionManager to delegate the full 401 logout orchestration
import 'package:appoynt_mobile_app/core/services/session_manager.dart';
// Importing Dio networking package for request/response/error hook types
import 'package:dio/dio.dart';
// Importing Flutter foundation for debugPrint diagnostics
import 'package:flutter/foundation.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SESSION EXPIRY BROADCAST STREAM (kept for any external observers)
// ─────────────────────────────────────────────────────────────────────────────

// Private broadcast stream controller emitting void events on each 401 event
final StreamController<void> _session_expired_ctrl =
    StreamController<void>.broadcast();

// Global stream broadcasting session expiry events to any external listeners
final Stream<void> session_expired_stream = _session_expired_ctrl.stream;

// Internal helper that safely emits a session expiry event on the stream
void _emit_session_expired() {
  // Guard against emitting on a closed or inactive stream controller
  if (!_session_expired_ctrl.isClosed) {
    // Emit a void event signalling session expiry to any active stream listeners
    _session_expired_ctrl.add(null);
  } else {
    // Controller is closed — skip the event emission silently
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AUTH INTERCEPTOR
// ─────────────────────────────────────────────────────────────────────────────

// Interceptor to inject Bearer tokens and route all HTTP errors through handlers
class AuthInterceptor extends Interceptor {
  // Override the request phase to inject the Authorization bearer token header
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Retrieve the secure access token from encrypted local storage
    final String? token = await TokenStorage.get_access_token();
    // Inject Authorization header only when a valid non-empty token exists
    if (null != token && token.isNotEmpty) {
      // Attach the standard Bearer token authorization header to the request
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      // Proceed without an authorization header for unauthenticated endpoints
    }
    // Forward the modified request options to the next interceptor in the chain
    return super.onRequest(options, handler);
  }

  // Override the error phase to map all DioExceptions through ErrorHandler
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // Map the raw DioException to a structured typed ApiFailure instance
    final ApiFailure api_failure = ErrorHandler.handle(err);

    final bool is_401 = 401 == err.response?.statusCode;
    final bool is_session_expired_data = err.response?.data is Map &&
        (('error_session_expired' == err.response?.data['code']) ||
         ('session_expired' == err.response?.data['code']) ||
         ('error_session_expired' == err.response?.data['message']) ||
         ('session_expired' == err.response?.data['message']));

    // Check if the resolved failure type represents an HTTP 401 session expiry or error_session_expired payload
    if (api_failure.failure is UnauthorizedFailure || is_401 || is_session_expired_data) {
      // Log the 401 detection for debugging and audit trail purposes
      debugPrint(
        '[AuthInterceptor] Session expiry (401/error_session_expired) detected — '
        'delegating to SessionManager for full logout flow.',
      );

      // Broadcast the session expiry event for any passive stream observers
      _emit_session_expired();

      // Resolve human-readable localized session expired string
      final String localized_msg = ErrorHandler.mapBackendErrorKey('error_session_expired');

      // Delegate the full logout orchestration to the SessionManager singleton.
      // SessionManager will: purge tokens, emit AuthUnauthenticated via AuthCubit,
      // push LoginPage (clearing the back stack), and show the session SnackBar.
      unawaited(
        SessionManager.instance.handle_session_expired(
          // Pass the translated user-facing message string
          localized_message: localized_msg,
        ),
      );

      // Return without forwarding the error — the 401 has been fully handled
      // so downstream callers do not receive a generic network error state.
      handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          // Use 200 as a sentinel status to signal that the error was absorbed
          statusCode: 200,
          // Attach handled flag so callers can distinguish absorbed responses
          data: {'handled': true, 'reason': 'session_expired'},
        ),
      );
      // Exit early — do not call super.onError or handler.next
      return;
    } else {
      // Non-401 failure — no session state mutation or stream broadcast needed
    }

    // Log detailed backend validation error payload if status is 400 Bad Request
    if (400 == err.response?.statusCode && err.response?.data is Map) {
      final Map<dynamic, dynamic> rawData = err.response!.data as Map;
      if (rawData.containsKey('errors')) {
        debugPrint('🚨 [Backend Validation Errors]: ${rawData['errors']}');
      } else {
        // No action needed
      }
      debugPrint('🚨 [Backend 400 Response Body]: ${err.response?.data}');
    } else {
      // No action needed
    }

    // Log all non-401 failure events with their typed localization key details
    debugPrint(
      '[AuthInterceptor] API Failure mapped: '
      '${api_failure.failure.runtimeType} — '
      'key: ${api_failure.failure.message_key} — '
      'server_msg: ${api_failure.server_message}',
    );

    // Forward the original DioException so downstream callers can handle it
    return super.onError(err, handler);
  }
}


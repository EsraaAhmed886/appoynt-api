/*
 * File Name: dio_factory.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:dio/dio.dart, package:flutter/foundation.dart, api_constants.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 31/08/2026]
 * File Description: A factory class that configures and provides a singleton instance of the Dio client
 *   with safe FormData handling in logging interceptors to avoid ANR freezes.
 */

import 'package:appoynt_mobile_app/core/api/api_constants.dart'; // Centralized API constants
import 'package:appoynt_mobile_app/core/api/auth_interceptor.dart'; // Token authorization interceptor
import 'package:dio/dio.dart'; // Core networking package
import 'package:flutter/foundation.dart'; // For debugPrint

/// Custom safe logging interceptor preventing FormData stream consumption / deadlock
class SafeLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('--> [DioRequest] ${options.method} ${options.uri}');
    if (options.data is FormData) {
      final FormData formData = options.data as FormData;
      debugPrint(
        '--> [DioRequest] Sending FormData with ${formData.files.length} files and ${formData.fields.length} fields',
      );
    } else if (null != options.data) {
      debugPrint('--> [DioRequest] Data: ${options.data}');
    } else {
      // No data payload
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('<-- [DioResponse] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('<-- [DioError] ${err.response?.statusCode} ${err.requestOptions.uri} - ${err.message}');
    if (null != err.response?.data) {
      debugPrint('<-- [DioError Body] ${err.response?.data}');
      if (err.response?.data is Map &&
          (err.response!.data as Map).containsKey('errors')) {
        debugPrint(
            '🚨 [Backend Validation Errors]: ${(err.response!.data as Map)['errors']}');
      } else {
        // No action needed
      }
    } else {
      // No action needed
    }
    handler.next(err);
  }
}

/// A factory responsible for creating and configuring the Dio instance.
class DioFactory {
  /// Private constructor to prevent instantiation.
  DioFactory._();

  /// Cached Dio instance.
  static Dio? _dio;

  /// Retrieves the pre-configured Dio singleton instance.
  static Dio get_dio() {
    /// Defining the standard timeout duration for network requests.
    const Duration timeout = Duration(seconds: 45);

    if (null == _dio) {
      /// Log that the networking layer is being initialized.
      debugPrint('--- [DioFactory] Initializing Dio Networking Layer ---');

      /// Initializing Dio with base options.
      _dio = Dio();
      
      _dio!
        ..options.baseUrl = ApiConstants.base_url // Applying base URL
        ..options.connectTimeout = timeout // Connection timeout
        ..options.receiveTimeout = timeout // Response receiving timeout
        ..options.sendTimeout = timeout // Send timeout
        ..options.headers = {
          'Accept': ApiConstants.accept,
        };

      /// Adding interceptors for debugging and safe logging.
      _dio!.interceptors.addAll([
        AuthInterceptor(),
        SafeLoggingInterceptor(),
      ]);
    } else {
      // Do nothing since Dio instance is already initialized
    }
    return _dio!;
  }
}

/*
 * File Name: auth_interceptor.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:dio/dio.dart, token_storage.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: Network interceptor to append authorization token headers and handle 401 unauthenticated errors.
 */

import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
import 'package:dio/dio.dart';

/// Interceptor to automatically add Bearer tokens and handle 401 status failures.
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Retrieve secure access token
    final String? token = await TokenStorage.get_access_token();
    if (null != token && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      // Keep headers as they are
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (401 == err.response?.statusCode) {
      // Clear secure tokens upon receiving 401 unauthenticated response
      await TokenStorage.clear_access_token();
      // Handle logging/notifications or redirection if required globally
    } else {
      // Leave error as is
    }
    return super.onError(err, handler);
  }
}

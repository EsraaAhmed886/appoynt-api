/*
 * File Name: dio_factory.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:dio/dio.dart, package:flutter/foundation.dart, api_constants.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: A factory class that configures and provides a singleton instance of the Dio client.
 */

import 'package:appoynt_mobile_app/core/api/api_constants.dart'; // Centralized API constants
import 'package:dio/dio.dart'; // Core networking package
import 'package:flutter/foundation.dart'; // For debugPrint

/// A factory responsible for creating and configuring the Dio instance.
class DioFactory {
  /// Private constructor to prevent instantiation.
  DioFactory._();

  /// Cached Dio instance.
  static Dio? _dio;

  /// Retrieves the pre-configured Dio singleton instance.
  static Dio get_dio() {
    /// Defining the standard timeout duration for network requests.
    const Duration timeout = Duration(seconds: 30);

    if (null == _dio) {
      /// Log that the networking layer is being initialized.
      debugPrint('--- [DioFactory] Initializing Dio Networking Layer ---');

      /// Initializing Dio with base options.
      _dio = Dio();
      
      _dio!
        ..options.baseUrl = ApiConstants.base_url // Applying base URL
        ..options.connectTimeout = timeout // Connection timeout
        ..options.receiveTimeout = timeout // Response receiving timeout
        ..options.headers = {
          'Content-Type': ApiConstants.content_type,
          'Accept': ApiConstants.accept,
        };

      /// Adding interceptors for debugging and logging.
      /// We explicitly use debugPrint to ensure logs show up in the IDE console.
      _dio!.interceptors.add(
        LogInterceptor(
          requestBody: true, // Log the JSON body being sent
          responseBody: true, // Log the JSON response received
          requestHeader: true, // Log the headers
          logPrint: (object) {
            debugPrint(object.toString()); // Force use of debugPrint
          },
        ),
      );
    } else {
      // Do nothing since Dio instance is already initialized
    }
    return _dio!;
  }
}

/*
 * File Name: api_constants.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: None (Pure Dart constant definitions)
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Centralized repository for all API-related constants,
 *   including the base URL, endpoints, and standard headers.
 */

/// A class that holds all application-wide API configuration constants.
class ApiConstants {
  /// Private constructor to prevent instantiation.
  ApiConstants._();

  /// The root URL of the backend API.
  static const String base_url = 'http://appoynt.runasp.net/api/';

  // ── Authentication Endpoints ──────────────────────────

  /// Endpoint for user authentication (Login).
  static const String login = 'auth/login';

  /// Endpoint for new user registration (Sign Up).
  static const String register = 'auth/register';

  /// Endpoint for requesting a password reset code.
  static const String forgot_password = 'auth/forgot-password';

  /// Endpoint for verifying the OTP code.
  static const String verify_otp = 'auth/otp/verify';

  /// Endpoint for resending the OTP code.
  static const String resend_otp = 'auth/otp/resend';

  /// Endpoint for setting a new password.
  static const String reset_password = 'auth/reset-password';

  // ── Profile Endpoints (Verified in Swagger) ───────────

  /// Endpoint for patient profile details (GET & PUT /api/patients/profile).
  static const String patient_profile = 'patients/profile';

  /// Exact ASP.NET Core Swagger endpoint for patient profile photo (POST & DELETE /api/patients/profile-photo).
  static const String patient_profile_photo = 'patients/profile-photo';

  // ── Headers ───────────────────────────────────────────

  /// Standard content type header for JSON requests.
  static const String content_type = 'application/json';

  /// Standard accept header for JSON responses.
  static const String accept = 'application/json';
}

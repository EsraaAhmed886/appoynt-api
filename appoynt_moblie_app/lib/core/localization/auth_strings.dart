/*
 * File Name: auth_strings.dart
 * Author: Kholoud Khaled
 * Date of Creation: 26/08/2026
 * Version Information: v1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Centralized dictionary and error code translation mapper for mobile authentication and registration security workflows.
 */

// Class providing localized values and backend error code mappings for authentication
class AuthLocalization {
  // Static map containing localized key-value pairs for English and Arabic locales
  static const Map<String, Map<String, String>> localizedValues = {
    'en': {
      'auth.registration.email.already_registered':
          'This email address is already registered. Please log in or use a different email.',
      'auth.registration.phone.already_registered':
          'This phone number is already registered. Please log in or use a different number.',
      'auth.registration.password.invalid_characters':
          'Password contains invalid characters. Please use only letters, numbers, and standard symbols (@, #, \$, %, etc.).',
      'auth.registration.password.contains_user_info':
          'Password must not contain your name, email, or personal details.',
      'auth.otp.attempts_exceeded':
          'You have exceeded the maximum number of verification attempts. Please request a new code and try again.',
      'auth.forgot_password.generic_success':
          'If this phone number is registered, a verification code has been sent.',
      'auth.generic_error':
          'An error occurred during authentication, please verify your details.',
    },
    'ar': {
      'auth.registration.email.already_registered':
          'البريد الإلكتروني مسجل بالفعل. يرجى تسجيل الدخول أو استخدام بريد آخر.',
      'auth.registration.phone.already_registered':
          'رقم الهاتف مسجل بالفعل. يرجى تسجيل الدخول أو استخدام رقم هاتف آخر.',
      'auth.registration.password.invalid_characters':
          'كلمة المرور تحتوي على رموز غير مسموحة. يرجى استخدام الحروف والأرقام والرموز المعتمدة فقط.',
      'auth.registration.password.contains_user_info':
          'يجب ألا تحتوي كلمة المرور على اسمك أو بريدك الإلكتروني أو بياناتك الشخصية.',
      'auth.otp.attempts_exceeded':
          'لقد تجاوزت الحد الأقصى للمحاولات. يرجى طلب رمز تحقق جديد والمحاولة مرة أخرى.',
      'auth.forgot_password.generic_success':
          'إذا كان رقم الهاتف مسجلاً لدينا، فسيتم إرسال رمز التحقق إليه.',
      'auth.generic_error':
          'حدث خطأ في تسجيل الدخول، يرجى التأكد من البيانات',
    },
  };

  // Maps backend error codes to human-readable localized error messages
  static String mapBackendError(String errorCode, String languageCode) {
    // Resolve language dictionary fallback to English if unsupported
    final Map<String, String> lang =
        localizedValues[languageCode] ?? localizedValues['en']!;
    // Return matching mapped string or generic error or raw code
    return lang[errorCode] ?? lang['auth.generic_error'] ?? errorCode;
  }
}

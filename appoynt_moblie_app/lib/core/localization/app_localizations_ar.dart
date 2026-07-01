/*
 * File Name: app_localizations_ar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: 1.0.0
 * Dependencies:
 *   - package:flutter/material.dart
 *   - package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description: Arabic concrete implementation of localizations containing only onboarding strings.
 */

// Importing standard material framework libraries
import 'package:flutter/material.dart';
// Importing abstract base localization class definition
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

// Arabic translations class extending the base localizations
class AppLocalizationsAr extends AppLocalizations {
  // Constructor passing the Arabic language locale context to parent
  AppLocalizationsAr() : super(const Locale('ar'));

  // Override getter returning Arabic label for skip action
  @override
  String get skip {
    // Return Arabic translation for skip text
    return 'تخطي';
  }

  // Override getter returning Arabic label for next action
  @override
  String get next {
    // Return Arabic translation for next text
    return 'التالي';
  }

  // Override getter returning Arabic label for final onboarding action
  @override
  String get get_started {
    // Return Arabic translation for get started text
    return 'ابدأ الآن';
  }

  // Override getter returning Arabic onboarding titles prefix list
  @override
  List<String> get onboarding_titles_prefix {
    // Return list of Arabic prefixes mapped to onboarding steps
    return const [
      'احجز بـ', // Page 1 prefix text in Arabic
      'ابقَ على ', // Page 2 prefix text in Arabic
      'صحتك، ', // Page 3 prefix text in Arabic
    ];
  }

  // Override getter returning Arabic onboarding titles accent words list
  @override
  List<String> get onboarding_titles_accent {
    // Return list of Arabic accented keywords mapped to onboarding steps
    return const [
      ' ثقة ', // Page 1 accent keyword in Arabic
      'اطلاع', // Page 2 accent keyword in Arabic
      'محمية', // Page 3 accent keyword in Arabic
    ];
  }

  // Override getter returning Arabic onboarding descriptive subtitles list
  @override
  List<String> get onboarding_subtitles {
    // Return list of Arabic paragraphs explaining app value propositions
    return const [
      'ابحث عن رعاية صحية موثوقة واحجز موعدك في بضع نقرات فقط.', // Page 1 description text in Arabic
      'تابع دورك في الوقت الفعلي واحصل على تحديثات حتى تعرف دائماً متى يحين دورك.', // Page 2 description text in Arabic
      'جميع سجلاتك ومدفوعاتك وتذكيراتك — كلها في مكان آمن واحد.', // Page 3 description text in Arabic
    ];
  }

  // Override getter returning English language code label
  @override
  String get language_code_en {
    // Return standard uppercase language code
    return 'EN';
  }

  // Override getter returning English language full name label
  @override
  String get language_name_en {
    // Return standard English name
    return 'English';
  }

  // Override getter returning Arabic language code label
  @override
  String get language_code_ar {
    // Return standard uppercase language code
    return 'AR';
  }

  // Override getter returning Arabic language full name label
  @override
  String get language_name_ar {
    // Return Arabic native spelling representation
    return 'العربية';
  }

  // Override getter returning rules header text for passwords
  @override
  String get password_must {
    // Return rule requirement prefix message
    return 'يجب أن تحتوي كلمة المرور على:';
  }

  // Override getter returning password strength indicator label
  @override
  String get password_strength {
    // Return label for password validation strength indicator
    return 'قوة كلمة المرور';
  }

  // Override getter returning weak strength status string representation
  @override
  String get strength_weak {
    // Return Arabic word for weak security level
    return 'ضعيفة';
  }

  // Override getter returning medium strength status string representation
  @override
  String get strength_medium {
    // Return Arabic word for medium security level
    return 'متوسطة';
  }

  // Override getter returning strong strength status string representation
  @override
  String get strength_strong {
    // Return Arabic word for strong security level
    return 'قوية';
  }

  // Override getter returning too short error validation text
  @override
  String get too_short {
    // Return Arabic warning word for short character length
    return 'قصيرة جداً';
  }

  // Override getter returning minimum character length password rule label
  @override
  String get password_rule_min_length {
    // Return Arabic rule description
    return '8 أحرف على الأقل';
  }

  // Override getter returning uppercase character password rule label
  @override
  String get password_rule_uppercase {
    // Return Arabic rule description
    return 'حرف كبير واحد على الأقل (A-Z)';
  }

  // Override getter returning lowercase character password rule label
  @override
  String get password_rule_lowercase {
    // Return Arabic rule description
    return 'حرف صغير واحد على الأقل (a-z)';
  }

  // Override getter returning digit number password rule label
  @override
  String get password_rule_number {
    // Return Arabic rule description
    return 'رقم واحد على الأقل (0-9)';
  }

  // Override getter returning special character password rule label
  @override
  String get password_rule_special {
    // Return Arabic rule description
    return 'رمز خاص واحد على الأقل (!@#\$&*~%)';
  }

  // Override getter prohibiting Arabic characters password rule label
  @override
  String get password_rule_no_arabic {
    // Return Arabic rule description
    return 'لا تحتوي على أحرف عربية';
  }

  // Override getter returning welcome back greeting message
  @override
  String get welcome_back {
    // Return Arabic welcome back title
    return 'مرحباً بعودتك';
  }

  // Override getter returning helper text for credential login input
  @override
  String get login_subtitle {
    // Return Arabic description helper text
    return 'أدخل بيانات الاعتماد الخاصة بك للوصول إلى حسابك';
  }

  // Override getter returning combined email or phone input field label
  @override
  String get email_or_phone {
    // Return Arabic identifier placeholder label
    return 'البريد الإلكتروني أو رقم الهاتف';
  }

  // Override getter returning hint helper text inside identifier field
  @override
  String get enter_email_or_phone {
    // Return Arabic prompt description hint text
    return 'أدخل بريدك الإلكتروني أو رقمك';
  }

  // Override getter returning standard label for email inputs
  @override
  String get email {
    // Return Arabic email label
    return 'البريد الإلكتروني';
  }

  // Override getter returning standard label for phone inputs
  @override
  String get phone {
    // Return Arabic phone label
    return 'رقم الهاتف';
  }

  // Override getter returning standard label for password inputs
  @override
  String get password {
    // Return Arabic password label
    return 'كلمة المرور';
  }

  // Override getter returning label for forgot password anchor link
  @override
  String get forgot_password {
    // Return Arabic question label text
    return 'نسيت كلمة المرور؟';
  }

  // Override getter returning standard login action button text
  @override
  String get login {
    // Return Arabic word for signing in
    return 'تسجيل الدخول';
  }

  // Override getter returning question prompt for new users
  @override
  String get no_account {
    // Return Arabic prompt label
    return 'ليس لديك حساب؟';
  }

  // Override getter returning link button text navigating to register page
  @override
  String get sign_up {
    // Return Arabic word for registration actions
    return 'إنشاء حساب';
  }

  // Override getter returning error description on blank inputs
  @override
  String get field_required {
    // Return Arabic field requirement warning
    return 'هذا الحقل مطلوب';
  }

  // Override getter returning format validation error message for emails
  @override
  String get invalid_email {
    // Return Arabic email validation failure warning
    return 'يرجى إدخال بريد إلكتروني صحيح';
  }

  // Override getter returning format validation error message for phone inputs
  @override
  String get invalid_phone {
    // Return Arabic phone number validation failure warning
    return 'يرجى إدخال رقم هاتف صحيح';
  }

  // Override getter returning title label for registration gateway
  @override
  String get register_title {
    // Return Arabic title
    return 'إنشاء حساب جديد';
  }

  // Override getter returning subtitle details for registration gateway
  @override
  String get register_subtitle {
    // Return Arabic description helper text
    return 'قم بتعبئة بياناتك للبدء';
  }

  // Override getter returning label for first name inputs
  @override
  String get first_name_label {
    // Return Arabic first name input label
    return 'الأسم الأول';
  }

  // Override getter returning hint for first name inputs
  @override
  String get first_name_hint {
    // Return Arabic first name hint
    return 'الأسم الأول';
  }

  // Override getter returning label for last name inputs
  @override
  String get last_name_label {
    // Return Arabic last name input label
    return 'الأسم الثاني';
  }

  // Override getter returning hint for last name inputs
  @override
  String get last_name_hint {
    // Return Arabic last name hint
    return 'الأسم الثاني';
  }

  // Override getter returning hint helper text for email inputs
  @override
  String get email_hint {
    // Return Arabic email format sample hint
    return 'example@email.com';
  }

  // Override getter returning hint helper text for phone inputs
  @override
  String get phone_hint {
    // Return Arabic phone pattern sample hint
    return '01xxxxxxxxx';
  }

  // Override getter returning hint helper text for password inputs
  @override
  String get password_hint {
    // Return Arabic password strength guidance hint
    return 'أدخل كلمة مرور قوية';
  }

  // Override getter returning label for confirmation password inputs
  @override
  String get confirm_password {
    // Return Arabic confirm password input label
    return 'تأكيد كلمة المرور';
  }

  // Override getter returning hint helper text for confirmation password inputs
  @override
  String get confirm_password_hint {
    // Return Arabic confirm password hint
    return 'أعد إدخال كلمة المرور';
  }

  // Override getter returning agreement prefix label for terms acceptance checkbox
  @override
  String get agree_to_terms {
    // Return Arabic agreement prefix sentence
    return 'أوافق على ';
  }

  // Override getter returning clickable link text for terms of service documentation
  @override
  String get terms_and_conditions {
    // Return Arabic terms link label
    return 'الشروط والأحكام';
  }

  // Override getter returning simple connector word for grammatical listings
  @override
  String get and_connector {
    // Return Arabic connector string
    return ' و ';
  }

  // Override getter returning clickable link text for privacy policy documentation
  @override
  String get privacy_policy {
    // Return Arabic privacy link label
    return 'سياسة الخصوصية';
  }

  // Override getter returning footer question prompt for registered users
  @override
  String get have_account {
    // Return Arabic question sentence
    return 'لديك حساب بالفعل؟';
  }

  // Override getter returning sign in link text for existing accounts
  @override
  String get sign_in {
    // Return Arabic sign in action word
    return 'تسجيل الدخول';
  }

  // Override getter returning action button label for registration execution
  @override
  String get create_my_account {
    // Return Arabic account creation button text
    return 'إنشاء حسابي';
  }

  // Override getter returning validation alert message for unselected terms checkbox
  @override
  String get terms_must_agree {
    // Return Arabic warning alert text
    return 'يجب الموافقة على الشروط';
  }

  // Override getter returning validation alert message for exceeded phone digits limit
  @override
  String get phone_max_error {
    // Return Arabic digit restriction warning text
    return 'رقم الهاتف لا يتجاوز 11 رقماً';
  }

  // Override getter returning validation alert message for mismatched password inputs
  @override
  String get password_mismatch {
    // Return Arabic credentials mismatch warning text
    return 'كلمات المرور غير متطابقة';
  }
}

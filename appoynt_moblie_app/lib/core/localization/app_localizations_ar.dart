/*
 * File Name: app_localizations_ar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Arabic concrete implementation of localizations
 *   containing onboarding and authentication strings.
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
      // Page 1 description text in Arabic
      'ابحث عن رعاية صحية موثوقة واحجز موعدك في بضع نقرات فقط.',
      // Page 2 description text in Arabic
      'تابع دورك في الوقت الفعلي واحصل على تحديثات حتى تعرف دائماً متى يحين دورك.',
      // Page 3 description text in Arabic
      'جميع سجلاتك ومدفوعاتك وتذكيراتك — كلها في مكان آمن واحد.',
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
    return 'أدخل البريد الإلكترونى أو رقم الهاتف';
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

  // Override getter returning name length validation error message
  @override
  String get name_length_error {
    // Return Arabic name length bounds validation warning
    return 'يجب أن يكون الاسم بين 3 و 50 حرفاً';
  }

  // Override getter returning name characters validation error message
  @override
  String get name_letters_only_error {
    // Return Arabic name letters only validation warning
    return 'يجب أن يحتوي الاسم على أحرف فقط';
  }

  // Override getter returning phone length validation error message
  @override
  String get phone_must_be_11_digits {
    // Return Arabic phone digits count warning
    return 'يجب أن يكون رقم الهاتف مكوناً من 11 رقماً بالضبط';
  }

  // Override getter returning phone start validation error message
  @override
  String get phone_must_start_01 {
    // Return Arabic phone prefix warning
    return 'يجب أن يبدأ رقم الهاتف بـ 01';
  }

  // Override getter returning phone operator validation error message
  @override
  String get phone_invalid_operator {
    // Return Arabic phone operator type warning
    return 'يجب أن يبدأ رقم الهاتف بـ 010 أو 011 أو 012 أو 015';
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
    // Return Arabic password placeholder hint
    return 'كلمة المرور';
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
    return 'تأكيد كلمة المرور';
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

  // Override getter returning verification screen title
  @override
  String get enter_your_code {
    // Return Arabic verification title
    return 'أدخل رمز التحقق';
  }

  // Override getter returning verification screen description subtitle
  @override
  String get enter_otp_subtitle {
    // Return Arabic description helper text
    return 'لقد أرسلنا رمزاً مكوناً من 6 أرقام إلى رقم هاتفك';
  }

  // Override getter returning resending countdown trigger link label
  @override
  String get send_code_again {
    // Return Arabic resending code label
    return 'إعادة إرسال الرمز';
  }

  // Override getter returning sent code description information card text
  @override
  String get sent_code_info {
    // Return Arabic information card text
    return 'لقد أرسلنا رمز التحقق إلى رقم هاتفك. يرجى إدخاله للتحقق من حسابك.';
  }

  // Override getter returning OTP verification action button label
  @override
  String get verify {
    // Return Arabic verification action label
    return 'تحقق';
  }

  // Override getter returning forgot password screen title
  @override
  String get forgot_password_title {
    // Return Arabic forgot password title
    return 'هل نسيت كلمة المرور؟';
  }

  // Override getter returning forgot password screen descriptive instructions subtitle
  @override
  String get forgot_password_subtitle {
    // Return Arabic forgot password subtitle instructions
    return 'أدخل رقم هاتفك لتلقي رمز التحقق';
  }

  // Override getter returning forgot password trigger button label text
  @override
  String get send_code {
    // Return Arabic send code label
    return 'إرسال الرمز';
  }

  // Override getter returning reset password confirmation button label
  @override
  String get update_password {
    // Return Arabic update password text
    return 'تحديث كلمة المرور';
  }

  // Override getter returning reset password screen title
  @override
  String get create_new_password {
    // Return Arabic create new password title
    return 'إنشاء كلمة مرور جديدة';
  }

  // Override getter returning reset password screen description subtitle
  @override
  String get reset_password_subtitle {
    // Return Arabic reset password subtitle instruction
    return 'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمات المرور السابقة';
  }

  // Override getter returning reset password input field label
  @override
  String get new_password_label {
    // Return Arabic new password label
    return 'كلمة المرور الجديدة';
  }

  // Override getter returning reset password input placeholder hint
  @override
  String get new_password_hint {
    // Return Arabic new password hint
    return 'كلمة المرور';
  }

  // Override getter returning account created success screen title
  @override
  String get account_created_success {
    // Return Arabic account success title
    return 'تم إنشاء الحساب بنجاح!';
  }

  // Override getter returning welcome greeting message
  @override
  String get welcome_to_appoynt {
    // Return Arabic welcome description
    return 'مرحباً بك في أبوانت';
  }

  // Override getter returning automatic redirect loader label
  @override
  String get redirecting_automatically {
    // Return Arabic redirecting description
    return 'جاري إعادة التوجيه تلقائياً...';
  }

  // Override parameterized method for home redirection timer description text
  @override
  String going_to_home_in(int seconds) {
    // Return Arabic going to home string dynamically
    return 'الانتقال إلى الصفحة الرئيسية خلال $seconds ثوانٍ...';
  }

  // Override getter returning skip manual button label
  @override
  String get go_to_home {
    // Return Arabic go to home label
    return 'الذهاب إلى الرئيسية';
  }

  // Override getter returning password reset successfully screen title
  @override
  String get password_reset_success_title {
    // Return Arabic password reset success title
    return 'تمت إعادة تعيين كلمة المرور بنجاح';
  }

  // Override getter returning password reset successfully screen description
  @override
  String get password_reset_success_body {
    // Return Arabic password reset success description
    return 'تم تحديث كلمة مرورك بنجاح. يمكنك الآن تسجيل الدخول\nباستخدام كلمة مرورك الجديدة.';
  }

  // Override getter returning redirecting to login page button label
  @override
  String get go_to_login {
    // Return Arabic go to login button label
    return 'الذهاب إلى تسجيل الدخول';
  }

  // Override getter returning no internet error screen title
  @override
  String get no_internet_title {
    // Return Arabic no internet title
    return 'لا يوجد اتصال بالإنترنت';
  }

  // Override getter returning no internet screen instructions subtitle
  @override
  String get no_internet_sub {
    // Return Arabic no internet instructions subtitle
    return 'يرجى التحقق من إعدادات الشبكة والمحاولة مرة أخرى';
  }

  // Override getter returning retry reconnection trigger button label
  @override
  String get retry {
    // Return Arabic retry label
    return 'إعادة المحاولة';
  }

  // Override getter returning password maximum length validation warning
  @override
  String get password_too_long {
    // Return Arabic password too long warning
    return 'يجب ألا تزيد كلمة المرور عن 30 حرفًا';
  }
}

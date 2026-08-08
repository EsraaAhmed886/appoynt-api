/*
 * File Name: app_localizations_ar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
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

  // TODO: START OF DUMMY HOME SCREEN LOCALIZATION OVERRIDES - REMOVE ONCE FINAL HOME IS COMPLETED
  // Override getter returning bottom navigation home label in Arabic
  @override
  String get dummy_home_tab_label {
    // Return Arabic bottom navigation home tab label
    return 'الرئيسية';
  }

  // Override getter returning bottom navigation appointments label in Arabic
  @override
  String get dummy_appointments_tab_label {
    // Return Arabic bottom navigation appointments tab label
    return 'المواعيد';
  }

  // Override getter returning bottom navigation search label in Arabic
  @override
  String get dummy_search_tab_label {
    // Return Arabic bottom navigation search tab label
    return 'البحث';
  }

  // Override getter returning bottom navigation favorites label in Arabic
  @override
  String get dummy_favorite_tab_label {
    // Return Arabic bottom navigation favorites label in Arabic
    return 'المفضلة';
  }

  // Override getter returning bottom navigation queue label in Arabic
  @override
  String get dummy_queue_tab_label {
    // Return Arabic bottom navigation queue tab label
    return 'الطابور';
  }

  // Override getter returning bottom navigation records label in Arabic
  @override
  String get dummy_records_tab_label {
    // Return Arabic bottom navigation records tab label
    return 'السجلات';
  }

  // Override getter returning bottom navigation profile label in Arabic
  @override
  String get dummy_profile_tab_label {
    // Return Arabic bottom navigation profile tab label
    return 'الحساب';
  }

  // Override getter returning greeting time welcome text in Arabic
  @override
  String get dummy_good_morning {
    // Return Arabic greeting time welcome text
    return 'صباح الخير 👋';
  }

  // Override getter returning welcome banner subtitle text in Arabic
  @override
  String get dummy_welcome_to_appoynt_home {
    // Return Arabic welcome banner subtitle text
    return 'مرحباً بك في أبوانت';
  }

  // Override getter returning search field placeholder hint text in Arabic
  @override
  String get dummy_search_hint {
    // Return Arabic search field placeholder hint text
    return 'ابحث عن الأطباء، التخصصات...';
  }

  // Override getter returning book appointment action button label in Arabic
  @override
  String get dummy_book_appointment {
    // Return Arabic book appointment action button label
    return 'حجز\nموعد';
  }

  // Override getter returning queue status action button label in Arabic
  @override
  String get dummy_my_queue {
    // Return Arabic queue status action button label
    return 'طابوري';
  }

  // Override getter returning video call action button label in Arabic
  @override
  String get dummy_video_consult {
    // Return Arabic video call action button label
    return 'استشارة\nمرئية';
  }

  // Override getter returning medical records action button label in Arabic
  @override
  String get dummy_my_records {
    // Return Arabic medical records action button label
    return 'سجلاتي';
  }

  // Override getter returning appointment banner title label in Arabic
  @override
  String get dummy_next_appointment {
    // Return Arabic appointment banner title label
    return 'الموعد القادم';
  }

  // Override getter returning primary physician name in Arabic
  @override
  String get dummy_dr_ahmed_hassan {
    // Return Arabic primary physician name
    return 'د. أحمد حسن';
  }

  // Override getter returning physician specialty and timing details in Arabic
  @override
  String get dummy_general_medicine_today {
    // Return Arabic physician specialty and timing details
    return 'طب عام • اليوم، ٣:٠٠ م';
  }

  // Override getter returning view details navigation button label in Arabic
  @override
  String get dummy_view_details {
    // Return Arabic view details navigation button label
    return 'عرض التفاصيل';
  }

  // Override getter returning specialty categorization header label in Arabic
  @override
  String get dummy_specialties {
    // Return Arabic specialty categorization header label
    return 'التخصصات';
  }

  // Override getter returning view all items navigation link label in Arabic
  @override
  String get dummy_see_all {
    // Return Arabic view all items navigation link label
    return 'عرض الكل';
  }

  // Override getter returning cardiology specialty category name in Arabic
  @override
  String get dummy_cardiology {
    // Return Arabic cardiology specialty category name
    return 'القلب';
  }

  // Override getter returning neurology specialty category name in Arabic
  @override
  String get dummy_neurology {
    // Return Arabic neurology specialty category name
    return 'الأعصاب';
  }

  // Override getter returning pediatrics specialty category name in Arabic
  @override
  String get dummy_pediatrics {
    // Return Arabic pediatrics specialty category name
    return 'الأطفال';
  }

  // Override getter returning ophthalmology specialty category name in Arabic
  @override
  String get dummy_eye_care {
    // Return Arabic ophthalmology specialty category name
    return 'العيون';
  }

  // Override getter returning orthopedic specialty category name in Arabic
  @override
  String get dummy_orthopedic {
    // Return Arabic orthopedic specialty category name
    return 'العظام';
  }

  // Override getter returning featured physicians header label in Arabic
  @override
  String get dummy_top_doctors {
    // Return Arabic featured physicians header label
    return 'أبرز الأطباء';
  }

  // Override getter returning cardiologist practitioner name in Arabic
  @override
  String get dummy_dr_sarah_johnson {
    // Return Arabic cardiologist practitioner name
    return 'د. سارة جونسون';
  }

  // Override getter returning cardiologist specialty title in Arabic
  @override
  String get dummy_cardiologist {
    // Return Arabic cardiologist specialty title
    return 'طبيبة قلب';
  }

  // Override getter returning cardiology practice length details in Arabic
  @override
  String get dummy_years_experience_sarah {
    // Return Arabic cardiology practice length details
    return '١٢ سنة خبرة';
  }

  // Override getter returning neurologist practitioner name in Arabic
  @override
  String get dummy_dr_mohammed_ali {
    // Return Arabic neurologist practitioner name
    return 'د. محمد علي';
  }

  // Override getter returning neurologist specialty title in Arabic
  @override
  String get dummy_neurologist {
    // Return Arabic neurologist specialty title
    return 'طبيب أعصاب';
  }

  // Override getter returning neurology practice length details in Arabic
  @override
  String get dummy_years_experience_mohammed {
    // Return Arabic neurology practice length details
    return '٩ سنوات خبرة';
  }

  // Override getter returning pediatrician practitioner name in Arabic
  @override
  String get dummy_dr_fatima_ahmed {
    // Return Arabic pediatrician practitioner name
    return 'د. فاطمة أحمد';
  }

  // Override getter returning pediatrician specialty title in Arabic
  @override
  String get dummy_pediatrician {
    // Return Arabic pediatrician specialty title
    return 'طبيبة أطفال';
  }

  // Override getter returning pediatrics practice length details in Arabic
  @override
  String get dummy_years_experience_fatima {
    // Return Arabic pediatrics practice length details
    return '٧ سنوات خبرة';
  }

  // Override getter returning appointment book action trigger label in Arabic
  @override
  String get dummy_book {
    // Return Arabic appointment book action trigger label
    return 'حجز';
  }

  // Override getter returning feature under construction info label in Arabic
  @override
  String get dummy_coming_soon {
    // Return Arabic feature under construction info label
    return 'قريباً';
  }
  // TODO: END OF DUMMY HOME SCREEN LOCALIZATION OVERRIDES

  // Override getter returning search filter chip location label text in Arabic
  @override
  String get search_location_chip {
    // Return Arabic search location label
    return 'الموقع';
  }

  // Override getter returning search filter chip specialty label text in Arabic
  @override
  String get search_specialty_chip {
    // Return Arabic search specialty label
    return 'التخصص';
  }

  // Override getter returning uppercase recent searches section label title in Arabic
  @override
  String get search_recent_searches_title {
    // Return Arabic recent searches title
    return 'عمليات البحث الأخيرة';
  }

  // Override getter returning recent search history clear list trigger label text in Arabic
  @override
  String get search_clear_action {
    // Return Arabic clear history label
    return 'مسح';
  }

  // Override getter returning recent search history clear confirmation modal warning in Arabic
  @override
  String get search_clear_all_confirm_title {
    // Return Arabic clear confirmation dialog message
    return 'هل تريد مسح سجل البحث بالكامل؟';
  }

  // Override getter returning alert modal cancel action button label in Arabic
  @override
  String get search_cancel_button {
    // Return Arabic cancel button text
    return 'إلغاء';
  }

  // Override getter returning alert modal confirm clear action button label in Arabic
  @override
  String get search_clear_all_button {
    // Return Arabic clear all button text
    return 'مسح الكل';
  }

  // Override getter returning suggestions card list view all results trigger label text in Arabic
  @override
  String get search_view_all_results {
    // Return Arabic view all search results label
    return 'عرض جميع نتائج البحث';
  }

  // Override getter returning filters-only state primary action button label in Arabic
  @override
  String get search_view_all_filtered_results {
    // Return Arabic view all filtered results button text
    return 'عرض جميع النتائج المصفاة';
  }

  // Override getter returning bottom navigation profile tab label in Arabic
  @override
  String get search_tab_profile {
    // Return Arabic profile label
    return 'الحساب';
  }

  // Override getter returning bottom navigation appointment tab label in Arabic
  @override
  String get search_tab_appointment {
    // Return Arabic appointment label
    return 'المواعيد';
  }

  // Override getter returning bottom navigation search tab label in Arabic
  @override
  String get search_tab_search {
    // Return Arabic search label
    return 'البحث';
  }

  // Override getter returning bottom navigation favorites tab label in Arabic
  @override
  String get search_tab_favorites {
    // Return Arabic favorites label
    return 'المفضلة';
  }

  // Override getter returning bottom navigation home tab label in Arabic
  @override
  String get search_tab_home {
    // Return Arabic home label
    return 'الرئيسية';
  }

  // Override getter returning autocomplete empty matching results indicator text label in Arabic
  @override
  String get search_no_results {
    // Return Arabic no results message
    return 'لم يتم العثور على نتائج.';
  }

  // Override getter returning offline network connectivity failure warning details in Arabic
  @override
  String get search_offline_error {
    // Return Arabic offline error message
    return 'فقد الاتصال بالشبكة. يرجى المحاولة مرة أخرى.';
  }

  // Override getter returning offline failure retry action trigger label in Arabic
  @override
  String get search_retry_button {
    // Return Arabic retry button text
    return 'إعادة المحاولة';
  }

  // Override getter returning search screen page title text in Arabic
  @override
  String get search_screen_title {
    // Return Arabic search screen title
    return 'البحث';
  }

  // Override getter returning search screen page subtitle text in Arabic
  @override
  String get search_screen_subtitle {
    // Return Arabic search screen subtitle
    return 'ابحث عن الأطباء والعيادات والتخصصات والمزيد';
  }

  // Override getter returning search screen text field placeholder hint text in Arabic
  @override
  String get search_screen_hint {
    // Return Arabic search screen hint
    return 'ابحث عن طبيب، تخصص، عيادة، مستشفى، مختبر أو صيدلية';
  }

  // Override getter returning search screen location filter default selection value in Arabic
  @override
  String get search_location_default {
    // Return Arabic default location filter
    return 'القاهرة، مصر';
  }

  // Override getter returning search screen specialty filter default selection value in Arabic
  @override
  String get search_specialty_default {
    // Return Arabic default specialty filter
    return 'جميع التخصصات';
  }

  // Override getter returning advanced filters bottom sheet title in Arabic
  @override
  String get search_filter_title {
    return 'الفلاتر المتقدمة';
  }

  // Override getter returning advanced filters gender section title in Arabic
  @override
  String get search_filter_gender_title {
    return 'جنس الطبيب';
  }

  // Override getter returning advanced filters gender Male option in Arabic
  @override
  String get search_filter_gender_male {
    return 'ذكر';
  }

  // Override getter returning advanced filters gender Female option in Arabic
  @override
  String get search_filter_gender_female {
    return 'أنثى';
  }

  // Override getter returning advanced filters price section title in Arabic
  @override
  String get search_filter_price_title {
    return 'سعر الكشف';
  }

  // Override getter returning advanced filters price option: Under 100 EGP in Arabic
  @override
  String get search_filter_price_under_100 {
    return 'أقل من 100 جنيه';
  }

  // Override getter returning advanced filters price option: 100 - 200 EGP in Arabic
  @override
  String get search_filter_price_100_200 {
    return '100 - 200 جنيه';
  }

  // Override getter returning advanced filters price option: 200 - 500 EGP in Arabic
  @override
  String get search_filter_price_200_500 {
    return '200 - 500 جنيه';
  }

  // Override getter returning advanced filters price option: Above 500 EGP in Arabic
  @override
  String get search_filter_price_above_500 {
    return 'أكثر من 500 جنيه';
  }

  // Override getter returning advanced filters rating section title in Arabic
  @override
  String get search_filter_rating_title {
    return 'تقييم الطبيب';
  }

  // Override getter returning advanced filters rating option: 5 Stars in Arabic
  @override
  String get search_filter_rating_5 {
    return '5 نجوم';
  }

  // Override getter returning advanced filters rating option: 4 Stars & Above in Arabic
  @override
  String get search_filter_rating_4 {
    return '4 نجوم وأكثر';
  }

  // Override getter returning advanced filters rating option: 3 Stars & Above in Arabic
  @override
  String get search_filter_rating_3 {
    return '3 نجوم وأكثر';
  }

  // Override getter returning advanced filters reset action button label in Arabic
  @override
  String get search_filter_reset {
    return 'إعادة ضبط';
  }

  // Override getter returning advanced filters apply action button label in Arabic
  @override
  String get search_filter_apply {
    return 'تطبيق الفلاتر';
  }

  // Override getter returning sort bottom sheet title in Arabic
  @override
  String get search_sort_title {
    return 'ترتيب حسب';
  }

  // Override getter returning recently added sort option label in Arabic
  @override
  String get search_sort_recently_added {
    return 'أضيف حديثاً';
  }

  // Override getter returning recently added sort option description in Arabic
  @override
  String get search_sort_recently_added_desc {
    return 'عرض الأطباء الذين تم إضافتهم مؤخراً';
  }

  // Override getter returning name A-Z sort option label in Arabic
  @override
  String get search_sort_name_a_to_z {
    return 'الاسم: من أ إلى ي';
  }

  // Override getter returning name A-Z sort option description in Arabic
  @override
  String get search_sort_name_a_to_z_desc {
    return 'ترتيب الأطباء أبجدياً تصاعدياً';
  }

  // Override getter returning name Z-A sort option label in Arabic
  @override
  String get search_sort_name_z_to_a {
    return 'الاسم: من ي إلى أ';
  }

  // Override getter returning name Z-A sort option description in Arabic
  @override
  String get search_sort_name_z_to_a_desc {
    return 'ترتيب الأطباء أبجدياً تنازلياً';
  }

  // Override getter returning rating high-to-low sort option label in Arabic
  @override
  String get search_sort_rating_high_to_low {
    return 'التقييم: الأعلى أولاً';
  }

  // Override getter returning rating high-to-low sort option description in Arabic
  @override
  String get search_sort_rating_high_to_low_desc {
    return 'ترتيب الأطباء حسب التقييم الأعلى أولاً';
  }

  // Override getter returning fee low-to-high sort option label in Arabic
  @override
  String get search_sort_fee_low_to_high {
    return 'سعر الكشف: الأقل إلى الأعلى';
  }

  // Override getter returning fee low-to-high sort option description in Arabic
  @override
  String get search_sort_fee_low_to_high_desc {
    return 'ترتيب الكشف من الأرخص إلى الأغلى';
  }

  // Override getter returning fee high-to-low sort option label in Arabic
  @override
  String get search_sort_fee_high_to_low {
    return 'سعر الكشف: الأعلى إلى الأقل';
  }

  // Override getter returning fee high-to-low sort option description in Arabic
  @override
  String get search_sort_fee_high_to_low_desc {
    return 'ترتيب الكشف من الأغلى إلى الأرخص';
  }

  // Override getter returning available today status indicator in Arabic
  @override
  String get search_doctor_available_today {
    return 'متاح اليوم';
  }

  // Override getter returning unavailable today status indicator in Arabic
  @override
  String get search_doctor_unavailable_today {
    return 'غير متاح اليوم';
  }

  // Override getter returning booking CTA button label in Arabic
  @override
  String get search_doctor_book_now {
    return 'احجز الآن';
  }

  // Override getter returning doctor reviews label text in Arabic
  @override
  String get search_doctor_reviews {
    return 'تقييم';
  }

  // Patient Profile Localizations Arabic Overrides
  @override
  String get profile_title => 'الملف الشخصي';
  @override
  String get edit_profile_title => 'تعديل الملف الشخصي';
  @override
  String get profile_first_name_label => 'الاسم الأول';
  @override
  String get profile_last_name_label => 'اسم العائلة';
  @override
  String get profile_address_label => 'العنوان';
  @override
  String get profile_change_photo => 'تغيير الصورة';
  @override
  String get profile_personal_information => 'المعلومات الشخصية';
  @override
  String get profile_personal_information_subtitle =>
      'تعديل الاسم والهاتف والبريد الإلكتروني والجنس والطول والوزن';
  @override
  String get profile_medical_history => 'السجل الطبي';
  @override
  String get profile_account_settings => 'إعدادات الحساب';
  @override
  String get profile_height => 'الطول';
  @override
  String get profile_weight => 'الوزن';
  @override
  String get profile_allergies => 'الحساسية';
  @override
  String get profile_medications => 'قائمة الأدوية';
  @override
  String get profile_tests_results => 'التحاليل والأشعة';
  @override
  String get profile_chronic_conditions => 'الأمراض المزمنة';
  @override
  String get profile_insurance_details => 'تفاصيل التأمين';
  @override
  String get profile_no_allergies => 'لم يتم إضافة أي حساسية';
  @override
  String get profile_zero_prescriptions =>
      'لم يتم إضافة أي روشتة. اضغط للإضافة';
  @override
  String get profile_zero_conditions => 'لم يتم إضافة أي أمراض';
  @override
  String get profile_zero_insurance => 'لم يتم إضافة أي بطاقات تأمين';
  @override
  String get profile_update_profile_button => 'تحديث الملف الشخصي';
  @override
  String get profile_save_button => 'حفظ';
  @override
  String get profile_cancel_button => 'إلغاء';
  @override
  String get profile_contact_section => 'معلومات الاتصال';
  @override
  String get profile_more_info_section => 'معلومات إضافية';
  @override
  String get profile_smoking_section => 'التدخين';
  @override
  String get profile_name_label => 'الاسم';
  @override
  String get profile_phone_label => 'رقم الهاتف';
  @override
  String get profile_birthdate_label => 'تاريخ الميلاد';
  @override
  String get profile_national_id_label => 'الرقم القومي';
  @override
  String get profile_national_id_hint => 'أدخل الرقم القومي (١٤ رقم)';
  @override
  String get profile_error_national_id_empty =>
      'الرقم القومي لا يمكن أن يكون فارغاً.';
  @override
  String get profile_error_national_id_invalid =>
      'الرقم القومي يجب أن يتكون من ١٤ رقماً بدون حروف أو رموز.';
  @override
  String get profile_email_label => 'البريد الإلكتروني';
  @override
  String get profile_gender_label => 'الجنس';
  @override
  String get profile_weight_label => 'الوزن';
  @override
  String get profile_height_label => 'الطول';
  @override
  String get profile_gender_male => 'ذكر';
  @override
  String get profile_gender_female => 'أنثى';
  @override
  String get profile_gender_prefer_not => 'آخر';
  @override
  String get profile_not_specified => 'غير محدد';
  @override
  String get profile_smoking_yes => 'نعم';
  @override
  String get profile_smoking_no => 'لا';
  @override
  String get profile_smoking_ex => 'مدخن سابق';
  @override
  String get profile_error_name_empty => 'الاسم الأول لا يمكن أن يكون فارغًا.';
  @override
  String get profile_error_name_length =>
      'يجب أن يكون الاسم الأول بين 3 و 50 حرفًا.';
  @override
  String get profile_error_name_letters_only =>
      'يجب أن يحتوي الاسم الأول على أحرف فقط.';
  @override
  String get profile_error_email_empty =>
      'البريد الإلكتروني لا يمكن أن يكون فارغًا.';
  @override
  String get profile_error_email_invalid => 'يرجى إدخال بريد إلكتروني صحيح.';
  @override
  String get profile_error_email_length =>
      'يجب ألا يتعدى البريد الإلكتروني 254 حرفًا.';
  @override
  String get profile_error_email_registered =>
      'هذا البريد الإلكتروني مسجل بالفعل.';
  @override
  String get profile_error_gender_required => 'الجنس مطلوب.';
  @override
  String get profile_error_address_length => 'يجب ألا يتعدى العنوان 250 حرفًا.';
  @override
  String get profile_error_address_invalid =>
      'لا يمكن أن يحتوي العنوان على رموز تعبيرية أو أحرف غير مدعومة.';
  @override
  String get profile_upload_photo_title => 'تحميل صورة الملف الشخصي';
  @override
  String get profile_take_photo_option => 'التقاط صورة';
  @override
  String get profile_choose_gallery_option => 'اختر من المعرض';
  @override
  String get profile_photo_selected_success => 'تم تحديد صورة الملف الشخصي بنجاح!';
  @override
  String get profile_photo_pick_failed_prefix => 'فشل في اختيار الصورة: ';
  @override
  String get profile_unsaved_changes_title => 'تغييرات غير محفوظة';
  @override
  String get profile_unsaved_changes_message =>
      'لديك تغييرات غير محفوظة. هل أنت متأكد من رغبتك في المغادرة؟';
  @override
  String get profile_unsaved_changes_stay => 'البقاء';
  @override
  String get profile_unsaved_changes_leave => 'المغادرة';

  // Section 2: Medical Context & Permissions
  @override
  String get profile_dependents_title => 'أفراد العائلة';
  @override
  String get profile_add_dependent_button => 'إضافة فرد عائلة';
  @override
  String get profile_insurance_card_title => 'التأمين الصحي الرقمي';
  @override
  String get profile_insurance_provider => 'مزود الخدمة';
  @override
  String get profile_insurance_number => 'رقم البوليصة';
  @override
  String get profile_insurance_expiry => 'تاريخ الانتهاء';

  // Section 3: Payment & Wallet Management
  @override
  String get profile_wallet_title => 'إدارة المحفظة والدفع';
  @override
  String get profile_wallet_balance => 'رصيد المحفظة';
  @override
  String get profile_wallet_priority => 'استخدام كطريقة دفع ذات أولوية';
  @override
  String get profile_saved_cards => 'البطاقات المحفوظة';
  @override
  String get profile_default_card => 'الافتراضية';
  @override
  String get profile_add_card => 'إضافة بطاقة جديدة';
  @override
  String get profile_invoices_title => 'سجل الدفعات / الفواتير';
  @override
  String get profile_invoice_id => 'رقم الفاتورة';
  @override
  String get profile_amount_paid => 'المبلغ المدفوع';

  // Section 4: Security & Privacy Settings
  @override
  String get profile_security_privacy => 'الأمان والخصوصية';
  @override
  String get profile_biometrics_toggle => 'تفعيل الحماية ببصمة الوجه / الإصبع';
  @override
  String get profile_delete_account => 'حذف الحساب';
  @override
  String get profile_delete_account_confirm => 'تأكيد حذف الحساب';
  @override
  String get profile_delete_account_warning =>
      'تحذير: هذا الإجراء دائم وسيؤدي إلى حذف بيانات حسابك بالكامل. يرجى تأكيد رغبتك في المتابعة.';
  @override
  String get profile_delete_account_dialog_title => 'حذف الحساب نهائياً؟';
  @override
  String get profile_face_id => 'أمان بصمة الوجه';

  // Section 5: App Preferences
  @override
  String get profile_notifications_title => 'الإشعارات';
  @override
  String get profile_priority_payment => 'الدفع ذو الأولوية';
  @override
  String get profile_payment_wallet => 'الدفع والمحفظة';
  @override
  String get profile_support_dial_dialog_title => 'اتصل بالدعم';
  @override
  String get profile_support_dial => 'خط الدعم الساخن';
  @override
  String get profile_app_preferences => 'تفضيلات التطبيق';
  @override
  String get profile_notifications_reminders => 'تذكيرات المواعيد';
  @override
  String get profile_notifications_invoices => 'الفواتير وكشوفات الحساب';
  @override
  String get profile_notifications_promos => 'العروض والخصومات';
  @override
  String get profile_notifications_reminders_sub =>
      'الحصول على تنبيهات للحجوزات والفحوصات';
  @override
  String get profile_notifications_invoices_sub =>
      'استلام كشوفات الحساب والإيصالات الرقمية';
  @override
  String get profile_notifications_promos_sub =>
      'استلام العروض الخاصة والنصائح الصحية';
  @override
  String get profile_language_row => 'اللغة';
  @override
  String get profile_language_sub => 'اختر لغة التطبيق المفضلة';
  @override
  String get profile_theme_row => 'مظهر التطبيق';
  @override
  String get profile_theme_sub => 'تخصيص نمط مظهر التطبيق Visual Appearance';
  @override
  String get profile_theme_light => 'فاتح';
  @override
  String get profile_theme_dark => 'داكن';
  @override
  String get profile_theme_system => 'النظام';
  @override
  String get profile_support_legal_title => 'الدعم والشروط القانونية';
  @override
  String get profile_support_legal_sub =>
      'مركز المساعدة وشروط الخدمة والخصوصية';
  @override
  String get profile_support_terms => 'شروط الاستخدام';
  @override
  String get profile_support_terms_sub =>
      'قراءة شروط الخدمة والأحكام الخاصة بالتطبيق';
  @override
  String get profile_support_privacy => 'سياسة الخصوصية';
  @override
  String get profile_support_privacy_sub =>
      'تعرف على كيفية حماية وتشفير بياناتك الشخصية';
  @override
  String get profile_support_hotline => 'خط الدعم الساخن';
  @override
  String get profile_support_hotline_sub =>
      'الاتصال المباشر بمكتب الدعم (19999)';
  @override
  String get profile_terms_modal_title => 'شروط الاستخدام';
  @override
  String get profile_privacy_modal_title => 'سياسة الخصوصية';
  @override
  String get profile_terms_content =>
      'باستخدام تطبيق Appoynt، فإنك توافق على شروط الخدمة، وسياسات الاستخدام المقبولة، وقواعد حجز المواعيد الطبية.';
  @override
  String get profile_privacy_content =>
      'إن خصوصيتك هي أولويتنا القصوى. نحن نشفر جميع السجلات الطبية والبيانات الشخصية وفقاً لأعلى معايير حماية البيانات الصحية.';
  @override
  String get profile_close_button => 'إغلاق';

  // Section 6: Log Out
  @override
  String get profile_logout_confirm_title => 'تسجيل الخروج من Appoynt؟';
  @override
  String get profile_logout_confirm_message =>
      'هل أنت متأكد من أنك تريد تسجيل الخروج؟ ستتحاج إلى تسجيل الدخول مرة أخرى لإدارة مواعيدك وسجلاتك الصحية.';
  @override
  String get profile_logout_confirm_yes => 'تسجيل الخروج';
  @override
  String get profile_logout_confirm_no => 'إلغاء';
  @override
  String get profile_logout_sub => 'تسجيل الخروج من جلسة حسابك النشطة';

  // Change Password Localizations Arabic Overrides
  @override
  String get password_change_title => 'تغيير كلمة المرور';
  @override
  String get password_current_label => 'كلمة المرور الحالية';
  @override
  String get password_new_label => 'كلمة المرور الجديدة';
  @override
  String get password_confirm_label => 'تأكيد كلمة المرور';
  @override
  String get password_current_empty =>
      'كلمة المرور الحالية لا يمكن أن تكون فارغة.';
  @override
  String get password_current_incorrect => 'كلمة المرور الحالية غير صحيحة.';
  @override
  String get password_new_empty => 'كلمة المرور الجديدة لا يمكن أن تكون فارغة.';
  @override
  String get password_new_length => 'يجب أن تكون كلمة المرور بين 8 و 64 حرفًا.';
  @override
  String get password_new_complexity =>
      'يجب أن تحتوي كلمة المرور على حرف كبير، وحرف صغير، ورقم، ورمز خاص.';
  @override
  String get password_new_unsupported =>
      'لا يمكن أن تحتوي كلمة المرور على مسافات، أو أحرف عربية، أو رموز تعبيرية.';
  @override
  String get password_new_personal_info =>
      'لا يمكن أن تحتوي كلمة المرور على معلوماتك الشخصية.';
  @override
  String get password_new_same_as_current =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور الحالية.';
  @override
  String get password_new_pattern =>
      'لا يمكن أن تحتوي كلمة المرور على أحرف أو أرقام متكررة أو متتالية.';
  @override
  String get password_confirm_empty =>
      'تأكيد كلمة المرور لا يمكن أن يكون فارغًا.';
  @override
  String get password_confirm_match => 'كلمتا المرور غير متطابقتين.';
  @override
  String get password_change_success_msg => 'تم تغيير كلمة المرور بنجاح.';
  @override
  String get profile_change_success_msg => 'تم تحديث الملف الشخصي بنجاح.';

  // Allergies Localizations Arabic Overrides
  @override
  String get allergies_title => 'الحساسية';
  @override
  String get allergies_food_section => 'حساسية الطعام';
  @override
  String get allergies_medication_section => 'حساسية الأدوية';
  @override
  String get environmental_seasonal_allergies => 'حساسية البيئة والفصول';
  @override
  String get allergies_add_allergy => 'إضافة حساسية';
  @override
  String get allergies_placeholder => 'النوع';
  @override
  String get allergies_save_btn => 'حفظ';
  @override
  String get allergies_update_status_btn => 'تحديث الحالة';

  // Prescriptions Localizations Arabic Overrides
  @override
  String get prescriptions_title => 'قائمة الروشتات';
  @override
  String get prescriptions_add_btn => '+ إضافة دواء جديد';
  @override
  String get prescriptions_empty_title => 'لا توجد أدوية مضافة';
  @override
  String get prescriptions_empty_subtitle =>
      'تابع أدويتك الحالية وخطط علاجك في مكان واحد.';
  @override
  String get prescriptions_empty_cta => '+ إضافة أول دواء لك';
  @override
  String get prescriptions_modal_title => 'إضافة دواء جديد';
  @override
  String get prescriptions_field_name_label => 'اسم الدواء والجرعة';
  @override
  String get prescriptions_field_name_hint => 'مثال: بنادول إكسترا 500mg';
  @override
  String get prescriptions_field_freq_label => 'التكرار';
  @override
  String get prescriptions_field_duration_label => 'مدة العلاج (أيام)';
  @override
  String get prescriptions_field_duration_hint => 'مثال: 7 أيام أو مستمر';
  @override
  String get prescriptions_field_doctor_label => 'الطبيب المعالج (اختياري)';
  @override
  String get prescriptions_field_doctor_hint => 'مثال: دكتور أحمد حسن';
  @override
  String get prescriptions_field_rx_label => 'رفع صورة الروشتة (اختياري)';
  @override
  String get prescriptions_freq_once => 'مرة يومياً';
  @override
  String get prescriptions_freq_twice => 'مرتان يومياً';
  @override
  String get prescriptions_freq_every8 => 'كل 8 ساعات';
  @override
  String get prescriptions_freq_as_needed => 'عند الحاجة';
  @override
  String get prescriptions_status_active => 'فعّال';
  @override
  String get prescriptions_save_btn => 'حفظ الروشتة';
  @override
  String get prescriptions_delete_confirm_title => 'حذف الدواء؟';
  @override
  String get prescriptions_delete_confirm_body =>
      'سيتم حذف هذا الدواء من قائمتك بشكل دائم.';
  @override
  String get prescriptions_delete_confirm_yes => 'حذف';
  @override
  String get prescriptions_delete_confirm_no => 'إلغاء';
  @override
  String get prescriptions_add_medication => 'إضافة دواء';
  @override
  String get prescriptions_added_title => 'الروشتة المضافة';

  // Tests & Results Localizations Arabic Overrides
  @override
  String get tests_title => 'التحاليل والأشعة';
  @override
  String get tests_tab_lab => 'التحاليل الطبية';
  @override
  String get tests_tab_scanning => 'الأشعة';
  @override
  String get tests_no_tests_found => 'لم يتم العثور على تحاليل طبية';
  @override
  String get tests_no_scans_found => 'لم يتم العثور على أشعة';
  @override
  String get tests_add_title => 'إضافة نتيجة تحليل طبي';
  @override
  String get tests_doc_name_label => 'اسم المستند';
  @override
  String get tests_date_label => 'التاريخ';
  @override
  String get tests_select_date_btn => 'اختر التاريخ';
  @override
  String get tests_upload_doc_btn => 'تحميل المستند من الجهاز';
  @override
  String get tests_confirm_upload_btn => 'تأكيد التحميل';
  @override
  String get tests_empty_title => 'لا توجد تقارير أو أشعة مضافة';
  @override
  String get tests_empty_subtitle =>
      'قم برفع وتقارير الفحوصات والأشعة الخاصة بك ليسهل الوصول إليها ومشاركتها مع طبيبك.';
  @override
  String get tests_empty_cta => '+ إضافة نتيجة أو تقرير جديد';
  @override
  String get tests_upload_new_cta => '+ إضافة نتيجة أو تقرير جديد';
  @override
  String get tests_file_attached_toast => 'تم إرفاق الملف بنجاح.';
  @override
  String get tests_error_no_file => 'يرجى تحميل ملف تقرير من جهازك.';
  @override
  String get tests_success_upload => 'تم رفع المستند بنجاح.';

  // Chronic Conditions Localizations Arabic Overrides
  @override
  String get chronic_title => 'الأمراض المزمنة';
  @override
  String get chronic_description =>
      'يرجى تحديد الحالات المزمنة التي تنطبق عليك لمساعدتنا في تقديم رعاية أفضل.';

  // Insurance Details Localizations Arabic Overrides
  @override
  String get insurance_title => 'قائمة التأمين';
  @override
  String get insurance_expiry_label => 'تاريخ الانتهاء:';
  @override
  String get insurance_view_btn => 'عرض';
  @override
  String get insurance_add_title => 'قائمة التأمين';
  @override
  String get insurance_card_name_label => 'اسم البطاقة';
  @override
  String get insurance_card_number_label => 'رقم البطاقة';
  @override
  String get insurance_select_provider_btn => 'اختر مقدم الخدمة';
  @override
  String get insurance_upload_doc_btn => 'تحميل من الجهاز';
  @override
  String get insurance_add_card_btn => 'إضافة البطاقة';
  @override
  String get insurance_add_card_full_btn => 'إضافة بطاقة تأمين';
  @override
  String get insurance_save_card_btn => 'حفظ البطاقة';

  // Payment & Wallet Localizations Arabic Overrides
  @override
  String get payment_wallet_title => 'المحفظة والدفع';
  @override
  String get payment_balance_label => 'رصيد المحفظة';
  @override
  String get payment_priority_label => 'مفتاح الدفع ذو الأولوية';
  @override
  String get payment_saved_cards_tile => 'بطاقات الدفع المحفوظة';
  @override
  String get payment_saved_cards_subtitle => 'إدارة بطاقات الدفع والخصم المحفوظة الخاصة بك';
  @override
  String get payment_history_tile => 'سجل الدفع والفواتير';
  @override
  String get payment_history_subtitle => 'عرض المعاملات السابقة وتنزيل الفواتير';
  @override
  String get payment_add_money_btn => 'إضافة أموال';
  @override
  String get payment_active_status => 'نشط';
  @override
  String get payment_inactive_status => 'غير نشط';
  @override
  String get payment_default_badge => 'افتراضي';
  @override
  String get payment_cardholder_label => 'حامل البطاقة';
  @override
  String get payment_valid_thru_label => 'صالح حتى';
  @override
  String get payment_add_money_coming_soon => 'ميزة إضافة الأموال ستتوفر قريباً!';
  @override
  String get payment_manage_cards_title => 'البطاقات المحفوظة';
  @override
  String get payment_cards_count_suffix => 'بطاقات';
  @override
  String get payment_set_default_action => 'تعيين كافتراضي';
  @override
  String get payment_delete_card_action => 'حذف البطاقة';
  @override
  String get payment_card_removed_success => 'تمت إزالة البطاقة بنجاح.';
  @override
  String get payment_confirm_delete_title => 'تأكيد الحذف';
  @override
  String get payment_confirm_delete_body => 'هل أنت متأكد أنك تريد حذف بطاقة الدفع هذه؟';
  @override
  String get payment_delete_card_dialog_body_prefix => 'هل أنت متأكد من رغبتك في إزالة البطاقة "';
  @override
  String get payment_delete_card_dialog_body_suffix => '"؟ لا يمكن التراجع عن هذا الإجراء.';
  @override
  String get payment_delete_btn => 'حذف';
  @override
  String get payment_remove_btn => 'إزالة';
  @override
  String get payment_cancel_btn => 'إلغاء';
  @override
  String get payment_no_saved_cards_title => 'لا توجد بطاقات محفوظة';
  @override
  String get payment_no_saved_cards_body => 'لم تقم بحفظ أي بطاقات دفع بعد.';
  @override
  String get payment_add_new_card_btn => 'إضافة بطاقة جديدة';
  @override
  String get payment_invoices_history_title => 'الفواتير والسجل';
  @override
  String get payment_total_paid_invoices => 'إجمالي الفواتير المدفوعة';
  @override
  String get payment_invoices_count_suffix => 'فواتير';
  @override
  String get payment_date_filter_prefix => 'التاريخ';
  @override
  String get payment_amount_filter_prefix => 'المبلغ';
  @override
  String get payment_service_filter_prefix => 'الخدمة';
  @override
  String get payment_apply_filter_btn => 'تطبيق الفلتر';
  @override
  String get payment_filter_date_range_title => 'تصفية حسب النطاق الزمني';
  @override
  String get payment_all_time_option => 'كل الأوقات';
  @override
  String get payment_this_month_option => 'هذا الشهر';
  @override
  String get payment_last_3_months_option => 'آخر 3 أشهر';
  @override
  String get payment_custom_range_option => 'نطاق مخصص';
  @override
  String get payment_filter_amount_range_title => 'تصفية حسب نطاق المبلغ';
  @override
  String get payment_filter_service_type_title => 'تصفية حسب نوع الخدمة';
  @override
  String get payment_no_invoices_found_title => 'لم يتم العثور على فواتير';
  @override
  String get payment_no_invoices_found_body => 'لم يتم العثور على فواتير تطابق الفلاتر المحددة. يرجى تعديل خيارات التصفية.';
  @override
  String get payment_downloading_invoice_snack => 'جاري تحميل الفاتورة بصيغة PDF...';
  @override
  String get payment_min_label => 'الحد الأدنى';
  @override
  String get payment_max_label => 'الحد الأقصى';

  // Add test result sub-page Arabic Overrides
  @override
  String get add_test_doc_name_label => 'اسم المستند';
  @override
  String get add_test_doc_name_hint => 'مثال: صورة دم كاملة (CBC)';
  @override
  String get add_test_facility_label => 'المعمل / المركز الطبي';
  @override
  String get add_test_facility_hint => 'مثال: معمل البرج، كايرو سكان';
  @override
  String get add_test_date_label => 'تاريخ الفحص / الأشعة';
  @override
  String get add_test_date_hint => 'اختر التاريخ';
  @override
  String get add_test_status_label => 'حالة النتيجة';
  @override
  String get add_test_status_normal => 'طبيعي';
  @override
  String get add_test_status_abnormal => 'غير طبيعي';
  @override
  String get add_test_status_pending => 'قيد المراجعة';
  @override
  String get add_test_doctor_label => 'الطبيب المعالج (اختياري)';
  @override
  String get add_test_doctor_hint => 'اسم الطبيب المعالج';
  @override
  String get add_test_notes_label => 'ملاحظات إضافية (اختياري)';
  @override
  String get add_test_notes_hint => 'أضف أي ملاحظات أو تفاصيل إضافية هنا...';
  @override
  String get add_test_upload_label => 'تحميل التقرير';
  @override
  String get add_test_dropzone_text => 'اضغط هنا لرفع صورة أو ملف PDF للتقرير';
  @override
  String get add_test_dropzone_sub => 'الحد الأقصى للملف 10 ميجابايت (JPG, PNG, PDF)';
  @override
  String get add_test_validation_name_empty => 'اسم المستند لا يمكن أن يكون فارغاً.';
  @override
  String get add_test_validation_date_empty => 'يرجى اختيار التاريخ.';
  @override
  String get add_test_uploaded_status => 'تم الرفع';
  @override
  List<String> get month_names => const [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];

  // Add family member Arabic Overrides
  @override
  String get add_member_edit_title => 'تعديل فرد العائلة';
  @override
  String get add_member_add_title => 'إضافة فرد عائلة';
  @override
  String get add_member_update_btn => 'تحديث البيانات';
  @override
  String get add_member_save_btn => 'حفظ البيانات';
  @override
  String get add_member_success_toast => 'تم حفظ بيانات فرد العائلة بنجاح.';
  @override
  String get add_member_identity_details_header => 'تفاصيل الهوية';
  @override
  String get add_member_full_name_label => 'الاسم الكامل';
  @override
  String get add_member_full_name_hint => 'مثال: ليونيل مسعد';
  @override
  String get add_member_name_empty_error => 'يرجى إدخال الاسم';
  @override
  String get add_member_name_short_error => 'يجب أن يتكون الاسم من 3 أحرف على الأقل';
  @override
  String get add_member_relationship_header => 'صلة القرابة';
  @override
  String get add_member_dob_header => 'تاريخ الميلاد';
  @override
  String get add_member_dob_hint => 'اختر التاريخ';
  @override
  String get add_member_required_error => 'مطلوب';
  @override
  String get add_member_gender_header => 'تحديد الجنس';
  @override
  String get add_member_medical_bg_header => 'الخلفية الطبية';
  @override
  String get add_member_medical_bg_label => 'الحساسية، الأدوية أو الأمراض المزمنة';
  @override
  String get add_member_medical_bg_hint => 'صف تفاصيل التاريخ الطبي هنا...';
  @override
  String get rel_son => 'ابن';
  @override
  String get rel_daughter => 'ابنة';
  @override
  String get rel_spouse => 'زوج/زوجة';
  @override
  String get rel_parent => 'أحد الوالدين';
  @override
  String get gender_male => 'ذكر';
  @override
  String get gender_female => 'أنثى';

  // Security & Privacy page Arabic Overrides
  @override
  String get sec_account_title => 'أمان الحساب';
  @override
  String get sec_privacy_title => 'خصوصية البيانات الطبية';
  @override
  String get sec_danger_title => 'إجراءات حساسة';
  @override
  String get biometric_title => 'المصادقة البيومترية';
  @override
  String get biometric_subtitle => 'بصمة الوجه / الإصبع للدخول السريع';
  @override
  String get tfa_title => 'التحقق بخطوتين';
  @override
  String get tfa_enabled => 'مفعّل';
  @override
  String get tfa_disabled => 'معطّل';
  @override
  String get change_password_label => 'تغيير كلمة المرور';
  @override
  String get change_password_subtitle => 'تحديث بيانات وكلمة مرور حسابك';
  @override
  String get autolock_title => 'القفل التلقائي للتطبيق';
  @override
  String get autolock_immediately => 'فوري';
  @override
  String get autolock_5mins => 'بعد 5 دقائق';
  @override
  String get doc_access_title => 'صلاحيات دخول الطبيب';
  @override
  String get doc_access_full => 'وصول كامل';
  @override
  String get doc_access_request => 'يتطلب إذن';
  @override
  String get active_devices_title => 'الأجهزة النشطة حالياً';
  @override
  String get active_devices_subtitle => 'آيفون 15 • القاهرة، مصر';
  @override
  String get manage_sessions => 'إدارة الجلسات';
  @override
  String get export_data_title => 'تصدير البيانات الطبية';
  @override
  String get export_data_subtitle => 'طلب نسخة بصيغة PDF أو JSON لسجلك الطبي';
  @override
  String get delete_account_title => 'حذف الحساب نهائياً';
  @override
  String get delete_account_subtitle => 'سيتم مسح جميع بياناتك وسجلاتك الطبية نهائياً ولا يمكن استرجاعها';
  @override
  String get preparing_data_export_toast => 'جاري تحضير ملف البيانات الطبية للتصدير...';

  // Medical context count Arabic overrides
  @override
  String get_items_count_text(int count) {
    if (0 == count) {
      return 'لا يوجد';
    } else if (1 == count) {
      return 'عنصر واحد';
    } else {
      return '$count عناصر';
    }
  }

  @override
  String get_prescriptions_count_text(int count) {
    if (0 == count) {
      return 'لا يوجد';
    } else if (1 == count) {
      return 'روشتة واحدة';
    } else {
      return '$count روشتات';
    }
  }

  @override
  String get_files_count_text(int count) {
    if (0 == count) {
      return 'لا يوجد';
    } else if (1 == count) {
      return 'ملف واحد';
    } else {
      return '$count ملفات';
    }
  }

  @override
  String get_cards_count_text(int count) {
    if (0 == count) {
      return 'لا يوجد بطاقات';
    } else if (1 == count) {
      return 'بطاقة واحدة';
    } else if (2 == count) {
      return 'بطاقتان';
    } else {
      return '$count بطاقات';
    }
  }

  @override
  String get_members_count_text(int count) {
    if (0 == count) {
      return 'لا يوجد أفراد';
    } else if (1 == count) {
      return 'عضو واحد';
    } else if (2 == count) {
      return 'عضوان';
    } else {
      return '$count أعضاء';
    }
  }

  // Chronic conditions page Arabic overrides
  @override
  String get chronic_remove_dialog_title => 'إزالة الحالة المرضية؟';
  @override
  String chronic_remove_dialog_body(String label) => 'هل أنت متأكد من إزالة $label من سجلك الطبي؟ لن يظهر هذا المرض في ملفك الطبي المشارك مع الأطباء.';
  @override
  String get chronic_cancel_btn => 'إلغاء';
  @override
  String get chronic_remove_btn => 'إزالة';
  @override
  String get chronic_status_controlled => 'حالة مستقرة';
  @override
  String get chronic_status_monitoring => 'تتطلب المتابعة';
  @override
  String get chronic_diag_year_header => 'سنة التشخيص';
  @override
  String get chronic_treatment_status_header => 'حالة العلاج';
  @override
  String get chronic_controlled_label => 'مستقرة';
  @override
  String get chronic_monitoring_label => 'متابعة';
  @override
  String get chronic_no_conditions_label => 'لا أعاني من أمراض مزمنة';
  @override
  String get chronic_save_btn => 'حفظ سجل الأمراض المزمنة';
  @override
  String get chronic_search_hint => 'البحث أو إضافة حالة جديدة (مثل: الربو)...';
  @override
  String get chronic_saved_success_toast => 'تم حفظ سجل الأمراض المزمنة بنجاح.';
  @override
  String get_chronic_subtitle(String year, String status) => 'تم التشخيص في $year • $status';

  // Authentication error localized message Arabic overrides
  @override
  String get error_invalid_credentials => 'رقم الهاتف أو كلمة المرور غير صحيحة.';
  @override
  String get error_phone_empty => 'رقم الهاتف لا يمكن أن يكون فارغاً.';
  @override
  String get error_otp_invalid => 'يجب أن يتكون رمز التحقق من 6 أرقام.';
  @override
  String get error_password_too_short => 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.';
}

/*
 * File Name: app_localizations_en.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
 * File Description: English concrete implementation of localizations
 *   containing onboarding and authentication strings.
 */

// Importing standard material framework libraries
import 'package:flutter/material.dart';
// Importing abstract base localization class definition
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

// English translations class extending the base localizations
class AppLocalizationsEn extends AppLocalizations {
  // Constructor passing the English language locale context to parent
  AppLocalizationsEn() : super(const Locale('en'));

  // Override getter returning localized label for skip action
  @override
  String get skip {
    // Return standard English word for skipping screens
    return 'Skip';
  }

  // Override getter returning localized label for next action
  @override
  String get next {
    // Return standard English word for proceeding
    return 'Next';
  }

  // Override getter returning localized label for final onboarding action
  @override
  String get get_started {
    // Return standard English phrase for beginning
    return 'Get Started';
  }

  // Override getter returning localized onboarding titles prefix list
  @override
  List<String> get onboarding_titles_prefix {
    // Return list of prefixes mapped to onboarding steps
    return const [
      'Book with ', // Page 1 prefix text
      'Stay in the ', // Page 2 prefix text
      'Your health, ', // Page 3 prefix text
    ];
  }

  // Override getter returning localized onboarding titles accent words list
  @override
  List<String> get onboarding_titles_accent {
    // Return list of accented keywords mapped to onboarding steps
    return const [
      'confidence', // Page 1 accent keyword
      'loop', // Page 2 accent keyword
      'secured', // Page 3 accent keyword
    ];
  }

  // Override getter returning localized onboarding descriptive subtitles list
  @override
  List<String> get onboarding_subtitles {
    // Return list of paragraphs explaining app value propositions
    return const [
      'Find trusted healthcare and book your appointment in just a few taps.',
      // Page 2 description
      'Track your real-time queue and get updates so you always know when it\'s your turn.',
      'All your records, payments and reminders — all in one safe place.',
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
    return 'Password must contain:';
  }

  // Override getter returning password strength indicator label
  @override
  String get password_strength {
    // Return label for password validation strength indicator
    return 'Password strength';
  }

  // Override getter returning weak strength status string representation
  @override
  String get strength_weak {
    // Return English word for weak security level
    return 'Weak';
  }

  // Override getter returning medium strength status string representation
  @override
  String get strength_medium {
    // Return English word for medium security level
    return 'Medium';
  }

  // Override getter returning strong strength status string representation
  @override
  String get strength_strong {
    // Return English word for strong security level
    return 'Strong';
  }

  // Override getter returning too short error validation text
  @override
  String get too_short {
    // Return English warning word for short character length
    return 'Too short';
  }

  // Override getter returning minimum character length password rule label
  @override
  String get password_rule_min_length {
    // Return English rule description
    return 'At least 8 characters';
  }

  // Override getter returning uppercase character password rule label
  @override
  String get password_rule_uppercase {
    // Return English rule description
    return 'At least one uppercase letter (A-Z)';
  }

  // Override getter returning lowercase character password rule label
  @override
  String get password_rule_lowercase {
    // Return English rule description
    return 'At least one lowercase letter (a-z)';
  }

  // Override getter returning digit number password rule label
  @override
  String get password_rule_number {
    // Return English rule description
    return 'At least one number (0-9)';
  }

  // Override getter returning special character password rule label
  @override
  String get password_rule_special {
    // Return English rule description
    return 'At least one special character (!@#\$&*~%)';
  }

  // Override getter prohibiting Arabic characters password rule label
  @override
  String get password_rule_no_arabic {
    // Return English rule description
    return 'No Arabic characters';
  }

  // Override getter returning welcome back greeting message
  @override
  String get welcome_back {
    // Return English welcome back title
    return 'Welcome Back';
  }

  // Override getter returning helper text for credential login input
  @override
  String get login_subtitle {
    // Return English description helper text
    return 'Enter your credentials to access your account';
  }

  // Override getter returning combined email or phone input field label
  @override
  String get email_or_phone {
    // Return English identifier placeholder label
    return 'Email or Phone Number';
  }

  // Override getter returning hint helper text inside identifier field
  @override
  String get enter_email_or_phone {
    // Return English prompt description hint text
    return 'Enter your email or phone';
  }

  // Override getter returning standard label for email inputs
  @override
  String get email {
    // Return English email label
    return 'Email';
  }

  // Override getter returning standard label for phone inputs
  @override
  String get phone {
    // Return English phone label
    return 'Phone Number';
  }

  // Override getter returning standard label for password inputs
  @override
  String get password {
    // Return English password label
    return 'Password';
  }

  // Override getter returning label for forgot password anchor link
  @override
  String get forgot_password {
    // Return English question label text
    return 'Forgot Password?';
  }

  // Override getter returning standard login action button text
  @override
  String get login {
    // Return English word for signing in
    return 'Login';
  }

  // Override getter returning question prompt for new users
  @override
  String get no_account {
    // Return English prompt label
    return "Don't have an account?";
  }

  // Override getter returning link button text navigating to register page
  @override
  String get sign_up {
    // Return English word for registration actions
    return 'Sign Up';
  }

  // Override getter returning error description on blank inputs
  @override
  String get field_required {
    // Return English field requirement warning
    return 'This field is required';
  }

  // Override getter returning format validation error message for emails
  @override
  String get invalid_email {
    // Return English email validation failure warning
    return 'Please enter a valid email address';
  }

  // Override getter returning format validation error message for phone inputs
  @override
  String get invalid_phone {
    // Return English phone number validation failure warning
    return 'Please enter a valid phone number';
  }

  // Override getter returning name length validation error message
  @override
  String get name_length_error {
    // Return English name length bounds validation warning
    return 'Name must be between 3 and 50 characters';
  }

  // Override getter returning name characters validation error message
  @override
  String get name_letters_only_error {
    // Return English name letters only validation warning
    return 'Name must contain only letters';
  }

  // Override getter returning phone length validation error message
  @override
  String get phone_must_be_11_digits {
    // Return English phone digits count warning
    return 'Phone number must be exactly 11 digits';
  }

  // Override getter returning phone start validation error message
  @override
  String get phone_must_start_01 {
    // Return English phone prefix warning
    return 'Phone number must start with 01';
  }

  // Override getter returning phone operator validation error message
  @override
  String get phone_invalid_operator {
    // Return English phone operator type warning
    return 'Phone number must start with 010, 011, 012, or 015';
  }

  // Override getter returning title label for registration gateway
  @override
  String get register_title {
    // Return English title
    return 'Create Account';
  }

  // Override getter returning subtitle details for registration gateway
  @override
  String get register_subtitle {
    // Return English description helper text
    return 'Fill in your details to get started';
  }

  // Override getter returning label for first name inputs
  @override
  String get first_name_label {
    // Return English first name input label
    return 'First Name';
  }

  // Override getter returning hint for first name inputs
  @override
  String get first_name_hint {
    // Return English first name hint
    return 'First Name';
  }

  // Override getter returning label for last name inputs
  @override
  String get last_name_label {
    // Return English last name input label
    return 'Last Name';
  }

  // Override getter returning hint for last name inputs
  @override
  String get last_name_hint {
    // Return English last name hint
    return 'Last Name';
  }

  // Override getter returning hint helper text for email inputs
  @override
  String get email_hint {
    // Return English email format sample hint
    return 'example@email.com';
  }

  // Override getter returning hint helper text for phone inputs
  @override
  String get phone_hint {
    // Return English phone pattern sample hint
    return '01xxxxxxxxx';
  }

  // Override getter returning hint helper text for password inputs
  @override
  String get password_hint {
    // Return English password placeholder hint
    return 'Password';
  }

  // Override getter returning label for confirmation password inputs
  @override
  String get confirm_password {
    // Return English confirm password input label
    return 'Confirm Password';
  }

  // Override getter returning hint helper text for confirmation password inputs
  @override
  String get confirm_password_hint {
    // Return English confirm password hint
    return 'Confirm Password';
  }

  // Override getter returning agreement prefix label for terms acceptance checkbox
  @override
  String get agree_to_terms {
    // Return English agreement prefix sentence
    return 'I agree to the ';
  }

  // Override getter returning clickable link text for terms of service documentation
  @override
  String get terms_and_conditions {
    // Return English terms link label
    return 'Terms & Conditions';
  }

  // Override getter returning simple connector word for grammatical listings
  @override
  String get and_connector {
    // Return English connector string
    return ' and ';
  }

  // Override getter returning clickable link text for privacy policy documentation
  @override
  String get privacy_policy {
    // Return English privacy link label
    return 'Privacy Policy';
  }

  // Override getter returning footer question prompt for registered users
  @override
  String get have_account {
    // Return English question sentence
    return 'Already have an account?';
  }

  // Override getter returning sign in link text for existing accounts
  @override
  String get sign_in {
    // Return English sign in action word
    return 'Sign In';
  }

  // Override getter returning action button label for registration execution
  @override
  String get create_my_account {
    // Return English account creation button text
    return 'Create My Account';
  }

  // Override getter returning validation alert message for unselected terms checkbox
  @override
  String get terms_must_agree {
    // Return English warning alert text
    return 'You must agree to the terms';
  }

  // Override getter returning validation alert message for exceeded phone digits limit
  @override
  String get phone_max_error {
    // Return English digit restriction warning text
    return 'Phone number must not exceed 11 digits';
  }

  // Override getter returning validation alert message for mismatched password inputs
  @override
  String get password_mismatch {
    // Return English credentials mismatch warning text
    return 'Passwords do not match';
  }

  // Override getter returning verification screen title
  @override
  String get enter_your_code {
    // Return English verification title
    return 'Enter your code';
  }

  // Override getter returning verification screen description subtitle
  @override
  String get enter_otp_subtitle {
    // Return English description helper text
    return 'We sent a 6-digit code to your phone number';
  }

  // Override getter returning resending countdown trigger link label
  @override
  String get send_code_again {
    // Return English resending code label
    return 'Send code again';
  }

  // Override getter returning sent code description information card text
  @override
  String get sent_code_info {
    // Return English information card text
    return 'We have sent a verification code to your phone number. '
        'Please enter it to verify your account.';
  }

  // Override getter returning OTP verification action button label
  @override
  String get verify {
    // Return English verification action label
    return 'Verify';
  }

  // Override getter returning forgot password screen title
  @override
  String get forgot_password_title {
    // Return English forgot password title
    return 'Forgot Password?';
  }

  // Override getter returning forgot password screen descriptive instructions subtitle
  @override
  String get forgot_password_subtitle {
    // Return English forgot password subtitle instructions
    return 'Enter your phone number to receive a verification code';
  }

  // Override getter returning forgot password trigger button label text
  @override
  String get send_code {
    // Return English send code label
    return 'Send Code';
  }

  // Override getter returning reset password confirmation button label
  @override
  String get update_password {
    // Return English update password text
    return 'Update Password';
  }

  // Override getter returning reset password screen title
  @override
  String get create_new_password {
    // Return English create new password title
    return 'Create New Password';
  }

  // Override getter returning reset password screen description subtitle
  @override
  String get reset_password_subtitle {
    // Return English reset password subtitle instruction
    return 'Your new password must be different from previous passwords';
  }

  // Override getter returning reset password input field label
  @override
  String get new_password_label {
    // Return English new password label
    return 'New Password';
  }

  // Override getter returning reset password input placeholder hint
  @override
  String get new_password_hint {
    // Return English new password hint
    return 'Password';
  }

  // Override getter returning account created success screen title
  @override
  String get account_created_success {
    // Return English account success title
    return 'Account Created Successfully!';
  }

  // Override getter returning welcome greeting message
  @override
  String get welcome_to_appoynt {
    // Return English welcome description
    return 'Welcome to Appoynt';
  }

  // Override getter returning automatic redirect loader label
  @override
  String get redirecting_automatically {
    // Return English redirecting description
    return 'Redirecting automatically...';
  }

  // Override parameterized method for home redirection timer description text
  @override
  String going_to_home_in(int seconds) {
    // Return English going to home string dynamically
    return 'Going to home page in $seconds seconds...';
  }

  // Override getter returning skip manual button label
  @override
  String get go_to_home {
    // Return English go to home label
    return 'Go to Home';
  }

  // Override getter returning password reset successfully screen title
  @override
  String get password_reset_success_title {
    // Return English password reset success title
    return 'Password Reset Successfully';
  }

  // Override getter returning password reset successfully screen description
  @override
  String get password_reset_success_body {
    // Return English password reset success description
    return 'Your password has been updated successfully.\n'
        'You can now sign in with your new password.';
  }

  // Override getter returning redirecting to login page button label
  @override
  String get go_to_login {
    // Return English go to login button label
    return 'Go to Login';
  }

  // Override getter returning no internet error screen title
  @override
  String get no_internet_title {
    // Return English no internet title
    return 'No Internet Connection';
  }

  // Override getter returning no internet screen instructions subtitle
  @override
  String get no_internet_sub {
    // Return English no internet instructions subtitle
    return 'Please check your network settings and try again';
  }

  // Override getter returning retry reconnection trigger button label
  @override
  String get retry {
    // Return English retry label
    return 'Retry';
  }

  // Override getter returning password maximum length validation warning
  @override
  String get password_too_long {
    // Return English password too long warning
    return 'Password must be maximum 30 characters';
  }

  // TODO: START OF DUMMY HOME SCREEN LOCALIZATION OVERRIDES - REMOVE ONCE FINAL HOME IS COMPLETED
  // Override getter returning bottom navigation home label in English
  @override
  String get dummy_home_tab_label {
    // Return English bottom navigation home tab label
    return 'Home';
  }

  // Override getter returning bottom navigation appointments label in English
  @override
  String get dummy_appointments_tab_label {
    // Return English bottom navigation appointments tab label
    return 'Appointments';
  }

  // Override getter returning bottom navigation search label in English
  @override
  String get dummy_search_tab_label {
    // Return English bottom navigation search tab label
    return 'Search';
  }

  // Override getter returning bottom navigation favorites label in English
  @override
  String get dummy_favorite_tab_label {
    // Return English bottom navigation favorites tab label
    return 'Favorite';
  }

  // Override getter returning bottom navigation queue label in English
  @override
  String get dummy_queue_tab_label {
    // Return English bottom navigation queue tab label
    return 'Queue';
  }

  // Override getter returning bottom navigation records label in English
  @override
  String get dummy_records_tab_label {
    // Return English bottom navigation records tab label
    return 'Records';
  }

  // Override getter returning bottom navigation profile label in English
  @override
  String get dummy_profile_tab_label {
    // Return English bottom navigation profile tab label
    return 'Profile';
  }

  // Override getter returning greeting time welcome text in English
  @override
  String get dummy_good_morning {
    // Return English greeting time welcome text
    return 'Good Morning 👋';
  }

  // Override getter returning welcome banner subtitle text in English
  @override
  String get dummy_welcome_to_appoynt_home {
    // Return English welcome banner subtitle text
    return 'Welcome to Appoynt';
  }

  // Override getter returning search field placeholder hint text in English
  @override
  String get dummy_search_hint {
    // Return English search field placeholder hint text
    return 'Search doctors, specialties...';
  }

  // Override getter returning book appointment action button label in English
  @override
  String get dummy_book_appointment {
    // Return English book appointment action button label
    return 'Book\nAppointment';
  }

  // Override getter returning queue status action button label in English
  @override
  String get dummy_my_queue {
    // Return English queue status action button label
    return 'My\nQueue';
  }

  // Override getter returning video call action button label in English
  @override
  String get dummy_video_consult {
    // Return English video call action button label
    return 'Video\nConsult';
  }

  // Override getter returning medical records action button label in English
  @override
  String get dummy_my_records {
    // Return English medical records action button label
    return 'My\nRecords';
  }

  // Override getter returning appointment banner title label in English
  @override
  String get dummy_next_appointment {
    // Return English appointment banner title label
    return 'Next Appointment';
  }

  // Override getter returning primary physician name in English
  @override
  String get dummy_dr_ahmed_hassan {
    // Return English primary physician name
    return 'Dr. Ahmed Hassan';
  }

  // Override getter returning physician specialty and timing details in English
  @override
  String get dummy_general_medicine_today {
    // Return English physician specialty and timing details
    return 'General Medicine • Today, 3:00 PM';
  }

  // Override getter returning view details navigation button label in English
  @override
  String get dummy_view_details {
    // Return English view details navigation button label
    return 'View Details';
  }

  // Override getter returning specialty categorization header label in English
  @override
  String get dummy_specialties {
    // Return English specialty categorization header label
    return 'Specialties';
  }

  // Override getter returning view all items navigation link label in English
  @override
  String get dummy_see_all {
    // Return English view all items navigation link label
    return 'See All';
  }

  // Override getter returning cardiology specialty category name in English
  @override
  String get dummy_cardiology {
    // Return English cardiology specialty category name
    return 'Cardiology';
  }

  // Override getter returning neurology specialty category name in English
  @override
  String get dummy_neurology {
    // Return English neurology specialty category name
    return 'Neurology';
  }

  // Override getter returning pediatrics specialty category name in English
  @override
  String get dummy_pediatrics {
    // Return English pediatrics specialty category name
    return 'Pediatrics';
  }

  // Override getter returning ophthalmology specialty category name in English
  @override
  String get dummy_eye_care {
    // Return English ophthalmology specialty category name
    return 'Eye Care';
  }

  // Override getter returning orthopedic specialty category name in English
  @override
  String get dummy_orthopedic {
    // Return English orthopedic specialty category name
    return 'Orthopedic';
  }

  // Override getter returning featured physicians header label in English
  @override
  String get dummy_top_doctors {
    // Return English featured physicians header label
    return 'Top Doctors';
  }

  // Override getter returning cardiologist practitioner name in English
  @override
  String get dummy_dr_sarah_johnson {
    // Return English cardiologist practitioner name
    return 'Dr. Sarah Johnson';
  }

  // Override getter returning cardiologist specialty title in English
  @override
  String get dummy_cardiologist {
    // Return English cardiologist specialty title
    return 'Cardiologist';
  }

  // Override getter returning cardiology practice length details in English
  @override
  String get dummy_years_experience_sarah {
    // Return English cardiology practice length details
    return '12 years';
  }

  // Override getter returning neurologist practitioner name in English
  @override
  String get dummy_dr_mohammed_ali {
    // Return English neurologist practitioner name
    return 'Dr. Mohammed Ali';
  }

  // Override getter returning neurologist specialty title in English
  @override
  String get dummy_neurologist {
    // Return English neurologist specialty title
    return 'Neurologist';
  }

  // Override getter returning neurology practice length details in English
  @override
  String get dummy_years_experience_mohammed {
    // Return English neurology practice length details
    return '9 years';
  }

  // Override getter returning pediatrician practitioner name in English
  @override
  String get dummy_dr_fatima_ahmed {
    // Return English pediatrician practitioner name
    return 'Dr. Fatima Ahmed';
  }

  // Override getter returning pediatrician specialty title in English
  @override
  String get dummy_pediatrician {
    // Return English pediatrician specialty title
    return 'Pediatrician';
  }

  // Override getter returning pediatrics practice length details in English
  @override
  String get dummy_years_experience_fatima {
    // Return English pediatrics practice length details
    return '7 years';
  }

  // Override getter returning appointment book action trigger label in English
  @override
  String get dummy_book {
    // Return English appointment book action trigger label
    return 'Book';
  }

  // Override getter returning feature under construction info label in English
  @override
  String get dummy_coming_soon {
    // Return English feature under construction info label
    return 'Coming Soon';
  }
  // TODO: END OF DUMMY HOME SCREEN LOCALIZATION OVERRIDES

  // Override getter returning search filter chip location label text in English
  @override
  String get search_location_chip {
    // Return English search location label
    return 'Location';
  }

  // Override getter returning search filter chip specialty label text in English
  @override
  String get search_specialty_chip {
    // Return English search specialty label
    return 'Specialty';
  }

  // Override getter returning uppercase recent searches section label title in English
  @override
  String get search_recent_searches_title {
    // Return English recent searches title
    return 'RECENT SEARCHES';
  }

  // Override getter returning recent search history clear list trigger label text in English
  @override
  String get search_clear_action {
    // Return English clear history label
    return 'Clear';
  }

  // Override getter returning recent search history clear confirmation modal warning in English
  @override
  String get search_clear_all_confirm_title {
    // Return English clear confirmation dialog message
    return 'Clear all recent search history?';
  }

  // Override getter returning alert modal cancel action button label in English
  @override
  String get search_cancel_button {
    // Return English cancel button text
    return 'Cancel';
  }

  // Override getter returning alert modal confirm clear action button label in English
  @override
  String get search_clear_all_button {
    // Return English clear all button text
    return 'Clear All';
  }

  // Override getter returning suggestions card list view all results trigger label text in English
  @override
  String get search_view_all_results {
    // Return English view all search results label
    return 'View All Search Results';
  }

  // Override getter returning filters-only state primary action button label in English
  @override
  String get search_view_all_filtered_results {
    // Return English view all filtered results button text
    return 'View all filtered results';
  }

  // Override getter returning bottom navigation profile tab label in English
  @override
  String get search_tab_profile {
    // Return English profile label
    return 'Profile';
  }

  // Override getter returning bottom navigation appointment tab label in English
  @override
  String get search_tab_appointment {
    // Return English appointment label
    return 'Appointment';
  }

  // Override getter returning bottom navigation search tab label in English
  @override
  String get search_tab_search {
    // Return English search label
    return 'Search';
  }

  // Override getter returning bottom navigation favorites tab label in English
  @override
  String get search_tab_favorites {
    // Return English favorites label
    return 'Favorites';
  }

  // Override getter returning bottom navigation home tab label in English
  @override
  String get search_tab_home {
    // Return English home label
    return 'Home';
  }

  // Override getter returning autocomplete empty matching results indicator text label in English
  @override
  String get search_no_results {
    // Return English no results message
    return 'No results found.';
  }

  // Override getter returning offline network connectivity failure warning details in English
  @override
  String get search_offline_error {
    // Return English offline error message
    return 'Network connection lost. Please try again.';
  }

  // Override getter returning offline failure retry action trigger label in English
  @override
  String get search_retry_button {
    // Return English retry button text
    return 'Retry';
  }

  // Override getter returning search screen page title text in English
  @override
  String get search_screen_title {
    // Return English search screen title
    return 'Search';
  }

  // Override getter returning search screen page subtitle text in English
  @override
  String get search_screen_subtitle {
    // Return English search screen subtitle
    return 'Find doctors, clinics, specialties and more';
  }

  // Override getter returning search screen text field placeholder hint text in English
  @override
  String get search_screen_hint {
    // Return English search screen hint
    return 'Find a Doctor, Specialty, Clinic, Hospital, Lab or Pharmacy';
  }

  // Override getter returning search screen location filter default selection value in English
  @override
  String get search_location_default {
    // Return English default location filter
    return 'Cairo, Egypt';
  }

  // Override getter returning search screen specialty filter default selection value in English
  @override
  String get search_specialty_default {
    // Return English default specialty filter
    return 'All Specialties';
  }

  // Override getter returning advanced filters bottom sheet title in English
  @override
  String get search_filter_title {
    return 'Advanced Filters';
  }

  // Override getter returning advanced filters gender section title in English
  @override
  String get search_filter_gender_title {
    return 'Doctor Gender';
  }

  // Override getter returning advanced filters gender Male option in English
  @override
  String get search_filter_gender_male {
    return 'Male';
  }

  // Override getter returning advanced filters gender Female option in English
  @override
  String get search_filter_gender_female {
    return 'Female';
  }

  // Override getter returning advanced filters price section title in English
  @override
  String get search_filter_price_title {
    return 'Consultation Fee';
  }

  // Override getter returning advanced filters price option: Under 100 EGP in English
  @override
  String get search_filter_price_under_100 {
    return 'Under 100 EGP';
  }

  // Override getter returning advanced filters price option: 100 - 200 EGP in English
  @override
  String get search_filter_price_100_200 {
    return '100 - 200 EGP';
  }

  // Override getter returning advanced filters price option: 200 - 500 EGP in English
  @override
  String get search_filter_price_200_500 {
    return '200 - 500 EGP';
  }

  // Override getter returning advanced filters price option: Above 500 EGP in English
  @override
  String get search_filter_price_above_500 {
    return 'Above 500 EGP';
  }

  // Override getter returning advanced filters rating section title in English
  @override
  String get search_filter_rating_title {
    return 'Doctor Rating';
  }

  // Override getter returning advanced filters rating option: 5 Stars in English
  @override
  String get search_filter_rating_5 {
    return '5 Stars';
  }

  // Override getter returning advanced filters rating option: 4 Stars & Above in English
  @override
  String get search_filter_rating_4 {
    return '4 Stars & Above';
  }

  // Override getter returning advanced filters rating option: 3 Stars & Above in English
  @override
  String get search_filter_rating_3 {
    return '3 Stars & Above';
  }

  // Override getter returning advanced filters reset action button label in English
  @override
  String get search_filter_reset {
    return 'Reset';
  }

  // Override getter returning advanced filters apply action button label in English
  @override
  String get search_filter_apply {
    return 'Apply Filters';
  }

  // Override getter returning sort bottom sheet title in English
  @override
  String get search_sort_title {
    return 'Sort by';
  }

  // Override getter returning recently added sort option label in English
  @override
  String get search_sort_recently_added {
    return 'Recently Added';
  }

  // Override getter returning recently added sort option description in English
  @override
  String get search_sort_recently_added_desc {
    return 'Show doctors you added most recently';
  }

  // Override getter returning name A-Z sort option label in English
  @override
  String get search_sort_name_a_to_z {
    return 'Name: A to Z';
  }

  // Override getter returning name A-Z sort option description in English
  @override
  String get search_sort_name_a_to_z_desc {
    return 'Sort doctors by name from A to Z';
  }

  // Override getter returning name Z-A sort option label in English
  @override
  String get search_sort_name_z_to_a {
    return 'Name: Z to A';
  }

  // Override getter returning name Z-A sort option description in English
  @override
  String get search_sort_name_z_to_a_desc {
    return 'Sort doctors by name from Z to A';
  }

  // Override getter returning rating high-to-low sort option label in English
  @override
  String get search_sort_rating_high_to_low {
    return 'Rating: High to Low';
  }

  // Override getter returning rating high-to-low sort option description in English
  @override
  String get search_sort_rating_high_to_low_desc {
    return 'Sort doctors by highest rating first';
  }

  // Override getter returning fee low-to-high sort option label in English
  @override
  String get search_sort_fee_low_to_high {
    return 'Consultation Fee: Low to High';
  }

  // Override getter returning fee low-to-high sort option description in English
  @override
  String get search_sort_fee_low_to_high_desc {
    return 'Sort from lowest fee to highest';
  }

  // Override getter returning fee high-to-low sort option label in English
  @override
  String get search_sort_fee_high_to_low {
    return 'Consultation Fee: High to Low';
  }

  // Override getter returning fee high-to-low sort option description in English
  @override
  String get search_sort_fee_high_to_low_desc {
    return 'Sort from highest fee to lowest';
  }

  // Override getter returning available today status indicator in English
  @override
  String get search_doctor_available_today {
    return 'Available Today';
  }

  // Override getter returning unavailable today status indicator in English
  @override
  String get search_doctor_unavailable_today {
    return 'Unavailable Today';
  }

  // Override getter returning booking CTA button label in English
  @override
  String get search_doctor_book_now {
    return 'Book Now';
  }

  // Override getter returning doctor reviews label text in English
  @override
  String get search_doctor_reviews {
    return 'reviews';
  }
}

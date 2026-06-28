/*
 * File Name: app_localizations_en.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: 1.0.0
 * Dependencies:
 *   - package:flutter/material.dart
 *   - package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: English concrete implementation of localizations containing only onboarding strings.
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
      'Find trusted healthcare and book your appointment in just a few taps.', // Page 1 description
      'Track your real-time queue and get updates so you always know when it\'s your turn.', // Page 2 description
      'All your records, payments and reminders — all in one safe place.', // Page 3 description
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
}

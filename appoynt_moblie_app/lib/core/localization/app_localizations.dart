/*
 * File Name: app_localizations.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description: Defines the abstract contract for application-wide custom localizations.
 */

// Importing standard material package for BuildContext and Locale
import 'package:flutter/material.dart';

// Abstract class defining localization dictionary schema for the app
abstract class AppLocalizations {
  // Locale property indicating the active language settings
  final Locale locale;

  // Constructor mapping the active locale instance variable
  AppLocalizations(this.locale);

  // Method to look up and retrieve active localization from widget tree context
  static AppLocalizations of(BuildContext context) {
    // Return localized resource context lookup result using standard widgets lookup
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Boolean helper getter to check if active locale language code is Arabic
  bool get is_arabic {
    // Perform Yoda condition comparison to check if language code is ar
    return 'ar' == locale.languageCode;
  }

  // Abstract getter for the Skip button label
  String get skip;

  // Abstract getter for the Next button label
  String get next;

  // Abstract getter for the Get Started button label
  String get get_started;

  // Abstract getter for the onboarding page title prefixes
  List<String> get onboarding_titles_prefix;

  // Abstract getter for the onboarding page title accent words
  List<String> get onboarding_titles_accent;

  // Abstract getter for the onboarding page subtitles list
  List<String> get onboarding_subtitles;

  // Abstract getter for English language code label
  String get language_code_en;

  // Abstract getter for English language full name label
  String get language_name_en;

  // Abstract getter for Arabic language code label
  String get language_code_ar;

  // Abstract getter for Arabic language full name label
  String get language_name_ar;

  // Abstract getter for password rules header label
  String get password_must;

  // Abstract getter for password strength tracker indicator label
  String get password_strength;

  // Abstract getter for weak strength password state label
  String get strength_weak;

  // Abstract getter for medium strength password state label
  String get strength_medium;

  // Abstract getter for strong strength password state label
  String get strength_strong;

  // Abstract getter for too short password validation message label
  String get too_short;

  // Abstract getter for minimum character length password rule label
  String get password_rule_min_length;

  // Abstract getter for uppercase character password rule label
  String get password_rule_uppercase;

  // Abstract getter for lowercase character password rule label
  String get password_rule_lowercase;

  // Abstract getter for digit number password rule label
  String get password_rule_number;

  // Abstract getter for special character password rule label
  String get password_rule_special;

  // Abstract getter for prohibiting Arabic characters password rule label
  String get password_rule_no_arabic;

  // Abstract getter for welcome back title label
  String get welcome_back;

  // Abstract getter for login panel helper description label
  String get login_subtitle;

  // Abstract getter for combined email or phone input label
  String get email_or_phone;

  // Abstract getter for combined email or phone hint label
  String get enter_email_or_phone;

  // Abstract getter for standalone email label
  String get email;

  // Abstract getter for standalone phone number label
  String get phone;

  // Abstract getter for standalone password label
  String get password;

  // Abstract getter for forgot password link button label
  String get forgot_password;

  // Abstract getter for login action button label
  String get login;

  // Abstract getter for guest sign up prompt label
  String get no_account;

  // Abstract getter for register sign up link label
  String get sign_up;

  // Abstract getter for blank input field validation error label
  String get field_required;

  // Abstract getter for invalid email format validation error label
  String get invalid_email;

  // Abstract getter for invalid phone number format validation error label
  String get invalid_phone;

  // Abstract getter for register title label
  String get register_title;

  // Abstract getter for register subtitle description label
  String get register_subtitle;

  // Abstract getter for first name input label
  String get first_name_label;

  // Abstract getter for first name placeholder hint
  String get first_name_hint;

  // Abstract getter for last name input label
  String get last_name_label;

  // Abstract getter for last name placeholder hint
  String get last_name_hint;

  // Abstract getter for email input hint
  String get email_hint;

  // Abstract getter for phone number input hint
  String get phone_hint;

  // Abstract getter for password input hint
  String get password_hint;

  // Abstract getter for confirmation password input label
  String get confirm_password;

  // Abstract getter for confirmation password placeholder hint
  String get confirm_password_hint;

  // Abstract getter for terms and conditions agreement sentence prefix
  String get agree_to_terms;

  // Abstract getter for terms and conditions action link label
  String get terms_and_conditions;

  // Abstract getter for general language and connector word
  String get and_connector;

  // Abstract getter for privacy policy action link label
  String get privacy_policy;

  // Abstract getter for existing account sign in prompt question
  String get have_account;

  // Abstract getter for sign in action label link
  String get sign_in;

  // Abstract getter for register creation CTA action button label
  String get create_my_account;

  // Abstract getter for mandatory validation error on checkbox
  String get terms_must_agree;

  // Abstract getter for phone number length limits validation warning
  String get phone_max_error;

  // Abstract getter for confirmation password mismatch validation warning
  String get password_mismatch;

  // Abstract getter for verification screen title
  String get enter_your_code;

  // Abstract getter for verification screen description subtitle
  String get enter_otp_subtitle;

  // Abstract getter for resending countdown trigger link label
  String get send_code_again;

  // Abstract getter for sent code description information card text
  String get sent_code_info;

  // Abstract getter for OTP verification action button label
  String get verify;

  // Abstract getter for forgot password screen title
  String get forgot_password_title;

  // Abstract getter for forgot password screen subtitle instruction
  String get forgot_password_subtitle;

  // Abstract getter for forgot password trigger button label
  String get send_code;
}

// Defining a short alias for clean and simple type references
typedef AppStrings = AppLocalizations;

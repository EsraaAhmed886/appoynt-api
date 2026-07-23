/*
 * File Name: app_localizations.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
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

  // Abstract getter for name length limits validation error label
  String get name_length_error;

  // Abstract getter for only-letters-allowed name validation error label
  String get name_letters_only_error;

  // Abstract getter for phone number exact length validation warning label
  String get phone_must_be_11_digits;

  // Abstract getter for phone number starting characters validation warning label
  String get phone_must_start_01;

  // Abstract getter for phone operator validation error label
  String get phone_invalid_operator;

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

  // Abstract getter for reset password confirmation button label
  String get update_password;

  // Abstract getter for reset password screen title
  String get create_new_password;

  // Abstract getter for reset password screen description subtitle
  String get reset_password_subtitle;

  // Abstract getter for reset password input field label
  String get new_password_label;

  // Abstract getter for reset password input placeholder hint
  String get new_password_hint;

  // Abstract getter for account created success screen title
  String get account_created_success;

  // Abstract getter for welcome greeting message
  String get welcome_to_appoynt;

  // Abstract getter for automatic redirect loader label
  String get redirecting_automatically;

  // Abstract parameterized method for home redirection timer description text
  String going_to_home_in(int seconds);

  // Abstract getter for skip manual button label
  String get go_to_home;

  // Abstract getter for password reset successfully screen title
  String get password_reset_success_title;

  // Abstract getter for password reset successfully screen description
  String get password_reset_success_body;

  // Abstract getter for redirecting to login page button label
  String get go_to_login;

  // Abstract getter for no internet error screen title
  String get no_internet_title;

  // Abstract getter for no internet screen instructions subtitle
  String get no_internet_sub;

  // Abstract getter for retry reconnection trigger button label
  String get retry;

  // Abstract getter for password maximum length validation warning
  String get password_too_long;

  // TODO: START OF DUMMY HOME SCREEN LOCALIZATION GETTERS - REMOVE ONCE FINAL HOME IS COMPLETED
  // Abstract getter for bottom navigation home label
  String get dummy_home_tab_label;

  // Abstract getter for bottom navigation appointments label
  String get dummy_appointments_tab_label;

  // Abstract getter for bottom navigation search label
  String get dummy_search_tab_label;

  // Abstract getter for bottom navigation favorites label
  String get dummy_favorite_tab_label;

  // Abstract getter for bottom navigation queue label
  String get dummy_queue_tab_label;

  // Abstract getter for bottom navigation records label
  String get dummy_records_tab_label;

  // Abstract getter for bottom navigation profile label
  String get dummy_profile_tab_label;

  // Abstract getter for greeting time welcome text
  String get dummy_good_morning;

  // Abstract getter for welcome banner subtitle text
  String get dummy_welcome_to_appoynt_home;

  // Abstract getter for search field placeholder hint text
  String get dummy_search_hint;

  // Abstract getter for book appointment action button label
  String get dummy_book_appointment;

  // Abstract getter for queue status action button label
  String get dummy_my_queue;

  // Abstract getter for video call action button label
  String get dummy_video_consult;

  // Abstract getter for medical records action button label
  String get dummy_my_records;

  // Abstract getter for appointment banner title label
  String get dummy_next_appointment;

  // Abstract getter for primary physician name
  String get dummy_dr_ahmed_hassan;

  // Abstract getter for physician specialty and timing details
  String get dummy_general_medicine_today;

  // Abstract getter for view details navigation button label
  String get dummy_view_details;

  // Abstract getter for specialty categorization header label
  String get dummy_specialties;

  // Abstract getter for view all items navigation link label
  String get dummy_see_all;

  // Abstract getter for cardiology specialty category name
  String get dummy_cardiology;

  // Abstract getter for neurology specialty category name
  String get dummy_neurology;

  // Abstract getter for pediatrics specialty category name
  String get dummy_pediatrics;

  // Abstract getter for ophthalmology specialty category name
  String get dummy_eye_care;

  // Abstract getter for orthopedic specialty category name
  String get dummy_orthopedic;

  // Abstract getter for featured physicians header label
  String get dummy_top_doctors;

  // Abstract getter for cardiologist practitioner name
  String get dummy_dr_sarah_johnson;

  // Abstract getter for cardiologist specialty title
  String get dummy_cardiologist;

  // Abstract getter for cardiology practice length details
  String get dummy_years_experience_sarah;

  // Abstract getter for neurologist practitioner name
  String get dummy_dr_mohammed_ali;

  // Abstract getter for neurologist specialty title
  String get dummy_neurologist;

  // Abstract getter for neurology practice length details
  String get dummy_years_experience_mohammed;

  // Abstract getter for pediatrician practitioner name
  String get dummy_dr_fatima_ahmed;

  // Abstract getter for pediatrician specialty title
  String get dummy_pediatrician;

  // Abstract getter for pediatrics practice length details
  String get dummy_years_experience_fatima;

  // Abstract getter for appointment book action trigger label
  String get dummy_book;

  // Abstract getter for feature under construction info label
  String get dummy_coming_soon;
  // TODO: END OF DUMMY HOME SCREEN LOCALIZATION GETTERS

  // Abstract getter for search filter chip location label text
  String get search_location_chip;

  // Abstract getter for search filter chip specialty label text
  String get search_specialty_chip;

  // Abstract getter for uppercase recent searches section label title
  String get search_recent_searches_title;

  // Abstract getter for recent search history clear list trigger label text
  String get search_clear_action;

  // Abstract getter for recent search history clear confirmation modal warning
  String get search_clear_all_confirm_title;

  // Abstract getter for alert modal cancel action button label
  String get search_cancel_button;

  // Abstract getter for alert modal confirm clear action button label
  String get search_clear_all_button;

  // Abstract getter for search screen page title text
  String get search_screen_title;

  // Abstract getter for search screen page subtitle text
  String get search_screen_subtitle;

  // Abstract getter for search screen text field placeholder hint text
  String get search_screen_hint;

  // Abstract getter for search screen location filter default selection value
  String get search_location_default;

  // Abstract getter for search screen specialty filter default selection value
  String get search_specialty_default;

  // Abstract getter for suggestions card list view all results trigger label text
  String get search_view_all_results;

  // Abstract getter for filters-only state primary action button label
  String get search_view_all_filtered_results;

  // Abstract getter for bottom navigation profile tab label
  String get search_tab_profile;

  // Abstract getter for bottom navigation appointment tab label
  String get search_tab_appointment;

  // Abstract getter for bottom navigation search tab label
  String get search_tab_search;

  // Abstract getter for bottom navigation favorites tab label
  String get search_tab_favorites;

  // Abstract getter for bottom navigation home tab label
  String get search_tab_home;

  // Abstract getter for autocomplete empty matching results indicator text label
  String get search_no_results;

  // Abstract getter for offline network connectivity failure warning details
  String get search_offline_error;

  // Abstract getter for offline failure retry action trigger label
  String get search_retry_button;

  // Abstract getter for advanced filters bottom sheet title
  String get search_filter_title;

  // Abstract getter for advanced filters gender section title
  String get search_filter_gender_title;

  // Abstract getter for advanced filters gender Male option
  String get search_filter_gender_male;

  // Abstract getter for advanced filters gender Female option
  String get search_filter_gender_female;

  // Abstract getter for advanced filters price section title
  String get search_filter_price_title;

  // Abstract getter for advanced filters price option: Under 100 EGP
  String get search_filter_price_under_100;

  // Abstract getter for advanced filters price option: 100 - 200 EGP
  String get search_filter_price_100_200;

  // Abstract getter for advanced filters price option: 200 - 500 EGP
  String get search_filter_price_200_500;

  // Abstract getter for advanced filters price option: Above 500 EGP
  String get search_filter_price_above_500;

  // Abstract getter for advanced filters rating section title
  String get search_filter_rating_title;

  // Abstract getter for advanced filters rating option: 5 Stars
  String get search_filter_rating_5;

  // Abstract getter for advanced filters rating option: 4 Stars & Above
  String get search_filter_rating_4;

  // Abstract getter for advanced filters rating option: 3 Stars & Above
  String get search_filter_rating_3;

  // Abstract getter for advanced filters reset action button label
  String get search_filter_reset;

  // Abstract getter for advanced filters apply action button label
  String get search_filter_apply;

  // Abstract getter for sort bottom sheet title
  String get search_sort_title;

  // Abstract getter for recently added sort option label
  String get search_sort_recently_added;

  // Abstract getter for recently added sort option description
  String get search_sort_recently_added_desc;

  // Abstract getter for name A-Z sort option label
  String get search_sort_name_a_to_z;

  // Abstract getter for name A-Z sort option description
  String get search_sort_name_a_to_z_desc;

  // Abstract getter for name Z-A sort option label
  String get search_sort_name_z_to_a;

  // Abstract getter for name Z-A sort option description
  String get search_sort_name_z_to_a_desc;

  // Abstract getter for rating high-to-low sort option label
  String get search_sort_rating_high_to_low;

  // Abstract getter for rating high-to-low sort option description
  String get search_sort_rating_high_to_low_desc;

  // Abstract getter for fee low-to-high sort option label
  String get search_sort_fee_low_to_high;

  // Abstract getter for fee low-to-high sort option description
  String get search_sort_fee_low_to_high_desc;

  // Abstract getter for fee high-to-low sort option label
  String get search_sort_fee_high_to_low;

  // Abstract getter for fee high-to-low sort option description
  String get search_sort_fee_high_to_low_desc;

  // Abstract getter for available today status indicator
  String get search_doctor_available_today;

  // Abstract getter for unavailable today status indicator
  String get search_doctor_unavailable_today;

  // Abstract getter for booking CTA button label
  String get search_doctor_book_now;

  // Abstract getter for doctor reviews label text
  String get search_doctor_reviews;

  // Patient Profile Localizations
  String get profile_title;
  String get profile_change_photo;
  String get profile_personal_information;
  String get profile_personal_information_subtitle;
  String get profile_medical_history;
  String get profile_account_settings;
  String get profile_height;
  String get profile_weight;
  String get profile_allergies;
  String get profile_medications;
  String get profile_tests_results;
  String get profile_chronic_conditions;
  String get profile_insurance_details;
  String get profile_no_allergies;
  String get profile_zero_prescriptions;
  String get profile_zero_conditions;
  String get profile_zero_insurance;
  String get profile_update_profile_button;
  String get profile_save_button;
  String get profile_cancel_button;
  String get profile_contact_section;
  String get profile_more_info_section;
  String get profile_smoking_section;
  String get profile_name_label;
  String get profile_phone_label;
  String get profile_birthdate_label;
  String get profile_national_id_label;
  String get profile_national_id_hint;
  String get profile_error_national_id_empty;
  String get profile_error_national_id_invalid;
  String get profile_email_label;
  String get profile_gender_label;
  String get profile_weight_label;
  String get profile_height_label;
  String get profile_gender_male;
  String get profile_gender_female;
  String get profile_gender_prefer_not;
  String get profile_smoking_yes;
  String get profile_smoking_no;
  String get profile_smoking_ex;
  String get profile_error_name_empty;
  String get profile_error_name_length;
  String get profile_error_name_letters_only;
  String get profile_error_email_empty;
  String get profile_error_email_invalid;
  String get profile_error_email_length;
  String get profile_error_email_registered;
  String get profile_error_gender_required;
  String get profile_error_address_length;
  String get profile_error_address_invalid;
  String get profile_unsaved_changes_title;
  String get profile_unsaved_changes_message;
  String get profile_unsaved_changes_stay;
  String get profile_unsaved_changes_leave;

  // Section 2: Medical Context & Permissions
  String get profile_dependents_title;
  String get profile_add_dependent_button;
  String get profile_insurance_card_title;
  String get profile_insurance_provider;
  String get profile_insurance_number;
  String get profile_insurance_expiry;

  // Section 3: Payment & Wallet Management
  String get profile_wallet_title;
  String get profile_wallet_balance;
  String get profile_wallet_priority;
  String get profile_saved_cards;
  String get profile_default_card;
  String get profile_add_card;
  String get profile_invoices_title;
  String get profile_invoice_id;
  String get profile_amount_paid;

  // Section 4: Security & Privacy Settings
  String get profile_security_privacy;
  String get profile_biometrics_toggle;
  String get profile_delete_account;
  String get profile_delete_account_confirm;
  String get profile_delete_account_warning;
  String get profile_delete_account_dialog_title;
  String get profile_face_id;

  // Section 5: App Preferences
  String get profile_notifications_title;
  String get profile_priority_payment;
  String get profile_payment_wallet;
  String get profile_support_dial_dialog_title;
  String get profile_support_dial;
  String get profile_app_preferences;
  String get profile_notifications_reminders;
  String get profile_notifications_invoices;
  String get profile_notifications_promos;
  String get profile_notifications_reminders_sub;
  String get profile_notifications_invoices_sub;
  String get profile_notifications_promos_sub;
  String get profile_language_row;
  String get profile_language_sub;
  String get profile_theme_row;
  String get profile_theme_sub;
  String get profile_theme_light;
  String get profile_theme_dark;
  String get profile_theme_system;
  String get profile_support_legal_title;
  String get profile_support_legal_sub;
  String get profile_support_terms;
  String get profile_support_terms_sub;
  String get profile_support_privacy;
  String get profile_support_privacy_sub;
  String get profile_support_hotline;
  String get profile_support_hotline_sub;
  String get profile_terms_modal_title;
  String get profile_privacy_modal_title;
  String get profile_terms_content;
  String get profile_privacy_content;
  String get profile_close_button;

  // Section 6: Log Out
  String get profile_logout_confirm_title;
  String get profile_logout_confirm_message;
  String get profile_logout_confirm_yes;
  String get profile_logout_confirm_no;
  String get profile_logout_sub;

  // Change Password Localizations
  String get password_change_title;
  String get password_current_label;
  String get password_new_label;
  String get password_confirm_label;
  String get password_current_empty;
  String get password_current_incorrect;
  String get password_new_empty;
  String get password_new_length;
  String get password_new_complexity;
  String get password_new_unsupported;
  String get password_new_personal_info;
  String get password_new_same_as_current;
  String get password_new_pattern;
  String get password_confirm_empty;
  String get password_confirm_match;
  String get password_change_success_msg;
  String get profile_change_success_msg;

  // Allergies Localizations
  String get allergies_title;
  String get allergies_food_section;
  String get allergies_medication_section;
  String get allergies_add_allergy;
  String get allergies_placeholder;
  String get allergies_save_btn;
  String get allergies_update_status_btn;

  // Prescriptions Localizations
  String get prescriptions_title;
  String get prescriptions_add_btn;
  String get prescriptions_empty_title;
  String get prescriptions_empty_subtitle;
  String get prescriptions_empty_cta;
  String get prescriptions_modal_title;
  String get prescriptions_field_name_label;
  String get prescriptions_field_name_hint;
  String get prescriptions_field_freq_label;
  String get prescriptions_field_duration_label;
  String get prescriptions_field_duration_hint;
  String get prescriptions_field_doctor_label;
  String get prescriptions_field_doctor_hint;
  String get prescriptions_field_rx_label;
  String get prescriptions_freq_once;
  String get prescriptions_freq_twice;
  String get prescriptions_freq_every8;
  String get prescriptions_freq_as_needed;
  String get prescriptions_status_active;
  String get prescriptions_save_btn;
  String get prescriptions_delete_confirm_title;
  String get prescriptions_delete_confirm_body;
  String get prescriptions_delete_confirm_yes;
  String get prescriptions_delete_confirm_no;
  // Legacy keys retained for backward compatibility
  String get prescriptions_add_medication;
  String get prescriptions_added_title;

  // Tests & Results Localizations
  String get tests_title;
  String get tests_tab_lab;
  String get tests_tab_scanning;
  String get tests_no_tests_found;
  String get tests_no_scans_found;
  String get tests_add_title;
  String get tests_doc_name_label;
  String get tests_date_label;
  String get tests_select_date_btn;
  String get tests_upload_doc_btn;
  String get tests_confirm_upload_btn;
  String get tests_empty_title;
  String get tests_empty_subtitle;
  String get tests_empty_cta;
  String get tests_upload_new_cta;
  String get tests_file_attached_toast;
  String get tests_error_no_file;
  String get tests_success_upload;

  // Chronic Conditions Localizations
  String get chronic_title;
  String get chronic_description;

  // Insurance Details Localizations
  String get insurance_title;
  String get insurance_expiry_label;
  String get insurance_view_btn;
  String get insurance_add_title;
  String get insurance_card_name_label;
  String get insurance_card_number_label;
  String get insurance_select_provider_btn;
  String get insurance_upload_doc_btn;
  String get insurance_add_card_btn;
}

// Defining a short alias for clean and simple type references
typedef AppStrings = AppLocalizations;

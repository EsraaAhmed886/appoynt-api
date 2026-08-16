/*
 * File Name: app_localizations.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
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
  String get edit_profile_title;
  String get profile_first_name_label;
  String get profile_last_name_label;
  String get profile_address_label;
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
  String get profile_not_specified;
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
  String get profile_upload_photo_title;
  String get profile_take_photo_option;
  String get profile_choose_gallery_option;
  String get profile_photo_selected_success;
  String get profile_photo_pick_failed_prefix;
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
  String get environmental_seasonal_allergies;
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
  String get insurance_add_card_full_btn;
  String get insurance_save_card_btn;

  // Payment & Wallet Localizations
  String get payment_wallet_title;
  String get payment_balance_label;
  String get payment_priority_label;
  String get payment_saved_cards_tile;
  String get payment_saved_cards_subtitle;
  String get payment_history_tile;
  String get payment_history_subtitle;
  String get payment_add_money_btn;
  String get payment_active_status;
  String get payment_inactive_status;
  String get payment_default_badge;
  String get payment_cardholder_label;
  String get payment_valid_thru_label;
  String get payment_add_money_coming_soon;
  String get payment_manage_cards_title;
  String get payment_cards_count_suffix;
  String get payment_set_default_action;
  String get payment_delete_card_action;
  String get payment_card_removed_success;
  String get payment_confirm_delete_title;
  String get payment_confirm_delete_body;
  String get payment_delete_card_dialog_body_prefix;
  String get payment_delete_card_dialog_body_suffix;
  String get payment_delete_btn;
  String get payment_remove_btn;
  String get payment_cancel_btn;
  String get payment_no_saved_cards_title;
  String get payment_no_saved_cards_body;
  String get payment_add_new_card_btn;
  String get payment_invoices_history_title;
  String get payment_total_paid_invoices;
  String get payment_invoices_count_suffix;
  String get payment_date_filter_prefix;
  String get payment_amount_filter_prefix;
  String get payment_service_filter_prefix;
  String get payment_apply_filter_btn;
  String get payment_filter_date_range_title;
  String get payment_all_time_option;
  String get payment_this_month_option;
  String get payment_last_3_months_option;
  String get payment_custom_range_option;
  String get payment_filter_amount_range_title;
  String get payment_filter_service_type_title;
  String get payment_no_invoices_found_title;
  String get payment_no_invoices_found_body;
  String get payment_downloading_invoice_snack;
  String get payment_min_label;
  String get payment_max_label;

  // Add test result sub-page localizations
  String get add_test_doc_name_label;
  String get add_test_doc_name_hint;
  String get add_test_facility_label;
  String get add_test_facility_hint;
  String get add_test_date_label;
  String get add_test_date_hint;
  String get add_test_status_label;
  String get add_test_status_normal;
  String get add_test_status_abnormal;
  String get add_test_status_pending;
  String get add_test_doctor_label;
  String get add_test_doctor_hint;
  String get add_test_notes_label;
  String get add_test_notes_hint;
  String get add_test_upload_label;
  String get add_test_dropzone_text;
  String get add_test_dropzone_sub;
  String get add_test_validation_name_empty;
  String get add_test_validation_date_empty;
  String get add_test_uploaded_status;
  List<String> get month_names;

  // Add family member localizations
  String get add_member_edit_title;
  String get add_member_add_title;
  String get add_member_update_btn;
  String get add_member_save_btn;
  String get add_member_success_toast;
  String get add_member_identity_details_header;
  String get add_member_full_name_label;
  String get add_member_full_name_hint;
  String get add_member_name_empty_error;
  String get add_member_name_short_error;
  String get add_member_relationship_header;
  String get add_member_dob_header;
  String get add_member_dob_hint;
  String get add_member_required_error;
  String get add_member_gender_header;
  String get add_member_medical_bg_header;
  String get add_member_medical_bg_label;
  String get add_member_medical_bg_hint;
  String get rel_son;
  String get rel_daughter;
  String get rel_spouse;
  String get rel_parent;
  String get gender_male;
  String get gender_female;

  // Security & Privacy page localizations
  String get sec_account_title;
  String get sec_privacy_title;
  String get sec_danger_title;
  String get biometric_title;
  String get biometric_subtitle;
  String get tfa_title;
  String get tfa_enabled;
  String get tfa_disabled;
  String get change_password_label;
  String get change_password_subtitle;
  String get autolock_title;
  String get autolock_immediately;
  String get autolock_5mins;
  String get doc_access_title;
  String get doc_access_full;
  String get doc_access_request;
  String get active_devices_title;
  String get active_devices_subtitle;
  String get manage_sessions;
  String get export_data_title;
  String get export_data_subtitle;
  String get delete_account_title;
  String get delete_account_subtitle;
  String get preparing_data_export_toast;

  // Medical context count helpers
  String get_items_count_text(int count);
  String get_prescriptions_count_text(int count);
  String get_files_count_text(int count);
  String get_cards_count_text(int count);
  String get_members_count_text(int count);

  // Chronic conditions localizations
  String get chronic_remove_dialog_title;
  String chronic_remove_dialog_body(String label);
  String get chronic_cancel_btn;
  String get chronic_remove_btn;
  String get chronic_status_controlled;
  String get chronic_status_monitoring;
  String get chronic_diag_year_header;
  String get chronic_treatment_status_header;
  String get chronic_controlled_label;
  String get chronic_monitoring_label;
  String get chronic_no_conditions_label;
  String get chronic_save_btn;
  String get chronic_search_hint;
  String get chronic_saved_success_toast;
  String get_chronic_subtitle(String year, String status);

  // App preferences and other page localizations
  String get profile_select_language;
  String get profile_select_theme;
  String get profile_sec_notifications;
  String get profile_sec_display;
  String get profile_sec_support;
  String get profile_medication_reminders;
  String get profile_medication_reminders_sub;
  String get profile_calendar_sync;
  String get profile_calendar_sync_sub;
  String get profile_active_language;
  String get profile_help_center;
  String get profile_help_center_sub;
  String get profile_opening_help_center;
  String get prescriptions_edit_title;
  String get prescriptions_update_btn;
  String get login_phone_hint;
  String get date_picker_cancel;
  String get date_picker_confirm;
  List<String> get weekdays;

  // New settings and help about page keys
  String get profile_app_settings;
  String get profile_app_settings_sub;
  String get profile_help_about;
  String get profile_help_about_sub;
  String get help_about_tagline;
  String get legal_open_source;
  String get legal_open_source_sub;
  String get legal_open_source_content;

  // Authentication error localized message getters
  String get error_invalid_credentials;
  String get error_phone_empty;
  String get error_otp_invalid;
  String get error_password_too_short;
  String get error_user_not_found;
  String get error_email_already_exists;
  String get error_auth_general;

  // Network and security error localized message getters
  String get error_no_internet;
  String get error_timeout;
  String get error_ssl_handshake;
  String get error_request_cancelled;

  // Auth and access control error localized message getters
  String get error_session_expired;
  String get error_forbidden;

  // Client and business logic error localized message getters
  String get error_bad_request;
  String get error_not_found;
  String get error_conflict;
  String get error_payload_too_large;
  String get error_unprocessable;
  String get error_rate_limit;

  // System and app lifecycle error localized message getters
  String get error_app_update_required;
  String get error_server;
  String get error_maintenance;
  String get error_data_parsing;
  String get error_unknown;
  String get error_cache;

  // Static helper to map Failure message_key or legacy message strings to
  // their localized UI display values. Prioritizes failure keys over raw strings.
  static String get_localized_error(BuildContext context, String message) {
    // Look up localizations dictionary from widget tree context
    final AppLocalizations s = AppLocalizations.of(context);
    final String cleanMessage = message.trim();

    // ── Network & Security ────────────────────────────────────────────────
    if ('error_no_internet' == cleanMessage) {
      return s.error_no_internet;
    } else if ('error_timeout' == cleanMessage) {
      return s.error_timeout;
    } else if ('error_ssl_handshake' == cleanMessage) {
      return s.error_ssl_handshake;
    } else if ('error_request_cancelled' == cleanMessage) {
      return s.error_request_cancelled;
    }

    // ── Auth & Access Control ─────────────────────────────────────────────
    else if ('error_session_expired' == cleanMessage) {
      return s.error_session_expired;
    } else if ('error_forbidden' == cleanMessage) {
      return s.error_forbidden;
    }

    // ── Client & Business Logic ───────────────────────────────────────────
    else if ('error_bad_request' == cleanMessage) {
      return s.error_bad_request;
    } else if ('error_not_found' == cleanMessage) {
      return s.error_not_found;
    } else if ('error_conflict' == cleanMessage) {
      return s.error_conflict;
    } else if ('error_payload_too_large' == cleanMessage) {
      return s.error_payload_too_large;
    } else if ('error_unprocessable' == cleanMessage) {
      return s.error_unprocessable;
    } else if ('error_rate_limit' == cleanMessage) {
      return s.error_rate_limit;
    }

    // ── System & App Lifecycle ────────────────────────────────────────────
    else if ('error_app_update_required' == cleanMessage) {
      return s.error_app_update_required;
    } else if ('error_server' == cleanMessage) {
      return s.error_server;
    } else if ('error_maintenance' == cleanMessage) {
      return s.error_maintenance;
    } else if ('error_data_parsing' == cleanMessage) {
      return s.error_data_parsing;
    } else if ('error_unknown' == cleanMessage) {
      return s.error_unknown;
    } else if ('error_cache' == cleanMessage) {
      return s.error_cache;
    }

    // ── Legacy Auth String Mappings ───────────────────────────────────────
    // Map invalid credentials error using Yoda conditions
    else if ('Invalid phone number or password.' == cleanMessage ||
        'invalid_credentials' == cleanMessage ||
        'auth.login.invalid_credentials' == cleanMessage) {
      // Return localized credentials mismatch error string
      return s.error_invalid_credentials;
    }
    // Map phone empty error using Yoda conditions
    else if ('Phone number cannot be empty.' == cleanMessage ||
        'phone_empty' == cleanMessage) {
      // Return localized phone empty error string
      return s.error_phone_empty;
    }
    // Map OTP invalid error using Yoda conditions
    else if ('OTP code must be 6 digits.' == cleanMessage ||
        'otp_invalid' == cleanMessage) {
      // Return localized OTP length warning error string
      return s.error_otp_invalid;
    }
    // Map password too short error using Yoda conditions
    else if ('Password must be at least 8 characters.' == cleanMessage ||
        'password_too_short' == cleanMessage) {
      // Return localized password minimum length warning error string
      return s.error_password_too_short;
    }
    // Map user not found error using Yoda conditions
    else if ('auth.user_not_found' == cleanMessage) {
      return s.error_user_not_found;
    }
    // Map email already exists error using Yoda conditions
    else if ('auth.email_already_exists' == cleanMessage) {
      return s.error_email_already_exists;
    }
    // Map general auth errors
    else if (cleanMessage.contains('.')) {
      return s.error_auth_general;
    }
    // Fallback returning original message if no matches exist
    else {
      // Return unmodified message string
      return message;
    }
  }

  // Abstract getter for the profile photo picker bottom sheet title
  String get profile_photo_sheet_title;

  // Abstract getter for the Camera option in the profile photo picker sheet
  String get profile_photo_camera_option;

  // Abstract getter for the Gallery option in the profile photo picker sheet
  String get profile_photo_gallery_option;

  // Abstract getter for the avatar upload success SnackBar message
  String get profile_photo_upload_success;

  // Abstract getter for the avatar upload failure SnackBar fallback message
  String get profile_photo_upload_error;

  // Abstract getters for Favorites screen features
  String get favorites_title;
  String get favorites_subtitle;
  String get favorites_subtitle_universal;
  String get favorites_subtitle_doctors;
  String get favorites_subtitle_offers;
  String get favorites_subtitle_clinics;
  String get favorites_search_hint;

  String get favorites_count_single;
  String favorites_count_plural(int count);
  String get favorites_sort_by;
  String get favorites_empty_title;
  String get favorites_empty_subtitle;
  String get favorites_sort_title;
  String get favorites_sort_recently_added;
  String get favorites_sort_name_a_z;
  String get favorites_sort_name_z_a;
  String get favorites_sort_rating_high_low;
  String get favorites_sort_price_low_high;
  String get favorites_sort_price_high_low;
  String get favorites_sort_discount_high_low;
  String get favorites_apply_button;

  // Category tabs
  String get favorites_tab_doctors;
  String get favorites_tab_offers;
  String get favorites_tab_clinics;

  // Category search hints
  String get favorites_search_doctors_hint;
  String get favorites_search_offers_hint;
  String get favorites_search_clinics_hint;

  // Category empty states
  String get favorites_empty_doctors_title;
  String get favorites_empty_doctors_subtitle;
  String get favorites_empty_offers_title;
  String get favorites_empty_offers_subtitle;
  String get favorites_empty_clinics_title;
  String get favorites_empty_clinics_subtitle;
  String get favorites_empty_search_title;
  String get favorites_empty_search_subtitle;

  // Guest access prompt
  String get favorites_guest_title;
  String get favorites_guest_subtitle;
  String get favorites_guest_login_button;

  // Feedback notifications
  String get favorites_remove_success;
  String get favorites_remove_error;
  String get favorites_refresh_error;

  // Badges & Action CTAs
  String get favorites_book_now;
  String get favorites_view_clinic;
  String get favorites_unavailable_badge;
  String get favorites_expired_badge;
  String get favorites_expires_on;
  String get favorites_off_badge;
  String favorites_reviews_count(int count);

  // ── Notifications Feature Strings ─────────────────────────
  String get notifications_page_title;
  String get notifications_mark_all_read;
  String get notifications_section_today;
  String get notifications_section_yesterday;
  String get notifications_section_earlier;
  String get notifications_empty_title;
  String get notifications_empty_subtitle;
  String get notifications_empty_cta;
  String get notifications_error_title;
  String get notifications_error_subtitle;
  String get notifications_retry_btn;
  String get notifications_unavailable_entity;
  String get notifications_marked_all_read_success;

  // Filter Chips Strings
  String get notifications_filter_all;
  String get notifications_filter_unread;
  String get notifications_filter_appointments;
  String get notifications_filter_payments;
  String get notifications_filter_prescriptions;

  // Notification Details Screen Strings
  String get notification_details_title;
  String get notification_details_section_info;
  String get notification_details_date;
  String get notification_details_time;
  String get notification_details_doctor;
  String get notification_details_location;
  String get notification_details_specialty;
  String get notification_details_amount;
  String get notification_details_transaction_id;
  String get notification_details_status;
  String get notification_details_status_completed;
  String get notification_details_status_failed;
  String get notification_details_view_appointment;
  String get notification_details_view_prescription;
  String get notification_details_add_to_calendar;
  String get notification_details_calendar_added;

  // Doctor Profile Screen Strings
  String get about_doctor;
  String get experience_label;
  String get patients_label;
  String get reviews_label;
  String get rating_label;
  String get career_and_education;
  String get education_tab;
  String get experience_tab;
  String get procedures_and_services;
  String get certificates_label;
  String get media_gallery_label;
  String get book_appointment;
  String get available_today;
  String get unavailable_today;
  String get read_more;
  String get read_less;
  String get currency_egp;
  String get years_exp;
  String get patient_reviews;
  String get clinic_tour;
  String get clinic_photo;
  String get consultation_fee_label;
}

// Defining a short alias for clean and simple type references
typedef AppStrings = AppLocalizations;


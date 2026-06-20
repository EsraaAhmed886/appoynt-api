/*
 * File Name: app_localizations.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: 1.0.0
 * Dependencies:
 *   - package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
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
}

// Defining a short alias for clean and simple type references
typedef AppStrings = AppLocalizations;

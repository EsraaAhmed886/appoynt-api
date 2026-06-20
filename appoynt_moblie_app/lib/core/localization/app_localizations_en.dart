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
}

/*
 * File Name: app_localizations_delegate.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_localizations/flutter_localizations.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations_en.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations_ar.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Delegate factory that registers and loads custom
 *   translation dictionaries based on system locale.
 */

// Importing core material framework widgets
import 'package:flutter/material.dart';
// Importing standard localizations delegates from the flutter_localizations package
import 'package:flutter_localizations/flutter_localizations.dart';
// Importing abstract localization contract schema
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Importing concrete English localization class
import 'package:appoynt_mobile_app/core/localization/app_localizations_en.dart';
// Importing concrete Arabic localization class
import 'package:appoynt_mobile_app/core/localization/app_localizations_ar.dart';

// Delegate class orchestrating translation mapping for AppLocalizations subclasses
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // Constant constructor initializing the delegate class
  const AppLocalizationsDelegate();

  // Method to check if a specific device locale is supported by our application
  @override
  bool isSupported(Locale locale) {
    // Return true if language code is either 'en' or 'ar' using standard list comparison
    return const ['en', 'ar'].contains(locale.languageCode);
  }

  // Method to load the appropriate translation dictionary subclass asynchronously
  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Switch on the locale's language code to resolve translation subclass instance
    switch (locale.languageCode) {
      // Check if language code matches Arabic locale code
      case 'ar':
        // Return the concrete Arabic localizations dictionary instance
        return AppLocalizationsAr();
      // Fallback matching default or English locale code
      case 'en':
      default:
        // Return the concrete English localizations dictionary instance
        return AppLocalizationsEn();
    }
  }

  // Method stating if delegate needs to refresh when state updates
  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    // Return false to keep delegate static across rebuilds
    return false;
  }
}

// Global list of localizations delegates required in MaterialApp initialization
const List<LocalizationsDelegate<dynamic>> app_localizations_delegates = [
  // Custom localizations delegate defined for Appoynt features
  AppLocalizationsDelegate(),
  // Global delegate mapping built-in Flutter Material translations
  GlobalMaterialLocalizations.delegate,
  // Global delegate mapping built-in Flutter Cupertino translations
  GlobalCupertinoLocalizations.delegate,
  // Global delegate mapping standard widgets layout directionality
  GlobalWidgetsLocalizations.delegate,
];

// Global list of locales officially supported by the mobile application
const List<Locale> app_supported_locales = [
  // English locale token initialization
  Locale('en'),
  // Arabic locale token initialization
  Locale('ar'),
];

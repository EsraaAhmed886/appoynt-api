/*
 * File Name: app_localizations_ar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: 1.0.0
 * Dependencies:
 *   - package:flutter/material.dart
 *   - package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Arabic concrete implementation of localizations containing only onboarding strings.
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
      'ابحث عن رعاية صحية موثوقة واحجز موعدك في بضع نقرات فقط.', // Page 1 description text in Arabic
      'تابع دورك في الوقت الفعلي واحصل على تحديثات حتى تعرف دائماً متى يحين دورك.', // Page 2 description text in Arabic
      'جميع سجلاتك ومدفوعاتك وتذكيراتك — كلها في مكان آمن واحد.', // Page 3 description text in Arabic
    ];
  }
}

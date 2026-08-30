/*
 * File Name: digit_converter_helper.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/services.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Centralized utility extension and TextInputFormatter for converting
 *   Eastern-Arabic (٠-٩) and Persian/Urdu (۰-۹) digits into standard Western-Arabic/English digits (0-9).
 */

import 'package:flutter/services.dart';

/// Extension on [String] providing instant numeral translation to standard Western digits.
extension DigitsConverterExtension on String {
  /// Converts Arabic (٠-٩) and Persian/Urdu (۰-۹) numerals to standard English digits (0-9).
  String toEnglishDigits() {
    const Map<String, String> arabicToEnglish = {
      // Eastern Arabic numerals
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
      // Extended Arabic-Indic / Persian / Urdu numerals
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    String result = this;
    arabicToEnglish.forEach((arabic, english) {
      result = result.replaceAll(arabic, english);
    });
    return result;
  }
}

/// Custom [TextInputFormatter] to automatically translate typed or pasted Arabic digits to English digits in real-time.
class ArabicToEnglishDigitsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String convertedText = newValue.text.toEnglishDigits();

    // Preserve the correct cursor position
    int selectionOffset = newValue.selection.end;
    if (selectionOffset > convertedText.length) {
      selectionOffset = convertedText.length;
    } else if (selectionOffset < 0) {
      selectionOffset = 0;
    } else {
      // Offset within valid bounds
    }

    return newValue.copyWith(
      text: convertedText,
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }
}

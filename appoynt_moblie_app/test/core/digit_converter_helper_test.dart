/*
 * File Name: digit_converter_helper_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/services.dart, package:flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/core/utils/digit_converter_helper.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Unit tests verifying digit converter extension and TextInputFormatter.
 */

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/core/utils/digit_converter_helper.dart';

void main() {
  group('DigitsConverterExtension Tests', () {
    test('converts Eastern-Arabic numerals (٠-٩) to English (0-9)', () {
      const String arabic = '٠١٢٣٤٥٦٧٨٩';
      expect(arabic.toEnglishDigits(), equals('0123456789'));
    });

    test('converts Persian/Urdu numerals (۰-۹) to English (0-9)', () {
      const String persian = '۰۱۲۳۴۵۶۷۸۹';
      expect(persian.toEnglishDigits(), equals('0123456789'));
    });

    test('converts mixed strings containing phone numbers with Arabic digits', () {
      const String mixed = '+20 ٠١٠-٢٢٧١-١٣٥٧';
      expect(mixed.toEnglishDigits(), equals('+20 010-2271-1357'));
    });

    test('leaves standard English strings intact', () {
      const String english = '01022711357';
      expect(english.toEnglishDigits(), equals('01022711357'));
    });
  });

  group('ArabicToEnglishDigitsFormatter Tests', () {
    late ArabicToEnglishDigitsFormatter formatter;

    setUp(() {
      formatter = ArabicToEnglishDigitsFormatter();
    });

    test('replaces Arabic digits on formatEditUpdate and preserves cursor offset', () {
      const oldValue = TextEditingValue(
        text: '010',
        selection: TextSelection.collapsed(offset: 3),
      );
      const newValue = TextEditingValue(
        text: '010٢٢٧',
        selection: TextSelection.collapsed(offset: 6),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, equals('010227'));
      expect(result.selection.end, equals(6));
    });

    test('handles pasting full Arabic phone number', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '٠١٠٢٢٧١١٣٥٧',
        selection: TextSelection.collapsed(offset: 11),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, equals('01022711357'));
      expect(result.selection.end, equals(11));
    });
  });
}

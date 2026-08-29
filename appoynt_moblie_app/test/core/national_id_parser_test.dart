/*
 * File Name: national_id_parser_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/core/utils/national_id_parser.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Unit tests validating gender and birthdate extraction logic
 *   for Egyptian National IDs according to official civil registry specifications.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/core/utils/national_id_parser.dart';

void main() {
  group('NationalIdParser Gender Extraction Tests', () {
    test('extracts male for odd 13th digit (1, 3, 5, 7, 9)', () {
      // 13th digit is '1' -> male
      expect(NationalIdParser.extractGender('29712050102315'), 'male');
      // 13th digit is '3' -> male
      expect(NationalIdParser.extractGender('30508078800034'), 'male');
      // 13th digit is '5' -> male
      expect(NationalIdParser.extractGender('29801010100052'), 'male');
      // 13th digit is '7' -> male
      expect(NationalIdParser.extractGender('30105151234578'), 'male');
      // 13th digit is '9' -> male
      expect(NationalIdParser.extractGender('29003200100099'), 'male');
    });

    test('extracts female for even 13th digit (0, 2, 4, 6, 8)', () {
      // 13th digit is '0' -> female
      expect(NationalIdParser.extractGender('29712050102305'), 'female');
      // 13th digit is '2' -> female
      expect(NationalIdParser.extractGender('30508078800024'), 'female');
      // 13th digit is '4' -> female
      expect(NationalIdParser.extractGender('30508078800044'), 'female');
      // 13th digit is '6' -> female
      expect(NationalIdParser.extractGender('29801010100062'), 'female');
      // 13th digit is '8' -> female
      expect(NationalIdParser.extractGender('30105151234588'), 'female');
    });

    test('returns null for invalid national ID lengths and characters', () {
      expect(NationalIdParser.extractGender(''), isNull);
      expect(NationalIdParser.extractGender('297120501023'), isNull); // 12 digits
      expect(NationalIdParser.extractGender('297120501023155'), isNull); // 15 digits
      expect(NationalIdParser.extractGender('2971205010231A'), isNull); // letters
      expect(NationalIdParser.extractGender('abcdefghijklmn'), isNull);
    });
  });

  group('NationalIdParser BirthDate Extraction Tests', () {
    test('extracts 1900s birth dates for century digit 2', () {
      // Born: 05 Dec 1997
      final DateTime? date1 = NationalIdParser.extractBirthDate('29712050102315');
      expect(date1, isNotNull);
      expect(date1!.year, 1997);
      expect(date1.month, 12);
      expect(date1.day, 5);

      // Born: 01 Jan 1980
      final DateTime? date2 = NationalIdParser.extractBirthDate('28001010102315');
      expect(date2, isNotNull);
      expect(date2!.year, 1980);
      expect(date2.month, 1);
      expect(date2.day, 1);
    });

    test('extracts 2000s birth dates for century digit 3', () {
      // Born: 07 Aug 2005
      final DateTime? date1 = NationalIdParser.extractBirthDate('30508078800044');
      expect(date1, isNotNull);
      expect(date1!.year, 2005);
      expect(date1.month, 8);
      expect(date1.day, 7);

      // Born: 15 May 2001
      final DateTime? date2 = NationalIdParser.extractBirthDate('30105151234588');
      expect(date2, isNotNull);
      expect(date2!.year, 2001);
      expect(date2.month, 5);
      expect(date2.day, 15);
    });

    test('returns null for impossible dates or invalid century prefixes', () {
      // Invalid century digit 1
      expect(NationalIdParser.extractBirthDate('19712050102315'), isNull);
      // Invalid century digit 4
      expect(NationalIdParser.extractBirthDate('49712050102315'), isNull);
      // Month 13
      expect(NationalIdParser.extractBirthDate('29713050102315'), isNull);
      // Month 00
      expect(NationalIdParser.extractBirthDate('29700050102315'), isNull);
      // Day 32
      expect(NationalIdParser.extractBirthDate('29712320102315'), isNull);
      // Feb 30 (invalid day for Feb)
      expect(NationalIdParser.extractBirthDate('29702300102315'), isNull);
    });
  });
}

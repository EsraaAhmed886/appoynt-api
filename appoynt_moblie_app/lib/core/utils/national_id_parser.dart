/*
 * File Name: national_id_parser.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:appoynt_mobile_app/core/utils/digit_converter_helper.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Utility class for validating and parsing Egyptian 14-digit National IDs
 *   to automatically extract Gender (13th digit) and Date of Birth (century + YYMMDD) with Arabic digit support.
 */

import 'package:appoynt_mobile_app/core/utils/digit_converter_helper.dart';

/// Utility class for validating and parsing 14-digit Egyptian National IDs.
class NationalIdParser {
  // Private constructor to prevent direct instantiation
  NationalIdParser._();

  /// Extracts Gender from 14-digit Egyptian National ID.
  ///
  /// Rule: The 13th digit (index 12 in 0-based indexing) denotes gender:
  /// - Odd digits (1, 3, 5, 7, 9) => 'male'
  /// - Even digits (0, 2, 4, 6, 8) => 'female'
  ///
  /// Returns `'male'`, `'female'`, or `null` if the input is invalid.
  static String? extractGender(String nationalId) {
    final String cleanedId = nationalId.trim().toEnglishDigits();
    if (cleanedId.length != 14 || !RegExp(r'^[0-9]+$').hasMatch(cleanedId)) {
      return null;
    } else {
      final int genderDigit = int.parse(cleanedId[12]);
      return (genderDigit % 2 != 0) ? 'male' : 'female';
    }
  }

  /// Extracts Birth Date from 14-digit Egyptian National ID.
  ///
  /// Century codes:
  /// - 2 => 1900-1999
  /// - 3 => 2000-2099
  ///
  /// Returns a valid [DateTime], or `null` if the ID is invalid or represents an impossible date.
  static DateTime? extractBirthDate(String nationalId) {
    final String cleanedId = nationalId.trim().toEnglishDigits();
    if (cleanedId.length != 14 || !RegExp(r'^[0-9]+$').hasMatch(cleanedId)) {
      return null;
    } else {
      final int centuryDigit = int.parse(cleanedId[0]);
      final int yearPrefix = (centuryDigit == 2) ? 1900 : (centuryDigit == 3 ? 2000 : 0);
      if (yearPrefix == 0) {
        return null;
      } else {
        final int year = yearPrefix + int.parse(cleanedId.substring(1, 3));
        final int month = int.parse(cleanedId.substring(3, 5));
        final int day = int.parse(cleanedId.substring(5, 7));

        if (month < 1 || month > 12 || day < 1 || day > 31) {
          return null;
        } else {
          try {
            final DateTime parsed = DateTime(year, month, day);
            // Double check that DateTime did not overflow (e.g. Feb 31 -> Mar 3)
            if (parsed.year == year && parsed.month == month && parsed.day == day) {
              return parsed;
            } else {
              return null;
            }
          } catch (_) {
            return null;
          }
        }
      }
    }
  }
}

/*
 * File Name: app_fonts.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: 1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Defines font family name constants and handles dynamic locale resolution for Cairo and Inter.
 */

// Utility class providing centralized registry of font family keys
class AppFonts {
  // Private constructor to prevent direct class instantiation
  AppFonts._();

  // Font family string constant for the English typeface Inter
  static const String inter = 'Inter';

  // Font family string constant for the Arabic typeface Cairo
  static const String cairo = 'Cairo';

  // Default font family design fallback representation
  static const String default_family = inter;

  // Static method returning appropriate font family based on language direction
  static String by_locale(bool is_arabic) {
    // Return cairo font key if is_arabic is true, else return inter font key using ternary condition
    return is_arabic ? cairo : inter;
  }
}

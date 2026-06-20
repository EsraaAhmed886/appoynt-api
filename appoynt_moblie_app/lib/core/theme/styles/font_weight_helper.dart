/*
 * File Name: font_weight_helper.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: 1.0.0
 * Dependencies:
 *   - package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: centralizes standard font weight constant mapping keys to ensure design system consistency.
 */

// Importing core material framework graphics libraries
import 'package:flutter/material.dart';

// Helper class containing predefined layout weights
class FontWeightHelper {
  // Private constructor to prevent direct class instantiation
  FontWeightHelper._();

  // FontWeight representation constant mapped to light weight (300)
  static const FontWeight light = FontWeight.w300;

  // FontWeight representation constant mapped to regular weight (400)
  static const FontWeight regular = FontWeight.w400;

  // FontWeight representation constant mapped to medium weight (500)
  static const FontWeight medium = FontWeight.w500;

  // FontWeight representation constant mapped to semi-bold weight (600)
  static const FontWeight semi_bold = FontWeight.w600;

  // FontWeight representation constant mapped to bold weight (700)
  static const FontWeight bold = FontWeight.w700;

  // FontWeight representation constant mapped to extra-bold weight (800)
  static const FontWeight extra_bold = FontWeight.w800;
}

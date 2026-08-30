/*
 * File Name: dark_mode.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter/services.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Defines the dark theme configuration for the Appoynt mobile application
 *   utilizing the unified Dark Slate / Charcoal palette and elevation tokens.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Importing application central color design token constants
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Defining the dark mode ThemeData configuration utilizing centralized tokens
final ThemeData dark_mode_theme = ThemeData(
  // Specifying brightness parameter as dark mode standard
  brightness: Brightness.dark,
  // Defining background color token configuration
  scaffoldBackgroundColor: AppColors.darkBackground,
  // Ensure canvasColor and cardColor adapt dynamically to Dark Mode
  canvasColor: AppColors.darkBackground,
  cardColor: AppColors.darkSurface,
  primaryColor: AppColors.primary,

  // Configuring visual elements theme extension colors
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    surface: AppColors.darkSurface,
    onPrimary: AppColors.white,
    onSurface: AppColors.darkTextPrimary,
    outline: AppColors.darkBorder,
  ),

  // Configuring navigation app bar top headers
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.transparent,
    elevation: 0.0,
    scrolledUnderElevation: 0.0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: AppColors.darkTextPrimary,
    ),
    iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),

  // Configuring global card theme
  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
      side: const BorderSide(color: AppColors.darkBorder, width: 1.0),
    ),
  ),

  // Configuring global bottom navigation bar theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.darkTextSecondary,
    type: BottomNavigationBarType.fixed,
    elevation: 8.0,
  ),

  // Configuring global input field decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    hintStyle: const TextStyle(color: AppColors.darkTextMuted, fontSize: 14.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppColors.darkBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppColors.darkBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  ),

  // Configuring global bottom sheet styles
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.transparent,
    modalBackgroundColor: AppColors.transparent,
    modalBarrierColor: AppColors.barrier_color,
    elevation: 0.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.0),
      ),
    ),
  ),

  // Configuring global dialog styles
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.darkSurface,
    barrierColor: AppColors.barrier_color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: const BorderSide(color: AppColors.darkBorder, width: 1.0),
    ),
  ),
);
// End of dark_mode.dart

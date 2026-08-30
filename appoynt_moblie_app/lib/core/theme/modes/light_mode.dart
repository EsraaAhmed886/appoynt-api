/*
 * File Name: light_mode.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Defines the light theme configuration for the Appoynt mobile application.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Importing application central color design token constants
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Defining the light mode ThemeData configuration utilizing centralized tokens
final ThemeData light_mode_theme = ThemeData(
  // Specifying brightness parameter as light mode standard
  brightness: Brightness.light,
  // Defining background color token configuration
  scaffoldBackgroundColor: AppColors.scaffold_light,
  // Ensure canvasColor and cardColor adapt dynamically to Light Mode
  canvasColor: AppColors.background_light,
  cardColor: AppColors.background_light,
  // Configuring visual elements theme extension colors
  colorScheme: const ColorScheme.light(
    // Setting primary color scheme token mapping
    primary: AppColors.primary_color,
    // Setting surface containers scheme token mapping
    surface: AppColors.surface_light,
  ),
  // Configuring navigation app bar top headers
  appBarTheme: const AppBarTheme(
    // Setting app bar background color token mapping
    backgroundColor: AppColors.transparent,
    // Setting elevated shadow height as zero to keep layout flat
    elevation: 0.0,
    // Prevents Material3 scroll surface tinting
    scrolledUnderElevation: 0.0,
    // Ensure titles are consistently centered
    centerTitle: true,
    // Setting foreground content color standard (text & icons)
    foregroundColor: AppColors.text_light_primary,
    // System overlay configuration for transparent status bar with dark icons
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
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
  dialogTheme: const DialogThemeData(
    barrierColor: AppColors.barrier_color,
  ),
);
// End of light_mode.dart

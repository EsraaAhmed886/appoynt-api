/*
 * File Name: route_export.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.0.0
 * Dependencies: flutter/material.dart,
 *   package:appoynt_mobile_app/constants/app_assets.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/theme/modes/light_mode.dart,
 *   package:appoynt_mobile_app/core/theme/modes/dark_mode.dart,
 *   package:appoynt_mobile_app/core/theme/modes/theme_mode.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
 * File Description: Acts as a central global barrel file for the
 *   application's foundational UI layer.
 */

// Exporting standard material library framework for UI components
export 'package:flutter/material.dart';

// Exporting central application asset definition paths constant class
export 'package:appoynt_mobile_app/constants/app_assets.dart';

// Exporting centralized application spacing and layout dimension tokens
export 'package:appoynt_mobile_app/constants/app_spacing.dart';

// Exporting central application color definition tokens and palettes
export 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Exporting configured light mode theme data settings
export 'package:appoynt_mobile_app/core/theme/modes/light_mode.dart';

// Exporting configured dark mode theme data settings
export 'package:appoynt_mobile_app/core/theme/modes/dark_mode.dart';

// Exporting state manager notifier class for dynamic theme switching
export 'package:appoynt_mobile_app/core/theme/modes/theme_mode.dart';

// Exporting custom localizations contract class for text dictionaries
export 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

// Exporting custom localizations delegate configurations for MaterialApp init
export 'package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart';

// Exporting app fonts configuration registry
export 'package:appoynt_mobile_app/core/theme/styles/app_fonts.dart';

// Exporting font weight helper mapping constants
export 'package:appoynt_mobile_app/core/theme/styles/font_weight_helper.dart';

// Exporting centralized application text styles registry
export 'package:appoynt_mobile_app/core/theme/styles/app_text_styles.dart';

// Exporting dynamic global configuration state manager cubit
export 'package:appoynt_mobile_app/core/logic/global_cubit.dart';

// TODO: START OF DUMMY HOME SCREEN EXPORT - REMOVE ONCE FINAL HOME IS COMPLETED
// Exporting temporary dummy home page layout widget representation
export 'package:appoynt_mobile_app/features/home/presentation/pages/home_page.dart';
// Exporting reusable bottom navigation bar component
export 'package:appoynt_mobile_app/core/widgets/app_bottom_nav_bar.dart';
// Exporting custom profile app bar component
export 'package:appoynt_mobile_app/core/widgets/custom_profile_app_bar.dart';
// Exporting shared insurance card widgets
export 'package:appoynt_mobile_app/core/widgets/insurance_card_widget.dart';
// Exporting sticky bottom bar component
export 'package:appoynt_mobile_app/core/widgets/sticky_bottom_bar.dart';
// TODO: END OF DUMMY HOME SCREEN EXPORT
// Exporting dedicated search page widget representation
export 'package:appoynt_mobile_app/features/search/presentation/pages/search_page.dart';
// End of route_export.dart

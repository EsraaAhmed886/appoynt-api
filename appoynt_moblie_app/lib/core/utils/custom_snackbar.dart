/*
 * File Name: custom_snackbar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 27/08/2026
 * Version Information: V1.1.0
 * Dependencies: flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 27/08/2026]
 * File Description: Centralized floating SnackBar utility supporting success, error,
 *   warning, and info message types with standardized bottom clearance without double-margin stacking.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

/// Supported notification feedback types for standardized appearance
enum SnackBarType {
  success,
  error,
  warning,
  info,
}

/// Global centralized SnackBar helper providing standardized floating feedback notifications
class CustomSnackBar {
  // Private constructor to prevent direct instantiation
  CustomSnackBar._();

  /// Reduced default bottom margin (12.0) so SnackBar sits right above the bottom navigation bar
  static const double default_bottom_margin = 12.0;

  /// Standard border radius for floating snackbars
  static const double border_radius = 12.0;

  /// Standard elevation for subtle floating depth
  static const double elevation = 4.0;

  /// Shows a custom styled floating SnackBar matching the design system
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    if (false == context.mounted) {
      return;
    } else {
      // Context is mounted
    }

    final Color background_color;
    final IconData icon_data;

    switch (type) {
      case SnackBarType.success:
        background_color = AppColors.success;
        icon_data = Icons.check_circle_outline_rounded;
        break;
      case SnackBarType.error:
        background_color = AppColors.error;
        icon_data = Icons.error_outline_rounded;
        break;
      case SnackBarType.warning:
        background_color = AppColors.amber;
        icon_data = Icons.warning_amber_rounded;
        break;
      case SnackBarType.info:
      default:
        background_color = AppColors.primary_color;
        icon_data = Icons.info_outline_rounded;
        break;
    }

    final SnackBar snack_bar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon_data,
            color: AppColors.white,
            size: 20.0,
          ),
          const SizedBox(width: AppSpacing.space_s),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: background_color,
      behavior: SnackBarBehavior.floating,
      elevation: elevation,
      duration: duration,
      margin: EdgeInsets.only(
        left: AppSpacing.space_xl,
        right: AppSpacing.space_xl,
        bottom: bottomMargin,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(border_radius),
      ),
      action: null != actionLabel
          ? SnackBarAction(
              label: actionLabel,
              textColor: AppColors.white,
              onPressed: onAction ?? () {},
            )
          : null,
    );

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(snack_bar);
  }

  /// Convenience shortcut for displaying a success SnackBar
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      bottomMargin: bottomMargin,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Convenience shortcut for displaying an error SnackBar
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      bottomMargin: bottomMargin,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Convenience shortcut for displaying a warning SnackBar
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      bottomMargin: bottomMargin,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Convenience shortcut for displaying an informational SnackBar
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      bottomMargin: bottomMargin,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }
}

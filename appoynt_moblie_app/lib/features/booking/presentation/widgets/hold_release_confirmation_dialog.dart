/*
 * File Name: hold_release_confirmation_dialog.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: PopScope alert dialog prompting patients before navigating away
 *   from an active slot reservation hold to prevent unintentional slot release.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens and colors
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

/// Confirmation dialog for releasing an active slot hold.
class HoldReleaseConfirmationDialog extends StatelessWidget {
  const HoldReleaseConfirmationDialog({super.key});

  /// Static helper to display the dialog.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialog_context) => const HoldReleaseConfirmationDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return AlertDialog(
      backgroundColor: is_dark ? AppColors.surface_dark : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.amber,
              size: 22.0,
            ),
          ),
          const SizedBox(width: AppSpacing.space_m),
          Text(
            localizations.release_slot_hold_title,
            style: TextStyle(
              fontSize: AppSpacing.font_size_dialog_title,
              fontWeight: FontWeight.w700,
              color: is_dark
                  ? AppColors.text_dark_primary
                  : AppColors.text_light_primary,
            ),
          ),
        ],
      ),
      content: Text(
        localizations.release_slot_hold_msg,
        style: TextStyle(
          fontSize: AppSpacing.font_size_body_small,
          height: 1.4,
          color: is_dark
              ? AppColors.text_dark_secondary
              : AppColors.text_light_secondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            localizations.stay_action,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: is_dark
                  ? AppColors.text_dark_secondary
                  : AppColors.text_light_secondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(localizations.leave_and_release_action),
        ),
      ],
    );
  }
}

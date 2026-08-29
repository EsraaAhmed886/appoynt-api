/*
 * File Name: edit_profile_body.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Widget rendering dynamic auto-detected Date of Birth and Gender Info Badges
 *   underneath Egyptian National ID input field with smooth AnimatedCrossFade transitions.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

/// Compact auto-detected Date of Birth and Gender badge widget.
class NationalIdInfoBadges extends StatelessWidget {
  /// The extracted birth date DateTime object
  final DateTime? birthDate;

  /// The extracted gender string ('male' or 'female')
  final String? gender;

  /// Constructor
  const NationalIdInfoBadges({
    super.key,
    required this.birthDate,
    required this.gender,
  });

  String _formatDisplayDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String day = date.day.toString().padLeft(2, '0');
    final String month = months[date.month - 1];
    return '$day $month ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations loc = AppLocalizations.of(context);
    final bool isVisible = birthDate != null && gender != null;

    return AnimatedCrossFade(
      firstChild: const SizedBox(width: double.infinity),
      secondChild: isVisible
          ? Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Birth Date Badge
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cake_outlined,
                              size: 16.0,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6.0),
                            Flexible(
                              child: Text(
                                _formatDisplayDate(birthDate!),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.slate800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        height: 16.0,
                        width: 1.0,
                        color: AppColors.primary.withValues(alpha: 0.3),
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),

                      // Gender Badge
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              gender!.toLowerCase() == 'female'
                                  ? Icons.female_rounded
                                  : Icons.male_rounded,
                              size: 17.0,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              gender!.toLowerCase() == 'female'
                                  ? loc.profile_gender_female
                                  : loc.profile_gender_male,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.slate800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 12.0,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.slate400,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        loc.auto_detected_from_national_id,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.slate500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox(width: double.infinity),
      crossFadeState: isVisible
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
    );
  }
}

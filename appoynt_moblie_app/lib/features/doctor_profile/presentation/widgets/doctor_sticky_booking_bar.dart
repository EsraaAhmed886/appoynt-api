/*
 * File Name: doctor_sticky_booking_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Modern full-width floating sticky bottom bar for booking,
 *   featuring full-width button layout with localized text and standardized dark slate theme.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Sticky bottom booking bar widget with full-width CTA button.
class DoctorStickyBookingBar extends StatelessWidget {
  // Doctor profile entity
  final DoctorProfileEntity profile;
  // Booking action callback
  final VoidCallback? on_book_pressed;

  // Constant constructor
  const DoctorStickyBookingBar({
    super.key,
    required this.profile,
    this.on_book_pressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.space_xl,
        AppSpacing.space_m,
        AppSpacing.space_xl,
        MediaQuery.of(context).padding.bottom + AppSpacing.space_m,
      ),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.darkSurface : AppColors.background_light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radius_xxl),
          topRight: Radius.circular(AppSpacing.radius_xxl),
        ),
        border: Border(
          top: BorderSide(
            color: is_dark ? AppColors.darkBorder : AppColors.slate200,
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? AppColors.black.withValues(alpha: 0.5)
                : AppColors.slate_200.withValues(alpha: 0.8),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52.0,
        child: ElevatedButton(
          onPressed: on_book_pressed ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary_color,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 18.0,
                color: AppColors.white,
              ),
              const SizedBox(width: AppSpacing.space_m),
              Text(
                localizations.book_appointment,
                style: const TextStyle(
                  fontSize: AppSpacing.font_size_text,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

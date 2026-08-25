/*
 * File Name: doctor_review_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/08/2026]
 * File Description: Modern aesthetic patient review card component featuring patient
 *   avatar/initials, verified patient badge, relative date, star rating, and expandable review text.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Modern aesthetic patient review card widget.
class DoctorReviewCard extends StatefulWidget {
  // Review entity model
  final DoctorReviewEntity review;

  // Constant constructor
  const DoctorReviewCard({
    super.key,
    required this.review,
  });

  @override
  State<DoctorReviewCard> createState() {
    return _DoctorReviewCardState();
  }
}

class _DoctorReviewCardState extends State<DoctorReviewCard> {
  // Expandable comment text toggle state
  bool _is_expanded = false;

  String _get_initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return 'P';
    } else if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final DoctorReviewEntity review = widget.review;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space_m),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.inner_container_dark : AppColors.slate_50,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: is_dark
              ? AppColors.border_dark
              : AppColors.slate_200.withValues(alpha: 0.8),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header: Avatar, Name + Verified Badge, and Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Patient Initials Avatar
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary_color.withValues(alpha: 0.8),
                      AppColors.primary_color,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _get_initials(review.patient_name),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),

              // Patient Name & Verified Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patient_name,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_small + 1.0,
                        fontWeight: FontWeight.w700,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 13.0,
                          color: AppColors.dummy_custom_green,
                        ),
                        const SizedBox(width: 3.0),
                        Text(
                          localizations.verified_patient,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.dummy_custom_green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Review Date
              Text(
                review.date,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_caption,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_m),

          // 2. Star Rating Score
          Row(
            children: [
              ...List.generate(5, (star_index) {
                final bool is_filled = star_index < review.rating.floor();
                final bool is_half = !is_filled &&
                    star_index < review.rating &&
                    (review.rating - star_index) >= 0.5;

                return Icon(
                  is_filled
                      ? Icons.star_rounded
                      : (is_half ? Icons.star_half_rounded : Icons.star_outline_rounded),
                  color: AppColors.amber,
                  size: 16.0,
                );
              }),
              const SizedBox(width: 6.0),
              Text(
                review.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: AppSpacing.font_size_caption,
                  fontWeight: FontWeight.w700,
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_s),

          // 3. Review Comment Body
          Text(
            review.comment,
            maxLines: _is_expanded ? null : 3,
            overflow: _is_expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_small,
              height: 1.45,
              color: is_dark
                  ? AppColors.text_dark_secondary
                  : AppColors.text_light_secondary,
            ),
          ),

          // Read More / Read Less Toggle
          _build_read_more_toggle(localizations),
        ],
      ),
    );
  }

  /// Builds the expandable text toggle button when review exceeds 100 characters.
  Widget _build_read_more_toggle(AppLocalizations localizations) {
    if (widget.review.comment.length > 100) {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _is_expanded = !_is_expanded;
            });
          },
          child: Text(
            _is_expanded ? localizations.read_less : localizations.read_more,
            style: const TextStyle(
              color: AppColors.primary_color,
              fontSize: AppSpacing.font_size_caption,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

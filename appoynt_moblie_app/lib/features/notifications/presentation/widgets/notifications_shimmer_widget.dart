/*
 * File Name: notifications_shimmer_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart, app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Skeleton placeholder loading shimmer widget for the Notifications page.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Local dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double card_radius = 16.0;
  static const double icon_box_size = 44.0;
  static const double icon_radius = 12.0;
  static const double line_height_title = 16.0;
  static const double line_height_subtitle = 12.0;
  static const double line_height_caption = 10.0;
  static const double line_radius = 4.0;
  static const double title_width = 160.0;
  static const double subtitle_width_1 = 220.0;
  static const double subtitle_width_2 = 140.0;
  static const double caption_width = 70.0;
  static const double section_header_height = 18.0;
  static const double section_header_width = 90.0;
}

// Stateful widget providing a soft pulsing shimmer animation for skeleton cards
class NotificationsShimmerWidget extends StatefulWidget {
  // Constant constructor
  const NotificationsShimmerWidget({super.key});

  @override
  State<NotificationsShimmerWidget> createState() {
    return _NotificationsShimmerWidgetState();
  }
}

class _NotificationsShimmerWidgetState extends State<NotificationsShimmerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity_animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _opacity_animation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  // Build method drawing the animated skeleton placeholders list
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final Color placeholder_color = is_dark
        ? AppColors.surface_dark
        : AppColors.slate_200;

    return AnimatedBuilder(
      animation: _opacity_animation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity_animation.value,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space_xl,
              vertical: AppSpacing.space_m,
            ),
            children: [
              // Section Header Shimmer 1
              _build_section_header_shimmer(placeholder_color),
              const SizedBox(height: AppSpacing.space_m),
              _build_card_shimmer(placeholder_color, is_dark),
              _build_card_shimmer(placeholder_color, is_dark),
              const SizedBox(height: AppSpacing.space_l),
              // Section Header Shimmer 2
              _build_section_header_shimmer(placeholder_color),
              const SizedBox(height: AppSpacing.space_m),
              _build_card_shimmer(placeholder_color, is_dark),
              _build_card_shimmer(placeholder_color, is_dark),
            ],
          ),
        );
      },
    );
  }

  // Helper drawing section title skeleton block
  Widget _build_section_header_shimmer(Color color) {
    return Container(
      width: _LocalDimensions.section_header_width,
      height: _LocalDimensions.section_header_height,
      margin: const EdgeInsets.only(top: AppSpacing.space_s),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(_LocalDimensions.line_radius),
      ),
    );
  }

  // Helper drawing individual notification card skeleton
  Widget _build_card_shimmer(Color color, bool is_dark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space_m),
      padding: const EdgeInsets.all(AppSpacing.space_l),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(_LocalDimensions.card_radius),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.border_light,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box placeholder
          Container(
            width: _LocalDimensions.icon_box_size,
            height: _LocalDimensions.icon_box_size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(_LocalDimensions.icon_radius),
            ),
          ),
          const SizedBox(width: AppSpacing.space_l),
          // Content lines placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _LocalDimensions.title_width,
                  height: _LocalDimensions.line_height_title,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(_LocalDimensions.line_radius),
                  ),
                ),
                const SizedBox(height: AppSpacing.space_s),
                Container(
                  width: _LocalDimensions.subtitle_width_1,
                  height: _LocalDimensions.line_height_subtitle,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(_LocalDimensions.line_radius),
                  ),
                ),
                const SizedBox(height: AppSpacing.space_xs),
                Container(
                  width: _LocalDimensions.subtitle_width_2,
                  height: _LocalDimensions.line_height_subtitle,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(_LocalDimensions.line_radius),
                  ),
                ),
                const SizedBox(height: AppSpacing.space_m),
                Container(
                  width: _LocalDimensions.caption_width,
                  height: _LocalDimensions.line_height_caption,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(_LocalDimensions.line_radius),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

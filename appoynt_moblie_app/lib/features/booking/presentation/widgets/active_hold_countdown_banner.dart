/*
 * File Name: active_hold_countdown_banner.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, dart:ui, app_spacing.dart, app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Modern medical-grade hold indicator with tabular digit typography,
 *   smooth slide-up animation, pulsing stopwatch icon, and amber/red urgency states.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens and colors
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

/// Redesigned medical-grade active hold countdown banner.
class ActiveHoldCountdownBanner extends StatefulWidget {
  // Remaining TTL seconds
  final int remaining_seconds;
  // Whether the hold is currently active
  final bool is_visible;

  // Constant constructor
  const ActiveHoldCountdownBanner({
    super.key,
    required this.remaining_seconds,
    this.is_visible = true,
  });

  @override
  State<ActiveHoldCountdownBanner> createState() =>
      _ActiveHoldCountdownBannerState();
}

class _ActiveHoldCountdownBannerState extends State<ActiveHoldCountdownBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse_controller;
  late Animation<double> _pulse_animation;

  @override
  void initState() {
    super.initState();
    _pulse_controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulse_animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulse_controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulse_controller.dispose();
    super.dispose();
  }

  String _format_timer(int total_seconds) {
    if (total_seconds <= 0) {
      return '00:00';
    } else {
      final int minutes = total_seconds ~/ 60;
      final int seconds = total_seconds % 60;
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final bool is_urgent = widget.remaining_seconds <= 60;

    // Amber Palette (Normal)
    final Color bg_amber =
        is_dark ? AppColors.amberDarkBg : AppColors.warningLight;
    final Color border_amber =
        is_dark ? AppColors.amber900 : AppColors.amber200;
    final Color icon_bg_amber =
        is_dark ? AppColors.amber950 : AppColors.amber100;
    const Color icon_color_amber = AppColors.amber600;
    final Color title_color_amber =
        is_dark ? AppColors.amber200 : AppColors.amber800;
    final Color sub_color_amber =
        is_dark ? AppColors.amber400 : AppColors.amber700;
    const Color badge_bg_amber = AppColors.amber600;

    // Red/Rose Palette (Urgent)
    final Color bg_red =
        is_dark ? AppColors.redDarkBg : AppColors.errorLight;
    final Color border_red =
        is_dark ? AppColors.red800 : AppColors.red200;
    final Color icon_bg_red =
        is_dark ? AppColors.redDarkBorder : AppColors.red100;
    const Color icon_color_red = AppColors.red600;
    final Color title_color_red =
        is_dark ? AppColors.red300 : AppColors.red800;
    final Color sub_color_red =
        is_dark ? AppColors.red400 : AppColors.red700;
    const Color badge_bg_red = AppColors.red600;

    // Active colors depending on urgency
    final Color card_bg = is_urgent ? bg_red : bg_amber;
    final Color card_border = is_urgent ? border_red : border_amber;
    final Color icon_bg = is_urgent ? icon_bg_red : icon_bg_amber;
    final Color icon_color = is_urgent ? icon_color_red : icon_color_amber;
    final Color title_color = is_urgent ? title_color_red : title_color_amber;
    final Color sub_color = is_urgent ? sub_color_red : sub_color_amber;
    final Color badge_bg = is_urgent ? badge_bg_red : badge_bg_amber;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: widget.is_visible ? 1.0 : 0.0,
      curve: Curves.easeOutCubic,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        offset: widget.is_visible ? Offset.zero : const Offset(0.0, 0.4),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space_xl,
            vertical: 6.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space_l,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: card_bg,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: card_border,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: is_dark
                    ? AppColors.black.withValues(alpha: 0.3)
                    : (is_urgent
                        ? AppColors.red600.withValues(alpha: 0.08)
                        : AppColors.amber600.withValues(alpha: 0.08)),
                blurRadius: 10.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Pulsing Icon Container
              AnimatedBuilder(
                animation: _pulse_animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: is_urgent ? _pulse_animation.value : 1.0,
                    child: child,
                  );
                },
                child: Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: icon_bg,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    size: 20.0,
                    color: icon_color,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),

              // Title and Subtitle Text Hierarchy
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Slot Reserved for You',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        color: title_color,
                      ),
                    ),
                    const SizedBox(height: 1.5),
                    Text(
                      'Complete booking in',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: sub_color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space_s),

              // High-Contrast Digital Timer Pill with Tabular Figures
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: badge_bg,
                  borderRadius: BorderRadius.circular(9.0),
                  boxShadow: [
                    BoxShadow(
                      color: badge_bg.withValues(alpha: 0.35),
                      blurRadius: 6.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _format_timer(widget.remaining_seconds),
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

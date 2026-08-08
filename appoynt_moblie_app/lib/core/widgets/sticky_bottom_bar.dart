/*
 * File Name: sticky_bottom_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 25/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 25/07/2026]
 * File Description: A reusable sticky bottom bar wrapper containing action buttons with customizable borders and safety padding.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Reusable sticky bottom bar container designed for dynamic scrollable pages
class StickyBottomBar extends StatelessWidget {
  // Inner child containing button layouts
  final Widget child;
  // Optional background color override
  final Color? backgroundColor;

  // Constructor mapping standard parameter
  const StickyBottomBar({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  // Render layout structure
  Widget build(BuildContext context) {
    // Resolve theme brightness modes
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Outer border shadow decorated wrapper
    return Container(
      // Decoration parameters
      decoration: BoxDecoration(
        // Solid white background adapting dynamically to dark modes
        color: backgroundColor ??
            (is_dark ? AppColors.surface_dark : AppColors.white),
        // Subtle top separating border line
        border: Border(
          // Top border side properties
          top: BorderSide(
            // Slate light border or dark adapter
            color: is_dark
                ? AppColors.border_dark
                : const Color(0xFFE2E8F0),
            // Border thickness thin
            width: 1.0,
          ),
        ),
        // Ambient shadow offset to separate from scroll views
        boxShadow: [
          // Soft elevation offset shadow
          BoxShadow(
            // Shadow transparency
            color: is_dark
                ? AppColors.black.withValues(alpha: 0.2)
                : AppColors.black.withValues(alpha: 0.05),
            // Blur spread
            blurRadius: 10.0,
            // Offset coordinates (upwards)
            offset: const Offset(0.0, -4.0),
          ),
        ],
      ),
      // Safe area padding wrapper
      child: SafeArea(
        // Safe bottom pad
        bottom: true,
        // Lateral margin pads
        child: Padding(
          // Safety padding dimensions
          padding: const EdgeInsets.symmetric(
            // Horizontal padding
            horizontal: 16.0,
            // Vertical padding
            vertical: 12.0,
          ),
          // Child widget tree
          child: child,
        ),
      ),
    );
  }
}

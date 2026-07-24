/*
 * File Name: custom_profile_app_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 23/07/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
 * File Description: Centralized back navigation header with centered title and
 * automatically mirrored back arrow. Supports an optional show_back_button flag
 * to suppress the back button on root tab screens (ProfilePage, HomePage, etc.)
 * that have no prior route in the navigation stack.
 */

// Importing central design system barrel configuration
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Reusable profile-style app bar with centered title and optional back button
class CustomProfileAppBar extends StatelessWidget {
  // Title text to display in the header center
  final String title;

  // Optional back action override callback
  final VoidCallback? onBackPressed;

  // Controls visibility of the circular back button.
  // Set to false on root bottom-nav tab screens to prevent a non-functional
  // Navigator.pop() call when there is no prior route in the stack.
  // Defaults to true for all secondary/child screens.
  final bool show_back_button;

  // Constructor mapping standard parameters
  const CustomProfileAppBar({
    super.key,
    // Title is always required
    required this.title,
    // Optional custom back press handler
    this.onBackPressed,
    // Show back button by default; pass false on root tabs
    this.show_back_button = true,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve dark theme configuration
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      // Space out leading, center, and trailing slots evenly
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ── Leading Slot: Squircle Back Button OR Empty Spacer ─────────────
        // When show_back_button is false (root tab), render an invisible
        // 40px spacer to maintain symmetric title centering.
        if (true == show_back_button) ...
          [
            // Standardized reusable squircle back button
            AppBackButton(onTap: onBackPressed),
          ]
        else ...
          [
            // Transparent 40px spacer so centered title stays truly centered
            const SizedBox(width: 40.0),
          ],

        // ── Center Slot: Page Title Text ────────────────────────────────────
        Expanded(
          child: Center(
            child: Text(
              // Display title string
              title,
              // Clamp to single line
              maxLines: 1,
              // Ellipsis for overflow
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                // Large bold heading size
                fontSize: 18.0,
                // Heavy bold weight
                fontWeight: FontWeight.w800,
                // Adaptive text color
                color: true == is_dark
                    ? Colors.white
                    : AppColors.text_light_primary,
              ),
            ),
          ),
        ),

        // ── Trailing Slot: 40px balancer spacer ────────────────────────────
        // Always present to keep the title visually centered regardless of
        // whether the back button is shown on the leading side.
        const SizedBox(width: 40.0),
      ],
    );
  }
}

/// A standardized Squircle Back Button component matching modern design specifications.
class AppBackButton extends StatelessWidget {
  /// Optional click callback override
  final VoidCallback? onTap;

  /// Constructor mapping standard callback handler
  const AppBackButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve dark theme brightness mode configuration
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // GestureDetector intercepts user navigation tap gestures
    return GestureDetector(
      // Execute callback or default to popping navigation stack
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        // Standard touch target side dimension constraint (40px)
        width: 40.0,
        // Standard touch target height constraint (40px)
        height: 40.0,
        // Visual container styling decoration
        decoration: BoxDecoration(
          // Resolve background color adapting to theme mode (Yoda style check)
          color: true == is_dark ? AppColors.surface_dark : Colors.white,
          // Rounded Rectangle Squircle corners derived from spacing tokens (12px)
          borderRadius: BorderRadius.circular(AppSpacing.radius_l),
          // Subtle border outline bounds resolving
          border: Border.all(
            // Resolve border color adapting to theme mode (Yoda style check)
            color: true == is_dark
                ? AppColors.border_dark
                : const Color(0xFFE2E8F0),
            // Thin border line width derived from spacing tokens (1px)
            width: AppSpacing.border_width_thin,
          ),
          // Soft ambient drop-shadow
          boxShadow: [
            BoxShadow(
              // Resolve shadow color adapting to theme mode (Yoda style check)
              color: true == is_dark
                  ? Colors.black26
                  : Colors.black.withValues(alpha: 0.05),
              // Blur spread
              blurRadius: 8.0,
              // Shadow offset coordinates (2px offset)
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        // Position icon centered inside bounds
        child: Icon(
          // Use modern clean angular back chevron
          Icons.arrow_back_ios_new_rounded,
          // Select icon color dynamically (Yoda style check)
          color: true == is_dark ? Colors.white : AppColors.text_light_primary,
          // Chevron display size constraint (18px)
          size: 18.0,
          // Text direction override for automatic RTL/LTR flipping
          textDirection: Directionality.of(context),
        ),
      ),
    );
  }
}

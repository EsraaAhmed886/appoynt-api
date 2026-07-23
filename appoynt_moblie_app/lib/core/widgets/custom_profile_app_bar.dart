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
        // ── Leading Slot: Circular Back Button OR Empty Spacer ─────────────
        // When show_back_button is false (root tab), render an invisible
        // 40px spacer to maintain symmetric title centering.
        if (true == show_back_button) ...
          [
            // Back button GestureDetector tap target
            GestureDetector(
              // Use custom handler if provided, else fall back to maybePop
              onTap: onBackPressed ?? () => Navigator.of(context).maybePop(),
              child: Container(
                // Circular button size
                width: 40.0,
                height: 40.0,
                // Circular decoration with shadow
                decoration: BoxDecoration(
                  // Surface background adapts to theme
                  color: true == is_dark ? AppColors.surface_dark : Colors.white,
                  // Perfect circle shape
                  shape: BoxShape.circle,
                  // Thin border outline
                  border: Border.all(
                    color: true == is_dark
                        ? AppColors.border_dark
                        : const Color(0xFFE2E8F0),
                    // Border width
                    width: 1.0,
                  ),
                  // Soft ambient shadow
                  boxShadow: [
                    BoxShadow(
                      color: true == is_dark
                          ? Colors.black26
                          : Colors.black.withValues(alpha: 0.05),
                      // Blur spread
                      blurRadius: 8.0,
                      // Vertical offset
                      offset: const Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Icon(
                  // Standard left-pointing back arrow
                  Icons.arrow_back,
                  // Adaptive icon color
                  color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                  // Icon display size
                  size: 20.0,
                ),
              ),
            ),
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

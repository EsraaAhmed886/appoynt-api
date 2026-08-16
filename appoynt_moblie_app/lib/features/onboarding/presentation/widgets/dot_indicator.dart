/*
 * File Name: dot_indicator.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: A theme-aware widget representing a page indicator dot in a slide sequence.
 */

// Importing standard central presentation and UI barrel exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Stateless widget definition for representing a single pagination dot
class DotIndicator extends StatelessWidget {
  // Boolean flag property indicating if this specific dot is highlighted
  final bool active;

  // Constructor initializing the active status parameter
  const DotIndicator({super.key, required this.active});

  // Build method rendering the animated container representing the dot
  @override
  Widget build(BuildContext context) {
    // Check if system brightness is dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Resolve dynamic inactive color token adapting to theme mode using Yoda style comparison
    final Color inactive_color = is_dark
        // Dark theme inactive dot color token
        ? AppColors.border_dark
        // Light theme inactive dot color token
        : AppColors.dot_inactive;

    // Return AnimatedContainer to animate color changes smoothly
    return AnimatedContainer(
      // Set transition duration in milliseconds using fade constant
      duration: const Duration(
        // Set duration parameter in milliseconds
        milliseconds: AppSpacing.duration_fade_ms,
      ),
      // Apply smooth ease curve transition behavior
      curve: Curves.easeInOut,
      // Margin spacing between dots utilizing standard extra small space
      margin: const EdgeInsets.symmetric(
        // Set horizontal margin space
        horizontal: AppSpacing.space_s,
      ),
      // Set width constraint utilizing central dot size constant
      width: AppSpacing.size_dot,
      // Set height constraint utilizing central dot size constant
      height: AppSpacing.size_dot,
      // Apply box decoration configurations
      decoration: BoxDecoration(
        // Determine dynamic color based on active state using Yoda conditional syntax
        color: true == active
            // Return brand primary color for active indicator
            ? AppColors.primary_color
            // Return active theme-resolved inactive color
            : inactive_color,
        // Apply circular border radius constant
        borderRadius: BorderRadius.circular(
          // Set border radius to circular constant
          AppSpacing.radius_circular,
        ),
      ),
    );
  }
}

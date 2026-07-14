/*
 * File Name: auth_button.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Accessible primary button wrapper supporting loading state indicator spinner.
 */

// Importing central presentation definitions barrel file
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Stateful or Stateless wrapper button used for auth submissions
class AuthButton extends StatelessWidget {
  // Label text displayed inside the button container
  final String label;

  // Click gesture callback function logic triggered on tap
  final VoidCallback on_pressed;

  // Toggle flag showing circular progress indicator spinner instead of text label
  final bool is_loading;

  // Toggle flag enabling or disabling the button interactions
  final bool is_enabled;

  // Custom background color parameter overriding default brand color settings
  final Color? color;

  // Constructor initializing custom configurations
  const AuthButton({
    super.key,
    required this.label,
    required this.on_pressed,
    this.is_loading = false,
    this.is_enabled = true,
    this.color,
  });

  @override
  // Build method compiling layout elements
  Widget build(BuildContext context) {
    // Resolve font family dynamically based on language layout settings
    final String font_family = AppFonts.by_locale(AppLocalizations.of(context).is_arabic);

    // Return sized container limiting button dimensions
    return SizedBox(
      // Set button to fill layout width
      width: double.infinity,
      // Set standard height using spacing constants
      height: AppSpacing.height_auth_button,
      // ElevatedButton core widget
      child: ElevatedButton(
        // Set press callback and disable interactions if loading or disabled using Yoda check
        onPressed: (true == is_loading || false == is_enabled)
            // Null callback disables actions
            ? null
            // Trigger standard submission gesture
            : on_pressed,
        // Button decoration styling
        style: ElevatedButton.styleFrom(
          // Set container background color using resolved custom override fallback
          backgroundColor: color ?? AppColors.primary_color,
          // Set background color state when disabled or loading
          disabledBackgroundColor: (color ?? AppColors.primary_color).withValues(alpha: 0.5),
          // Set border corners curvature shape
          shape: RoundedRectangleBorder(
            // Set corner radius using spacing constants
            borderRadius: BorderRadius.circular(AppSpacing.radius_l),
          ),
          // Set elevation flat to match clean visual specs
          elevation: 0.0,
        ),
        // Draw loading indicator or localized text labels based on loading check using Yoda style
        child: true == is_loading
            // Render spinner during execution
            ? const SizedBox(
                // Set layout width
                width: 22.0,
                // Set layout height
                height: 22.0,
                // Circular progress indicator spinner widget
                child: CircularProgressIndicator(
                  // Set line stroke thickness
                  strokeWidth: 2.5,
                  // Apply high contrast white color
                  color: Colors.white,
                ),
              )
            // Render localized text when idle
            : Text(
                // Active label text
                label,
                // Custom text styling options
                style: TextStyle(
                  // Set localized font family
                  fontFamily: font_family,
                  // Set standard text size using spacing constants
                  fontSize: AppSpacing.font_size_text,
                  // Set semi-bold font weight
                  fontWeight: FontWeight.w600,
                  // Force white text color with faded opacity when disabled using Yoda style check
                  color: false == is_enabled
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.white,
                ),
              ),
      ),
    );
  }
}

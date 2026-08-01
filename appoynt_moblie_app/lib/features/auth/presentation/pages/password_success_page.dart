/*
 * File Name: password_success_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 05/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: A celebratory screen displayed after successful password reset.
 *   Features entrance animations and a manual redirection button back to login.
 */

// Importing central barrel for routing, design tokens, and UI dependencies
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

/// Celebratory screen widget displayed upon successful password update operations
class PasswordSuccessPage extends StatefulWidget {
  /// Callback to navigate back to the previous auth gateway page
  final VoidCallback on_back;

  /// Callback to navigate to the application's login screen
  final VoidCallback on_go_login;

  /// Constructor mapping required navigation callback parameters
  const PasswordSuccessPage({
    super.key,
    required this.on_back,
    required this.on_go_login,
  });

  @override
  // Create state tracking class instance
  State<PasswordSuccessPage> createState() {
    // Return state class instance
    return _PasswordSuccessPageState();
  }
}

/// State class for PasswordSuccessPage managing scale and fade entrance animations
class _PasswordSuccessPageState extends State<PasswordSuccessPage>
    with SingleTickerProviderStateMixin {
  /// Controller orchestrating the entry animations
  late final AnimationController _ctrl;

  /// Scale animation for checkmark illustration pop-in
  late final Animation<double> _scale_anim;

  /// Fade animation for secondary text components and buttons
  late final Animation<double> _fade_anim;

  @override
  // Initialize state properties and launch animations
  void initState() {
    // Invoke parent widget class initialization logic
    super.initState();

    // Create animation controller running the entry transitions with 800ms duration
    _ctrl = AnimationController(
      // Set ticker provider sync dependency
      vsync: this,
      // Define total duration parameters
      duration: const Duration(milliseconds: 800),
    );

    // Create elastic scale animation curve for the visual checkmark pop effect
    _scale_anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        // Set parent controller
        parent: _ctrl,
        // Set curve mapping
        curve: Curves.elasticOut,
      ),
    );

    // Create delayed fade-in transition curve for text labels and button layout
    _fade_anim = CurvedAnimation(
      // Set parent controller
      parent: _ctrl,
      // Apply offset interval bounds
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    // Trigger animations sequence forward
    _ctrl.forward();
  }

  @override
  // Dispose controller resources to avoid memory leaks
  void dispose() {
    // Dispose the entry animation controller
    _ctrl.dispose();
    // Invoke parent class dispose logic
    super.dispose();
  }

  @override
  // Build method drawing the password reset success screen widgets
  Widget build(BuildContext context) {
    // Retrieve localized strings dictionary
    final s = AppStrings.of(context);


    // Check if standard system brightness matches dark theme mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Resolve primary text color token using Yoda style check
    final Color text_primary =
        true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary;

    // Resolve secondary text color token using Yoda style check
    final Color text_secondary =
        true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary;

    // Return scaffold setting background color
    return Scaffold(
      // SafeArea container to prevent notch overlays
      body: SafeArea(
        // Padding widget structuring content spacing bounds
        child: Padding(
          // Symmetric layout margins
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          // Column structure organizing visuals
          child: Column(
            // Contain children widgets inside list
            children: [
              // Top flexible layout spacer
              const Spacer(flex: 1),
              // Scale transition wrapping the success checkmark illustration
              ScaleTransition(
                // Bind scale path
                scale: _scale_anim,
                // Render asset image
                child: Image.asset(
                  // Path pointing to success icon constant
                  AppAssets.password_reset_success,
                  // Responsive width constraint
                  width: 280.0,
                  // Responsive height constraint
                  height: 280.0,
                  // Maintain aspect ratio configuration
                  fit: BoxFit.contain,
                ),
              ),
              // Spacing divider height
              const Spacer(flex: 1),
              // Fade transition wrapping text descriptions
              FadeTransition(
                // Bind opacity path
                opacity: _fade_anim,
                // Column grouping title and description text
                child: Column(
                  // Contain visual children list
                  children: [
                    // Title label text
                    Text(
                      // Localized title
                      s.password_reset_success_title,
                      // Center alignment settings
                      textAlign: TextAlign.center,
                      // Styling configurations
                      style: TextStyle(
                        // Emphasized font size
                        fontSize: 26.0,
                        // High bold weight
                        fontWeight: FontWeight.w800,
                        // Apply resolved primary text color
                        color: text_primary,
                        // Line height spacing
                        height: 1.3,
                      ),
                    ),
                    // Margin gap space height divider
                    const SizedBox(height: 12.0),
                    // Description body label text
                    Text(
                      // Localized description body
                      s.password_reset_success_body,
                      // Center alignment settings
                      textAlign: TextAlign.center,
                      // Styling configurations
                      style: TextStyle(
                        // Body text font size
                        fontSize: 14.0,
                        // Apply resolved secondary text color
                        color: text_secondary,
                        // Height spacing multipliers
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              // Spacing divider height before button
              const Spacer(flex: 2),
              // Fade transition wrapping the redirection button
              FadeTransition(
                // Bind opacity path
                opacity: _fade_anim,
                // Sized box wrapper setting button bounds
                child: SizedBox(
                  // Stretch width horizontally
                  width: double.infinity,
                  // Accessible button height constraints
                  height: 52.0,
                  // Elevated button widget
                  child: ElevatedButton(
                    // Press event callback
                    onPressed: widget.on_go_login,
                    // Visual styling configurations
                    style: ElevatedButton.styleFrom(
                      // Set background color to brand primary color
                      backgroundColor: AppColors.primary_color,
                      // Flat modern shadow elevation
                      elevation: 0.0,
                      // Shape definition setting corner rounded curves
                      shape: RoundedRectangleBorder(
                        // Corner radius constraints
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    // Button label text
                    child: Text(
                      // Localized button label
                      s.go_to_login,
                      // Styling configurations
                      style: const TextStyle(
                        // Font size bounds
                        fontSize: 16.0,
                        // Bold weight configuration
                        fontWeight: FontWeight.w700,
                        // High contrast white text color
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Spacing margin height reserved at page bottom
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

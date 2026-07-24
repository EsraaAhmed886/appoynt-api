/*
 * File Name: account_success_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart, dart:async
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: A celebratory screen displayed after successful account creation or password
 *   reset. Features entrance animations and an automatic redirection timer.
 */

import 'dart:async'; // Standard Dart timer for redirection
// Centralized barrel for UI dependencies
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

/// The celebratory screen widget for successful account operations.
class AccountSuccessPage extends StatefulWidget {
  /// Callback to navigate to the application's home or main screen.
  final VoidCallback on_go_home;

  /// Constructor requiring the home navigation callback.
  const AccountSuccessPage({super.key, required this.on_go_home});

  @override
  State<AccountSuccessPage> createState() {
    return _AccountSuccessPageState();
  }
}

/// The state class for AccountSuccessPage managing animations and redirection timer.
class _AccountSuccessPageState extends State<AccountSuccessPage>
    with SingleTickerProviderStateMixin {
  /// Controller for orchestrating the celebratory entry animations.
  late AnimationController _ctrl;
  
  /// Animation for the pop-in/elastic scaling effect of the success illustration.
  late Animation<double> _scale_anim;
  
  /// Animation for the smooth fading effect of the text and buttons.
  late Animation<double> _fade_anim;

  /// Remaining seconds before automatic redirection occurs.
  int _seconds_left = 3;
  
  /// Reference to the active countdown timer.
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    /// Initializing the animation controller with an 800ms duration.
    _ctrl = AnimationController(
      vsync: this, // Using TickerProvider for smooth rendering
      duration: const Duration(milliseconds: 800),
    );
    
    /// Creating an elastic scale animation for a playful "pop" effect.
    _scale_anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    
    /// Creating a delayed fade-in animation for the secondary content.
    _fade_anim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );
    
    /// Triggering the animations sequence.
    _ctrl.forward();

    /// Configuring a periodic timer to handle the automatic redirection logic.
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (1 == _seconds_left) {
        t.cancel(); // Stopping the timer
        /// Executing the redirection if the widget is still in the tree.
        if (mounted) {
          widget.on_go_home();
        }
      } else {
        /// Updating the countdown value in the UI.
        setState(() {
          _seconds_left--;
        });
      }
    });
  }

  @override
  void dispose() {
    /// Cleaning up the controller and timer to prevent resource leaks.
    _ctrl.dispose();
    _timer?.cancel();
    super.dispose(); // Final disposal
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving localized strings.
    final s = AppStrings.of(context);
    
    /// Check if system brightness matches dark mode.
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    
    final Color text_primary = true == is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    final Color text_secondary = true == is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32), // content padding
          child: Column(
            children: [
              const Spacer(flex: 2), // Flexible top spacing

              /// Celebratory illustration with entrance scaling.
              ScaleTransition(
                scale: _scale_anim,
                child: Image.asset(
                  'assets/images/account_success.png',
                  width: 220, // Responsive width
                  height: 220, // Responsive height
                  fit: BoxFit.contain, // Maintaining aspect ratio
                  /// Rendering a custom fallback icon if the asset fails to load.
                  errorBuilder: (context, error, stackTrace) {
                    return _DefaultSuccessIcon();
                  },
                ),
              ),

              const Spacer(flex: 1), // Spacing between image and text

              /// Localized Title and Subtitle with entrance fade.
              FadeTransition(
                opacity: _fade_anim,
                child: Column(
                  children: [
                    /// Displaying the "Account Created" success title.
                    Text(
                      s.account_created_success,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: text_primary, // Primary brand text color
                        height: 1.3, // Standardized line height
                      ),
                    ),
                    const SizedBox(height: 12), // Vertical gap
                    /// Displaying the welcome and redirection message.
                    Text(
                      '${s.welcome_to_appoynt}\n${s.redirecting_automatically}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: text_secondary, // Secondary brand text color
                        height: 1.6, // Increased line height for body text
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1), // Spacing between text and timer

              /// Circular countdown indicator with entrance fade.
              FadeTransition(
                opacity: _fade_anim,
                child: Column(
                  children: [
                    /// Visual stack representing the countdown ring and numeric value.
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// Background ring and active progress indicator.
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: CircularProgressIndicator(
                              value: _seconds_left / 3, // Calculated progress
                              strokeWidth: 3, // Standard ring thickness
                              backgroundColor: AppColors.primary_color
                                  .withValues(alpha: 0.15), // Muted brand color
                              color: AppColors.primary_color, // Active brand color
                            ),
                          ),
                          /// The numeric countdown value.
                          Text(
                            '$_seconds_left',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary_color, // Themed numeric color
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8), // Gap before description
                    /// Descriptive localized text for the redirection timer.
                    Text(
                      s.going_to_home_in(_seconds_left),
                      style: TextStyle(
                        fontSize: 12,
                        color: text_secondary, // Muted description color
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2), // Flexible spacing before manual button

              /// Primary action button for manual skip with entrance fade.
              FadeTransition(
                opacity: _fade_anim,
                child: SizedBox(
                  width: double.infinity,
                  height: 52, // Standard accessible button height
                  child: ElevatedButton(
                    onPressed: widget.on_go_home, // Triggering home navigation
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary_color, // Brand primary color
                      elevation: 0, // Modern flat design
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14), // Stylized corners
                      ),
                    ),
                    /// Localized manual navigation label.
                    child: Text(
                      s.go_to_home,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white, // High contrast text
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32), // Bottom margin for visual balance
            ],
          ),
        ),
      ),
    );
  }
}

/// A private internal helper widget representing the fallback success icon.
class _DefaultSuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      /// Applying a vibrant brand gradient for the circular background.
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary_color, // Start color
            AppColors.primary_color.withValues(alpha: 0.85), // End color
          ],
        ),
        shape: BoxShape.circle, // Circular badge
        boxShadow: [
          /// Adding a soft glowing shadow with the primary brand color.
          BoxShadow(
            color: AppColors.primary_color.withValues(alpha: 0.35),
            blurRadius: 30, // Large diffusion for a glow effect
            offset: const Offset(0, 12), // Downward projection
          ),
        ],
      ),
      /// The central checkmark icon.
      child: const Icon(
        Icons.check_rounded,
        color: Colors.white, // High contrast white icon
        size: 80, // Large emphasized size
      ),
    );
  }
}

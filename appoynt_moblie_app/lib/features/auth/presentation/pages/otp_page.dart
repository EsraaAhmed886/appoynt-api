/*
 * File Name: otp_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/widgets/otp_box.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: The OTP Verification screen. It handles the input of a 6-digit code,
 *   manages a resend timer, and follows the centralized design system.
 */

import 'dart:async'; // Importing standard Dart timers
import 'package:flutter/services.dart'; // Importing standard Flutter services for keyboard events
// Centralized barrel for UI dependencies
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Specialized input widget
import 'package:appoynt_mobile_app/features/auth/presentation/widgets/otp_box.dart';
// Centralized auth widgets barrel file
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';

/// The main OTP verification screen widget.
class OtpPage extends StatefulWidget {
  /// The phone number where the code was sent (for display/context).
  final String phone;

  /// Callback executed when the code is successfully verified.
  final VoidCallback on_verified;

  /// Callback to navigate back to the previous screen.
  final VoidCallback on_back;

  /// Callback to toggle the application's active language.
  final VoidCallback on_toggle_language;

  /// Constructor for OtpPage requiring all functional parameters.
  const OtpPage({
    super.key,
    required this.phone,
    required this.on_verified,
    required this.on_back,
    required this.on_toggle_language,
  });

  @override
  State<OtpPage> createState() {
    return _OtpPageState();
  }
}

/// The state class for OtpPage managing timer logic and input orchestration.
class _OtpPageState extends State<OtpPage> {
  /// Creating 6 individual controllers for each OTP digit box.
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());

  /// Creating 6 focus nodes to manage the keyboard traversal between boxes.
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  /// The remaining seconds until the user can request a new code.
  int _seconds_left = 28;

  /// Reference to the active timer instance.
  Timer? _timer;

  /// Flag tracking whether a verification request is in progress.
  bool _is_loading = false;

  @override
  void initState() {
    super.initState();

    /// Initializing and starting the resend countdown.
    _start_timer();

    // Attach text change listeners to all controllers to refresh build on updates
    for (final c in _ctrls) {
      c.addListener(_on_otp_changed);
    }

    // Attach onKeyEvent listeners to FocusNodes to orchestrate
    // backspace navigation naturally (BUG-009)
    for (int i = 0; i < 6; i++) {
      // Set key event handler on focus node
      _nodes[i].onKeyEvent = (node, event) {
        // Intercept key down event transitions
        if (event is KeyDownEvent) {
          // Identify if backspace key was pressed
          final bool is_backspace = event.logicalKey == LogicalKeyboardKey.backspace;
          // Trigger backward transition if field is empty and not the first box
          if (true == is_backspace && _ctrls[i].text.isEmpty && i > 0) {
            // Shift focus backwards to previous digit input field
            _nodes[i - 1].requestFocus();
            // Clear content of previous input field to simulate backspace deletion
            _ctrls[i - 1].clear();
            // Consume key event
            return KeyEventResult.handled;
          } else {
            // Empty action block to satisfy compiler
          }
        } else {
          // Empty action block to satisfy compiler
        }
        // Delegate event mapping to framework default handlers
        return KeyEventResult.ignored;
      };
    }

    /// Automatically focusing the first digit box after the screen is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nodes[0].requestFocus();
      }
    });
  }

  // Method executing when OTP value updates
  void _on_otp_changed() {
    // Refresh layout state to update button colors
    setState(() {});
  }

  /// Configures and starts a 1-second interval periodic timer.
  void _start_timer() {
    _timer?.cancel(); // Stopping any existing timer
    setState(() {
      _seconds_left = 28; // Resetting the countdown
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (0 == _seconds_left) {
        t.cancel(); // Stopping when countdown reaches zero
      } else {
        /// Updating the UI with the decremented value.
        setState(() {
          _seconds_left--;
        });
      }
    });
  }

  @override
  void dispose() {
    /// Cleaning up the timer and all individual controllers/nodes.
    _timer?.cancel();
    // Remove text change listeners from controllers
    for (final c in _ctrls) {
      c.removeListener(_on_otp_changed);
    }
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _nodes) {
      f.dispose();
    }
    super.dispose(); // Final disposal
  }

  /// Concatenates the values from all 6 boxes into a single string.
  String get _otp {
    return _ctrls.map((c) => c.text).join();
  }

  /// Flag indicating whether the user has entered all 6 digits.
  bool get _is_filled {
    return 6 == _otp.length;
  }

  /// Handles focus movement when a digit is entered or deleted.
  /// [index] The position of the box being changed.
  /// [value] The new character value.
  void _on_digit_changed(int index, String value) {
    // Re-rendering the UI to reflect potential changes in button state and enablement
    setState(() {});

    // Moving focus forward if a digit is entered (except for the last box)
    if (true == value.isNotEmpty && 5 > index) {
      // Defer focus shift to next frame to ensure the next field is fully enabled
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Request focus on the next digit box
        _nodes[index + 1].requestFocus();
      });
    } else {
      // Empty action block to satisfy compiler
    }

    // Shift focus backwards logic was removed here and is handled
    // by FocusNode.onKeyEvent instead (BUG-009)
  }

  /// Orchestrates the verification process.
  void _verify() async {
    /// Blocking execution if the code is incomplete.
    if (false == _is_filled) {
      return;
    } else {
      // Proceed with verification if OTP is complete
    }

    /// Activating the loading state.
    setState(() {
      _is_loading = true;
    });

    /// Simulating a network request for OTP validation.
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      /// Deactivating loading and triggering the success callback.
      setState(() {
        _is_loading = false;
      });
      widget.on_verified();
    }
  }

  /// Converts the raw seconds count into a MM:SS formatted string.
  String _format_time(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving localized strings and directionality info.
    final s = AppStrings.of(context);
    final bool is_arabic = s.is_arabic;

    /// Check if system brightness matches dark mode.
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    /// Dynamically resolved color schemes.
    final Color background_color = true == is_dark
        ? AppColors.background_dark
        : AppColors.background_light;
    final Color text_primary = true == is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    final Color text_secondary = true == is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;
    final Color border_color =
        true == is_dark ? AppColors.border_dark : AppColors.border_light;
    final Color card_color =
        true == is_dark ? AppColors.surface_dark : Colors.white;

    return Scaffold(
      backgroundColor: background_color, // Applying theme background color
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24), // Content padding
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centering all children
            children: [
              const SizedBox(height: 12), // Top margin

              /// Navigation and language control row.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Standard back button with localized icon direction.
                  GestureDetector(
                    onTap: widget.on_back,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color:
                            card_color, // Standard white background or dark surface
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        border:
                            Border.all(color: border_color), // Subtle border
                      ),
                      // RotatedBox to mirror the back chevron icon in Arabic
                      // RTL mode (BUG-012)
                      child: RotatedBox(
                        // Quarter turns set to 0 to keep the back chevron
                        // pointing left in both languages
                        quarterTurns: 0,
                        // Chevron back icon widget
                        child: Icon(
                          // Back chevron icon representation
                          Icons.arrow_back_ios_new_rounded,
                          // Set size constraint
                          size: 16,
                          // Primary icon color
                          color: text_primary,
                        ),
                      ),
                    ),
                  ),

                  /// Globally centralized language switching button.
                  GlobalLanguageButton(
                    is_arabic: is_arabic,
                    on_tap: widget.on_toggle_language,
                    light: false, // Standard dark mode icons
                  ),
                ],
              ),

              const SizedBox(height: 40), // Space before title

              /// Header section containing title and descriptive subtitle.
              Text(
                s.enter_your_code,
                style: AppTextStyles.get_otp_title(
                    is_arabic), // Localized typography
              ),
              const SizedBox(height: 8), // Vertical spacing
              Text(
                s.enter_otp_subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.get_otp_subtitle(
                    is_arabic), // Localized body style
              ),

              const SizedBox(height: 40), // Space before input grid

              /// The 6-box OTP entry grid, explicitly forced to LTR for consistent numeric entry.
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (i) => OtpBox(
                      // Mapping text controller
                      controller: _ctrls[i],
                      // Mapping focus node
                      focusNode: _nodes[i],
                      // Mapping change logic
                      onChanged: (v) =>
                          _on_digit_changed(i, v),
                      // Enable sequentially based on previous field filled status (BUG-010)
                      enabled: 0 == i || _ctrls[i - 1].text.isNotEmpty,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28), // Space before timer row

              /// Resend action row with active countdown.
              Row(
                // Center row elements horizontally
                mainAxisAlignment: MainAxisAlignment.center,
                // Children list
                children: [
                  /// Clickable label for resending the code (enabled only when timer is 0).
                  GestureDetector(
                    // Trigger timer restart on tap if time is up
                    onTap: 0 == _seconds_left ? _start_timer : null,
                    // Text label widget
                    child: Text(
                      // Localized label string
                      s.send_code_again,
                      // Styling configurations
                      style: TextStyle(
                        // Font size
                        fontSize: 14,
                        // Emphasized bold weight
                        fontWeight: FontWeight.w700,
                        /// Highlighting color based on availability.
                        color: 0 == _seconds_left
                            ? AppColors.primary_color
                            : text_secondary,
                      ),
                    ),
                  ),
                  // Conditionally show spacing and timer widget only if countdown
                  // remains active (BUG-005)
                  if (_seconds_left > 0) ...[
                    // Horizontal spacing gap
                    const SizedBox(width: 6),
                    // Timer text label widget showing countdown seconds left
                    Text(
                      // Format remaining seconds as MM:SS
                      _format_time(_seconds_left),
                      // Localized timer text style
                      style: AppTextStyles.get_otp_timer(is_arabic),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20), // Margin before info card

              /// Information card providing context about the sent code.
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  /// Subtle brand-themed background fill.
                  color: AppColors.primary_color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  s.sent_code_info,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,

                    /// Using a slightly transparent variant of primary color.
                    color: AppColors.primary_color.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(), // Pushing the button to the bottom

              /// Primary verification action button.
              AuthButton(
                // Localized action string
                label: s.verify,
                // Enable only when all 6 boxes are completed using Yoda style check
                is_enabled: _is_filled,
                // Submission callback
                on_pressed: _verify,
                // Loading state indicator
                is_loading: _is_loading,
              ),

              const SizedBox(height: 32), // Bottom safe margin
            ],
          ),
        ),
      ),
    );
  }
}

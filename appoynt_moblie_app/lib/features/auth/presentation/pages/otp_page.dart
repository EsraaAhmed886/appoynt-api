/*
 * File Name: otp_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/widgets/otp_box.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart,
 *   package:appoynt_mobile_app/core/di/service_locator.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
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
// Importing bloc consumer and provider utilities
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing auth business state controller cubit definitions
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
// Importing dependency injection service locator setup representation
import 'package:appoynt_mobile_app/core/di/service_locator.dart';

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
  void _verify(BuildContext verification_context) {
    /// Blocking execution if the code is incomplete.
    if (false == _is_filled) {
      return;
    } else {
      // Proceed with verification if OTP is complete
    }

    // Dispatch verify otp event to AuthCubit
    verification_context.read<AuthCubit>().verify_otp(_otp);
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
    final Color text_secondary = true == is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;

    // Return BlocProvider setting up AuthCubit on top of the tree
    return BlocProvider<AuthCubit>(
      // Create and initialize new auth cubit instance
      create: (context) {
        // Return initialized auth cubit resolved from service locator container
        return get_it<AuthCubit>();
      },
      // Bind consumer widget to intercept state changes
      child: BlocConsumer<AuthCubit, AuthState>(
        // Listener callback intercepts transition changes
        listener: (context, state) {
          // Check if verification succeeds using Yoda style check
          if (state is AuthSuccess) {
            // Trigger OTP verification success callback
            widget.on_verified();
          } else {
            // Empty action block to satisfy compiler
          }
        },
        // Builder rendering UI components based on state updates
        builder: (context, state) {
          // Return Scaffold container layout settings
          return Scaffold(
            body: SafeArea(
              // LayoutBuilder measuring viewport height constraints dynamically
              child: LayoutBuilder(
                // Builder callback receiving layout constraints
                builder: (context, constraints) {
                  // SingleChildScrollView enabling vertical scrolling when content overflows
                  return SingleChildScrollView(
                    // ConstrainedBox forcing child to match at least viewport height
                    child: ConstrainedBox(
                      // Bind constraints
                      constraints: BoxConstraints(
                        // Minimum height matches constraints maxHeight
                        minHeight: constraints.maxHeight,
                      ),
                      // IntrinsicHeight resolves children vertical stretching
                      child: IntrinsicHeight(
                        // Padding container layout using spacing tokens
                        child: Padding(
                          // Apply horizontal padding using spacing tokens instead of raw pixels
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xxl),
                          // Main Column centering all children
                          child: Column(
                            // Align children horizontally centered
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Contain visual children list
                            children: [
                              // Top margin notch spacing using spacing constants
                              const SizedBox(height: AppSpacing.space_xl),

                              /// Navigation and language control row.
                              Row(
                                // Distribute space evenly between row elements
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // Children list
                                children: [
                                  /// Standard back button with localized icon direction.
                                  // Reusable squircle back button component
                                  AppBackButton(onTap: widget.on_back),

                                  /// Globally centralized language switching button.
                                  GlobalLanguageButton(
                                    // Pass language direction flag
                                    is_arabic: is_arabic,
                                    // Pass selection toggle callback
                                    on_tap: widget.on_toggle_language,
                                    // Keep standard icon color mapping rules
                                    light: false,
                                  ),
                                ],
                              ),

                              // Space before title using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_extreme),

                              /// Header section containing title and descriptive subtitle.
                              Text(
                                // Localized title
                                s.enter_your_code,
                                // Pull OTP title styling passing context
                                style: AppTextStyles.get_otp_title(context, is_arabic),
                              ),
                              // Vertical spacing gap using spacing constants
                              const SizedBox(height: AppSpacing.space_m),
                              Text(
                                // Localized description subtitle
                                s.enter_otp_subtitle,
                                // Center align text
                                textAlign: TextAlign.center,
                                // Pull OTP subtitle styling passing context
                                style: AppTextStyles.get_otp_subtitle(context, is_arabic),
                              ),
                              // Spacing/Container block for validation error feedback message (FR-15 / Logic Log)
                              const SizedBox(height: AppSpacing.space_s),
                              // Fixed-height container to prevent layout shifting
                              SizedBox(
                                // Fixed height derived from spacing tokens to satisfy stable UI constraint
                                height: AppSpacing.error_container_height,
                                // Draw error feedback text inside center coordinates
                                child: Center(
                                  // Render error message if state is AuthError (Yoda style check)
                                  child: Text(
                                    // Bind message or empty string based on state type
                                    true == (state is AuthError)
                                        ? AppLocalizations.get_localized_error(context, (state as AuthError).message)
                                        : '',
                                    // Center align paragraph
                                    textAlign: TextAlign.center,
                                    // Apply styling configurations
                                    style: const TextStyle(
                                      // Set brand warning color
                                      color: AppColors.error,
                                      // Scale size relative to labels
                                      fontSize: AppSpacing.font_size_label,
                                      // Emphasize text weight
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              // Space before input grid using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxl),

                              /// The 6-box OTP entry grid, explicitly forced to LTR for consistent numeric entry.
                              Directionality(
                                // Force Left-to-Right layout directionality
                                textDirection: TextDirection.ltr,
                                // Row layout wrapping OTP input boxes
                                child: Row(
                                  // Distribute space evenly between row elements
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // Children list
                                  children: List.generate(
                                    6,
                                    (i) => OtpBox(
                                      // Mapping text controller
                                      controller: _ctrls[i],
                                      // Mapping focus node
                                      focusNode: _nodes[i],
                                      // Mapping change logic
                                      onChanged: (v) => _on_digit_changed(i, v),
                                      // Enable sequentially based on previous field filled status (BUG-010)
                                      enabled: 0 == i || _ctrls[i - 1].text.isNotEmpty,
                                    ),
                                  ),
                                ),
                              ),

                              // Space before timer row using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxxl),

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
                                    // Horizontal spacing gap using spacing constants instead of magic numbers
                                    const SizedBox(width: AppSpacing.space_s),
                                    // Timer text label widget showing countdown seconds left
                                    Text(
                                      // Format remaining seconds as MM:SS
                                      _format_time(_seconds_left),
                                      // Localized timer text style passing context
                                      style: AppTextStyles.get_otp_timer(context, is_arabic),
                                    ),
                                  ],
                                ],
                              ),

                              // Margin before info card using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxl),

                              /// Information card providing context about the sent code.
                              Container(
                                // Stretches width horizontally
                                width: double.infinity,
                                // Symmetric padding container layout
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl, vertical: AppSpacing.space_l),
                                // Visual styling decoration
                                decoration: BoxDecoration(
                                  /// Subtle brand-themed background fill.
                                  color: AppColors.primary_color.withValues(alpha: 0.08),
                                  // Corner radius using spacing constants
                                  borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                                ),
                                // Text details inside info box
                                child: Text(
                                  // Localized details string
                                  s.sent_code_info,
                                  // Center align text
                                  textAlign: TextAlign.center,
                                  // Typography styling
                                  style: TextStyle(
                                    // Font size
                                    fontSize: 13,
                                    /// Using a slightly transparent variant of primary color.
                                    color: AppColors.primary_color.withValues(alpha: 0.9),
                                    // Line height multiplier
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              // Spacer pushing button to the bottom while maintaining scroll support
                              const Spacer(),

                              // Margin before action button using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxxl),

                              /// Primary verification action button.
                              AuthButton(
                                // Localized action string
                                label: s.verify,
                                // Enable only when all 6 boxes are completed using Yoda style check
                                is_enabled: _is_filled,
                                // Submission callback
                                on_pressed: () {
                                  // Trigger verification under context
                                  _verify(context);
                                },
                                // Loading state indicator
                                is_loading: state is AuthLoading,
                              ),

                              // Bottom safe margin using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxxl),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

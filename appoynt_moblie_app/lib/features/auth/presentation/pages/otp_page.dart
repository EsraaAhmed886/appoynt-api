/*
 * File Name: otp_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/widgets/otp_box.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart,
 *   package:appoynt_mobile_app/core/di/service_locator.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
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

  /// Local attempt counter tracking consecutive verification failures.
  int _attempt_count = 0;

  /// Flag indicating whether OTP input is locked due to max attempts exceeded.
  bool _is_locked = false;

  @override
  void initState() {
    super.initState();

    // Clear any previous error on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        get_it<AuthCubit>().clear_error();
      } else {
        // No action needed
      }
    });

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
          if (is_backspace && _ctrls[i].text.isEmpty && i > 0) {
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
        final authCubit = get_it<AuthCubit>();
        if (null == authCubit.challengeId || authCubit.challengeId!.isEmpty) {
          _show_graceful_recovery_dialog();
        } else {
          _nodes[0].requestFocus();
        }
      } else {
        // No action needed
      }
    });
  }

  /// Gracefully displays a verification error dialog when the challenge ID is missing.
  void _show_graceful_recovery_dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final AppLocalizations s = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(s.is_arabic ? 'خطأ في المصادقة' : 'Verification Error'),
          content: Text(
            s.is_arabic
                ? 'فقدت جلسة التحقق. يرجى الرجوع إلى الصفحة السابقة وإعادة المحاولة.'
                : 'Verification session lost. Please return to the previous page and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.on_back();
              },
              child: Text(s.is_arabic ? 'رجوع' : 'Go Back'),
            ),
          ],
        );
      },
    );
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
    // Clear error on screen exit
    get_it<AuthCubit>().clear_error();
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
    if (true == _is_locked) {
      return;
    } else {
      // Proceed with input handling
    }

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
  }

  /// Orchestrates the verification process.
  void _verify(BuildContext verification_context) {
    /// Blocking execution if locked or code is incomplete.
    if (true == _is_locked) {
      return;
    } else {
      // Not locked
    }
    if (false == _is_filled) {
      return;
    } else {
      // Proceed with verification if OTP is complete
    }

    // Increment attempt count
    _attempt_count++;
    if (_attempt_count >= 3) {
      setState(() {
        _is_locked = true;
      });
      for (final c in _ctrls) {
        c.clear();
      }
      CustomSnackBar.error(
        context,
        AppLocalizations.get_localized_error(
            context, 'auth.otp.attempts_exceeded'),
      );
      return;
    } else {
      // Attempt count within limit
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
    final Color text_secondary = is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;

    // Return BlocProvider setting up AuthCubit on top of the tree
    return BlocProvider<AuthCubit>.value(
      value: get_it<AuthCubit>(),
      // Bind consumer widget to intercept state changes
      child: BlocConsumer<AuthCubit, AuthState>(
        // Listener callback intercepts transition changes
        listener: (context, state) {
          // Check if verification succeeds using Yoda style check
          if (state is VerifyOtpSuccess) {
            // Trigger OTP verification success callback
            widget.on_verified();
          } else if (state is AuthError) {
            // Handle max attempts reached or attempts exceeded error
            if (state.message == 'auth.otp.attempts_exceeded' || _attempt_count >= 3) {
              setState(() {
                _is_locked = true;
              });
              for (final c in _ctrls) {
                c.clear();
              }
            } else {
              // Empty action block to satisfy compiler
            }
            CustomSnackBar.error(
              context,
              AppLocalizations.get_localized_error(context, state.message),
            );
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
                                      // Enable sequentially based on previous field filled status and locked state
                                      enabled: !_is_locked && (0 == i || _ctrls[i - 1].text.isNotEmpty),
                                    ),
                                  ),
                                ),
                              ),

                              // Space before timer row using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxxl),

                              /// Resend action row with active countdown and locked guidance highlight.
                              Container(
                                padding: _is_locked
                                    ? const EdgeInsets.symmetric(horizontal: AppSpacing.space_l, vertical: AppSpacing.space_s)
                                    : EdgeInsets.zero,
                                decoration: _is_locked
                                    ? BoxDecoration(
                                        color: AppColors.primary_color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                                        border: Border.all(color: AppColors.primary_color, width: 1.5),
                                      )
                                    : null,
                                child: Row(
                                  // Center row elements horizontally
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: _is_locked ? MainAxisSize.min : MainAxisSize.max,
                                  // Children list
                                  children: [
                                    GestureDetector(
                                      // Trigger resend and timer restart on tap if time is up or UI locked
                                      onTap: (_is_locked || 0 == _seconds_left)
                                          ? () {
                                              setState(() {
                                                _is_locked = false;
                                                _attempt_count = 0;
                                              });
                                              for (final c in _ctrls) {
                                                c.clear();
                                              }
                                              context.read<AuthCubit>().resend_otp();
                                              _start_timer();
                                              _nodes[0].requestFocus();
                                            }
                                          : null,
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
                                          /// Highlighting color based on availability and locked guidance state.
                                          color: (_is_locked || 0 == _seconds_left)
                                              ? AppColors.primary_color
                                              : text_secondary,
                                        ),
                                      ),
                                    ),
                                    // Conditionally show spacing and timer widget only if countdown
                                    // remains active and not locked (BUG-005)
                                    if (_seconds_left > 0 && !_is_locked) ...[
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
                                // Enable only when all 6 boxes are completed and UI is not locked
                                is_enabled: !_is_locked && _is_filled,
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

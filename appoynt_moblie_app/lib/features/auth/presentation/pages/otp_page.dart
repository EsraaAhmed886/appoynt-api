/*
 * File Name: otp_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:appoynt_mobile_app/features/auth/presentation/widgets/otp_box.dart
 *   - package:appoynt_mobile_app/core/widgets/auth/global_language_button.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   The OTP Verification screen. It handles the input of a 6-digit code, 
 *   manages a resend timer, and follows the centralized design system.
 */

import 'dart:async'; // Importing standard Dart timers
import 'package:appoynt_mobile_app/core/routing/route_export.dart'; // Centralized barrel for UI dependencies
import 'package:appoynt_mobile_app/features/auth/presentation/widgets/otp_box.dart'; // Specialized input widget
import 'package:appoynt_mobile_app/core/widgets/auth/global_language_button.dart'; // Global language selector widget

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
    
    /// Automatically focusing the first digit box after the screen is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nodes[0].requestFocus();
      }
    });
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
    /// Moving focus forward if a digit is entered (except for the last box).
    if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    /// Moving focus backward if a digit is deleted (except for the first box).
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    /// Re-rendering the UI to reflect potential changes in button state.
    setState(() {});
  }

  /// Orchestrates the verification process.
  void _verify() async {
    /// Blocking execution if the code is incomplete.
    if (!_is_filled) {
      return;
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
    final Color background_color = true == is_dark ? AppColors.background_dark : AppColors.background_light;
    final Color text_primary = true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary;
    final Color text_secondary = true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary;
    final Color border_color = true == is_dark ? AppColors.border_dark : AppColors.border_light;
    final Color card_color = true == is_dark ? AppColors.surface_dark : Colors.white;

    return Scaffold(
      backgroundColor: background_color, // Applying theme background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // Content padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centering all children
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
                        color: card_color, // Standard white background or dark surface
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                        border: Border.all(color: border_color), // Subtle border
                      ),
                      child: Icon(
                        true == is_arabic
                            ? Icons.arrow_forward_ios_rounded // RTL back icon
                            : Icons.arrow_back_ios_new_rounded, // LTR back icon
                        size: 16,
                        color: text_primary, // Primary icon color
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
                style: AppTextStyles.get_otp_title(is_arabic), // Localized typography
              ),
              const SizedBox(height: 8), // Vertical spacing
              Text(
                s.enter_otp_subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.get_otp_subtitle(is_arabic), // Localized body style
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
                      controller: _ctrls[i], // Mapping controller
                      focusNode: _nodes[i], // Mapping focus node
                      onChanged: (v) => _on_digit_changed(i, v), // Mapping change logic
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28), // Space before timer row

              /// Resend action row with active countdown.
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centering row
                children: [
                  /// Clickable label for resending the code (enabled only when timer is 0).
                  GestureDetector(
                    onTap: 0 == _seconds_left ? _start_timer : null,
                    child: Text(
                      s.send_code_again,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        /// Highlighting color based on availability.
                        color: 0 == _seconds_left 
                            ? AppColors.primary_color 
                            : text_secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6), // Horizontal gap
                  /// Displaying the formatted remaining time.
                  Text(
                    _format_time(_seconds_left),
                    style: AppTextStyles.get_otp_timer(is_arabic), // Localized timer style
                  ),
                ],
              ),

              const SizedBox(height: 20), // Margin before info card

              /// Information card providing context about the sent code.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              SizedBox(
                width: double.infinity,
                height: 52, // Standard accessible height
                child: ElevatedButton(
                  /// Enabling button only if all boxes are filled and not currently loading.
                  onPressed: _is_filled && !_is_loading ? _verify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color, // Brand primary color
                    /// Semi-transparent color when disabled.
                    disabledBackgroundColor: AppColors.primary_color.withValues(alpha: 0.5),
                    elevation: 0, // Flat design
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), // Rounded corners
                    ),
                  ),
                  /// Displaying spinner or localized text.
                  child: true == _is_loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : Text(
                          s.verify,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32), // Bottom safe margin
            ],
          ),
        ),
      ),
    );
  }
}

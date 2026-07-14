/*
 * File Name: forgot_password_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/07/2026]
 * File Description:
 *   The Forgot Password screen allows users to request a reset code via 
 *   their phone number. It follows the centralized design system and 
 *   supports full bilingual localization.
 */

import 'package:appoynt_mobile_app/core/routing/route_export.dart'; // Centralized barrel for UI dependencies and global logic
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart'; // Barrel file exporting AuthTextField

/// The main forgot password screen widget.
class ForgotPasswordPage extends StatefulWidget {
  /// Callback to navigate back to the previous screen (typically Login).
  final VoidCallback on_back;
  /// Callback to toggle the application's active language.
  final VoidCallback on_toggle_language;
  /// Callback triggered when a reset code has been successfully sent.
  /// [phone] The phone number where the code was dispatched.
  final void Function(String phone) on_code_sent;

  /// Constructor for ForgotPasswordPage requiring all functional callbacks.
  const ForgotPasswordPage({
    super.key,
    required this.on_back,
    required this.on_toggle_language,
    required this.on_code_sent,
  });

  @override
  State<ForgotPasswordPage> createState() {
    return _ForgotPasswordPageState();
  }
}

/// The state class for ForgotPasswordPage managing form input and validation.
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  /// Global key to uniquely identify and validate the phone number form.
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  
  /// Controller for the phone number input field.
  final TextEditingController _phone_ctrl = TextEditingController();
  
  /// Flag tracking whether a code request is currently in progress.
  bool _is_loading = false;
  
  /// Flag to track whether at least one submission attempt occurred.
  bool _form_submitted = false;
  
  /// Variable to store the last known locale for detecting language changes.
  Locale? _last_locale;

  @override
  // Initialize state registers and add listener to refresh UI on text updates
  void initState() {
    // Invoke parent initialization
    super.initState();
    // Register listener mapping text value changes
    _phone_ctrl.addListener(_on_phone_changed);
  }

  // Method executing when phone value updates
  void _on_phone_changed() {
    // Refresh layout state to update button colors
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /// Retrieving the current active locale from context.
    final locale = Localizations.localeOf(context);
    /// Re-validating the form if the language changed after a submission attempt.
    if (_form_submitted && _last_locale != null && _last_locale != locale) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _form_key.currentState?.validate();
        }
      });
    }
    _last_locale = locale; // Updating the last known locale
  }

  @override
  void dispose() {
    // Remove listener from controller
    _phone_ctrl.removeListener(_on_phone_changed);
    /// Cleaning up the text controller to prevent memory leaks.
    _phone_ctrl.dispose();
    super.dispose(); // Final disposal
  }

  // Validator function verifying phone digits count limits using Yoda style check
  String? _validate_phone(String? phone_value, AppStrings strings_catalog) {
    // Check if input value is null or empty using Yoda style check
    if (null == phone_value || phone_value.isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
    } else {
      // Empty action block to satisfy compiler
    }
    // Convert Arabic numerals to English digits if any exist
    String clean_digits = phone_value;
    // Map of Arabic-Indic to standard English digits
    final Map<String, String> translation_map = {
      '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
      '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9'
    };
    // Translate each character in map
    translation_map.forEach((arabic, english) {
      clean_digits = clean_digits.replaceAll(arabic, english);
    });
    // Strip space dividers, symbols, and format modifiers
    clean_digits = clean_digits.replaceAll(RegExp(r'[^\d]'), '');
    // Verify phone digit count length matches exactly 11 digits using Yoda style check
    if (11 != clean_digits.length) {
      // Return phone count validation warning message
      return strings_catalog.phone_must_be_11_digits;
    } else {
      // Empty action block to satisfy compiler
    }
    // Verify that phone number starts with 01 prefix using Yoda style check
    if (false == clean_digits.startsWith('01')) {
      // Return prefix starting requirement warning message
      return strings_catalog.phone_must_start_01;
    } else {
      // Empty action block to satisfy compiler
    }
    // Retrieve third digit character index point
    final String third_char = clean_digits[2];
    // Verify operator digit matches standard Egyptian mobile code using Yoda style check
    if ('0' != third_char && '1' != third_char && '2' != third_char && '5' != third_char) {
      // Return operator matching validation error message
      return strings_catalog.phone_invalid_operator;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing validation success
    return null;
  }

  /// Handles the form submission and triggers the code sending process.
  void _submit() async {
    setState(() {
      _form_submitted = true; // Marking form as submitted
    });
    
    /// Triggering standard Flutter form validation.
    if (!_form_key.currentState!.validate()) {
      return;
    }
    
    /// Activating the loading state.
    setState(() {
      _is_loading = true;
    });
    
    /// Simulating a network request for sending the reset code.
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      /// Deactivating loading and triggering the code sent callback.
      setState(() {
        _is_loading = false;
      });
      widget.on_code_sent(_phone_ctrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving localized strings and directionality info.
    final s = AppStrings.of(context);
    final bool is_arabic = s.is_arabic;
    
    /// Check if system brightness matches dark mode.
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    
    /// Dynamically resolved colors.
    final Color background_color = true == is_dark ? AppColors.background_dark : AppColors.background_light;
    final Color text_primary = true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary;
    final Color card_color = true == is_dark ? AppColors.surface_dark : Colors.white;
    final Color border_color = true == is_dark ? AppColors.border_dark : AppColors.border_light;

    return Scaffold(
      backgroundColor: background_color, // Applying theme background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // Content padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12), // Top margin

              /// Navigation and language control row.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Stylized back button.
                  GestureDetector(
                    onTap: widget.on_back,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: card_color, // Adaptive background
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                        border: Border.all(color: border_color), // Subtle border
                      ),
                      // RotatedBox to mirror the back chevron icon in Arabic RTL mode (BUG-012)
                      child: RotatedBox(
                        // Quarter turns value set to 2 (180 degrees) for English to point to the right
                        quarterTurns: TextDirection.rtl == Directionality.of(context) ? 0 : 2,
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

              const SizedBox(height: 36), // Space before title

              /// Header section with centered title and instructions.
              Center(
                child: Column(
                  children: [
                    /// Displaying the localized title.
                    Text(
                      s.forgot_password_title,
                      style: AppTextStyles.get_forgot_password_title(is_arabic),
                    ),
                    const SizedBox(height: 8), // Vertical spacing
                    /// Displaying the localized descriptive subtitle.
                    Text(
                      s.forgot_password_subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.get_forgot_password_subtitle(is_arabic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36), // Margin before input field

              /// The phone number input form.
              Form(
                key: _form_key,
                /// Toggling auto-validation mode after the first attempt.
                autovalidateMode: _form_submitted
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: AuthTextField(
                  label: s.phone,
                  hint: s.phone_hint,
                  controller: _phone_ctrl,
                  is_phone: true,
                  keyboard_type: TextInputType.phone,
                  validator: (v) {
                    return _validate_phone(v, s);
                  },
                ),
              ),

              const SizedBox(height: 32), // Margin before action button

              /// Primary action button for sending the reset code.
              AuthButton(
                // Localized action string
                label: s.send_code,
                // Enable only when phone field is not empty using Yoda style check
                is_enabled: _phone_ctrl.text.isNotEmpty,
                // Submission callback
                on_pressed: _submit,
                // Loading state indicator
                is_loading: _is_loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

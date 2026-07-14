/*
 * File Name: reset_password_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/07/2026]
 * File Description:
 *   The Reset Password screen allows users to set a new security credential 
 *   after successful verification. It features real-time rule tracking and 
 *   follows the centralized design system.
 */

import 'package:appoynt_mobile_app/core/routing/route_export.dart'; // Centralized barrel for UI dependencies and global logic
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart'; // Exporting PasswordFieldWithRules and AuthTextField

/// The main reset password screen widget.
class ResetPasswordPage extends StatefulWidget {
  /// Callback to navigate back to the previous screen.
  final VoidCallback on_back;
  /// Callback to toggle the application's active language.
  final VoidCallback on_toggle_language;
  /// Callback executed when the password has been successfully updated.
  final VoidCallback on_password_updated;

  /// Constructor for ResetPasswordPage requiring all functional parameters.
  const ResetPasswordPage({
    super.key,
    required this.on_back,
    required this.on_toggle_language,
    required this.on_password_updated,
  });

  @override
  State<ResetPasswordPage> createState() {
    return _ResetPasswordPageState();
  }
}

/// The state class for ResetPasswordPage managing form input and state.
class _ResetPasswordPageState extends State<ResetPasswordPage> {
  /// Global key to uniquely identify and validate the reset form.
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  
  /// Controllers for the new password and its confirmation.
  final TextEditingController _password_ctrl = TextEditingController();
  final TextEditingController _confirm_ctrl = TextEditingController();
  
  /// Flag tracking whether an update request is currently in progress.
  bool _is_loading = false;
  
  /// Flag to track whether at least one submission attempt occurred.
  bool _form_submitted = false;
  
  /// Variable to store the last known locale for detecting language changes.
  Locale? _last_locale;

  @override
  // Initialize state and add listeners to controllers to refresh layout in real-time
  void initState() {
    // Invoke parent initialization
    super.initState();
    // Register listener mapping text value changes
    _password_ctrl.addListener(_on_fields_changed);
    _confirm_ctrl.addListener(_on_fields_changed);
  }

  // Method executing when input values change
  void _on_fields_changed() {
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
    // Remove listeners
    _password_ctrl.removeListener(_on_fields_changed);
    _confirm_ctrl.removeListener(_on_fields_changed);
    /// Cleaning up controllers to prevent memory leaks.
    _password_ctrl.dispose();
    _confirm_ctrl.dispose();
    super.dispose(); // Final disposal
  }

  // Validator function verifying password constraints using Yoda style check
  String? _validate_password(String? password_value, AppStrings strings_catalog) {
    // Check if input value is null or empty using Yoda style check
    if (null == password_value || password_value.isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
    } else {
      // Empty action block to satisfy compiler
    }
    // Verify minimum character length bounds using Yoda style check
    if (8 > password_value.length) {
      // Return too short warning message
      return strings_catalog.too_short;
    } else {
      // Empty action block to satisfy compiler
    }
    // Verify maximum character length bounds using Yoda style check
    if (30 < password_value.length) {
      // Return too long warning message
      return strings_catalog.password_too_long;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing validation success
    return null;
  }

  /// Handles the form submission and triggers the update process.
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
    
    /// Simulating a network request for password update.
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      /// Deactivating loading and triggering the success callback.
      setState(() {
        _is_loading = false;
      });
      widget.on_password_updated();
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
      
      /// Using bottomNavigationBar to keep the action button fixed above the keyboard.
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          /// Adjusting bottom padding dynamically based on keyboard presence.
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 12,
        ),
        child: AuthButton(
          // Localized action string
          label: s.update_password,
          // Enable only when both password fields are not empty using Yoda style check
          is_enabled: _password_ctrl.text.isNotEmpty && _confirm_ctrl.text.isNotEmpty,
          // Submission callback
          on_pressed: _submit,
          // Loading indicator
          is_loading: _is_loading,
        ),
      ),

      body: SafeArea(
        child: GestureDetector(
          /// Dismissing keyboard when tapping outside input fields.
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24), // Content padding
            child: Form(
              key: _form_key,
              /// Toggling auto-validation mode after the first attempt.
              autovalidateMode: _form_submitted
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
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
                            // Quarter turns set to 0 to keep the back chevron pointing left in both languages
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
                        light: false, // Standard dark icons
                      ),
                    ],
                  ),

                  const SizedBox(height: 32), // Space before titles

                  /// Header section containing title and instructions.
                  Center(
                    child: Column(
                      children: [
                        Text(
                          s.create_new_password,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.get_forgot_password_title(is_arabic), // Reusing stylized typography
                        ),
                        const SizedBox(height: 8), // Vertical spacing
                        Text(
                          s.reset_password_subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.get_forgot_password_subtitle(is_arabic), // Reusing body style
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32), // Margin before fields

                  /// Specialized password input field with real-time requirement tracking.
                  PasswordFieldWithRules(
                    key: const ValueKey('reset_password_field'),
                    controller: _password_ctrl,
                    label: s.new_password_label,
                    hint: s.new_password_hint,
                    text_input_action: TextInputAction.next,
                    validator: (v) {
                      return _validate_password(v, s);
                    },
                  ),

                  const SizedBox(height: 16), // Space between fields

                  /// Confirmation field to ensure password entry matches.
                  AuthTextField(
                    label: s.confirm_password,
                    hint: s.confirm_password_hint,
                    controller: _confirm_ctrl,
                    is_password: true,
                    text_input_action: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return s.field_required;
                      }
                      /// Checking if the confirmation matches the original value.
                      if (v != _password_ctrl.text) {
                        return s.password_mismatch;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24), // Bottom padding for scroll
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

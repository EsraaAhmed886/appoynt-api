/*
 * File Name: reset_password_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
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
    /// Cleaning up controllers to prevent memory leaks.
    _password_ctrl.dispose();
    _confirm_ctrl.dispose();
    super.dispose(); // Final disposal
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
        child: SizedBox(
          width: double.infinity,
          height: 52, // Standard button height
          child: ElevatedButton(
            /// Disabling button when loading.
            onPressed: _is_loading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary_color, // Brand primary color
              /// Semi-transparent color when disabled.
              disabledBackgroundColor: AppColors.primary_color.withValues(alpha: 0.6),
              elevation: 0, // Flat design
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14), // Rounded corners
              ),
            ),
            /// Displaying either a progress spinner or localized text.
            child: true == _is_loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : Text(
                    s.update_password,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
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
                          child: Icon(
                            true == is_arabic
                                ? Icons.arrow_forward_ios_rounded // RTL icon
                                : Icons.arrow_back_ios_new_rounded, // LTR icon
                            size: 16,
                            color: text_primary, // Primary color
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
                      if (v == null || v.isEmpty) {
                        return s.field_required;
                      }
                      return null; // Detailed validation handled internally
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

/*
 * File Name: reset_password_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart,
 *   package:appoynt_mobile_app/core/di/service_locator.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
 * File Description: The Reset Password screen allows users to set a new security credential
 *   after successful verification. It features real-time rule tracking and
 *   follows the centralized design system.
 */

// Centralized barrel for UI dependencies and global logic
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Exporting PasswordFieldWithRules and AuthTextField
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';
// Importing bloc consumer and provider utilities
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing auth business state controller cubit definitions
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
// Importing dependency injection service locator setup representation
import 'package:appoynt_mobile_app/core/di/service_locator.dart';

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
        } else {
          // Do nothing if the widget is no longer mounted
        }
      });
    } else {
      // Do nothing since form has not been submitted or locale is unchanged
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
  void _submit(BuildContext submission_context) {
    setState(() {
      _form_submitted = true; // Marking form as submitted
    });
    
    /// Triggering standard Flutter form validation.
    if (false == _form_key.currentState!.validate()) {
      return;
    } else {
      // Proceed if form is valid
    }
    
    // Dispatch reset password event to AuthCubit
    submission_context.read<AuthCubit>().reset_password(new_password: _password_ctrl.text);
  }

  // Helper getter checking if all password reset fields are valid and matching
  bool get _is_reset_form_valid {
    // Retrieve password input value
    final String pw = _password_ctrl.text;
    // Retrieve confirm password input value
    final String cpw = _confirm_ctrl.text;
    // Check if new password passes all validation checks using Yoda style check
    final bool is_pw_valid = (null == _validate_password(pw, AppLocalizations.of(context)));
    // Return true if password is valid and confirm password matches it using Yoda style comparison
    return is_pw_valid && cpw == pw;
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving localized strings and directionality info.
    final s = AppStrings.of(context);
    final bool is_arabic = s.is_arabic;

    // Return BlocProvider setting up AuthCubit on top of the tree
    return BlocProvider<AuthCubit>.value(
      value: get_it<AuthCubit>(),
      // Bind consumer widget to intercept state changes
      child: BlocConsumer<AuthCubit, AuthState>(
        // Listener callback intercepts transition changes
        listener: (context, state) {
          // Check if reset password succeeds using Yoda style check
          if (state is ResetPasswordSuccess) {
            // Trigger password updated success callback
            widget.on_password_updated();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else {
            // Empty action block to satisfy compiler
          }
        },
        // Builder rendering UI components based on state updates
        builder: (context, state) {
          // Return Scaffold container layout settings
          return Scaffold(
            /// Using bottomNavigationBar to keep the action button fixed above the keyboard.
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.space_xxl,
                right: AppSpacing.space_xxl,
                /// Adjusting bottom padding dynamically based on keyboard presence using spacing tokens
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.space_xxl,
                top: AppSpacing.space_l,
              ),
              child: AuthButton(
                // Localized action string
                label: s.update_password,
                // Enable only when all validation rules pass and confirm password matches
                is_enabled: _is_reset_form_valid,
                // Submission callback
                on_pressed: () {
                  // Submit form under context
                  _submit(context);
                },
                // Loading indicator
                is_loading: state is AuthLoading,
              ),
            ),

            body: SafeArea(
              child: GestureDetector(
                /// Dismissing keyboard when tapping outside input fields.
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xxl), // Content padding
                  child: Form(
                    key: _form_key,
                    /// Toggling auto-validation mode after the first attempt.
                    autovalidateMode: _form_submitted
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.space_xl), // Top margin notch spacing

                        /// Navigation and language control row.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// Stylized back button.
                            // Reusable squircle back button component
                            AppBackButton(onTap: widget.on_back),
                            /// Globally centralized language switching button.
                            GlobalLanguageButton(
                              is_arabic: is_arabic,
                              on_tap: widget.on_toggle_language,
                              light: false, // Standard dark icons
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.space_xxxl), // Space before titles

                        /// Header section containing title and instructions.
                        Center(
                          child: Column(
                            children: [
                              Text(
                                s.create_new_password,
                                textAlign: TextAlign.center,
                                // Reusing stylized typography passing context
                                style:
                                    AppTextStyles.get_forgot_password_title(context, is_arabic),
                              ),
                              const SizedBox(height: AppSpacing.space_m), // Vertical spacing
                              Text(
                                s.reset_password_subtitle,
                                textAlign: TextAlign.center,
                                // Reusing body style passing context
                                style: AppTextStyles.get_forgot_password_subtitle(
                                    context,
                                    is_arabic),
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
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.space_xxl), // Margin before fields

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

                        const SizedBox(height: AppSpacing.space_xl), // Space between fields

                        /// Confirmation field to ensure password entry matches.
                        AuthTextField(
                          label: s.confirm_password,
                          hint: s.confirm_password_hint,
                          controller: _confirm_ctrl,
                          is_password: true,
                          text_input_action: TextInputAction.done,
                          validator: (v) {
                            if (null == v || v.isEmpty) {
                              return s.field_required;
                            } else if (v != _password_ctrl.text) {
                              return s.password_mismatch;
                            } else {
                              return null;
                            }
                          },
                        ),

                        const SizedBox(height: AppSpacing.space_xxl), // Bottom padding for scroll
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

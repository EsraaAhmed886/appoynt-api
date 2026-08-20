/*
 * File Name: forgot_password_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart,
 *   package:appoynt_mobile_app/core/di/service_locator.dart,
 *   package:flutter_bloc/flutter_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: The Forgot Password screen allows users to request a reset code via
 *   their phone number. It follows the centralized design system and
 *   supports full bilingual localization.
 */

// Centralized barrel for UI dependencies and global logic
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Barrel file exporting AuthTextField
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';
// Importing bloc consumer and provider utilities
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing auth business state controller cubit definitions
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
// Importing dependency injection service locator setup representation
import 'package:appoynt_mobile_app/core/di/service_locator.dart';

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
  void _submit(BuildContext submission_context) {
    setState(() {
      _form_submitted = true; // Marking form as submitted
    });
    
    /// Triggering standard Flutter form validation.
    if (false == _form_key.currentState!.validate()) {
      return;
    } else {
      // Proceed with submission if form is valid
    }
    
    // Dispatch forgot password event to AuthCubit
    submission_context.read<AuthCubit>().forgot_password(_phone_ctrl.text.trim());
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
          // Check if request succeeds using Yoda style check
          if (state is ForgotPasswordSuccess) {
            // Trigger code sent navigation callback
            widget.on_code_sent(_phone_ctrl.text.trim());
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
            body: SafeArea(
              // LayoutBuilder to measure viewport height constraints dynamically
              child: LayoutBuilder(
                // Builder callback receiving layouts constraints
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
                        // Padding container layout
                        child: Padding(
                          // Apply horizontal padding using spacing tokens instead of raw pixels
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xxl),
                          // Main Column organizing layout children
                          child: Column(
                            // Align starting from the horizontal edge
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  /// Stylized back button.
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
                              const SizedBox(height: AppSpacing.space_xxxl),

                              /// Header section with centered title and instructions.
                              Center(
                                // Column structuring headers vertically
                                child: Column(
                                  // Children list
                                  children: [
                                    /// Displaying the localized title.
                                    Text(
                                      // Localized title
                                      s.forgot_password_title,
                                      // Pull forgot password title styling passing context
                                      style: AppTextStyles.get_forgot_password_title(context, is_arabic),
                                    ),
                                    // Spacing gap using spacing constants instead of magic numbers
                                    const SizedBox(height: AppSpacing.space_m),
                                    /// Displaying the localized descriptive subtitle.
                                    Text(
                                      // Localized description body
                                      s.forgot_password_subtitle,
                                      // Center align text
                                      textAlign: TextAlign.center,
                                      // Pull forgot password subtitle styling passing context
                                      style: AppTextStyles.get_forgot_password_subtitle(context, is_arabic),
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

                              // Margin before input field using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxl),

                              /// The phone number input form.
                              Form(
                                // Bind global identification key
                                key: _form_key,
                                /// Toggling auto-validation mode after the first attempt.
                                autovalidateMode: _form_submitted
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.disabled,
                                // Input field widget
                                child: AuthTextField(
                                  // Localized phone label string
                                  label: s.phone,
                                  // Localized phone input hint
                                  hint: s.phone_hint,
                                  // Bind controller
                                  controller: _phone_ctrl,
                                  // Enable operator logic
                                  is_phone: true,
                                  // Configure input type layout keyboard
                                  keyboard_type: TextInputType.phone,
                                  // Validator function mapping rules
                                  validator: (v) {
                                    // Invoke validator check helper
                                    return _validate_phone(v, s);
                                  },
                                ),
                              ),

                              // Spacer pushing button to the bottom while maintaining scroll support
                              const Spacer(),

                              // Margin before action button using spacing constants instead of magic numbers
                              const SizedBox(height: AppSpacing.space_xxxl),

                              /// Primary action button for sending the reset code.
                              AuthButton(
                                // Localized action string
                                label: s.send_code,
                                // Enable only when phone field is not empty using Yoda style check
                                is_enabled: _phone_ctrl.text.isNotEmpty,
                                // Submission callback
                                on_pressed: () {
                                  // Submit form under context
                                  _submit(context);
                                },
                                // Loading state indicator
                                is_loading: state is AuthLoading,
                              ),
                              // Bottom margin/spacing using spacing constants instead of magic numbers
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

/*
 * File Name: register_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart,
 *   package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart,
 *   package:appoynt_mobile_app/core/di/service_locator.dart,
 *   package:flutter/gestures.dart,
 *   package:flutter_bloc/flutter_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Renders the registration page containing the form fields, terms check box,
 *   and validations adapting fully to light/dark themes and localizations.
 */

// Importing core theme configurations and layout definitions
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing shared auth layout button and input fields widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';
// Importing auth business state controller cubit definitions
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
// Importing dependency injection service locator setup representation
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Importing gesture recognizer classes for inline TextSpan links
import 'package:flutter/gestures.dart';
// Importing bloc consumer and provider utilities
import 'package:flutter_bloc/flutter_bloc.dart';

// Stateful widget class representing the primary registration gate interface
class RegisterPage extends StatefulWidget {
  // Navigation event callback directing users to OTP verification screens, passing phone number
  final ValueChanged<String> on_go_to_otp;

  // Navigation event callback returning users back to the login screen
  final VoidCallback on_go_to_login;

  // Configuration callback switching language state options
  final VoidCallback on_toggle_language;

  // Constructor mapping callback settings
  const RegisterPage({
    super.key,
    required this.on_go_to_otp,
    required this.on_go_to_login,
    required this.on_toggle_language,
  });

  @override
  // Create state class instance for registration lifecycle
  State<RegisterPage> createState() {
    // Return state tracking class instance
    return _RegisterPageState();
  }
}

// State tracking class managing input controller values
class _RegisterPageState extends State<RegisterPage> {
  // Unique global identification key validating credential fields form state
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();

  // Text controllers tracking individual user inputs
  final TextEditingController _first_name_ctrl = TextEditingController();
  final TextEditingController _last_name_ctrl = TextEditingController();
  final TextEditingController _email_ctrl = TextEditingController();
  final TextEditingController _phone_ctrl = TextEditingController();
  final TextEditingController _password_ctrl = TextEditingController();
  final TextEditingController _confirm_ctrl = TextEditingController();

  // State flags monitoring interaction progress
  bool _agree_to_terms = false;
  bool _terms_error = false;
  bool _form_submitted = false;

  // Cache pointer recording last configured locale settings
  Locale? _last_locale;

  // Listener callback to refresh state on text input changes
  late final VoidCallback _input_listener;

  @override
  // Initialize state and add listeners to all text fields to refresh build on text updates
  void initState() {
    // Invoke parent initialization
    super.initState();
    // Clear any leftover auth error from previous screens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        get_it<AuthCubit>().reset();
      } else {
        // No action needed
      }
    });
    // Instantiate input listener callback
    _input_listener = () {
      // Check active state using Yoda style check
      if (true == mounted) {
        // Refresh layout state to update button colors
        setState(() {});
      } else {
        // Empty action block to satisfy compiler
      }
    };
    // Attach listener to all controllers
    _first_name_ctrl.addListener(_input_listener);
    _last_name_ctrl.addListener(_input_listener);
    _email_ctrl.addListener(_input_listener);
    _phone_ctrl.addListener(_input_listener);
    _password_ctrl.addListener(_input_listener);
    _confirm_ctrl.addListener(_input_listener);
  }

  @override
  // Track system dependencies changes to trace language switches
  void didChangeDependencies() {
    // Invoke parent dependency listeners
    super.didChangeDependencies();
    // Retrieve active locale settings from context configurations
    final Locale active_locale = Localizations.localeOf(context);
    // Force form revalidation if locale settings changed after submission check using Yoda style
    if (true == _form_submitted &&
        null != _last_locale &&
        _last_locale != active_locale) {
      // Defer validation processing frame until layout registers settle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check active state
        if (true == mounted) {
          // Re-validate credential fields
          _form_key.currentState?.validate();
        } else {
          // Empty block to satisfy compiler
        }
      });
    } else {
      // Empty block to satisfy compiler
    }
    // Update cache pointer representation
    _last_locale = active_locale;
  }

  @override
  // Clean up controller logic parameters to prevent memory leaks
  void dispose() {
    // Clear any auth error on exit
    get_it<AuthCubit>().reset();
    // Remove listeners from all controllers
    _first_name_ctrl.removeListener(_input_listener);
    _last_name_ctrl.removeListener(_input_listener);
    _email_ctrl.removeListener(_input_listener);
    _phone_ctrl.removeListener(_input_listener);
    _password_ctrl.removeListener(_input_listener);
    _confirm_ctrl.removeListener(_input_listener);
    // Dispose text controller resources
    _first_name_ctrl.dispose();
    _last_name_ctrl.dispose();
    _email_ctrl.dispose();
    _phone_ctrl.dispose();
    _password_ctrl.dispose();
    _confirm_ctrl.dispose();
    // Invoke base layout disposal configurations
    super.dispose();
  }

  // Pure validation helper checking password security and personal info rules
  bool _is_password_valid(
    String password, {
    String? firstName,
    String? lastName,
    String? email,
  }) {
    // Check minimum and maximum character length constraints using Yoda style check
    if (8 > password.length || 30 < password.length) {
      return false;
    } else {
      // Length requirements met
    }

    // Allowed characters whitelist validation: letters, digits, and standard symbols
    if (false == RegExp(r'^[A-Za-z0-9@#$%^&*!_~+=.-]+$').hasMatch(password)) {
      return false;
    } else {
      // Characters within allowed whitelist
    }

    // Complexity verification: must have uppercase, lowercase, digit, and special symbol
    final bool has_lower = RegExp(r'[a-z]').hasMatch(password);
    final bool has_upper = RegExp(r'[A-Z]').hasMatch(password);
    final bool has_digit = RegExp(r'[0-9]').hasMatch(password);
    final bool has_special = RegExp(r'[@#$%^&*!_~+=.-]').hasMatch(password);
    if (false == has_lower ||
        false == has_upper ||
        false == has_digit ||
        false == has_special) {
      return false;
    } else {
      // Complexity constraints met
    }

    // Personal info defense: reject passwords containing name or email prefix
    final String lower_pw = password.toLowerCase();

    // Check first name if available and at least 2 characters long
    if (null != firstName && firstName.trim().length >= 2) {
      if (true == lower_pw.contains(firstName.trim().toLowerCase())) {
        return false;
      } else {
        // First name not contained in password
      }
    } else {
      // No first name check needed
    }

    // Check last name if available and at least 2 characters long
    if (null != lastName && lastName.trim().length >= 2) {
      if (true == lower_pw.contains(lastName.trim().toLowerCase())) {
        return false;
      } else {
        // Last name not contained in password
      }
    } else {
      // No last name check needed
    }

    // Check email prefix before '@' symbol
    if (null != email && email.contains('@')) {
      final String prefix = email.split('@').first.trim();
      if (prefix.length >= 3 && true == lower_pw.contains(prefix.toLowerCase())) {
        return false;
      } else {
        // Email prefix not contained in password
      }
    } else {
      // No email prefix check needed
    }

    // All password safety rules passed
    return true;
  }

  // Helper getter checking if all registration fields contain valid values in real-time (BUG-004)
  bool get _is_form_valid {
    // Validate first name field using our name rules
    final String first_name = _first_name_ctrl.text.trim();
    if (3 > first_name.length || 50 < first_name.length) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }
    if (false == RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$').hasMatch(first_name)) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }

    // Validate last name field using our name rules
    final String last_name = _last_name_ctrl.text.trim();
    if (3 > last_name.length || 50 < last_name.length) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }
    if (false == RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$').hasMatch(last_name)) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }

    // Validate email field using the strict email regex
    final String email = _email_ctrl.text.trim();
    final bool is_email_valid = RegExp(
            r'^[a-zA-Z0-9]+([._-][a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,4}$')
        .hasMatch(email);
    if (!is_email_valid) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }

    // Validate phone number field using the Egyptian mobile format rules
    String clean_digits = _phone_ctrl.text;
    final Map<String, String> translation_map = {
      '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
      '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9'
    };
    translation_map.forEach((arabic, english) {
      clean_digits = clean_digits.replaceAll(arabic, english);
    });
    clean_digits = clean_digits.replaceAll(RegExp(r'[^\d]'), '');
    if (11 != clean_digits.length) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }
    if (false == clean_digits.startsWith('01')) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }
    final String third_char = clean_digits[2];
    if ('0' != third_char && '1' != third_char && '2' != third_char && '5' != third_char) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }

    // Validate password using security rules helper
    final String password = _password_ctrl.text;
    if (false ==
        _is_password_valid(
          password,
          firstName: first_name,
          lastName: last_name,
          email: email,
        )) {
      return false;
    } else {
      // Password is valid
    }

    // Validate password confirmation match
    final String confirm_password = _confirm_ctrl.text;
    if (confirm_password != password || confirm_password.isEmpty) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }

    // Validate terms agreement checkbox is checked using Yoda style check
    if (true != _agree_to_terms) {
      return false;
    } else {
      // Empty action block to satisfy compiler
    }

    // All validation checks passed successfully
    return true;
  }

  // Method validating input fields and triggering registration submit events
  void _submit(BuildContext submission_context) {
    // Set state indicators on submission attempts
    setState(() {
      // Mark form submitted to enable auto validation modes
      _form_submitted = true;
      // Calculate terms checkbox validation failure
      _terms_error = false == _agree_to_terms;
    });

    // Run form validation checks
    final bool is_valid = _form_key.currentState!.validate();

    // Terminate submission workflow if validation fails or terms are not accepted using Yoda style check
    if (!is_valid || true == _terms_error) {
      // Terminate execution
      return;
    } else {
      // Empty action block to satisfy compiler
    }

    // Dispatch registration event to AuthCubit
    submission_context.read<AuthCubit>().register(
          first_name: _first_name_ctrl.text.trim(),
          last_name: _last_name_ctrl.text.trim(),
          email: _email_ctrl.text.trim(),
          phone: _phone_ctrl.text.trim(),
          password: _password_ctrl.text,
        );
  }

  // Validator function verifying general name field entries using Yoda style check
  String? _validate_name(String? name_value, AppStrings strings_catalog) {
    // Check if input value is null or empty using Yoda style check
    if (null == name_value || name_value.trim().isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
    } else {
      // Empty action block to satisfy compiler
    }
    // Retrieve trimmed value representation
    final String trimmed = name_value.trim();
    // Validate length rules for min 3 and max 50 constraints using Yoda style check
    if (3 > trimmed.length || 50 < trimmed.length) {
      // Return localized length limit error message
      return strings_catalog.name_length_error;
    } else {
      // Empty action block to satisfy compiler
    }
    // Validate character rules allowing only letters and spaces using Yoda style check
    if (false == RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$').hasMatch(trimmed)) {
      // Return localized letters-only error message
      return strings_catalog.name_letters_only_error;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing validation success
    return null;
  }

  // Validator function verifying email string structures using Yoda style check
  String? _validate_email(String? email_value, AppStrings strings_catalog) {
    // Check if input value is null or empty
    if (null == email_value || email_value.trim().isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
    } else {
      // Empty action block to satisfy compiler
    }
    // Verify strict regex syntax matching check (BUG-003)
    final bool is_email_pattern_valid = RegExp(
            r'^[a-zA-Z0-9]+([._-][a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,4}$')
        .hasMatch(email_value.trim());
    if (!is_email_pattern_valid) {
      // Return format warning string
      return strings_catalog.invalid_email;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing validation success
    return null;
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
    // Verify allowed characters whitelist
    if (false == RegExp(r'^[A-Za-z0-9@#$%^&*!_~+=.-]+$').hasMatch(password_value)) {
      return strings_catalog.auth_registration_password_invalid_characters;
    } else {
      // Empty action block to satisfy compiler
    }
    // Check personal details (first name, last name, email prefix)
    final String lower_pw = password_value.toLowerCase();
    final String first_name = _first_name_ctrl.text.trim();
    if (first_name.length >= 2 && true == lower_pw.contains(first_name.toLowerCase())) {
      return strings_catalog.auth_registration_password_contains_user_info;
    } else {
      // Empty action block to satisfy compiler
    }
    final String last_name = _last_name_ctrl.text.trim();
    if (last_name.length >= 2 && true == lower_pw.contains(last_name.toLowerCase())) {
      return strings_catalog.auth_registration_password_contains_user_info;
    } else {
      // Empty action block to satisfy compiler
    }
    final String email = _email_ctrl.text.trim();
    if (true == email.contains('@')) {
      final String email_prefix = email.split('@').first.trim();
      if (email_prefix.length >= 3 && true == lower_pw.contains(email_prefix.toLowerCase())) {
        return strings_catalog.auth_registration_password_contains_user_info;
      } else {
        // Empty action block to satisfy compiler
      }
    } else {
      // Empty action block to satisfy compiler
    }
    // Verify complexity requirements
    final bool has_lower = RegExp(r'[a-z]').hasMatch(password_value);
    final bool has_upper = RegExp(r'[A-Z]').hasMatch(password_value);
    final bool has_digit = RegExp(r'[0-9]').hasMatch(password_value);
    final bool has_special = RegExp(r'[@#$%^&*!_~+=.-]').hasMatch(password_value);
    if (!has_lower || !has_upper || !has_digit || !has_special) {
      return strings_catalog.password_must;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing validation success
    return null;
  }

  // Validator function verifying matching password confirmation checks using Yoda style check
  String? _validate_confirm_password(String? confirm_value, AppStrings strings_catalog) {
    // Check if input value is null or empty
    if (null == confirm_value || confirm_value.isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
    } else {
      // Empty action block to satisfy compiler
    }
    // Verify equality checks matching original passwords
    if (confirm_value != _password_ctrl.text) {
      // Return mismatch warning strings
      return strings_catalog.password_mismatch;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing validation success
    return null;
  }

  @override
  // Build method drawing page UI elements
  Widget build(BuildContext context) {
    // Load custom translations catalog dictionary configurations
    final AppLocalizations s = AppLocalizations.of(context);
    // Check if Arabic directionality is active
    final bool is_arabic = s.is_arabic;
    // Check if system brightness is dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return BlocProvider setting up AuthCubit on top of the register tree
    return BlocProvider<AuthCubit>.value(
      value: get_it<AuthCubit>(),
      // Bind consumer widget to intercept state changes
      child: BlocConsumer<AuthCubit, AuthState>(
        // Listener callback intercepts transition changes
        listener: (context, state) {
          // Check if registration succeeds using Yoda style check
          if (state is RegisterSuccess) {
            // Trigger navigation callback on success, passing the phone number
            widget.on_go_to_otp(_phone_ctrl.text);
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
            // Wrap contents in SafeArea layout structure to bypass top display notches
            body: SafeArea(
              // Wrap contents inside horizontal margins spacing scroll view
              child: SingleChildScrollView(
                // Apply layout padding margins using spacing constants (including top notch spacing)
                padding: const EdgeInsets.only(
                  left: AppSpacing.space_xxl,
                  right: AppSpacing.space_xxl,
                  top: AppSpacing.space_xl,
                  bottom: AppSpacing.space_xl,
                ),
                // child Form container wrapping fields validation
                child: Form(
                  // Bind global identification key
                  key: _form_key,
                  // Toggle validation checks triggers dynamically based on
                  // submission attempts using Yoda style check
                  autovalidateMode: true == _form_submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  // Column layout structuring credentials fields
                  child: Column(
                    // Align column elements starting from horizontal edge
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Contain visual children list
                    children: [
                      // Top vertical space margin using spacing constants
                      const SizedBox(height: AppSpacing.space_s),

                      // Top row navigation and language bar
                      Row(
                        // Space items between left and right edges
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // children list
                        children: [
                          // Reusable squircle back button component
                          AppBackButton(onTap: widget.on_go_to_login),
                          // Globally centralized language switcher button
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

                      // Centered header titles column
                      Center(
                        // Column layout structuring titles vertically
                        child: Column(
                          // children list
                          children: [
                            // Text widget displaying Welcoming title
                            Text(
                              // Localized registration title string
                              s.register_title,
                              // Align text center
                              textAlign: TextAlign.center,
                              // Pull register title styling
                              style: AppTextStyles.get_register_title(context, is_arabic),
                            ),
                            // Tight spacing divider using spacing constants
                            const SizedBox(height: AppSpacing.space_s),
                            // Text widget displaying welcoming description
                            Text(
                              // Localized help subtitle string
                              s.register_subtitle,
                              // Align text center
                              textAlign: TextAlign.center,
                              // Pull register subtitle styling
                              style: AppTextStyles.get_register_subtitle(context, is_arabic),
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

                      // Space before input fields using spacing constants
                      const SizedBox(height: AppSpacing.space_m),

                      // Row layout placing first and last name fields next to each other
                      Row(
                        // Align items starting at top vertical heights
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // children list
                        children: [
                          // First name field wrapper
                          Expanded(
                            // Custom auth text field component
                            child: AuthTextField(
                              // Localized input field label
                              label: s.first_name_label,
                              // Localized placeholder hint
                              hint: s.first_name_hint,
                              // Bind text controller
                              controller: _first_name_ctrl,
                              // Inline validator check
                              validator: (val) {
                                // Execute validator method
                                return _validate_name(val, s);
                              },
                            ),
                          ),
                          // Spacing gap between fields using spacing constants
                          const SizedBox(width: AppSpacing.space_l),
                          // Last name field wrapper
                          Expanded(
                            // Custom auth text field component
                            child: AuthTextField(
                              // Localized input field label
                              label: s.last_name_label,
                              // Localized placeholder hint
                              hint: s.last_name_hint,
                              // Bind text controller
                              controller: _last_name_ctrl,
                              // Inline validator check
                              validator: (val) {
                                // Execute validator method
                                return _validate_name(val, s);
                              },
                            ),
                          ),
                        ],
                      ),

                      // Spacing gap between fields using spacing constants
                      const SizedBox(height: AppSpacing.space_m),

                      // Email input field widget
                      AuthTextField(
                        // Localized input field label
                        label: s.email,
                        // Localized placeholder hint
                        hint: s.email_hint,
                        // Bind text controller
                        controller: _email_ctrl,
                        // Select keyboard type for email characters format
                        keyboard_type: TextInputType.emailAddress,
                        // Inline validator check
                        validator: (val) {
                          // Execute validator method
                          return _validate_email(val, s);
                        },
                      ),

                      // Spacing gap between fields using spacing constants
                      const SizedBox(height: AppSpacing.space_m),

                      // Phone input field widget
                      AuthTextField(
                        // Localized input field label
                        label: s.phone,
                        // Localized placeholder hint
                        hint: s.phone_hint,
                        // Bind text controller
                        controller: _phone_ctrl,
                        // Enable formatting rules for phone types
                        is_phone: true,
                        // Inline validator check
                        validator: (val) {
                          // Execute validator method
                          return _validate_phone(val, s);
                        },
                      ),

                      // Spacing gap between fields using spacing constants
                      const SizedBox(height: AppSpacing.space_m),

                      // Password strength checker input field widget
                      PasswordFieldWithRules(
                        // Bind controller
                        controller: _password_ctrl,
                        // Localized input field label
                        label: s.password,
                        // Localized placeholder hint
                        hint: s.password_hint,
                        // Inline validator check
                        validator: (val) {
                          // Execute validator method
                          return _validate_password(val, s);
                        },
                      ),

                      // Spacing gap between fields using spacing constants
                      const SizedBox(height: AppSpacing.space_m),

                      // Confirmation password input field widget
                      AuthTextField(
                        // Localized input field label
                        label: s.confirm_password,
                        // Localized placeholder hint
                        hint: s.confirm_password_hint,
                        // Bind text controller
                        controller: _confirm_ctrl,
                        // Obfuscate characters
                        is_password: true,
                        // Finish typing action layout keyboard trigger
                        text_input_action: TextInputAction.done,
                        // Inline validator check
                        validator: (val) {
                          // Execute validator method
                          return _validate_confirm_password(val, s);
                        },
                      ),

                      // Spacing gap before terms agreement using spacing constants
                      const SizedBox(height: AppSpacing.space_l),

                      // GestureDetector wrapping terms checkbox row
                      GestureDetector(
                        // Toggle state checkbox tap handler
                        onTap: () {
                          // Update state flags
                          setState(() {
                            // Toggle agreement check
                            _agree_to_terms = false == _agree_to_terms;
                            // Clear validation error if checkbox gets selected using Yoda style check
                            if (true == _agree_to_terms) {
                              // Clear error status
                              _terms_error = false;
                            } else {
                              // Empty action block to satisfy compiler
                            }
                          });
                        },
                        // Row layout holding indicator box and agreement terms text
                        child: Row(
                          // Align indicators at top edge
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // children list
                          children: [
                            // Animated checkbox container mapping states
                            AnimatedContainer(
                              // Duration parameter
                              duration: const Duration(milliseconds: 200),
                              // Width diameter
                              width: 22.0,
                              // Height diameter
                              height: 22.0,
                              // Shift box slightly to align with text line heights
                              margin: const EdgeInsets.only(top: 1.0),
                              // Visual decorations
                              decoration: BoxDecoration(
                                // Dynamic background color matching active state using
                                // Yoda style check
                                color: true == _agree_to_terms
                                    ? AppColors.primary_color
                                    : (is_dark
                                        ? AppColors.surface_dark
                                        : AppColors.background_light),
                                // Corner radius curves using spacing constants
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radius_m),
                                // Border boundaries dynamic color resolving using
                                // Yoda style check
                                border: Border.all(
                                  // Select border color based on error, active, or
                                  // default states using Yoda style check
                                  color: true == _terms_error
                                      ? AppColors.error
                                      : (true == _agree_to_terms
                                          ? AppColors.primary_color
                                          : (is_dark
                                              ? AppColors.border_dark
                                              : AppColors.border_light)),
                                  // Border line width
                                  width: 1.8,
                                ),
                              ),
                              // Check icon centered inside box using Yoda style check
                              child: true == _agree_to_terms
                                  ? const Icon(
                                      // Check indicator icon
                                      Icons.check_rounded,
                                      // Icon size
                                      size: 14.0,
                                      // Keep color white inside filled checkboxes
                                      color: AppColors.white,
                                    )
                                  : null,
                            ),
                            // Spacing gap between checkbox and labels using spacing constants
                            const SizedBox(width: AppSpacing.space_l),
                            // Expanded terms agreement text builder
                            Expanded(
                              // RichText building localized agreement clauses links
                              child: RichText(
                                // Text block representation
                                text: TextSpan(
                                  // General terms prefix text
                                  text: s.agree_to_terms,
                                  // Text styling resolving error states using Yoda style check
                                  style: AppTextStyles.get_body_medium(
                                    context,
                                    is_arabic,
                                    custom_color: true == _terms_error
                                        ? AppColors.error
                                        : (is_dark
                                            ? AppColors.text_dark_secondary
                                            : AppColors.text_light_secondary),
                                  ).copyWith(
                                    // Spacing size
                                    fontSize: 13.0,
                                    // Spacing height lines spacing
                                    height: 1.5,
                                  ),
                                  // Clickable text segments children links list
                                  children: [
                                    // Terms of service link segment
                                    TextSpan(
                                      // Localized text
                                      text: s.terms_and_conditions,
                                      // Highlighted link text styles
                                      style: const TextStyle(
                                        // Brand color highlight
                                        color: AppColors.primary_color,
                                        // Bold font weight
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Listings divider connector segment
                                    TextSpan(
                                      // Localized text
                                      text: s.and_connector,
                                      // Inherited color overrides using Yoda style check
                                      style: TextStyle(
                                        // Keep error red or default gray color
                                        color: true == _terms_error ? AppColors.error : null,
                                      ),
                                    ),
                                    // Privacy policy link segment
                                    TextSpan(
                                      // Localized text
                                      text: s.privacy_policy,
                                      // Highlighted link text styles
                                      style: const TextStyle(
                                        // Brand color highlight
                                        color: AppColors.primary_color,
                                        // Bold font weight
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Display error warning prompt below checkbox row dynamically
                      // using Yoda style check
                      true == _terms_error
                          ? Padding(
                              // Apply top spacing margin and offset alignments
                              padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                              // Row structuring warnings
                              child: Row(
                                // children list
                                children: [
                                  // Alert warning error icon
                                  const Icon(
                                    // Warning circle icon
                                    Icons.error_outline_rounded,
                                    // Set layout size
                                    size: 14.0,
                                    // Error color
                                    color: AppColors.error,
                                  ),
                                  // Spacing gap between icon and label using spacing
                                  // constants
                                  const SizedBox(width: AppSpacing.space_s),
                                  // Text rendering warning alert translations
                                  Text(
                                    // Localized terms check requirement warnings
                                    s.terms_must_agree,
                                    // Text styling
                                    style: const TextStyle(
                                      // Error color
                                      color: AppColors.error,
                                      // Small font size
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),

                      // Spacing gap before button using spacing constants
                      const SizedBox(height: AppSpacing.space_l),

                      // CTA Action button component executing account creations
                      AuthButton(
                        // Localized button text label
                        label: s.create_my_account,
                        // Enable only when all form fields contain valid values (BUG-004)
                        is_enabled: _is_form_valid,
                        // Bind submit handler callback
                        on_pressed: () {
                          // Submit form values under context
                          _submit(context);
                        },
                        // Bind loading state indicator flag
                        is_loading: state is AuthLoading,
                      ),

                      // Spacing gap before footer links using spacing constants
                      const SizedBox(height: AppSpacing.space_l),

                      // Navigation footer redirecting users back to sign in gateway
                      Center(
                        // RichText building link inline elements
                        child: RichText(
                          // Text block representation
                          text: TextSpan(
                            // Link prompt question text
                            text: s.have_account,
                            // Text styling
                            style: TextStyle(
                              // Apply Cairo or Inter fonts correctly
                              fontFamily: AppFonts.by_locale(is_arabic),
                              // Spacing size
                              fontSize: 14.0,
                              // Select secondary text color based on theme using
                              // Yoda style check
                              color: is_dark
                                  ? AppColors.text_dark_secondary
                                  : AppColors.text_light_secondary,
                            ),
                            // children list
                            children: [
                              // Clickable action anchor span widget with recognizer
                              // to prevent alignment shift
                              TextSpan(
                                // Localized sign in word prefixed with space
                                text: ' ${s.sign_in}',
                                // Bind tap event callback
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.on_go_to_login,
                                // Link text styles
                                style: TextStyle(
                                  // Apply Cairo or Inter fonts correctly
                                  fontFamily: AppFonts.by_locale(is_arabic),
                                  // Spacing size
                                  fontSize: 14.0,
                                  // High visual brand highlight
                                  color: AppColors.primary_color,
                                  // Bold font weight
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Final bottom layout safety margins using spacing constants
                      const SizedBox(height: AppSpacing.space_l),
                    ],
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

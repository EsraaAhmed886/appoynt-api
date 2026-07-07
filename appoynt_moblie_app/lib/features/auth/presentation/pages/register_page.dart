/*
 * File Name: register_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Renders the registration page containing the form fields, terms check box,
 *   and validations adapting fully to light/dark themes and localizations.
 */

// Importing core theme configurations and layout definitions
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing shared auth layout button and input fields widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';

// Stateful widget class representing the primary registration gate interface
class RegisterPage extends StatefulWidget {
  // Navigation event callback directing users to OTP verification screens
  final VoidCallback on_go_to_otp;

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
  bool _is_loading = false;
  bool _agree_to_terms = false;
  bool _terms_error = false;
  bool _form_submitted = false;

  // Cache pointer recording last configured locale settings
  Locale? _last_locale;

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

  // Method validating input fields and triggering registration submit events
  void _submit() async {
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
    if (false == is_valid || true == _terms_error) {
      // Terminate execution
      return;
    } else {
      // Empty action block to satisfy compiler
    }

    // Set loading indicator state
    setState(() {
      // Activate loading spinner
      _is_loading = true;
    });

    // Simulate network latency delay
    await Future.delayed(const Duration(seconds: 2));

    // Verify widget lifecycle state after async processing using Yoda style check
    if (true == mounted) {
      // Set loading indicator state
      setState(() {
        // Deactivate loading spinner
        _is_loading = false;
      });
      // Execute page navigation callback to OTP confirmation
      widget.on_go_to_otp();
    } else {
      // Empty action block to satisfy compiler
    }
  }

  // Validator function verifying general name field entries using Yoda style check
  String? _validate_name(String? name_value, AppStrings strings_catalog) {
    // Check if input value is null or empty
    if (null == name_value || name_value.trim().isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
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
    // Verify regex syntax matching check
    if (false == RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email_value.trim())) {
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
    // Check if input value is null or empty
    if (null == phone_value || phone_value.isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
    } else {
      // Empty action block to satisfy compiler
    }
    // Strip space dividers and format modifiers
    final String clean_digits = phone_value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    // Verify length rules for minimum Egyptian standard digit lengths
    if (clean_digits.length < 10) {
      // Return invalid format warnings
      return strings_catalog.invalid_phone;
    } else {
      // Empty action block to satisfy compiler
    }
    // Verify maximum bounds digits using Yoda style check
    if (clean_digits.length > 11) {
      // Return maximum limit warnings
      return strings_catalog.phone_max_error;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing validation success
    return null;
  }

  // Validator function verifying password constraints using Yoda style check
  String? _validate_password(String? password_value, AppStrings strings_catalog) {
    // Check if input value is null or empty
    if (null == password_value || password_value.isEmpty) {
      // Return requirements warning string
      return strings_catalog.field_required;
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

    // Return Scaffold container layout settings
    return Scaffold(
      // Apply background color dynamics adapting to brightness modes using Yoda style check
      backgroundColor: true == is_dark
          ? AppColors.background_dark
          : AppColors.background_light,
      // Wrap contents in SafeArea layout structure to bypass top display notches
      body: SafeArea(
        // Wrap contents inside horizontal margins spacing scroll view
        child: SingleChildScrollView(
          // Apply layout horizontal padding margins using spacing constants
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xxl),
          // child Form container wrapping fields validation
          child: Form(
            // Bind global identification key
            key: _form_key,
            // Toggle validation checks triggers dynamically based on submission attempts using Yoda style check
            autovalidateMode: true == _form_submitted
                // Trigger validation checks immediately on text changes
                ? AutovalidateMode.onUserInteraction
                // Disable checks during layout setup
                : AutovalidateMode.disabled,
            // Column layout structuring credentials fields
            child: Column(
              // Align column elements starting from horizontal edge
              crossAxisAlignment: CrossAxisAlignment.start,
              // Contain visual children list
              children: [
                // Top vertical space margin using spacing constants
                const SizedBox(height: AppSpacing.space_l),

                // Top row navigation and language bar
                Row(
                  // Space items between left and right edges
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // children list
                  children: [
                    // GestureDetector mapping back action button
                    GestureDetector(
                      // Bind tap event callback
                      onTap: widget.on_go_to_login,
                      // Customized visual container design
                      child: Container(
                        // Width constraints using spacing constants
                        width: 40.0,
                        // Height constraints using spacing constants
                        height: 40.0,
                        // Visual decorations
                        decoration: BoxDecoration(
                          // Container background adapts to dark mode using Yoda style check
                          color: true == is_dark ? AppColors.surface_dark : AppColors.background_light,
                          // Border radius curves using spacing constants
                          borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                          // Border colors adapt to dark mode using Yoda style check
                          border: Border.all(
                            color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                          ),
                        ),
                        // Visual icon centered inside box
                        child: Icon(
                          // Back chevron icon
                          Icons.arrow_back_ios_new_rounded,
                          // Set layout size
                          size: 18.0,
                          // Select icon color dynamically using Yoda style check
                          color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
                        ),
                      ),
                    ),
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

                // Space before header texts using spacing constants
                const SizedBox(height: AppSpacing.space_xxl),

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
                        style: AppTextStyles.get_register_title(is_arabic),
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
                        style: AppTextStyles.get_register_subtitle(is_arabic),
                      ),
                    ],
                  ),
                ),

                // Space before input fields using spacing constants
                const SizedBox(height: AppSpacing.space_xl),

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
                const SizedBox(height: AppSpacing.space_l),

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
                const SizedBox(height: AppSpacing.space_l),

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
                const SizedBox(height: AppSpacing.space_l),

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
                const SizedBox(height: AppSpacing.space_l),

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
                const SizedBox(height: AppSpacing.space_xxl),

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
                          // Dynamic background color matching active state using Yoda style check
                          color: true == _agree_to_terms
                              ? AppColors.primary_color
                              : (true == is_dark ? AppColors.surface_dark : AppColors.background_light),
                          // Corner radius curves using spacing constants
                          borderRadius: BorderRadius.circular(AppSpacing.radius_m),
                          // Border boundaries dynamic color resolving using Yoda style check
                          border: Border.all(
                            // Select border color based on error, active, or default states using Yoda style check
                            color: true == _terms_error
                                ? AppColors.error
                                : (true == _agree_to_terms ? AppColors.primary_color : (true == is_dark ? AppColors.border_dark : AppColors.border_light)),
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
                                color: Colors.white,
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
                              is_arabic,
                              custom_color: true == _terms_error
                                  ? AppColors.error
                                  : (true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary),
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
                // Display error warning prompt below checkbox row dynamically using Yoda style check
                if (true == _terms_error)
                  // Padding container wrapping text warning
                  Padding(
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
                        // Spacing gap between icon and label using spacing constants
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
                  ),

                // Spacing gap before button using spacing constants
                const SizedBox(height: AppSpacing.space_xl),

                // CTA Action button component executing account creations
                AuthButton(
                  // Localized button text label
                  label: s.create_my_account,
                  // Bind submit handler callback
                  on_pressed: _submit,
                  // Bind loading state indicator flag
                  is_loading: _is_loading,
                ),

                // Spacing gap before footer links using spacing constants
                const SizedBox(height: AppSpacing.space_xl),

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
                        // Select secondary text color based on theme using Yoda style check
                        color: true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                      ),
                      // children list
                      children: [
                        // Clickable action anchor span widget
                        WidgetSpan(
                          // GestureDetector mapping navigate to login pages
                          child: GestureDetector(
                            // Bind navigation event callback
                            onTap: widget.on_go_to_login,
                            // Text widget rendering sign in label link
                            child: Text(
                              // Localized sign in word
                              s.sign_in,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom layout padding space margins using spacing constants
                const SizedBox(height: AppSpacing.space_xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

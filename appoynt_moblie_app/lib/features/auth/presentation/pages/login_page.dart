/*
 * File Name: login_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart
 *   - package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart
 *   - package:appoynt_mobile_app/features/auth/presentation/widgets/smart_identifier_field.dart
 *   - package:appoynt_mobile_app/features/auth/presentation/widgets/smart_password_field.dart
 *   - package:flutter_bloc/flutter_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Renders the user login gateway presentation page under BLoC configurations.
 */

// Importing core theme configurations and layout definitions
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing shared auth layout button widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';
// Importing auth business state controller cubit definitions
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
// Importing dependency injection service locator setup representation
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Importing customized identifier input component field widget
import 'package:appoynt_mobile_app/features/auth/presentation/widgets/smart_identifier_field.dart';
// Importing password obfuscation selector input field widget
import 'package:appoynt_mobile_app/features/auth/presentation/widgets/smart_password_field.dart';
// Importing bloc listener and consumer wrapper utilities
import 'package:flutter_bloc/flutter_bloc.dart';

// Stateful widget class representing the primary login gateway interface
class LoginPage extends StatefulWidget {
  // Navigation event callback executed upon successful authentication
  final VoidCallback on_login_success;

  // Navigation event callback directing guests to register forms
  final VoidCallback on_go_to_register;

  // Navigation event callback launching forgot credentials workflow
  final VoidCallback on_forgot_password;

  // Configuration callback switching language state options
  final VoidCallback on_toggle_language;

  // Constructor mapping callback settings
  const LoginPage({
    super.key,
    required this.on_login_success,
    required this.on_go_to_register,
    required this.on_forgot_password,
    required this.on_toggle_language,
  });

  @override
  // Create state class instance for login widgets lifecycle
  State<LoginPage> createState() {
    // Return state tracking class instance
    return _LoginPageState();
  }
}

// State tracking class managing input controller values
class _LoginPageState extends State<LoginPage> {
  // Unique global identification key validating credential fields form state
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();

  // Text controller tracking combined user identifiers input box values
  final TextEditingController _identifier_ctrl = TextEditingController();

  // Text controller tracking user password input box values
  final TextEditingController _password_ctrl = TextEditingController();

  // Submission tracking flag checking if validation attempts occurred
  bool _form_submitted = false;

  // Resolved type category classification describing the inputs value pattern
  _InputType _detected_type = _InputType.empty;

  // Cache pointer recording last configured locale settings to trace switches
  Locale? _last_locale;

  @override
  // Initialize state registers and attach text listener functions
  void initState() {
    // Invoke standard base class initialization configurations
    super.initState();
    // Register text listener mapping input type changes dynamically
    _identifier_ctrl.addListener(_detect_input_type);
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

  // Method categorizing text inputs patterns dynamically
  void _detect_input_type() {
    // Retrieve clean text block representation
    final String val = _identifier_ctrl.text.trim();
    // Update layout states
    setState(() {
      // Check if value is empty using Yoda style check
      if (val.isEmpty) {
        // Set type category
        _detected_type = _InputType.empty;
      }
      // Check if value maps standard email characters using Yoda style check
      else if (true == val.contains('@') || true == _looks_like_email(val)) {
        // Set type category
        _detected_type = _InputType.email;
      }
      // Check if value maps numeric digits using Yoda style check
      else if (true == _looks_like_phone(val)) {
        // Set type category
        _detected_type = _InputType.phone;
      }
      // Fallback matching unknown patterns
      else {
        // Set type category
        _detected_type = _InputType.unknown;
      }
    });
  }

  // Method testing if string pattern matches standard email syntax
  bool _looks_like_email(String check_value) {
    // Return comparison checking alphabet matching and size checks
    return RegExp(r'[a-zA-Z]').hasMatch(check_value) && check_value.length > 2;
  }

  // Method testing if string pattern matches standard phone digits syntax
  bool _looks_like_phone(String check_value) {
    // Strip space dividers and standard phone formatting marks
    final String clean_digits =
        check_value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    // Return comparison verifying digits matching and length checks
    return RegExp(r'^\d+$').hasMatch(clean_digits) && clean_digits.length >= 3;
  }

  // Getter resolving the appropriate prefix icon from design system
  IconData get _prefix_icon {
    // Switch on input type classification state
    switch (_detected_type) {
      // Match email category
      case _InputType.email:
        // Return email envelope icon
        return Icons.email_outlined;
      // Match phone category
      case _InputType.phone:
        // Return phone icon
        return Icons.phone_outlined;
      // Fallback matching empty or unknown states
      default:
        // Return generic person profile icon
        return Icons.person_outline_rounded;
    }
  }

  // Method resolving input field label translation string
  String _field_label(AppStrings s) {
    // Switch on input type classification state
    switch (_detected_type) {
      // Match email category
      case _InputType.email:
        // Return translated email label
        return s.email;
      // Match phone category
      case _InputType.phone:
        // Return translated phone label
        return s.phone;
      // Fallback matching empty or unknown states
      default:
        // Return translated combined label
        return s.email_or_phone;
    }
  }

  // Method resolving input field hint translation string
  String _field_hint(AppStrings s) {
    // Switch on input type classification state
    switch (_detected_type) {
      // Match email category
      case _InputType.email:
        // Return email prompt sample hint
        return 'example@email.com';
      // Match phone category
      case _InputType.phone:
        // Return phone format hint dynamically depending on language choice using Yoda style check
        return true == s.is_arabic ? '01xxxxxxxxx' : '+1 234 567 8900';
      // Fallback matching empty or unknown states
      default:
        // Return combined enter prompt hint
        return s.enter_email_or_phone;
    }
  }

  // Getter resolving the active virtual keyboard configuration type
  TextInputType get _keyboard_type {
    // Switch on input type classification state using Yoda style
    if (_InputType.phone == _detected_type) {
      // Return numeric phone layout keyboard
      return TextInputType.phone;
    } else {
      // Return standard email character layout keyboard
      return TextInputType.emailAddress;
    }
  }

  // Method implementing validation rules verification for identifiers input
  String? _validate_identifier(
      String? input_value, AppStrings strings_catalog) {
    // Check if input value is null or empty using Yoda style check
    if (null == input_value || input_value.trim().isEmpty) {
      // Return blank requirement warning translation
      return strings_catalog.field_required;
    } else {
      // Empty action block to satisfy compiler
    }

    // Check email specific structure rules if detected using Yoda style check
    if (_InputType.email == _detected_type) {
      // Verify syntax characters mapping using Yoda style check
      if (false ==
          RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(input_value.trim())) {
        // Return invalid email translation warning
        return strings_catalog.invalid_email;
      } else {
        // Empty action block to satisfy compiler
      }
    }
    // Check phone specific structure rules if detected using Yoda style check
    else if (_InputType.phone == _detected_type) {
      // Strip helper visual separators
      final String clean_digits =
          input_value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
      // Verify minimum and maximum length threshold using Yoda style check
      if (11 != clean_digits.length) {
        // Return invalid phone translation warning
        return strings_catalog.invalid_phone;
      } else {
        // Empty action block to satisfy compiler
      }
    } else {
      // Empty action block to satisfy compiler
    }
    // Return null representing successful validation checks
    return null;
  }

  // Method validating input fields and triggering authentication events
  void _submit(BuildContext submission_context) {
    // Set submission flag tracking attempt in state registers
    setState(() {
      // Set submission flag to true
      _form_submitted = true;
    });

    // Check validation checks status of credential fields form using Yoda style check
    if (false == _form_key.currentState!.validate()) {
      // Terminate execution
      return;
    } else {
      // Empty action block to satisfy compiler
    }

    // Dispatch login credentials validation event to auth state manager cubit
    submission_context.read<AuthCubit>().login(
          // Pass clean text user identifier
          _identifier_ctrl.text.trim(),
          // Pass plain user password
          _password_ctrl.text,
        );
  }

  @override
  // Clean up controller logic parameters to prevent memory leaks
  void dispose() {
    // Remove input text listener tracking type detections
    _identifier_ctrl.removeListener(_detect_input_type);
    // Dispose identifier field controller resources
    _identifier_ctrl.dispose();
    // Dispose password field controller resources
    _password_ctrl.dispose();
    // Invoke base layout disposal configurations
    super.dispose();
  }

  @override
  // Build method compiling page UI elements
  Widget build(BuildContext context) {
    // Load custom translations catalog dictionary configurations
    final AppLocalizations s = AppLocalizations.of(context);
    // Check if Arabic directionality is active
    final bool is_arabic = s.is_arabic;
    // Check if system brightness is dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return BlocProvider setting up AuthCubit on top of tree
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
          // Check if authentication succeeds using Yoda style check
          if (state is AuthSuccess) {
            // Trigger navigation callback on success
            widget.on_login_success();
          } else {
            // Empty action block to satisfy compiler
          }
        },
        // Builder rendering UI components based on state updates
        builder: (context, state) {
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
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xxl),
                // Place page column layout
                child: Column(
                  // Align column elements starting from horizontal edge
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Contain visual children list
                  children: [
                    // Top vertical space margin using spacing constants
                    const SizedBox(height: AppSpacing.space_l),

                    // Section positioning language toggle dropdown
                    Align(
                      // Toggle layout alignments dynamically depending on language code direction using Yoda style check
                      alignment: true == is_arabic
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      // Language toggler button capsule widget
                      child: GlobalLanguageButton(
                        // Pass language direction flag
                        is_arabic: is_arabic,
                        // Pass selection toggle callback
                        on_tap: widget.on_toggle_language,
                        // Keep standard icon color mapping rules
                        light: false,
                      ),
                    ),

                    // Space before brand logo display using spacing constants
                    const SizedBox(height: AppSpacing.space_xl),

                    // Centered logo layout container
                    Center(
                      // Render brand logo design image asset
                      child: Image.asset(
                        // Load image path registry constant
                        AppAssets.appoynt_01,
                        // Set layout height using spacing constants
                        height: AppSpacing.size_logo_login,
                        // Error fallback rendering verification icon
                        errorBuilder: (context, error, stackTrace) {
                          // Return fallback visual icon
                          return const Icon(
                            // Verification check icon
                            Icons.check_circle_rounded,
                            // Set color to primary brand
                            color: AppColors.primary_color,
                            // Set layout dimensions size
                            size: 140.0,
                          );
                        },
                      ),
                    ),

                    // Space before header texts using spacing constants
                    const SizedBox(height: AppSpacing.space_xl),

                    // Welcoming header title and subtitle block wrapped in Transform to offset image transparent spacing
                    Transform.translate(
                      // Shift layout up by 60 pixels
                      offset: const Offset(0.0, -60.0),
                      // Target Center child containing titles
                      child: Center(
                        // Column layout structuring titles vertically
                        child: Column(
                          // children list
                          children: [
                            // Text widget displaying Welcoming title
                            Text(
                              // Localized greeting string
                              s.welcome_back,
                              // Align text center
                              textAlign: TextAlign.center,
                              // Pull login title styling
                              style: AppTextStyles.get_login_title(is_arabic),
                            ),
                            // Tight spacing divider using spacing constants
                            const SizedBox(height: AppSpacing.space_s),
                            // Text widget displaying welcoming description
                            Text(
                              // Localized help subtitle string
                              s.login_subtitle,
                              // Align text center
                              textAlign: TextAlign.center,
                              // Pull login subtitle styling
                              style:
                                  AppTextStyles.get_login_subtitle(is_arabic),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Space before input fields using spacing constants
                    const SizedBox(height: AppSpacing.space_xxl),

                    // Form container wrapped in Transform to offset logo transparent spacing
                    Transform.translate(
                      // Shift form layout up by 60 pixels to match welcoming titles
                      offset: const Offset(0.0, -60.0),
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
                          // children list
                          children: [
                            // Dynamic Identifier input field (Email or Phone text field)
                            SmartIdentifierField(
                              // Bind text controller
                              controller: _identifier_ctrl,
                              // Bind resolved prefix icon
                              prefix_icon: _prefix_icon,
                              // Resolve localized label
                              label: _field_label(s),
                              // Resolve localized hint
                              hint: _field_hint(s),
                              // Bind keyboard layout type
                              keyboard_type: _keyboard_type,
                              // Bind validator rule checking functions
                              validator: (val) {
                                // Execute validator method
                                return _validate_identifier(val, s);
                              },
                            ),

                            // Space divider separating inputs using spacing constants
                            const SizedBox(height: AppSpacing.space_xl),

                            // Password field widget wrapping secure entries
                            SmartPasswordField(
                              // Bind password controller
                              controller: _password_ctrl,
                              // Localized label string
                              label: s.password,
                              // Inline validator check
                              validator: (val) {
                                // Verify if password input is null or empty using Yoda style check
                                if (null == val || val.isEmpty) {
                                  // Return requirement warning text
                                  return s.field_required;
                                } else {
                                  // Empty case matches clean validations
                                  return null;
                                }
                              },
                            ),

                            // Tight vertical spacing divider using spacing constants
                            const SizedBox(height: AppSpacing.space_m),

                            // Forgot password anchor text link
                            Align(
                              // Align right for English and left for Arabic using Yoda style check
                              alignment: true == is_arabic
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              // TextButton trigger
                              child: TextButton(
                                // Bind forgot password callback
                                onPressed: widget.on_forgot_password,
                                // Button style settings removing internal pad offsets
                                style: TextButton.styleFrom(
                                  // Reset internal margins
                                  padding: EdgeInsets.zero,
                                  // Reset layout limits
                                  minimumSize: Size.zero,
                                  // Standardize tap targets
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                // Anchor text widget
                                child: Text(
                                  // Localized forgot password link string
                                  s.forgot_password,
                                  // Custom link styling
                                  style: const TextStyle(
                                    // Brand color mapping
                                    color: AppColors.primary_color,
                                    // Set font size using spacing constants
                                    fontSize: AppSpacing.font_size_forgot_link,
                                    // Emphasize link weight
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Margin space before main action button using spacing constants
                            const SizedBox(height: AppSpacing.space_xxl),

                            // Submit login auth action button
                            AuthButton(
                              // Localized action string
                              label: s.login,
                              // Submission execution gesture callback
                              on_pressed: () {
                                // Fire submit logic
                                _submit(context);
                              },
                              // Set spinner active flag during execution loading state
                              is_loading: state is AuthLoading,
                            ),

                            // Space before guest sign up prompt using spacing constants
                            const SizedBox(height: AppSpacing.space_xl),

                            // Redirect navigation link prompting new users to register
                            Center(
                              // RichText wrapper mixing styling properties
                              child: RichText(
                                // Mix children span nodes
                                text: TextSpan(
                                  // Localized warning text prefix
                                  text: s.no_account,
                                  // Pull body typography text styles
                                  style:
                                      AppTextStyles.get_body_medium(is_arabic),
                                  // children array
                                  children: [
                                    // Inline widget span nesting sign up link
                                    WidgetSpan(
                                      // Wrap link inside GestureDetector targeting taps
                                      child: GestureDetector(
                                        // Bind registration page navigation callback
                                        onTap: widget.on_go_to_register,
                                        // Link text widget
                                        child: Text(
                                          // Prefix leading space and localized registration label
                                          ' ${s.sign_up}',
                                          // Custom links typography styling
                                          style: const TextStyle(
                                            // Set brand color
                                            color: AppColors.primary_color,
                                            // Set size using spacing constants
                                            fontSize: AppSpacing
                                                .font_size_forgot_link,
                                            // Emphasize weight helper
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Final bottom layout safety margins using spacing constants
                            const SizedBox(height: AppSpacing.space_xxl),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Internal enumeration classification tagging user input types
enum _InputType { empty, unknown, email, phone }

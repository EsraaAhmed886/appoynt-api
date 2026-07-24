/*
 * File Name: change_password_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Defines the Change Password form and constraints check operations.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing routing and localizations exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing profile Cubit and State
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing patient profile entity definition
import 'package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart';
// Importing reusable text field widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';

// Change Password screen layout stateful widget representation
class ChangePasswordPage extends StatefulWidget {
  // Constructor mapping key
  const ChangePasswordPage({super.key});

  // State builder definition
  @override
  State<ChangePasswordPage> createState() {
    // Return state tracker
    return _ChangePasswordPageState();
  }
}

// Concrete state implementation class for the ChangePasswordPage
class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Global form key validation tracker configuration
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  // Input controllers mapping password inputs
  final TextEditingController _current_pw_controller = TextEditingController();
  // New password text controller
  final TextEditingController _new_pw_controller = TextEditingController();
  // Confirm password text controller
  final TextEditingController _confirm_pw_controller = TextEditingController();

  // Dispose controllers freeing system resource locks
  @override
  void dispose() {
    // Dispose text field input controllers
    _current_pw_controller.dispose();
    _new_pw_controller.dispose();
    _confirm_pw_controller.dispose();
    // Call base dispose
    super.dispose();
  }

  // Validate the complexity and matching rules for the new password input field
  String? _validate_new_password(String? value, String current_pw,
      PatientProfile? profile, AppLocalizations localizations) {
    // Clean string entry representation
    final String password = value ?? '';
    // Check if empty
    if (password.isEmpty) {
      // Return empty password validation message
      return localizations.password_new_empty;
    } else if (password.length < 8 || password.length > 64) {
      // Return length validation error message
      return localizations.password_new_length;
    } else {
      // Check complexity containing character varieties
      final bool has_upper = password.contains(RegExp(r'[A-Z]'));
      // Lowercase check
      final bool has_lower = password.contains(RegExp(r'[a-z]'));
      // Numbers check
      final bool has_digit = password.contains(RegExp(r'[0-9]'));
      // Symbols check
      final bool has_special =
          password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      // Validate criteria matches
      if (false == has_upper ||
          false == has_lower ||
          false == has_digit ||
          false == has_special) {
        // Return complexity error msg
        return localizations.password_new_complexity;
      } else {
        // Check unsupported space or Arabic inputs
        if (password.contains(' ') ||
            password.contains(RegExp(r'[\u0600-\u06FF]')) ||
            password.contains(RegExp(
                r'[\u2600-\u27BF]|[\u{1F300}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]',
                unicode: true))) {
          // Return unsupported char warning msg
          return localizations.password_new_unsupported;
        } else {
          // Safe null checks on profile properties to prevent TypeError in JS compiled Dart
          final String first_name =
              (profile?.first_name ?? '').trim().toLowerCase();
          // Clean last name
          final String last_name =
              (profile?.last_name ?? '').trim().toLowerCase();
          // Extract email local part
          final String raw_email = profile?.email ?? '';
          final String email_local = raw_email.contains('@')
              ? raw_email.split('@').first.trim().toLowerCase()
              : raw_email.trim().toLowerCase();
          // Clean current input lowercased
          final String password_lower = password.toLowerCase();
          // Validate personal names leakage criteria
          if ((first_name.isNotEmpty && password_lower.contains(first_name)) ||
              (last_name.isNotEmpty && password_lower.contains(last_name)) ||
              (email_local.isNotEmpty &&
                  password_lower.contains(email_local))) {
            // Return leak error msg
            return localizations.password_new_personal_info;
          } else if (password == current_pw) {
            // Return duplicates warning msg
            return localizations.password_new_same_as_current;
          } else {
            // Check no more than 2 identical consecutive characters (e.g. aaa is invalid)
            for (int i = 0; i < password.length - 2; i++) {
              // Compare adjacent characters
              if (password[i] == password[i + 1] &&
                  password[i] == password[i + 2]) {
                // Return sequential characters warning
                return localizations.password_new_pattern;
              } else {
                // Empty block
              }
            }
            // Check no ascending or descending sequence of 3 or more chars (e.g., abc, cba, 123, 321)
            for (int i = 0; i < password.length - 2; i++) {
              // Resolve code units
              int code_0 = password.codeUnitAt(i);
              // Next code unit
              int code_1 = password.codeUnitAt(i + 1);
              // Third code unit
              int code_2 = password.codeUnitAt(i + 2);
              // Check ascending sequence (e.g., a-b-c)
              if (code_1 == code_0 + 1 && code_2 == code_1 + 1) {
                // Ensure it is alphanumeric
                if ((code_0 >= 97 && code_2 <= 122) ||
                    (code_0 >= 65 && code_2 <= 90) ||
                    (code_0 >= 48 && code_2 <= 57)) {
                  // Return sequential pattern warning
                  return localizations.password_new_pattern;
                } else {
                  // Empty block
                }
              } else {
                // Empty block
              }
              // Check descending sequence (e.g., c-b-a)
              if (code_1 == code_0 - 1 && code_2 == code_1 - 1) {
                // Ensure it is alphanumeric
                if ((code_2 >= 97 && code_0 <= 122) ||
                    (code_2 >= 65 && code_0 <= 90) ||
                    (code_2 >= 48 && code_0 <= 57)) {
                  // Return sequential pattern warning
                  return localizations.password_new_pattern;
                } else {
                  // Empty block
                }
              } else {
                // Empty block
              }
            }
            // Valid checks
            return null;
          }
        }
      }
    }
  }

  // Trigger form submit and save updates
  void _submit_change_pw() {
    // Validate form fields using validator triggers
    if (true == _form_key.currentState?.validate()) {
      // Trigger Cubit change_password call
      context.read<ProfileCubit>().change_password(
            // current password text
            _current_pw_controller.text,
            // new password text
            _new_pw_controller.text,
          );
    } else {
      // Form validation failed
    }
  }

  // Draw widget views structures
  @override
  Widget build(BuildContext context) {
    // Resolve localized labels context
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Return root Scaffold layout container
    return Scaffold(
      // Body wrap in safe area and scroll view
      body: SafeArea(
        // Scroll view protecting layout bounds
        child: SingleChildScrollView(
          // Outer padding margins (strictly 16px lateral padding)
          child: Padding(
            // Margins boundaries
            padding: const EdgeInsets.only(
              left: AppSpacing.space_xl,
              right: AppSpacing.space_xl,
              top: AppSpacing.space_xl,
              bottom: AppSpacing.space_m,
            ),
            // BLoC consumer tracking password status
            child: BlocConsumer<ProfileCubit, ProfileState>(
              // Listen to password actions response status
              listener: (context, state) {
                // Check if password change completed successfully using Yoda comparison
                if (ProfileStatus.passwordSuccess == state.status) {
                  // Reset cubit state status
                  context.read<ProfileCubit>().reset_status();
                  // Show feedback notification message info
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar settings
                    SnackBar(
                      // Localized success message
                      content: Text(localizations.password_change_success_msg),
                      // Themed color fill
                      backgroundColor: AppColors.primary_color,
                    ),
                  );
                  // Revert back to Profile Page screen
                  Navigator.of(context).pop();
                } else if (ProfileStatus.passwordError == state.status) {
                  // Show password error message info
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar settings
                    SnackBar(
                      // Localized error message or fallback
                      content: Text(state.error_message ??
                          localizations.password_current_incorrect),
                      // Error color fill
                      backgroundColor: AppColors.error,
                    ),
                  );
                  // Clear current password input text field following FR-45 specs
                  _current_pw_controller.clear();
                  // Reset status back to success
                  context.read<ProfileCubit>().reset_status();
                } else {
                  // Empty block
                }
              },
              // Build screen details
              builder: (context, state) {
                // Wrap content area within form key validator
                return Form(
                  // Bind global key
                  key: _form_key,
                  // Column stacking fields
                  child: Column(
                    // Children list array
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top header row placing circular back button and screen title
                      CustomProfileAppBar(
                        title: localizations.password_change_title,
                      ),
                      // Spacing offset
                      const SizedBox(height: AppSpacing.space_xl),

                      // Current Password obscure TextFormField container card
                      AuthTextField(
                        label: localizations.password_current_label,
                        hint: '••••••••',
                        controller: _current_pw_controller,
                        is_password: true,
                        validator: (value) {
                          if (true == (value ?? '').isEmpty) {
                            return localizations.password_current_empty;
                          } else {
                            return null;
                          }
                        },
                      ),
                      // Spacing offset gaps
                      const SizedBox(
                        height: AppSpacing.space_m,
                      ),
                      // New Password obscure TextFormField container card VR-09 specs
                      PasswordFieldWithRules(
                        label: localizations.password_new_label,
                        hint: '••••••••',
                        controller: _new_pw_controller,
                        text_input_action: TextInputAction.next,
                        validator: (value) {
                          return _validate_new_password(
                            value,
                            _current_pw_controller.text,
                            state.profile,
                            localizations,
                          );
                        },
                      ),
                      // Spacing offset gaps
                      const SizedBox(
                        height: AppSpacing.space_m,
                      ),
                      // Confirm Password obscure TextFormField container card VR-10 specs
                      AuthTextField(
                        label: localizations.password_confirm_label,
                        hint: '••••••••',
                        controller: _confirm_pw_controller,
                        is_password: true,
                        validator: (value) {
                          final String trimmed = value ?? '';
                          if (trimmed.isEmpty) {
                            return localizations.password_confirm_empty;
                          } else if (trimmed != _new_pw_controller.text) {
                            return localizations.password_confirm_match;
                          } else {
                            return null;
                          }
                        },
                      ),
                      // Spacing vertical divider
                      const SizedBox(
                        // Spacing offset
                        height: AppSpacing.space_xxl,
                      ),
                      // Primary action submit button representing Change Password trigger
                      SizedBox(
                        // Full width available
                        width: double.infinity,
                        // Height dimensions matching standard buttons
                        height: AppSpacing.height_auth_button,
                        // ElevatedButton
                        child: ElevatedButton(
                          // Click submits password changes or disables during load actions
                          onPressed:
                              ProfileStatus.passwordUpdating == state.status
                                  ? null
                                  : _submit_change_pw,
                          // Style configurations
                          style: ElevatedButton.styleFrom(
                            // primary blue
                            backgroundColor: AppColors.primary_color,
                            // disabled background color
                            disabledBackgroundColor:
                                AppColors.primary_color.withValues(alpha: 0.5),
                            // Clear shadows
                            elevation: 0.0,
                            // Curvature shape configurations
                            shape: RoundedRectangleBorder(
                              // Radius parameter value
                              borderRadius: BorderRadius.circular(
                                // standard spacing radius token
                                AppSpacing.radius_l,
                              ),
                            ),
                          ),
                          // Button contents loading indicator or labels
                          child: ProfileStatus.passwordUpdating == state.status
                              ? const SizedBox(
                                  // layout constraints
                                  width: 22.0,
                                  height: 22.0,
                                  // Contrast colors white progress circle
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  // Localized submit button label
                                  localizations.password_change_title,
                                  // Styles
                                  style: const TextStyle(
                                    // Color white
                                    color: Colors.white,
                                    // Size action button font
                                    fontSize:
                                        AppSpacing.font_size_action_button,
                                    // Bold typography weight
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

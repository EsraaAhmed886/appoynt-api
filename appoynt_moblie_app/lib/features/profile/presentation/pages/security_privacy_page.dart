/*
 * File Name: security_privacy_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart,
 *   dart:ui,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Completely refactored Security & Privacy screen with categorized cards, M3 styled settings, auto-lock timeouts, active sessions, and Danger Zone.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing UI library for blurs
import 'dart:ui';
// Importing flutter bloc for state handling
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing profile cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing profile state definition
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing change password page
import 'package:appoynt_mobile_app/features/profile/presentation/pages/change_password_page.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double blur_sigma = 5.0;
  static const double border_radius_default = 16.0;
  static const double font_size_small = 13.0;
  static const double font_size_medium = 14.0;
  static const double font_size_tiny = 11.0;
  static const double font_size_micro = 12.0;
  static const double border_radius_large = 20.0;
  static const double border_radius_small = 10.0;
  static const double border_width_thin = 1.0;
  static const double shadow_blur = 10.0;
  static const double shadow_spread = 1.0;
  static const double shadow_offset_y = 2.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.03;
  static const double icon_container_size = 40.0;
  static const double icon_size_default = 20.0;
  static const double padding_vertical = 14.0;
  static const double padding_horizontal = 16.0;
  static const double spacing_small = 8.0;
  static const double spacing_medium = 12.0;
  static const double spacing_large = 24.0;
  static const double line_height = 1.3;
  static const double letter_spacing = 1.0;
  static const double divider_indent = 68.0;
  static const double divider_end_indent = 16.0;
  static const double spacing_tiny = 2.0;
  static const double spacing_micro = 4.0;
}

// Stateful widget displaying Security details layout
class SecurityPrivacyPage extends StatefulWidget {
  // Constructor mapping key
  const SecurityPrivacyPage({super.key});

  @override
  State<SecurityPrivacyPage> createState() {
    return _SecurityPrivacyPageState();
  }
}

// State class managing biometric switches and modal displays
class _SecurityPrivacyPageState extends State<SecurityPrivacyPage> {
  // Toggle states
  bool _biometrics_enabled = false;
  bool _two_factor_enabled = true;

  // Selected dropdown choices states
  String _auto_lock_timeout = 'immediately';
  String _doctor_access = 'full_access';

  // Helper method displaying native account deletion popup modal dialog with blurred screen backdrop
  void _show_delete_account_dialog(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialog_context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _LocalDimensions.blur_sigma, sigmaY: _LocalDimensions.blur_sigma),
          child: AlertDialog(
            backgroundColor: is_dark ? AppColors.surface_dark : AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
            ),
            title: Text(
              localizations.profile_delete_account_dialog_title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            content: Text(
              localizations.profile_delete_account_warning,
              style: TextStyle(
                fontSize: _LocalDimensions.font_size_small,
                color: is_dark ? AppColors.white70 : AppColors.text_light_secondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialog_context).pop();
                },
                child: Text(
                  localizations.profile_cancel_button,
                  style: TextStyle(
                    color: is_dark ? AppColors.white54 : AppColors.text_light_secondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialog_context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deletion process initiated.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_large),
                  ),
                ),
                child: Text(
                  localizations.profile_delete_account,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Section Group Card layout helper container
  Widget _build_section_card({
    required List<Widget> children,
    required bool is_dark,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate200,
          width: _LocalDimensions.border_width_thin,
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark) : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
            blurRadius: _LocalDimensions.shadow_blur,
            spreadRadius: _LocalDimensions.shadow_spread,
            offset: const Offset(0.0, _LocalDimensions.shadow_offset_y),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Row option item styling widget builder
  Widget _build_setting_row({
    required Widget leadingIcon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool is_dark,
  }) {
    final rowContent = Row(
      children: [
        // Soft-tinted leading icon container (10% opacity primary color background)
        Container(
          width: _LocalDimensions.icon_container_size,
          height: _LocalDimensions.icon_container_size,
          decoration: BoxDecoration(
            color: AppColors.primary_color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_small),
          ),
          child: leadingIcon,
        ),
        const SizedBox(width: _LocalDimensions.spacing_medium),
        // Title & Subtitle details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: _LocalDimensions.font_size_medium,
                  fontWeight: FontWeight.bold,
                  color: is_dark ? AppColors.white : AppColors.text_light_primary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: _LocalDimensions.spacing_tiny),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: _LocalDimensions.font_size_micro,
                    color: is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                    height: _LocalDimensions.line_height,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: _LocalDimensions.spacing_small),
          trailing,
        ],
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: _LocalDimensions.padding_vertical, horizontal: _LocalDimensions.padding_horizontal),
          child: rowContent,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: _LocalDimensions.padding_vertical, horizontal: _LocalDimensions.padding_horizontal),
        child: rowContent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Localized Headers & Titles
    final String sec_account_title = localizations.sec_account_title;
    final String sec_privacy_title = localizations.sec_privacy_title;
    final String sec_danger_title = localizations.sec_danger_title;

    final String biometric_title = localizations.biometric_title;
    final String biometric_subtitle = localizations.biometric_subtitle;

    final String tfa_title = localizations.tfa_title;
    final String tfa_enabled = localizations.tfa_enabled;
    final String tfa_disabled = localizations.tfa_disabled;

    final String change_password_label = localizations.change_password_label;
    final String change_password_subtitle = localizations.change_password_subtitle;

    final String autolock_title = localizations.autolock_title;
    final String autolock_immediately = localizations.autolock_immediately;
    final String autolock_5mins = localizations.autolock_5mins;

    final String doc_access_title = localizations.doc_access_title;
    final String doc_access_full = localizations.doc_access_full;
    final String doc_access_request = localizations.doc_access_request;

    final String active_devices_title = localizations.active_devices_title;
    final String active_devices_subtitle = localizations.active_devices_subtitle;
    final String manage_sessions = localizations.manage_sessions;

    final String export_data_title = localizations.export_data_title;
    final String export_data_subtitle = localizations.export_data_subtitle;

    final String delete_account_title = localizations.delete_account_title;
    final String delete_account_subtitle = localizations.delete_account_subtitle;

    final Color dividerColor = is_dark ? AppColors.border_dark : AppColors.slate100;

    // Return root Scaffold layout container
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.space_xl,
              right: AppSpacing.space_xl,
              top: AppSpacing.space_xl,
              bottom: AppSpacing.space_m,
            ),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (bloc_context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top header row placing circular back button and screen title
                    CustomProfileAppBar(
                      title: localizations.profile_security_privacy,
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // SECTION 1: ACCOUNT SECURITY Header
                    Text(
                      sec_account_title,
                      style: const TextStyle(
                        fontSize: _LocalDimensions.font_size_tiny,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate400,
                        letterSpacing: _LocalDimensions.letter_spacing,
                      ),
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_medium),
                    // SECTION 1: ACCOUNT SECURITY CARD
                    _build_section_card(
                      is_dark: is_dark,
                      children: [
                        // Biometric Authentication
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.fingerprint_rounded, color: AppColors.primary_color, size: _LocalDimensions.icon_size_default),
                          title: biometric_title,
                          subtitle: biometric_subtitle,
                          trailing: Switch.adaptive(
                            value: _biometrics_enabled,
                            onChanged: (val) {
                              setState(() {
                                _biometrics_enabled = val;
                              });
                            },
                            activeTrackColor: AppColors.primary_color,
                            activeThumbColor: AppColors.white,
                          ),
                        ),
                        Divider(height: _LocalDimensions.border_width_thin, indent: _LocalDimensions.divider_indent, endIndent: _LocalDimensions.divider_end_indent, color: dividerColor),
                        // Two-Factor Authentication
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.security_rounded, color: AppColors.primary_color, size: _LocalDimensions.icon_size_default),
                          title: tfa_title,
                          subtitle: _two_factor_enabled ? tfa_enabled : tfa_disabled,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
                          ),
                          onTap: () {
                            setState(() {
                              _two_factor_enabled = !_two_factor_enabled;
                            });
                          },
                        ),
                        Divider(height: _LocalDimensions.border_width_thin, indent: _LocalDimensions.divider_indent, endIndent: _LocalDimensions.divider_end_indent, color: dividerColor),
                        // Change Password
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary_color, size: _LocalDimensions.icon_size_default),
                          title: change_password_label,
                          subtitle: change_password_subtitle,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (route_context) => BlocProvider.value(
                                  value: context.read<ProfileCubit>(),
                                  child: const ChangePasswordPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        Divider(height: _LocalDimensions.border_width_thin, indent: _LocalDimensions.divider_indent, endIndent: _LocalDimensions.divider_end_indent, color: dividerColor),
                        // Auto-Lock Timeout
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.timer_outlined, color: AppColors.primary_color, size: _LocalDimensions.icon_size_default),
                          title: autolock_title,
                          trailing: DropdownButton<String>(
                            value: _auto_lock_timeout,
                            dropdownColor: is_dark ? AppColors.surface_dark : AppColors.white,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary_color),
                            style: const TextStyle(
                              color: AppColors.primary_color,
                              fontWeight: FontWeight.bold,
                              fontSize: _LocalDimensions.font_size_small,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'immediately',
                                child: Text(autolock_immediately),
                              ),
                              DropdownMenuItem(
                                value: '5_mins',
                                child: Text(autolock_5mins),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _auto_lock_timeout = val;
                                });
                              } else {
                                // No change
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // SECTION 2: MEDICAL DATA PRIVACY Header
                    Text(
                      sec_privacy_title,
                      style: const TextStyle(
                        fontSize: _LocalDimensions.font_size_tiny,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate400,
                        letterSpacing: _LocalDimensions.letter_spacing,
                      ),
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_medium),
                    // SECTION 2: MEDICAL DATA PRIVACY CARD
                    _build_section_card(
                      is_dark: is_dark,
                      children: [
                        // Doctor Access Permissions
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.primary_color, size: _LocalDimensions.icon_size_default),
                          title: doc_access_title,
                          trailing: DropdownButton<String>(
                            value: _doctor_access,
                            dropdownColor: is_dark ? AppColors.surface_dark : AppColors.white,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary_color),
                            style: const TextStyle(
                              color: AppColors.primary_color,
                              fontWeight: FontWeight.bold,
                              fontSize: _LocalDimensions.font_size_small,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'full_access',
                                child: Text(doc_access_full),
                              ),
                              DropdownMenuItem(
                                value: 'requires_request',
                                child: Text(doc_access_request),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _doctor_access = val;
                                });
                              } else {
                                // No change
                              }
                            },
                          ),
                        ),
                        Divider(height: _LocalDimensions.border_width_thin, indent: _LocalDimensions.divider_indent, endIndent: _LocalDimensions.divider_end_indent, color: dividerColor),
                        // Active Logged-in Devices
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.devices_rounded, color: AppColors.primary_color, size: _LocalDimensions.icon_size_default),
                          title: active_devices_title,
                          subtitle: active_devices_subtitle,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(manage_sessions),
                                backgroundColor: AppColors.primary_color,
                              ),
                            );
                          },
                        ),
                        Divider(height: _LocalDimensions.border_width_thin, indent: _LocalDimensions.divider_indent, endIndent: _LocalDimensions.divider_end_indent, color: dividerColor),
                        // Export Medical Data
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.download_rounded, color: AppColors.primary_color, size: _LocalDimensions.icon_size_default),
                          title: export_data_title,
                          subtitle: export_data_subtitle,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
                          ),
                          onTap: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text(localizations.preparing_data_export_toast),
                                 backgroundColor: AppColors.primary_color,
                               ),
                             );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // SECTION 3: DANGER ZONE Header
                    Text(
                      sec_danger_title,
                      style: const TextStyle(
                        fontSize: _LocalDimensions.font_size_tiny,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate400,
                        letterSpacing: _LocalDimensions.letter_spacing,
                      ),
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_medium),
                    // SECTION 3: DANGER ZONE Isolated Container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: is_dark ? AppColors.red900.withValues(alpha: 0.15) : AppColors.errorLight,
                        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                        border: Border.all(
                          color: is_dark ? AppColors.red800 : AppColors.red300,
                          width: _LocalDimensions.border_width_thin,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          _show_delete_account_dialog(context);
                        },
                        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                        child: Padding(
                          padding: const EdgeInsets.all(_LocalDimensions.padding_horizontal),
                          child: Row(
                            children: [
                              Container(
                                width: _LocalDimensions.icon_container_size,
                                height: _LocalDimensions.icon_container_size,
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.no_accounts_rounded,
                                  color: AppColors.error,
                                  size: _LocalDimensions.icon_size_default,
                                ),
                              ),
                              const SizedBox(width: _LocalDimensions.spacing_medium),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      delete_account_title,
                                      style: const TextStyle(
                                        fontSize: _LocalDimensions.font_size_medium,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.error,
                                      ),
                                    ),
                                    const SizedBox(height: _LocalDimensions.spacing_micro),
                                    Text(
                                      delete_account_subtitle,
                                      style: TextStyle(
                                        fontSize: _LocalDimensions.font_size_micro,
                                        color: is_dark ? AppColors.white70 : AppColors.slate500,
                                        height: _LocalDimensions.line_height,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

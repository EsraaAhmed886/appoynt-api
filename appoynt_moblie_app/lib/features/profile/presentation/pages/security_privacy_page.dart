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
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
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
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: is_dark ? AppColors.surface_dark : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
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
                fontSize: 13.0,
                color: is_dark ? Colors.white70 : AppColors.text_light_secondary,
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
                    color: is_dark ? Colors.white54 : AppColors.text_light_secondary,
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
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  localizations.profile_delete_account,
                  style: const TextStyle(
                    color: Colors.white,
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
        color: is_dark ? AppColors.surface_dark : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.0,
            spreadRadius: 1.0,
            offset: const Offset(0.0, 2.0),
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
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: AppColors.primary_color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: leadingIcon,
        ),
        const SizedBox(width: 12.0),
        // Title & Subtitle details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: is_dark ? Colors.white : AppColors.text_light_primary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8.0),
          trailing,
        ],
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: rowContent,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      child: rowContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Localized Headers & Titles
    final String sec_account_title = localizations.is_arabic ? "أمان الحساب" : "ACCOUNT SECURITY";
    final String sec_privacy_title = localizations.is_arabic ? "خصوصية البيانات الطبية" : "MEDICAL DATA PRIVACY";
    final String sec_danger_title = localizations.is_arabic ? "إجراءات حساسة" : "DANGER ZONE";

    final String biometric_title = localizations.is_arabic ? "المصادقة البيومترية" : "Biometric Authentication";
    final String biometric_subtitle = localizations.is_arabic 
        ? "بصمة الوجه / الإصبع للدخول السريع" 
        : "Biometric Authentication (Face ID / Fingerprint)";

    final String tfa_title = localizations.is_arabic ? "التحقق بخطوتين" : "Two-Factor Authentication";
    final String tfa_enabled = localizations.is_arabic ? "مفعّل" : "Enabled";
    final String tfa_disabled = localizations.is_arabic ? "معطّل" : "Disabled";

    final String change_password_label = localizations.is_arabic ? "تغيير كلمة المرور" : "Change Password";
    final String change_password_subtitle = localizations.is_arabic 
        ? "تحديث بيانات وكلمة مرور حسابك" 
        : "Update password credentials";

    final String autolock_title = localizations.is_arabic ? "القفل التلقائي للتطبيق" : "Auto-Lock App Timeout";
    final String autolock_immediately = localizations.is_arabic ? "فوري" : "Immediately";
    final String autolock_5mins = localizations.is_arabic ? "بعد 5 دقائق" : "After 5 Mins";

    final String doc_access_title = localizations.is_arabic ? "صلاحيات دخول الطبيب" : "Doctor Access Permissions";
    final String doc_access_full = localizations.is_arabic ? "وصول كامل" : "Full Access";
    final String doc_access_request = localizations.is_arabic ? "يتطلب إذن" : "Requires Request";

    final String active_devices_title = localizations.is_arabic ? "الأجهزة النشطة حالياً" : "Active Logged-in Devices";
    final String active_devices_subtitle = localizations.is_arabic 
        ? "آيفون 15 • القاهرة، مصر" 
        : "iPhone 15 • Cairo";
    final String manage_sessions = localizations.is_arabic ? "إدارة الجلسات" : "Manage Sessions";

    final String export_data_title = localizations.is_arabic ? "تصدير البيانات الطبية" : "Export Medical Data";
    final String export_data_subtitle = localizations.is_arabic 
        ? "طلب نسخة بصيغة PDF أو JSON لسجلك الطبي" 
        : "Request PDF/JSON health log archive";

    final String delete_account_title = localizations.is_arabic ? "حذف الحساب نهائياً" : "Delete Account";
    final String delete_account_subtitle = localizations.is_arabic 
        ? "سيتم مسح جميع بياناتك وسجلاتك الطبية نهائياً ولا يمكن استرجاعها" 
        : "Permanently erase your personal medical logs and account";

    final Color dividerColor = is_dark ? AppColors.border_dark : const Color(0xFFF1F5F9);

    // Return root Scaffold layout container
    return Scaffold(
      backgroundColor: is_dark ? AppColors.background_dark : const Color(0xFFF8FAFC),
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
                    const SizedBox(height: 24.0),

                    // SECTION 1: ACCOUNT SECURITY Header
                    Text(
                      sec_account_title,
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    // SECTION 1: ACCOUNT SECURITY CARD
                    _build_section_card(
                      is_dark: is_dark,
                      children: [
                        // Biometric Authentication
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.fingerprint_rounded, color: AppColors.primary_color, size: 20.0),
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
                            activeThumbColor: Colors.white,
                          ),
                        ),
                        Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                        // Two-Factor Authentication
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.security_rounded, color: AppColors.primary_color, size: 20.0),
                          title: tfa_title,
                          subtitle: _two_factor_enabled ? tfa_enabled : tfa_disabled,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                          ),
                          onTap: () {
                            setState(() {
                              _two_factor_enabled = !_two_factor_enabled;
                            });
                          },
                        ),
                        Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                        // Change Password
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.primary_color, size: 20.0),
                          title: change_password_label,
                          subtitle: change_password_subtitle,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
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
                        Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                        // Auto-Lock Timeout
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.timer_outlined, color: AppColors.primary_color, size: 20.0),
                          title: autolock_title,
                          trailing: DropdownButton<String>(
                            value: _auto_lock_timeout,
                            dropdownColor: is_dark ? AppColors.surface_dark : Colors.white,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary_color),
                            style: const TextStyle(
                              color: AppColors.primary_color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
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
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // SECTION 2: MEDICAL DATA PRIVACY Header
                    Text(
                      sec_privacy_title,
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    // SECTION 2: MEDICAL DATA PRIVACY CARD
                    _build_section_card(
                      is_dark: is_dark,
                      children: [
                        // Doctor Access Permissions
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.remove_red_eye_outlined, color: AppColors.primary_color, size: 20.0),
                          title: doc_access_title,
                          trailing: DropdownButton<String>(
                            value: _doctor_access,
                            dropdownColor: is_dark ? AppColors.surface_dark : Colors.white,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary_color),
                            style: const TextStyle(
                              color: AppColors.primary_color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
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
                              }
                            },
                          ),
                        ),
                        Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                        // Active Logged-in Devices
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.devices_rounded, color: AppColors.primary_color, size: 20.0),
                          title: active_devices_title,
                          subtitle: active_devices_subtitle,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
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
                        Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                        // Export Medical Data
                        _build_setting_row(
                          is_dark: is_dark,
                          leadingIcon: const Icon(Icons.download_rounded, color: AppColors.primary_color, size: 20.0),
                          title: export_data_title,
                          subtitle: export_data_subtitle,
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations.is_arabic ? 'جاري تحضير ملف البيانات الطبية للتصدير...' : 'Preparing medical data archive...'),
                                backgroundColor: AppColors.primary_color,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // SECTION 3: DANGER ZONE Header
                    Text(
                      sec_danger_title,
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    // SECTION 3: DANGER ZONE Isolated Container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: is_dark ? const Color(0xFF7F1D1D).withValues(alpha: 0.15) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: is_dark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5),
                          width: 1.0,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          _show_delete_account_dialog(context);
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.no_accounts_rounded,
                                  color: AppColors.error,
                                  size: 20.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      delete_account_title,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.error,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      delete_account_subtitle,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: is_dark ? Colors.white70 : const Color(0xFF64748B),
                                        height: 1.3,
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

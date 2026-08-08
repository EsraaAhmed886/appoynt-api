/*
 * File Name: app_preferences_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
 * File Description: Redesigned App Preferences page with unified grouped cards, modern bottom sheets for language/theme, and Support & Legal sections.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing flutter bloc for state handling
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing main to access global theme mode notifier
import 'package:appoynt_mobile_app/main.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_small = 10.0;
  static const double border_radius_sheet = 24.0;
  static const double border_radius_tiny = 2.0;
  static const double border_width_thin = 1.0;
  static const double button_height = 48.0;
  static const double drag_handle_width = 40.0;
  static const double drag_handle_height = 4.0;
  static const double icon_container_size = 40.0;
  static const double spacing_tiny = 2.0;
  static const double spacing_small = 8.0;
  static const double spacing_medium = 12.0;
  static const double spacing_large = 16.0;
  static const double spacing_xl = 20.0;
  static const double spacing_xxl = 24.0;
  static const double font_size_title_large = 20.0;
  static const double font_size_title_medium = 16.0;
  static const double font_size_body_large = 15.0;
  static const double font_size_body_medium = 14.0;
  static const double font_size_body_small = 12.0;
  static const double shadow_blur = 10.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.03;
  static const double input_padding_h = 16.0;
  static const double input_padding_v = 14.0;
}

// Stateful widget displaying Preferences layout
class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({super.key});

  @override
  State<AppPreferencesPage> createState() {
    return _AppPreferencesPageState();
  }
}

// State class managing switches and bottom sheet triggers
class _AppPreferencesPageState extends State<AppPreferencesPage> {
  // Notification states
  bool _notif_appointments = true;
  bool _notif_medications = true;
  bool _notif_invoices = true;
  bool _notif_promotions = false;

  // Accessibility state
  bool _calendar_sync = false;

  // Show quick language selector bottom sheet
  void _show_language_bottom_sheet(BuildContext context, AppLocalizations localizations, bool is_dark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (modal_context) {
        final bool is_arabic = localizations.is_arabic;
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(_LocalDimensions.border_radius_sheet)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              const SizedBox(height: _LocalDimensions.spacing_medium),
              Center(
                child: Container(
                  width: _LocalDimensions.drag_handle_width,
                  height: _LocalDimensions.drag_handle_height,
                  decoration: BoxDecoration(
                    color: is_dark ? Colors.white30 : Colors.black12,
                    borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_tiny),
                  ),
                ),
              ),
              const SizedBox(height: _LocalDimensions.spacing_xl),
              Text(
                localizations.is_arabic ? "اختر اللغة" : "Select Language",
                style: TextStyle(
                  fontSize: _LocalDimensions.font_size_title_medium,
                  fontWeight: FontWeight.bold,
                  color: is_dark ? Colors.white : AppColors.text_light_primary,
                ),
              ),
              const SizedBox(height: _LocalDimensions.spacing_large),
              ListTile(
                title: const Text("English", style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: !is_arabic ? const Icon(Icons.check_rounded, color: AppColors.primary_color) : null,
                onTap: () {
                  if (is_arabic) {
                    context.read<GlobalCubit>().toggle_language();
                  }
                  Navigator.pop(modal_context);
                },
              ),
              Divider(height: 1.0, color: is_dark ? AppColors.border_dark : AppColors.slate_50),
              ListTile(
                title: const Text("العربية", style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: is_arabic ? const Icon(Icons.check_rounded, color: AppColors.primary_color) : null,
                onTap: () {
                  if (!is_arabic) {
                    context.read<GlobalCubit>().toggle_language();
                  }
                  Navigator.pop(modal_context);
                },
              ),
              const SizedBox(height: _LocalDimensions.spacing_xl),
            ],
          ),
        ),
      );
    },
    );
  }

  // Show quick theme selector bottom sheet
  void _show_theme_bottom_sheet(BuildContext context, AppLocalizations localizations, bool is_dark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (modal_context) {
        return ListenableBuilder(
          listenable: theme_mode_notifier,
          builder: (builder_context, child) {
            final ThemeMode currentMode = theme_mode_notifier.current_theme_mode;
            return Container(
              decoration: BoxDecoration(
                color: is_dark ? AppColors.surface_dark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  const SizedBox(height: 12.0),
                  Center(
                    child: Container(
                      width: 40.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: is_dark ? Colors.white30 : Colors.black12,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: _LocalDimensions.spacing_xl),
                  Text(
                    localizations.is_arabic ? "اختر المظهر" : "Select Theme",
                    style: TextStyle(
                      fontSize: _LocalDimensions.font_size_title_medium,
                      fontWeight: FontWeight.bold,
                      color: is_dark ? Colors.white : AppColors.text_light_primary,
                    ),
                  ),
                  const SizedBox(height: _LocalDimensions.spacing_large),
                  ListTile(
                    leading: const Icon(Icons.light_mode_rounded),
                    title: Text(localizations.profile_theme_light),
                    trailing: currentMode == ThemeMode.light ? const Icon(Icons.check_rounded, color: AppColors.primary_color) : null,
                    onTap: () {
                      theme_mode_notifier.set_theme_mode(ThemeMode.light);
                      Navigator.pop(modal_context);
                    },
                  ),
                  Divider(height: 1.0, color: is_dark ? AppColors.border_dark : AppColors.slate_50),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_rounded),
                    title: Text(localizations.profile_theme_dark),
                    trailing: currentMode == ThemeMode.dark ? const Icon(Icons.check_rounded, color: AppColors.primary_color) : null,
                    onTap: () {
                      theme_mode_notifier.set_theme_mode(ThemeMode.dark);
                      Navigator.pop(modal_context);
                    },
                  ),
                  Divider(height: 1.0, color: is_dark ? AppColors.border_dark : AppColors.slate_50),
                  ListTile(
                    leading: const Icon(Icons.settings_suggest_rounded),
                    title: Text(localizations.profile_theme_system),
                    trailing: currentMode == ThemeMode.system ? const Icon(Icons.check_rounded, color: AppColors.primary_color) : null,
                    onTap: () {
                      theme_mode_notifier.set_theme_mode(ThemeMode.system);
                      Navigator.pop(modal_context);
                    },
                  ),
                  const SizedBox(height: _LocalDimensions.spacing_xl),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  // Show legal & terms modal bottom sheet
  void _show_legal_modal({
    required BuildContext context,
    required String title,
    required String content,
    required bool is_dark,
    required AppLocalizations localizations,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (modal_context) {
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(_LocalDimensions.border_radius_sheet)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(_LocalDimensions.spacing_xxl),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: _LocalDimensions.drag_handle_width,
                  height: _LocalDimensions.drag_handle_height,
                  decoration: BoxDecoration(
                    color: is_dark ? Colors.white30 : Colors.black26,
                    borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_tiny),
                  ),
                ),
              ),
              const SizedBox(height: _LocalDimensions.spacing_xl),
              Text(
                title,
                style: TextStyle(
                  fontSize: _LocalDimensions.font_size_title_large,
                  fontWeight: FontWeight.w800,
                  color: is_dark ? Colors.white : AppColors.text_light_primary,
                ),
              ),
              const SizedBox(height: _LocalDimensions.spacing_medium),
              Text(
                content,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
                  height: 1.4,
                  color: is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                ),
              ),
              const SizedBox(height: _LocalDimensions.spacing_xxl),
              SizedBox(
                width: double.infinity,
                height: _LocalDimensions.button_height,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(modal_context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                    ),
                  ),
                  child: Text(
                    localizations.profile_close_button,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _LocalDimensions.font_size_body_large,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: _LocalDimensions.border_width_thin,
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark ? Colors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark) : Colors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
            blurRadius: _LocalDimensions.shadow_blur,
            spreadRadius: _LocalDimensions.border_width_thin,
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
  Widget _build_preference_row({
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
                  fontSize: _LocalDimensions.font_size_body_medium,
                  fontWeight: FontWeight.bold,
                  color: is_dark ? Colors.white : AppColors.text_light_primary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: _LocalDimensions.spacing_tiny),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: _LocalDimensions.font_size_body_small,
                    color: is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                    height: 1.3,
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
          padding: const EdgeInsets.symmetric(vertical: _LocalDimensions.input_padding_v, horizontal: _LocalDimensions.input_padding_h),
          child: rowContent,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _LocalDimensions.input_padding_v, horizontal: _LocalDimensions.input_padding_h),
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
    final String sec_notifications = localizations.is_arabic ? "الإشعارات والتنبيهات" : "NOTIFICATIONS & ALERTS";
    final String sec_display = localizations.is_arabic ? "العرض وإمكانية الوصول" : "DISPLAY & ACCESSIBILITY";
    final String sec_support = localizations.is_arabic ? "الدعم والسياسات" : "SUPPORT & LEGAL";

    final String appointment_reminders_title = localizations.profile_notifications_reminders;
    final String appointment_reminders_sub = localizations.profile_notifications_reminders_sub;

    final String medication_reminders_title = localizations.is_arabic ? "تنبيهات الأدوية والحبوب" : "Medication & Pill Reminders";
    final String medication_reminders_sub = localizations.is_arabic ? "تذكير بمواعيد أخذ جرعات الأدوية" : "Get notified for your prescribed pills";

    final String invoices_title = localizations.profile_notifications_invoices;
    final String invoices_sub = localizations.profile_notifications_invoices_sub;

    final String promos_title = localizations.profile_notifications_promos;
    final String promos_sub = localizations.profile_notifications_promos_sub;

    final String calendar_sync_title = localizations.is_arabic ? "مزامنة التقويم" : "Calendar Synchronization";
    final String calendar_sync_sub = localizations.is_arabic ? "حفظ المواعيد تلقائياً في تقويم الهاتف" : "Sync medical bookings to phone calendar";

    final String active_language = localizations.is_arabic ? "العربية" : "English";
    final String active_theme = theme_mode_notifier.current_theme_mode == ThemeMode.light
        ? localizations.profile_theme_light
        : (theme_mode_notifier.current_theme_mode == ThemeMode.dark
            ? localizations.profile_theme_dark
            : localizations.profile_theme_system);

    final String help_center_title = localizations.is_arabic ? "مركز المساعدة والأسئلة الشائعة" : "Help Center & FAQs";
    final String help_center_sub = localizations.is_arabic ? "عرض الإرشادات والأسئلة الأكثر شيوعاً" : "Browse guides and common answers";

    final Color dividerColor = is_dark ? AppColors.border_dark : const Color(0xFFF1F5F9);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header row placing circular back button and screen title
                CustomProfileAppBar(
                  title: localizations.profile_app_preferences,
                ),
                const SizedBox(height: 24.0),

                // SECTION 1: NOTIFICATIONS & ALERTS
                Text(
                  sec_notifications,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                _build_section_card(
                  is_dark: is_dark,
                  children: [
                    // Appointment Reminders
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.calendar_month_rounded, color: AppColors.primary_color, size: 20.0),
                      title: appointment_reminders_title,
                      subtitle: appointment_reminders_sub,
                      trailing: Switch.adaptive(
                        value: _notif_appointments,
                        onChanged: (val) {
                          setState(() {
                            _notif_appointments = val;
                          });
                        },
                        activeTrackColor: AppColors.primary_color,
                        activeThumbColor: Colors.white,
                      ),
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Medication & Pill Reminders
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.medication_rounded, color: AppColors.primary_color, size: 20.0),
                      title: medication_reminders_title,
                      subtitle: medication_reminders_sub,
                      trailing: Switch.adaptive(
                        value: _notif_medications,
                        onChanged: (val) {
                          setState(() {
                            _notif_medications = val;
                          });
                        },
                        activeTrackColor: AppColors.primary_color,
                        activeThumbColor: Colors.white,
                      ),
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Invoices & Statements
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.receipt_long_rounded, color: AppColors.primary_color, size: 20.0),
                      title: invoices_title,
                      subtitle: invoices_sub,
                      trailing: Switch.adaptive(
                        value: _notif_invoices,
                        onChanged: (val) {
                          setState(() {
                            _notif_invoices = val;
                          });
                        },
                        activeTrackColor: AppColors.primary_color,
                        activeThumbColor: Colors.white,
                      ),
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Promotional & Health Tips
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.spa_rounded, color: AppColors.primary_color, size: 20.0),
                      title: promos_title,
                      subtitle: promos_sub,
                      trailing: Switch.adaptive(
                        value: _notif_promotions,
                        onChanged: (val) {
                          setState(() {
                            _notif_promotions = val;
                          });
                        },
                        activeTrackColor: AppColors.primary_color,
                        activeThumbColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // SECTION 2: DISPLAY & ACCESSIBILITY
                Text(
                  sec_display,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                _build_section_card(
                  is_dark: is_dark,
                  children: [
                    // Language selection compact tile
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.language_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.profile_language_row,
                      subtitle: active_language,
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        _show_language_bottom_sheet(context, localizations, is_dark);
                      },
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Theme selection compact tile
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.palette_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.profile_theme_row,
                      subtitle: active_theme,
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        _show_theme_bottom_sheet(context, localizations, is_dark);
                      },
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Calendar synchronization toggle
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.sync_rounded, color: AppColors.primary_color, size: 20.0),
                      title: calendar_sync_title,
                      subtitle: calendar_sync_sub,
                      trailing: Switch.adaptive(
                        value: _calendar_sync,
                        onChanged: (val) {
                          setState(() {
                            _calendar_sync = val;
                          });
                        },
                        activeTrackColor: AppColors.primary_color,
                        activeThumbColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // SECTION 3: SUPPORT & LEGAL
                Text(
                  sec_support,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                _build_section_card(
                  is_dark: is_dark,
                  children: [
                    // Hotline click dial row
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.phone_callback_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.profile_support_hotline,
                      subtitle: "19999",
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (dialog_context) {
                            return AlertDialog(
                              title: Text(
                                localizations.profile_support_dial_dialog_title,
                              ),
                              content: const Text(
                                'Would you like to place a secure call to Appoynt support desk at 19999?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dialog_context).pop(),
                                  child: Text(localizations.profile_cancel_button),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialog_context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Hotline dialer opened.'),
                                      ),
                                    );
                                  },
                                  child: const Text('Dial'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Help Center & FAQs
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.help_outline_rounded, color: AppColors.primary_color, size: 20.0),
                      title: help_center_title,
                      subtitle: help_center_sub,
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.is_arabic ? 'جاري فتح مركز المساعدة...' : 'Opening Help Center...'),
                            backgroundColor: AppColors.primary_color,
                          ),
                        );
                      },
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Terms of Use
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.description_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.profile_support_terms,
                      subtitle: localizations.profile_support_terms_sub,
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        _show_legal_modal(
                          context: context,
                          title: localizations.profile_terms_modal_title,
                          content: localizations.profile_terms_content,
                          is_dark: is_dark,
                          localizations: localizations,
                        );
                      },
                    ),
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Privacy Policy
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.security_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.profile_support_privacy,
                      subtitle: localizations.profile_support_privacy_sub,
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? Colors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        _show_legal_modal(
                          context: context,
                          title: localizations.profile_privacy_modal_title,
                          content: localizations.profile_privacy_content,
                          is_dark: is_dark,
                          localizations: localizations,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),

                // App Version Footer
                const Center(
                  child: Text(
                    "APPOYNT v1.2.0 • Build 8421",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

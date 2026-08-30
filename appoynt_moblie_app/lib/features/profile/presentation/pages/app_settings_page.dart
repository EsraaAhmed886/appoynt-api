/*
 * File Name: app_settings_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: App Settings screen containing user notification preferences, language, display themes, and calendar sync configuration.
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
  static const double drag_handle_width = 40.0;
  static const double drag_handle_height = 4.0;
  static const double icon_container_size = 40.0;
  static const double spacing_tiny = 2.0;
  static const double spacing_small = 8.0;
  static const double spacing_medium = 12.0;
  static const double spacing_large = 16.0;
  static const double spacing_xl = 20.0;
  static const double font_size_title_medium = 16.0;
  static const double font_size_body_medium = 14.0;
  static const double font_size_body_small = 12.0;
  static const double shadow_blur = 10.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.03;
  static const double input_padding_h = 16.0;
  static const double input_padding_v = 14.0;
}

// Stateful widget displaying App Settings layout
class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() {
    return _AppSettingsPageState();
  }
}

// State class managing settings toggles and bottom sheets
class _AppSettingsPageState extends State<AppSettingsPage> {
  // Notification states
  bool _notif_invoices = true;
  bool _notif_promotions = false;

  // Accessibility state
  bool _calendar_sync = false;

  // Show quick language selector bottom sheet
  void _show_language_bottom_sheet(BuildContext context, AppLocalizations localizations, bool is_dark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (modal_context) {
        final bool is_arabic = localizations.is_arabic;
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
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
                      color: is_dark ? AppColors.white30 : AppColors.black12,
                      borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_tiny),
                    ),
                  ),
                ),
                const SizedBox(height: _LocalDimensions.spacing_xl),
                Text(
                  localizations.profile_select_language,
                  style: TextStyle(
                    fontSize: _LocalDimensions.font_size_title_medium,
                    fontWeight: FontWeight.bold,
                    color: is_dark ? AppColors.white : AppColors.text_light_primary,
                  ),
                ),
                const SizedBox(height: _LocalDimensions.spacing_large),
                ListTile(
                  title: const Text("English", style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: !is_arabic ? const Icon(Icons.check_rounded, color: AppColors.primary_color) : null,
                  onTap: () {
                    if (is_arabic) {
                      context.read<GlobalCubit>().toggle_language();
                    } else {
                      // Already English
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
                    } else {
                      // Already Arabic
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
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (modal_context) {
        return ListenableBuilder(
          listenable: theme_mode_notifier,
          builder: (builder_context, child) {
            final ThemeMode currentMode = theme_mode_notifier.current_theme_mode;
            return Container(
              decoration: BoxDecoration(
                color: is_dark ? AppColors.surface_dark : AppColors.white,
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
                          color: is_dark ? AppColors.white30 : AppColors.black12,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_xl),
                    Text(
                      localizations.profile_select_theme,
                      style: TextStyle(
                        fontSize: _LocalDimensions.font_size_title_medium,
                        fontWeight: FontWeight.bold,
                        color: is_dark ? AppColors.white : AppColors.text_light_primary,
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
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: _LocalDimensions.border_width_thin,
        ),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: _LocalDimensions.font_size_body_medium,
                  fontWeight: FontWeight.bold,
                  color: is_dark ? AppColors.white : AppColors.text_light_primary,
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
          padding: const EdgeInsets.symmetric(
            vertical: _LocalDimensions.input_padding_v,
            horizontal: _LocalDimensions.input_padding_h,
          ),
          child: rowContent,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: _LocalDimensions.input_padding_v,
          horizontal: _LocalDimensions.input_padding_h,
        ),
        child: rowContent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    final String sec_notifications = localizations.profile_sec_notifications;
    final String sec_display = localizations.profile_sec_display;

    final String invoices_title = localizations.profile_notifications_invoices;
    final String invoices_sub = localizations.profile_notifications_invoices_sub;

    final String promos_title = localizations.profile_notifications_promos;
    final String promos_sub = localizations.profile_notifications_promos_sub;

    final String calendar_sync_title = localizations.profile_calendar_sync;
    final String calendar_sync_sub = localizations.profile_calendar_sync_sub;

    final String active_language = localizations.profile_active_language;
    final String active_theme = theme_mode_notifier.current_theme_mode == ThemeMode.light
        ? localizations.profile_theme_light
        : (theme_mode_notifier.current_theme_mode == ThemeMode.dark
            ? localizations.profile_theme_dark
            : localizations.profile_theme_system);

    final Color dividerColor = is_dark ? AppColors.border_dark : AppColors.slate100;

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
                CustomProfileAppBar(
                  title: localizations.profile_app_settings,
                ),
                const SizedBox(height: 24.0),

                // SECTION 1: NOTIFICATIONS & ALERTS
                Text(
                  sec_notifications,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.slate400,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                _build_section_card(
                  is_dark: is_dark,
                  children: [
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
                        activeThumbColor: AppColors.white,
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
                        activeThumbColor: AppColors.white,
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
                    color: AppColors.slate400,
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
                        color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
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
                        color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
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
                        activeThumbColor: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

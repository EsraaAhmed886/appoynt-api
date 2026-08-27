/*
 * File Name: help_about_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Help & About screen containing support helpline, legal terms, open source licenses, and application version info.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
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
  static const double font_size_body_large = 15.0;
  static const double font_size_body_medium = 14.0;
  static const double font_size_body_small = 12.0;
  static const double shadow_blur = 10.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.03;
  static const double input_padding_h = 16.0;
  static const double input_padding_v = 14.0;
  static const double logo_size = 72.0;
}

// Stateful widget displaying Help & About App layout
class HelpAndAboutPage extends StatefulWidget {
  const HelpAndAboutPage({super.key});

  @override
  State<HelpAndAboutPage> createState() {
    return _HelpAndAboutPageState();
  }
}

// State class managing legal modals and dialog triggers
class _HelpAndAboutPageState extends State<HelpAndAboutPage> {
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
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (modal_context) {
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
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
                      color: is_dark ? AppColors.white30 : AppColors.black26,
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
                    color: is_dark ? AppColors.white : AppColors.text_light_primary,
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
                      foregroundColor: AppColors.white,
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

    final String sec_support = localizations.profile_sec_support;
    final String help_center_title = localizations.profile_help_center;
    final String help_center_sub = localizations.profile_help_center_sub;

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
                  title: localizations.profile_help_about,
                ),
                const SizedBox(height: 24.0),

                // Top App Card: Logo, App Name, Tagline, and Version
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(_LocalDimensions.spacing_xxl),
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
                    children: [
                      Image.asset(
                        AppAssets.appoynt_icon,
                        width: _LocalDimensions.logo_size,
                        height: _LocalDimensions.logo_size,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: _LocalDimensions.spacing_large),
                      Text(
                        'Appoynt',
                        style: TextStyle(
                          fontSize: _LocalDimensions.font_size_title_large,
                          fontWeight: FontWeight.bold,
                          color: is_dark ? AppColors.white : AppColors.text_light_primary,
                        ),
                      ),
                      const SizedBox(height: _LocalDimensions.spacing_tiny),
                      Text(
                        localizations.help_about_tagline,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _LocalDimensions.font_size_body_small,
                          color: is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                        ),
                      ),
                      const SizedBox(height: _LocalDimensions.spacing_medium),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.primary_color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Text(
                          "v1.2.0 - Build 8421",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary_color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // SECTION 1: SUPPORT & FAQ
                Text(
                  sec_support,
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
                    // Hotline click dial row
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.phone_callback_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.profile_support_hotline,
                      subtitle: "19999",
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
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
                                      CustomSnackBar.info(
                                        context,
                                        'Hotline dialer opened.',
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
                        color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        CustomSnackBar.info(
                          context,
                          localizations.profile_opening_help_center,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // SECTION 2: LEGAL & ABOUT
                const Text(
                  "LEGAL & POLICIES", // Localized header if needed or standard uppercase header
                  style: TextStyle(
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
                    // Terms of Use
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.description_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.profile_support_terms,
                      subtitle: localizations.profile_support_terms_sub,
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
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
                        color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
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
                    Divider(height: 1.0, indent: 68.0, endIndent: 16.0, color: dividerColor),
                    // Open Source Licenses
                    _build_preference_row(
                      is_dark: is_dark,
                      leadingIcon: const Icon(Icons.code_rounded, color: AppColors.primary_color, size: 20.0),
                      title: localizations.legal_open_source,
                      subtitle: localizations.legal_open_source_sub,
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
                      ),
                      onTap: () {
                        _show_legal_modal(
                          context: context,
                          title: localizations.legal_open_source,
                          content: localizations.legal_open_source_content,
                          is_dark: is_dark,
                          localizations: localizations,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

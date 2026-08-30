/*
 * File Name: doctor_hero_header.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.6.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, app_network_image.dart, custom_profile_app_bar.dart,
 *   doctor_profile_entity.dart, favorite_heart_button.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/08/2026]
 * File Description: Modern edge-to-edge Hero Banner featuring 44x44 action buttons,
 *   decoupled 2-tier metadata badges, borderless portrait with gradient ShaderMask,
 *   local asset and network image support, and verified credentials.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, widgets, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/widgets/app_network_image.dart';
import 'package:appoynt_mobile_app/features/shared/widgets/favorite_heart_button.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Modern edge-to-edge Hero Banner presenting doctor portrait and credentials.
class DoctorHeroHeader extends StatelessWidget {
  // Doctor domain entity
  final DoctorProfileEntity profile;
  // Favorite state boolean
  final bool is_favorite;
  // Favorite button tap callback
  final VoidCallback? on_favorite_tap;
  // Share button tap callback
  final VoidCallback? on_share_tap;
  // Back navigation callback
  final VoidCallback? on_back_tap;

  // Constant constructor
  const DoctorHeroHeader({
    super.key,
    required this.profile,
    this.is_favorite = false,
    this.on_favorite_tap,
    this.on_share_tap,
    this.on_back_tap,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final double screen_width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // 1. Ambient Background Gradient Glow
        Container(
          height: 355.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary_color
                    .withValues(alpha: is_dark ? 0.25 : 0.15),
                is_dark ? AppColors.background_dark : AppColors.scaffold_light,
              ],
            ),
          ),
        ),

        // 2. Large Borderless Doctor Portrait with smooth ShaderMask fade
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 275.0,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black,
                  AppColors.black.withValues(alpha: 0.95),
                  AppColors.black.withValues(alpha: 0.3),
                  AppColors.transparent,
                ],
                stops: const [0.0, 0.50, 0.85, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: AppNetworkImage(
              image_url: profile.profile_photo_url,
              width: double.infinity,
              height: 275.0,
              border_radius: 0.0,
              fallback_icon: Icons.person_rounded,
            ),
          ),
        ),

        // 3. Foreground Content Column
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space_xl,
              vertical: AppSpacing.space_xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Navigation Action Bar with 44x44 Accessible Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _build_action_button(
                      is_dark: is_dark,
                      on_tap:
                          on_back_tap ?? () => Navigator.of(context).maybePop(),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20.0,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                        textDirection: Directionality.of(context),
                      ),
                    ),
                    Row(
                      children: [
                        _build_action_button(
                          is_dark: is_dark,
                          on_tap: on_share_tap ??
                              () {
                                CustomSnackBar.info(
                                  context,
                                  'Sharing profile of ${profile.full_name}...',
                                  duration: const Duration(seconds: 2),
                                );
                              },
                          child: Icon(
                            Icons.share_outlined,
                            size: 22.0,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space_m),
                        _build_action_button(
                          is_dark: is_dark,
                          on_tap: on_favorite_tap ?? () {},
                          child: FavoriteHeartButton(
                            is_favorite: is_favorite,
                            on_tap: on_favorite_tap,
                            size: 22.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Spacer to place Doctor details neatly over bottom gradient
                const SizedBox(height: 150.0),

                // Doctor Full Name + Verified Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          profile.full_name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppSpacing.dummy_font_size_welcome,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                      ),
                    ),
                    ..._build_verified_badge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.space_s + 2.0),

                // ── Tier 1: Standalone Specialty Chip ──
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screen_width * 0.88,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_m,
                      vertical: AppSpacing.space_xs + 1.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary_color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.medical_services_outlined,
                          color: AppColors.primary_color,
                          size: 15.0,
                        ),
                        const SizedBox(width: 5.0),
                        Flexible(
                          child: Text(
                            profile.specialty,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: AppSpacing.font_size_body_small,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary_color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),

                // ── Tier 2: Dedicated Row for Availability & Fee Badges ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Availability indicator badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space_m,
                        vertical: AppSpacing.space_xs + 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: profile.is_available_today
                            ? AppColors.dummy_custom_green
                                .withValues(alpha: 0.12)
                            : AppColors.amber.withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radius_l),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7.0,
                            height: 7.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: profile.is_available_today
                                  ? AppColors.dummy_custom_green
                                  : AppColors.amber,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            profile.is_available_today
                                ? localizations.available_today
                                : localizations.unavailable_today,
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_label,
                              fontWeight: FontWeight.w700,
                              color: profile.is_available_today
                                  ? AppColors.dummy_custom_green
                                  : AppColors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),

                    // Fee badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space_m,
                        vertical: AppSpacing.space_xs + 1.0,
                      ),
                      decoration: BoxDecoration(
                        color: is_dark
                            ? AppColors.inner_container_dark
                            : AppColors.slate_100,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radius_l),
                        border: Border.all(
                          color: is_dark
                              ? AppColors.border_dark
                              : AppColors.border_light,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.payments_outlined,
                            color: AppColors.dummy_custom_green,
                            size: 15.0,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            "${profile.consultation_fee.toStringAsFixed(0)} ${profile.currency}",
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_body_small,
                              fontWeight: FontWeight.w700,
                              color: is_dark
                                  ? AppColors.text_dark_primary
                                  : AppColors.text_light_primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _build_action_button({
    required Widget child,
    required VoidCallback on_tap,
    required bool is_dark,
  }) {
    return GestureDetector(
      onTap: on_tap,
      child: Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: is_dark ? AppColors.surface_dark : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radius_l),
          border: Border.all(
            color: is_dark ? AppColors.border_dark : AppColors.slate200,
            width: AppSpacing.border_width_thin,
          ),
          boxShadow: [
            BoxShadow(
              color: is_dark
                  ? AppColors.black26
                  : AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8.0,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  /// Builds a circular profile avatar with local asset and network fallback support
  static Widget buildProfileAvatar(String imagePath, {double size = 120.0}) {
    final String path = imagePath.trim();
    final bool isAsset = path.startsWith('assets/');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: isAsset
            ? Image.asset(
                path,
                width: size,
                height: size,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: size,
                  height: size,
                  color: AppColors.blue50,
                  child: const Icon(Icons.person,
                      color: AppColors.primary, size: 48),
                ),
              )
            : (path.isNotEmpty
                ? Image.network(
                    path,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          width: size,
                          height: size,
                          color: AppColors.grey200,
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: size,
                      height: size,
                      color: AppColors.blue50,
                      child: const Icon(Icons.person,
                          color: AppColors.primary, size: 48),
                    ),
                  )
                : Container(
                    width: size,
                    height: size,
                    color: AppColors.blue50,
                    child: const Icon(Icons.person,
                        color: AppColors.primary, size: 48),
                  )),
      ),
    );
  }

  /// Builds the verified badge icon when the doctor profile is verified.
  List<Widget> _build_verified_badge() {
    if (profile.is_verified) {
      return [
        const SizedBox(width: 6.0),
        const Icon(
          Icons.verified_rounded,
          color: AppColors.primary_color,
          size: 22.0,
        ),
      ];
    } else {
      return const [];
    }
  }
}

/*
 * File Name: doctor_media_gallery.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, app_network_image.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Horizontal media gallery displaying high-resolution clinic photos
 *   and procedure videos with video player indicator overlays and localized preview dialog.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/widgets/app_network_image.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Horizontal media gallery with image preview and video player indicators.
class DoctorMediaGallery extends StatelessWidget {
  // Media items list
  final List<DoctorMediaEntity> media_list;

  // Constant constructor
  const DoctorMediaGallery({
    super.key,
    required this.media_list,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (media_list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_xl,
        vertical: AppSpacing.space_s,
      ),
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  size: 20.0,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),
              Text(
                localizations.media_gallery_label,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_title_medium,
                  fontWeight: FontWeight.w700,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_l),

          // Horizontal list
          SizedBox(
            height: 110.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: media_list.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.space_m),
              itemBuilder: (context, index) {
                final media = media_list[index];
                return _build_media_thumbnail(context, media, is_dark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_media_thumbnail(
    BuildContext context,
    DoctorMediaEntity media,
    bool is_dark,
  ) {
    final bool is_video = media.type == DoctorMediaType.video;

    return GestureDetector(
      onTap: () => _open_media_preview(context, media),
      child: Container(
        width: 140.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radius_l),
          border: Border.all(
            color: is_dark ? AppColors.border_dark : AppColors.slate_200,
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(
              image_url: media.thumbnail_url.isNotEmpty
                  ? media.thumbnail_url
                  : media.url,
              width: 140.0,
              height: 110.0,
              border_radius: 0.0,
              fallback_icon: Icons.image_rounded,
            ),
            if (is_video)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.white,
                    size: 24.0,
                  ),
                ),
              ),
            Positioned(
              bottom: 4.0,
              right: 6.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      is_video
                          ? Icons.videocam_rounded
                          : Icons.photo_camera_rounded,
                      color: AppColors.white,
                      size: 11.0,
                    ),
                    const SizedBox(width: 3.0),
                    Text(
                      is_video ? 'Video' : 'Photo',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 9.0,
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
    );
  }

  void _open_media_preview(
    BuildContext context,
    DoctorMediaEntity media,
  ) {
    final bool is_video = media.type == DoctorMediaType.video;
    final AppLocalizations localizations = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (sheet_context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surface_dark
                : AppColors.background_light,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radius_xxl),
              topRight: Radius.circular(AppSpacing.radius_xxl),
            ),
          ),
          child: Column(
            children: [
              // Header Drag Handle & Close Button
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.space_xl,
                  AppSpacing.space_m,
                  AppSpacing.space_m,
                  AppSpacing.space_s,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      is_video ? localizations.clinic_tour : localizations.clinic_photo,
                      style: const TextStyle(
                        fontSize: AppSpacing.font_size_title_medium,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(sheet_context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0),

              // Media Display Area
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.space_l),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
                      child: is_video
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                AppNetworkImage(
                                  image_url: media.thumbnail_url,
                                  width: double.infinity,
                                  height: double.infinity,
                                  border_radius: 0.0,
                                  fallback_icon: Icons.movie_rounded,
                                ),
                                Container(
                                  color: AppColors.black.withValues(alpha: 0.4),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary_color,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary_color
                                                .withValues(alpha: 0.4),
                                            blurRadius: 16.0,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: AppColors.white,
                                        size: 40.0,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.space_m),
                                    Text(
                                      localizations.clinic_tour,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: AppSpacing.font_size_body_medium,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : InteractiveViewer(
                              minScale: 0.8,
                              maxScale: 4.0,
                              child: AppNetworkImage(
                                image_url: media.url,
                                width: double.infinity,
                                height: double.infinity,
                                border_radius: 0.0,
                                fallback_icon: Icons.image_rounded,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

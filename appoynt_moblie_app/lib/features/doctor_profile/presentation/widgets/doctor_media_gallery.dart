/*
 * File Name: doctor_media_gallery.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, app_network_image.dart, doctor_profile_entity.dart,
 *   doctor_media_preview_dialog.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Horizontal media gallery displaying clinic photos and procedure
 *   videos with Hero animations and full-screen glassmorphic preview modal integration.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/widgets/app_network_image.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_media_preview_dialog.dart';

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
    } else {
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

          // Horizontal media list
          SizedBox(
            height: 110.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: media_list.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.space_m),
              itemBuilder: (context, index) {
                final DoctorMediaEntity media = media_list[index];
                return _build_media_thumbnail(context, media, index, is_dark);
              },
            ),
          ),
        ],
      ),
    );
    }
  }

  Widget _build_media_thumbnail(
    BuildContext context,
    DoctorMediaEntity media,
    int index,
    bool is_dark,
  ) {
    final bool is_video = media.type == DoctorMediaType.video;

    return GestureDetector(
      onTap: () {
        DoctorMediaPreviewDialog.show(
          context: context,
          media_list: media_list,
          initial_index: index,
        );
      },
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
            Hero(
              tag: 'media_${media.id}',
              child: AppNetworkImage(
                image_url: media.thumbnail_url.isNotEmpty
                    ? media.thumbnail_url
                    : media.url,
                width: 140.0,
                height: 110.0,
                border_radius: 0.0,
                fallback_icon: Icons.image_rounded,
              ),
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
}

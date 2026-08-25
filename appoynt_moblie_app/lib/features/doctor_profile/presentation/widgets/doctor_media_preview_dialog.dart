/*
 * File Name: doctor_media_preview_dialog.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, app_network_image.dart, doctor_profile_entity.dart,
 *   doctor_video_player_widget.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Modern glassmorphic full-screen media viewer dialog supporting
 *   horizontal PageView navigation, swipe-down to dismiss, pinch-to-zoom for photos,
 *   Hero transitions, and embedded custom video streaming.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/widgets/app_network_image.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_video_player_widget.dart';

/// Full-screen interactive media viewer dialog.
class DoctorMediaPreviewDialog extends StatefulWidget {
  // Complete list of media entities
  final List<DoctorMediaEntity> media_list;
  // Initial page index to display
  final int initial_index;

  // Constant constructor
  const DoctorMediaPreviewDialog({
    super.key,
    required this.media_list,
    this.initial_index = 0,
  });

  /// Static helper to display the full-screen dialog with smooth fade transition.
  static Future<void> show({
    required BuildContext context,
    required List<DoctorMediaEntity> media_list,
    int initial_index = 0,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: AppColors.black.withValues(alpha: 0.94),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: DoctorMediaPreviewDialog(
              media_list: media_list,
              initial_index: initial_index,
            ),
          );
        },
      ),
    );
  }

  @override
  State<DoctorMediaPreviewDialog> createState() {
    return _DoctorMediaPreviewDialogState();
  }
}

class _DoctorMediaPreviewDialogState extends State<DoctorMediaPreviewDialog> {
  // Page controller for horizontal swipe
  late final PageController _page_controller;
  // Current active index
  late int _current_index;
  // Drag offset for vertical swipe-to-dismiss gesture
  double _drag_offset_y = 0.0;

  @override
  void initState() {
    super.initState();
    _current_index = widget.initial_index.clamp(0, widget.media_list.length - 1);
    _page_controller = PageController(initialPage: _current_index);
  }

  @override
  void dispose() {
    _page_controller.dispose();
    super.dispose();
  }

  void _on_vertical_drag_update(DragUpdateDetails details) {
    // Track downward drag
    if (details.delta.dy > 0 || _drag_offset_y > 0) {
      setState(() {
        _drag_offset_y += details.delta.dy;
      });
    } else {
      // No action needed
    }
  }

  void _on_vertical_drag_end(DragEndDetails details) {
    if (_drag_offset_y > 100 || (details.primaryVelocity ?? 0) > 300) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _drag_offset_y = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final DoctorMediaEntity current_media = widget.media_list[_current_index];
    final bool is_current_video =
        current_media.type == DoctorMediaType.video;

    // Calculate drag opacity for swipe-down to dismiss
    final double drag_opacity = (1.0 - (_drag_offset_y / 350.0)).clamp(0.4, 1.0);

    return Scaffold(
      backgroundColor: AppColors.black.withValues(alpha: 0.94 * drag_opacity),
      body: GestureDetector(
        onVerticalDragUpdate: _on_vertical_drag_update,
        onVerticalDragEnd: _on_vertical_drag_end,
        child: Transform.translate(
          offset: Offset(0, _drag_offset_y),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Horizontal PageView for Media Content
              PageView.builder(
                controller: _page_controller,
                itemCount: widget.media_list.length,
                onPageChanged: (index) {
                  setState(() {
                    _current_index = index;
                  });
                },
                itemBuilder: (context, index) {
                  final DoctorMediaEntity media = widget.media_list[index];
                  return _build_media_page(context, media);
                },
              ),

              // 2. Top Navigation Overlay (Close Button & Page Indicator)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                      vertical: AppSpacing.space_m,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Glassmorphic Close Button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.2),
                                width: 1.0,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.white,
                                size: 22.0,
                              ),
                            ),
                          ),
                        ),

                        // Media Index Badge (e.g., "1 / 4")
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space_l,
                            vertical: AppSpacing.space_xs + 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.55),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radius_l),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.2),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            "${_current_index + 1} / ${widget.media_list.length}",
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: AppSpacing.font_size_body_small,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Bottom Caption & Details Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.space_xl,
                    AppSpacing.space_xxl,
                    AppSpacing.space_xl,
                    AppSpacing.space_xxl,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.black.withValues(alpha: 0.90),
                        AppColors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: is_current_video
                                ? AppColors.orange.withValues(alpha: 0.2)
                                : AppColors.primary_color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            is_current_video
                                ? Icons.videocam_rounded
                                : Icons.photo_camera_rounded,
                            color: is_current_video
                                ? AppColors.orange
                                : AppColors.primary_color,
                            size: 18.0,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space_m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                is_current_video
                                    ? localizations.clinic_tour
                                    : localizations.clinic_photo,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: AppSpacing.font_size_title_medium,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                is_current_video
                                    ? 'Tap video to play/pause or scrub timeline'
                                    : 'Pinch with two fingers to zoom in/out',
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                  fontSize: AppSpacing.font_size_label,
                                  fontWeight: FontWeight.w500,
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
          ),
        ),
      ),
    );
  }

  Widget _build_media_page(BuildContext context, DoctorMediaEntity media) {
    if (media.type == DoctorMediaType.video) {
      return DoctorVideoPlayerWidget(
        video_url: media.url,
        thumbnail_url: media.thumbnail_url,
      );
    } else {
      return Center(
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 3.5,
          child: Hero(
            tag: 'media_${media.id}',
            child: AppNetworkImage(
              image_url: media.url,
              width: double.infinity,
              height: double.infinity,
              border_radius: 0.0,
              fallback_icon: Icons.image_rounded,
            ),
          ),
        ),
      );
    }
  }
}

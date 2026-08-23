/*
 * File Name: doctor_video_player_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:flutter/material.dart, package:video_player/video_player.dart,
 *   app_colors.dart, app_spacing.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/08/2026]
 * File Description: Clean standalone video player widget supporting network video
 *   streaming from official CDN sources, auto-looping, aspect ratio preservation,
 *   animated controls, progress scrubbing, and graceful error recovery.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import video player package
import 'package:video_player/video_player.dart';
// Import design tokens and colors
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

/// Interactive custom video player component for doctor procedure and tour videos.
class DoctorVideoPlayerWidget extends StatefulWidget {
  // Network video URL endpoint
  final String video_url;
  // Optional thumbnail preview image URL
  final String? thumbnail_url;
  // Auto play boolean flag
  final bool auto_play;

  // Constant constructor
  const DoctorVideoPlayerWidget({
    super.key,
    required this.video_url,
    this.thumbnail_url,
    this.auto_play = true,
  });

  @override
  State<DoctorVideoPlayerWidget> createState() =>
      _DoctorVideoPlayerWidgetState();
}

class _DoctorVideoPlayerWidgetState extends State<DoctorVideoPlayerWidget> {
  // Video player controller
  VideoPlayerController? _controller;
  // Initialization state flag
  bool _is_initializing = true;
  // Error state flag
  bool _has_error = false;
  // Controls overlay visibility flag
  bool _show_controls = true;

  @override
  void initState() {
    super.initState();
    _initialize_video_player();
  }

  @override
  void didUpdateWidget(covariant DoctorVideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video_url != widget.video_url) {
      _dispose_controller();
      _initialize_video_player();
    } else {
      // No action needed
    }
  }

  /// Initializes the video controller cleanly using official networkUrl loader.
  Future<void> _initialize_video_player() async {
    if (!mounted) {
      return;
    } else {
      _dispose_controller();

      setState(() {
        _is_initializing = true;
        _has_error = false;
      });

      try {
        final String trimmed_url = widget.video_url.trim();
        debugPrint('Loading Video URL: $trimmed_url');

        final Uri uri = Uri.parse(trimmed_url);
        final VideoPlayerController controller =
            VideoPlayerController.networkUrl(uri);

        _controller = controller;

        controller.addListener(_video_listener);

        await controller.initialize();

        if (!mounted) {
          await controller.dispose();
          return;
        } else {
          await controller.setLooping(true);

          if (widget.auto_play) {
            await controller.play();
          } else {
            // No action needed
          }

          if (mounted) {
            setState(() {
              _is_initializing = false;
              _has_error = controller.value.hasError;
            });
          } else {
            // No action needed
          }
        }
      } catch (e) {
        debugPrint('Video initialization failed: $e');
        if (mounted) {
          setState(() {
            _is_initializing = false;
            _has_error = true;
          });
        } else {
          // No action needed
        }
      }
    }
  }

  void _video_listener() {
    if (!mounted) {
      return;
    } else {
      final VideoPlayerController? controller = _controller;
      if (controller != null && controller.value.hasError) {
        debugPrint(
            'Video controller error: ${controller.value.errorDescription}');
        setState(() {
          _has_error = true;
          _is_initializing = false;
        });
      } else {
        setState(() {});
      }
    }
  }

  void _dispose_controller() {
    _controller?.removeListener(_video_listener);
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _dispose_controller();
    super.dispose();
  }

  void _toggle_play_pause() {
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    } else {
      setState(() {
        if (controller.value.isPlaying) {
          controller.pause();
          _show_controls = true;
        } else {
          controller.play();
          _show_controls = false;
        }
      });
    }
  }

  String _format_duration(Duration duration) {
    final String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? controller = _controller;

    // 1. Error State with Clean Retry Button
    if (_has_error || controller == null) {
      return Container(
        color: AppColors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.white.withValues(alpha: 0.7),
                size: 44.0,
              ),
              const SizedBox(height: AppSpacing.space_m),
              const Text(
                'Unable to load video stream',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSpacing.font_size_body_medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.space_l),
              ElevatedButton.icon(
                onPressed: _initialize_video_player,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_color,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18.0),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    } else if (_is_initializing || !controller.value.isInitialized) {
      // 2. Loading State with Sleek Pulse
      return Container(
        color: AppColors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary_color,
            strokeWidth: 3.0,
          ),
        ),
      );
    } else {
      final double aspect_ratio = controller.value.aspectRatio > 0
          ? controller.value.aspectRatio
          : 16 / 9;

      final Duration position = controller.value.position;
      final Duration total_duration = controller.value.duration;
      final bool is_playing = controller.value.isPlaying;

      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        child: Container(
          color: AppColors.black,
          child: AspectRatio(
            aspectRatio: aspect_ratio,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _show_controls = !_show_controls;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video Surface
                  VideoPlayer(controller),

                  // Center Play/Pause Overlay Button
                  _build_center_play_button(is_playing),

                  // Bottom Controls Bar with Time and Scrubber
                  _build_bottom_controls_bar(
                    controller,
                    position,
                    total_duration,
                    is_playing,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  /// Builds the center play / pause overlay button.
  Widget _build_center_play_button(bool is_playing) {
    if (_show_controls || !is_playing) {
      return Center(
        child: GestureDetector(
          onTap: _toggle_play_pause,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.65),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            child: Icon(
              is_playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: AppColors.white,
              size: 40.0,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Builds the bottom gradient controls bar with duration and scrubber.
  Widget _build_bottom_controls_bar(
    VideoPlayerController controller,
    Duration position,
    Duration total_duration,
    bool is_playing,
  ) {
    if (_show_controls || !is_playing) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.black.withValues(alpha: 0.85),
                AppColors.transparent,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Interactive Progress Indicator
              VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                colors: VideoProgressColors(
                  playedColor: AppColors.primary_color,
                  bufferedColor: AppColors.white.withValues(alpha: 0.35),
                  backgroundColor: AppColors.white.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(height: 4.0),

              // Time Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _format_duration(position),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppSpacing.font_size_label,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _format_duration(total_duration),
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: AppSpacing.font_size_label,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

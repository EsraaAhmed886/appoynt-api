/*
 * File Name: doctor_video_player_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:flutter/material.dart, package:video_player/video_player.dart,
 *   app_colors.dart, app_spacing.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
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
  // Optional thumbnail preview image while loading
  final String? thumbnail_url;
  // Auto play upon initialization flag
  final bool auto_play;

  // Constant constructor
  const DoctorVideoPlayerWidget({
    super.key,
    required this.video_url,
    this.thumbnail_url,
    this.auto_play = true,
  });

  @override
  State<DoctorVideoPlayerWidget> createState() {
    return _DoctorVideoPlayerWidgetState();
  }
}

class _DoctorVideoPlayerWidgetState extends State<DoctorVideoPlayerWidget> {
  // Underlying video player controller
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
    }
  }

  /// Initializes the video controller cleanly using official networkUrl loader.
  Future<void> _initialize_video_player() async {
    if (!mounted) return;

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
      }

      await controller.setLooping(true);

      if (widget.auto_play) {
        await controller.play();
      }

      if (mounted) {
        setState(() {
          _is_initializing = false;
          _has_error = controller.value.hasError;
        });
      }
    } catch (e) {
      debugPrint('Video initialization failed: $e');
      if (mounted) {
        setState(() {
          _is_initializing = false;
          _has_error = true;
        });
      }
    }
  }

  void _video_listener() {
    if (!mounted) return;

    final VideoPlayerController? controller = _controller;
    if (controller != null && controller.value.hasError) {
      debugPrint('Video controller error: ${controller.value.errorDescription}');
      setState(() {
        _has_error = true;
        _is_initializing = false;
      });
    } else {
      setState(() {});
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
    if (controller == null || !controller.value.isInitialized) return;

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
    }

    // 2. Loading State with Sleek Pulse
    if (_is_initializing || !controller.value.isInitialized) {
      return Container(
        color: AppColors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary_color,
            strokeWidth: 3.0,
          ),
        ),
      );
    }

    final double aspect_ratio = controller.value.aspectRatio > 0
        ? controller.value.aspectRatio
        : 16 / 9;

    final Duration position = controller.value.position;
    final Duration total_duration = controller.value.duration;
    final bool is_playing = controller.value.isPlaying;

    return GestureDetector(
      onTap: () {
        setState(() {
          _show_controls = !_show_controls;
        });
      },
      child: Container(
        color: AppColors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: aspect_ratio,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                // Video Stream Render Surface
                VideoPlayer(controller),

                // Animated Center Play/Pause Indicator
                if (_show_controls || !is_playing)
                  AnimatedOpacity(
                    opacity: _show_controls || !is_playing ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Center(
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
                            is_playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: AppColors.white,
                            size: 40.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Bottom Controls Bar with Time and Scrubber
                if (_show_controls || !is_playing)
                  Positioned(
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
                              bufferedColor:
                                  AppColors.white.withValues(alpha: 0.35),
                              backgroundColor:
                                  AppColors.white.withValues(alpha: 0.15),
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

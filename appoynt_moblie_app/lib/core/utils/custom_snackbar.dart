/*
 * File Name: custom_snackbar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 27/08/2026
 * Version Information: V2.0.0
 * Dependencies: dart:async,
 *   package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Centralized animated top-sliding toast and banner notification utility supporting success,
 *   error, warning, and info message types with smooth physics, pastel tints, and non-intrusive positioning.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

/// Supported notification feedback types for standardized appearance
enum SnackBarType {
  success,
  error,
  warning,
  info,
}

/// Global centralized Top Toast & Banner helper providing animated top-sliding feedback notifications
class CustomSnackBar {
  // Private constructor to prevent direct instantiation
  CustomSnackBar._();

  static OverlayEntry? _currentOverlay;

  /// Default bottom margin preserved for backward compatibility
  static const double default_bottom_margin = 12.0;

  /// Shows an animated top toast notification that slides down smoothly under the status bar
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    if (false == context.mounted) {
      return;
    } else {
      // Context is mounted and valid
    }

    _dismissCurrent();

    final OverlayState? overlayState =
        Overlay.maybeOf(context, rootOverlay: true) ?? Overlay.maybeOf(context);
    if (null == overlayState) {
      return;
    } else {
      // Overlay state resolved
    }

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) => _TopToastWidget(
        message: message,
        type: type,
        duration: duration,
        onAction: onAction,
        actionLabel: actionLabel,
        onDismissed: () => _dismissCurrent(overlayEntry),
      ),
    );

    _currentOverlay = overlayEntry;
    overlayState.insert(overlayEntry);
  }

  /// Dismisses the currently active overlay entry safely if mounted
  static void _dismissCurrent([OverlayEntry? entry]) {
    if (null != entry && _currentOverlay != entry) {
      if (entry.mounted) {
        entry.remove();
      } else {
        // Entry is not mounted
      }
      return;
    } else {
      // Entry matches active overlay or is null
    }

    if (null != _currentOverlay) {
      if (_currentOverlay!.mounted) {
        _currentOverlay!.remove();
      } else {
        // Overlay is not mounted
      }
      _currentOverlay = null;
    } else {
      // No active overlay
    }
  }

  /// Convenience shortcut for displaying a success toast
  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) =>
      show(
        context,
        message: message,
        type: SnackBarType.success,
        duration: duration,
        bottomMargin: bottomMargin,
        onAction: onAction,
        actionLabel: actionLabel,
      );

  /// Convenience shortcut for displaying an error toast
  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) =>
      show(
        context,
        message: message,
        type: SnackBarType.error,
        duration: duration,
        bottomMargin: bottomMargin,
        onAction: onAction,
        actionLabel: actionLabel,
      );

  /// Convenience shortcut for displaying a warning toast
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) =>
      show(
        context,
        message: message,
        type: SnackBarType.warning,
        duration: duration,
        bottomMargin: bottomMargin,
        onAction: onAction,
        actionLabel: actionLabel,
      );

  /// Convenience shortcut for displaying an informational toast
  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    double bottomMargin = default_bottom_margin,
    VoidCallback? onAction,
    String? actionLabel,
  }) =>
      show(
        context,
        message: message,
        type: SnackBarType.info,
        duration: duration,
        bottomMargin: bottomMargin,
        onAction: onAction,
        actionLabel: actionLabel,
      );
}

class _TopToastWidget extends StatefulWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback onDismissed;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _TopToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
    this.onAction,
    this.actionLabel,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _dismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Auto-dismiss after duration
    _dismissTimer = Timer(widget.duration, () {
      if (mounted && false == _isDismissing) {
        _dismiss();
      } else {
        // Already dismissed or unmounted
      }
    });
  }

  void _dismiss() {
    _dismissTimer?.cancel();
    if (_isDismissing) {
      return;
    } else {
      // Proceed with dismiss
    }
    _isDismissing = true;
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) {
          widget.onDismissed();
        } else {
          // Unmounted after reverse
        }
      });
    } else {
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + 10.0;

    final Color bgColor;
    final Color borderColor;
    final Color iconColor;
    final IconData icon;

    switch (widget.type) {
      case SnackBarType.success:
        bgColor = AppColors.successBg;
        borderColor = AppColors.successBorder;
        iconColor = AppColors.successIcon;
        icon = Icons.check_circle_rounded;
        break;
      case SnackBarType.error:
        bgColor = AppColors.errorBg;
        borderColor = AppColors.errorBorder;
        iconColor = AppColors.errorIcon;
        icon = Icons.cancel_rounded;
        break;
      case SnackBarType.warning:
        bgColor = AppColors.warningBg;
        borderColor = AppColors.warningBorder;
        iconColor = AppColors.warningIcon;
        icon = Icons.warning_rounded;
        break;
      case SnackBarType.info:
      default:
        bgColor = AppColors.infoBg;
        borderColor = AppColors.infoBorder;
        iconColor = AppColors.infoIcon;
        icon = Icons.info_rounded;
        break;
    }

    return Positioned(
      top: topPadding,
      left: 16.0,
      right: 16.0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: AppColors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: borderColor,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.06),
                      blurRadius: 10.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: iconColor,
                      size: 22.0,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: AppColors.notificationText,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildActionButton(iconColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(Color iconColor) {
    if (null != widget.actionLabel && null != widget.onAction) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: GestureDetector(
          onTap: () {
            widget.onAction!();
            _dismiss();
          },
          child: Text(
            widget.actionLabel!,
            style: TextStyle(
              color: iconColor,
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

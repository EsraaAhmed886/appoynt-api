/*
 * File Name: draggable_floating_ai_button.dart
 * Author: Kholoud Khaled
 * Date of Creation: 30/08/2026
 * Version Information: v1.4.0
 * Dependencies: flutter/material.dart, flutter_svg/flutter_svg.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: A draggable interactive floating action button (68px) with 115px bottom nav clearance threshold, preventing overlap with the bottom navigation bar and preserving original visual design and SVG asset.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart';

/// Draggable interactive floating action button for the Ask AI bot.
class DraggableFloatingAiButton extends StatefulWidget {
  /// Optional custom callback when the button is tapped.
  final VoidCallback? onTap;

  /// Custom icon asset path (defaulting to the original SVG chatbot asset).
  final String customIconAsset;

  const DraggableFloatingAiButton({
    super.key,
    this.onTap,
    this.customIconAsset = 'assets/icons/ChatbotFAB.svg',
  });

  @override
  State<DraggableFloatingAiButton> createState() =>
      _DraggableFloatingAiButtonState();
}

class _DraggableFloatingAiButtonState extends State<DraggableFloatingAiButton> {
  Offset? _position;

  // Increased button diameter for better prominence (68.0px)
  final double _buttonSize = 68.0;

  final double _bottomNavThreshold = 140.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Default Initial Position: Hovering safely above the Bottom Nav Bar
    if (null == _position) {
      final Size screenSize = MediaQuery.of(context).size;
      final EdgeInsets padding = MediaQuery.of(context).padding;

      final double initialX = screenSize.width - _buttonSize - 16.0;
      final double initialY = screenSize.height -
          _buttonSize -
          padding.bottom -
          _bottomNavThreshold;

      _position = Offset(initialX, initialY);
    } else {
      // Empty block satisfying compiler
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null == _position) {
      return const SizedBox.shrink();
    } else {
      // Empty block satisfying compiler
    }

    final Size screenSize = MediaQuery.of(context).size;
    final EdgeInsets padding = MediaQuery.of(context).padding;

    // Strict Boundary Constraints
    const double minX = 12.0;
    final double maxX = screenSize.width - _buttonSize - 12.0;

    // Top limit: Below status bar / notch
    final double minY = padding.top + 16.0;

    // Bottom limit: Strictly above the Bottom Navigation Bar (never behind it)
    final double maxY =
        screenSize.height - _buttonSize - padding.bottom - _bottomNavThreshold;

    return Positioned(
      left: _position!.dx,
      top: _position!.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            double newX = _position!.dx + details.delta.dx;
            double newY = _position!.dy + details.delta.dy;

            // Clamp coordinates strictly within boundaries
            newX = newX.clamp(minX, maxX);
            newY = newY.clamp(minY, maxY);

            _position = Offset(newX, newY);
          });
        },
        child: Container(
          width: _buttonSize,
          height: _buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                AppColors.primary, // Medical Primary Blue
                AppColors.indigo600, // Deep Indigo
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 16.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.18),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: () {
                if (null != widget.onTap) {
                  widget.onTap!();
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AskAiDummyView(),
                    ),
                  );
                }
              },
              customBorder: const CircleBorder(),
              splashColor: AppColors.white.withValues(alpha: 0.25),
              highlightColor: AppColors.white.withValues(alpha: 0.12),
              child: Center(
                child: widget.customIconAsset.endsWith('.svg')
                    ? SvgPicture.asset(
                        widget.customIconAsset,
                        width: _buttonSize,
                        height: _buttonSize,
                        fit: BoxFit.contain,
                      )
                    : widget.customIconAsset.endsWith('.png')
                        ? Image.asset(
                            widget.customIconAsset,
                            width: _buttonSize * 0.85,
                            height: _buttonSize * 0.85,
                            fit: BoxFit.contain,
                            color: AppColors.white,
                          )
                        : const Icon(
                            Icons.smart_toy_rounded,
                            size: 36.0,
                            color: AppColors.white,
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

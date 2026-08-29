/*
 * File Name: ask_ai_fab.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.1.0
 * Dependencies: flutter/material.dart, flutter_svg/flutter_svg.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Prominent circular floating action button with scaled-up AI Chatbot icon (42.0px)
 *   filling ~75-80% of the circle diameter with brand glow, opening AskAiDummyView.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/features/ask_ai/presentation/views/ask_ai_dummy_view.dart';

/// Large circular floating action button displaying prominent AI icon.
class AskAiFab extends StatelessWidget {
  final VoidCallback? onTap;
  final String customIconAsset;

  const AskAiFab({
    super.key,
    this.onTap,
    this.customIconAsset = 'assets/icons/ChatbotFAB.svg',
  });

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 68.0;
    const double iconSize = 68.0;

    return Container(
      width: buttonSize,
      height: buttonSize,
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
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 14.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap ??
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AskAiDummyView(),
                  ),
                );
              },
          customBorder: const CircleBorder(),
          splashColor: AppColors.white.withValues(alpha: 0.25),
          highlightColor: AppColors.white.withValues(alpha: 0.12),
          child: Center(
            child: customIconAsset.endsWith('.svg')
                ? SvgPicture.asset(
                    customIconAsset,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  )
                : customIconAsset.endsWith('.png')
                    ? Image.asset(
                        customIconAsset,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                        color: AppColors.white,
                      )
                    : const Icon(
                        Icons.smart_toy_rounded,
                        size: iconSize,
                        color: AppColors.white,
                      ),
          ),
        ),
      ),
    );
  }
}

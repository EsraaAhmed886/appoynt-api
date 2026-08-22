/*
 * File Name: ask_ai_fab.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, flutter_svg/flutter_svg.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Prominent circular floating action button with scaled-up AI Chatbot icon (42.0px) filling ~75-80% of the circle diameter with brand glow.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            Color(0xFF2563EB), // Medical Primary Blue
            Color(0xFF4338CA), // Deep Indigo
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.4),
            blurRadius: 14.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.25),
          highlightColor: Colors.white.withValues(alpha: 0.12),
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
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.smart_toy_rounded,
                        size: iconSize,
                        color: Colors.white,
                      ),
          ),
        ),
      ),
    );
  }
}

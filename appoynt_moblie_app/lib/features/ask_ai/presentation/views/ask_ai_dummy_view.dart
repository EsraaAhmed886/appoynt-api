/*
 * File Name: ask_ai_dummy_view.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/routing/routes.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Modern Coming Soon placeholder view for the Ask AI medical assistant with custom rounded card back button and home redirect.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/routing/routes.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

/// Modern Coming Soon / Placeholder view for the Ask AI Assistant.
class AskAiDummyView extends StatelessWidget {
  /// Constructor
  const AskAiDummyView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.slate50,
      appBar: AppBar(
        title: Text(
          localizations.ask_ai_title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.slate900,
          ),
        ),
        centerTitle: true,
        leadingWidth: 70.0,
        // -------------------------------------------------------------
        // 1. Unified Custom Rounded Card Back Button
        // -------------------------------------------------------------
        leading: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.slate200,
                  width: 1.0,
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.04),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18.0,
                color: isDark ? AppColors.darkTextPrimary : AppColors.slate800,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Glowing Bot Avatar Container
                Container(
                  width: 110.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 24.0,
                        spreadRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 76.0,
                      height: 76.0,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.smart_toy_rounded,
                        size: 42.0,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28.0),

                // 2. Title & Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    localizations.ask_ai_coming_soon,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14.0),
                Text(
                  localizations.ask_ai_health_assistant,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  localizations.ask_ai_desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.slate600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32.0),

                // 3. Feature Highlights Preview Cards
                _buildFeatureItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: localizations.ask_ai_symptom_consultation_title,
                  subtitle: localizations.ask_ai_symptom_consultation_desc,
                  isDark: isDark,
                ),
                const SizedBox(height: 12.0),
                _buildFeatureItem(
                  icon: Icons.medical_services_outlined,
                  title: localizations.ask_ai_smart_booking_title,
                  subtitle: localizations.ask_ai_smart_booking_desc,
                  isDark: isDark,
                ),
                const SizedBox(height: 36.0),

                // 4. Direct "Back to Home" Redirection Action
                SizedBox(
                  width: double.infinity,
                  height: 52.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.home,
                        (route) => false,
                      );
                    },
                    child: Text(
                      localizations.ask_ai_back_to_home,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.slate200,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.0),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: isDark ? AppColors.darkTextMuted : AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

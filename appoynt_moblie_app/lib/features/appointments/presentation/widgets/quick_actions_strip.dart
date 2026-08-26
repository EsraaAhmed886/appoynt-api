import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: quick_actions_strip.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/quick_action_item_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Quick action cards strip allowing rapid navigation to Prescriptions, Lab Results, and Radiology Reports with zero-resource suppression (BR-34).
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/quick_action_item_model.dart';

/// Quick actions horizontal cards row for Prescriptions, Lab Results, and Radiology Reports.
class QuickActionsStrip extends StatelessWidget {
  final QuickActionsSummaryModel? summary;
  final VoidCallback? onPrescriptionsTap;
  final VoidCallback? onLabResultsTap;
  final VoidCallback? onRadiologyTap;

  const QuickActionsStrip({
    super.key,
    required this.summary,
    this.onPrescriptionsTap,
    this.onLabResultsTap,
    this.onRadiologyTap,
  });

  @override
  Widget build(BuildContext context) {
    // Visibility Guard (BR-34): Hide the entire section if 0 resources exist
    if (summary == null || !summary!.hasAnyResources) {
      return const SizedBox.shrink();
    } else {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              AppointmentsStrings.of(context, 'quick_actions'),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.slate400 : AppColors.slate600,
              ),
            ),
            const SizedBox(height: 10.0),

            // Cards Row
            Row(
              children: [
                // 1. Prescriptions
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: AppointmentsStrings.of(context, 'prescriptions'),
                    count: summary!.prescriptionsCount,
                    icon: Icons.medication_liquid_outlined,
                    color: AppColors.sky600,
                    onTap: onPrescriptionsTap,
                  ),
                ),
                const SizedBox(width: 8.0),

                // 2. Lab Results
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: AppointmentsStrings.of(context, 'lab_results'),
                    count: summary!.labResultsCount,
                    icon: Icons.science_outlined,
                    color: AppColors.teal600,
                    onTap: onLabResultsTap,
                  ),
                ),
                const SizedBox(width: 8.0),

                // 3. Radiology Reports
                Expanded(
                  child: _buildActionCard(
                    context,
                    title: AppointmentsStrings.of(context, 'radiology_reports'),
                    count: summary!.radiologyReportsCount,
                    icon: Icons.biotech_outlined,
                    color: AppColors.indigo500,
                    onTap: onRadiologyTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.12 : 0.08),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.3 : 0.2),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 20.0, color: color),
                  _build_count_badge(count, color),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.slate900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds count badge with explicit control flow.
  Widget _build_count_badge(int count, Color color) {
    if (count > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          count.toString(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

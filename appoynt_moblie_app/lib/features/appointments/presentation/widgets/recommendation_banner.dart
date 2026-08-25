/*
 * File Name: recommendation_banner.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/doctor_recommendation_model.dart, ./appointment_doctor_avatar.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Recommendation banner card recommending top-rated specialists and health checkups with search-suppression guard (BR-63).
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/doctor_recommendation_model.dart';
import 'appointment_doctor_avatar.dart';

/// Horizontal banner displaying top-rated specialist recommendations.
class RecommendationBanner extends StatelessWidget {
  final List<DoctorRecommendationModel> recommendations;
  final ValueChanged<DoctorRecommendationModel>? onBookTap;

  const RecommendationBanner({
    super.key,
    required this.recommendations,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    } else {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              AppointmentsStrings.of(context, 'recommended_doctors'),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 10.0),

            // Horizontal Recommendations List
            SizedBox(
              height: 140.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: recommendations.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12.0),
                itemBuilder: (context, index) {
                  final doc = recommendations[index];
                  return _buildDoctorCard(context, doc, isDark);
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDoctorCard(
    BuildContext context,
    DoctorRecommendationModel doc,
    bool isDark,
  ) {
    return Container(
      width: 280.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          AppointmentDoctorAvatar(
            imageUrl: doc.imageUrl,
            doctorName: doc.name,
            width: 68.0,
            height: 80.0,
          ),
          const SizedBox(width: 10.0),

          // Details + CTA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  doc.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  doc.specialty,
                  style: TextStyle(
                    fontSize: 11.0,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14.0, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 2.0),
                    Text(
                      doc.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      doc.consultationFee,
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                SizedBox(
                  height: 28.0,
                  child: ElevatedButton(
                    onPressed: () => onBookTap?.call(doc),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      AppointmentsStrings.of(context, 'book_now'),
                      style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
                    ),
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

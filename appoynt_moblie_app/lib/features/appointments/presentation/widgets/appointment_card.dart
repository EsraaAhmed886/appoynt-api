/*
 * File Name: appointment_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart, ./appointment_doctor_avatar.dart, ./appointment_status_badge.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Smart appointment card widget rendering doctor info, date/time, facility location, and contextual action buttons based on status and timing.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/appointment_model.dart';
import 'appointment_doctor_avatar.dart';
import 'appointment_status_badge.dart';

/// Interactive card component representing a scheduled, completed, or cancelled appointment.
class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onViewDetails;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onJoinCall;
  final VoidCallback? onBookAgain;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onViewDetails,
    this.onReschedule,
    this.onCancel,
    this.onJoinCall,
    this.onBookAgain,
  });

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dt.month - 1];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month ${dt.day}, ${dt.year} • $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUpcoming = appointment.status == AppointmentStatus.upcoming ||
        appointment.status == AppointmentStatus.confirmed;
    final isJoinable = appointment.canJoinCall();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Avatar + Doctor Info + Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Doctor Avatar
                AppointmentDoctorAvatar(
                  imageUrl: appointment.doctorImageUrl,
                  doctorName: appointment.doctorName,
                  width: 82.0,
                  height: 96.0,
                ),
                const SizedBox(width: 14.0),

                // 2. Doctor Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Verification + Status Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    appointment.doctorName,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _build_verified_badge(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          AppointmentStatusBadge(status: appointment.status),
                        ],
                      ),
                      const SizedBox(height: 4.0),

                      // Specialty
                      Text(
                        appointment.doctorSpecialty ?? AppointmentsStrings.of(context, 'unavailable_doctor'),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6.0),

                      // Rating & Reviews Count
                      _build_rating_row(isDark, context),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Divider
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: isDark ? const Color(0xFF334155).withValues(alpha: 0.6) : const Color(0xFFF1F5F9),
            ),
            const SizedBox(height: 12.0),

            // Date & Time Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    size: 14.0,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    _formatDateTime(appointment.scheduledDateTime),
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                    ),
                  ),
                ),
                _build_online_video_tag(context),
              ],
            ),
            const SizedBox(height: 8.0),

            // Location / Clinic Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 14.0,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.clinicName,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        ),
                      ),
                      _build_clinic_address(isDark),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Bottom Action Strip (Dynamic based on status & timing)
            if (isUpcoming) ...[
              // Join Call Banner Button (if active window)
              if (isJoinable) ...[
                SizedBox(
                  width: double.infinity,
                  height: 44.0,
                  child: ElevatedButton.icon(
                    onPressed: onJoinCall,
                    icon: const Icon(Icons.videocam_rounded, size: 18.0),
                    label: Text(
                      AppointmentsStrings.of(context, 'join_call'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
              ],

              // Action Buttons Row: [Cancel] + [Reschedule] + [View Details]
              Row(
                children: [
                  _build_cancel_button(context),

                  Expanded(
                    flex: 3,
                    child: OutlinedButton(
                      onPressed: onReschedule,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0284C7),
                        side: const BorderSide(color: Color(0xFFBAE6FD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: Text(
                        AppointmentsStrings.of(context, 'reschedule'),
                        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: Text(
                        AppointmentsStrings.of(context, 'view_details'),
                        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Completed / Cancelled / Missed Actions: [Book Again] + [View Details]
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBookAgain,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0284C7),
                        side: const BorderSide(color: Color(0xFFBAE6FD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: Text(
                        AppointmentsStrings.of(context, 'book_again'),
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      child: Text(
                        AppointmentsStrings.of(context, 'view_details'),
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds verified badge icon with explicit control flow.
  Widget _build_verified_badge() {
    if (appointment.isDoctorVerified) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 4.0),
          Icon(
            Icons.verified_rounded,
            size: 16.0,
            color: Color(0xFF0284C7),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Builds doctor rating and review counts row with explicit control flow.
  Widget _build_rating_row(bool isDark, BuildContext context) {
    if (appointment.doctorRating != null) {
      return Row(
        children: [
          const Icon(Icons.star_rounded, size: 16.0, color: Color(0xFFF59E0B)),
          const SizedBox(width: 3.0),
          Text(
            appointment.doctorRating!.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          _build_reviews_count_text(isDark, context),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Builds reviews count text if available.
  Widget _build_reviews_count_text(bool isDark, BuildContext context) {
    if (appointment.doctorReviewsCount != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 4.0),
          Text(
            '(${appointment.doctorReviewsCount} ${AppointmentsStrings.of(context, 'reviews')})',
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Builds online video consultation tag.
  Widget _build_online_video_tag(BuildContext context) {
    if (appointment.type == AppointmentType.onlineVideo) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_rounded, size: 13.0, color: Color(0xFF8B5CF6)),
            const SizedBox(width: 4.0),
            Text(
              AppointmentsStrings.of(context, 'online_video'),
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Builds cancel appointment button if allowed.
  Widget _build_cancel_button(BuildContext context) {
    if (appointment.canCancel) {
      return Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFFFECACA)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            child: Text(
              AppointmentsStrings.of(context, 'cancel_appointment'),
              style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Builds optional clinic address text.
  Widget _build_clinic_address(bool isDark) {
    if (appointment.clinicAddress != null) {
      return Text(
        appointment.clinicAddress!,
        style: TextStyle(
          fontSize: 11.0,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

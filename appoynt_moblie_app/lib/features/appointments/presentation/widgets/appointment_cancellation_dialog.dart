/*
 * File Name: appointment_cancellation_dialog.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Cancellation confirmation dialog calculating refund tiers, displaying cutoff warnings, and capturing optional cancellation reasons.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/appointment_model.dart';

/// Modal dialog confirming appointment cancellation with automated refund eligibility calculation.
class AppointmentCancellationDialog extends StatefulWidget {
  final AppointmentModel appointment;
  final ValueChanged<String?> onConfirm;

  const AppointmentCancellationDialog({
    super.key,
    required this.appointment,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required AppointmentModel appointment,
    required ValueChanged<String?> onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AppointmentCancellationDialog(
        appointment: appointment,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AppointmentCancellationDialog> createState() => _AppointmentCancellationDialogState();
}

class _AppointmentCancellationDialogState extends State<AppointmentCancellationDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final refundTier = widget.appointment.refundEligibility;
    final canCancel = widget.appointment.canCancel;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Icon + Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFEF4444),
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    AppointmentsStrings.of(context, 'cancel_dialog_title'),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Description
            Text(
              AppointmentsStrings.of(context, 'cancel_dialog_desc')
                  .replaceFirst('{name}', widget.appointment.doctorName),
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 14.0),

            // Refund Policy Banner
            _build_refund_banner(canCancel, refundTier, context),
            const SizedBox(height: 14.0),

            // Optional Reason Input Field
            _build_reason_input(canCancel, isDark, context),

            // Action Buttons: [Keep] & [Confirm]
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white70 : const Color(0xFF475569),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: Text(
                      AppointmentsStrings.of(context, 'keep_appointment'),
                      style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canCancel
                        ? () {
                            Navigator.pop(context);
                            final reason = _reasonController.text.trim();
                            widget.onConfirm(reason.isNotEmpty ? reason : null);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: Text(
                      AppointmentsStrings.of(context, 'confirm_cancel'),
                      style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds refund eligibility banner or cutoff warning.
  Widget _build_refund_banner(bool canCancel, RefundEligibility refundTier, BuildContext context) {
    if (canCancel) {
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: refundTier == RefundEligibility.full
              ? const Color(0xFFECFDF5)
              : const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: refundTier == RefundEligibility.full
                ? const Color(0xFFA7F3D0)
                : const Color(0xFFFDE68A),
          ),
        ),
        child: Row(
          children: [
            Icon(
              refundTier == RefundEligibility.full
                  ? Icons.check_circle_outline_rounded
                  : Icons.info_outline_rounded,
              size: 18.0,
              color: refundTier == RefundEligibility.full
                  ? const Color(0xFF059669)
                  : const Color(0xFFD97706),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                refundTier == RefundEligibility.full
                    ? AppointmentsStrings.of(context, 'cancel_full_refund')
                    : AppointmentsStrings.of(context, 'cancel_partial_refund'),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: refundTier == RefundEligibility.full
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, size: 18.0, color: Color(0xFFDC2626)),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                AppointmentsStrings.of(context, 'cancel_cutoff_warning'),
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF991B1B),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Builds optional reason input field when cancellation is permitted.
  Widget _build_reason_input(bool canCancel, bool isDark, BuildContext context) {
    if (canCancel) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: TextField(
              controller: _reasonController,
              maxLines: 2,
              style: TextStyle(
                fontSize: 13.0,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: AppointmentsStrings.of(context, 'cancel_reason_hint'),
                hintStyle: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
                contentPadding: const EdgeInsets.all(12.0),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      );
    } else {
      return const SizedBox(height: 20.0);
    }
  }
}

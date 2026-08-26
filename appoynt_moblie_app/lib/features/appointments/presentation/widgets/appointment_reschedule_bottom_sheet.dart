import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: appointment_reschedule_bottom_sheet.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart, ../../data/repositories/appointments_mock_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Rescheduling workflow modal with date strip picker, dynamic time slots grid, and schedule confirmation.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointments_mock_repository.dart';

/// Modal bottom sheet for choosing a new date and time slot to reschedule an appointment.
class AppointmentRescheduleBottomSheet extends StatefulWidget {
  final AppointmentModel appointment;
  final AppointmentsRepository repository;
  final ValueChanged<DateTime> onConfirm;

  const AppointmentRescheduleBottomSheet({
    super.key,
    required this.appointment,
    required this.repository,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required AppointmentModel appointment,
    required AppointmentsRepository repository,
    required ValueChanged<DateTime> onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => AppointmentRescheduleBottomSheet(
        appointment: appointment,
        repository: repository,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AppointmentRescheduleBottomSheet> createState() => _AppointmentRescheduleBottomSheetState();
}

class _AppointmentRescheduleBottomSheetState extends State<AppointmentRescheduleBottomSheet> {
  late DateTime _selectedDate;
  DateTime? _selectedSlot;
  List<DateTime> _availableSlots = [];
  bool _isLoadingSlots = true;

  final List<DateTime> _upcomingDays = List.generate(
    14,
    (index) => DateTime.now().add(Duration(days: index + 1)),
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = _upcomingDays.first;
    _fetchSlotsForDate(_selectedDate);
  }

  Future<void> _fetchSlotsForDate(DateTime date) async {
    setState(() {
      _isLoadingSlots = true;
      _selectedSlot = null;
    });

    try {
      final slots = await widget.repository.getAvailableRescheduleSlots(
        widget.appointment.doctorId,
        date,
      );
      if (mounted) {
        setState(() {
          _availableSlots = slots;
          _isLoadingSlots = false;
        });
      } else {
        // No action needed
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _availableSlots = [];
          _isLoadingSlots = false;
        });
      } else {
        // No action needed
      }
    }
  }

  String _formatSlotTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String _getDayName(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.slate700 : AppColors.slate300,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppointmentsStrings.of(context, 'reschedule_title'),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.slate900,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: isDark ? AppColors.slate400 : AppColors.slate500,
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Step 1: Date Selector Horizontal Strip
            Text(
              AppointmentsStrings.of(context, 'select_date'),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.slate400 : AppColors.slate600,
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 72.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _upcomingDays.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8.0),
                itemBuilder: (context, index) {
                  final day = _upcomingDays[index];
                  final isSelected = day.year == _selectedDate.year &&
                      day.month == _selectedDate.month &&
                      day.day == _selectedDate.day;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDate = day);
                      _fetchSlotsForDate(day);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 58.0,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.sky600
                            : (isDark ? AppColors.slate800 : AppColors.slate50),
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.sky600
                              : (isDark ? AppColors.slate700 : AppColors.slate200),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(day),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.white70
                                  : (isDark ? AppColors.slate400 : AppColors.slate500),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            day.day.toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.white
                                  : (isDark ? AppColors.white : AppColors.slate900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Step 2: Time Slots Grid
            Text(
              AppointmentsStrings.of(context, 'select_time'),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.slate400 : AppColors.slate600,
              ),
            ),
            const SizedBox(height: 10.0),

            _build_time_slots_section(isDark, context),
            const SizedBox(height: 24.0),

            // Confirmation CTA
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _selectedSlot != null
                    ? () {
                        Navigator.pop(context);
                        widget.onConfirm(_selectedSlot!);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sky600,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: AppColors.sky600.withValues(alpha: 0.3),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                ),
                child: Text(
                  AppointmentsStrings.of(context, 'confirm_reschedule'),
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the time slots grid, loading spinner, or empty state.
  Widget _build_time_slots_section(bool isDark, BuildContext context) {
    if (_isLoadingSlots) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.sky600,
          ),
        ),
      );
    } else if (_availableSlots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : AppColors.slate50,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          AppointmentsStrings.of(context, 'no_slots_available'),
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? AppColors.slate400 : AppColors.slate500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 2.4,
        ),
        itemCount: _availableSlots.length,
        itemBuilder: (context, index) {
          final slot = _availableSlots[index];
          final isSelected = _selectedSlot != null &&
              _selectedSlot!.isAtSameMomentAs(slot);

          return GestureDetector(
            onTap: () => setState(() => _selectedSlot = slot),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.sky600
                    : (isDark ? AppColors.slate800 : AppColors.slate50),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isSelected
                      ? AppColors.sky600
                      : (isDark ? AppColors.slate700 : AppColors.slate200),
                  width: 1.0,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _formatSlotTime(slot),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? AppColors.white
                      : (isDark ? AppColors.white70 : AppColors.slate700),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

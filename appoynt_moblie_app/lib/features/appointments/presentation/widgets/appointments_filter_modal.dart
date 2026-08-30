import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: appointments_filter_modal.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart, ../../data/models/appointment_model.dart, ../../data/models/appointment_filter_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Bottom sheet modal for filtering appointments by date range, specialty, facility, and consultation medium.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../data/models/appointment_filter_model.dart';
import '../../data/models/appointment_model.dart';

/// Bottom sheet modal dialog for configuring appointment filters.
class AppointmentsFilterModal extends StatefulWidget {
  final AppointmentFilter initialFilter;
  final ValueChanged<AppointmentFilter> onApply;

  const AppointmentsFilterModal({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required AppointmentFilter initialFilter,
    required ValueChanged<AppointmentFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => AppointmentsFilterModal(
        initialFilter: initialFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<AppointmentsFilterModal> createState() => _AppointmentsFilterModalState();
}

class _AppointmentsFilterModalState extends State<AppointmentsFilterModal> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedSpecialty;
  String? _selectedClinic;
  AppointmentType? _selectedType;

  final List<String> _specialties = [
    'Cardiology',
    'Dermatology & Cosmetology',
    'Orthopedic Surgery',
    'Pediatrics & Neonatology',
    'Neurology',
    'Ophthalmology',
    'Internal Medicine & Endocrinology',
    'Clinical Nutrition',
  ];

  final List<String> _clinics = [
    'Al-Safwa Specialist Clinic',
    'New Cairo Heart & Vascular Center',
    'Zayed Medical Plaza',
    'Maadi Health Oasis',
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialFilter.startDate;
    _endDate = widget.initialFilter.endDate;
    _selectedSpecialty = widget.initialFilter.specialty;
    _selectedClinic = widget.initialFilter.clinicName;
    _selectedType = widget.initialFilter.type;
  }

  void _resetFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedSpecialty = null;
      _selectedClinic = null;
      _selectedType = null;
    });
  }

  void _applyFilters() {
    final filter = AppointmentFilter(
      startDate: _startDate,
      endDate: _endDate,
      specialty: _selectedSpecialty,
      clinicName: _selectedClinic,
      type: _selectedType,
    );
    widget.onApply(filter);
    Navigator.pop(context);
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    } else {
      // No action needed
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now,
      firstDate: _startDate ?? now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    } else {
      // No action needed
    }
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

            // Header Title & Reset
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppointmentsStrings.of(context, 'filter'),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.slate900,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    AppointmentsStrings.of(context, 'reset'),
                    style: const TextStyle(
                      color: AppColors.sky600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // 1. Consultation Type (In-Clinic / Online Video)
            Text(
              AppointmentsStrings.of(context, 'filter_by_type'),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.slate400 : AppColors.slate600,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildTypeChoice(
                    context,
                    label: AppointmentsStrings.of(context, 'in_clinic'),
                    icon: Icons.local_hospital_outlined,
                    isSelected: _selectedType == AppointmentType.inClinic,
                    onTap: () {
                      setState(() {
                        _selectedType = _selectedType == AppointmentType.inClinic
                            ? null
                            : AppointmentType.inClinic;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: _buildTypeChoice(
                    context,
                    label: AppointmentsStrings.of(context, 'online_video'),
                    icon: Icons.videocam_outlined,
                    isSelected: _selectedType == AppointmentType.onlineVideo,
                    onTap: () {
                      setState(() {
                        _selectedType = _selectedType == AppointmentType.onlineVideo
                            ? null
                            : AppointmentType.onlineVideo;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // 2. Date Range
            Text(
              AppointmentsStrings.of(context, 'filter_by_date'),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.slate400 : AppColors.slate600,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: _buildDateButton(
                    context,
                    label: _startDate != null
                        ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                        : AppointmentsStrings.of(context, 'start_date'),
                    onTap: _pickStartDate,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: _buildDateButton(
                    context,
                    label: _endDate != null
                        ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                        : AppointmentsStrings.of(context, 'end_date'),
                    onTap: _pickEndDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // 3. Specialty
            Text(
              AppointmentsStrings.of(context, 'filter_by_specialty'),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.slate400 : AppColors.slate600,
              ),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _specialties.map((spec) {
                final isSelected = _selectedSpecialty == spec;
                return ChoiceChip(
                  label: Text(spec),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedSpecialty = selected ? spec : null;
                    });
                  },
                  selectedColor: AppColors.sky600.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppColors.sky600
                        : (isDark ? AppColors.white70 : AppColors.slate700),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),

            // 4. Clinic / Facility
            Text(
              AppointmentsStrings.of(context, 'filter_by_clinic'),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.slate400 : AppColors.slate600,
              ),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _clinics.map((clinic) {
                final isSelected = _selectedClinic == clinic;
                return ChoiceChip(
                  label: Text(clinic),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedClinic = selected ? clinic : null;
                    });
                  },
                  selectedColor: AppColors.sky600.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    fontSize: 12.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppColors.sky600
                        : (isDark ? AppColors.white70 : AppColors.slate700),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24.0),

            // Apply Button CTA
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sky600,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppointmentsStrings.of(context, 'apply_filter'),
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
    );
  }

  Widget _buildTypeChoice(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.sky600.withValues(alpha: 0.12)
              : (isDark ? AppColors.slate800 : AppColors.slate50),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? AppColors.sky600
                : (isDark ? AppColors.slate700 : AppColors.slate200),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.0,
              color: isSelected
                  ? AppColors.sky600
                  : (isDark ? AppColors.slate400 : AppColors.slate500),
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? AppColors.sky600
                    : (isDark ? AppColors.white70 : AppColors.slate700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : AppColors.slate50,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isDark ? AppColors.slate700 : AppColors.slate200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 16.0, color: AppColors.sky600),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? AppColors.white70 : AppColors.slate700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

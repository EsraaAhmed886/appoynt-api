/*
 * File Name: appointment_doctor_avatar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Rectangular portrait container for doctor headshot rendering with fallback initials and soft elevation.
 */

import 'package:flutter/material.dart';

/// Rectangular doctor portrait avatar container (92x106) with rounded corners and initials fallback.
class AppointmentDoctorAvatar extends StatelessWidget {
  final String? imageUrl;
  final String doctorName;
  final double width;
  final double height;

  const AppointmentDoctorAvatar({
    super.key,
    this.imageUrl,
    required this.doctorName,
    this.width = 92.0,
    this.height = 106.0,
  });

  String _getInitials(String name) {
    final clean = name.replaceAll('Dr.', '').trim();
    final parts = clean.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'DR';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final isAsset = hasImage && imageUrl!.startsWith('assets/');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: hasImage
            ? (isAsset
                ? Image.asset(
                    imageUrl!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => _buildFallback(isDark),
                  )
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => _buildFallback(isDark),
                  ))
            : _buildFallback(isDark),
      ),
    );
  }

  Widget _buildFallback(bool isDark) {
    return Container(
      color: const Color(0xFF0284C7).withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_rounded,
            color: Color(0xFF0284C7),
            size: 32.0,
          ),
          const SizedBox(height: 2.0),
          Text(
            _getInitials(doctorName),
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0284C7),
            ),
          ),
        ],
      ),
    );
  }
}

/*
 * File Name: floating_input_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 24/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Reusable floating input card widget with icon and styled container.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/constants/app_spacing.dart';

/// A widget that provides a white background container with rounded corners and a subtle border.
/// It embeds an [AuthTextField] and displays a leading [iconData] inside the container.
class FloatingInputCard extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? iconData;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isPhone;
  final bool isNationalId;

  const FloatingInputCard({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.iconData,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.isPhone = false,
    this.isNationalId = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radius_l),
        border: Border.all(
          color: AppColors.slate_200,
          width: AppSpacing.border_width_thin,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_l,
        vertical: AppSpacing.space_m,
      ),
      child: Row(
        children: [
          if (iconData != null)
            Icon(iconData, color: isDark ? AppColors.icon_dark : AppColors.icon_light),
          Expanded(
            child: AuthTextField(
              label: label,
              hint: hint,
              controller: controller,
              validator: validator,
              keyboard_type: keyboardType,
              input_formatters: inputFormatters,
              enabled: enabled,
              is_phone: isPhone,
              is_national_id: isNationalId,
            ),
          ),
        ],
      ),
    );
  }
}

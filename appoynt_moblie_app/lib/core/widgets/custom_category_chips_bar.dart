/*
 * File Name: custom_category_chips_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Unified reusable horizontal category filter chips component with symmetric RTL-safe spacing, smooth active state animation, and theme adaptability matching Appointments and Notifications design specifications.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

/// Reusable horizontal category filter chips component matching design system specifications.
class CustomCategoryChipsBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final EdgeInsetsGeometry padding;
  final bool isFullWidth;
  final double spacing;

  const CustomCategoryChipsBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.isFullWidth = true,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    if (true == isFullWidth) {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            for (int i = 0; i < categories.length; i++) ...[
              0 < i ? SizedBox(width: spacing) : const SizedBox.shrink(),
              Expanded(
                child: _buildChip(
                  context: context,
                  index: i,
                  label: categories[i],
                  isSelected: selectedIndex == i,
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: padding,
        child: Row(
          children: [
            for (int i = 0; i < categories.length; i++) ...[
              0 < i ? SizedBox(width: spacing) : const SizedBox.shrink(),
              _buildChip(
                context: context,
                index: i,
                label: categories[i],
                isSelected: selectedIndex == i,
              ),
            ],
          ],
        ),
      );
    }
  }

  Widget _buildChip({
    required BuildContext context,
    required int index,
    required String label,
    required bool isSelected,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () {
            onCategorySelected(index);
          },
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 9.0,
              horizontal: 8.0,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: true == isSelected
                  ? AppColors.sky600
                  : (isDark ? AppColors.slate800 : AppColors.slate100),
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: true == isSelected
                    ? AppColors.sky600
                    : (isDark ? AppColors.slate700 : AppColors.slate200),
                width: 1.0,
              ),
              boxShadow: true == isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.sky600.withValues(alpha: 0.25),
                        blurRadius: 8.0,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: true == isSelected
                    ? FontWeight.bold
                    : FontWeight.w600,
                color: true == isSelected
                    ? AppColors.white
                    : (isDark
                        ? AppColors.slate400
                        : AppColors.slate500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

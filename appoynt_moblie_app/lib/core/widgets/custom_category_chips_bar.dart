/*
 * File Name: custom_category_chips_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Unified reusable horizontal category filter chips component with responsive styling, smooth active state animation, and theme adaptability matching Appointments and Notifications design specifications.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

/// Reusable horizontal category filter chips component matching design system specifications.
class CustomCategoryChipsBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final EdgeInsetsGeometry? padding;
  final bool isFullWidth;

  const CustomCategoryChipsBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    this.padding,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (true == isFullWidth) {
      return Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: List.generate(categories.length, (index) {
            final bool isSelected = selectedIndex == index;
            final bool isLast = index == categories.length - 1;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: true == isLast ? 0.0 : 8.0),
                child: AnimatedContainer(
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
                          horizontal: 4.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.sky600
                              : (isDark
                                  ? AppColors.slate800
                                  : AppColors.slate100),
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.sky600
                                : (isDark
                                    ? AppColors.slate700
                                    : AppColors.slate200),
                            width: 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.sky600
                                        .withValues(alpha: 0.25),
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          categories[index],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected
                                ? AppColors.white
                                : (isDark
                                    ? AppColors.slate400
                                    : AppColors.slate500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: List.generate(categories.length, (index) {
            final bool isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AnimatedContainer(
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
                        horizontal: 16.0,
                        vertical: 9.0,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.sky600
                            : (isDark
                                ? AppColors.slate800
                                : AppColors.slate100),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.sky600
                              : (isDark
                                  ? AppColors.slate700
                                  : AppColors.slate200),
                          width: 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.sky600.withValues(alpha: 0.25),
                                  blurRadius: 8.0,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? AppColors.white
                              : (isDark
                                  ? AppColors.slate400
                                  : AppColors.slate500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }
  }
}

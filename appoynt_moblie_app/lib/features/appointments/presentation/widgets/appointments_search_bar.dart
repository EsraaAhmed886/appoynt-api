import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
/*
 * File Name: appointments_search_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/material.dart, ../../../../core/localization/appointments_strings.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Reusable search input field with debounced query controller and filter modal trigger with active badge count.
 */

import 'package:flutter/material.dart';
import '../../../../core/localization/appointments_strings.dart';

/// Search and filter bar for appointments filtering.
class AppointmentsSearchBar extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFilterTap;
  final int activeFiltersCount;

  const AppointmentsSearchBar({
    super.key,
    required this.initialQuery,
    required this.onQueryChanged,
    required this.onFilterTap,
    this.activeFiltersCount = 0,
  });

  @override
  State<AppointmentsSearchBar> createState() => _AppointmentsSearchBarState();
}

class _AppointmentsSearchBarState extends State<AppointmentsSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant AppointmentsSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery && widget.initialQuery != _controller.text) {
      _controller.text = widget.initialQuery;
    } else {
      // No action needed
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        children: [
          // Search Input Container
          Expanded(
            child: Container(
              height: 46.0,
              decoration: BoxDecoration(
                color: isDark ? AppColors.slate800 : AppColors.slate50,
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(
                  color: isDark ? AppColors.slate700 : AppColors.slate200,
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: _controller,
                onChanged: widget.onQueryChanged,
                style: TextStyle(
                  fontSize: 14.0,
                  color: isDark ? AppColors.white : AppColors.slate900,
                ),
                decoration: InputDecoration(
                  hintText: AppointmentsStrings.of(context, 'search_placeholder'),
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? AppColors.slate500 : AppColors.slate400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20.0,
                    color: isDark ? AppColors.slate500 : AppColors.slate400,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18.0),
                          color: isDark ? AppColors.slate500 : AppColors.slate400,
                          onPressed: () {
                            _controller.clear();
                            widget.onQueryChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),

          // Filter Button with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46.0,
                height: 46.0,
                decoration: BoxDecoration(
                  color: widget.activeFiltersCount > 0
                      ? AppColors.sky600
                      : (isDark ? AppColors.slate800 : AppColors.slate50),
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: widget.activeFiltersCount > 0
                        ? AppColors.sky600
                        : (isDark ? AppColors.slate700 : AppColors.slate200),
                    width: 1.0,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.tune_rounded,
                    size: 20.0,
                    color: widget.activeFiltersCount > 0
                        ? AppColors.white
                        : (isDark ? AppColors.slate400 : AppColors.slate600),
                  ),
                  onPressed: widget.onFilterTap,
                  padding: EdgeInsets.zero,
                ),
              ),
              _build_filter_badge(),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the badge counter on top of the filter icon.
  Widget _build_filter_badge() {
    if (widget.activeFiltersCount > 0) {
      return Positioned(
        top: -3,
        right: -3,
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: const BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
          constraints: const BoxConstraints(minWidth: 16.0, minHeight: 16.0),
          child: Center(
            child: Text(
              widget.activeFiltersCount.toString(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 9.0,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

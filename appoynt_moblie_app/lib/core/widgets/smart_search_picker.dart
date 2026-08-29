/*
 * File Name: smart_search_picker.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.0.0
 * Dependencies: dart:ui, package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Sleek reusable floating search modal picker dialog with backdrop blur,
 *   instant query filtering, and animated transition for selection datasets.
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

/// Displays a sleek, floating searchable modal picker with backdrop blur and smooth entrance.
Future<T?> showSmartSearchPicker<T>({
  required BuildContext context,
  required String title,
  required String searchHint,
  required List<T> items,
  required String Function(T item) itemLabel,
  required T? selectedItem,
}) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final bool isAr = Localizations.localeOf(context).languageCode == 'ar';

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: AppColors.slate900.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 220),
    transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4.0 * animation.value,
          sigmaY: 4.0 * animation.value,
        ),
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );
    },
    pageBuilder: (dialogContext, anim1, anim2) {
      return _SmartSearchDialog<T>(
        title: title,
        searchHint: searchHint,
        items: items,
        itemLabel: itemLabel,
        selectedItem: selectedItem,
        isDark: isDark,
        isAr: isAr,
      );
    },
  );
}

class _SmartSearchDialog<T> extends StatefulWidget {
  final String title;
  final String searchHint;
  final List<T> items;
  final String Function(T item) itemLabel;
  final T? selectedItem;
  final bool isDark;
  final bool isAr;

  const _SmartSearchDialog({
    required this.title,
    required this.searchHint,
    required this.items,
    required this.itemLabel,
    required this.selectedItem,
    required this.isDark,
    required this.isAr,
  });

  @override
  State<_SmartSearchDialog<T>> createState() => _SmartSearchDialogState<T>();
}

class _SmartSearchDialogState<T> extends State<_SmartSearchDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final String query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final String label = widget.itemLabel(item).toLowerCase();
          return label.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBg =
        widget.isDark ? AppColors.darkSurface : AppColors.white;
    final Color borderColor =
        widget.isDark ? AppColors.darkBorder : AppColors.slate200;

    return Dialog(
      backgroundColor: cardBg,
      elevation: 10,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
        side: BorderSide(color: borderColor, width: 1.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Title & Close Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 18.0, 12.0, 12.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: widget.isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.slate900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: widget.isDark
                          ? AppColors.darkTextMuted
                          : AppColors.slate400,
                      size: 22.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 44.0,
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? AppColors.darkBackground
                      : AppColors.slate100,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: widget.isDark
                        ? AppColors.darkBorder
                        : AppColors.slate200,
                    width: 0.8,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: widget.isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.slate900,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: TextStyle(
                      fontSize: 13.0,
                      color: widget.isDark
                          ? AppColors.darkTextMuted
                          : AppColors.slate400,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20.0,
                      color: widget.isDark
                          ? AppColors.darkTextMuted
                          : AppColors.slate400,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                            },
                            child: const Icon(
                              Icons.cancel_rounded,
                              size: 18.0,
                              color: AppColors.slate400,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Divider(height: 1.0, color: borderColor),

            // List of Items
            Flexible(
              child: _filteredItems.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        widget.isAr
                            ? 'لا توجد نتائج مطابقة'
                            : 'No results found',
                        style: TextStyle(
                          color: widget.isDark
                              ? AppColors.darkTextMuted
                              : AppColors.slate500,
                          fontSize: 14.0,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      itemCount: _filteredItems.length,
                      itemBuilder: (itemContext, index) {
                        final item = _filteredItems[index];
                        final bool isSelected = widget.selectedItem == item;
                        final String label = widget.itemLabel(item);

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 2.5),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(
                                    alpha: widget.isDark ? 0.2 : 0.08)
                                : AppColors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 2.0),
                            title: Text(
                              label,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : (widget.isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.slate800),
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                    size: 19.0,
                                  )
                                : null,
                            onTap: () {
                              Navigator.of(context).pop(item);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

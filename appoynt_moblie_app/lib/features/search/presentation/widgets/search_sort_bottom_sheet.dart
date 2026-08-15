/*
 * File Name: search_sort_bottom_sheet.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, search_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Defines the unified Search sort bottom sheet modal matching
 *   the exact visual design, radio option cards, icon badges, and apply interaction
 *   established in FavoriteSortBottomSheet.
 */

// Import standard Flutter material design framework
import 'package:flutter/material.dart';
// Import layout spacing tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import SearchSortOption enumeration
import 'package:appoynt_mobile_app/features/search/presentation/cubit/search_state.dart';

// Local layout dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  // Drag handle bar width (40px)
  static const double handle_width = 40.0;
  // Drag handle bar height (4px)
  static const double handle_height = 4.0;
  // Drag handle border radius (2px)
  static const double handle_radius = 2.0;
  // Icon badge container dimensions (36px)
  static const double icon_badge_size = 36.0;
  // Icon badge border radius (10px)
  static const double icon_badge_radius = 10.0;
  // Icon vector size (20px)
  static const double icon_size = 20.0;
  // Option item border radius (12px)
  static const double option_radius = 12.0;
  // Option item vertical padding (10px)
  static const double option_padding_v = 10.0;
  // Option item horizontal padding (12px)
  static const double option_padding_h = 12.0;
  // Option items vertical spacing gap (8px)
  static const double option_gap = 8.0;
  // Apply CTA button height (48px)
  static const double cta_height = 48.0;
  // Apply CTA button border radius (12px)
  static const double cta_radius = 12.0;
  // Top sheet radius token (24px)
  static const double sheet_top_radius = 24.0;
}

// SearchSortBottomSheet modal stateful widget representation
class SearchSortBottomSheet extends StatefulWidget {
  // Currently active sorting option in search state
  final SearchSortOption initial_sort;
  // Callback when user taps Apply button with selected sort option
  final ValueChanged<SearchSortOption> on_apply;

  // Constructor mapping required parameters
  const SearchSortBottomSheet({
    super.key,
    required this.initial_sort,
    required this.on_apply,
  });

  @override
  // Create mutable state instance
  State<SearchSortBottomSheet> createState() {
    return _SearchSortBottomSheetState();
  }
}

// Mutable state managing temporary selected sorting option before applying
class _SearchSortBottomSheetState extends State<SearchSortBottomSheet> {
  // Track selected sort option in sheet state
  late SearchSortOption _selected_sort;

  @override
  // Initialize state binding initial sort parameter
  void initState() {
    super.initState();
    _selected_sort = widget.initial_sort;
  }

  // Returns list of all applicable sort options for Search
  List<SearchSortOption> _get_sort_options() {
    return const [
      SearchSortOption.recentlyAdded,
      SearchSortOption.nameAToZ,
      SearchSortOption.nameZToA,
      SearchSortOption.ratingHighToLow,
      SearchSortOption.feeLowToHigh,
      SearchSortOption.feeHighToLow,
    ];
  }

  // Returns icon associated with each SearchSortOption
  IconData _get_option_icon(SearchSortOption option) {
    switch (option) {
      case SearchSortOption.recentlyAdded:
        return Icons.access_time_rounded;
      case SearchSortOption.nameAToZ:
        return Icons.sort_by_alpha_rounded;
      case SearchSortOption.nameZToA:
        return Icons.sort_by_alpha_rounded;
      case SearchSortOption.ratingHighToLow:
        return Icons.star_rounded;
      case SearchSortOption.feeLowToHigh:
        return Icons.arrow_downward_rounded;
      case SearchSortOption.feeHighToLow:
        return Icons.arrow_upward_rounded;
    }
  }

  // Returns localized title string associated with each SearchSortOption
  String _get_option_title(
    SearchSortOption option,
    AppLocalizations localizations,
  ) {
    switch (option) {
      case SearchSortOption.recentlyAdded:
        return localizations.search_sort_recently_added;
      case SearchSortOption.nameAToZ:
        return localizations.search_sort_name_a_to_z;
      case SearchSortOption.nameZToA:
        return localizations.search_sort_name_z_to_a;
      case SearchSortOption.ratingHighToLow:
        return localizations.search_sort_rating_high_to_low;
      case SearchSortOption.feeLowToHigh:
        return localizations.search_sort_fee_low_to_high;
      case SearchSortOption.feeHighToLow:
        return localizations.search_sort_fee_high_to_low;
    }
  }

  // Returns localized subtitle description associated with each SearchSortOption
  String _get_option_desc(
    SearchSortOption option,
    AppLocalizations localizations,
  ) {
    switch (option) {
      case SearchSortOption.recentlyAdded:
        return localizations.search_sort_recently_added_desc;
      case SearchSortOption.nameAToZ:
        return localizations.search_sort_name_a_to_z_desc;
      case SearchSortOption.nameZToA:
        return localizations.search_sort_name_z_to_a_desc;
      case SearchSortOption.ratingHighToLow:
        return localizations.search_sort_rating_high_to_low_desc;
      case SearchSortOption.feeLowToHigh:
        return localizations.search_sort_fee_low_to_high_desc;
      case SearchSortOption.feeHighToLow:
        return localizations.search_sort_fee_high_to_low_desc;
    }
  }

  @override
  // Build method constructing modal layout
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final List<SearchSortOption> options = _get_sort_options();

    return Container(
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_LocalDimensions.sheet_top_radius),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space_xl,
            vertical: AppSpacing.space_m,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sheet drag handle indicator bar
              Center(
                child: Container(
                  width: _LocalDimensions.handle_width,
                  height: _LocalDimensions.handle_height,
                  decoration: BoxDecoration(
                    color: is_dark
                        ? AppColors.text_dark_secondary
                        : AppColors.grey_300,
                    borderRadius:
                        BorderRadius.circular(_LocalDimensions.handle_radius),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space_m),
              // Header title: "Sort By"
              Text(
                localizations.search_sort_title,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_dialog_title,
                  fontWeight: FontWeight.bold,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_m),
              // Render sorting options list
              ...options.map((option) {
                final bool is_selected = option == _selected_sort;
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: _LocalDimensions.option_gap,
                  ),
                  child: _build_option_tile(
                    option: option,
                    is_selected: is_selected,
                    localizations: localizations,
                    is_dark: is_dark,
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.space_m),
              // Full-width "Apply" CTA button
              SizedBox(
                height: _LocalDimensions.cta_height,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.on_apply(_selected_sort);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(_LocalDimensions.cta_radius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    localizations.search_filter_apply,
                    style: const TextStyle(
                      fontSize: AppSpacing.font_size_body_medium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space_s),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder constructing styled radio option card item
  Widget _build_option_tile({
    required SearchSortOption option,
    required bool is_selected,
    required AppLocalizations localizations,
    required bool is_dark,
  }) {
    final IconData icon = _get_option_icon(option);
    final String title = _get_option_title(option, localizations);
    final String desc = _get_option_desc(option, localizations);

    return Material(
      color: is_selected
          ? (is_dark
              ? AppColors.primary_color.withValues(alpha: 0.18)
              : AppColors.primary_color.withValues(alpha: 0.08))
          : (is_dark ? const Color(0xFF252536) : const Color(0xFFF8FAFC)),
      borderRadius: BorderRadius.circular(_LocalDimensions.option_radius),
      child: InkWell(
        onTap: () {
          setState(() {
            _selected_sort = option;
          });
        },
        borderRadius: BorderRadius.circular(_LocalDimensions.option_radius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_LocalDimensions.option_radius),
            border: Border.all(
              color: is_selected
                  ? AppColors.primary_color
                  : (is_dark ? AppColors.border_dark : AppColors.border_light),
              width: is_selected ? 1.5 : 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: _LocalDimensions.option_padding_h,
            vertical: _LocalDimensions.option_padding_v,
          ),
          child: Row(
            children: [
              Container(
                width: _LocalDimensions.icon_badge_size,
                height: _LocalDimensions.icon_badge_size,
                decoration: BoxDecoration(
                  color: is_selected
                      ? AppColors.primary_color
                      : (is_dark
                          ? AppColors.primary_color.withValues(alpha: 0.15)
                          : AppColors.primary_color.withValues(alpha: 0.08)),
                  borderRadius: BorderRadius.circular(
                    _LocalDimensions.icon_badge_radius,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color:
                        is_selected ? AppColors.white : AppColors.primary_color,
                    size: _LocalDimensions.icon_size,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_medium,
                        fontWeight:
                            is_selected ? FontWeight.bold : FontWeight.w600,
                        color: is_selected
                            ? (is_dark
                                ? AppColors.white
                                : AppColors.primary_color)
                            : (is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space_xs),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_small,
                        color: is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                is_selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: is_selected
                    ? AppColors.primary_color
                    : (is_dark
                        ? AppColors.text_dark_secondary
                        : AppColors.text_light_secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Global helper function presenting the SearchSortBottomSheet modal
Future<void> show_search_sort_bottom_sheet({
  required BuildContext context,
  required SearchSortOption current_sort,
  required ValueChanged<SearchSortOption> on_apply,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(_LocalDimensions.sheet_top_radius),
      ),
    ),
    builder: (modal_context) {
      return SearchSortBottomSheet(
        initial_sort: current_sort,
        on_apply: on_apply,
      );
    },
  );
}

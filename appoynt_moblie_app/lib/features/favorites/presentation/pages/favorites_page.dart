/*
 * File Name: favorites_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/features/shared/widgets/doctor_card.dart,
 *   package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_cubit.dart,
 *   package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_state.dart,
 *   package:appoynt_mobile_app/features/favorites/presentation/widgets/empty_favorites_widget.dart,
 *   package:appoynt_mobile_app/features/favorites/presentation/widgets/favorite_sort_bottom_sheet.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Defines the Favorites Screen displaying saved doctors, real-time search,
 *   sort bottom sheet triggers, centered headers, and empty state handling.
 */

// Import standard material design widget library
import 'package:flutter/material.dart';
// Import BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import reusable DoctorCard component from shared module
import 'package:appoynt_mobile_app/features/shared/widgets/doctor_card.dart';
// Import FavoritesCubit controller
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_cubit.dart';
// Import FavoritesState and FavoriteSortOption definitions
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_state.dart';
// Import EmptyFavoritesWidget component
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/empty_favorites_widget.dart';
// Import FavoriteSortBottomSheet helper
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/favorite_sort_bottom_sheet.dart';

// Local layout dimension constants eliminating raw numbers
class _LocalDimensions {
  // Search bar corner border radius (14px)
  static const double search_bar_radius = 14.0;
  // Search bar internal height (48px)
  static const double search_bar_height = 48.0;
  // Sort trigger chip border radius (10px)
  static const double sort_chip_radius = 10.0;
  // Sort trigger chip internal horizontal padding (10px)
  static const double sort_chip_padding_h = 10.0;
  // Sort trigger chip internal vertical padding (6px)
  static const double sort_chip_padding_v = 6.0;
  // Search field prefix search icon size (20px)
  static const double search_icon_size = 20.0;
  // Clear button icon size (18px)
  static const double clear_icon_size = 18.0;
}

// Favorites screen stateful widget
class FavoritesPage extends StatefulWidget {
  // Constant constructor
  const FavoritesPage({super.key});

  @override
  // Create mutable state instance
  State<FavoritesPage> createState() {
    return _FavoritesPageState();
  }
}

// Concrete state for FavoritesPage managing search controller and layout
class _FavoritesPageState extends State<FavoritesPage> {
  // TextEditingController for real-time search input
  late TextEditingController _search_controller;

  @override
  // Initialize state and setup search controller listener
  void initState() {
    super.initState();
    _search_controller = TextEditingController();
  }

  @override
  // Dispose search controller resources on widget unmount
  void dispose() {
    _search_controller.dispose();
    super.dispose();
  }

  // Returns short display text for current sort option trigger button
  String _get_sort_trigger_label(
    FavoriteSortOption sort,
    AppLocalizations localizations,
  ) {
    switch (sort) {
      case FavoriteSortOption.recently_added:
        return localizations.favorites_sort_recently_added;
      case FavoriteSortOption.name_a_z:
        return 'A-Z';
      case FavoriteSortOption.name_z_a:
        return 'Z-A';
      case FavoriteSortOption.rating_high_low:
        return localizations.favorites_sort_rating_high_low;
      case FavoriteSortOption.price_low_high:
        return localizations.favorites_sort_price_low_high;
      case FavoriteSortOption.price_high_low:
        return localizations.favorites_sort_price_high_low;
    }
  }

  @override
  // Build method constructing Favorites screen UI hierarchy
  Widget build(BuildContext context) {
    // Resolve localization dictionary
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve active theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Wrap in BlocProvider ensuring FavoritesCubit instance availability
    return BlocProvider<FavoritesCubit>(
      create: (cubit_context) => FavoritesCubit(),
      child: SafeArea(
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (bloc_context, state) {
            // Check if master favorites list is completely empty
            final bool is_master_empty = state.all_favorites.isEmpty;
            // Check if filtered search/sort results are empty
            final bool is_filtered_empty = state.filtered_favorites.isEmpty;

            // Render Centered Empty State when master list or filter yields 0 items
            if (is_master_empty || is_filtered_empty) {
              return Column(
                children: [
                  // Top Header Title and Subtitle (Centered)
                  _build_header(localizations, is_dark),
                  // If filter is active but master list has items, keep search bar
                  if (!is_master_empty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space_xl,
                      ),
                      child: _build_search_field(
                        bloc_context,
                        localizations,
                        is_dark,
                      ),
                    ),
                  // Centered Empty Favorites Illustration and message
                  const Expanded(
                    child: EmptyFavoritesWidget(),
                  ),
                ],
              );
            }

            // Active favorites layout displaying search, count, sort, and list
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Top Header (Title & Subtitle Centered)
                _build_header(localizations, is_dark),
                // Section 2: Real-time Search Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xl,
                  ),
                  child: _build_search_field(
                    bloc_context,
                    localizations,
                    is_dark,
                  ),
                ),
                const SizedBox(height: AppSpacing.space_m),
                // Section 3: Count & Sort Trigger Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xl,
                  ),
                  child: _build_count_and_sort_row(
                    bloc_context,
                    state,
                    localizations,
                    is_dark,
                  ),
                ),
                const SizedBox(height: AppSpacing.space_m),
                // Section 4: Scrollable Favorites Doctor Cards List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                    ),
                    itemCount: state.filtered_favorites.length,
                    itemBuilder: (list_context, index) {
                      final doc = state.filtered_favorites[index];
                      return DoctorCard(
                        doctor_name: doc.name,
                        specialization: doc.specialty,
                        location: doc.location,
                        rating: doc.rating,
                        review_count: doc.reviews_count,
                        price: doc.fee,
                        is_available: doc.is_available_today,
                        is_favorite: doc.is_favorite,
                        avatar_url: doc.avatar_url,
                        on_book_tap: () {
                          // Booking action feedback SnackBar
                          ScaffoldMessenger.of(list_context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Booking appointment with ${doc.name}...',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        on_favorite_tap: () {
                          // Dynamically remove doctor from favorited list
                          bloc_context
                              .read<FavoritesCubit>()
                              .toggle_favorite(doc.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Header Title ("Favorites") and Subtitle ("Your favorite doctors") builder centered
  Widget _build_header(AppLocalizations localizations, bool is_dark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Title Text (Centered)
            Text(
              localizations.favorites_title,
              style: TextStyle(
                fontSize: AppSpacing.font_size_title,
                fontWeight: FontWeight.bold,
                color: is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.text_light_primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space_xs),
            // Header Subtitle Text (Centered)
            Text(
              localizations.favorites_subtitle,
              style: TextStyle(
                fontSize: AppSpacing.font_size_body_medium,
                color: is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Search Input Field builder with real-time Cubit dispatch and clear button
  Widget _build_search_field(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    return Container(
      height: _LocalDimensions.search_bar_height,
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.surface_light,
        borderRadius:
            BorderRadius.circular(_LocalDimensions.search_bar_radius),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.border_light,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_m),
      child: Row(
        children: [
          // Search prefix magnifying glass icon
          Icon(
            Icons.search_rounded,
            color: is_dark
                ? AppColors.text_dark_secondary
                : AppColors.text_light_secondary,
            size: _LocalDimensions.search_icon_size,
          ),
          const SizedBox(width: AppSpacing.space_s),
          // Expanded TextField for input entry
          Expanded(
            child: TextField(
              controller: _search_controller,
              onChanged: (query) {
                // Dispatch real-time search filter to Cubit
                context.read<FavoritesCubit>().search_favorites(query);
                setState(() {});
              },
              style: TextStyle(
                fontSize: AppSpacing.font_size_body_medium,
                color: is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.text_light_primary,
              ),
              decoration: InputDecoration(
                hintText: localizations.favorites_search_hint,
                hintStyle: TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // Clear button visible when search text is non-empty
          if (_search_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _search_controller.clear();
                context.read<FavoritesCubit>().search_favorites('');
                setState(() {});
              },
              child: Icon(
                Icons.close_rounded,
                color: is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary,
                size: _LocalDimensions.clear_icon_size,
              ),
            ),
        ],
      ),
    );
  }

  // Doctor Count & Sort Trigger Row builder
  Widget _build_count_and_sort_row(
    BuildContext context,
    FavoritesState state,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Total count of filtered favorited doctors
    final int count = state.filtered_favorites.length;
    // Formatted count label string
    final String count_label = 1 == count
        ? localizations.favorites_count_single
        : localizations.favorites_count_plural(count);
    // Sort label for trigger chip
    final String sort_label =
        _get_sort_trigger_label(state.selected_sort, localizations);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Side: Total favorited doctor count label
        Text(
          count_label,
          style: TextStyle(
            fontSize: AppSpacing.font_size_body_medium,
            fontWeight: FontWeight.bold,
            color: is_dark
                ? AppColors.text_dark_primary
                : AppColors.text_light_primary,
          ),
        ),
        // Right Side: Clickable "Sort by: [Selected Option]" trigger chip
        InkWell(
          onTap: () {
            // Open FavoriteSortBottomSheet modal
            show_favorite_sort_bottom_sheet(
              context: context,
              current_sort: state.selected_sort,
              on_apply: (new_sort) {
                context.read<FavoritesCubit>().sort_favorites(new_sort);
              },
            );
          },
          borderRadius:
              BorderRadius.circular(_LocalDimensions.sort_chip_radius),
          child: Container(
            decoration: BoxDecoration(
              color: is_dark
                  ? AppColors.primary_color.withValues(alpha: 0.15)
                  : AppColors.primary_color.withValues(alpha: 0.08),
              borderRadius:
                  BorderRadius.circular(_LocalDimensions.sort_chip_radius),
              border: Border.all(
                color: AppColors.primary_color.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: _LocalDimensions.sort_chip_padding_h,
              vertical: _LocalDimensions.sort_chip_padding_v,
            ),
            child: Row(
              children: [
                // Sort icon
                const Icon(
                  Icons.swap_vert_rounded,
                  color: AppColors.primary_color,
                  size: 16.0,
                ),
                const SizedBox(width: 4.0),
                // Sort trigger text label
                Text(
                  '${localizations.favorites_sort_by}: $sort_label',
                  style: const TextStyle(
                    fontSize: AppSpacing.font_size_body_small,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary_color,
                  ),
                ),
                const SizedBox(width: 2.0),
                // Dropdown arrow indicator icon
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary_color,
                  size: 16.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

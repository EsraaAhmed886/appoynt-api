/*
 * File Name: favorites_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   app_localizations.dart, app_spacing.dart, app_colors.dart,
 *   service_locator.dart, favorites_cubit.dart, favorites_state.dart,
 *   doctor_favorite_tab.dart, offer_favorite_tab.dart, clinic_favorite_tab.dart,
 *   guest_favorites_widget.dart, favorite_sort_bottom_sheet.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Main Favorites Screen featuring 3 category tabs (Doctors,
 *   Offers, Clinics), guest session guard, debounced search bar, category-aware
 *   sorting modal, and tab-specific list rendering.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import service locator to resolve FavoritesCubit
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Import cubit and state
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_state.dart';
// Import tab content widgets
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/doctor_favorite_tab.dart';
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/offer_favorite_tab.dart';
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/clinic_favorite_tab.dart';
// Import guest guard widget
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/guest_favorites_widget.dart';
// Import sorting bottom sheet helper
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/favorite_sort_bottom_sheet.dart';

// Local layout dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double search_bar_radius = 14.0;
  static const double search_bar_height = 48.0;
  static const double sort_chip_radius = 10.0;
  static const double sort_chip_padding_h = 10.0;
  static const double sort_chip_padding_v = 6.0;
  static const double search_icon_size = 20.0;
  static const double clear_icon_size = 18.0;
  static const double tab_segment_height = 44.0;
  static const double tab_segment_radius = 12.0;
  static const double tab_item_radius = 10.0;
}

// Favorites screen stateful widget
class FavoritesPage extends StatefulWidget {
  // Constant constructor
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() {
    return _FavoritesPageState();
  }
}

// Concrete state for FavoritesPage managing search controller and layout
class _FavoritesPageState extends State<FavoritesPage> {
  // TextEditingController for real-time search input
  late final TextEditingController _search_controller;

  @override
  void initState() {
    super.initState();
    _search_controller = TextEditingController();
  }

  @override
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
      case FavoriteSortOption.discount_high_low:
        return localizations.favorites_sort_discount_high_low;
      default:
        return localizations.favorites_sort_recently_added;
    }
  }

  // Returns localized search field hint based on active category
  String _get_search_hint(
    FavoriteCategory category,
    AppLocalizations localizations,
  ) {
    switch (category) {
      case FavoriteCategory.doctors:
        return localizations.favorites_search_doctors_hint;
      case FavoriteCategory.offers:
        return localizations.favorites_search_offers_hint;
      case FavoriteCategory.clinics:
        return localizations.favorites_search_clinics_hint;
      default:
        return localizations.favorites_search_doctors_hint;
    }
  }

  // Returns active items count label
  String _get_items_count_label(
    FavoritesState state,
    AppLocalizations localizations,
  ) {
    switch (state.active_category) {
      case FavoriteCategory.doctors:
        final int count = state.filtered_doctors.length;
        return (1 == count)
            ? localizations.favorites_count_single
            : localizations.favorites_count_plural(count);
      case FavoriteCategory.offers:
        final int count = state.filtered_offers.length;
        return '$count ${localizations.favorites_tab_offers}';
      case FavoriteCategory.clinics:
        final int count = state.filtered_clinics.length;
        return '$count ${localizations.favorites_tab_clinics}';
      default:
        return '';
    }
  }

  // Returns active sort option for currently selected category
  FavoriteSortOption _get_active_sort(FavoritesState state) {
    switch (state.active_category) {
      case FavoriteCategory.doctors:
        return state.doctors_sort;
      case FavoriteCategory.offers:
        return state.offers_sort;
      case FavoriteCategory.clinics:
        return state.clinics_sort;
      default:
        return state.doctors_sort;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<FavoritesCubit>(
      create: (cubit_context) => get_it<FavoritesCubit>(),
      child: SafeArea(
        child: BlocConsumer<FavoritesCubit, FavoritesState>(
          listener: (context, state) {
            // Handle feedback SnackBar notifications
            if (null != state.feedback_message) {
              String msg = '';
              if ('remove_success' == state.feedback_message) {
                msg = localizations.favorites_remove_success;
              } else if ('remove_error' == state.feedback_message) {
                msg = localizations.favorites_remove_error;
              } else if ('refresh_error' == state.feedback_message) {
                msg = localizations.favorites_refresh_error;
              } else {
                msg = state.feedback_message!;
              }
              if (state.is_feedback_error) {
                CustomSnackBar.error(
                  context,
                  msg,
                  duration: const Duration(seconds: 2),
                );
              } else {
                CustomSnackBar.success(
                  context,
                  msg,
                  duration: const Duration(seconds: 2),
                );
              }
              context.read<FavoritesCubit>().clear_feedback();
            } else {
              // No feedback message
            }
          },
          builder: (context, state) {
            // Guest mode guard per Phase 2
            if (false == state.is_authenticated) {
              return Column(
                children: [
                  _build_header(localizations, is_dark),
                  const Expanded(
                    child: GuestFavoritesWidget(),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Header (Title & Subtitle Centered)
                  _build_header(
                    localizations,
                    is_dark,
                    category: state.active_category,
                  ),
                  // Section 2: 3-Category Segmented Tab Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                    ),
                    child: _build_category_tabs(
                        context, state, localizations, is_dark),
                  ),
                  const SizedBox(height: AppSpacing.space_m),
                  // Section 3: Debounced In-Page Search Field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                    ),
                    child: _build_search_field(
                        context, state, localizations, is_dark),
                  ),
                  const SizedBox(height: AppSpacing.space_m),
                  // Section 4: Count & Sort Trigger Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                    ),
                    child: _build_count_and_sort_row(
                        context, state, localizations, is_dark),
                  ),
                  const SizedBox(height: AppSpacing.space_m),
                  // Section 5: Dynamic Category Tab View
                  Expanded(
                    child: _build_active_tab_view(state),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // Header Title and Subtitle Centered
  Widget _build_header(
    AppLocalizations localizations,
    bool is_dark, {
    FavoriteCategory? category,
  }) {
    final String subtitle = _get_header_subtitle(localizations, category);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_xl,
        vertical: AppSpacing.space_l,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizations.favorites_title,
              style: TextStyle(
                fontSize: AppSpacing.font_size_title,
                fontWeight: FontWeight.bold,
                color: is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.text_light_primary,
              ),
            ),
            const SizedBox(height: AppSpacing.space_xs),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: AppSpacing.font_size_body_medium,
                color: is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper resolving localized header subtitle dynamically
  String _get_header_subtitle(
    AppLocalizations localizations,
    FavoriteCategory? category,
  ) {
    if (null == category) {
      return localizations.favorites_subtitle_universal;
    } else {
      switch (category) {
        case FavoriteCategory.doctors:
          return localizations.favorites_subtitle_doctors;
        case FavoriteCategory.offers:
          return localizations.favorites_subtitle_offers;
        case FavoriteCategory.clinics:
          return localizations.favorites_subtitle_clinics;
        default:
          return localizations.favorites_subtitle_universal;
      }
    }
  }

  // 3-Category Segmented Tabs: Doctors (default), Offers, Clinics
  Widget _build_category_tabs(
    BuildContext context,
    FavoritesState state,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    return Container(
      height: _LocalDimensions.tab_segment_height,
      padding: const EdgeInsets.all(AppSpacing.space_xs),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.slate_50,
        borderRadius:
            BorderRadius.circular(_LocalDimensions.tab_segment_radius),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: AppSpacing.border_width_thin,
        ),
      ),
      child: Row(
        children: [
          _build_tab_segment_item(
            context: context,
            label: localizations.favorites_tab_doctors,
            category: FavoriteCategory.doctors,
            is_active: FavoriteCategory.doctors == state.active_category,
            is_dark: is_dark,
          ),
          _build_tab_segment_item(
            context: context,
            label: localizations.favorites_tab_offers,
            category: FavoriteCategory.offers,
            is_active: FavoriteCategory.offers == state.active_category,
            is_dark: is_dark,
          ),
          _build_tab_segment_item(
            context: context,
            label: localizations.favorites_tab_clinics,
            category: FavoriteCategory.clinics,
            is_active: FavoriteCategory.clinics == state.active_category,
            is_dark: is_dark,
          ),
        ],
      ),
    );
  }

  // Individual Tab Segment Capsule Item
  Widget _build_tab_segment_item({
    required BuildContext context,
    required String label,
    required FavoriteCategory category,
    required bool is_active,
    required bool is_dark,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _search_controller.clear();
          context.read<FavoritesCubit>().switch_category(category);
        },
        borderRadius: BorderRadius.circular(_LocalDimensions.tab_item_radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: is_active ? AppColors.primary_color : AppColors.transparent,
            borderRadius:
                BorderRadius.circular(_LocalDimensions.tab_item_radius),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppSpacing.font_size_body_medium,
              fontWeight: is_active ? FontWeight.bold : FontWeight.w500,
              color: is_active
                  ? AppColors.white
                  : (is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary),
            ),
          ),
        ),
      ),
    );
  }

  // In-Page Debounced Search Input Bar
  Widget _build_search_field(
    BuildContext context,
    FavoritesState state,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    final String hint = _get_search_hint(state.active_category, localizations);

    return Container(
      height: _LocalDimensions.search_bar_height,
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(_LocalDimensions.search_bar_radius),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: AppSpacing.border_width_thin,
        ),
      ),
      child: TextField(
        controller: _search_controller,
        onChanged: (val) {
          context.read<FavoritesCubit>().search_favorites(val);
        },
        style: TextStyle(
          fontSize: AppSpacing.font_size_body_medium,
          color: is_dark
              ? AppColors.text_dark_primary
              : AppColors.text_light_primary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: AppSpacing.font_size_body_medium,
            color: is_dark
                ? AppColors.text_dark_secondary
                : AppColors.text_light_secondary,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: _LocalDimensions.search_icon_size,
            color: AppColors.primary_color,
          ),
          suffixIcon: _search_controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: _LocalDimensions.clear_icon_size,
                  ),
                  onPressed: () {
                    _search_controller.clear();
                    context.read<FavoritesCubit>().search_favorites('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.space_l,
          ),
        ),
      ),
    );
  }

  // Count indicator & Category-Aware Sort Trigger Button
  Widget _build_count_and_sort_row(
    BuildContext context,
    FavoritesState state,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    final String count_label = _get_items_count_label(state, localizations);
    final FavoriteSortOption active_sort = _get_active_sort(state);
    final String sort_label =
        _get_sort_trigger_label(active_sort, localizations);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Count Text
        Text(
          count_label,
          style: TextStyle(
            fontSize: AppSpacing.font_size_body_small,
            fontWeight: FontWeight.w600,
            color: is_dark
                ? AppColors.text_dark_secondary
                : AppColors.text_light_secondary,
          ),
        ),
        // Sort Trigger Button
        InkWell(
          onTap: () {
            show_favorite_sort_bottom_sheet(
              context: context,
              category: state.active_category,
              current_sort: active_sort,
              on_apply: (selected_sort) {
                context.read<FavoritesCubit>().sort_favorites(selected_sort);
              },
            );
          },
          borderRadius:
              BorderRadius.circular(_LocalDimensions.sort_chip_radius),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _LocalDimensions.sort_chip_padding_h,
              vertical: _LocalDimensions.sort_chip_padding_v,
            ),
            decoration: BoxDecoration(
              color: is_dark
                  ? AppColors.primary_color.withValues(alpha: 0.15)
                  : AppColors.primary_color.withValues(alpha: 0.08),
              borderRadius:
                  BorderRadius.circular(_LocalDimensions.sort_chip_radius),
              border: Border.all(
                color: is_dark ? AppColors.border_dark : AppColors.slate_200,
                width: AppSpacing.border_width_thin,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sort_rounded,
                  size: AppSpacing.font_size_body_medium,
                  color: AppColors.primary_color,
                ),
                const SizedBox(width: AppSpacing.space_xs),
                Text(
                  sort_label,
                  style: const TextStyle(
                    fontSize: AppSpacing.font_size_body_small,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary_color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Active Category Tab View Builder
  Widget _build_active_tab_view(FavoritesState state) {
    switch (state.active_category) {
      case FavoriteCategory.doctors:
        return const DoctorFavoriteTab();
      case FavoriteCategory.offers:
        return const OfferFavoriteTab();
      case FavoriteCategory.clinics:
        return const ClinicFavoriteTab();
      default:
        return const DoctorFavoriteTab();
    }
  }
}

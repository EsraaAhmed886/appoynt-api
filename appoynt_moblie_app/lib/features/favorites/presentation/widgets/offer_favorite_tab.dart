/*
 * File Name: offer_favorite_tab.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   app_colors.dart, app_localizations.dart, offer_card.dart,
 *   empty_favorites_widget.dart, favorites_cubit.dart, favorites_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Renders the Offers category tab content with pull-to-refresh,
 *   infinite scroll pagination at 80% scroll depth, and empty state fallbacks.
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
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import OfferCard component
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/offer_card.dart';
// Import EmptyFavoritesWidget component
import 'package:appoynt_mobile_app/features/favorites/presentation/widgets/empty_favorites_widget.dart';
// Import cubit and state
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_state.dart';

// OfferFavoriteTab stateful widget
class OfferFavoriteTab extends StatefulWidget {
  // Constant constructor
  const OfferFavoriteTab({super.key});

  @override
  State<OfferFavoriteTab> createState() => _OfferFavoriteTabState();
}

// State tracking scroll depth for infinite pagination
class _OfferFavoriteTabState extends State<OfferFavoriteTab> {
  // ScrollController to monitor 80% scroll depth
  late final ScrollController _scroll_controller;

  @override
  void initState() {
    super.initState();
    _scroll_controller = ScrollController()..addListener(_on_scroll);
  }

  @override
  void dispose() {
    _scroll_controller.removeListener(_on_scroll);
    _scroll_controller.dispose();
    super.dispose();
  }

  // Listener triggering load more when reaching 80% scroll depth
  void _on_scroll() {
    if (!_scroll_controller.hasClients) {
      return;
    } else {
      final double max_scroll = _scroll_controller.position.maxScrollExtent;
      final double current_scroll = _scroll_controller.position.pixels;
      if (current_scroll >= (max_scroll * 0.8)) {
        context.read<FavoritesCubit>().load_more_items();
      } else {
        // Below 80% scroll threshold
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        // Loading state
        if (CategoryLoadingStatus.loading == state.offers_status) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary_color,
            ),
          );
        } else {
          final bool is_search_empty = state.offers.isNotEmpty &&
              state.filtered_offers.isEmpty &&
              state.offers_query.isNotEmpty;

          final bool is_master_empty = state.offers.isEmpty;

          if (is_master_empty) {
            return RefreshIndicator(
              color: AppColors.primary_color,
              onRefresh: () async {
                await context
                    .read<FavoritesCubit>()
                    .load_active_category(is_refresh: true);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: EmptyFavoritesWidget(
                      custom_title: localizations.favorites_empty_offers_title,
                      custom_subtitle:
                          localizations.favorites_empty_offers_subtitle,
                      custom_icon: Icons.local_offer_outlined,
                    ),
                  ),
                ],
              ),
            );
          } else if (is_search_empty) {
            return Center(
              child: EmptyFavoritesWidget(
                custom_title: localizations.favorites_empty_search_title,
                custom_subtitle: localizations.favorites_empty_search_subtitle,
                custom_icon: Icons.search_off_rounded,
              ),
            );
          } else {
            // Render scrollable Offer Cards
            return RefreshIndicator(
              color: AppColors.primary_color,
              onRefresh: () async {
                await context
                    .read<FavoritesCubit>()
                    .load_active_category(is_refresh: true);
              },
              child: ListView.builder(
                controller: _scroll_controller,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space_xl,
                  vertical: AppSpacing.space_m,
                ),
                itemCount: state.filtered_offers.length +
                    (state.offers_is_loading_more ? 1 : 0),
                itemBuilder: (list_context, index) {
                  // Bottom pagination loader
                  if (index >= state.filtered_offers.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.space_l,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: AppColors.primary_color,
                          ),
                        ),
                      ),
                    );
                  } else {
                    final offer = state.filtered_offers[index];
                    final bool is_removing =
                        state.removing_ids.contains(offer.id);
                    return OfferCard(
                      offer: offer,
                      is_removing: is_removing,
                      on_book_tap: offer.is_expired
                          ? null
                          : () {
                              CustomSnackBar.info(
                                list_context,
                                'Booking offer: ${offer.title}...',
                                duration: const Duration(seconds: 2),
                              );
                            },
                      on_favorite_tap: () {
                        context.read<FavoritesCubit>().remove_favorite(
                              offer.id,
                              FavoriteCategory.offers,
                            );
                      },
                    );
                  }
                },
              ),
            );
          }
        }
      },
    );
  }
}

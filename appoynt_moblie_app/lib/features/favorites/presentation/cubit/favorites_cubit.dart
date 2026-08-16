/*
 * File Name: favorites_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart,
 *   token_storage.dart, favorites_repository.dart, favorites_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Business logic controller for the Favorites feature managing
 *   tab navigation, auth guards, independent pagination, search filtering,
 *   sorting algorithms, and backend-confirmed favorite removal across Doctors,
 *   Offers, and Clinics.
 */

// Import Dart asynchronous library for Timer debounce
import 'dart:async';
// Import BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';

// Import TokenStorage to verify authentication session
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
// Import domain entities
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_offer.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_clinic.dart';
// Import domain repository contract
import 'package:appoynt_mobile_app/features/favorites/domain/repositories/favorites_repository.dart';
// Import state and enums
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_state.dart';

// Controller class orchestrating all business actions for Favorites screen
class FavoritesCubit extends Cubit<FavoritesState> {
  // Favorites repository dependency injected via constructor
  final FavoritesRepository repository;
  // Page size constant for infinite scroll pagination batches
  static const int _page_size = 10;
  // Timer instance for search input debounce
  Timer? _debounce_timer;

  // Constructor mapping repository dependency and initiating auth check
  FavoritesCubit({required this.repository}) : super(FavoritesState.initial()) {
    check_auth_and_initialize();
  }

  @override
  // Clean up debounce timer on cubit disposal
  Future<void> close() {
    _debounce_timer?.cancel();
    return super.close();
  }

  // Verifies user session and initializes active category or marks as guest
  Future<void> check_auth_and_initialize() async {
    final String? token = await TokenStorage.get_access_token();
    if (null == token || token.isEmpty) {
      if (!isClosed) {
        emit(state.copyWith(is_authenticated: false));
      } else {
        // Discard emit if cubit closed
      }
    } else {
      if (!isClosed) {
        emit(state.copyWith(is_authenticated: true));
        load_active_category();
      } else {
        // Discard emit if cubit closed
      }
    }
  }

  // Switches active category tab and lazily loads target category if uninitialized
  void switch_category(FavoriteCategory category) {
    if (category == state.active_category) {
      return;
    } else {
      emit(state.copyWith(active_category: category));
      final CategoryLoadingStatus target_status = _get_status_for_category(category);
      if (CategoryLoadingStatus.initial == target_status) {
        load_active_category();
      } else {
        // Target category already initialized — retain cached data
      }
    }
  }

  // Helper resolving loading status for a given category
  CategoryLoadingStatus _get_status_for_category(FavoriteCategory category) {
    switch (category) {
      case FavoriteCategory.doctors:
        return state.doctors_status;
      case FavoriteCategory.offers:
        return state.offers_status;
      case FavoriteCategory.clinics:
        return state.clinics_status;
      default:
        return state.doctors_status;
    }
  }

  // Loads initial or refreshed page for active category
  Future<void> load_active_category({bool is_refresh = false}) async {
    if (false == state.is_authenticated) {
      return;
    } else {
      switch (state.active_category) {
        case FavoriteCategory.doctors:
          await _load_doctors(is_refresh: is_refresh);
          break;
        case FavoriteCategory.offers:
          await _load_offers(is_refresh: is_refresh);
          break;
        case FavoriteCategory.clinics:
          await _load_clinics(is_refresh: is_refresh);
          break;
        default:
          break;
      }
    }
  }

  // Loads paginated favorited doctors
  Future<void> _load_doctors({bool is_refresh = false}) async {
    if (is_refresh) {
      emit(state.copyWith(doctors_status: CategoryLoadingStatus.refreshing));
    } else {
      emit(state.copyWith(doctors_status: CategoryLoadingStatus.loading));
    }
    try {
      final List<FavoritedDoctor> loaded = await repository.getFavoriteDoctors(
        page: 1,
        page_size: _page_size,
      );
      final List<FavoritedDoctor> filtered = _filter_and_sort_doctors(
        items: loaded,
        query: state.doctors_query,
        sort: state.doctors_sort,
      );
      if (!isClosed) {
        emit(state.copyWith(
          doctors: loaded,
          filtered_doctors: filtered,
          doctors_status: CategoryLoadingStatus.success,
          doctors_page: 1,
          doctors_has_more: loaded.length >= _page_size,
        ));
      } else {
        // Discard emit
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          doctors_status: CategoryLoadingStatus.error,
          feedback_message: is_refresh ? 'refresh_error' : null,
          is_feedback_error: true,
        ));
      } else {
        // Discard emit
      }
    }
  }

  // Loads paginated favorited offers
  Future<void> _load_offers({bool is_refresh = false}) async {
    if (is_refresh) {
      emit(state.copyWith(offers_status: CategoryLoadingStatus.refreshing));
    } else {
      emit(state.copyWith(offers_status: CategoryLoadingStatus.loading));
    }
    try {
      final List<FavoritedOffer> loaded = await repository.getFavoriteOffers(
        page: 1,
        page_size: _page_size,
      );
      final List<FavoritedOffer> filtered = _filter_and_sort_offers(
        items: loaded,
        query: state.offers_query,
        sort: state.offers_sort,
      );
      if (!isClosed) {
        emit(state.copyWith(
          offers: loaded,
          filtered_offers: filtered,
          offers_status: CategoryLoadingStatus.success,
          offers_page: 1,
          offers_has_more: loaded.length >= _page_size,
        ));
      } else {
        // Discard emit
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          offers_status: CategoryLoadingStatus.error,
          feedback_message: is_refresh ? 'refresh_error' : null,
          is_feedback_error: true,
        ));
      } else {
        // Discard emit
      }
    }
  }

  // Loads paginated favorited clinics
  Future<void> _load_clinics({bool is_refresh = false}) async {
    if (is_refresh) {
      emit(state.copyWith(clinics_status: CategoryLoadingStatus.refreshing));
    } else {
      emit(state.copyWith(clinics_status: CategoryLoadingStatus.loading));
    }
    try {
      final List<FavoritedClinic> loaded = await repository.getFavoriteClinics(
        page: 1,
        page_size: _page_size,
      );
      final List<FavoritedClinic> filtered = _filter_and_sort_clinics(
        items: loaded,
        query: state.clinics_query,
        sort: state.clinics_sort,
      );
      if (!isClosed) {
        emit(state.copyWith(
          clinics: loaded,
          filtered_clinics: filtered,
          clinics_status: CategoryLoadingStatus.success,
          clinics_page: 1,
          clinics_has_more: loaded.length >= _page_size,
        ));
      } else {
        // Discard emit
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          clinics_status: CategoryLoadingStatus.error,
          feedback_message: is_refresh ? 'refresh_error' : null,
          is_feedback_error: true,
        ));
      } else {
        // Discard emit
      }
    }
  }

  // Infinite scroll pagination trigger called at 80% scroll depth
  Future<void> load_more_items() async {
    if (false == state.is_authenticated) {
      return;
    } else {
      switch (state.active_category) {
        case FavoriteCategory.doctors:
          await _load_more_doctors();
          break;
        case FavoriteCategory.offers:
          await _load_more_offers();
          break;
        case FavoriteCategory.clinics:
          await _load_more_clinics();
          break;
        default:
          break;
      }
    }
  }

  // Pagination loader for doctors
  Future<void> _load_more_doctors() async {
    if (state.doctors_is_loading_more || false == state.doctors_has_more) {
      return;
    } else {
      emit(state.copyWith(doctors_is_loading_more: true));
      final int next_page = state.doctors_page + 1;
      try {
        final List<FavoritedDoctor> next_items =
            await repository.getFavoriteDoctors(
          page: next_page,
          page_size: _page_size,
        );
        final List<FavoritedDoctor> combined = [
          ...state.doctors,
          ...next_items,
        ];
        final List<FavoritedDoctor> filtered = _filter_and_sort_doctors(
          items: combined,
          query: state.doctors_query,
          sort: state.doctors_sort,
        );
        if (!isClosed) {
          emit(state.copyWith(
            doctors: combined,
            filtered_doctors: filtered,
            doctors_page: next_page,
            doctors_has_more: next_items.length >= _page_size,
            doctors_is_loading_more: false,
          ));
        } else {
          // Discard emit
        }
      } catch (e) {
        if (!isClosed) {
          emit(state.copyWith(doctors_is_loading_more: false));
        } else {
          // Discard emit
        }
      }
    }
  }

  // Pagination loader for offers
  Future<void> _load_more_offers() async {
    if (state.offers_is_loading_more || false == state.offers_has_more) {
      return;
    } else {
      emit(state.copyWith(offers_is_loading_more: true));
      final int next_page = state.offers_page + 1;
      try {
        final List<FavoritedOffer> next_items =
            await repository.getFavoriteOffers(
          page: next_page,
          page_size: _page_size,
        );
        final List<FavoritedOffer> combined = [
          ...state.offers,
          ...next_items,
        ];
        final List<FavoritedOffer> filtered = _filter_and_sort_offers(
          items: combined,
          query: state.offers_query,
          sort: state.offers_sort,
        );
        if (!isClosed) {
          emit(state.copyWith(
            offers: combined,
            filtered_offers: filtered,
            offers_page: next_page,
            offers_has_more: next_items.length >= _page_size,
            offers_is_loading_more: false,
          ));
        } else {
          // Discard emit
        }
      } catch (e) {
        if (!isClosed) {
          emit(state.copyWith(offers_is_loading_more: false));
        } else {
          // Discard emit
        }
      }
    }
  }

  // Pagination loader for clinics
  Future<void> _load_more_clinics() async {
    if (state.clinics_is_loading_more || false == state.clinics_has_more) {
      return;
    } else {
      emit(state.copyWith(clinics_is_loading_more: true));
      final int next_page = state.clinics_page + 1;
      try {
        final List<FavoritedClinic> next_items =
            await repository.getFavoriteClinics(
          page: next_page,
          page_size: _page_size,
        );
        final List<FavoritedClinic> combined = [
          ...state.clinics,
          ...next_items,
        ];
        final List<FavoritedClinic> filtered = _filter_and_sort_clinics(
          items: combined,
          query: state.clinics_query,
          sort: state.clinics_sort,
        );
        if (!isClosed) {
          emit(state.copyWith(
            clinics: combined,
            filtered_clinics: filtered,
            clinics_page: next_page,
            clinics_has_more: next_items.length >= _page_size,
            clinics_is_loading_more: false,
          ));
        } else {
          // Discard emit
        }
      } catch (e) {
        if (!isClosed) {
          emit(state.copyWith(clinics_is_loading_more: false));
        } else {
          // Discard emit
        }
      }
    }
  }

  // Real-time search filter with debounce <= 500ms
  void search_favorites(String raw_query) {
    _debounce_timer?.cancel();
    _debounce_timer = Timer(const Duration(milliseconds: 300), () {
      final String clean_query = raw_query.trim();
      switch (state.active_category) {
        case FavoriteCategory.doctors:
          final List<FavoritedDoctor> filtered = _filter_and_sort_doctors(
            items: state.doctors,
            query: clean_query,
            sort: state.doctors_sort,
          );
          emit(state.copyWith(
            doctors_query: clean_query,
            filtered_doctors: filtered,
          ));
          break;
        case FavoriteCategory.offers:
          final List<FavoritedOffer> filtered = _filter_and_sort_offers(
            items: state.offers,
            query: clean_query,
            sort: state.offers_sort,
          );
          emit(state.copyWith(
            offers_query: clean_query,
            filtered_offers: filtered,
          ));
          break;
        case FavoriteCategory.clinics:
          final List<FavoritedClinic> filtered = _filter_and_sort_clinics(
            items: state.clinics,
            query: clean_query,
            sort: state.clinics_sort,
          );
          emit(state.copyWith(
            clinics_query: clean_query,
            filtered_clinics: filtered,
          ));
          break;
        default:
          break;
      }
    });
  }

  // Applies category-aware sorting and persists sort selection during session
  void sort_favorites(FavoriteSortOption sort_option) {
    switch (state.active_category) {
      case FavoriteCategory.doctors:
        final List<FavoritedDoctor> filtered = _filter_and_sort_doctors(
          items: state.doctors,
          query: state.doctors_query,
          sort: sort_option,
        );
        emit(state.copyWith(
          doctors_sort: sort_option,
          filtered_doctors: filtered,
        ));
        break;
      case FavoriteCategory.offers:
        final List<FavoritedOffer> filtered = _filter_and_sort_offers(
          items: state.offers,
          query: state.offers_query,
          sort: sort_option,
        );
        emit(state.copyWith(
          offers_sort: sort_option,
          filtered_offers: filtered,
        ));
        break;
      case FavoriteCategory.clinics:
        final List<FavoritedClinic> filtered = _filter_and_sort_clinics(
          items: state.clinics,
          query: state.clinics_query,
          sort: sort_option,
        );
        emit(state.copyWith(
          clinics_sort: sort_option,
          filtered_clinics: filtered,
        ));
        break;
      default:
        break;
    }
  }

  // Backend-confirmed favorite removal with temporary loading guard
  Future<void> remove_favorite(String id, FavoriteCategory category) async {
    if (state.removing_ids.contains(id)) {
      return;
    } else {
      final Set<String> updated_removing = Set<String>.from(state.removing_ids)
        ..add(id);
      emit(state.copyWith(removing_ids: updated_removing));
      try {
        switch (category) {
          case FavoriteCategory.doctors:
            await repository.removeFavoriteDoctor(id);
            final List<FavoritedDoctor> remaining =
                state.doctors.where((doc) => doc.id != id).toList();
            final List<FavoritedDoctor> filtered = _filter_and_sort_doctors(
              items: remaining,
              query: state.doctors_query,
              sort: state.doctors_sort,
            );
            final Set<String> cleared = Set<String>.from(state.removing_ids)
              ..remove(id);
            if (!isClosed) {
              emit(state.copyWith(
                doctors: remaining,
                filtered_doctors: filtered,
                removing_ids: cleared,
                feedback_message: 'remove_success',
                is_feedback_error: false,
              ));
            } else {
              // Discard emit
            }
            break;
          case FavoriteCategory.offers:
            await repository.removeFavoriteOffer(id);
            final List<FavoritedOffer> remaining =
                state.offers.where((off) => off.id != id).toList();
            final List<FavoritedOffer> filtered = _filter_and_sort_offers(
              items: remaining,
              query: state.offers_query,
              sort: state.offers_sort,
            );
            final Set<String> cleared = Set<String>.from(state.removing_ids)
              ..remove(id);
            if (!isClosed) {
              emit(state.copyWith(
                offers: remaining,
                filtered_offers: filtered,
                removing_ids: cleared,
                feedback_message: 'remove_success',
                is_feedback_error: false,
              ));
            } else {
              // Discard emit
            }
            break;
          case FavoriteCategory.clinics:
            await repository.removeFavoriteClinic(id);
            final List<FavoritedClinic> remaining =
                state.clinics.where((cln) => cln.id != id).toList();
            final List<FavoritedClinic> filtered = _filter_and_sort_clinics(
              items: remaining,
              query: state.clinics_query,
              sort: state.clinics_sort,
            );
            final Set<String> cleared = Set<String>.from(state.removing_ids)
              ..remove(id);
            if (!isClosed) {
              emit(state.copyWith(
                clinics: remaining,
                filtered_clinics: filtered,
                removing_ids: cleared,
                feedback_message: 'remove_success',
                is_feedback_error: false,
              ));
            } else {
              // Discard emit
            }
            break;
          default:
            break;
        }
      } catch (e) {
        final Set<String> cleared = Set<String>.from(state.removing_ids)
          ..remove(id);
        if (!isClosed) {
          emit(state.copyWith(
            removing_ids: cleared,
            feedback_message: 'remove_error',
            is_feedback_error: true,
          ));
        } else {
          // Discard emit
        }
      }
    }
  }

  // Resets transient feedback toast message
  void clear_feedback() {
    emit(state.copyWith(feedback_message: null, is_feedback_error: false));
  }

  // Session cleanup called upon logout or account switch
  Future<void> on_logout_session_cleared() async {
    await repository.clearFavoritesCache();
    if (!isClosed) {
      emit(FavoritesState.initial().copyWith(is_authenticated: false));
    } else {
      // Discard emit
    }
  }

  // Private filtering and sorting algorithms for Doctors
  List<FavoritedDoctor> _filter_and_sort_doctors({
    required List<FavoritedDoctor> items,
    required String query,
    required FavoriteSortOption sort,
  }) {
    List<FavoritedDoctor> result = items;
    if (query.isNotEmpty) {
      final String lower = query.toLowerCase();
      result = result.where((doc) {
        return doc.name.toLowerCase().contains(lower) ||
            doc.specialty.toLowerCase().contains(lower) ||
            doc.location.toLowerCase().contains(lower);
      }).toList();
    } else {
      // Retain all items
    }
    final List<FavoritedDoctor> sorted = List.from(result);
    switch (sort) {
      case FavoriteSortOption.recently_added:
        sorted.sort((a, b) => b.added_timestamp.compareTo(a.added_timestamp));
        break;
      case FavoriteSortOption.name_a_z:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case FavoriteSortOption.name_z_a:
        sorted.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case FavoriteSortOption.rating_high_low:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case FavoriteSortOption.price_low_high:
        sorted.sort((a, b) => a.fee.compareTo(b.fee));
        break;
      case FavoriteSortOption.price_high_low:
        sorted.sort((a, b) => b.fee.compareTo(a.fee));
        break;
      case FavoriteSortOption.discount_high_low:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        break;
    }
    return sorted;
  }

  // Private filtering and sorting algorithms for Offers
  List<FavoritedOffer> _filter_and_sort_offers({
    required List<FavoritedOffer> items,
    required String query,
    required FavoriteSortOption sort,
  }) {
    List<FavoritedOffer> result = items;
    if (query.isNotEmpty) {
      final String lower = query.toLowerCase();
      result = result.where((off) {
        return off.title.toLowerCase().contains(lower) ||
            off.provider_name.toLowerCase().contains(lower);
      }).toList();
    } else {
      // Retain all items
    }
    final List<FavoritedOffer> sorted = List.from(result);
    switch (sort) {
      case FavoriteSortOption.recently_added:
        sorted.sort((a, b) => b.added_timestamp.compareTo(a.added_timestamp));
        break;
      case FavoriteSortOption.name_a_z:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case FavoriteSortOption.name_z_a:
        sorted.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case FavoriteSortOption.rating_high_low:
      case FavoriteSortOption.discount_high_low:
        sorted.sort((a, b) => b.discount_percentage.compareTo(a.discount_percentage));
        break;
      case FavoriteSortOption.price_low_high:
        sorted.sort((a, b) => a.discounted_price.compareTo(b.discounted_price));
        break;
      case FavoriteSortOption.price_high_low:
        sorted.sort((a, b) => b.discounted_price.compareTo(a.discounted_price));
        break;
      default:
        break;
    }
    return sorted;
  }

  // Private filtering and sorting algorithms for Clinics
  List<FavoritedClinic> _filter_and_sort_clinics({
    required List<FavoritedClinic> items,
    required String query,
    required FavoriteSortOption sort,
  }) {
    List<FavoritedClinic> result = items;
    if (query.isNotEmpty) {
      final String lower = query.toLowerCase();
      result = result.where((cln) {
        final bool name_match = cln.name.toLowerCase().contains(lower);
        final bool address_match = cln.address.toLowerCase().contains(lower);
        final bool spec_match =
            cln.specialties.any((s) => s.toLowerCase().contains(lower));
        return name_match || address_match || spec_match;
      }).toList();
    } else {
      // Retain all items
    }
    final List<FavoritedClinic> sorted = List.from(result);
    switch (sort) {
      case FavoriteSortOption.recently_added:
        sorted.sort((a, b) => b.added_timestamp.compareTo(a.added_timestamp));
        break;
      case FavoriteSortOption.name_a_z:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case FavoriteSortOption.name_z_a:
        sorted.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case FavoriteSortOption.rating_high_low:
      case FavoriteSortOption.discount_high_low:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case FavoriteSortOption.price_low_high:
      case FavoriteSortOption.price_high_low:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      default:
        break;
    }
    return sorted;
  }
}

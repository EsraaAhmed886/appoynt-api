/*
 * File Name: favorites_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:equatable/equatable.dart, favorited_doctor.dart,
 *   favorited_offer.dart, favorited_clinic.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Defines the multi-category states, sorting option enumeration,
 *   category status enums, and pagination trackers for the Favorites feature.
 */

// Import Equatable for state equality comparison
import 'package:equatable/equatable.dart';
// Import domain entities
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_offer.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_clinic.dart';

// Category tab enumeration
enum FavoriteCategory {
  // Doctors category (default tab 0)
  doctors,
  // Offers category (tab 1)
  offers,
  // Clinics category (tab 2)
  clinics,
}

// Category loading status enumeration
enum CategoryLoadingStatus {
  // Initial uninitialized state
  initial,
  // Initial loading spinner state
  loading,
  // Data loaded successfully
  success,
  // Loading error occurred
  error,
  // Pull-to-refresh in progress
  refreshing,
}

// Sorting options enumeration across all categories
enum FavoriteSortOption {
  // Recently added timestamp (default)
  recently_added,
  // Name alphabetical A to Z
  name_a_z,
  // Name alphabetical Z to A
  name_z_a,
  // Rating high to low (Doctors & Clinics)
  rating_high_low,
  // Price / fee low to high (Doctors & Offers)
  price_low_high,
  // Price / fee high to low (Doctors & Offers)
  price_high_low,
  // Discount percentage high to low (Offers)
  discount_high_low,
}

// Comprehensive State class for Favorites feature
class FavoritesState extends Equatable {
  // Currently active selected category tab
  final FavoriteCategory active_category;
  // Flag indicating if current session is authenticated
  final bool is_authenticated;

  // ── Doctors Category State ──
  final List<FavoritedDoctor> doctors;
  final List<FavoritedDoctor> filtered_doctors;
  final CategoryLoadingStatus doctors_status;
  final FavoriteSortOption doctors_sort;
  final String doctors_query;
  final int doctors_page;
  final bool doctors_has_more;
  final bool doctors_is_loading_more;

  // ── Offers Category State ──
  final List<FavoritedOffer> offers;
  final List<FavoritedOffer> filtered_offers;
  final CategoryLoadingStatus offers_status;
  final FavoriteSortOption offers_sort;
  final String offers_query;
  final int offers_page;
  final bool offers_has_more;
  final bool offers_is_loading_more;

  // ── Clinics Category State ──
  final List<FavoritedClinic> clinics;
  final List<FavoritedClinic> filtered_clinics;
  final CategoryLoadingStatus clinics_status;
  final FavoriteSortOption clinics_sort;
  final String clinics_query;
  final int clinics_page;
  final bool clinics_has_more;
  final bool clinics_is_loading_more;

  // Set of item IDs currently being removed via backend API
  final Set<String> removing_ids;
  // Transient feedback toast message string
  final String? feedback_message;
  // Flag indicating if feedback message is an error
  final bool is_feedback_error;

  // Constructor mapping all properties
  const FavoritesState({
    required this.active_category,
    required this.is_authenticated,
    required this.doctors,
    required this.filtered_doctors,
    required this.doctors_status,
    required this.doctors_sort,
    required this.doctors_query,
    required this.doctors_page,
    required this.doctors_has_more,
    required this.doctors_is_loading_more,
    required this.offers,
    required this.filtered_offers,
    required this.offers_status,
    required this.offers_sort,
    required this.offers_query,
    required this.offers_page,
    required this.offers_has_more,
    required this.offers_is_loading_more,
    required this.clinics,
    required this.filtered_clinics,
    required this.clinics_status,
    required this.clinics_sort,
    required this.clinics_query,
    required this.clinics_page,
    required this.clinics_has_more,
    required this.clinics_is_loading_more,
    required this.removing_ids,
    this.feedback_message,
    this.is_feedback_error = false,
  });

  // Factory constructor initializing default state
  factory FavoritesState.initial() {
    return const FavoritesState(
      active_category: FavoriteCategory.doctors,
      is_authenticated: true,
      doctors: [],
      filtered_doctors: [],
      doctors_status: CategoryLoadingStatus.initial,
      doctors_sort: FavoriteSortOption.recently_added,
      doctors_query: '',
      doctors_page: 1,
      doctors_has_more: true,
      doctors_is_loading_more: false,
      offers: [],
      filtered_offers: [],
      offers_status: CategoryLoadingStatus.initial,
      offers_sort: FavoriteSortOption.recently_added,
      offers_query: '',
      offers_page: 1,
      offers_has_more: true,
      offers_is_loading_more: false,
      clinics: [],
      filtered_clinics: [],
      clinics_status: CategoryLoadingStatus.initial,
      clinics_sort: FavoriteSortOption.recently_added,
      clinics_query: '',
      clinics_page: 1,
      clinics_has_more: true,
      clinics_is_loading_more: false,
      removing_ids: {},
      feedback_message: null,
      is_feedback_error: false,
    );
  }

  // CopyWith helper method to duplicate state with overrides
  FavoritesState copyWith({
    FavoriteCategory? active_category,
    bool? is_authenticated,
    List<FavoritedDoctor>? doctors,
    List<FavoritedDoctor>? filtered_doctors,
    CategoryLoadingStatus? doctors_status,
    FavoriteSortOption? doctors_sort,
    String? doctors_query,
    int? doctors_page,
    bool? doctors_has_more,
    bool? doctors_is_loading_more,
    List<FavoritedOffer>? offers,
    List<FavoritedOffer>? filtered_offers,
    CategoryLoadingStatus? offers_status,
    FavoriteSortOption? offers_sort,
    String? offers_query,
    int? offers_page,
    bool? offers_has_more,
    bool? offers_is_loading_more,
    List<FavoritedClinic>? clinics,
    List<FavoritedClinic>? filtered_clinics,
    CategoryLoadingStatus? clinics_status,
    FavoriteSortOption? clinics_sort,
    String? clinics_query,
    int? clinics_page,
    bool? clinics_has_more,
    bool? clinics_is_loading_more,
    Set<String>? removing_ids,
    String? feedback_message,
    bool? is_feedback_error,
  }) {
    return FavoritesState(
      active_category: active_category ?? this.active_category,
      is_authenticated: is_authenticated ?? this.is_authenticated,
      doctors: doctors ?? this.doctors,
      filtered_doctors: filtered_doctors ?? this.filtered_doctors,
      doctors_status: doctors_status ?? this.doctors_status,
      doctors_sort: doctors_sort ?? this.doctors_sort,
      doctors_query: doctors_query ?? this.doctors_query,
      doctors_page: doctors_page ?? this.doctors_page,
      doctors_has_more: doctors_has_more ?? this.doctors_has_more,
      doctors_is_loading_more:
          doctors_is_loading_more ?? this.doctors_is_loading_more,
      offers: offers ?? this.offers,
      filtered_offers: filtered_offers ?? this.filtered_offers,
      offers_status: offers_status ?? this.offers_status,
      offers_sort: offers_sort ?? this.offers_sort,
      offers_query: offers_query ?? this.offers_query,
      offers_page: offers_page ?? this.offers_page,
      offers_has_more: offers_has_more ?? this.offers_has_more,
      offers_is_loading_more:
          offers_is_loading_more ?? this.offers_is_loading_more,
      clinics: clinics ?? this.clinics,
      filtered_clinics: filtered_clinics ?? this.filtered_clinics,
      clinics_status: clinics_status ?? this.clinics_status,
      clinics_sort: clinics_sort ?? this.clinics_sort,
      clinics_query: clinics_query ?? this.clinics_query,
      clinics_page: clinics_page ?? this.clinics_page,
      clinics_has_more: clinics_has_more ?? this.clinics_has_more,
      clinics_is_loading_more:
          clinics_is_loading_more ?? this.clinics_is_loading_more,
      removing_ids: removing_ids ?? this.removing_ids,
      feedback_message: feedback_message,
      is_feedback_error: is_feedback_error ?? false,
    );
  }

  @override
  // Equatable props list for state comparison
  List<Object?> get props => [
        active_category,
        is_authenticated,
        doctors,
        filtered_doctors,
        doctors_status,
        doctors_sort,
        doctors_query,
        doctors_page,
        doctors_has_more,
        doctors_is_loading_more,
        offers,
        filtered_offers,
        offers_status,
        offers_sort,
        offers_query,
        offers_page,
        offers_has_more,
        offers_is_loading_more,
        clinics,
        filtered_clinics,
        clinics_status,
        clinics_sort,
        clinics_query,
        clinics_page,
        clinics_has_more,
        clinics_is_loading_more,
        removing_ids,
        feedback_message,
        is_feedback_error,
      ];
}

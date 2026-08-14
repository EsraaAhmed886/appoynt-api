/*
 * File Name: favorites_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart,
 *   package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Defines the states and sorting option enumeration for the Favorites BLoC/Cubit pattern.
 */

// Import Equatable package for state equality comparison
import 'package:equatable/equatable.dart';
// Import FavoritedDoctor domain entity representation
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart';

// Sorting options enumeration for favorited doctors
enum FavoriteSortOption {
  // Sort by recently added timestamp (default)
  recently_added,
  // Sort alphabetically by doctor name from A to Z
  name_a_z,
  // Sort alphabetically by doctor name from Z to A
  name_z_a,
  // Sort by star rating from highest to lowest
  rating_high_low,
  // Sort by consultation fee from lowest to highest
  price_low_high,
  // Sort by consultation fee from highest to lowest
  price_high_low,
}

// State class for Favorites feature
class FavoritesState extends Equatable {
  // Full master list of favorited doctors
  final List<FavoritedDoctor> all_favorites;
  // Filtered and sorted list of doctors active in UI
  final List<FavoritedDoctor> filtered_favorites;
  // Active search query string
  final String search_query;
  // Currently selected sorting option
  final FavoriteSortOption selected_sort;
  // Flag indicating if loading is in progress
  final bool is_loading;

  // Constructor assigning all member properties
  const FavoritesState({
    required this.all_favorites,
    required this.filtered_favorites,
    required this.search_query,
    required this.selected_sort,
    required this.is_loading,
  });

  // Initial factory constructor layout config
  factory FavoritesState.initial() {
    return const FavoritesState(
      all_favorites: [],
      filtered_favorites: [],
      search_query: '',
      selected_sort: FavoriteSortOption.recently_added,
      is_loading: true,
    );
  }

  // CopyWith helper to create updated state duplicate
  FavoritesState copyWith({
    List<FavoritedDoctor>? all_favorites,
    List<FavoritedDoctor>? filtered_favorites,
    String? search_query,
    FavoriteSortOption? selected_sort,
    bool? is_loading,
  }) {
    return FavoritesState(
      all_favorites: all_favorites ?? this.all_favorites,
      filtered_favorites: filtered_favorites ?? this.filtered_favorites,
      search_query: search_query ?? this.search_query,
      selected_sort: selected_sort ?? this.selected_sort,
      is_loading: is_loading ?? this.is_loading,
    );
  }

  @override
  // Equatable props list for state comparison
  List<Object?> get props => [
        all_favorites,
        filtered_favorites,
        search_query,
        selected_sort,
        is_loading,
      ];
}

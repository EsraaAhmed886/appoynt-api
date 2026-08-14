/*
 * File Name: favorites_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart,
 *   package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Cubit managing state, real-time search filtering, sorting algorithms,
 *   and favorite toggling logic for the Favorites screen.
 */

// Import BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Import FavoritedDoctor domain entity
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart';
// Import FavoritesState and FavoriteSortOption definitions
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_state.dart';

// FavoritesCubit managing state transitions for the Favorites feature
class FavoritesCubit extends Cubit<FavoritesState> {
  // Constructor initializing with default initial state and launching initial load
  FavoritesCubit() : super(FavoritesState.initial()) {
    // Automatically load mock favorited doctors on creation
    load_favorites();
  }

  // Mock sample doctors dataset for initial state loading
  static final List<FavoritedDoctor> _mock_favorites = [
    FavoritedDoctor(
      id: 'doc_101',
      name: 'Dr. Sarah Jenkins',
      specialty: 'Cardiologist',
      location: 'New Cairo Medical Center',
      rating: 4.9,
      reviews_count: 124,
      fee: 450.0,
      is_available_today: true,
      is_favorite: true,
      avatar_url: 'https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    FavoritedDoctor(
      id: 'doc_102',
      name: 'Dr. Ahmed Hassan',
      specialty: 'Dermatologist',
      location: 'Maadi Health Specialist Clinic',
      rating: 4.8,
      reviews_count: 98,
      fee: 350.0,
      is_available_today: false,
      is_favorite: true,
      avatar_url: 'https://img.freepik.com/free-photo/doctor-offering-medical-advice_23-2148816172.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    FavoritedDoctor(
      id: 'doc_103',
      name: 'Dr. Mona El-Sayed',
      specialty: 'Neurologist',
      location: 'Heliopolis Specialist Hospital',
      rating: 4.95,
      reviews_count: 156,
      fee: 600.0,
      is_available_today: true,
      is_favorite: true,
      avatar_url: 'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827763.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    FavoritedDoctor(
      id: 'doc_104',
      name: 'Dr. Michael Chang',
      specialty: 'Orthopedic Surgeon',
      location: 'Zayed Bone & Joint Center',
      rating: 4.7,
      reviews_count: 84,
      fee: 500.0,
      is_available_today: true,
      is_favorite: true,
      avatar_url: 'https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-arms_409827-254.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    FavoritedDoctor(
      id: 'doc_105',
      name: 'Dr. Layla Mahmoud',
      specialty: 'Pediatrician',
      location: 'Dokki Children Hospital',
      rating: 4.85,
      reviews_count: 110,
      fee: 300.0,
      is_available_today: false,
      is_favorite: true,
      avatar_url: 'https://img.freepik.com/free-photo/front-view-female-doctor-with-medical-mask-stethoscope_23-2148847628.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  // Loads the list of favorited doctors and applies initial filter/sort
  void load_favorites() {
    // Set loading state
    emit(state.copyWith(is_loading: true));
    // Copy initial mock favorites list
    final List<FavoritedDoctor> initial_list = List.from(_mock_favorites);
    // Apply search filter and sorting algorithms
    final List<FavoritedDoctor> processed_list = _apply_filter_and_sort(
      all_items: initial_list,
      query: state.search_query,
      sort: state.selected_sort,
    );
    // Emit updated state with loaded favorites
    emit(state.copyWith(
      all_favorites: initial_list,
      filtered_favorites: processed_list,
      is_loading: false,
    ));
  }

  // Filters favorites list in real-time by search query
  void search_favorites(String query) {
    // Trim search query
    final String clean_query = query.trim();
    // Re-process list with updated search query
    final List<FavoritedDoctor> processed_list = _apply_filter_and_sort(
      all_items: state.all_favorites,
      query: clean_query,
      sort: state.selected_sort,
    );
    // Emit state update with filtered list
    emit(state.copyWith(
      search_query: clean_query,
      filtered_favorites: processed_list,
    ));
  }

  // Applies selected sorting option to the favorited doctors list
  void sort_favorites(FavoriteSortOption sort_option) {
    // Re-process list with new sort option
    final List<FavoritedDoctor> processed_list = _apply_filter_and_sort(
      all_items: state.all_favorites,
      query: state.search_query,
      sort: sort_option,
    );
    // Emit state update with selected sort option and updated list
    emit(state.copyWith(
      selected_sort: sort_option,
      filtered_favorites: processed_list,
    ));
  }

  // Toggles or removes a doctor from the favorited list dynamically
  void toggle_favorite(String doctor_id) {
    // Remove target doctor from master list
    final List<FavoritedDoctor> updated_all = state.all_favorites
        .where((doc) => doc.id != doctor_id)
        .toList();
    // Re-apply filter and sort to updated master list
    final List<FavoritedDoctor> processed_list = _apply_filter_and_sort(
      all_items: updated_all,
      query: state.search_query,
      sort: state.selected_sort,
    );
    // Emit updated state with doctor removed
    emit(state.copyWith(
      all_favorites: updated_all,
      filtered_favorites: processed_list,
    ));
  }

  // Internal helper function applying search filtering and sorting algorithms
  List<FavoritedDoctor> _apply_filter_and_sort({
    required List<FavoritedDoctor> all_items,
    required String query,
    required FavoriteSortOption sort,
  }) {
    // 1. Filter items by query string matching doctor name or specialty
    List<FavoritedDoctor> result = all_items;
    if (query.isNotEmpty) {
      final String lower_query = query.toLowerCase();
      result = result.where((doc) {
        final bool name_match = doc.name.toLowerCase().contains(lower_query);
        final bool specialty_match =
            doc.specialty.toLowerCase().contains(lower_query);
        return name_match || specialty_match;
      }).toList();
    } else {
      // Query is empty — retain all items
    }

    // 2. Sort filtered items according to selected FavoriteSortOption
    final List<FavoritedDoctor> sorted_list = List.from(result);
    switch (sort) {
      case FavoriteSortOption.recently_added:
        sorted_list.sort((a, b) => b.added_timestamp.compareTo(a.added_timestamp));
        break;
      case FavoriteSortOption.name_a_z:
        sorted_list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case FavoriteSortOption.name_z_a:
        sorted_list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case FavoriteSortOption.rating_high_low:
        sorted_list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case FavoriteSortOption.price_low_high:
        sorted_list.sort((a, b) => a.fee.compareTo(b.fee));
        break;
      case FavoriteSortOption.price_high_low:
        sorted_list.sort((a, b) => b.fee.compareTo(a.fee));
        break;
    }
    // Return processed list
    return sorted_list;
  }
}

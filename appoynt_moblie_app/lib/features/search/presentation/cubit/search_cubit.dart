/*
 * File Name: search_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart, dart:async,
 *   search_state.dart, search_history_item.dart, doctor_suggestion.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 21/08/2026]
 * File Description: Manages the search input query processing, filter sets, history storage, and suggestion states.
 */

// Import asynchronous timer support
import 'dart:async';
// Import BLoC state manager framework library
import 'package:flutter_bloc/flutter_bloc.dart';
// Import search history data entity schema
import 'package:appoynt_mobile_app/features/search/domain/entities/search_history_item.dart';
// Import doctor suggestion data entity schema
import 'package:appoynt_mobile_app/features/search/domain/entities/doctor_suggestion.dart';
// Import search state definitions class
import 'package:appoynt_mobile_app/features/search/presentation/cubit/search_state.dart';
// Import centralized doctor mock dataset
import 'package:appoynt_mobile_app/data/mock/doctor_mock_data.dart';

// Cubit executing search operations business logic rules
class SearchCubit extends Cubit<SearchState> {
  // Active debounce timer reference for api input throttle
  Timer? _debounce_timer;

  // Static mock doctor database records referenced from single source of truth
  static const List<DoctorSuggestion> _mock_doctors_database =
      DoctorMockData.mockDoctors;

  // Static mock locations data records list for filter selection
  static const List<Map<String, String>> mock_locations = [
    {"id": "loc_1", "name": "Nasr City : abbas el akad"},
    {"id": "loc_2", "name": "Cairo"},
    {"id": "loc_3", "name": "Alexandria"},
    {"id": "loc_4", "name": "Giza"},
  ];

  // Static mock specialties data records list for filter selection
  static const List<Map<String, String>> mock_specialties = [
    {"id": "spec_1", "name": "Dermatologist"},
    {"id": "spec_2", "name": "Cardiology"},
    {"id": "spec_3", "name": "Neurology"},
    {"id": "spec_4", "name": "Pediatrics"},
    {"id": "spec_5", "name": "Dentistry"},
    {"id": "spec_6", "name": "Ophthalmology"},
    {"id": "spec_7", "name": "Psychiatry"},
  ];

  // Constructor initializing starting parameters values representation
  SearchCubit() : super(SearchState.initial()) {
    // Trigger loading of initial history items list
    load_history();
  }

  // Initial loading operation seeding baseline search history list
  void load_history() {
    // Generate static mockup list items driven by database constraints schema
    final List<SearchHistoryItem> mock_history = [
      // Orthopedic Surgeon item representation
      SearchHistoryItem(
        // ID token
        id: "hist_1",
        // Query string
        query: "Orthopedic Surgeon",
        // Empty filters configuration
        filters: const SearchHistoryFilters(location_id: "", specialty_id: ""),
        // Creation timestamp value representation
        timestamp: DateTime.now().millisecondsSinceEpoch - 10000,
      ),
      // Dr. John Doe item representation
      SearchHistoryItem(
        // ID token
        id: "hist_2",
        // Query string
        query: "Dr. John Doe",
        // Empty filters configuration
        filters: const SearchHistoryFilters(location_id: "", specialty_id: ""),
        // Creation timestamp value representation
        timestamp: DateTime.now().millisecondsSinceEpoch - 50000,
      ),
    ];

    // Emit state updating history searches list
    emit(state.copyWith(
      // Bind recent searches property
      recent_searches: mock_history,
      // Default to history loaded status if query and all filters are currently empty
      status: true == state.query.isEmpty &&
              true == state.selected_location_id.isEmpty &&
              true == state.selected_specialty_id.isEmpty &&
              true == state.selected_gender.isEmpty &&
              true == state.selected_price_range.isEmpty &&
              true == state.selected_rating.isEmpty
          ? SearchStatus.historyLoaded
          : state.status,
    ));
  }

  // Activates search mode and prepares state
  void start_search() {
    // Determine whether history exists or should display pure initial state
    final SearchStatus next_status = true == state.recent_searches.isEmpty
        ? SearchStatus.initial
        : SearchStatus.historyLoaded;

    // Emit updated status preserving other state parameters
    emit(state.copyWith(
      status: next_status,
      show_filtered_results_explicitly: false,
    ));
  }

  // Helper method compiling results matching all search and filter criteria
  void _perform_search_and_filter() {
    // Check if query is active using Yoda comparison
    final bool has_query = true == state.query.isNotEmpty;
    // Check if any filters are active using Yoda comparisons
    final bool has_filters = true == state.selected_location_id.isNotEmpty ||
        true == state.selected_specialty_id.isNotEmpty ||
        true == state.selected_gender.isNotEmpty ||
        true == state.selected_price_range.isNotEmpty ||
        true == state.selected_rating.isNotEmpty;

    // Fallback to initial/history state if query and filters are empty
    if (false == has_query && false == has_filters) {
      emit(state.copyWith(
        suggestions: const [],
        status: true == state.recent_searches.isEmpty
            ? SearchStatus.initial
            : SearchStatus.historyLoaded,
      ));
      return;
    } else {
      // No action needed
    }

    // Check if query is empty and filters are set, but user hasn't explicitly clicked to show results (State C)
    if (false == has_query &&
        true == has_filters &&
        false == state.show_filtered_results_explicitly) {
      emit(state.copyWith(
        suggestions: const [],
        status: SearchStatus.filtersOnly,
      ));
      return;
    } else {
      // No action needed
    }

    // Start filtering from mock database list
    List<DoctorSuggestion> results = List.from(_mock_doctors_database);

    // 1. Filter by query matches (check name and specialty)
    if (true == has_query) {
      results = results.where((doc) {
        return doc.name.toLowerCase().contains(state.query.toLowerCase()) ||
            doc.specialty.toLowerCase().contains(state.query.toLowerCase());
      }).toList();
    } else {
      // No action needed
    }

    // 2. Filter by location matches
    if (true == state.selected_location_id.isNotEmpty) {
      results = results.where((doc) {
        return doc.location
            .toLowerCase()
            .contains(state.selected_location_id.toLowerCase());
      }).toList();
    } else {
      // No action needed
    }

    // 3. Filter by specialty matches
    if (true == state.selected_specialty_id.isNotEmpty) {
      results = results.where((doc) {
        return doc.specialty
            .toLowerCase()
            .contains(state.selected_specialty_id.toLowerCase());
      }).toList();
    } else {
      // No action needed
    }

    // 4. Filter by gender matches
    if (true == state.selected_gender.isNotEmpty) {
      results = results.where((doc) {
        return doc.gender.toLowerCase() == state.selected_gender.toLowerCase();
      }).toList();
    } else {
      // No action needed
    }

    // 5. Filter by price range matches
    if (true == state.selected_price_range.isNotEmpty) {
      results = results.where((doc) {
        if ("Under 100" == state.selected_price_range) {
          return doc.fee < 100;
        } else if ("100-200" == state.selected_price_range) {
          return doc.fee >= 100 && doc.fee <= 200;
        } else if ("200-500" == state.selected_price_range) {
          return doc.fee >= 200 && doc.fee <= 500;
        } else if ("Above 500" == state.selected_price_range) {
          return doc.fee > 500;
        } else {
          return true;
        }
      }).toList();
    } else {
      // No action needed
    }

    // 6. Filter by rating matches
    if (true == state.selected_rating.isNotEmpty) {
      results = results.where((doc) {
        if ("5 Stars" == state.selected_rating) {
          return doc.rating == 5.0;
        } else if ("4+ Stars" == state.selected_rating) {
          return doc.rating >= 4.0;
        } else if ("3+ Stars" == state.selected_rating) {
          return doc.rating >= 3.0;
        } else {
          return true;
        }
      }).toList();
    } else {
      // No action needed
    }

    // 7. Apply selected sorting option logic
    switch (state.selected_sort_option) {
      case SearchSortOption.recentlyAdded:
        // Sort by creation timestamp descending (newest first)
        results.sort((a, b) => b.created_at.compareTo(a.created_at));
        break;
      case SearchSortOption.nameAToZ:
        // Sort by name alphabetically ascending
        results.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case SearchSortOption.nameZToA:
        // Sort by name alphabetically descending
        results.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case SearchSortOption.ratingHighToLow:
        // Sort by rating score descending
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SearchSortOption.feeLowToHigh:
        // Sort by consultation fee ascending
        results.sort((a, b) => a.fee.compareTo(b.fee));
        break;
      case SearchSortOption.feeHighToLow:
        // Sort by consultation fee descending
        results.sort((a, b) => b.fee.compareTo(a.fee));
        break;
      default:
        break;
    }

    // Emit suggestionsLoaded if we have matching results, else empty
    if (true == results.isEmpty) {
      emit(state.copyWith(
        suggestions: const [],
        status: SearchStatus.empty,
      ));
    } else {
      emit(state.copyWith(
        suggestions: results,
        status: SearchStatus.suggestionsLoaded,
      ));
    }
  }

  // Triggers when user types search characters values options
  void on_query_changed(String raw_query) {
    // Normalize search query removing spaces and emojis
    final String normalized = _normalize_query(raw_query);

    // Cancel any active pending debounce timers to prevent race conditions
    _debounce_timer?.cancel();

    // Update the active query parameter in state immediately
    emit(state.copyWith(query: normalized));

    // Handle empty input queries representation scenarios
    if (true == normalized.isEmpty) {
      // Re-perform filtering immediately without debounce delay
      _perform_search_and_filter();
      // Return early to skip debouncing executions
      return;
    } else {
      // No action needed
    }

    // Abort search requests if character count is below minimum length threshold
    if (normalized.length < 2) {
      // Re-perform filtering immediately to clear query bounds but preserve filters
      _perform_search_and_filter();
      // Terminate execution flow
      return;
    } else {
      // No action needed
    }

    // Capture query instance locally to compare after async delay completes
    final String searched_query = normalized;

    // Initialize debounce timer scheduling api fetch delay (400 milliseconds)
    _debounce_timer = Timer(
      // Setup duration config parameter
      const Duration(
        // Debounce timer milliseconds count
        milliseconds: 400,
      ),
      () async {
        // Check if query hasn't changed using Yoda style check
        if (state.query != searched_query) {
          // Terminate stale request execution
          return;
        } else {
          // No action needed
        }

        // Emit loading status to trigger skeleton loader visual feedback
        emit(state.copyWith(status: SearchStatus.loading));

        // Simulate network API delay processing latency (400 milliseconds)
        await Future.delayed(
          // Setup duration config parameter
          const Duration(
            // Delay milliseconds count
            milliseconds: 400,
          ),
        );

        // Re-verify query string freshness after simulated latency completes
        if (state.query != searched_query) {
          // Abort stale response emission
          return;
        } else {
          // No action needed
        }

        // Simulate offline connection failure if query matches trigger words
        if ("offline" == searched_query.toLowerCase() ||
            "error" == searched_query.toLowerCase()) {
          // Emit network connection error state details
          emit(state.copyWith(
            // Set offline error status
            status: SearchStatus.offlineError,
            // Custom localized failure string representation
            error_message: "Network connection lost. Please try again.",
          ));
          // Stop execution
          return;
        } else {
          // No action needed
        }

        // Execute search filtering and sorting logic
        _perform_search_and_filter();
      },
    );
  }

  // Updates active Location filter parameter
  void select_location(String location_id) {
    // Emit modified Location identifier and reset explicit show results flag
    emit(state.copyWith(
      selected_location_id: location_id,
      show_filtered_results_explicitly: false,
    ));
    // Apply changes immediately
    _perform_search_and_filter();
  }

  // Updates active Specialty filter parameter
  void select_specialty(String specialty_id) {
    // Emit modified Specialty identifier and reset explicit show results flag
    emit(state.copyWith(
      selected_specialty_id: specialty_id,
      show_filtered_results_explicitly: false,
    ));
    // Apply changes immediately
    _perform_search_and_filter();
  }

  // Clears Location and Specialty filters, including advanced filters
  void clear_filters() {
    // Emit empty filter settings and reset explicit show results flag
    emit(state.copyWith(
      // Clear location
      selected_location_id: "",
      // Clear specialty
      selected_specialty_id: "",
      // Clear gender selection
      selected_gender: "",
      // Clear price range selection
      selected_price_range: "",
      // Clear rating selection
      selected_rating: "",
      show_filtered_results_explicitly: false,
    ));
    // Apply changes immediately
    _perform_search_and_filter();
  }

  // Updates and applies advanced filters criteria set
  void apply_advanced_filters({
    required String gender,
    required String price_range,
    required String rating,
  }) {
    // Emit modified advanced filter settings and reset explicit show results flag
    emit(state.copyWith(
      selected_gender: gender,
      selected_price_range: price_range,
      selected_rating: rating,
      show_filtered_results_explicitly: false,
    ));
    // Apply changes immediately
    _perform_search_and_filter();
  }

  // Explicitly triggers transition from filters-only state to suggestions/results list (State C to State B)
  void reveal_filtered_results() {
    // Set explicit show results flag to true
    emit(state.copyWith(show_filtered_results_explicitly: true));
    // Run search filtering logic to populate Suggestions list
    _perform_search_and_filter();
  }

  // Updates and applies selected sort option
  void select_sort_option(SearchSortOption option) {
    // Emit modified sorting option
    emit(state.copyWith(selected_sort_option: option));
    // Re-apply filtering and sorting logic
    _perform_search_and_filter();
  }

  // Toggles the favorite flag of a mock doctor in the database and updates state results
  void toggle_favorite(String doctor_id) {
    // We can update the status of the doctor in our mock suggestions results list
    final List<DoctorSuggestion> updated_suggestions =
        state.suggestions.map((doc) {
      if (doc.doctor_id == doctor_id) {
        return DoctorSuggestion(
          doctor_id: doc.doctor_id,
          name: doc.name,
          avatar_url: doc.avatar_url,
          specialty: doc.specialty,
          location: doc.location,
          rating: doc.rating,
          reviews_count: doc.reviews_count,
          fee: doc.fee,
          is_available_today: doc.is_available_today,
          is_favorite: !doc.is_favorite,
          gender: doc.gender,
          created_at: doc.created_at,
        );
      } else {
        return doc;
      }
    }).toList();

    emit(state.copyWith(suggestions: updated_suggestions));
  }

  // Saves current query string and filters to persistent history list
  void save_search_to_history(String query_text) {
    // Trim input value
    final String trimmed = query_text.trim();
    // Block saving empty queries
    if (true == trimmed.isEmpty) {
      // Terminate action
      return;
    } else {
      // No action needed
    }

    // Copy current history searches array
    final List<SearchHistoryItem> updated_list =
        List.from(state.recent_searches);

    // Look up matching query indexes having same query text and filters
    final int existing_index = updated_list.indexWhere((item) {
      // Return true if criteria fields match using Yoda comparisons
      return item.query.toLowerCase() == trimmed.toLowerCase() &&
          item.filters.location_id == state.selected_location_id &&
          item.filters.specialty_id == state.selected_specialty_id;
    });

    // Remove duplicates if found to allow rearranging to top (BR-23)
    if (-1 != existing_index) {
      // Delete existing item index
      updated_list.removeAt(existing_index);
    } else {
      // No action needed
    }

    // Insert new history item at index 0 (top-most priority recent search)
    updated_list.insert(
      0,
      SearchHistoryItem(
        // Assign ID using timestamp string
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        // Bind trimmed query
        query: trimmed,
        // Bind active filter configuration options
        filters: SearchHistoryFilters(
          location_id: state.selected_location_id,
          specialty_id: state.selected_specialty_id,
        ),
        // Assign current epoch timestamp value
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    // Enforce history retention threshold limit of 10 items (BR-22)
    if (updated_list.length > 10) {
      // Evict oldest history entry from end of array
      updated_list.removeLast();
    } else {
      // No action needed
    }

    // Emit updated searches array list
    emit(state.copyWith(recent_searches: updated_list));
  }

  // Displays clear confirmation alert dialogue overlay modal
  void clear_history() {
    // Set visibility flag true in state
    emit(state.copyWith(is_confirm_modal_visible: true));
  }

  // Confirms clear history action, purging recent searches list
  void confirm_clear_history() {
    // Clear recent searches list and reset visibility flags
    emit(state.copyWith(
      // Purge history searches
      recent_searches: const [],
      // Hide modal dialogue overlay
      is_confirm_modal_visible: false,
      // If search query is currently empty, return to initial page state
      status: true == state.query.isEmpty &&
              true == state.selected_location_id.isEmpty &&
              true == state.selected_specialty_id.isEmpty
          ? SearchStatus.initial
          : state.status,
    ));
  }

  // Dismisses clear history confirmation dialog without modifications
  void cancel_clear_history() {
    // Set visibility flag false in state
    emit(state.copyWith(is_confirm_modal_visible: false));
  }

  // Deletes an individual history item row selection (BR-21)
  void delete_history_item(String item_id) {
    // Copy current history searches array
    final List<SearchHistoryItem> updated_list =
        List.from(state.recent_searches);
    // Remove item matching unique ID token
    updated_list.removeWhere((item) {
      // Evaluate ID matching
      return item.id == item_id;
    });

    // Emit updated array list
    emit(state.copyWith(
      // Bind modified list
      recent_searches: updated_list,
      // Fallback to initial status if list becomes empty and query is blank
      status: true == updated_list.isEmpty &&
              true == state.query.isEmpty &&
              true == state.selected_location_id.isEmpty &&
              true == state.selected_specialty_id.isEmpty
          ? SearchStatus.initial
          : state.status,
    ));
  }

  // Executes search from historical search items list row tap
  void execute_history_search(SearchHistoryItem item) {
    // Set query string and filter values parameters
    emit(state.copyWith(
      // Set input query text
      query: item.query,
      // Re-apply history location setting
      selected_location_id: item.filters.location_id,
      // Re-apply history specialty setting
      selected_specialty_id: item.filters.specialty_id,
    ));
    // Trigger suggestions search execution
    on_query_changed(item.query);
  }

  // Retries query search after simulating an offline failure
  void retry_search() {
    // Refresh query matching search logic
    on_query_changed(state.query);
  }

  // Helper function cleaning raw query texts
  String _normalize_query(String raw_query) {
    // Trim leading/trailing blank spaces
    String cleaned = raw_query.trim();
    // Replace multiple sequential spacing gaps with single spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    // Strip emojis and unsupported graphics characters to prevent rendering crashes
    cleaned = cleaned.replaceAll(
      // Regex grouping target emoji character unicode ranges
      RegExp(
          r'[\u{1F600}-\u{1F64F}|\u{1F300}-\u{1F5FF}|\u{1F680}-\u{1F6FF}|\u{2600}-\u{26FF}|\u{2700}-\u{27BF}]',
          unicode: true),
      // Replace target matches with empty strings
      "",
    );
    // Return normalized search query string
    return cleaned;
  }

  @override
  // Clean up debounce timers upon closing cubit block
  Future<void> close() {
    // Cancel active debouncing tasks
    _debounce_timer?.cancel();
    // Return parent close future execution
    return super.close();
  }
}

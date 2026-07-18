/*
 * File Name: search_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart, dart:async,
 *   search_state.dart, search_history_item.dart, doctor_suggestion.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
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

// Cubit executing search operations business logic rules
class SearchCubit extends Cubit<SearchState> {
  // Active debounce timer reference for api input throttle
  Timer? _debounce_timer;

  // Static mock doctor database records driven by design schemas
  static const List<Map<String, String>> _mock_doctors_database = [
    {
      "doctorId": "doc_1",
      "name": "Dr. Sarah Chen",
      "avatarUrl": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=150&auto=format&fit=crop",
    },
    {
      "doctorId": "doc_2",
      "name": "Dr. Samuel Lee",
      "avatarUrl": "https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=150&auto=format&fit=crop",
    },
    {
      "doctorId": "doc_3",
      "name": "Dr. Sophie Dubois",
      "avatarUrl": "https://images.unsplash.com/photo-1594824813573-246434de83fb?q=80&w=150&auto=format&fit=crop",
    },
    {
      "doctorId": "doc_4",
      "name": "Dr. Susan Al-Fayed",
      "avatarUrl": "https://images.unsplash.com/photo-1527613426441-4da17471b66d?q=80&w=150&auto=format&fit=crop",
    },
    {
      "doctorId": "doc_5",
      "name": "Dr. Sebastian Keller",
      "avatarUrl": "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=150&auto=format&fit=crop",
    },
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
      // Default to history loaded status if query is currently empty
      status: true == state.query.isEmpty && true == state.selected_location_id.isEmpty && true == state.selected_specialty_id.isEmpty
          ? SearchStatus.historyLoaded
          : state.status,
    ));
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
      // Check if location or specialty filters remain active using Yoda style check
      if (true == state.selected_location_id.isNotEmpty || true == state.selected_specialty_id.isNotEmpty) {
        // Emit filters-only state status trigger
        emit(state.copyWith(
          // Reset recommendations list
          suggestions: const [],
          // Set filters-only status representation
          status: SearchStatus.filtersOnly,
        ));
      } else {
        // Else fall back to displaying search history list
        emit(state.copyWith(
          // Reset recommendations list
          suggestions: const [],
          // Set history loaded status representation
          status: SearchStatus.historyLoaded,
        ));
      }
      // Return early to skip debouncing executions
      return;
    }

    // Abort search requests if character count is below minimum length threshold
    if (normalized.length < 2) {
      // Reset recommendations list but preserve input value
      emit(state.copyWith(suggestions: const []));
      // Terminate execution flow
      return;
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
        // Check if query hasn't changed before emitting loading state to verify request freshness
        if (state.query != searched_query) {
          // Terminate stale request execution
          return;
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
        }

        // Simulate offline connection failure if query matches trigger words
        if ("offline" == searched_query.toLowerCase() || "error" == searched_query.toLowerCase()) {
          // Emit network connection error state details
          emit(state.copyWith(
            // Set offline error status
            status: SearchStatus.offlineError,
            // Custom localized failure string representation
            error_message: "Network connection lost. Please try again.",
          ));
          // Stop execution
          return;
        }

        // Initialize matching suggestions list
        final List<DoctorSuggestion> matching_suggestions = [];

        // Loop through local mock database records to perform query matching
        for (final Map<String, String> doc in _mock_doctors_database) {
          // Resolve doctor name value
          final String doc_name = doc["name"] ?? "";
          // Resolve doctor ID token
          final String doc_id = doc["doctorId"] ?? "";
          // Resolve avatar image resource link
          final String doc_avatar = doc["avatarUrl"] ?? "";

          // Perform case-insensitive containment match check
          if (true == doc_name.toLowerCase().contains(searched_query.toLowerCase())) {
            // Append suggestion mapping schema parameters
            matching_suggestions.add(
              // Instantiate suggestions entity representation
              DoctorSuggestion(
                // Bind ID
                doctor_id: doc_id,
                // Bind name
                name: doc_name,
                // Bind avatar Url
                avatar_url: doc_avatar,
              ),
            );
          }
        }

        // Check if matching suggestions returned empty elements using Yoda style check
        if (true == matching_suggestions.isEmpty) {
          // Emit empty results state
          emit(state.copyWith(
            // Reset suggestions
            suggestions: const [],
            // Set empty results status representation
            status: SearchStatus.empty,
          ));
        } else {
          // Emit suggestions loaded status list
          emit(state.copyWith(
            // Bind resolved items list
            suggestions: matching_suggestions,
            // Set success status representation
            status: SearchStatus.suggestionsLoaded,
          ));
        }
      },
    );
  }

  // Updates active Location filter parameter
  void select_location(String location_id) {
    // Emit modified Location identifier
    emit(state.copyWith(selected_location_id: location_id));
    // Re-trigger query lookup to apply filter constraints update
    on_query_changed(state.query);
  }

  // Updates active Specialty filter parameter
  void select_specialty(String specialty_id) {
    // Emit modified Specialty identifier
    emit(state.copyWith(selected_specialty_id: specialty_id));
    // Re-trigger query lookup to apply filter constraints update
    on_query_changed(state.query);
  }

  // Clears Location and Specialty filters, including advanced filters
  void clear_filters() {
    // Emit empty filter settings
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
    ));
    // Refresh search results
    on_query_changed(state.query);
  }

  // Updates and applies advanced filters criteria set
  void apply_advanced_filters({
    required String gender,
    required String price_range,
    required String rating,
  }) {
    // Emit modified advanced filter settings
    emit(state.copyWith(
      selected_gender: gender,
      selected_price_range: price_range,
      selected_rating: rating,
    ));
    // Re-trigger query lookup to apply filter constraints update
    on_query_changed(state.query);
  }

  // Saves current query string and filters to persistent history list
  void save_search_to_history(String query_text) {
    // Trim input value
    final String trimmed = query_text.trim();
    // Block saving empty queries
    if (true == trimmed.isEmpty) {
      // Terminate action
      return;
    }

    // Copy current history searches array
    final List<SearchHistoryItem> updated_list = List.from(state.recent_searches);

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
      status: true == state.query.isEmpty && true == state.selected_location_id.isEmpty && true == state.selected_specialty_id.isEmpty
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
    final List<SearchHistoryItem> updated_list = List.from(state.recent_searches);
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
      status: true == updated_list.isEmpty && true == state.query.isEmpty && true == state.selected_location_id.isEmpty && true == state.selected_specialty_id.isEmpty
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
      RegExp(r'[\u{1F600}-\u{1F64F}|\u{1F300}-\u{1F5FF}|\u{1F680}-\u{1F6FF}|\u{2600}-\u{26FF}|\u{2700}-\u{27BF}]', unicode: true),
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

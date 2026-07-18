/*
 * File Name: search_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart,
 *   search_history_item.dart, doctor_suggestion.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
 * File Description: Defines the SearchState and status enum representing search screen scenarios.
 */

// Import Equatable for value comparison support
import 'package:equatable/equatable.dart';
// Import history entity definition
import 'package:appoynt_mobile_app/features/search/domain/entities/search_history_item.dart';
// Import suggestion entity definition
import 'package:appoynt_mobile_app/features/search/domain/entities/doctor_suggestion.dart';

// Enum representing the active presentation status of the search feature
enum SearchStatus {
  // Screen mounted, showing initial states
  initial,
  // Executing api request, showing loading skeleton
  loading,
  // Displaying active history searches list (State A)
  historyLoaded,
  // Displaying matching suggestions doctor cards (State B)
  suggestionsLoaded,
  // Displaying view results callout when filters are set but query is empty (State C)
  filtersOnly,
  // Suggestion list returned zero matching records
  empty,
  // Simulating connection failure error state
  offlineError,
}

// Immutable state model containing search criteria and suggestion parameters
class SearchState extends Equatable {
  // Current raw search input text
  final String query;
  // Selected location criteria identifier
  final String selected_location_id;
  // Selected specialty criteria identifier
  final String selected_specialty_id;
  // Selected doctor gender filter value
  final String selected_gender;
  // Selected consultation price range filter value
  final String selected_price_range;
  // Selected doctor rating filter value
  final String selected_rating;
  // List of search history items retrieved from store
  final List<SearchHistoryItem> recent_searches;
  // Autocomplete doctor suggestions list
  final List<DoctorSuggestion> suggestions;
  // Active state indicator status enum value
  final SearchStatus status;
  // Flag indicating if clear history confirmation dialog overlay is shown
  final bool is_confirm_modal_visible;
  // Descriptive warning text representing failed requests
  final String error_message;

  // Constant constructor initializing immutable properties
  const SearchState({
    required this.query,
    required this.selected_location_id,
    required this.selected_specialty_id,
    required this.selected_gender,
    required this.selected_price_range,
    required this.selected_rating,
    required this.recent_searches,
    required this.suggestions,
    required this.status,
    required this.is_confirm_modal_visible,
    required this.error_message,
  });

  // Factory constructor generating baseline initial states
  factory SearchState.initial() {
    // Return default initial search state configuration values
    return const SearchState(
      // Empty input query
      query: '',
      // Empty location constraint filter
      selected_location_id: '',
      // Empty specialty constraint filter
      selected_specialty_id: '',
      // Empty gender filter
      selected_gender: '',
      // Empty price range filter
      selected_price_range: '',
      // Empty rating filter
      selected_rating: '',
      // Empty recent history searches list
      recent_searches: [],
      // Empty autocomplete doctor suggestion list
      suggestions: [],
      // Default initial state
      status: SearchStatus.initial,
      // Overlay modal set invisible
      is_confirm_modal_visible: false,
      // Empty alert warning messages
      error_message: '',
    );
  }

  // Generates state copies applying selective property modifications
  SearchState copyWith({
    String? query,
    String? selected_location_id,
    String? selected_specialty_id,
    String? selected_gender,
    String? selected_price_range,
    String? selected_rating,
    List<SearchHistoryItem>? recent_searches,
    List<DoctorSuggestion>? suggestions,
    SearchStatus? status,
    bool? is_confirm_modal_visible,
    String? error_message,
  }) {
    // Return newly instantiated copy using fallback options
    return SearchState(
      // Map query string value
      query: query ?? this.query,
      // Map location constraint criteria
      selected_location_id: selected_location_id ?? this.selected_location_id,
      // Map specialty constraint criteria
      selected_specialty_id: selected_specialty_id ?? this.selected_specialty_id,
      // Map gender filter selection
      selected_gender: selected_gender ?? this.selected_gender,
      // Map price range filter selection
      selected_price_range: selected_price_range ?? this.selected_price_range,
      // Map rating filter selection
      selected_rating: selected_rating ?? this.selected_rating,
      // Map historical searches list
      recent_searches: recent_searches ?? this.recent_searches,
      // Map suggestion results list
      suggestions: suggestions ?? this.suggestions,
      // Map presentation state enum indicator
      status: status ?? this.status,
      // Map modal display flag
      is_confirm_modal_visible: is_confirm_modal_visible ?? this.is_confirm_modal_visible,
      // Map error details text
      error_message: error_message ?? this.error_message,
    );
  }

  @override
  // Map properties list to evaluate value-based equality comparison
  List<Object?> get props {
    return [
      query,
      selected_location_id,
      selected_specialty_id,
      selected_gender,
      selected_price_range,
      selected_rating,
      recent_searches,
      suggestions,
      status,
      is_confirm_modal_visible,
      error_message,
    ];
  }
}

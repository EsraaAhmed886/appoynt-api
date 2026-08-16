/*
 * File Name: search_history_item.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the SearchHistoryItem entity mapping persistent query records.
 */

// Import Equatable for value-based comparisons
import 'package:equatable/equatable.dart';

// Represents filter attributes applied during a search query history item
class SearchHistoryFilters extends Equatable {
  // Location identifier string representation
  final String location_id;
  // Specialty identifier string representation
  final String specialty_id;

  // Constant constructor initializing final properties representation
  const SearchHistoryFilters({
    required this.location_id,
    required this.specialty_id,
  });

  @override
  // Map properties list to evaluate value-based equality comparison
  List<Object?> get props {
    return [
      location_id,
      specialty_id,
    ];
  }
}

// Entity mapping a historical search query made by the patient user
class SearchHistoryItem extends Equatable {
  // Unique database identifier for the history entry representation
  final String id;
  // Raw text string value query executed
  final String query;
  // Filter settings associated with the query history item
  final SearchHistoryFilters filters;
  // Unix timestamp value representing creation epoch details
  final int timestamp;

  // Constant constructor initializing final properties representation
  const SearchHistoryItem({
    required this.id,
    required this.query,
    required this.filters,
    required this.timestamp,
  });

  @override
  // Map properties list to evaluate value-based equality comparison
  List<Object?> get props {
    return [
      id,
      query,
      filters,
      timestamp,
    ];
  }
}

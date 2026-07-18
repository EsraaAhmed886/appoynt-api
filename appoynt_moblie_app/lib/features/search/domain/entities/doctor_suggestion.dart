/*
 * File Name: doctor_suggestion.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 18/07/2026]
 * File Description: Defines the DoctorSuggestion entity representing search autocomplete and results items.
 */

// Import Equatable for value-based comparisons
import 'package:equatable/equatable.dart';

// Entity mapping doctor details returned for autocompletion lists and search results cards
class DoctorSuggestion extends Equatable {
  // Unique database identifier representing the doctor record
  final String doctor_id;
  // Display name string representation for the physician
  final String name;
  // Public avatar thumbnail picture URL address
  final String avatar_url;
  // Specialization field (e.g. Dermatologist)
  final String specialty;
  // Practice location details (e.g. Nasr City : abbas el akad)
  final String location;
  // Average customer rating score
  final double rating;
  // Total patient reviews count
  final int reviews_count;
  // Consultation booking fee amount
  final int fee;
  // Indicator status flag representing same-day availability
  final bool is_available_today;
  // Indicator flag representing patient favorites list status
  final bool is_favorite;
  // Doctor gender classification (Male/Female)
  final String gender;
  // Creation timestamp in epoch milliseconds (for sorting by recently added)
  final int created_at;

  // Constant constructor initializing suggest doctor instances
  const DoctorSuggestion({
    required this.doctor_id,
    required this.name,
    required this.avatar_url,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews_count,
    required this.fee,
    required this.is_available_today,
    required this.is_favorite,
    required this.gender,
    required this.created_at,
  });

  @override
  // Map properties list to evaluate value-based equality comparison
  List<Object?> get props {
    return [
      doctor_id,
      name,
      avatar_url,
      specialty,
      location,
      rating,
      reviews_count,
      fee,
      is_available_today,
      is_favorite,
      gender,
      created_at,
    ];
  }
}

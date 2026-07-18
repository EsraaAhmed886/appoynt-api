/*
 * File Name: doctor_suggestion.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
 * File Description: Defines the DoctorSuggestion entity representing search autocompletion items.
 */

// Import Equatable for value-based comparisons
import 'package:equatable/equatable.dart';

// Entity mapping doctor details returned for autocompletion lists
class DoctorSuggestion extends Equatable {
  // Unique database identifier representing the doctor record
  final String doctor_id;
  // Display name string representation for the physician
  final String name;
  // Public avatar thumbnail picture URL address
  final String avatar_url;

  // Constant constructor initializing suggest doctor instances
  const DoctorSuggestion({
    required this.doctor_id,
    required this.name,
    required this.avatar_url,
  });

  @override
  // Map properties list to evaluate value-based equality comparison
  List<Object?> get props {
    return [
      doctor_id,
      name,
      avatar_url,
    ];
  }
}

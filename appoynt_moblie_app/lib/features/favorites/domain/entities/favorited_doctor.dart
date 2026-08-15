/*
 * File Name: favorited_doctor.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Domain entity model representing a favorited doctor record.
 *   V1.1.0 adds the is_active flag to support Phase 7 inactive doctor guards.
 */

// Import Equatable for value comparison support
import 'package:equatable/equatable.dart';

// FavoritedDoctor entity model class
class FavoritedDoctor extends Equatable {
  // Unique doctor identifier
  final String id;
  // Doctor full name
  final String name;
  // Medical specialty / specialization name
  final String specialty;
  // Practice location address string
  final String location;
  // Doctor star rating (e.g. 4.8)
  final double rating;
  // Total reviews count
  final int reviews_count;
  // Consultation fee / price in EGP
  final double fee;
  // Flag indicating if doctor is available today
  final bool is_available_today;
  // Flag indicating active practicing status
  final bool is_active;
  // Flag indicating favorited state (defaults to true)
  final bool is_favorite;
  // Avatar photo network URL
  final String avatar_url;
  // Timestamp when added to favorites for recent sorting
  final DateTime added_timestamp;

  // Constructor assigning all member variables
  const FavoritedDoctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews_count,
    required this.fee,
    required this.is_available_today,
    this.is_active = true,
    this.is_favorite = true,
    required this.avatar_url,
    required this.added_timestamp,
  });

  // CopyWith helper method to duplicate entity with field overrides
  FavoritedDoctor copyWith({
    String? id,
    String? name,
    String? specialty,
    String? location,
    double? rating,
    int? reviews_count,
    double? fee,
    bool? is_available_today,
    bool? is_active,
    bool? is_favorite,
    String? avatar_url,
    DateTime? added_timestamp,
  }) {
    return FavoritedDoctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviews_count: reviews_count ?? this.reviews_count,
      fee: fee ?? this.fee,
      is_available_today: is_available_today ?? this.is_available_today,
      is_active: is_active ?? this.is_active,
      is_favorite: is_favorite ?? this.is_favorite,
      avatar_url: avatar_url ?? this.avatar_url,
      added_timestamp: added_timestamp ?? this.added_timestamp,
    );
  }

  @override
  // Equatable props list for value comparison
  List<Object?> get props => [
        id,
        name,
        specialty,
        location,
        rating,
        reviews_count,
        fee,
        is_available_today,
        is_active,
        is_favorite,
        avatar_url,
        added_timestamp,
      ];
}


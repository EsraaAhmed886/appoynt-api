/*
 * File Name: favorited_clinic.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Domain entity model representing a favorited clinic record.
 */

// Import Equatable for value comparison support
import 'package:equatable/equatable.dart';

// FavoritedClinic entity model class
class FavoritedClinic extends Equatable {
  // Unique clinic identifier
  final String id;
  // Clinic name
  final String name;
  // Available medical specialties or service departments list
  final List<String> specialties;
  // Physical address string
  final String address;
  // Star rating (e.g. 4.9)
  final double rating;
  // Total patient reviews count
  final int reviews_count;
  // Contact phone number
  final String phone_number;
  // Flag indicating if clinic is currently active/open
  final bool is_active;
  // Flag indicating favorited status
  final bool is_favorite;
  // Clinic exterior or logo image network URL
  final String image_url;
  // Timestamp when added to favorites for recent sorting
  final DateTime added_timestamp;

  // Constructor assigning all member variables
  const FavoritedClinic({
    required this.id,
    required this.name,
    required this.specialties,
    required this.address,
    required this.rating,
    required this.reviews_count,
    required this.phone_number,
    this.is_active = true,
    this.is_favorite = true,
    required this.image_url,
    required this.added_timestamp,
  });

  // CopyWith helper method to duplicate entity with field overrides
  FavoritedClinic copyWith({
    String? id,
    String? name,
    List<String>? specialties,
    String? address,
    double? rating,
    int? reviews_count,
    String? phone_number,
    bool? is_active,
    bool? is_favorite,
    String? image_url,
    DateTime? added_timestamp,
  }) {
    return FavoritedClinic(
      id: id ?? this.id,
      name: name ?? this.name,
      specialties: specialties ?? this.specialties,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      reviews_count: reviews_count ?? this.reviews_count,
      phone_number: phone_number ?? this.phone_number,
      is_active: is_active ?? this.is_active,
      is_favorite: is_favorite ?? this.is_favorite,
      image_url: image_url ?? this.image_url,
      added_timestamp: added_timestamp ?? this.added_timestamp,
    );
  }

  @override
  // Equatable props list for value comparison
  List<Object?> get props => [
        id,
        name,
        specialties,
        address,
        rating,
        reviews_count,
        phone_number,
        is_active,
        is_favorite,
        image_url,
        added_timestamp,
      ];
}

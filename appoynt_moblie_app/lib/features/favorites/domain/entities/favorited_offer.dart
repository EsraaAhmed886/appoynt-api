/*
 * File Name: favorited_offer.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Domain entity model representing a favorited medical offer.
 */

// Import Equatable for value comparison support
import 'package:equatable/equatable.dart';

// FavoritedOffer entity model class
class FavoritedOffer extends Equatable {
  // Unique offer identifier
  final String id;
  // Offer promotional title
  final String title;
  // Provider / clinic / hospital name
  final String provider_name;
  // Discount percentage (e.g. 25 for 25% OFF)
  final int discount_percentage;
  // Original consultation or procedure price in EGP
  final double original_price;
  // Discounted final price in EGP
  final double discounted_price;
  // Expiry date of the promotional offer
  final DateTime expiry_date;
  // Flag indicating if offer is expired
  final bool is_expired;
  // Flag indicating favorited status
  final bool is_favorite;
  // Image or promo banner network URL
  final String image_url;
  // Timestamp when added to favorites for recent sorting
  final DateTime added_timestamp;

  // Constructor assigning all member variables
  const FavoritedOffer({
    required this.id,
    required this.title,
    required this.provider_name,
    required this.discount_percentage,
    required this.original_price,
    required this.discounted_price,
    required this.expiry_date,
    required this.is_expired,
    this.is_favorite = true,
    required this.image_url,
    required this.added_timestamp,
  });

  // CopyWith helper method to duplicate entity with field overrides
  FavoritedOffer copyWith({
    String? id,
    String? title,
    String? provider_name,
    int? discount_percentage,
    double? original_price,
    double? discounted_price,
    DateTime? expiry_date,
    bool? is_expired,
    bool? is_favorite,
    String? image_url,
    DateTime? added_timestamp,
  }) {
    return FavoritedOffer(
      id: id ?? this.id,
      title: title ?? this.title,
      provider_name: provider_name ?? this.provider_name,
      discount_percentage: discount_percentage ?? this.discount_percentage,
      original_price: original_price ?? this.original_price,
      discounted_price: discounted_price ?? this.discounted_price,
      expiry_date: expiry_date ?? this.expiry_date,
      is_expired: is_expired ?? this.is_expired,
      is_favorite: is_favorite ?? this.is_favorite,
      image_url: image_url ?? this.image_url,
      added_timestamp: added_timestamp ?? this.added_timestamp,
    );
  }

  @override
  // Equatable props list for value comparison
  List<Object?> get props => [
        id,
        title,
        provider_name,
        discount_percentage,
        original_price,
        discounted_price,
        expiry_date,
        is_expired,
        is_favorite,
        image_url,
        added_timestamp,
      ];
}

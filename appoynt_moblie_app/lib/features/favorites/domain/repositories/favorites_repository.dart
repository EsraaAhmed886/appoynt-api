/*
 * File Name: favorites_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: favorited_doctor.dart, favorited_offer.dart, favorited_clinic.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Domain repository interface declaring the contract for
 *   fetching, paginating, removing, and clearing favorited items across all categories.
 */

// Import domain entities
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_offer.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_clinic.dart';

// Abstract contract for Favorites repository
abstract class FavoritesRepository {
  // Retrieves paginated list of favorited doctors
  Future<List<FavoritedDoctor>> getFavoriteDoctors({
    required int page,
    required int page_size,
  });

  // Retrieves paginated list of favorited offers
  Future<List<FavoritedOffer>> getFavoriteOffers({
    required int page,
    required int page_size,
  });

  // Retrieves paginated list of favorited clinics
  Future<List<FavoritedClinic>> getFavoriteClinics({
    required int page,
    required int page_size,
  });

  // Removes a doctor from favorites via backend confirmation
  Future<void> removeFavoriteDoctor(String doctor_id);

  // Removes an offer from favorites via backend confirmation
  Future<void> removeFavoriteOffer(String offer_id);

  // Removes a clinic from favorites via backend confirmation
  Future<void> removeFavoriteClinic(String clinic_id);

  // Purges all cached favorite records for session/user isolation
  Future<void> clearFavoritesCache();
}

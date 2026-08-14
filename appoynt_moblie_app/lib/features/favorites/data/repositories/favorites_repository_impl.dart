/*
 * File Name: favorites_repository_impl.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: favorites_repository.dart, favorites_remote_data_source.dart,
 *   favorites_local_data_source.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Implements the FavoritesRepository interface coordinating remote
 *   data source queries with local cache isolation and session cleanup.
 */

// Import domain entities
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_offer.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_clinic.dart';
// Import domain repository interface
import 'package:appoynt_mobile_app/features/favorites/domain/repositories/favorites_repository.dart';
// Import data source dependencies
import 'package:appoynt_mobile_app/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:appoynt_mobile_app/features/favorites/data/datasources/favorites_local_data_source.dart';

// Concrete repository implementation for Favorites
class FavoritesRepositoryImpl implements FavoritesRepository {
  // Remote data source dependency
  final FavoritesRemoteDataSource remote_data_source;
  // Local data source dependency
  final FavoritesLocalDataSource local_data_source;

  // Constructor injecting dependencies
  const FavoritesRepositoryImpl({
    required this.remote_data_source,
    required this.local_data_source,
  });

  @override
  // Retrieves paginated list of favorited doctors from remote backend
  Future<List<FavoritedDoctor>> getFavoriteDoctors({
    required int page,
    required int page_size,
  }) async {
    final List<FavoritedDoctor> results =
        await remote_data_source.getFavoriteDoctors(
      page: page,
      page_size: page_size,
    );
    await local_data_source.saveLastSyncTimestamp('doctors', DateTime.now());
    return results;
  }

  @override
  // Retrieves paginated list of favorited offers from remote backend
  Future<List<FavoritedOffer>> getFavoriteOffers({
    required int page,
    required int page_size,
  }) async {
    final List<FavoritedOffer> results =
        await remote_data_source.getFavoriteOffers(
      page: page,
      page_size: page_size,
    );
    await local_data_source.saveLastSyncTimestamp('offers', DateTime.now());
    return results;
  }

  @override
  // Retrieves paginated list of favorited clinics from remote backend
  Future<List<FavoritedClinic>> getFavoriteClinics({
    required int page,
    required int page_size,
  }) async {
    final List<FavoritedClinic> results =
        await remote_data_source.getFavoriteClinics(
      page: page,
      page_size: page_size,
    );
    await local_data_source.saveLastSyncTimestamp('clinics', DateTime.now());
    return results;
  }

  @override
  // Removes doctor from favorites with backend confirmation
  Future<void> removeFavoriteDoctor(String doctor_id) async {
    await remote_data_source.removeFavoriteDoctor(doctor_id);
  }

  @override
  // Removes offer from favorites with backend confirmation
  Future<void> removeFavoriteOffer(String offer_id) async {
    await remote_data_source.removeFavoriteOffer(offer_id);
  }

  @override
  // Removes clinic from favorites with backend confirmation
  Future<void> removeFavoriteClinic(String clinic_id) async {
    await remote_data_source.removeFavoriteClinic(clinic_id);
  }

  @override
  // Purges all local favorites cache to prevent cross-account data leakage
  Future<void> clearFavoritesCache() async {
    await local_data_source.clearAllFavoritesCache();
  }
}

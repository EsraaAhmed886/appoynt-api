/*
 * File Name: upload_profile_photo_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 13/08/2026
 * Version Information: V1.0.0
 * Dependencies: profile_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 13/08/2026]
 * File Description: Domain use case responsible for uploading the patient''s
 *   profile photo to the remote server via the ProfileRepository contract.
 *   Accepts a local file path string, delegates the multipart upload to the
 *   repository layer, and returns the resolved network URL of the stored image.
 *   Keeps the cubit layer decoupled from the repository layer per Clean
 *   Architecture SRP (Single Responsibility Principle).
 */

// Importing the profile repository domain contract for dependency inversion
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';

// Use case responsible for uploading a patient profile photo to the server
class UploadProfilePhotoUseCase {
  // Profile repository dependency injected via constructor
  final ProfileRepository repository;

  // Constructor mapping the required profile repository dependency
  const UploadProfilePhotoUseCase(this.repository);

  // Executes the profile photo upload business action.
  // Accepts the local file path of the picked image and returns the
  // resolved network URL string of the stored server-side image.
  Future<String> call(
    // The absolute local file system path of the selected image file
    String file_path,
  ) async {
    // Delegate multipart upload execution to the repository implementation
    // which coordinates the remote API call and local URL cache persistence
    return await repository.uploadProfilePhoto(file_path);
  }
}

/*
 * File Name: delete_profile_photo_usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Domain use case responsible for deleting the patient's
 *   profile photo on the remote server and clearing the local cache via ProfileRepository.
 */

// Importing the profile repository domain contract for dependency inversion
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';

// Use case responsible for deleting a patient profile photo from the server and cache
class DeleteProfilePhotoUseCase {
  // Profile repository dependency injected via constructor
  final ProfileRepository repository;

  // Constructor mapping the required profile repository dependency
  const DeleteProfilePhotoUseCase(this.repository);

  // Executes the profile photo deletion business action.
  Future<void> call() async {
    // Delegate photo deletion to repository implementation
    await repository.deleteProfilePhoto();
  }
}

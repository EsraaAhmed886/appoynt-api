/*
 * File Name: edit_profile_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: dart:io
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Defines the immutable state representation for the Edit Profile
 *   flow, holding the locally staged profile image file, photo deletion flag, and async statuses.
 */

import 'dart:io';

class EditProfileState {
  final File? stagedProfileImage;
  final bool isPhotoDeleted;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const EditProfileState({
    this.stagedProfileImage,
    this.isPhotoDeleted = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  EditProfileState copyWith({
    File? stagedProfileImage,
    bool? isPhotoDeleted,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool clearStagedImage = false,
  }) {
    return EditProfileState(
      stagedProfileImage: clearStagedImage
          ? null
          : (stagedProfileImage ?? this.stagedProfileImage),
      isPhotoDeleted: isPhotoDeleted ?? this.isPhotoDeleted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? false,
    );
  }
}

/*
 * File Name: edit_profile_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.1.0
 * Dependencies: dart:io, package:flutter/painting.dart,
 *   package:flutter_bloc/flutter_bloc.dart, package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Cubit managing the Edit Profile flow by staging photo picks and deletions
 *   locally in state, updating the backend and local cache on save, and clearing stale image cache.
 */

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepository profileRepository;
  final ImagePicker _picker = ImagePicker();

  EditProfileCubit({required this.profileRepository})
      : super(const EditProfileState());

  // 1. Pick Image (Gallery / Camera) - LOCAL STAGING ONLY
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (null != pickedFile) {
        emit(state.copyWith(
          stagedProfileImage: File(pickedFile.path),
          isPhotoDeleted: false,
        ));
      } else {
        // User cancelled image selection
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to select image. Please try again.',
      ));
    }
  }

  // 2. Stage Photo Removal - LOCAL STAGING ONLY
  void stagePhotoDeletion() {
    emit(state.copyWith(
      clearStagedImage: true,
      isPhotoDeleted: true,
    ));
  }

  // 3. Save All Profile Changes (Text fields + Staged Image)
  Future<void> saveProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? address,
    String? nationalId,
    String? birthDate,
  }) async {
    // 1. Capture the staged image before any async state mutation
    final File? imageToUpload = state.stagedProfileImage;
    final bool shouldDelete = state.isPhotoDeleted;

    debugPrint(
      '[EditProfileCubit] Attempting to save profile. Staged image path: ${imageToUpload?.path}, shouldDelete: $shouldDelete',
    );

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await profileRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        nationalId: nationalId,
        birthDate: birthDate,
        imageFile: imageToUpload,
        deleteCurrentPhoto: shouldDelete,
      );

      // Invalidate image cache so UI immediately displays new avatar without restart
      try {
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
      } catch (_) {
        // Safe fallback in headless/unit test environments
      }

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        clearStagedImage: true,
      ));
    } catch (failure) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.toString(),
      ));
    }
  }
}

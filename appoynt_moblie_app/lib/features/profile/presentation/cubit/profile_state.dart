/*
 * File Name: profile_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.4.0
 * Dependencies: dart:io, package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart,
 *   user_profile_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Defines the states and subclasses for the Patient Profile
 *   BLoC/Cubit pattern. V1.4.0 adds staged_profile_image and is_photo_deleted
 *   fields to support local staging of image changes until explicit save.
 */

import 'dart:io';
// Importing the PatientProfile domain entity
import 'package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart';
// Importing UserProfileModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';

// Represents the state status enumeration options
enum ProfileStatus {
  // Initial state before action begins
  initial,
  // Fetching profile details from mock repo/backend
  loading,
  // Successful data loading completed
  success,
  // Loading failure occurred
  error,
  // Submitting update payload
  updating,
  // Successful update completed
  updateSuccess,
  // Update payload submission failed
  updateError,
  // Password validation/update in progress
  passwordUpdating,
  // Password updated successfully
  passwordSuccess,
  // Password update failed
  passwordError,
  // Profile avatar photo upload in progress
  avatarUploading,
  // Profile avatar photo upload completed successfully
  avatarUploadSuccess,
  // Profile avatar photo upload failed with error
  avatarUploadError,
  // Profile avatar photo deletion in progress
  avatarDeleting,
  // Profile avatar photo deletion completed successfully
  avatarDeleteSuccess,
  // Profile avatar photo deletion failed with error
  avatarDeleteError,
}

// State class representation for Profile feature block operations
class ProfileState {
  // Active status tracker value
  final ProfileStatus status;
  // Patient details model representing saved backend record
  final PatientProfile profile;
  // Temp draft model representation during editing
  final PatientProfile temp_profile;
  // Error label string description for alerts
  final String? error_message;
  // Dirty flag status mapping unsaved edits comparison
  final bool is_dirty;
  // Locally staged profile image file in memory before save
  final File? staged_profile_image;
  // Flag indicating current photo has been staged for deletion
  final bool is_photo_deleted;

  // Convenience camelCase getters
  File? get stagedProfileImage => staged_profile_image;
  bool get isPhotoDeleted => is_photo_deleted;

  // Constructor mapping the variables
  const ProfileState({
    required this.status,
    required this.profile,
    required this.temp_profile,
    this.error_message,
    required this.is_dirty,
    this.staged_profile_image,
    this.is_photo_deleted = false,
  });

  // Factory constructor representing the default starting state layout config
  factory ProfileState.initial() {
    // Return initial status with empty profile representations
    return ProfileState(
      // Bind status parameter
      status: ProfileStatus.initial,
      // Map empty profile structure
      profile: PatientProfile.empty(),
      // Map empty profile layout structures draft
      temp_profile: PatientProfile.empty(),
      // Null error message representation
      error_message: null,
      // False flag defaults
      is_dirty: false,
      staged_profile_image: null,
      is_photo_deleted: false,
    );
  }

  // Generate a duplicate state instance overriding properties
  ProfileState copyWith({
    // Optional status update
    ProfileStatus? status,
    // Optional profile update
    PatientProfile? profile,
    // Optional temp_profile update
    PatientProfile? temp_profile,
    // Optional error_message update
    String? error_message,
    // Optional dirty flag update
    bool? is_dirty,
    // Optional staged image file update
    File? staged_profile_image,
    File? stagedProfileImage,
    // Optional photo deleted flag update
    bool? is_photo_deleted,
    bool? isPhotoDeleted,
    // Clear staged image flag
    bool clear_staged_image = false,
    bool clearStagedImage = false,
  }) {
    final bool should_clear_staged = clear_staged_image || clearStagedImage;
    final File? resolved_staged = should_clear_staged
        ? null
        : (staged_profile_image ??
            stagedProfileImage ??
            this.staged_profile_image);

    // Return new copy of state representation instance
    return ProfileState(
      // Apply status override or keep current state value
      status: status ?? this.status,
      // Apply profile override or keep current profile instance
      profile: profile ?? this.profile,
      // Apply temp draft override or keep current draft instance
      temp_profile: temp_profile ?? this.temp_profile,
      // Apply error message override or keep current description
      error_message: error_message ?? this.error_message,
      // Apply dirty status override or keep current flag
      is_dirty: is_dirty ?? this.is_dirty,
      staged_profile_image: resolved_staged,
      is_photo_deleted:
          is_photo_deleted ?? isPhotoDeleted ?? this.is_photo_deleted,
    );
  }
}

// State representing the loading state when fetching profile
class ProfileLoading extends ProfileState {
  // Constructor forwarding parameters to base state
  const ProfileLoading({
    required super.profile,
    required super.temp_profile,
    required super.is_dirty,
  }) : super(status: ProfileStatus.loading);
}

// State representing successful fetch of user profile data
class ProfileLoaded extends ProfileState {
  // The retrieved user profile data model
  final UserProfileModel user;

  // Constructor taking user profile model and forwarding default parameters to base state
  const ProfileLoaded({
    required this.user,
    required super.profile,
    required super.temp_profile,
    required super.is_dirty,
  }) : super(status: ProfileStatus.success);
}

// State representing profile update submission in progress
class ProfileUpdating extends ProfileState {
  // Constructor forwarding parameters to base state
  const ProfileUpdating({
    required super.profile,
    required super.temp_profile,
    required super.is_dirty,
    super.staged_profile_image,
    super.is_photo_deleted,
  }) : super(status: ProfileStatus.updating);
}

// State representing successful profile update operation
class ProfileUpdateSuccess extends ProfileState {
  // Optional updated UserProfileModel reference
  final UserProfileModel? user;

  // Constructor forwarding parameters to base state
  const ProfileUpdateSuccess({
    this.user,
    required super.profile,
    required super.temp_profile,
    required super.is_dirty,
  }) : super(status: ProfileStatus.updateSuccess);
}

// State representing profile update failure operation
class ProfileUpdateError extends ProfileState {
  // The error message received
  final String message;

  // Constructor mapping the message and forwarding parameters to base state
  const ProfileUpdateError({
    required this.message,
    required super.profile,
    required super.temp_profile,
    required super.is_dirty,
  }) : super(
          status: ProfileStatus.updateError,
          error_message: message,
        );
}

// State representing successful profile avatar removal operation
class ProfilePhotoDeleted extends ProfileState {
  // Constructor forwarding default parameters to base state
  const ProfilePhotoDeleted({
    required super.profile,
    required super.temp_profile,
    required super.is_dirty,
  }) : super(status: ProfileStatus.avatarDeleteSuccess);
}

// Alias for photo removed state
typedef EditProfilePhotoRemovedState = ProfilePhotoDeleted;

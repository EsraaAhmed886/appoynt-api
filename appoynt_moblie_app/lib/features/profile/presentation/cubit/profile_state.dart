/*
 * File Name: profile_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart,
 *   user_profile_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 13/08/2026]
 * File Description: Defines the states and subclasses for the Patient Profile
 *   BLoC/Cubit pattern. V1.2.0 adds avatarUploading, avatarUploadSuccess,
 *   and avatarUploadError enum values to support the profile image upload flow.
 */

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

  // Constructor mapping the variables
  const ProfileState({
    required this.status,
    required this.profile,
    required this.temp_profile,
    this.error_message,
    required this.is_dirty,
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
  }) {
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
  }) : super(status: ProfileStatus.updating);
}

// State representing successful profile update operation
class ProfileUpdateSuccess extends ProfileState {
  // Constructor forwarding parameters to base state
  const ProfileUpdateSuccess({
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

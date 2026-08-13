/*
 * File Name: user_profile_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.2.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 13/08/2026]
 * File Description: Data Transfer Object (DTO) for the User Profile. Handles
 *   JSON serialization and mapping. V1.2.0 adds the has_profile_photo boolean
 *   field sourced from the PatientProfileResponse schema.
 */

// Model representing user profile data with JSON serialization
class UserProfileModel {
  // Unique identifier of the user
  final String id;
  // Email address of the user
  final String email;
  // First name of the user
  final String first_name;
  // Last name of the user
  final String last_name;
  // Phone number of the user
  final String phone_number;
  // Gender representation (0 for Male, 1 for Female, or null if unset)
  final int? gender;
  // Date of birth formatted as YYYY-MM-DD
  final String? date_of_birth;
  // Physical address details
  final String? address;
  // Optional patient-scoped ID returned from backend GET profile response
  final String? patient_id;
  // Flag indicating whether the patient has an uploaded profile photo on server
  final bool has_profile_photo;

  // Constructor initializing all member variables
  const UserProfileModel({
    required this.id,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.phone_number,
    this.gender,
    this.date_of_birth,
    this.address,
    this.patient_id,
    // Default to false when the field is absent
    this.has_profile_photo = false,
  });

  // Factory constructor to instantiate model from a JSON map
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Return UserProfileModel with mapped properties
    return UserProfileModel(
      // Map id claim — check both 'id' (GET /patients/profile) and legacy key
      id: json['id'] as String? ?? '',
      // Map email claim
      email: json['email'] as String? ?? '',
      // Map firstName claim
      first_name: json['firstName'] as String? ?? '',
      // Map lastName claim
      last_name: json['lastName'] as String? ?? '',
      // Map phoneNumber claim
      phone_number: json['phoneNumber'] as String? ?? '',
      // Map gender enum value
      gender: json['gender'] as int?,
      // Map dateOfBirth string (Swagger key: birthDate or dateOfBirth)
      date_of_birth: json['dateOfBirth'] as String?
          ?? json['birthDate'] as String?,
      // Map address details
      address: json['address'] as String?,
      // Map optional patient_id from backend API claim
      patient_id: json['patient_id'] as String?
          ?? json['pid'] as String?,
      // Map hasProfilePhoto boolean flag from PatientProfileResponse schema
      has_profile_photo: json['hasProfilePhoto'] as bool? ?? false,
    );
  }

  // Converts the UserProfileModel instance into a JSON map
  Map<String, dynamic> toJson() {
    // Return JSON map representation
    return {
      // Map id parameter
      'id': id,
      // Map email parameter
      'email': email,
      // Map firstName parameter
      'firstName': first_name,
      // Map lastName parameter
      'lastName': last_name,
      // Map phoneNumber parameter
      'phoneNumber': phone_number,
      // Map gender parameter
      'gender': gender,
      // Map dateOfBirth parameter
      'dateOfBirth': date_of_birth,
      // Map address parameter
      'address': address,
      // Map optional patient_id parameter
      'patient_id': patient_id,
      // Map hasProfilePhoto boolean flag for cache persistence
      'hasProfilePhoto': has_profile_photo,
    };
  }

  // Creates a copy of the model with optional field overrides
  UserProfileModel copyWith({
    // Optional id override
    String? id,
    // Optional email override
    String? email,
    // Optional first_name override
    String? first_name,
    // Optional last_name override
    String? last_name,
    // Optional phone_number override
    String? phone_number,
    // Optional gender override
    int? gender,
    // Optional date_of_birth override
    String? date_of_birth,
    // Optional address override
    String? address,
    // Optional patient_id override
    String? patient_id,
    // Optional has_profile_photo override
    bool? has_profile_photo,
  }) {
    // Return new instance with applied overrides
    return UserProfileModel(
      // Apply id override or keep current
      id: id ?? this.id,
      // Apply email override or keep current
      email: email ?? this.email,
      // Apply first_name override or keep current
      first_name: first_name ?? this.first_name,
      // Apply last_name override or keep current
      last_name: last_name ?? this.last_name,
      // Apply phone_number override or keep current
      phone_number: phone_number ?? this.phone_number,
      // Apply gender override or keep current
      gender: gender ?? this.gender,
      // Apply date_of_birth override or keep current
      date_of_birth: date_of_birth ?? this.date_of_birth,
      // Apply address override or keep current
      address: address ?? this.address,
      // Apply patient_id override or keep current
      patient_id: patient_id ?? this.patient_id,
      // Apply has_profile_photo override or keep current
      has_profile_photo: has_profile_photo ?? this.has_profile_photo,
    );
  }
}

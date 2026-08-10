/*
 * File Name: user_profile_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Data Transfer Object (DTO) for the User Profile. Handles JSON serialization and mapping.
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
  });

  // Factory constructor to instantiate model from a JSON map
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Return UserProfileModel with mapped properties
    return UserProfileModel(
      // Map id claim
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
      // Map dateOfBirth string
      date_of_birth: json['dateOfBirth'] as String?,
      // Map address details
      address: json['address'] as String?,
      // Map optional patient_id from backend API claim
      patient_id: json['patient_id'] as String?,
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
    };
  }
}

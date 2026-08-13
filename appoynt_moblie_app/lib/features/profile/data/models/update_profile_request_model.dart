/*
 * File Name: update_profile_request_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Defines the DTO model for the PUT profile update API request.
 */

// Importing UserProfileModel for enum conversion helpers
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';

// Model representing update request body for user profile
class UpdateProfileRequestModel {
  // First name value to set
  final String first_name;
  // Last name value to set
  final String last_name;
  // Gender value (0 for Male, 1 for Female)
  final int? gender;
  // Date of birth value (YYYY-MM-DD)
  final String? date_of_birth;
  // Physical address text details
  final String? address;
  // National ID 14-digit SSN string
  final String? national_id;
  // Patient body weight in KG
  final String? weight;
  // Patient body height in CM
  final String? height;
  // Patient blood group category string
  final String? blood_group;

  // Constructor mapping members
  const UpdateProfileRequestModel({
    required this.first_name,
    required this.last_name,
    this.gender,
    this.date_of_birth,
    this.address,
    this.national_id,
    this.weight,
    this.height,
    this.blood_group,
  });

  // Converts the request object variables into a JSON-compliant map format
  Map<String, dynamic> toJson() {
    // Return parameters matching Swagger UpdateUserRequest / PatientProfile expected properties
    return {
      // Map firstName
      'firstName': first_name,
      // Map lastName
      'lastName': last_name,
      // Map gender enum
      'gender': gender,
      // Map birthDate (expected property) and dateOfBirth (legacy alias)
      'birthDate': date_of_birth,
      'dateOfBirth': date_of_birth,
      // Map address
      'address': address,
      // Map nationalId / ssn
      'nationalId': national_id,
      // Map weightKg (expected property) and weight (legacy alias)
      'weightKg': null != weight && weight!.isNotEmpty ? double.tryParse(weight!) ?? weight : null,
      'weight': weight,
      // Map heightCm (expected property) and height (legacy alias)
      'heightCm': null != height && height!.isNotEmpty ? double.tryParse(height!) ?? height : null,
      'height': height,
      // Map bloodGroup enum integer (0..7) or string
      'bloodGroup': UserProfileModel.bloodGroupToInt(blood_group) ?? blood_group,
    };
  }
}

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

  // Constructor mapping members
  const UpdateProfileRequestModel({
    required this.first_name,
    required this.last_name,
    this.gender,
    this.date_of_birth,
    this.address,
  });

  // Converts the request object variables into a JSON-compliant map format
  Map<String, dynamic> toJson() {
    // Return parameters matching Swagger UpdateUserRequest fields
    return {
      // Map firstName
      'firstName': first_name,
      // Map lastName
      'lastName': last_name,
      // Map gender enum
      'gender': gender,
      // Map dateOfBirth
      'dateOfBirth': date_of_birth,
      // Map address
      'address': address,
    };
  }
}

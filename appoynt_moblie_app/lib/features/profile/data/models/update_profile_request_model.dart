/*
 * File Name: update_profile_request_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.4.0
 * Dependencies: package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 31/08/2026]
 * File Description: Defines the DTO model for the PUT /api/patients/profile API request
 *   structuring address as an object matching UpdateAddressDto with governorateId and cityId GUIDs.
 */

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
  // Selected governorate GUID string
  final String? governorate_id;
  // Selected city GUID string
  final String? city_id;

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
    this.governorate_id,
    this.city_id,
  });

  // Converts the request object variables into a JSON-compliant map format matching ASP.NET backend
  Map<String, dynamic> toJson() {
    final double? weightVal = null != weight && weight!.trim().isNotEmpty
        ? double.tryParse(weight!.trim().replaceAll(',', '.'))
        : null;
    final double? heightVal = null != height && height!.trim().isNotEmpty
        ? double.tryParse(height!.trim().replaceAll(',', '.'))
        : null;

    final Map<String, dynamic> data = {
      'firstName': first_name.trim(),
      'lastName': last_name.trim(),
    };

    if (gender != null) {
      data['gender'] = gender;
    } else {
      // No action needed
    }

    if (date_of_birth != null && date_of_birth!.trim().isNotEmpty) {
      data['birthDate'] = date_of_birth!.trim();
    } else {
      // No action needed
    }

    // Structure address as an UpdateAddressDto object with governorateId and cityId
    if (governorate_id != null &&
        governorate_id!.trim().isNotEmpty &&
        governorate_id != 'null' &&
        city_id != null &&
        city_id!.trim().isNotEmpty &&
        city_id != 'null') {
      data['address'] = {
        'governorateId': governorate_id!.trim(),
        'cityId': city_id!.trim(),
      };
    } else if (address != null && address!.trim().isNotEmpty) {
      data['address'] = address!.trim();
    } else {
      // No action needed
    }

    if (national_id != null && national_id!.trim().isNotEmpty) {
      data['nationalId'] = national_id!.trim();
    } else {
      // No action needed
    }

    if (weightVal != null && weightVal > 0) {
      data['weight'] = weightVal;
      data['weightKg'] = weightVal;
    } else {
      // No action needed
    }

    if (heightVal != null && heightVal > 0) {
      data['height'] = heightVal;
      data['heightCm'] = heightVal;
    } else {
      // No action needed
    }

    if (blood_group != null && blood_group!.trim().isNotEmpty) {
      final int? bgInt = UserProfileModel.bloodGroupToInt(blood_group);
      data['bloodGroup'] = bgInt ?? 0;
    } else {
      // No action needed
    }

    return data;
  }
}

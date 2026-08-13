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
  // National ID 14-digit SSN string
  final String? national_id;
  // Patient body weight in KG
  final String? weight;
  // Patient body height in CM
  final String? height;
  // Patient blood group category string
  final String? blood_group;

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
    this.national_id,
    this.weight,
    this.height,
    this.blood_group,
  });

  /// Converts a blood group string (e.g. 'A+', 'B-') or int to a standard enum int (0..7)
  static int? bloodGroupToInt(dynamic val) {
    if (null == val) return null;
    if (val is int) return val;
    final String str = val.toString().trim().replaceAll(' ', '').toUpperCase();
    switch (str) {
      case 'A+':
      case '0':
      case 'APOSITIVE':
        return 0;
      case 'A-':
      case '1':
      case 'ANEGATIVE':
        return 1;
      case 'B+':
      case '2':
      case 'BPOSITIVE':
        return 2;
      case 'B-':
      case '3':
      case 'BNEGATIVE':
        return 3;
      case 'AB+':
      case '4':
      case 'ABPOSITIVE':
        return 4;
      case 'AB-':
      case '5':
      case 'ABNEGATIVE':
        return 5;
      case 'O+':
      case '6':
      case 'OPOSITIVE':
        return 6;
      case 'O-':
      case '7':
      case 'ONEGATIVE':
        return 7;
      default:
        return int.tryParse(str);
    }
  }

  /// Converts a backend blood group representation (int 0..7 or String) into 'A+', 'B-', etc.
  static String intToBloodGroup(dynamic val) {
    if (null == val) return '';
    if (val is int) {
      switch (val) {
        case 0: return 'A+';
        case 1: return 'A-';
        case 2: return 'B+';
        case 3: return 'B-';
        case 4: return 'AB+';
        case 5: return 'AB-';
        case 6: return 'O+';
        case 7: return 'O-';
        default: return '';
      }
    }
    final String s = val.toString().trim();
    final int? parsed = int.tryParse(s);
    if (null != parsed) {
      return intToBloodGroup(parsed);
    } else {
      return s;
    }
  }

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
      // Map birthDate string (check birthDate first, then dateOfBirth)
      date_of_birth: json['birthDate'] as String?
          ?? json['dateOfBirth'] as String?,
      // Map address details
      address: json['address'] as String?,
      // Map optional patient_id from backend API claim
      patient_id: json['patient_id'] as String?
          ?? json['pid'] as String?
          ?? json['patientId'] as String?,
      // Map hasProfilePhoto boolean flag from PatientProfileResponse schema
      has_profile_photo: json['hasProfilePhoto'] as bool? ?? false,
      // Map nationalId / ssn string
      national_id: json['nationalId'] as String?
          ?? json['ssn'] as String?
          ?? json['national_id'] as String?,
      // Map weight string or number (check weightKg first, then weight)
      weight: json['weightKg']?.toString()
          ?? json['weight']?.toString(),
      // Map height string or number (check heightCm first, then height)
      height: json['heightCm']?.toString()
          ?? json['height']?.toString(),
      // Map bloodGroup enum int (0..7) or string to UI label e.g. "B+"
      blood_group: UserProfileModel.intToBloodGroup(
        json['bloodGroup'] ?? json['blood_group'],
      ),
    );
  }

  // Converts the UserProfileModel instance into a JSON map
  Map<String, dynamic> toJson() {
    // Return JSON map representation matching ASP.NET API expected keys
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
      // Map birthDate and dateOfBirth parameter
      'birthDate': date_of_birth,
      'dateOfBirth': date_of_birth,
      // Map address parameter
      'address': address,
      // Map optional patient_id parameter
      'patient_id': patient_id,
      // Map hasProfilePhoto boolean flag for cache persistence
      'hasProfilePhoto': has_profile_photo,
      // Map nationalId for serialization
      'nationalId': national_id,
      // Map weightKg and weight parameter
      'weightKg': null != weight && weight!.isNotEmpty ? double.tryParse(weight!) ?? weight : null,
      'weight': weight,
      // Map heightCm and height parameter
      'heightCm': null != height && height!.isNotEmpty ? double.tryParse(height!) ?? height : null,
      'height': height,
      // Map bloodGroup enum integer (0..7) or string
      'bloodGroup': UserProfileModel.bloodGroupToInt(blood_group),
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
    // Optional national_id override
    String? national_id,
    // Optional weight override
    String? weight,
    // Optional height override
    String? height,
    // Optional blood_group override
    String? blood_group,
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
      // Apply national_id override or keep current
      national_id: national_id ?? this.national_id,
      // Apply weight override or keep current
      weight: weight ?? this.weight,
      // Apply height override or keep current
      height: height ?? this.height,
      // Apply blood_group override or keep current
      blood_group: blood_group ?? this.blood_group,
    );
  }
}

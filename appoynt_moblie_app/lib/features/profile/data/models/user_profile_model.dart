/*
 * File Name: user_profile_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 09/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Data Transfer Object (DTO) for the User/Patient Profile. Handles
 *   resilient, defensive JSON deserialization for nested Map objects (governorate, city, bloodGroup, user)
 *   and String ID/Name combinations from ASP.NET Core backend endpoints.
 */

import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';

// Model representing user and patient profile data with defensive JSON serialization
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
  // Patient blood group category string (e.g., 'A+', 'B-')
  final String? blood_group;
  // Foreign key identifier for selected governorate
  final String? governorate_id;
  // English/Arabic display name for governorate
  final String? governorate_name;
  // Foreign key identifier for selected city
  final String? city_id;
  // English/Arabic display name for city
  final String? city_name;
  // Parsed GovernorateModel entity object
  final GovernorateModel? governorate;
  // Parsed CityModel entity object
  final CityModel? city;
  // Profile picture URL from backend
  final String? photo_url;

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
    this.has_profile_photo = false,
    this.national_id,
    this.weight,
    this.height,
    this.blood_group,
    this.governorate_id,
    this.governorate_name,
    this.city_id,
    this.city_name,
    this.governorate,
    this.city,
    this.photo_url,
  });

  // Convenient camelCase property aliases
  String get firstName => first_name;
  String get lastName => last_name;
  String get phoneNumber => phone_number;
  String get phone => phone_number;
  String? get nationalId => national_id;
  String? get dateOfBirth => date_of_birth;
  String? get birthDate => date_of_birth;
  DateTime? get parsedBirthDate =>
      date_of_birth != null ? DateTime.tryParse(date_of_birth!) : null;
  String? get patientId => patient_id;
  bool get hasProfilePhoto => has_profile_photo;
  String? get bloodGroup => blood_group;
  String? get governorateId => governorate_id;
  String? get governorateName => governorate_name;
  String? get cityId => city_id;
  String? get cityName => city_name;
  String? get photoUrl => photo_url;

  /// Converts a blood group string (e.g. 'A+', 'B-') or int to a standard enum int (0..7)
  static int? bloodGroupToInt(dynamic val) {
    if (null == val) {
      return null;
    } else {
      // No action needed
    }
    if (val is int) {
      return val;
    } else {
      // No action needed
    }
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

  /// Converts a backend blood group representation (int 0..7 or String or Map) into 'A+', 'B-', etc.
  static String intToBloodGroup(dynamic val) {
    if (null == val) {
      return '';
    } else {
      // No action needed
    }
    if (val is Map) {
      final dynamic name = val['name'] ?? val['type'] ?? val['label'];
      if (name != null) {
        return intToBloodGroup(name);
      } else {
        return '';
      }
    } else {
      // No action needed
    }
    if (val is int) {
      switch (val) {
        case 0:
          return 'A+';
        case 1:
          return 'A-';
        case 2:
          return 'B+';
        case 3:
          return 'B-';
        case 4:
          return 'AB+';
        case 5:
          return 'AB-';
        case 6:
          return 'O+';
        case 7:
          return 'O-';
        default:
          return '';
      }
    } else {
      // No action needed
    }
    final String s = val.toString().trim();
    final int? parsed = int.tryParse(s);
    if (null != parsed) {
      return intToBloodGroup(parsed);
    } else {
      return s;
    }
  }

  /// Internal helper to parse gender dynamically from int, string, or enum representations
  static int? _parseGender(dynamic val) {
    if (val == null) {
      return null;
    } else {
      // No action needed
    }
    if (val is int) {
      return val;
    } else {
      // No action needed
    }
    final String str = val.toString().trim().toLowerCase();
    if (str == '0' || str == 'male' || str == 'm' || str == 'ذكر') {
      return 0;
    } else if (str == '1' || str == 'female' || str == 'f' || str == 'أنثى') {
      return 1;
    } else {
      // Fallback parse
    }
    return int.tryParse(str);
  }

  // Factory constructor to instantiate model from a JSON map with defensive parsing
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // If backend wraps the patient payload inside a 'data', 'result', or 'patient' key
    final Map<String, dynamic> root = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : (json['patient'] is Map<String, dynamic>
            ? json['patient'] as Map<String, dynamic>
            : (json['result'] is Map<String, dynamic>
                ? json['result'] as Map<String, dynamic>
                : json));

    // Nested user map fallback if identity data is in root['user']
    final Map<String, dynamic>? userMap = root['user'] is Map<String, dynamic>
        ? root['user'] as Map<String, dynamic>
        : null;

    // -------------------------------------------------------------------------
    // Safe Governorate Parsing (Handles both Object Map and String ID/Name)
    // -------------------------------------------------------------------------
    GovernorateModel? parsedGov;
    String? govId;
    String? govName;

    if (root['governorate'] is Map<String, dynamic>) {
      parsedGov =
          GovernorateModel.fromJson(root['governorate'] as Map<String, dynamic>);
      govId = parsedGov.id;
      govName = parsedGov.nameEn.isNotEmpty ? parsedGov.nameEn : parsedGov.nameAr;
    } else if (root['governorate'] is String) {
      govName = root['governorate'] as String;
    } else if (root['governorate'] != null) {
      govName = root['governorate'].toString();
    } else {
      // No action needed
    }
    govId ??= root['governorateId']?.toString() ?? root['governorate_id']?.toString();

    // -------------------------------------------------------------------------
    // Safe City Parsing (Handles both Object Map and String ID/Name)
    // -------------------------------------------------------------------------
    CityModel? parsedCity;
    String? cId;
    String? cName;

    if (root['city'] is Map<String, dynamic>) {
      parsedCity = CityModel.fromJson(root['city'] as Map<String, dynamic>);
      cId = parsedCity.id;
      cName = parsedCity.nameEn.isNotEmpty ? parsedCity.nameEn : parsedCity.nameAr;
    } else if (root['city'] is String) {
      cName = root['city'] as String;
    } else if (root['city'] != null) {
      cName = root['city'].toString();
    } else {
      // No action needed
    }
    cId ??= root['cityId']?.toString() ?? root['city_id']?.toString();

    // -------------------------------------------------------------------------
    // Safe Blood Group Parsing
    // -------------------------------------------------------------------------
    final String parsedBloodGroup = UserProfileModel.intToBloodGroup(
      root['bloodGroup'] ?? root['blood_group'],
    );

    // -------------------------------------------------------------------------
    // Safe Date of Birth Parsing
    // -------------------------------------------------------------------------
    String? rawDob;
    if (root['birthDate'] != null) {
      rawDob = root['birthDate'].toString();
    } else if (root['dateOfBirth'] != null) {
      rawDob = root['dateOfBirth'].toString();
    } else if (root['dob'] != null) {
      rawDob = root['dob'].toString();
    } else {
      // No action needed
    }

    // -------------------------------------------------------------------------
    // Safe Address Parsing (Handles String or composed Governorate/City)
    // -------------------------------------------------------------------------
    String? parsedAddress;
    if (root['address'] is String) {
      parsedAddress = root['address'] as String;
    } else if (root['address'] is Map) {
      // Compose from nested map if available
      final Map<dynamic, dynamic> addrMap = root['address'] as Map;
      final String? street = addrMap['street']?.toString();
      final String? c = addrMap['city']?.toString() ?? cName;
      final String? g = addrMap['governorate']?.toString() ?? govName;
      final parts = [street, c, g].where((p) => p != null && p.isNotEmpty).toList();
      if (parts.isNotEmpty) {
        parsedAddress = parts.join(', ');
      } else {
        // No action needed
      }
    } else {
      // No action needed
    }
    if ((parsedAddress == null || parsedAddress.isEmpty) && govName != null) {
      parsedAddress = cName != null ? '$cName, $govName' : govName;
    } else {
      // No action needed
    }

    // -------------------------------------------------------------------------
    // Safe Photo URL & Has Photo Flag
    // -------------------------------------------------------------------------
    final String? parsedPhotoUrl = (root['profilePictureUrl'] ??
            root['photoUrl'] ??
            root['avatar'] ??
            root['avatarUrl'] ??
            root['pictureUrl'])
        ?.toString();

    final bool parsedHasPhoto = root['hasProfilePhoto'] is bool
        ? root['hasProfilePhoto'] as bool
        : (parsedPhotoUrl != null && parsedPhotoUrl.isNotEmpty);

    return UserProfileModel(
      id: (root['id'] ?? root['userId'] ?? root['patientId'] ?? userMap?['id'])
              ?.toString() ??
          '',
      email: (root['email'] ?? userMap?['email'])?.toString() ?? '',
      first_name: (root['firstName'] ??
                  root['first_name'] ??
                  userMap?['firstName'] ??
                  userMap?['first_name'])
              ?.toString() ??
          '',
      last_name: (root['lastName'] ??
                  root['last_name'] ??
                  userMap?['lastName'] ??
                  userMap?['last_name'])
              ?.toString() ??
          '',
      phone_number: (root['phoneNumber'] ??
                  root['phone'] ??
                  userMap?['phoneNumber'] ??
                  userMap?['phone'])
              ?.toString() ??
          '',
      gender: _parseGender(root['gender'] ?? userMap?['gender']),
      date_of_birth: rawDob,
      address: parsedAddress,
      patient_id: (root['patient_id'] ??
              root['pid'] ??
              root['patientId'] ??
              root['id'])
          ?.toString(),
      has_profile_photo: parsedHasPhoto,
      national_id: (root['nationalId'] ??
              root['ssn'] ??
              root['national_id'] ??
              userMap?['nationalId'])
          ?.toString(),
      weight: (root['weightKg'] ?? root['weight'])?.toString(),
      height: (root['heightCm'] ?? root['height'])?.toString(),
      blood_group: parsedBloodGroup.isNotEmpty ? parsedBloodGroup : null,
      governorate_id: govId,
      governorate_name: govName,
      city_id: cId,
      city_name: cName,
      governorate: parsedGov,
      city: parsedCity,
      photo_url: parsedPhotoUrl,
    );
  }

  // Converts the UserProfileModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': first_name,
      'lastName': last_name,
      'phoneNumber': phone_number,
      'gender': gender,
      'birthDate': date_of_birth,
      'dateOfBirth': date_of_birth,
      'address': address,
      'patient_id': patient_id,
      'patientId': patient_id,
      'hasProfilePhoto': has_profile_photo,
      'nationalId': national_id,
      'weightKg': null != weight && weight!.isNotEmpty
          ? double.tryParse(weight!) ?? weight
          : null,
      'weight': weight,
      'heightCm': null != height && height!.isNotEmpty
          ? double.tryParse(height!) ?? height
          : null,
      'height': height,
      'bloodGroup': UserProfileModel.bloodGroupToInt(blood_group),
      'governorateId': governorate_id,
      'governorateName': governorate_name,
      'cityId': city_id,
      'cityName': city_name,
      'photoUrl': photo_url,
    };
  }

  // Creates a copy of the model with optional field overrides
  UserProfileModel copyWith({
    String? id,
    String? email,
    String? first_name,
    String? last_name,
    String? phone_number,
    int? gender,
    String? date_of_birth,
    String? address,
    String? patient_id,
    bool? has_profile_photo,
    String? national_id,
    String? weight,
    String? height,
    String? blood_group,
    String? governorate_id,
    String? governorate_name,
    String? city_id,
    String? city_name,
    GovernorateModel? governorate,
    CityModel? city,
    String? photo_url,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      phone_number: phone_number ?? this.phone_number,
      gender: gender ?? this.gender,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      address: address ?? this.address,
      patient_id: patient_id ?? this.patient_id,
      has_profile_photo: has_profile_photo ?? this.has_profile_photo,
      national_id: national_id ?? this.national_id,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      blood_group: blood_group ?? this.blood_group,
      governorate_id: governorate_id ?? this.governorate_id,
      governorate_name: governorate_name ?? this.governorate_name,
      city_id: city_id ?? this.city_id,
      city_name: city_name ?? this.city_name,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      photo_url: photo_url ?? this.photo_url,
    );
  }
}

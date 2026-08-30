/*
 * File Name: patient_profile_model_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 30/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/patient_profile_model.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Unit tests verifying resilient JSON deserialization in UserProfileModel and PatientProfileModel.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/patient_profile_model.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';

void main() {
  group('PatientProfileModel / UserProfileModel Deserialization Tests', () {
    test('successfully parses nested Map objects for governorate, city, and bloodGroup with UUID strings', () {
      final Map<String, dynamic> rawJson = {
        'id': 'p-uuid-12345',
        'email': 'kholoud@example.com',
        'firstName': 'Kholoud',
        'lastName': 'Khaled',
        'phoneNumber': '01012345678',
        'gender': 1,
        'birthDate': '2000-01-15',
        'nationalId': '30001150100000',
        'weight': 65.5,
        'height': 168.0,
        'bloodGroup': {
          'id': 0,
          'name': 'A+',
        },
        'governorate': {
          'id': 'c96424b4-e13c-4569-b3b4-31780630ab20',
          'nameAr': 'القاهرة',
          'nameEn': 'Cairo',
        },
        'city': {
          'id': '7f8b9c0d-1e2f-3a4b-5c6d-7e8f9a0b1c2d',
          'governorateId': 'c96424b4-e13c-4569-b3b4-31780630ab20',
          'nameAr': 'مدينة نصر',
          'nameEn': 'Nasr City',
        },
        'profilePictureUrl': 'https://appoynt.com/photos/avatar.png',
        'hasProfilePhoto': true,
      };

      final UserProfileModel model = UserProfileModel.fromJson(rawJson);

      expect(model.id, 'p-uuid-12345');
      expect(model.first_name, 'Kholoud');
      expect(model.firstName, 'Kholoud');
      expect(model.last_name, 'Khaled');
      expect(model.lastName, 'Khaled');
      expect(model.email, 'kholoud@example.com');
      expect(model.phone_number, '01012345678');
      expect(model.gender, 1);
      expect(model.date_of_birth, '2000-01-15');
      expect(model.national_id, '30001150100000');
      expect(model.weight, '65.5');
      expect(model.height, '168.0');
      expect(model.blood_group, 'A+');
      expect(model.bloodGroup, 'A+');
      expect(model.governorate_id, 'c96424b4-e13c-4569-b3b4-31780630ab20');
      expect(model.governorate_name, 'Cairo');
      expect(model.city_id, '7f8b9c0d-1e2f-3a4b-5c6d-7e8f9a0b1c2d');
      expect(model.city_name, 'Nasr City');
      expect(model.governorate, isNotNull);
      expect(model.governorate?.nameEn, 'Cairo');
      expect(model.city, isNotNull);
      expect(model.city?.nameEn, 'Nasr City');
      expect(model.has_profile_photo, isTrue);
      expect(model.photo_url, 'https://appoynt.com/photos/avatar.png');
    });

    test('successfully parses when wrapped inside a data envelope and identity in user map', () {
      final Map<String, dynamic> rawEnvelopeJson = {
        'statusCode': 200,
        'data': {
          'id': 'patient-999',
          'user': {
            'id': 'user-111',
            'firstName': 'Omar',
            'lastName': 'Ali',
            'email': 'omar@example.com',
            'phoneNumber': '01122334455',
            'gender': 'Male',
          },
          'ssn': '29505050100000',
          'weightKg': 80,
          'heightCm': 175,
          'blood_group': 2, // enum 2 -> B+
          'governorate': 'Alexandria',
          'city': 'Smouha',
        },
      };

      final PatientProfileModel model = PatientProfileModel.fromJson(rawEnvelopeJson);

      expect(model.id, 'patient-999');
      expect(model.firstName, 'Omar');
      expect(model.lastName, 'Ali');
      expect(model.email, 'omar@example.com');
      expect(model.phone, '01122334455');
      expect(model.gender, 0); // Normalized Male -> 0
      expect(model.nationalId, '29505050100000');
      expect(model.weight, '80');
      expect(model.height, '175');
      expect(model.bloodGroup, 'B+');
      expect(model.governorateName, 'Alexandria');
      expect(model.cityName, 'Smouha');
      expect(model.address, 'Smouha, Alexandria');
    });

    test('GovernorateModel and CityModel handle UUID string IDs and nested lists properly', () {
      final Map<String, dynamic> govJson = {
        'id': 'c96424b4-e13c-4569-b3b4-31780630ab20',
        'nameEn': 'Giza',
        'nameAr': 'الجيزة',
        'cities': [
          {
            'id': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
            'governorateId': 'c96424b4-e13c-4569-b3b4-31780630ab20',
            'nameEn': 'Dokki',
            'nameAr': 'الدقي',
          },
          {
            'id': 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
            'governorateId': 'c96424b4-e13c-4569-b3b4-31780630ab20',
            'nameEn': 'Mohandessin',
            'nameAr': 'المهندسين',
          },
        ],
      };

      final GovernorateModel gov = GovernorateModel.fromJson(govJson);

      expect(gov.id, 'c96424b4-e13c-4569-b3b4-31780630ab20');
      expect(gov.nameEn, 'Giza');
      expect(gov.nameAr, 'الجيزة');
      expect(gov.cities.length, 2);
      expect(gov.cities[0].id, 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d');
      expect(gov.cities[0].nameEn, 'Dokki');
      expect(gov.cities[1].nameEn, 'Mohandessin');
    });
  });
}

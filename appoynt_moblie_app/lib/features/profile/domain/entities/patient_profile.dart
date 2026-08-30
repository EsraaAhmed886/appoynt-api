/*
 * File Name: patient_profile.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 31/08/2026]
 * File Description: Declares the PatientProfile domain entity representing patient record metadata,
 *   including governorate and city address properties.
 */

// Importing the InsuranceCard entity declaration
import 'package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart';
// Importing the TestResult entity declaration
import 'package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart';

// Represents the structural PatientProfile domain entity
class PatientProfile {
  // First name identifier
  final String first_name;
  // Last name identifier
  final String last_name;
  // Phone number (read-only and immutable)
  final String phone;
  // Email address
  final String email;
  // Gender value (Male/Female/Prefer not to say)
  final String gender;
  // Physical address field representation
  final String address;
  // National ID 14-digit number string
  final String national_id;
  // Body weight marker value string
  final String weight;
  // Body height marker value string
  final String height;
  // Patient blood group category string
  final String blood_group;
  // Smoking status indicator (Yes/No)
  final String smoking;
  // Food allergies categories listed
  final List<String> food_allergies;
  // Medication allergies categories listed
  final List<String> medication_allergies;
  // Prescriptions medications listed (rich schema: name, dosage, frequency,
  // duration, status, doctor, date, attachment)
  final List<Map<String, dynamic>> prescriptions;
  // Lab tests details records list
  final List<TestResult> lab_tests;
  // Scanning medical results list
  final List<TestResult> scans;
  // Chronic diseases conditions list
  final List<String> chronic_conditions;
  // Linked insurance cards details list
  final List<InsuranceCard> insurance_cards;
  // Avatar photo path or remote URL
  final String avatar_url;
  // Saved payment cards list (rich map schema: id, brand, number, expiry, holder, is_default)
  final List<Map<String, dynamic>> payment_cards;
  // Foreign key identifier for selected governorate
  final String? governorate_id;
  // English display name for governorate
  final String? governorate_name_en;
  // Arabic display name for governorate
  final String? governorate_name_ar;
  // Foreign key identifier for selected city
  final String? city_id;
  // English display name for city
  final String? city_name_en;
  // Arabic display name for city
  final String? city_name_ar;

  // Constructor initializing all profile property mappings
  const PatientProfile({
    // Require first name
    required this.first_name,
    // Require last name
    required this.last_name,
    // Require phone
    required this.phone,
    // Require email
    required this.email,
    // Require gender selection
    required this.gender,
    // Require physical address
    required this.address,
    // Require national id
    required this.national_id,
    // Require weight info
    required this.weight,
    // Require height info
    required this.height,
    // Require blood group info
    required this.blood_group,
    // Require smoking flag
    required this.smoking,
    // Require food allergies list
    required this.food_allergies,
    // Require medication allergies list
    required this.medication_allergies,
    // Require prescriptions list
    required this.prescriptions,
    // Require lab tests list
    required this.lab_tests,
    // Require scans list
    required this.scans,
    // Require chronic conditions list
    required this.chronic_conditions,
    // Require insurance cards list
    required this.insurance_cards,
    // Require avatar url
    required this.avatar_url,
    // Require payment cards list
    required this.payment_cards,
    this.governorate_id,
    this.governorate_name_en,
    this.governorate_name_ar,
    this.city_id,
    this.city_name_en,
    this.city_name_ar,
  });

  // Convenient property getters
  String? get governorateId => governorate_id;
  String? get governorateNameEn => governorate_name_en;
  String? get governorateNameAr => governorate_name_ar;
  String? get cityId => city_id;
  String? get cityNameEn => city_name_en;
  String? get cityNameAr => city_name_ar;
  String? get nationalId => national_id;
  String? get bloodGroup => blood_group;
  String? get firstName => first_name;
  String? get lastName => last_name;
  String? get photoUrl => avatar_url;

  // Helper factory method creating an initial empty/dummy profile instance
  factory PatientProfile.empty() {
    // Return empty profile representation with defaults
    return const PatientProfile(
      // Empty string first name
      first_name: '',
      // Empty string last name
      last_name: '',
      // Default phone mockup credential
      phone: '01022711357',
      // Empty email layout
      email: '',
      // Default ambient value
      gender: '',
      // Empty address string
      address: '',
      // Default national id mockup
      national_id: '29712050102345',
      // Weight default indicator
      weight: '',
      // Height default indicator
      height: '',
      // Blood group default indicator
      blood_group: '',
      // Default smoking choice
      smoking: 'No',
      // Empty list of food allergies
      food_allergies: [],
      // Empty list of medication allergies
      medication_allergies: [],
      // Empty list of prescriptions
      prescriptions: [],
      // Empty list of lab tests
      lab_tests: [],
      // Empty list of scans
      scans: [],
      // Empty list of chronic conditions
      chronic_conditions: [],
      // Empty list of insurance plans
      insurance_cards: [],
      // Empty avatar url path representation
      avatar_url: '',
      // Initial default saved payment cards list
      payment_cards: [
        {
          'id': '1',
          'brand': 'Visa',
          'number': '4000 1234 5678 4321',
          'expiry': '12/2029',
          'holder': 'Kareem Mangood',
          'is_default': 'true',
        },
        {
          'id': '2',
          'brand': 'Mastercard',
          'number': '5105 4321 8765 8877',
          'expiry': '08/2028',
          'holder': 'Kareem Mangood',
          'is_default': 'false',
        },
      ],
      governorate_id: null,
      governorate_name_en: null,
      governorate_name_ar: null,
      city_id: null,
      city_name_en: null,
      city_name_ar: null,
    );
  }

  // Generate a duplicate profile instance with updated overrides
  PatientProfile copyWith({
    // Optional first name update
    String? first_name,
    // Optional last name update
    String? last_name,
    // Optional phone update
    String? phone,
    // Optional email update
    String? email,
    // Optional gender update
    String? gender,
    // Optional address update
    String? address,
    // Optional national id update
    String? national_id,
    // Optional weight update
    String? weight,
    // Optional height update
    String? height,
    // Optional blood group update
    String? blood_group,
    // Optional smoking status update
    String? smoking,
    // Optional food allergies update
    List<String>? food_allergies,
    // Optional medication allergies update
    List<String>? medication_allergies,
    // Optional prescriptions list update (rich map schema)
    List<Map<String, dynamic>>? prescriptions,
    // Optional lab tests update
    List<TestResult>? lab_tests,
    // Optional scans update
    List<TestResult>? scans,
    // Optional chronic conditions update
    List<String>? chronic_conditions,
    // Optional insurance cards update
    List<InsuranceCard>? insurance_cards,
    // Optional avatar photo path update
    String? avatar_url,
    // Optional payment cards list update
    List<Map<String, dynamic>>? payment_cards,
    String? governorate_id,
    String? governorate_name_en,
    String? governorate_name_ar,
    String? city_id,
    String? city_name_en,
    String? city_name_ar,
  }) {
    // Return new modified PatientProfile instance mapping properties
    return PatientProfile(
      // Apply first name override or keep current value
      first_name: first_name ?? this.first_name,
      // Apply last name override or keep current value
      last_name: last_name ?? this.last_name,
      // Apply phone override or keep current value
      phone: phone ?? this.phone,
      // Apply email override or keep current value
      email: email ?? this.email,
      // Apply gender override or keep current value
      gender: gender ?? this.gender,
      // Apply address override or keep current value
      address: address ?? this.address,
      // Apply national id override or keep current value
      national_id: national_id ?? this.national_id,
      // Apply weight override or keep current value
      weight: weight ?? this.weight,
      // Apply height override or keep current value
      height: height ?? this.height,
      // Apply blood group override or keep current value
      blood_group: blood_group ?? this.blood_group,
      // Apply smoking override or keep current value
      smoking: smoking ?? this.smoking,
      // Apply food allergies override or keep current list
      food_allergies: food_allergies ?? this.food_allergies,
      // Apply medication allergies override or keep current list
      medication_allergies: medication_allergies ?? this.medication_allergies,
      // Apply prescriptions override or keep current list
      prescriptions: prescriptions ?? this.prescriptions,
      // Apply lab tests override or keep current list
      lab_tests: lab_tests ?? this.lab_tests,
      // Apply scans override or keep current list
      scans: scans ?? this.scans,
      // Apply chronic conditions override or keep current list
      chronic_conditions: chronic_conditions ?? this.chronic_conditions,
      // Apply insurance cards override or keep current list
      insurance_cards: insurance_cards ?? this.insurance_cards,
      // Apply avatar url override or keep current value
      avatar_url: avatar_url ?? this.avatar_url,
      // Apply payment cards override or keep current list
      payment_cards: payment_cards ?? this.payment_cards,
      governorate_id: governorate_id ?? this.governorate_id,
      governorate_name_en: governorate_name_en ?? this.governorate_name_en,
      governorate_name_ar: governorate_name_ar ?? this.governorate_name_ar,
      city_id: city_id ?? this.city_id,
      city_name_en: city_name_en ?? this.city_name_en,
      city_name_ar: city_name_ar ?? this.city_name_ar,
    );
  }
}

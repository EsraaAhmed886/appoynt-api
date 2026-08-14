/*
 * File Name: favorites_remote_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: favorited_doctor.dart, favorited_offer.dart, favorited_clinic.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Remote data source contract and mock API implementation
 *   serving paginated favorites data and backend removal endpoints.
 */

// Import domain entities
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_doctor.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_offer.dart';
import 'package:appoynt_mobile_app/features/favorites/domain/entities/favorited_clinic.dart';

// Abstract contract for remote favorites operations
abstract class FavoritesRemoteDataSource {
  // Fetch paginated favorited doctors
  Future<List<FavoritedDoctor>> getFavoriteDoctors({
    required int page,
    required int page_size,
  });

  // Fetch paginated favorited offers
  Future<List<FavoritedOffer>> getFavoriteOffers({
    required int page,
    required int page_size,
  });

  // Fetch paginated favorited clinics
  Future<List<FavoritedClinic>> getFavoriteClinics({
    required int page,
    required int page_size,
  });

  // Remove doctor favorite on remote backend
  Future<void> removeFavoriteDoctor(String doctor_id);

  // Remove offer favorite on remote backend
  Future<void> removeFavoriteOffer(String offer_id);

  // Remove clinic favorite on remote backend
  Future<void> removeFavoriteClinic(String clinic_id);
}

// Concrete mock implementation of FavoritesRemoteDataSource
class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  // Master mock dataset for doctors
  static final List<FavoritedDoctor> _mock_doctors = [
    FavoritedDoctor(
      id: 'doc_101',
      name: 'Dr. Sarah Jenkins',
      specialty: 'Cardiologist',
      location: 'New Cairo Medical Center',
      rating: 4.9,
      reviews_count: 124,
      fee: 450.0,
      is_available_today: true,
      is_active: true,
      is_favorite: true,
      avatar_url:
          'https://img.freepik.com/free-photo/woman-doctor-wearing-lab-coat-with-stethoscope-isolated_1303-29791.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    FavoritedDoctor(
      id: 'doc_102',
      name: 'Dr. Ahmed Hassan',
      specialty: 'Dermatologist',
      location: 'Maadi Health Specialist Clinic',
      rating: 4.8,
      reviews_count: 98,
      fee: 350.0,
      is_available_today: false,
      is_active: true,
      is_favorite: true,
      avatar_url:
          'https://img.freepik.com/free-photo/doctor-offering-medical-advice_23-2148816172.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    FavoritedDoctor(
      id: 'doc_103',
      name: 'Dr. Mona El-Sayed',
      specialty: 'Neurologist',
      location: 'Heliopolis Specialist Hospital',
      rating: 4.95,
      reviews_count: 156,
      fee: 600.0,
      is_available_today: true,
      is_active: true,
      is_favorite: true,
      avatar_url:
          'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827763.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    FavoritedDoctor(
      id: 'doc_104',
      name: 'Dr. Michael Chang',
      specialty: 'Orthopedic Surgeon',
      location: 'Zayed Bone & Joint Center',
      rating: 4.7,
      reviews_count: 84,
      fee: 500.0,
      is_available_today: true,
      is_active: true,
      is_favorite: true,
      avatar_url:
          'https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-arms_409827-254.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    FavoritedDoctor(
      id: 'doc_105',
      name: 'Dr. Layla Mahmoud',
      specialty: 'Pediatrician',
      location: 'Dokki Children Hospital',
      rating: 4.85,
      reviews_count: 110,
      fee: 300.0,
      is_available_today: false,
      is_active: false,
      is_favorite: true,
      avatar_url:
          'https://img.freepik.com/free-photo/front-view-female-doctor-with-medical-mask-stethoscope_23-2148847628.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  // Master mock dataset for promotional medical offers
  static final List<FavoritedOffer> _mock_offers = [
    FavoritedOffer(
      id: 'off_201',
      title: 'Full Body Comprehensive Health Checkup',
      provider_name: 'Al-Mokhtabar Specialized Labs',
      discount_percentage: 30,
      original_price: 1500.0,
      discounted_price: 1050.0,
      expiry_date: DateTime.now().add(const Duration(days: 14)),
      is_expired: false,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/doctor-explaining-diagnosis-patient_23-2148827748.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    FavoritedOffer(
      id: 'off_202',
      title: 'Dental Scaling & Advanced Teeth Whitening',
      provider_name: 'Shiny White Dental Centers',
      discount_percentage: 40,
      original_price: 2000.0,
      discounted_price: 1200.0,
      expiry_date: DateTime.now().add(const Duration(days: 7)),
      is_expired: false,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/dentist-examining-patient-teeth_23-2148827756.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FavoritedOffer(
      id: 'off_203',
      title: 'LASIK Eye Vision Correction Package',
      provider_name: 'Magrabi Eye & Ear Hospital',
      discount_percentage: 25,
      original_price: 8000.0,
      discounted_price: 6000.0,
      expiry_date: DateTime.now().subtract(const Duration(days: 3)),
      is_expired: true,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/optometrist-examining-patient-eyesight-with-phoropter_23-2148827753.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 6)),
    ),
    FavoritedOffer(
      id: 'off_204',
      title: 'Cardiology Screening & Stress ECG Test',
      provider_name: 'Dar Al Fouad Heart Hospital',
      discount_percentage: 20,
      original_price: 1200.0,
      discounted_price: 960.0,
      expiry_date: DateTime.now().add(const Duration(days: 21)),
      is_expired: false,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/doctor-working-with-monitor_23-2148827764.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Master mock dataset for clinics
  static final List<FavoritedClinic> _mock_clinics = [
    FavoritedClinic(
      id: 'cln_301',
      name: 'Cleopatra Specialist Polyclinic',
      specialties: const ['Cardiology', 'Internal Medicine', 'Orthopedics'],
      address: 'Salah Salem Road, Heliopolis, Cairo',
      rating: 4.85,
      reviews_count: 340,
      phone_number: '19777',
      is_active: true,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/modern-hospital-building_23-2148827749.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    FavoritedClinic(
      id: 'cln_302',
      name: 'Prime Care Medical & Wellness Center',
      specialties: const ['Dermatology', 'Dental', 'Pediatrics'],
      address: 'Road 90 North, New Cairo, Cairo',
      rating: 4.9,
      reviews_count: 215,
      phone_number: '16888',
      is_active: true,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/hospital-room-interior_23-2148827750.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FavoritedClinic(
      id: 'cln_303',
      name: 'El-Safwa Eye & Laser Specialized Clinic',
      specialties: const ['Ophthalmology', 'Optometry', 'LASIK'],
      address: 'El-Nasr St, Maadi, Cairo',
      rating: 4.75,
      reviews_count: 180,
      phone_number: '19555',
      is_active: true,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/medical-clinic-hall_23-2148827751.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 4)),
    ),
    FavoritedClinic(
      id: 'cln_304',
      name: 'Zayed Ortho & Sports Injury Institute',
      specialties: const ['Orthopedics', 'Physiotherapy', 'Rehabilitation'],
      address: '26th of July Corridor, Sheikh Zayed, Giza',
      rating: 4.65,
      reviews_count: 95,
      phone_number: '16222',
      is_active: false,
      is_favorite: true,
      image_url:
          'https://img.freepik.com/free-photo/rehabilitation-center_23-2148827752.jpg',
      added_timestamp: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];


  @override
  // Fetch paginated favorited doctors with network simulation
  Future<List<FavoritedDoctor>> getFavoriteDoctors({
    required int page,
    required int page_size,
  }) async {
    // Simulate realistic network round-trip delay
    await Future.delayed(const Duration(milliseconds: 350));
    // Calculate slice bounds
    final int start_index = (page - 1) * page_size;
    if (start_index >= _mock_doctors.length) {
      return [];
    } else {
      final int end_index = (start_index + page_size > _mock_doctors.length)
          ? _mock_doctors.length
          : start_index + page_size;
      return _mock_doctors.sublist(start_index, end_index);
    }
  }

  @override
  // Fetch paginated favorited offers with network simulation
  Future<List<FavoritedOffer>> getFavoriteOffers({
    required int page,
    required int page_size,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 350));
    final int start_index = (page - 1) * page_size;
    if (start_index >= _mock_offers.length) {
      return [];
    } else {
      final int end_index = (start_index + page_size > _mock_offers.length)
          ? _mock_offers.length
          : start_index + page_size;
      return _mock_offers.sublist(start_index, end_index);
    }
  }

  @override
  // Fetch paginated favorited clinics with network simulation
  Future<List<FavoritedClinic>> getFavoriteClinics({
    required int page,
    required int page_size,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 350));
    final int start_index = (page - 1) * page_size;
    if (start_index >= _mock_clinics.length) {
      return [];
    } else {
      final int end_index = (start_index + page_size > _mock_clinics.length)
          ? _mock_clinics.length
          : start_index + page_size;
      return _mock_clinics.sublist(start_index, end_index);
    }
  }

  @override
  // Remove doctor favorite with backend confirmation
  Future<void> removeFavoriteDoctor(String doctor_id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _mock_doctors.removeWhere((doc) => doc.id == doctor_id);
  }

  @override
  // Remove offer favorite with backend confirmation
  Future<void> removeFavoriteOffer(String offer_id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _mock_offers.removeWhere((offer) => offer.id == offer_id);
  }

  @override
  // Remove clinic favorite with backend confirmation
  Future<void> removeFavoriteClinic(String clinic_id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _mock_clinics.removeWhere((clinic) => clinic.id == clinic_id);
  }
}

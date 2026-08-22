/*
 * File Name: appointments_mock_repository.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: ../models/appointment_model.dart, ../models/appointment_filter_model.dart, ../models/quick_action_item_model.dart, ../models/doctor_recommendation_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Mock repository providing realistic patient appointments, quick action counts, doctor recommendations, cancellation refunds, and rescheduling time slots.
 */

import '../models/appointment_filter_model.dart';
import '../models/appointment_model.dart';
import '../models/doctor_recommendation_model.dart';
import '../models/quick_action_item_model.dart';

/// Repository interface providing appointments data and workflow actions.
abstract class AppointmentsRepository {
  Future<List<AppointmentModel>> getAppointments({
    required AppointmentTabType tab,
    String? searchQuery,
    AppointmentFilter? filter,
    int page = 1,
    int pageSize = 20,
  });

  Future<QuickActionsSummaryModel> getQuickActionsSummary();

  Future<List<DoctorRecommendationModel>> getDoctorRecommendations();

  Future<AppointmentModel> cancelAppointment(String id, {String? reason});

  Future<List<DateTime>> getAvailableRescheduleSlots(String doctorId, DateTime date);

  Future<AppointmentModel> rescheduleAppointment(String id, DateTime newDateTime);
}

/// In-memory implementation of AppointmentsRepository with realistic clinical records.
class AppointmentsMockRepository implements AppointmentsRepository {
  static final AppointmentsMockRepository _instance = AppointmentsMockRepository._internal();
  factory AppointmentsMockRepository() => _instance;

  AppointmentsMockRepository._internal() {
    _initializeMockData();
  }

  late List<AppointmentModel> _mockAppointments;
  late QuickActionsSummaryModel _quickActionsSummary;
  late List<DoctorRecommendationModel> _recommendations;

  void _initializeMockData() {
    final now = DateTime.now();

    _mockAppointments = [
      // 1. Upcoming Online Video Call (Active in 5 mins for testing Join Call window)
      AppointmentModel(
        id: 'appt_101',
        doctorId: 'doc_1',
        doctorName: 'Dr. Sherif Zaki',
        doctorSpecialty: 'Cardiology',
        doctorImageUrl: 'assets/images/doctors/sherif.png',
        doctorRating: 4.9,
        doctorReviewsCount: 142,
        isDoctorVerified: true,
        clinicId: 'clinic_1',
        clinicName: 'Al-Safwa Specialist Clinic',
        clinicAddress: 'Building 14, 90th St, New Cairo',
        scheduledDateTime: now.add(const Duration(minutes: 5)),
        endDateTime: now.add(const Duration(minutes: 35)),
        status: AppointmentStatus.confirmed,
        type: AppointmentType.onlineVideo,
        consultationFee: '450 EGP',
        onlineCallUrl: 'https://appoynt.health/call/appt_101',
      ),

      // 2. Upcoming In-Clinic Tomorrow
      AppointmentModel(
        id: 'appt_102',
        doctorId: 'doc_2',
        doctorName: 'Dr. Salma Nour',
        doctorSpecialty: 'Dermatology & Cosmetology',
        doctorImageUrl: 'assets/images/doctors/salma.png',
        doctorRating: 4.8,
        doctorReviewsCount: 98,
        isDoctorVerified: true,
        clinicId: 'clinic_2',
        clinicName: 'New Cairo Heart & Vascular Center',
        clinicAddress: 'Tower B, Medical City, New Cairo',
        scheduledDateTime: now.add(const Duration(days: 1, hours: 3)),
        endDateTime: now.add(const Duration(days: 1, hours: 3, minutes: 30)),
        status: AppointmentStatus.upcoming,
        type: AppointmentType.inClinic,
        consultationFee: '380 EGP',
      ),

      // 3. Upcoming In-Clinic in 4 days
      AppointmentModel(
        id: 'appt_103',
        doctorId: 'doc_3',
        doctorName: 'Dr. Tarek Mansour',
        doctorSpecialty: 'Orthopedic Surgery',
        doctorImageUrl: 'assets/images/doctors/tarek.png',
        doctorRating: 4.7,
        doctorReviewsCount: 76,
        isDoctorVerified: true,
        clinicId: 'clinic_3',
        clinicName: 'Zayed Medical Plaza',
        clinicAddress: 'Block 7, 26th July Corridor, Sheikh Zayed',
        scheduledDateTime: now.add(const Duration(days: 4, hours: 2)),
        endDateTime: now.add(const Duration(days: 4, hours: 2, minutes: 30)),
        status: AppointmentStatus.upcoming,
        type: AppointmentType.inClinic,
        consultationFee: '500 EGP',
      ),

      // 4. Completed (Last week)
      AppointmentModel(
        id: 'appt_104',
        doctorId: 'doc_4',
        doctorName: 'Dr. Dina El-Gazzar',
        doctorSpecialty: 'Pediatrics & Neonatology',
        doctorImageUrl: 'assets/images/doctors/dina.png',
        doctorRating: 4.9,
        doctorReviewsCount: 210,
        isDoctorVerified: true,
        clinicId: 'clinic_4',
        clinicName: 'Maadi Health Oasis',
        clinicAddress: 'Street 9, Intersection 218, Maadi',
        scheduledDateTime: now.subtract(const Duration(days: 6, hours: 4)),
        endDateTime: now.subtract(const Duration(days: 6, hours: 3, minutes: 30)),
        status: AppointmentStatus.completed,
        type: AppointmentType.inClinic,
        consultationFee: '400 EGP',
      ),

      // 5. Completed (2 weeks ago)
      AppointmentModel(
        id: 'appt_105',
        doctorId: 'doc_1',
        doctorName: 'Dr. Sherif Zaki',
        doctorSpecialty: 'Cardiology',
        doctorImageUrl: 'assets/images/doctors/sherif.png',
        doctorRating: 4.9,
        doctorReviewsCount: 142,
        isDoctorVerified: true,
        clinicId: 'clinic_1',
        clinicName: 'Al-Safwa Specialist Clinic',
        clinicAddress: 'Building 14, 90th St, New Cairo',
        scheduledDateTime: now.subtract(const Duration(days: 14, hours: 1)),
        endDateTime: now.subtract(const Duration(days: 14, hours: 0, minutes: 30)),
        status: AppointmentStatus.completed,
        type: AppointmentType.onlineVideo,
        consultationFee: '450 EGP',
        onlineCallUrl: 'https://appoynt.health/call/appt_105',
      ),

      // 6. Cancelled (3 weeks ago)
      AppointmentModel(
        id: 'appt_106',
        doctorId: 'doc_5',
        doctorName: 'Dr. Omar Farouk',
        doctorSpecialty: 'Neurology',
        doctorImageUrl: 'assets/images/doctors/omar.png',
        doctorRating: 4.6,
        doctorReviewsCount: 54,
        isDoctorVerified: false,
        clinicId: 'clinic_3',
        clinicName: 'Zayed Medical Plaza',
        clinicAddress: 'Block 7, 26th July Corridor, Sheikh Zayed',
        scheduledDateTime: now.subtract(const Duration(days: 21, hours: 5)),
        endDateTime: now.subtract(const Duration(days: 21, hours: 4, minutes: 30)),
        status: AppointmentStatus.cancelled,
        type: AppointmentType.inClinic,
        consultationFee: '350 EGP',
        cancellationReason: 'Personal emergency and travel scheduling conflict.',
        cancelledAt: now.subtract(const Duration(days: 22, hours: 2)),
      ),

      // 7. Missed (Last month)
      AppointmentModel(
        id: 'appt_107',
        doctorId: 'doc_6',
        doctorName: 'Dr. Hoda Kamel',
        doctorSpecialty: 'Ophthalmology',
        doctorImageUrl: 'assets/images/doctors/hoda.png',
        doctorRating: 4.8,
        doctorReviewsCount: 112,
        isDoctorVerified: true,
        clinicId: 'clinic_2',
        clinicName: 'New Cairo Heart & Vascular Center',
        clinicAddress: 'Tower B, Medical City, New Cairo',
        scheduledDateTime: now.subtract(const Duration(days: 30, hours: 2)),
        endDateTime: now.subtract(const Duration(days: 30, hours: 1, minutes: 30)),
        status: AppointmentStatus.missed,
        type: AppointmentType.inClinic,
        consultationFee: '420 EGP',
      ),
    ];

    _quickActionsSummary = const QuickActionsSummaryModel(
      prescriptionsCount: 3,
      labResultsCount: 2,
      radiologyReportsCount: 1,
    );

    _recommendations = const [
      DoctorRecommendationModel(
        id: 'doc_rec_1',
        name: 'Dr. Ahmed Rashed',
        specialty: 'Internal Medicine & Endocrinology',
        imageUrl: 'assets/images/doctors/sherif.png',
        rating: 4.9,
        reviewsCount: 184,
        consultationFee: '400 EGP',
        clinicName: 'Elite Medical Center',
      ),
      DoctorRecommendationModel(
        id: 'doc_rec_2',
        name: 'Dr. Nourhan Adel',
        specialty: 'Clinical Nutrition',
        imageUrl: 'assets/images/doctors/salma.png',
        rating: 4.8,
        reviewsCount: 120,
        consultationFee: '300 EGP',
        clinicName: 'Health Lifestyle Clinic',
      ),
    ];
  }

  @override
  Future<List<AppointmentModel>> getAppointments({
    required AppointmentTabType tab,
    String? searchQuery,
    AppointmentFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    // 1. Filter by Tab Category
    List<AppointmentModel> filtered = _mockAppointments.where((appt) {
      switch (tab) {
        case AppointmentTabType.upcoming:
          return appt.status == AppointmentStatus.upcoming ||
              appt.status == AppointmentStatus.confirmed;
        case AppointmentTabType.completed:
          return appt.status == AppointmentStatus.completed;
        case AppointmentTabType.cancelled:
          return appt.status == AppointmentStatus.cancelled;
        case AppointmentTabType.all:
          return true;
      }
    }).toList();

    // 2. Filter by Search Query (Doctor, Specialty, Facility - Case-insensitive partial matching)
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      filtered = filtered.where((appt) {
        final doctorMatches = appt.doctorName.toLowerCase().contains(query);
        final specialtyMatches = appt.doctorSpecialty?.toLowerCase().contains(query) ?? false;
        final clinicMatches = appt.clinicName.toLowerCase().contains(query);
        return doctorMatches || specialtyMatches || clinicMatches;
      }).toList();
    }

    // 3. Filter by Active Modal Criteria
    if (filter != null && filter.isActive) {
      filtered = filtered.where((appt) => filter.matches(appt)).toList();
    }

    // 4. Sort based on Tab Rules (BR-27, BR-28, VR-45)
    filtered.sort((a, b) {
      if (tab == AppointmentTabType.upcoming) {
        // Upcoming: NEAREST date/time first (Ascending)
        final dateComparison = a.scheduledDateTime.compareTo(b.scheduledDateTime);
        if (dateComparison != 0) return dateComparison;
      } else {
        // Completed, Cancelled, All: LATEST date/time first (Descending)
        final dateComparison = b.scheduledDateTime.compareTo(a.scheduledDateTime);
        if (dateComparison != 0) return dateComparison;
      }

      // Tie-breaker for same timestamps: Upcoming -> Confirmed -> Completed -> Missed -> Cancelled
      return a.status.index.compareTo(b.status.index);
    });

    // 5. Pagination (Page index 1-based)
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= filtered.length) {
      return [];
    }
    final endIndex = (startIndex + pageSize).clamp(0, filtered.length);
    return filtered.sublist(startIndex, endIndex);
  }

  @override
  Future<QuickActionsSummaryModel> getQuickActionsSummary() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _quickActionsSummary;
  }

  @override
  Future<List<DoctorRecommendationModel>> getDoctorRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 180));
    return _recommendations;
  }

  @override
  Future<AppointmentModel> cancelAppointment(String id, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _mockAppointments.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    final target = _mockAppointments[index];
    if (!target.canCancel) {
      throw Exception('Appointments cannot be cancelled within 15 minutes of scheduled time.');
    }

    final updated = target.copyWith(
      status: AppointmentStatus.cancelled,
      cancellationReason: reason ?? 'Patient requested cancellation',
      cancelledAt: DateTime.now(),
    );

    _mockAppointments[index] = updated;
    return updated;
  }

  @override
  Future<List<DateTime>> getAvailableRescheduleSlots(String doctorId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 150));

    // Generate 6 realistic time slots for the requested date
    final baseDate = DateTime(date.year, date.month, date.day);
    return [
      baseDate.add(const Duration(hours: 10)),
      baseDate.add(const Duration(hours: 10, minutes: 30)),
      baseDate.add(const Duration(hours: 11, minutes: 30)),
      baseDate.add(const Duration(hours: 14)),
      baseDate.add(const Duration(hours: 14, minutes: 30)),
      baseDate.add(const Duration(hours: 16)),
    ];
  }

  @override
  Future<AppointmentModel> rescheduleAppointment(String id, DateTime newDateTime) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _mockAppointments.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Appointment not found');
    }

    final target = _mockAppointments[index];
    final updated = target.copyWith(
      scheduledDateTime: newDateTime,
      endDateTime: newDateTime.add(const Duration(minutes: 30)),
      status: AppointmentStatus.confirmed,
    );

    _mockAppointments[index] = updated;
    return updated;
  }
}

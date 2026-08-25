/*
 * File Name: appointments_bloc_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Dependencies: flutter_test, appointments_bloc.dart, appointment_model.dart, appointments_mock_repository.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Comprehensive unit and integration test suite verifying appointments BLoC state transitions, tab sorting, search isolation, cancellation cutoffs, and pagination.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/features/appointments/data/models/appointment_filter_model.dart';
import 'package:appoynt_mobile_app/features/appointments/data/models/appointment_model.dart';
import 'package:appoynt_mobile_app/features/appointments/data/models/quick_action_item_model.dart';
import 'package:appoynt_mobile_app/features/appointments/data/repositories/appointments_mock_repository.dart';
import 'package:appoynt_mobile_app/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:appoynt_mobile_app/features/appointments/presentation/bloc/appointments_event.dart';

void main() {
  group('Appointments Module BLoC & Workflow Tests', () {
    late AppointmentsMockRepository repository;
    late AppointmentsBloc bloc;

    setUp(() {
      repository = AppointmentsMockRepository();
      bloc = AppointmentsBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('1. Initial tab load should fetch upcoming appointments sorted NEAREST first (BR-27)', () async {
      bloc.add(const LoadAppointmentsTab(AppointmentTabType.upcoming));

      await expectLater(
        bloc.stream,
        emitsThrough(predicate<dynamic>((state) {
          if (state.isLoading || state.upcomingAppointments.isEmpty) return false;
          final list = state.upcomingAppointments as List<AppointmentModel>;
          for (int i = 0; i < list.length - 1; i++) {
            if (list[i].scheduledDateTime.isAfter(list[i + 1].scheduledDateTime)) {
              return false;
            }
          }
          return true;
        })),
      );
    });

    test('2. Completed tab load should sort LATEST date/time first (BR-28)', () async {
      bloc.add(const LoadAppointmentsTab(AppointmentTabType.completed));

      await expectLater(
        bloc.stream,
        emitsThrough(predicate<dynamic>((state) {
          if (state.isLoading || state.completedAppointments.isEmpty) return false;
          final list = state.completedAppointments as List<AppointmentModel>;
          for (int i = 0; i < list.length - 1; i++) {
            if (list[i].scheduledDateTime.isBefore(list[i + 1].scheduledDateTime)) {
              return false;
            }
          }
          return true;
        })),
      );
    });

    test('3. Tab switching must clear search text and active filters (BR-03, BR-04, VR-03)', () async {
      // Apply search query and filter first on Upcoming tab
      bloc.add(const SearchQueryChanged('Sherif'));
      bloc.add(const ApplyFilter(AppointmentFilter(specialty: 'Cardiology')));

      // Now switch tab to Completed
      bloc.add(const LoadAppointmentsTab(AppointmentTabType.completed));

      await expectLater(
        bloc.stream,
        emitsThrough(predicate<dynamic>((state) {
          return state.activeTab == AppointmentTabType.completed &&
              state.searchQuery == '' &&
              !state.activeFilter.isActive;
        })),
      );
    });

    test('4. Cancellation cutoff rules and refund calculation (BR-41 to BR-47)', () {
      final now = DateTime.now();

      // Case A: > 24 hours prior -> Full Refund (100%)
      final apptFullRefund = AppointmentModel(
        id: 'test_1',
        doctorId: 'doc_1',
        doctorName: 'Dr. Test',
        clinicId: 'c_1',
        clinicName: 'Test Clinic',
        scheduledDateTime: now.add(const Duration(hours: 36)),
        endDateTime: now.add(const Duration(hours: 36, minutes: 30)),
        status: AppointmentStatus.upcoming,
        type: AppointmentType.inClinic,
      );
      expect(apptFullRefund.canCancel, isTrue);
      expect(apptFullRefund.refundEligibility, RefundEligibility.full);

      // Case B: < 24 hrs & > 15 mins -> Partial Refund
      final apptPartialRefund = AppointmentModel(
        id: 'test_2',
        doctorId: 'doc_1',
        doctorName: 'Dr. Test',
        clinicId: 'c_1',
        clinicName: 'Test Clinic',
        scheduledDateTime: now.add(const Duration(hours: 2)),
        endDateTime: now.add(const Duration(hours: 2, minutes: 30)),
        status: AppointmentStatus.upcoming,
        type: AppointmentType.inClinic,
      );
      expect(apptPartialRefund.canCancel, isTrue);
      expect(apptPartialRefund.refundEligibility, RefundEligibility.partial);

      // Case C: < 15 mins -> Cancellation Prohibited
      final apptCutoffProhibited = AppointmentModel(
        id: 'test_3',
        doctorId: 'doc_1',
        doctorName: 'Dr. Test',
        clinicId: 'c_1',
        clinicName: 'Test Clinic',
        scheduledDateTime: now.add(const Duration(minutes: 10)),
        endDateTime: now.add(const Duration(minutes: 40)),
        status: AppointmentStatus.upcoming,
        type: AppointmentType.inClinic,
      );
      expect(apptCutoffProhibited.canCancel, isFalse);
      expect(apptCutoffProhibited.refundEligibility, RefundEligibility.none);
    });

    test('5. Online consultation Join Call eligibility window (BR-77, VR-43)', () {
      final scheduledTime = DateTime(2026, 8, 22, 10, 0);
      final endTime = DateTime(2026, 8, 22, 10, 30);

      final onlineAppt = AppointmentModel(
        id: 'test_online',
        doctorId: 'doc_1',
        doctorName: 'Dr. Test',
        clinicId: 'c_1',
        clinicName: 'Test Clinic',
        scheduledDateTime: scheduledTime,
        endDateTime: endTime,
        status: AppointmentStatus.confirmed,
        type: AppointmentType.onlineVideo,
      );

      // 15 mins before -> Too early
      expect(onlineAppt.canJoinCall(scheduledTime.subtract(const Duration(minutes: 15))), isFalse);

      // 10 mins before -> Allowed
      expect(onlineAppt.canJoinCall(scheduledTime.subtract(const Duration(minutes: 10))), isTrue);

      // 5 mins before -> Allowed
      expect(onlineAppt.canJoinCall(scheduledTime.subtract(const Duration(minutes: 5))), isTrue);

      // During call (10:15) -> Allowed
      expect(onlineAppt.canJoinCall(DateTime(2026, 8, 22, 10, 15)), isTrue);

      // After end time (10:35) -> Prohibited
      expect(onlineAppt.canJoinCall(DateTime(2026, 8, 22, 10, 35)), isFalse);

      // In-clinic type -> Prohibited even at scheduled time
      final inClinicAppt = onlineAppt.copyWith(type: AppointmentType.inClinic);
      expect(inClinicAppt.canJoinCall(scheduledTime), isFalse);
    });

    test('6. Recommendation banner hides instantly on non-empty search (BR-63)', () async {
      bloc.add(const RefreshRecommendations());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<dynamic>((state) {
          return state.recommendations.isNotEmpty && state.shouldShowRecommendations;
        })),
      );

      // When search query is non-empty, shouldShowRecommendations becomes false
      bloc.add(const SearchQueryChanged('Cardiology'));
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<dynamic>((state) {
          return state.searchQuery == 'Cardiology' && !state.shouldShowRecommendations;
        })),
      );
    });

    test('7. Quick actions strip hides when 0 resources exist (BR-34)', () {
      const emptySummary = QuickActionsSummaryModel(
        prescriptionsCount: 0,
        labResultsCount: 0,
        radiologyReportsCount: 0,
      );
      expect(emptySummary.hasAnyResources, isFalse);

      const activeSummary = QuickActionsSummaryModel(
        prescriptionsCount: 2,
        labResultsCount: 0,
        radiologyReportsCount: 0,
      );
      expect(activeSummary.hasAnyResources, isTrue);
    });

    test('8. Filter matching handles partial clinic names, specialty, and type', () {
      final now = DateTime.now();
      final appt = AppointmentModel(
        id: 'match_1',
        doctorId: 'doc_1',
        doctorName: 'Dr. Sherif Zaki',
        doctorSpecialty: 'Cardiology',
        clinicId: 'c_1',
        clinicName: 'Al-Safwa Specialist Clinic',
        scheduledDateTime: now.add(const Duration(days: 2)),
        endDateTime: now.add(const Duration(days: 2, minutes: 30)),
        status: AppointmentStatus.upcoming,
        type: AppointmentType.onlineVideo,
      );

      // Matching filter
      const matchingFilter = AppointmentFilter(
        specialty: 'Cardiology',
        clinicName: 'Safwa',
        type: AppointmentType.onlineVideo,
      );
      expect(matchingFilter.matches(appt), isTrue);

      // Mismatched filter by type
      const mismatchFilter = AppointmentFilter(
        type: AppointmentType.inClinic,
      );
      expect(mismatchFilter.matches(appt), isFalse);
    });
  });
}

/*
 * File Name: appointment_card_actions_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Dependencies: flutter_test, appointment_card.dart, appointment_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Widget and component tests for the AppointmentCard actions, status badges, and join call buttons.
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/features/appointments/data/models/appointment_model.dart';
import 'package:appoynt_mobile_app/features/appointments/presentation/widgets/appointment_card.dart';

void main() {
  group('AppointmentCard Widget & Action Verification Tests', () {
    testWidgets('Upcoming appointment renders Reschedule, Cancel, and View Details', (tester) async {
      final now = DateTime.now();
      final appt = AppointmentModel(
        id: 'card_test_1',
        doctorId: 'doc_1',
        doctorName: 'Dr. Sherif Zaki',
        doctorSpecialty: 'Cardiology',
        clinicId: 'c_1',
        clinicName: 'Al-Safwa Clinic',
        scheduledDateTime: now.add(const Duration(days: 2)),
        endDateTime: now.add(const Duration(days: 2, minutes: 30)),
        status: AppointmentStatus.upcoming,
        type: AppointmentType.inClinic,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppointmentCard(appointment: appt),
          ),
        ),
      );

      expect(find.text('Dr. Sherif Zaki'), findsOneWidget);
      expect(find.text('Cardiology'), findsOneWidget);
      expect(find.text('Reschedule'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('View Details'), findsOneWidget);
      expect(find.text('Book Again'), findsNothing);
    });

    testWidgets('Completed appointment renders Book Again and View Details', (tester) async {
      final now = DateTime.now();
      final appt = AppointmentModel(
        id: 'card_test_2',
        doctorId: 'doc_2',
        doctorName: 'Dr. Salma Nour',
        doctorSpecialty: 'Dermatology',
        clinicId: 'c_2',
        clinicName: 'New Cairo Clinic',
        scheduledDateTime: now.subtract(const Duration(days: 3)),
        endDateTime: now.subtract(const Duration(days: 3, hours: -1)),
        status: AppointmentStatus.completed,
        type: AppointmentType.inClinic,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppointmentCard(appointment: appt),
          ),
        ),
      );

      expect(find.text('Dr. Salma Nour'), findsOneWidget);
      expect(find.text('Book Again'), findsOneWidget);
      expect(find.text('View Details'), findsOneWidget);
      expect(find.text('Reschedule'), findsNothing);
      expect(find.text('Cancel'), findsNothing);
    });
  });
}

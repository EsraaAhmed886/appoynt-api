/*
 * File Name: edit_profile_view_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_test/flutter_test.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/views/edit_profile_view.dart,
 *   package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Widget tests verifying EditProfileView rendering, photo picker triggers, and form submission.
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations_delegate.dart';
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/views/edit_profile_view.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

// Importing GovernorateModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';

class _FakeProfileRepository implements ProfileRepository {
  bool updateProfileCalled = false;

  @override
  Future<UserProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    String? address,
    String? nationalId,
    String? birthDate,
    File? imageFile,
    bool deleteCurrentPhoto = false,
  }) async {
    updateProfileCalled = true;
    return UserProfileModel(
      id: '1',
      first_name: firstName,
      last_name: lastName,
      email: 'john@example.com',
      phone_number: phone,
    );
  }

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    return const [
      GovernorateModel(
        id: 'c96424b4-e13c-4569-b3b4-31780630ab20',
        nameEn: 'Cairo',
        nameAr: 'القاهرة',
        cities: [
          CityModel(
            id: '7f8b9c0d-1e2f-3a4b-5c6d-7e8f9a0b1c2d',
            nameEn: 'Nasr City',
            nameAr: 'مدينة نصر',
          ),
        ],
      ),
    ];
  }

  @override
  Future<List<CityModel>> getCitiesByGovernorate(dynamic governorateId) async {
    return const [];
  }

  @override
  Future<void> deleteProfilePhoto() async {}

  @override
  Future<UserProfileModel?> getCachedProfile() async => null;

  @override
  Future<String?> getCachedProfilePhotoUrl() async => null;

  @override
  Future<UserProfileModel> getUserProfile() async => const UserProfileModel(
        id: '1',
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com',
        phone_number: '1234567890',
      );

  @override
  Future<void> updateUserProfile(
      UpdateProfileRequestModel requestModel) async {}

  @override
  Future<String> uploadProfilePhoto(String file_path) async => 'url';
}

void main() {
  Widget createTestWidget({
    required EditProfileCubit cubit,
    Locale locale = const Locale('en'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: app_localizations_delegates,
      supportedLocales: app_supported_locales,
      home: BlocProvider<EditProfileCubit>.value(
        value: cubit,
        child: const EditProfileView(
          initialFirstName: 'Jane',
          initialLastName: 'Smith',
          initialPhone: '987654321',
        ),
      ),
    );
  }

  group('EditProfileView Widget Tests', () {
    late _FakeProfileRepository fakeRepo;
    late EditProfileCubit cubit;

    setUp(() {
      fakeRepo = _FakeProfileRepository();
      cubit = EditProfileCubit(profileRepository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    testWidgets('renders initial fields and avatar camera badge',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cubit: cubit));
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('Smith'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Governorate'), findsOneWidget);
      expect(find.text('City'), findsOneWidget);
    });

    testWidgets('tapping Save button invokes saveProfile on cubit',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cubit: cubit));
      await tester.pumpAndSettle();

      final Finder saveBtn = find.text('Save');
      await tester.ensureVisible(saveBtn);
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(fakeRepo.updateProfileCalled, isTrue);
    });

    testWidgets('entering 14-digit National ID auto-displays dynamic info badges in English',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cubit: cubit));
      await tester.pumpAndSettle();

      // Find National ID TextFormField
      final Finder nationalIdField = find.widgetWithText(TextFormField, 'National ID');
      expect(nationalIdField, findsOneWidget);

      // Enter female 14-digit National ID (30508078800044 -> 07 Aug 2005, Female)
      await tester.enterText(nationalIdField, '30508078800044');
      await tester.pumpAndSettle();

      expect(find.text('07 Aug 2005'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Auto-detected from National ID'), findsOneWidget);
    });

    testWidgets('entering 14-digit National ID auto-displays localized info badges in Arabic',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cubit: cubit, locale: const Locale('ar')));
      await tester.pumpAndSettle();

      // Find National ID TextFormField with Arabic label
      final Finder nationalIdField = find.widgetWithText(TextFormField, 'الرقم القومي');
      expect(nationalIdField, findsOneWidget);

      // Enter female 14-digit National ID (30508078800044 -> 07 أغسطس 2005, أنثى)
      await tester.enterText(nationalIdField, '30508078800044');
      await tester.pumpAndSettle();

      expect(find.text('07 أغسطس 2005'), findsOneWidget);
      expect(find.text('أنثى'), findsOneWidget);
    });
  });
}

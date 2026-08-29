/*
 * File Name: edit_profile_cubit_test.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: dart:io, package:flutter_test/flutter_test.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Unit tests verifying EditProfileCubit local staging and deferred save execution.
 */

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

// Importing GovernorateModel representation
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';

class _FakeProfileRepository implements ProfileRepository {
  bool updateProfileCalled = false;
  File? receivedImageFile;
  bool receivedDeleteCurrentPhoto = false;

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
    receivedImageFile = imageFile;
    receivedDeleteCurrentPhoto = deleteCurrentPhoto;
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
    return GovernorateModel.defaultGovernorates;
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
  group('EditProfileCubit Unit Tests', () {
    late _FakeProfileRepository fakeRepo;
    late EditProfileCubit cubit;

    setUp(() {
      fakeRepo = _FakeProfileRepository();
      cubit = EditProfileCubit(profileRepository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has no staged image, isPhotoDeleted false, not loading',
        () {
      expect(cubit.state.stagedProfileImage, isNull);
      expect(cubit.state.isPhotoDeleted, isFalse);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.isSuccess, isFalse);
    });

    test(
        'stagePhotoDeletion sets isPhotoDeleted true and clears staged image without calling repo',
        () {
      cubit.stagePhotoDeletion();

      expect(cubit.state.isPhotoDeleted, isTrue);
      expect(cubit.state.stagedProfileImage, isNull);
      expect(fakeRepo.updateProfileCalled, isFalse);
    });

    test('loadGovernorates fetches governorates and populates state', () async {
      await cubit.loadGovernorates(initialGovId: 1, initialCityId: 101);

      expect(cubit.state.governorates.isNotEmpty, isTrue);
      expect(cubit.state.selectedGovernorate?.nameEn, 'Cairo');
      expect(cubit.state.selectedCity?.nameEn, 'Nasr City');
    });

    test('selectGovernorate resets selectedCity', () async {
      await cubit.loadGovernorates(initialGovId: 1, initialCityId: 101);
      expect(cubit.state.selectedCity, isNotNull);

      final giza = cubit.state.governorates.firstWhere((g) => g.nameEn == 'Giza');
      cubit.selectGovernorate(giza);

      expect(cubit.state.selectedGovernorate?.nameEn, 'Giza');
      expect(cubit.state.selectedCity, isNull);
    });

    test('selectCity updates selectedCity in state', () async {
      await cubit.loadGovernorates(initialGovId: 2);
      final oct = cubit.state.selectedGovernorate!.cities.firstWhere((c) => c.nameEn == '6th of October');
      cubit.selectCity(oct);

      expect(cubit.state.selectedCity?.nameEn, '6th of October');
    });

    test('saveProfile executes repo.updateProfile and emits success state',
        () async {
      cubit.stagePhotoDeletion();

      await cubit.saveProfile(
        firstName: 'John',
        lastName: 'Doe',
        phone: '123456',
      );

      expect(fakeRepo.updateProfileCalled, isTrue);
      expect(fakeRepo.receivedDeleteCurrentPhoto, isTrue);
      expect(cubit.state.isSuccess, isTrue);
      expect(cubit.state.isLoading, isFalse);
    });
  });
}

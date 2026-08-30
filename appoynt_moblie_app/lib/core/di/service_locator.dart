/*
 * File Name: service_locator.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:get_it/get_it.dart, package:dio/dio.dart, dio_factory.dart,
 *   auth_remote_datasource.dart, auth_repository_impl.dart, login_usecase.dart,
 *   register_usecase.dart, auth_cubit.dart, profile usecases
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Initializes and manages the singleton instances of services,
 *   repositories, use cases, and cubits using the GetIt service locator.
 */

// Configured network client
import 'package:appoynt_mobile_app/core/api/dio_factory.dart';
// Remote source
import 'package:appoynt_mobile_app/features/auth/data/datasources/auth_remote_datasource.dart';
// Repository implementation
import 'package:appoynt_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
// Repository contract
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart';
// Business logic for login
import 'package:appoynt_mobile_app/features/auth/domain/usecases/login_usecase.dart';
// Business logic for registration
import 'package:appoynt_mobile_app/features/auth/domain/usecases/register_usecase.dart';
// Business logic for verify OTP
import 'package:appoynt_mobile_app/features/auth/domain/usecases/verify_otp_usecase.dart';
// Business logic for resend OTP
import 'package:appoynt_mobile_app/features/auth/domain/usecases/resend_otp_usecase.dart';
// Business logic for forgot password
import 'package:appoynt_mobile_app/features/auth/domain/usecases/forgot_password_usecase.dart';
// Business logic for reset password
import 'package:appoynt_mobile_app/features/auth/domain/usecases/reset_password_usecase.dart';
// State management
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
// Core network client
import 'package:dio/dio.dart';
// Service locator package
import 'package:get_it/get_it.dart';
// Profile Remote Data Source
import 'package:appoynt_mobile_app/features/profile/data/datasources/profile_remote_data_source.dart';
// Profile Repository Interface
import 'package:appoynt_mobile_app/features/profile/domain/repositories/profile_repository.dart';
// Profile Repository Implementation
import 'package:appoynt_mobile_app/features/profile/data/repositories/profile_repository_impl.dart';
// Profile Local Data Source for SharedPreferences caching layer
import 'package:appoynt_mobile_app/features/profile/data/datasources/profile_local_data_source.dart';
// Profile Retrieve Use Case
import 'package:appoynt_mobile_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
// Profile Update Use Case
import 'package:appoynt_mobile_app/features/profile/domain/usecases/update_user_profile_usecase.dart';
// Profile Photo Upload Use Case
import 'package:appoynt_mobile_app/features/profile/domain/usecases/upload_profile_photo_usecase.dart';
// Profile Photo Delete Use Case
import 'package:appoynt_mobile_app/features/profile/domain/usecases/delete_profile_photo_usecase.dart';
// Favorites Remote Data Source
import 'package:appoynt_mobile_app/features/favorites/data/datasources/favorites_remote_data_source.dart';
// Favorites Local Data Source
import 'package:appoynt_mobile_app/features/favorites/data/datasources/favorites_local_data_source.dart';
// Favorites Repository Interface
import 'package:appoynt_mobile_app/features/favorites/domain/repositories/favorites_repository.dart';
// Favorites Repository Implementation
import 'package:appoynt_mobile_app/features/favorites/data/repositories/favorites_repository_impl.dart';
// Favorites Cubit
import 'package:appoynt_mobile_app/features/favorites/presentation/cubit/favorites_cubit.dart';
// Notifications Remote Data Source
import 'package:appoynt_mobile_app/features/notifications/data/datasources/notifications_remote_data_source.dart';
// Notifications Repository Interface
import 'package:appoynt_mobile_app/features/notifications/domain/repositories/notifications_repository.dart';
// Notifications Repository Implementation
import 'package:appoynt_mobile_app/features/notifications/data/repositories/notifications_repository_impl.dart';
// Notifications Cubit
import 'package:appoynt_mobile_app/features/notifications/presentation/cubit/notifications_cubit.dart';
// Doctor Profile Remote Data Source
import 'package:appoynt_mobile_app/features/doctor_profile/data/datasources/doctor_profile_remote_data_source.dart';
// Doctor Profile Repository Contract
import 'package:appoynt_mobile_app/features/doctor_profile/domain/repositories/doctor_profile_repository.dart';
// Doctor Profile Repository Implementation
import 'package:appoynt_mobile_app/features/doctor_profile/data/repositories/doctor_profile_repository_impl.dart';
// Doctor Profile Use Cases
import 'package:appoynt_mobile_app/features/doctor_profile/domain/usecases/get_doctor_profile_use_case.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/usecases/get_doctor_available_slots_use_case.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/usecases/toggle_favorite_doctor_use_case.dart';
// Doctor Profile Cubit
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/cubit/doctor_profile_cubit.dart';
// Booking Availability Remote Data Source
import 'package:appoynt_mobile_app/features/booking/data/datasources/availability_remote_data_source.dart';
// Booking Availability Repository Contract
import 'package:appoynt_mobile_app/features/booking/domain/repositories/availability_repository.dart';
// Booking Availability Repository Implementation
import 'package:appoynt_mobile_app/features/booking/data/repositories/availability_repository_impl.dart';
// Booking Use Cases
import 'package:appoynt_mobile_app/features/booking/domain/usecases/get_doctor_clinics_use_case.dart';
import 'package:appoynt_mobile_app/features/booking/domain/usecases/get_available_slots_use_case.dart';
import 'package:appoynt_mobile_app/features/booking/domain/usecases/create_slot_hold_use_case.dart';
import 'package:appoynt_mobile_app/features/booking/domain/usecases/release_slot_hold_use_case.dart';
// Booking Cubit
import 'package:appoynt_mobile_app/features/booking/presentation/cubit/slot_booking_cubit.dart';

/// Global instance of the service locator.
final GetIt get_it = GetIt.instance;

/// Short alias for the service locator instance matching sl convention.
final GetIt sl = get_it;

/// Initializes all application-wide dependencies.
Future<void> setup_service_locator() async {
  // ── Core Dependencies ──────────────────────────────────

  /// Registering the Dio instance provided by the factory.
  final Dio dio = DioFactory.get_dio();
  get_it.registerLazySingleton<Dio>(() {
    return dio;
  });

  /// Registering the Profile Local Data Source implementation.
  get_it.registerLazySingleton<ProfileLocalDataSource>(() {
    // Return concrete SharedPreferences-backed cache implementation
    return ProfileLocalDataSourceImpl();
  });

  /// Registering the Profile Remote Data Source implementation.
  get_it.registerLazySingleton<ProfileRemoteDataSource>(() {
    return ProfileRemoteDataSourceImpl(get_it<Dio>());
  });

  /// Registering the Profile Repository implementation.
  get_it.registerLazySingleton<ProfileRepository>(() {
    return ProfileRepositoryImpl(
      // Inject the remote API data source dependency
      remote_data_source: get_it<ProfileRemoteDataSource>(),
      // Inject the local SharedPreferences cache data source dependency
      local_data_source: get_it<ProfileLocalDataSource>(),
    );
  });

  /// Registering the Get User Profile Use Case.
  get_it.registerLazySingleton<GetUserProfileUseCase>(() {
    return GetUserProfileUseCase(get_it<ProfileRepository>());
  });

  /// Registering the Update User Profile Use Case.
  get_it.registerLazySingleton<UpdateUserProfileUseCase>(() {
    return UpdateUserProfileUseCase(get_it<ProfileRepository>());
  });

  /// Registering the Upload Profile Photo Use Case.
  get_it.registerLazySingleton<UploadProfilePhotoUseCase>(() {
    // Inject the profile repository for multipart upload delegation
    return UploadProfilePhotoUseCase(get_it<ProfileRepository>());
  });

  /// Registering the Delete Profile Photo Use Case.
  get_it.registerLazySingleton<DeleteProfilePhotoUseCase>(() {
    // Inject the profile repository for photo deletion delegation
    return DeleteProfilePhotoUseCase(get_it<ProfileRepository>());
  });

  // ── Authentication Feature ─────────────────────────────

  /// Registering the Remote Data Source implementation.
  get_it.registerLazySingleton<AuthRemoteDataSource>(() {
    return AuthRemoteDataSourceImpl(get_it<Dio>());
  });

  /// Registering the Repository implementation using the domain contract.
  get_it.registerLazySingleton<AuthRepository>(() {
    return AuthRepositoryImpl(get_it<AuthRemoteDataSource>());
  });

  /// Registering the Login Use Case.
  get_it.registerLazySingleton<LoginUseCase>(() {
    return LoginUseCase(get_it<AuthRepository>());
  });

  /// Registering the Register Use Case.
  get_it.registerLazySingleton<RegisterUseCase>(() {
    return RegisterUseCase(get_it<AuthRepository>());
  });

  /// Registering the Verify OTP Use Case.
  get_it.registerLazySingleton<VerifyOtpUseCase>(() {
    return VerifyOtpUseCase(get_it<AuthRepository>());
  });

  /// Registering the Resend OTP Use Case.
  get_it.registerLazySingleton<ResendOtpUseCase>(() {
    return ResendOtpUseCase(get_it<AuthRepository>());
  });

  /// Registering the Forgot Password Use Case.
  get_it.registerLazySingleton<ForgotPasswordUseCase>(() {
    return ForgotPasswordUseCase(get_it<AuthRepository>());
  });

  /// Registering the Reset Password Use Case.
  get_it.registerLazySingleton<ResetPasswordUseCase>(() {
    return ResetPasswordUseCase(get_it<AuthRepository>());
  });

  /// Registering the Auth Cubit as a lazy singleton to preserve challenge state across routing boundaries.
  get_it.registerLazySingleton<AuthCubit>(() {
    return AuthCubit(
      get_it<LoginUseCase>(),
      get_it<RegisterUseCase>(),
      get_it<VerifyOtpUseCase>(),
      get_it<ResendOtpUseCase>(),
      get_it<ForgotPasswordUseCase>(),
      get_it<ResetPasswordUseCase>(),
    );
  });

  // ── Favorites Feature ──────────────────────────────────

  /// Registering the Favorites Remote Data Source implementation.
  get_it.registerLazySingleton<FavoritesRemoteDataSource>(() {
    return FavoritesRemoteDataSourceImpl();
  });

  /// Registering the Favorites Local Data Source implementation.
  get_it.registerLazySingleton<FavoritesLocalDataSource>(() {
    return FavoritesLocalDataSourceImpl();
  });

  /// Registering the Favorites Repository implementation.
  get_it.registerLazySingleton<FavoritesRepository>(() {
    return FavoritesRepositoryImpl(
      remote_data_source: get_it<FavoritesRemoteDataSource>(),
      local_data_source: get_it<FavoritesLocalDataSource>(),
    );
  });

  /// Registering the Favorites Cubit factory instance.
  get_it.registerFactory<FavoritesCubit>(() {
    return FavoritesCubit(
      repository: get_it<FavoritesRepository>(),
    );
  });

  // ── Notifications Feature ───────────────────────────────

  /// Registering the Notifications Remote Data Source implementation.
  get_it.registerLazySingleton<NotificationsRemoteDataSource>(() {
    return NotificationsRemoteDataSourceImpl();
  });

  /// Registering the Notifications Repository implementation.
  get_it.registerLazySingleton<NotificationsRepository>(() {
    return NotificationsRepositoryImpl(
      remote_data_source: get_it<NotificationsRemoteDataSource>(),
    );
  });

  /// Registering the Notifications Cubit factory instance.
  get_it.registerFactory<NotificationsCubit>(() {
    return NotificationsCubit(
      repository: get_it<NotificationsRepository>(),
    );
  });

  // ── Doctor Profile Feature ───────────────────────────────

  /// Registering the Doctor Profile Remote Data Source implementation.
  get_it.registerLazySingleton<DoctorProfileRemoteDataSource>(() {
    return DoctorProfileRemoteDataSourceImpl(get_it<Dio>());
  });

  /// Registering the Doctor Profile Repository implementation.
  get_it.registerLazySingleton<DoctorProfileRepository>(() {
    return DoctorProfileRepositoryImpl(
      remote_data_source: get_it<DoctorProfileRemoteDataSource>(),
    );
  });

  /// Registering Get Doctor Profile Use Case.
  get_it.registerLazySingleton<GetDoctorProfileUseCase>(() {
    return GetDoctorProfileUseCase(get_it<DoctorProfileRepository>());
  });

  /// Registering Get Doctor Available Slots Use Case.
  get_it.registerLazySingleton<GetDoctorAvailableSlotsUseCase>(() {
    return GetDoctorAvailableSlotsUseCase(get_it<DoctorProfileRepository>());
  });

  /// Registering Toggle Favorite Doctor Use Case.
  get_it.registerLazySingleton<ToggleFavoriteDoctorUseCase>(() {
    return ToggleFavoriteDoctorUseCase(get_it<DoctorProfileRepository>());
  });

  /// Registering Doctor Profile Cubit factory instance.
  get_it.registerFactory<DoctorProfileCubit>(() {
    return DoctorProfileCubit(
      get_doctor_profile_use_case: get_it<GetDoctorProfileUseCase>(),
      get_doctor_available_slots_use_case:
          get_it<GetDoctorAvailableSlotsUseCase>(),
      toggle_favorite_doctor_use_case:
          get_it<ToggleFavoriteDoctorUseCase>(),
    );
  });

  // ── Booking & Time Slots Feature ───────────────────────

  /// Registering Availability Remote Data Source.
  get_it.registerLazySingleton<AvailabilityRemoteDataSource>(() {
    return AvailabilityRemoteDataSourceImpl(get_it<Dio>());
  });

  /// Registering Availability Repository.
  get_it.registerLazySingleton<AvailabilityRepository>(() {
    return AvailabilityRepositoryImpl(get_it<AvailabilityRemoteDataSource>());
  });

  /// Registering Get Doctor Clinics Use Case.
  get_it.registerLazySingleton<GetDoctorClinicsUseCase>(() {
    return GetDoctorClinicsUseCase(get_it<AvailabilityRepository>());
  });

  /// Registering Get Available Slots Use Case.
  get_it.registerLazySingleton<GetAvailableSlotsUseCase>(() {
    return GetAvailableSlotsUseCase(get_it<AvailabilityRepository>());
  });

  /// Registering Create Slot Hold Use Case.
  get_it.registerLazySingleton<CreateSlotHoldUseCase>(() {
    return CreateSlotHoldUseCase(get_it<AvailabilityRepository>());
  });

  /// Registering Release Slot Hold Use Case.
  get_it.registerLazySingleton<ReleaseSlotHoldUseCase>(() {
    return ReleaseSlotHoldUseCase(get_it<AvailabilityRepository>());
  });

  /// Registering Slot Booking Cubit factory instance.
  get_it.registerFactory<SlotBookingCubit>(() {
    return SlotBookingCubit(
      get_doctor_clinics_use_case: get_it<GetDoctorClinicsUseCase>(),
      get_available_slots_use_case: get_it<GetAvailableSlotsUseCase>(),
      create_slot_hold_use_case: get_it<CreateSlotHoldUseCase>(),
      release_slot_hold_use_case: get_it<ReleaseSlotHoldUseCase>(),
    );
  });
}


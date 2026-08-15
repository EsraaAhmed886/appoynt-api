/*
 * File Name: service_locator.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:get_it/get_it.dart, package:dio/dio.dart, dio_factory.dart,
 *   auth_remote_datasource.dart, auth_repository_impl.dart, login_usecase.dart,
 *   register_usecase.dart, auth_cubit.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
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

/// Global instance of the service locator.
final GetIt get_it = GetIt.instance;

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
}

/*
 * File Name: service_locator.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: 
 *   - package:get_it/get_it.dart
 *   - package:dio/dio.dart
 *   - dio_factory.dart
 *   - auth_remote_datasource.dart
 *   - auth_repository_impl.dart
 *   - login_usecase.dart
 *   - register_usecase.dart
 *   - auth_cubit.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Initializes and manages the singleton instances of services, repositories, 
 *   use cases, and cubits using the GetIt service locator.
 */

import 'package:appoynt_mobile_app/core/api/dio_factory.dart'; // Configured network client
import 'package:appoynt_mobile_app/features/auth/data/datasources/auth_remote_datasource.dart'; // Remote source
import 'package:appoynt_mobile_app/features/auth/data/repositories/auth_repository_impl.dart'; // Repository implementation
import 'package:appoynt_mobile_app/features/auth/domain/repositories/auth_repository.dart'; // Repository contract
import 'package:appoynt_mobile_app/features/auth/domain/usecases/login_usecase.dart'; // Business logic
import 'package:appoynt_mobile_app/features/auth/domain/usecases/register_usecase.dart'; // Business logic
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart'; // State management
import 'package:dio/dio.dart'; // Core network client
import 'package:get_it/get_it.dart'; // Service locator package

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

  /// Registering the Auth Cubit (Factory to ensure fresh state if needed).
  get_it.registerFactory<AuthCubit>(() {
    return AuthCubit(
      get_it<LoginUseCase>(),
      get_it<RegisterUseCase>(),
    );
  });
}

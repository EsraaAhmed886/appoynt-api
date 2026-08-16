/*
 * File Name: usecase.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:dartz/dartz.dart, package:equatable/equatable.dart,
 *   package:appoynt_mobile_app/core/error/failures.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the base abstract contract for all business logic UseCases
 *   in the application, following the Clean Architecture pattern.
 */

// Importing dartz for functional error handling (Either type)
import 'package:dartz/dartz.dart';
// Importing Equatable for value-based parameter comparison
import 'package:equatable/equatable.dart';
// Importing failure definitions for error states
import 'package:appoynt_mobile_app/core/error/failures.dart';

/// Abstract base class that all UseCases must implement.
/// [Type] defines the success result type.
/// [Params] defines the input parameter type required for execution.
abstract class UseCase<T, Params> {
  /// Base constructor
  const UseCase();

  /// The main execution method for the UseCase.
  /// Returns a Future containing an Either (Failure on the left, Success on the right).
  Future<Either<Failure, T>> call(Params params);
}

/// A standard class used to represent the absence of parameters in a UseCase call.
class NoParams extends Equatable {
  /// Default constructor
  const NoParams();

  @override
  /// No properties to compare for NoParams.
  List<Object?> get props {
    return [];
  }
}

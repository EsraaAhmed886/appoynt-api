/*
 * File Name: failures.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Defines the failure hierarchy used to represent domain-level errors
 *   throughout the application's clean architecture layers.
 */

import 'package:equatable/equatable.dart'; // Importing Equatable for failure object comparison

/// Base abstract class for all failure types in the system.
abstract class Failure extends Equatable {
  /// Base failure has no specific properties for comparison.
  const Failure();

  @override
  List<Object?> get props {
    return [];
  }
}

/// A specific failure representing an error occurring during a server/remote request.
class ServerFailure extends Failure {
  /// Default constructor
  const ServerFailure();
}

/// A specific failure representing an error occurring during local database or cache access.
class CacheFailure extends Failure {
  /// Default constructor
  const CacheFailure();
}

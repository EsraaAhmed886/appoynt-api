/*
 * File Name: global_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart, package:flutter/material.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the configuration states for global settings,
 *   such as current locale (language).
 */

part of 'global_cubit.dart'; // Linking this state definition to global_cubit.dart

// Class representing the global settings state container
class GlobalState extends Equatable {
  // Active locale value parameter for the application settings
  final Locale active_locale;

  // Constructor initializing the active locale
  const GlobalState({required this.active_locale});

  @override
  // Array defining the properties checked in value comparisons
  List<Object?> get props {
    // Return parameters array containing the active locale
    return [active_locale];
  }
}

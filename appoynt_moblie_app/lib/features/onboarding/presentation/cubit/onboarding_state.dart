/*
 * File Name: onboarding_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - onboarding_cubit.dart (Part of)
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Defines the states emitted during onboarding flow navigation.
 */

// Declaring that this file is a part of onboarding_cubit.dart
part of 'onboarding_cubit.dart';

// Abstract class defining base onboarding state extending equatable features
abstract class OnboardingState extends Equatable {
  // Constant constructor initializing the abstract state class
  const OnboardingState();

  // Override getter returning object properties checklist to compare states
  @override
  List<Object> get props {
    // Return empty list by default for base state class comparisons
    return const [];
  }
}

// Initial state class representing the first loading phase of onboarding
class OnboardingInitial extends OnboardingState {}

// Page update state class indicating a change in the active slide index
class OnboardingPageUpdate extends OnboardingState {
  // Constant integer variable indicating the active page index
  final int page_index;

  // Constructor mapping the page_index parameter value
  const OnboardingPageUpdate(this.page_index);

  // Override getter returning props checklist containing page_index
  @override
  List<Object> get props {
    // Return list holding the active page_index identifier
    return [page_index];
  }
}

// Completed state class representing onboarding completion or skip action
class OnboardingCompleted extends OnboardingState {}

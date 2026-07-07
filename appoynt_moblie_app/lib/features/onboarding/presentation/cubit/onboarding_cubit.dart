/*
 * File Name: onboarding_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:equatable/equatable.dart
 *   - package:flutter_bloc/flutter_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Manages the onboarding presentation states and screen transition index changes.
 */

// Importing equatable package to facilitate object property comparisons
import 'package:equatable/equatable.dart';
// Importing standard flutter bloc package to implement state management core BLoC architecture
import 'package:flutter_bloc/flutter_bloc.dart';

// Declare parts state file holding state classes
part 'onboarding_state.dart';

// Cubit class containing transition logic for the onboarding screen
class OnboardingCubit extends Cubit<OnboardingState> {
  // Constructor initializing cubit with onboarding initial state
  OnboardingCubit() : super(OnboardingInitial());

  // Function to change the active page index state
  void page_changed(int index) {
    // Emit new state containing the active page index value
    emit(OnboardingPageUpdate(index));
  }

  // Function to trigger onboarding completion state
  void onboarding_completed() {
    // Emit onboarding completed state indicating landing completion
    emit(OnboardingCompleted());
  }
}

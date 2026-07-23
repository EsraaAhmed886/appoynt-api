/*
 * File Name: profile_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Implement the Patient Profile Cubit orchestrating UI updates, validations, and saves.
 */

// Importing the BLoC library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing the profile state definitions
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing the patient profile entity definition
import 'package:appoynt_mobile_app/features/profile/domain/entities/patient_profile.dart';
// Importing the insurance card model definition
import 'package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart';
// Importing the test result model definition
import 'package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart';

// Profile business logic Cubit controller class
class ProfileCubit extends Cubit<ProfileState> {
  // Master list of available chronic conditions options (to be fetched from API/DB)
  final List<Map<String, String>> available_conditions = const [
    // Diabetes details EN/AR and icon key
    {
      // English label
      'en': 'Diabetes',
      // Arabic label
      'ar': 'مرض السكري',
      // Icon identifier
      'icon_key': 'diabetes',
    },
    // Hypertension details EN/AR and icon key
    {
      // English label
      'en': 'Hypertension',
      // Arabic label
      'ar': 'ارتفاع ضغط الدم',
      // Icon identifier
      'icon_key': 'hypertension',
    },
    // Gout details EN/AR and icon key
    {
      // English label
      'en': 'Gout',
      // Arabic label
      'ar': 'النقرس',
      // Icon identifier
      'icon_key': 'gout',
    },
    // Asthma details EN/AR and icon key
    {
      // English label
      'en': 'Asthma',
      // Arabic label
      'ar': 'الربو',
      // Icon identifier
      'icon_key': 'asthma',
    },
    // Heart Disease details EN/AR and icon key
    {
      // English label
      'en': 'Heart Disease',
      // Arabic label
      'ar': 'أمراض القلب',
      // Icon identifier
      'icon_key': 'heart_disease',
    },
  ];

  // Constructor initializing with initial blank state configuration
  ProfileCubit() : super(ProfileState.initial());

  // Triggers loading sequence for retrieving patient profile details
  Future<void> load_profile() async {
    // Emit loading state values
    emit(state.copyWith(status: ProfileStatus.loading));
    // Simulate API fetch delay
    await Future.delayed(
      // Delay parameters
      const Duration(
        // Delay count in milliseconds
        milliseconds: 800,
      ),
    );
    // Populate mockup initial patient details
    const PatientProfile loaded_profile = PatientProfile(
      // First name
      first_name: 'kareem',
      // Last name
      last_name: 'mangood',
      // Read-only phone mockup
      phone: '01234567890',
      // Saved email representation
      email: 'admin@gmail.com',
      // Gender setting selection
      gender: 'Male',
      // Address string
      address: 'Cairo, Egypt',
      // National ID (14 digits)
      national_id: '29712050102345',
      // Weight indicator
      weight: '80',
      // Height indicator
      height: '180',
      // Smoking flag
      smoking: 'No',
      // Food allergies array
      food_allergies: ['Peanuts'],
      // Medication allergies array
      medication_allergies: ['Penicillin'],
      // Prescriptions array (rich map schema with clinical metadata)
      prescriptions: [
        {
          'id': '1',
          'name': 'Panadol Extra 500mg',
          'dosage': '1 Tablet',
          'frequency': 'Twice Daily',
          'duration': '7 Days',
          'status': 'Active',
          'doctor': 'Dr. Ahmed Hassan',
          'date': '20 Jul 2026',
          'attachment': null,
        }
      ],
      // Lab test list
      lab_tests: [],
      // Scan test list
      scans: [],
      // Chronic diseases array
      chronic_conditions: ['Hypertension'],
      // Insurance plan array
      insurance_cards: [
        // MetLife mockup card details
        InsuranceCard(
          // Card label
          card_name: 'MetLife Medical Insurance',
          // Policy code
          card_number: '12345678',
          // Provider brand
          provider_name: 'MetLife Egypt',
          // File attachment path
          document_path: '/docs/metlife.pdf',
          // Active expiry timing info
          expiry_date: '26 December 2025',
        ),
      ],
      // Empty mock avatar URL path
      avatar_url: '',
    );
    // Emit successfully loaded state updates
    emit(
      // State details copy with loaded structures
      state.copyWith(
        // Set success
        status: ProfileStatus.success,
        // Bind profile
        profile: loaded_profile,
        // Bind temp profile copy
        temp_profile: loaded_profile,
        // Reset dirty status
        is_dirty: false,
      ),
    );
  }

  // Update temp draft properties inside profile state tracker
  void update_temp_profile(PatientProfile updated_temp) {
    // Clean string fields helper variables before comparisons
    final String initial_first = state.profile.first_name.trim();
    // Clean initial last name
    final String initial_last = state.profile.last_name.trim();
    // Clean initial email
    final String initial_email = state.profile.email.trim().toLowerCase();
    // Clean initial address
    final String initial_address = state.profile.address.trim();
    // Clean initial national_id
    final String initial_national_id = state.profile.national_id.trim();
    // Clean initial weight
    final String initial_weight = state.profile.weight.trim();
    // Clean initial height
    final String initial_height = state.profile.height.trim();
    // Clean initial gender
    final String initial_gender = state.profile.gender.trim();
    // Clean initial smoking choice
    final String initial_smoking = state.profile.smoking.trim();
    // Clean initial avatar URL path
    final String initial_avatar = state.profile.avatar_url.trim();

    // Clean current temp parameters inputs
    final String current_first = updated_temp.first_name.trim();
    // Clean temp last name
    final String current_last = updated_temp.last_name.trim();
    // Clean temp email
    final String current_email = updated_temp.email.trim().toLowerCase();
    // Clean temp address
    final String current_address = updated_temp.address.trim();
    // Clean temp national_id
    final String current_national_id = updated_temp.national_id.trim();
    // Clean temp weight
    final String current_weight = updated_temp.weight.trim();
    // Clean temp height
    final String current_height = updated_temp.height.trim();
    // Clean temp gender
    final String current_gender = updated_temp.gender.trim();
    // Clean temp smoking choice
    final String current_smoking = updated_temp.smoking.trim();
    // Clean temp avatar URL path
    final String current_avatar = updated_temp.avatar_url.trim();

    // Check if any property was changed using comparison checks
    bool has_changes = false;
    // Check first name change
    if (current_first != initial_first) {
      // Set changed
      has_changes = true;
    } else if (current_last != initial_last) {
      // Set changed
      has_changes = true;
    } else if (current_email != initial_email) {
      // Set changed
      has_changes = true;
    } else if (current_address != initial_address) {
      // Set changed
      has_changes = true;
    } else if (current_national_id != initial_national_id) {
      // Set changed
      has_changes = true;
    } else if (current_weight != initial_weight) {
      // Set changed
      has_changes = true;
    } else if (current_height != initial_height) {
      // Set changed
      has_changes = true;
    } else if (current_gender != initial_gender) {
      // Set changed
      has_changes = true;
    } else if (current_smoking != initial_smoking) {
      // Set changed
      has_changes = true;
    } else if (current_avatar != initial_avatar) {
      // Set changed
      has_changes = true;
    } else {
      // No changes found
      has_changes = false;
    }

    // Emit updated temp state tracking changes dirty status
    emit(
      // Copy current properties mapping modifications
      state.copyWith(
        // Maintain success state or generic trigger
        status: ProfileStatus.success,
        // Bind modified temp profile copy
        temp_profile: updated_temp,
        // Update dirty status
        is_dirty: has_changes,
      ),
    );
  }

  // Submits the updated profile properties to mock repository backend
  Future<void> update_profile() async {
    // Verify changes exist using Yoda comparison
    if (false == state.is_dirty) {
      // Return early to save execution payload
      return;
    } else {
      // Proceed with update flow
      emit(state.copyWith(status: ProfileStatus.updating));
      // Simulate backend save delay duration
      await Future.delayed(
        // Delay settings
        const Duration(
          // Duration count
          milliseconds: 800,
        ),
      );
      // Construct final saved profile with trimmed inputs
      final PatientProfile saved_profile = state.temp_profile.copyWith(
        // Trim first name
        first_name: state.temp_profile.first_name.trim(),
        // Trim last name
        last_name: state.temp_profile.last_name.trim(),
        // Lowercase and trim email
        email: state.temp_profile.email.trim().toLowerCase(),
        // Trim address field
        address: state.temp_profile.address.trim(),
        // Force immutable phone number
        phone: state.profile.phone,
      );
      // Emit success state updating source profile snapshot
      emit(
        // Duplicate state configurations
        state.copyWith(
          // Set update success status
          status: ProfileStatus.updateSuccess,
          // Bind new profile
          profile: saved_profile,
          // Bind new temp copy
          temp_profile: saved_profile,
          // Clear dirty flag
          is_dirty: false,
        ),
      );
    }
  }

  // Restore current editing form values back to saved profile values
  void discard_changes() {
    // Revert draft changes back to initial state
    emit(
      // copy properties
      state.copyWith(
        // Status reset
        status: ProfileStatus.success,
        // Revert temp copy back to profile values
        temp_profile: state.profile,
        // Clear dirty status
        is_dirty: false,
      ),
    );
  }

  // Dynamic status modifier to resolve page navigation return triggers
  void reset_status() {
    // Reset state status back to base success mode
    emit(state.copyWith(status: ProfileStatus.success));
  }

  // Update password parameters validating requirements criteria
  Future<void> change_password(String current_pw, String new_pw) async {
    // Emits password updating status
    emit(state.copyWith(status: ProfileStatus.passwordUpdating));
    // Simulate delay
    await Future.delayed(
      // Delay specs
      const Duration(
        // Duration count
        milliseconds: 600,
      ),
    );
    // Verify current password matches static credentials using Yoda comparison
    if ("123asdASD!@#" != current_pw) {
      // Emit password update error status
      emit(
        // State copy with error msg details
        state.copyWith(
          // Set error
          status: ProfileStatus.passwordError,
          // Bind description
          error_message: 'Current password is incorrect.',
        ),
      );
    } else {
      // Emit password change success status
      emit(
        // State copy
        state.copyWith(
          // Set success
          status: ProfileStatus.passwordSuccess,
        ),
      );
    }
  }

  // Add customized food or medication allergy item to list
  void add_allergy(String allergy_name, String category_type) {
    // Verify allergy name is not empty after trim
    if (allergy_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Check allergy category type using Yoda comparisons
      if ('food' == category_type) {
        // Create duplicate list appending new item
        final List<String> updated_list =
            List<String>.from(state.profile.food_allergies)
              ..add(allergy_name.trim());
        // Create profile instance clone
        final PatientProfile updated_profile =
            state.profile.copyWith(food_allergies: updated_list);
        // Emit updated profile state configurations
        emit(
          // Copy configs
          state.copyWith(
            // Success status
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      } else {
        // Create duplicate list appending new medication allergy item
        final List<String> updated_list =
            List<String>.from(state.profile.medication_allergies)
              ..add(allergy_name.trim());
        // Create profile clone
        final PatientProfile updated_profile =
            state.profile.copyWith(medication_allergies: updated_list);
        // Emit updated state
        emit(
          // Copy configs
          state.copyWith(
            // Success status
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      }
    }
  }

  // Remove customized food or medication allergy item from list
  void remove_allergy(String allergy_name, String category_type) {
    if ('food' == category_type) {
      final List<String> updated_list =
          List<String>.from(state.profile.food_allergies)..remove(allergy_name);
      final PatientProfile updated_profile =
          state.profile.copyWith(food_allergies: updated_list);
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: updated_profile,
          temp_profile: updated_profile,
        ),
      );
    } else {
      final List<String> updated_list =
          List<String>.from(state.profile.medication_allergies)
            ..remove(allergy_name);
      final PatientProfile updated_profile =
          state.profile.copyWith(medication_allergies: updated_list);
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: updated_profile,
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Add rich prescription map entry to the patient medications list
  void add_prescription(Map<String, dynamic> prescription_data) {
    // Verify medication name is valid after trim checks
    final String name = (prescription_data['name'] as String? ?? '').trim();
    // Return early if the name field is empty
    if (name.isEmpty) {
      return;
    } else {
      // Clone prescriptions list appending new rich entry
      final List<Map<String, dynamic>> updated_list =
          List<Map<String, dynamic>>.from(state.profile.prescriptions)
            ..add(prescription_data);
      // Clone profile structures with updated list
      final PatientProfile updated_profile =
          state.profile.copyWith(prescriptions: updated_list);
      // Emit updated states
      emit(
        // Copy configs
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Remove a prescription entry by its unique id field from the list
  void remove_prescription(String prescription_id) {
    // Filter out the entry matching the given id
    final List<Map<String, dynamic>> updated_list =
        List<Map<String, dynamic>>.from(state.profile.prescriptions)
          ..removeWhere((item) => item['id'] == prescription_id);
    // Clone profile with filtered list
    final PatientProfile updated_profile =
        state.profile.copyWith(prescriptions: updated_list);
    // Emit updated state
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Add diagnostic reports tests or scans file attachment metadata
  void add_test_result(
      String doc_name,
      String upload_date,
      String file_path,
      String scan_type, {
      String? facility_name,
      String status = 'normal',
      String? doctor_name,
      String? notes,
  }) {
    // Verify attachment name parameter is valid
    if (doc_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Build test result instance mapping metadata fields
      final TestResult result = TestResult(
        // Bind document name
        document_name: doc_name.trim(),
        // Bind calendar date
        date: upload_date,
        // Bind document physical path
        document_path: file_path,
        // Bind result type indicator
        type: scan_type,
        // Bind facility name
        facility_name: facility_name,
        // Bind result status
        status: status,
        // Bind prescribing doctor
        doctor_name: doctor_name,
        // Bind additional notes
        notes: notes,
      );
      // Check scan type classification using Yoda comparisons
      if ('lab_test' == scan_type) {
        // Clone lab list adding result entry
        final List<TestResult> updated_list =
            List<TestResult>.from(state.profile.lab_tests)..add(result);
        // Clone profile model details
        final PatientProfile updated_profile =
            state.profile.copyWith(lab_tests: updated_list);
        // Emit updated states
        emit(
          // Copy configs
          state.copyWith(
            // Status success
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      } else {
        // Clone scan list adding result entry
        final List<TestResult> updated_list =
            List<TestResult>.from(state.profile.scans)..add(result);
        // Clone profile details
        final PatientProfile updated_profile =
            state.profile.copyWith(scans: updated_list);
        // Emit updated states
        emit(
          // Copy configs
          state.copyWith(
            // Status success
            status: ProfileStatus.success,
            // Bind profile
            profile: updated_profile,
            // Bind temp copy
            temp_profile: updated_profile,
          ),
        );
      }
    }
  }

  // Toggle chronic conditions selection flags dynamically
  void toggle_chronic_condition(String condition_label) {
    // Verify condition parameter label is valid
    if (condition_label.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Clone chronic conditions array list representation
      final List<String> updated_list =
          List<String>.from(state.profile.chronic_conditions);
      // Check if tag is already selected using list checks
      if (updated_list.contains(condition_label)) {
        // Remove item from active selection list
        updated_list.remove(condition_label);
      } else {
        // Append item to active selection list
        updated_list.add(condition_label);
      }
      // Clone profile models parameters
      final PatientProfile updated_profile =
          state.profile.copyWith(chronic_conditions: updated_list);
      // Emit updated states
      emit(
        // Copy configs
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Update a list field inside the patient profile dynamically
  void update_profile_field(String field, List<String> values) {
    PatientProfile updated_profile = state.profile;
    if ('food_allergies' == field) {
      updated_profile = state.profile.copyWith(food_allergies: values);
    } else if ('medication_allergies' == field) {
      updated_profile = state.profile.copyWith(medication_allergies: values);
    } else if ('chronic_conditions' == field) {
      updated_profile = state.profile.copyWith(chronic_conditions: values);
    }
    emit(
      state.copyWith(
        status: ProfileStatus.success,
        profile: updated_profile,
        temp_profile: updated_profile,
      ),
    );
  }

  // Add insurance card coverage information models
  void add_insurance_card(String card_name, String card_number,
      String provider_name, String document_path, String expiry_date) {
    // Verify insurance card name parameter is valid
    if (card_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Build insurance card policy instance
      final InsuranceCard card = InsuranceCard(
        // Bind card name
        card_name: card_name.trim(),
        // Bind card number
        card_number: card_number.trim(),
        // Bind provider brand
        provider_name: provider_name.trim(),
        // Bind file attachment path
        document_path: document_path,
        // Bind policy expiry date
        expiry_date: expiry_date,
      );
      // Clone insurance list adding card entry
      final List<InsuranceCard> updated_list =
          List<InsuranceCard>.from(state.profile.insurance_cards)..add(card);
      // Clone profile specifications
      final PatientProfile updated_profile =
          state.profile.copyWith(insurance_cards: updated_list);
      // Emit updated state properties
      emit(
        // Copy state properties
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Remove insurance card by list index
  void remove_insurance_card(int index) {
    // Verify if index resides within bounds
    if (index < 0 || index >= state.profile.insurance_cards.length) {
      // Return early
      return;
    } else {
      // Clone insurance list removing card at index
      final List<InsuranceCard> updated_list =
          List<InsuranceCard>.from(state.profile.insurance_cards)
            ..removeAt(index);
      // Clone profile specifications
      final PatientProfile updated_profile =
          state.profile.copyWith(insurance_cards: updated_list);
      // Emit updated state properties
      emit(
        // Copy state properties
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }

  // Edit insurance card by list index
  void edit_insurance_card(int index, String card_name, String card_number,
      String provider_name, String document_path, String expiry_date) {
    // Verify if index resides within bounds or empty parameters
    if (index < 0 ||
        index >= state.profile.insurance_cards.length ||
        card_name.trim().isEmpty) {
      // Return early
      return;
    } else {
      // Build updated insurance card policy instance
      final InsuranceCard card = InsuranceCard(
        // Bind card name
        card_name: card_name.trim(),
        // Bind card number
        card_number: card_number.trim(),
        // Bind provider brand
        provider_name: provider_name.trim(),
        // Bind file attachment path
        document_path: document_path,
        // Bind policy expiry date
        expiry_date: expiry_date,
      );
      // Clone insurance list
      final List<InsuranceCard> updated_list =
          List<InsuranceCard>.from(state.profile.insurance_cards);
      // Replace item at index
      updated_list[index] = card;
      // Clone profile specifications
      final PatientProfile updated_profile =
          state.profile.copyWith(insurance_cards: updated_list);
      // Emit updated state properties
      emit(
        // Copy state properties
        state.copyWith(
          // Status success
          status: ProfileStatus.success,
          // Bind profile
          profile: updated_profile,
          // Bind temp copy
          temp_profile: updated_profile,
        ),
      );
    }
  }
}

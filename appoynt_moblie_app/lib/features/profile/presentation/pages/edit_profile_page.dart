/*
 * File Name: edit_profile_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Defines the Edit Profile layout form fields, validators, and unsaved changes dialogs.
 */

// Importing standard I/O for File operations
import 'dart:io';
// Importing BLoC state builders
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing official Image Picker library package
import 'package:image_picker/image_picker.dart';
// Importing routing and localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing reusable text field widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';
import 'package:appoynt_mobile_app/core/widgets/app_date_picker.dart';
// Patient Profile Editor form screen stateful widget representation
class EditProfilePage extends StatefulWidget {
  // Constructor mapping key
  const EditProfilePage({super.key});

  // State builder definition
  @override
  State<EditProfilePage> createState() {
    // Return edit profile state tracker
    return _EditProfilePageState();
  }
}

// State tracker class implementation for EditProfilePage
class _EditProfilePageState extends State<EditProfilePage> {
  // Global form key constraint configuration
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  // Text controllers mapping inputs
  late TextEditingController _first_name_controller;
  // Last name text controller
  late TextEditingController _last_name_controller;
  // Email text controller
  late TextEditingController _email_controller;
  // Address text controller
  late TextEditingController _address_controller;
  // National ID text controller
  late TextEditingController _national_id_controller;
  // Weight text controller
  late TextEditingController _weight_controller;
  // Height text controller
  late TextEditingController _height_controller;
  // Phone text controller
  late TextEditingController _phone_controller;
  // Date of birth text controller
  late TextEditingController _dob_controller;

  // Track if fields listeners are active
  bool _listeners_attached = false;
  // Track if form validation should display error messages onUserInteraction
  bool _form_submitted = false;

  // Initialize text controllers pre-filled with state values
  @override
  void initState() {
    // Invoke base initState
    super.initState();
    // Resolve cubit state
    final state = context.read<ProfileCubit>().state;
    // Instantiate controllers
    _first_name_controller =
        TextEditingController(text: state.profile.first_name);
    _last_name_controller =
        TextEditingController(text: state.profile.last_name);
    _email_controller = TextEditingController(text: state.profile.email);
    _address_controller = TextEditingController(text: state.profile.address);
    _national_id_controller =
        TextEditingController(text: state.profile.national_id);
    _weight_controller = TextEditingController(text: state.profile.weight);
    _height_controller = TextEditingController(text: state.profile.height);
    _phone_controller = TextEditingController(text: state.profile.phone);
    _dob_controller = TextEditingController(text: '05/12/1997');
  }

  // Attach text change listeners after controllers binding
  void _attach_listeners() {
    // Ensure listeners are bound once
    if (false == _listeners_attached) {
      // Attach listeners
      _first_name_controller.addListener(_on_fields_changed);
      _last_name_controller.addListener(_on_fields_changed);
      _email_controller.addListener(_on_fields_changed);
      _address_controller.addListener(_on_fields_changed);
      _national_id_controller.addListener(_on_fields_changed);
      _weight_controller.addListener(_on_fields_changed);
      _height_controller.addListener(_on_fields_changed);
      _dob_controller.addListener(_on_fields_changed);
      // Mark bound
      _listeners_attached = true;
    } else {
      // Empty block
    }
  }

  // Dispose controllers freeing up system resources
  @override
  void dispose() {
    // Remove listeners
    _first_name_controller.removeListener(_on_fields_changed);
    _last_name_controller.removeListener(_on_fields_changed);
    _email_controller.removeListener(_on_fields_changed);
    _address_controller.removeListener(_on_fields_changed);
    _national_id_controller.removeListener(_on_fields_changed);
    _weight_controller.removeListener(_on_fields_changed);
    _height_controller.removeListener(_on_fields_changed);
    _dob_controller.removeListener(_on_fields_changed);
    // Dispose text field controllers
    _first_name_controller.dispose();
    _last_name_controller.dispose();
    _email_controller.dispose();
    _address_controller.dispose();
    _national_id_controller.dispose();
    _weight_controller.dispose();
    _height_controller.dispose();
    _phone_controller.dispose();
    _dob_controller.dispose();
    // Call base dispose
    super.dispose();
  }

  // Real-time listener updating temp profile copy inside Cubit state
  void _on_fields_changed() {
    // Resolve cubit block
    final cubit = context.read<ProfileCubit>();
    // Clone draft profile with current form entries
    final updated = cubit.state.temp_profile.copyWith(
      first_name: _first_name_controller.text,
      last_name: _last_name_controller.text,
      email: _email_controller.text,
      address: _address_controller.text,
      national_id: _national_id_controller.text,
      weight: _weight_controller.text,
      height: _height_controller.text,
    );
    // Dispatch update representation to Cubit
    cubit.update_temp_profile(updated);
  }

  // Simulates photo upload by showing a bottom sheet chooser and updating avatar state
  void _upload_photo() {
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Show modal bottom sheet display
    showModalBottomSheet(
      // context parameter
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.barrier_color,
      // bottom sheet layout builder
      builder: (BuildContext context) {
        // Return Container providing sheet background and rounded corners
        return Container(
          decoration: BoxDecoration(
            color: true == is_dark ? AppColors.surface_dark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          // Safe area wrapper
          child: SafeArea(
          // Vertical layout column
          child: Column(
            // Minimizing height layout constraints
            mainAxisSize: MainAxisSize.min,
            // children widgets
            children: [
              // Top padding separator
              const SizedBox(height: AppSpacing.space_m),
              // Modal title text label
              Text(
                // String title text
                'Upload Profile Photo',
                // Text styling properties
                style: TextStyle(
                  // Title standard size
                  fontSize: 18.0,
                  // Bold styling
                  fontWeight: FontWeight.bold,
                  // Dynamic colors adapting to light/dark surfaces
                  color: true == is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              // Separator spacing gap
              const SizedBox(height: AppSpacing.space_m),
              // Choose Camera camera selection list item
              ListTile(
                // Camera icon graphic
                leading: const Icon(Icons.camera_alt_outlined,
                    color: AppColors.primary_color),
                // English take photo title description
                title: const Text('Take Photo'),
                // Action on tapped choice selection
                onTap: () {
                  // Dismiss modal overlay sheet
                  Navigator.of(context).pop();
                  // Trigger camera picker source sequence
                  _pick_profile_image(ImageSource.camera);
                },
              ),
              // Choose Gallery list item option
              ListTile(
                // Image gallery symbol icon
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primary_color),
                // English choose from gallery title description
                title: const Text('Choose from Gallery'),
                // Action on tapped choice selection
                onTap: () {
                  // Dismiss modal overlay sheet
                  Navigator.of(context).pop();
                  // Trigger gallery selection sequence
                  _pick_profile_image(ImageSource.gallery);
                },
              ),
              // Bottom offset padding layout spacing box
              const SizedBox(height: AppSpacing.space_m),
            ],
          ),
        ),
      );
    },
    );
  }

  // Triggers image picking from camera or gallery and updates avatar path
  Future<void> _pick_profile_image(ImageSource source) async {
    // Instantiate new ImagePicker controller helper representation
    final ImagePicker image_picker = ImagePicker();

    try {
      // Pick image file asynchronously using selected source
      final XFile? picked_file = await image_picker.pickImage(
        // Source input parameter camera or gallery
        source: source,
        // Image quality constraints to avoid memory exhaustion (FLT-03)
        imageQuality: 85,
        // Maximum width constraints
        maxWidth: 800,
        // Maximum height constraints
        maxHeight: 800,
      );

      // Verify if a file was successfully chosen using Yoda style check
      if (null != picked_file) {
        // Show circular loading indicator dialog
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary_color,
                ),
              );
            },
          );
        } else {
          // Empty block
        }

        // Simulate short local loading transition delay
        await Future.delayed(const Duration(milliseconds: 300));

        // Verify mount status of widget before dispatching updates
        if (mounted) {
          // Dismiss circular loader dialog
          Navigator.of(context).pop();
          // Resolve ProfileCubit block context controller
          final cubit = context.read<ProfileCubit>();
          // Dispatch avatar path update to Cubit state to trigger dirty tracking checks
          cubit.update_temp_profile(
            // Clone temp profile with selected local image file path override
            cubit.state.temp_profile.copyWith(
              avatar_url: picked_file.path,
            ),
          );
          // Show snackbar notifying success state
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture selected successfully!'),
              backgroundColor: AppColors.primary_color,
            ),
          );
        } else {
          // Empty block
        }
      } else {
        // User cancelled selection
      }
    } catch (error) {
      // Catch blocks must never be left empty; log error
      debugPrint("Error picking profile image: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to pick image: $error"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Empty block
      }
    }
  }

  // Pop navigation check displaying unsaved changes warning dialog
  Future<bool> _on_will_pop() async {
    // Resolve profile state dirty tracking flags
    final cubit = context.read<ProfileCubit>();
    // Check if changes exist using Yoda comparison style
    if (true == cubit.state.is_dirty) {
      // Show confirmation dialog overlay
      final bool leave = await _show_unsaved_dialog(context);
      // If user chooses to leave, revert changes
      if (true == leave) {
        // Discard unsaved edits from Cubit
        cubit.discard_changes();
        // Return true to allow pop transition
        return true;
      } else {
        // Block pop transition
        return false;
      }
    } else {
      // Allow pop transition safely
      return true;
    }
  }

  // Displays the dialog alerting users of unsaved modifications
  Future<bool> _show_unsaved_dialog(BuildContext context) async {
    // Resolve localized labels context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Show alert builder
    final result = await showDialog<bool>(
      // Context parameters
      context: context,
      // Block ambient dismiss on outside taps
      barrierDismissible: false,
      // Dialog builder
      builder: (dialog_context) {
        // Return AlertDialog block
        return AlertDialog(
          // Localized alert title
          title: Text(localizations.profile_unsaved_changes_title),
          // Localized body question
          content: Text(localizations.profile_unsaved_changes_message),
          // Actions buttons list
          actions: [
            // Stay button
            TextButton(
              // Dismiss dialog returning false status
              onPressed: () {
                // Return status
                Navigator.of(dialog_context).pop(false);
              },
              // Label text
              child: Text(localizations.profile_unsaved_changes_stay),
            ),
            // Leave button
            TextButton(
              // Dismiss dialog returning true status
              onPressed: () {
                // Return status
                Navigator.of(dialog_context).pop(true);
              },
              // Label text
              child: Text(localizations.profile_unsaved_changes_leave),
            ),
          ],
        );
      },
    );
    // Return final selection result or false
    return result ?? false;
  }

  // Form submit saving changes
  void _submit_form() {
    setState(() {
      _form_submitted = true;
    });
    // Validate form fields using validator triggers
    if (true == _form_key.currentState?.validate()) {
      // Trigger Cubit update profile call
      context.read<ProfileCubit>().update_profile();
    } else {
      // Form entries are invalid, focus first invalid field (handled dynamically)
    }
  }

  // Draw editing widgets layouts
  @override
  Widget build(BuildContext context) {
    // Resolve localized strings dictionary
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Determine if dark mode is active
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Attach listeners to controllers safely
    _attach_listeners();
    // Return a SafeArea wrapping PopScope to handle top margin and safe area
    return SafeArea(
      child: PopScope(
        // Disallow popping if there are unsaved changes
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) async {
          if (didPop) return;
          final bool allow = await _on_will_pop();
          // Pop the screen if allowed and widget is still mounted
          if (true == allow && context.mounted) {
            Navigator.of(context).pop();
          } else {
            // Navigation blocked
          }
        },
        // Main content wrapped in BlocConsumer to react to profile state changes
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // Show a success snackbar when profile update succeeds
            if (ProfileStatus.updateSuccess == state.status) {
              context.read<ProfileCubit>().reset_status();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.profile_change_success_msg),
                  backgroundColor: AppColors.primary_color,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            // Scaffold provides the page layout structure
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
                child: Form(
                  key: _form_key,
                  autovalidateMode: _form_submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.space_xl),
                      CustomProfileAppBar(
                        title: localizations.edit_profile_title,
                      ),
                      const SizedBox(height: AppSpacing.space_xl),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Center container for avatar photo editor
                              Center(
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: _upload_photo,
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.primary_color,
                                            width: 2.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: is_dark
                                                  ? Colors.black54
                                                  : Colors.black12,
                                              blurRadius: 8.0,
                                              offset: const Offset(0.0, 2.0),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: state.temp_profile.avatar_url.isNotEmpty
                                              ? (state.temp_profile.avatar_url.startsWith('http')
                                                  ? Image.network(
                                                      state.temp_profile.avatar_url,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(state.temp_profile.avatar_url),
                                                      fit: BoxFit.cover,
                                                    ))
                                              : Container(
                                                  color: AppColors.primary_color.withValues(alpha: 0.1),
                                                  child: const Icon(
                                                    Icons.person_rounded,
                                                    color: AppColors.primary_color,
                                                    size: 50.0,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: _upload_photo,
                                        child: Container(
                                          padding: const EdgeInsets.all(6.0),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary_color,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.space_xl),
                              // Single grouped card container holding all form fields
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: is_dark ? AppColors.surface_dark : Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
                                    width: 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: is_dark
                                          ? Colors.black.withValues(alpha: 0.2)
                                          : Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0,
                                      offset: const Offset(0.0, 4.0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1: First name and Last name side-by-side Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AuthTextField(
                                            label: localizations.profile_first_name_label,
                                            hint: '',
                                            controller: _first_name_controller,
                                            keyboard_type: TextInputType.name,
                                            show_shadow: false,
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: AuthTextField(
                                            label: localizations.profile_last_name_label,
                                            hint: '',
                                            controller: _last_name_controller,
                                            keyboard_type: TextInputType.name,
                                            show_shadow: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Email input card (full width)
                                    AuthTextField(
                                      label: localizations.profile_email_label,
                                      hint: '',
                                      controller: _email_controller,
                                      keyboard_type: TextInputType.emailAddress,
                                      show_shadow: false,
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Phone input card (full width)
                                    AuthTextField(
                                      label: localizations.profile_phone_label,
                                      hint: '',
                                      controller: _phone_controller,
                                      keyboard_type: TextInputType.phone,
                                      is_phone: true,
                                      show_shadow: false,
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Address input card (full width)
                                    AuthTextField(
                                      label: localizations.profile_address_label,
                                      hint: '',
                                      controller: _address_controller,
                                      keyboard_type: TextInputType.streetAddress,
                                      show_shadow: false,
                                    ),
                                    const SizedBox(height: 16.0),
                                    // National ID input card (full width)
                                    AuthTextField(
                                      label: localizations.profile_national_id_label,
                                      hint: '',
                                      controller: _national_id_controller,
                                      keyboard_type: TextInputType.number,
                                      is_national_id: true,
                                      show_shadow: false,
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Date of Birth input card (full width, tapping triggers custom calendar picker dialog)
                                    GestureDetector(
                                      onTap: () async {
                                        final DateTime? picked_date = await showAppDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (picked_date != null) {
                                          final String formatted = '${picked_date.day}/${picked_date.month}/${picked_date.year}';
                                          setState(() {
                                            _dob_controller.text = formatted;
                                          });
                                        }
                                      },
                                      child: IgnorePointer(
                                        child: AuthTextField(
                                          label: localizations.profile_birthdate_label,
                                          hint: '',
                                          controller: _dob_controller,
                                          enabled: false,
                                          show_shadow: false,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Gender label
                                    Text(
                                      localizations.profile_gender_label,
                                      style: TextStyle(
                                        fontSize: AppSpacing.font_size_body_medium,
                                        fontWeight: FontWeight.w700,
                                        color: true == is_dark ? AppColors.text_dark_primary : AppColors.primary_color,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    // Segmented chips for gender choices
                                    _build_segmented_chips<String>(
                                      values: ['Male', 'Female', 'Prefer not to say'],
                                      labels: [
                                        localizations.profile_gender_male,
                                        localizations.profile_gender_female,
                                        localizations.profile_gender_prefer_not,
                                      ],
                                      selectedValue: state.temp_profile.gender,
                                      onChanged: (value) {
                                        context.read<ProfileCubit>().update_temp_profile(
                                          state.temp_profile.copyWith(gender: value),
                                        );
                                      },
                                      is_dark: is_dark,
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Weight and Height side-by-side Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AuthTextField(
                                            label: localizations.profile_weight_label,
                                            hint: '',
                                            controller: _weight_controller,
                                            keyboard_type: TextInputType.number,
                                            show_shadow: false,
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: AuthTextField(
                                            label: localizations.profile_height_label,
                                            hint: '',
                                            controller: _height_controller,
                                            keyboard_type: TextInputType.number,
                                            show_shadow: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16.0),
                                    // Smoking section header
                                    Text(
                                      localizations.profile_smoking_section,
                                      style: TextStyle(
                                        fontSize: AppSpacing.font_size_body_medium,
                                        fontWeight: FontWeight.w700,
                                        color: true == is_dark ? AppColors.text_dark_primary : AppColors.primary_color,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    // Segmented chips for smoking options
                                    _build_segmented_chips<String>(
                                      values: ['Yes', 'No', 'Ex-Smoker'],
                                      labels: [
                                        localizations.profile_smoking_yes,
                                        localizations.profile_smoking_no,
                                        localizations.profile_smoking_ex,
                                      ],
                                      selectedValue: state.temp_profile.smoking,
                                      onChanged: (value) {
                                        context.read<ProfileCubit>().update_temp_profile(
                                          state.temp_profile.copyWith(smoking: value),
                                        );
                                      },
                                      is_dark: is_dark,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 80.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: StickyBottomBar(
                child: AuthButton(
                  label: localizations.profile_save_button,
                  is_enabled: true == state.is_dirty &&
                      state.status != ProfileStatus.updating,
                  on_pressed: _submit_form,
                  is_loading: state.status == ProfileStatus.updating,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Private helper to render modern responsive segmented toggle chips with 48px height
  Widget _build_segmented_chips<T>({
    required List<T> values,
    required List<String> labels,
    required T selectedValue,
    required ValueChanged<T> onChanged,
    required bool is_dark,
  }) {
    return Container(
      height: 48.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: is_dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: List.generate(values.length, (index) {
          final T value = values[index];
          final String label = labels[index];
          final bool is_selected = value == selectedValue;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(value),
              child: Container(
                alignment: Alignment.center,
                // Reduced horizontal padding to accommodate longer labels on narrow screens
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: is_selected
                      ? AppColors.primary_color
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // FittedBox dynamically scales text down to prevent truncation
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: is_selected
                          ? Colors.white
                          : (is_dark
                              ? Colors.white70
                              : AppColors.text_light_primary),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

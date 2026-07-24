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
// Importing services for text input formatters
import 'package:flutter/services.dart';
// Importing routing and localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing reusable text field widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';

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
    // Dispose text field controllers
    _first_name_controller.dispose();
    _last_name_controller.dispose();
    _email_controller.dispose();
    _address_controller.dispose();
    _national_id_controller.dispose();
    _weight_controller.dispose();
    _height_controller.dispose();
    _phone_controller.dispose();
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
      // background color depending on theme brightness
      backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.white,
      // Rounded borders at top coordinates
      shape: const RoundedRectangleBorder(
        // top radius specs
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      // bottom sheet layout builder
      builder: (BuildContext context) {
        // Safe area wrapper
        return SafeArea(
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
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Attach listeners to controllers safely
    _attach_listeners();

    // Return PopScope intercepting back navigation actions
    return PopScope(
      // Configure block popping if dirty
      canPop: false,
      // Intercept navigation pop trigger
      onPopInvokedWithResult: (didPop, result) async {
        // Verify pop wasn't handled already using Yoda checks
        if (true == didPop) {
          // Return early
          return;
        } else {
          // Trigger pop check handler
          final bool allow = await _on_will_pop();
          // If allowed, pop screen safely
          if (true == allow && context.mounted) {
            // Dismiss editor screen layout
            Navigator.of(context).pop();
          } else {
            // Block navigation return
          }
        }
      },
      // Root Scaffold sheet container
      child: BlocConsumer<ProfileCubit, ProfileState>(
        // Listen to success updates triggering routing
        listener: (context, state) {
          // Check if successfully updated profile details using Yoda check
          if (ProfileStatus.updateSuccess == state.status) {
            // Reset cubit status back to success standard
            context.read<ProfileCubit>().reset_status();
            // Show feedback notification message info
            ScaffoldMessenger.of(context).showSnackBar(
              // SnackBar settings
              SnackBar(
                // Localized success message
                content: Text(localizations.profile_change_success_msg),
                // Themed color fill
                backgroundColor: AppColors.primary_color,
              ),
            );
            // Return back to main Profile screen
            Navigator.of(context).pop();
          } else {
            // Empty block
          }
        },
        // Build screen layouts
        builder: (context, state) {
          // Scaffold display layout setup
          return Scaffold(
            // Background surface colors
            backgroundColor: true == is_dark
                ? AppColors.background_dark
                : AppColors.background_light,
            // Form layout body containing fields scroll areas
            body: Form(
              // Bind global key
              key: _form_key,
              // Auto validate mode configuration
              autovalidateMode: true == _form_submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              // Scrollable area wrapping input cards fields
              child: SingleChildScrollView(
                // Margin offsets constraints
                padding: const EdgeInsets.symmetric(
                  // Horizontal padding
                  horizontal: AppSpacing.space_xxl,
                  // Vertical padding
                  vertical: AppSpacing.space_l,
                ),
                // Column stack nesting fields layouts
                child: Column(
                  // Align fields left start boundary lines
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // inputs list array
                  children: [
                    // Top vertical space margin
                    const SizedBox(height: AppSpacing.space_xl),
                    // Top row containing custom back button
                    CustomProfileAppBar(
                      title: localizations.profile_update_profile_button,
                      onBackPressed: () async {
                        final bool allow = await _on_will_pop();
                        if (true == allow && context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.space_xl),
                    // Profile edit mode avatar picker widget mockup
                    Center(
                      child: GestureDetector(
                        onTap: _upload_photo,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // circular outline placeholder avatar
                            Container(
                              width: AppSpacing.profile_edit_avatar_radius * 2,
                              height: AppSpacing.profile_edit_avatar_radius * 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: true == is_dark
                                      ? AppColors.border_dark
                                      : AppColors.border_light,
                                  width: AppSpacing.border_width_thin,
                                ),
                                image: state.temp_profile.avatar_url.isNotEmpty
                                    ? DecorationImage(
                                        image: true == state.temp_profile.avatar_url.startsWith('http')
                                            ? NetworkImage(state.temp_profile.avatar_url) as ImageProvider
                                            : FileImage(File(state.temp_profile.avatar_url)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: state.temp_profile.avatar_url.isEmpty
                                  ? const Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: AppColors.text_light_secondary,
                                        size: AppSpacing.icon_size_xxl,
                                      ),
                                    )
                                  : null,
                            ),
                            // Positioned edit pencil overlay button badge
                            Positioned(
                              bottom: AppSpacing.space_xs,
                              right: AppSpacing.space_xs,
                              child: Container(
                                width: AppSpacing.icon_size_xl,
                                height: AppSpacing.icon_size_xl,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary_color,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: AppSpacing.icon_size_s,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Vertical separator spacing
                    const SizedBox(
                      // Spacing value
                      height: AppSpacing.space_l,
                    ),
                    // Contact Section Header display label
                    Text(
                      // Section header title string
                      localizations.profile_contact_section,
                      // Style layout options
                      style: TextStyle(
                        // Standard body size font
                        fontSize: AppSpacing.font_size_body_medium,
                        // bold weight
                        fontWeight: FontWeight.w700,
                        // Color styling
                        color: true == is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.primary_color,
                      ),
                    ),
                    // Separator offset gaps
                    const SizedBox(
                      // Spacing offset
                      height: AppSpacing.space_s,
                    ),
                    // Row containing First Name and Last Name text fields next to each other
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Name
                        Expanded(
                          child: AuthTextField(
                            label: localizations.first_name_label,
                            hint: localizations.first_name_hint,
                            controller: _first_name_controller,
                            validator: (value) {
                              final String trimmed = (value ?? '').trim();
                              if (trimmed.isEmpty) {
                                return localizations.profile_error_name_empty;
                              } else if (trimmed.length < 3 ||
                                  trimmed.length > 50) {
                                return localizations.profile_error_name_length;
                              } else if (false ==
                                  RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
                                return localizations
                                    .profile_error_name_letters_only;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        // spacing gap
                        const SizedBox(
                          width: AppSpacing.space_m,
                        ),
                        // Last Name
                        Expanded(
                          child: AuthTextField(
                            label: localizations.last_name_label,
                            hint: localizations.last_name_hint,
                            controller: _last_name_controller,
                            validator: (value) {
                              final String trimmed = (value ?? '').trim();
                              if (trimmed.isEmpty) {
                                return 'Last Name cannot be empty.';
                              } else if (trimmed.length < 3 ||
                                  trimmed.length > 50) {
                                return 'Last Name must be between 3 and 50 characters.';
                              } else if (false ==
                                  RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
                                return 'Last Name must contain letters only.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    // Separator offset gap box
                    const SizedBox(
                      height: AppSpacing.space_s,
                    ),
                    // Disabled Phone Number TextFormField card VR-03 / FLT-05 / FLT-06 specs
                    AuthTextField(
                      enabled: false,
                      label: localizations.profile_phone_label,
                      hint: localizations.allergies_placeholder,
                      controller: _phone_controller,
                      is_phone: true,
                    ),
                    // Separator offset gap box
                    const SizedBox(
                      height: AppSpacing.space_m,
                    ),
                    // National ID TextFormField card (14 numeric digits)
                    AuthTextField(
                      is_national_id: true,
                      label: localizations.profile_national_id_label,
                      hint: localizations.profile_national_id_hint,
                      controller: _national_id_controller,
                      keyboard_type: TextInputType.number,
                      input_formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(14),
                      ],
                      validator: (value) {
                        final String trimmed = (value ?? '').trim();
                        if (trimmed.isEmpty) {
                          return localizations.profile_error_national_id_empty;
                        } else if (false ==
                            RegExp(r'^\d{14}$').hasMatch(trimmed)) {
                          return localizations
                              .profile_error_national_id_invalid;
                        } else {
                          return null;
                        }
                      },
                    ),
                    // Separator offset gap box
                    const SizedBox(
                      height: AppSpacing.space_s,
                    ),
                    // Email Text field input container card VR-04 / FLT-14 specs
                    AuthTextField(
                      label: localizations.profile_email_label,
                      hint: localizations.allergies_placeholder,
                      controller: _email_controller,
                      keyboard_type: TextInputType.emailAddress,
                      validator: (value) {
                        final String trimmed =
                            (value ?? '').trim().toLowerCase();
                        if (trimmed.isEmpty) {
                          return localizations.profile_error_email_empty;
                        } else if (trimmed.length > 254) {
                          return localizations.profile_error_email_length;
                        } else if (false ==
                            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(trimmed)) {
                          return localizations.profile_error_email_invalid;
                        } else {
                          return null;
                        }
                      },
                    ),
                    // Separator offset gap box
                    const SizedBox(
                      height: AppSpacing.space_s,
                    ),
                    // Address Text field input container card VR-06 / FLT-16 specs
                    AuthTextField(
                      label: 'Address',
                      hint: localizations.allergies_placeholder,
                      controller: _address_controller,
                      validator: (value) {
                        final String trimmed = (value ?? '').trim();
                        if (trimmed.length > 250) {
                          return localizations.profile_error_address_length;
                        } else if (true ==
                            RegExp(r'[\u{1F300}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]',
                                    unicode: true)
                                .hasMatch(trimmed)) {
                          return localizations.profile_error_address_invalid;
                        } else {
                          return null;
                        }
                      },
                    ),
                    // Separator offset gap box
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_s,
                    ),
                    // Gender selection section labels
                    Text(
                      // Localized gender label
                      localizations.profile_gender_label,
                      // Style typographic parameters options
                      style: TextStyle(
                        // Body standard size
                        fontSize: AppSpacing.font_size_body_medium,
                        // bold weight
                        fontWeight: FontWeight.w600,
                        // Secondary colors
                        color: true == is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
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
                    // Section divider space
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_m,
                    ),
                    // More Information Section Header display label
                    Text(
                      // Section header title string
                      localizations.profile_more_info_section,
                      // Style layout options
                      style: TextStyle(
                        // Standard body size font
                        fontSize: AppSpacing.font_size_body_medium,
                        // bold weight
                        fontWeight: FontWeight.w700,
                        // Color styling
                        color: true == is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.primary_color,
                      ),
                    ),
                    // Separator offset gap box
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_s,
                    ),
                    // Row containing Weight and Height text fields next to each other
                    Row(
                      // Option layout spaces
                      children: [
                        // Weight card
                        Expanded(
                          // Weight text field input
                          child: AuthTextField(
                            label: localizations.profile_weight_label,
                            hint: localizations.allergies_placeholder,
                            controller: _weight_controller,
                            keyboard_type: TextInputType.number,
                          ),
                        ),
                        // gap
                        const SizedBox(
                          // Separator width value
                          width: AppSpacing.space_s,
                        ),
                        // Height card
                        Expanded(
                          // Height text field input
                          child: AuthTextField(
                            label: localizations.profile_height_label,
                            hint: localizations.allergies_placeholder,
                            controller: _height_controller,
                            keyboard_type: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    // Section divider space
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_m,
                    ),
                    // Smoking Section Header display label
                    Text(
                      // Section header title string
                      localizations.profile_smoking_section,
                      // Style layout options
                      style: TextStyle(
                        // Standard body size font
                        fontSize: AppSpacing.font_size_body_medium,
                        // bold weight
                        fontWeight: FontWeight.w700,
                        // Color styling
                        color: true == is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.primary_color,
                      ),
                    ),
                    const SizedBox(height: 8.0),
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
                    // Spacing gap before button
                    const SizedBox(height: AppSpacing.space_l),
                    // CTA Action button component executing profile save
                    AuthButton(
                      label: localizations.profile_save_button,
                      is_enabled: true == state.is_dirty &&
                          state.status != ProfileStatus.updating,
                      on_pressed: _submit_form,
                      is_loading: state.status == ProfileStatus.updating,
                    ),
                    // Spacing bottom padding margin box
                    const SizedBox(
                      // Spacing offset
                      height: AppSpacing.space_xxl,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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

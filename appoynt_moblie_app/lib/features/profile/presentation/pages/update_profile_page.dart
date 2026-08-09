/*
 * File Name: update_profile_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 09/08/2026]
 * File Description: Defines the Update Profile layout form fields, validators, and backend save handlers.
 */

// Importing standard I/O for File operations
import 'dart:io';
// Importing flutter services for InputFormatters
import 'package:flutter/services.dart';
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
// Importing DTO request model representation
import 'package:appoynt_mobile_app/features/profile/data/models/update_profile_request_model.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  // Minimum weight value
  static const double min_weight = 2.0;
  // Maximum weight value
  static const double max_weight = 300.0;
  // Minimum height value
  static const double min_height = 30.0;
  // Maximum height value
  static const double max_height = 250.0;
  // Border radius for bottom sheet
  static const double border_radius_sheet = 24.0;
  // Title font size representation
  static const double title_font_size = 18.0;
  // Avatar box layout size bounds
  static const double avatar_box_size = 100.0;
  // Avatar border width
  static const double avatar_border_width = 2.0;
  // Avatar shadow blur size
  static const double avatar_shadow_blur = 8.0;
  // Avatar shadow offset y representation
  static const double avatar_shadow_offset_y = 2.0;
  // Avatar circular radius
  static const double avatar_radius = 50.0;
  // Default camera placeholder icon size
  static const double default_avatar_icon_size = 50.0;
  // Camera badge container padding
  static const double camera_badge_padding = 6.0;
  // Camera badge icon size
  static const double camera_badge_icon_size = 16.0;
  // Form card padding size
  static const double card_padding = 16.0;
  // Form card border radius
  static const double card_radius = 16.0;
  // Form card outline border width
  static const double card_border_width = 1.0;
  // Form card shadow blur size
  static const double card_shadow_blur = 10.0;
  // Form card shadow offset y
  static const double card_shadow_offset_y = 4.0;
  // Small field vertical spacing gap
  static const double field_spacing_small = 12.0;
  // Large field vertical spacing gap
  static const double field_spacing_large = 16.0;
  // Tiny field vertical spacing gap
  static const double field_spacing_tiny = 8.0;
  // Scroll view bottom clearance padding
  static const double scroll_bottom_padding = 80.0;
  // Segmented chips container height
  static const double segmented_height = 48.0;
  // Segmented chips border radius
  static const double segmented_radius = 12.0;
  // Segmented chips outline border width
  static const double segmented_border_width = 1.0;
  // Segmented chips internal padding
  static const double segmented_padding = 4.0;
  // Segmented chip item horizontal padding
  static const double chip_padding_h = 8.0;
  // Segmented chip item border radius
  static const double chip_radius = 8.0;
  // Segmented chip item font size
  static const double chip_font_size = 13.0;
}

// Patient Profile Editor form screen stateful widget representation
class UpdateProfilePage extends StatefulWidget {
  // Constructor mapping key
  const UpdateProfilePage({super.key});

  // State builder definition
  @override
  State<UpdateProfilePage> createState() {
    // Return edit profile state tracker
    return _UpdateProfilePageState();
  }
}

// State tracker class implementation for UpdateProfilePage
class _UpdateProfilePageState extends State<UpdateProfilePage> {
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
  // Track if form values were already populated from fetched API state
  bool _is_populated = false;

  // Initial email to check for case-insensitive changes during email uniqueness check
  late String _initial_email;

  // Helper method to strip country code and keep local phone format
  String _strip_country_code(String phone) {
    // Strip all non-numeric characters except plus
    String local = phone.replaceAll(RegExp(r'[^\d+]'), '');
    // Check Egyptian prefix +20
    if (local.startsWith('+20')) {
      // Egyptian prefix local format
      return '0${local.substring(3)}';
    } else if (local.startsWith('20') && local.length > 10) {
      // Egyptian prefix alternative local format
      return '0${local.substring(2)}';
    } else if (local.startsWith('+2')) {
      // General +2 prefix local format
      return '0${local.substring(2)}';
    } else {
      // Empty action block to satisfy compiler
    }
    // Return Egypt local phone representation
    return local;
  }

  // Validator helper logic for First Name form input field
  String? _validate_first_name(String? value) {
    // Trim input values
    final String value_trimmed = (value ?? '').trim();
    // Validate empty field
    if (value_trimmed.isEmpty) {
      // First name is empty
      return "First Name cannot be empty.";
    } else {
      // Format check (highest priority after empty check)
      final RegExp letters_only = RegExp(r'^\p{L}+$', unicode: true);
      // Validate letters constraint
      if (false == letters_only.hasMatch(value_trimmed)) {
        // String contains numbers or symbols
        return "First Name must contain letters only.";
      } else {
        // Length check constraints
        if (value_trimmed.length < 3 || value_trimmed.length > 50) {
          // Range validation failed
          return "First Name must be between 3 and 50 characters.";
        } else {
          // Name valid
          return null;
        }
      }
    }
  }

  // Validator helper logic for Last Name form input field
  String? _validate_last_name(String? value) {
    // Trim input values
    final String value_trimmed = (value ?? '').trim();
    // Validate empty field
    if (value_trimmed.isEmpty) {
      // Last name is empty
      return "Last Name cannot be empty.";
    } else {
      // Format check (highest priority after empty check)
      final RegExp letters_only = RegExp(r'^\p{L}+$', unicode: true);
      // Validate letters constraint
      if (false == letters_only.hasMatch(value_trimmed)) {
        // String contains numbers or symbols
        return "Last Name must contain letters only.";
      } else {
        // Length check constraints
        if (value_trimmed.length < 3 || value_trimmed.length > 50) {
          // Range validation failed
          return "Last Name must be between 3 and 50 characters.";
        } else {
          // Name valid
          return null;
        }
      }
    }
  }

  // Validator helper logic for Email form input field
  String? _validate_email(String? value) {
    // Trim input value
    final String val = (value ?? '').trim();
    // Validate empty field
    if (val.isEmpty) {
      // Email is empty
      return "Email cannot be empty.";
    } else {
      // Length check constraints
      if (val.length > 254) {
        // Range validation failed
        return "Email must not exceed 254 characters.";
      } else {
        // Space checking constraints
        if (val.contains(' ')) {
          // Contains spacing characters
          return "Please enter a valid email.";
        } else {
          // Exactly one @ check
          final int at_index = val.indexOf('@');
          // Validate unique @ symbol
          if (at_index == -1 || at_index != val.lastIndexOf('@')) {
            // Missing or multiple @ symbols
            return "Please enter a valid email.";
          } else {
            // Local part length check
            final String local_part = val.substring(0, at_index);
            // Validate local part range limit
            if (local_part.length > 64) {
              // Range limit failed
              return "Please enter a valid email.";
            } else {
              // Standard email regex
              final RegExp email_regex = RegExp(
                r'^[a-zA-Z0-9]+([._-][a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,4}$',
              );
              // Validate format regex
              if (false == email_regex.hasMatch(val)) {
                // Formatting incorrect
                return "Please enter a valid email.";
              } else {
                // Email uniqueness case-insensitive check
                final String email_lower = val.toLowerCase();
                // Compare with initial email
                if (email_lower != _initial_email) {
                  // Mapped list of mock registered emails
                  final Set<String> registered_emails = {
                    'taken@gmail.com',
                    'user@gmail.com',
                    'alreadyregistered@gmail.com',
                    'test@gmail.com',
                  };
                  // Check duplicate emails
                  if (true == registered_emails.contains(email_lower)) {
                    // Duplicate email
                    return "This email is already registered.";
                  } else {
                    // Unique email
                    return null;
                  }
                } else {
                  // No change to initial email
                  return null;
                }
              }
            }
          }
        }
      }
    }
  }

  // Validator helper logic for Address form input field (VR-06)
  String? _validate_address(String? value) {
    // Trim input value
    final String value_trimmed = (value ?? '').trim();
    // Validate empty address
    if (value_trimmed.isEmpty) {
      // Address is optional
      return null;
    } else {
      // Length check constraint
      if (value_trimmed.length > 250) {
        // Range validation failed
        return "Address must not exceed 250 characters.";
      } else {
        // Emojis and control characters regex filters
        final RegExp emoji_regex =
            RegExp(r'[\u{1F300}-\u{1F9FF}\u{2600}-\u{27BF}]', unicode: true);
        final RegExp control_regex = RegExp(r'[\u0000-\u001F\u007F-\u009F]');
        // Verify regex constraints
        if (true == emoji_regex.hasMatch(value_trimmed) ||
            true == control_regex.hasMatch(value_trimmed)) {
          // Unsupported symbols detected
          return "Address cannot contain emojis or unsupported characters.";
        } else {
          // Address is valid
          return null;
        }
      }
    }
  }

  // Validator helper logic for Weight form input field
  String? _validate_weight(String? value) {
    // Trim input value
    final String val = (value ?? '').trim();
    // Validate empty field
    if (val.isEmpty) {
      // Weight is empty
      return "Weight is required.";
    } else {
      // Parse numeric double
      final double? weight = double.tryParse(val);
      // Validate numeric value
      if (weight == null || weight <= 0.0) {
        // Parse error or negative value
        return "Please enter a valid weight.";
      } else {
        // Validate weight range limits
        if (weight < _LocalDimensions.min_weight || weight > _LocalDimensions.max_weight) {
          // Bounds verification failed
          return "Weight must be between 2 and 300 kg.";
        } else {
          // Weight valid
          return null;
        }
      }
    }
  }

  // Validator helper logic for Height form input field
  String? _validate_height(String? value) {
    // Trim input value
    final String val = (value ?? '').trim();
    // Validate empty field
    if (val.isEmpty) {
      // Height is empty
      return "Height is required.";
    } else {
      // Parse numeric double
      final double? height = double.tryParse(val);
      // Validate numeric value
      if (height == null || height <= 0.0) {
        // Parse error or negative value
        return "Please enter a valid height.";
      } else {
        // Validate height range limits
        if (height < _LocalDimensions.min_height || height > _LocalDimensions.max_height) {
          // Bounds verification failed
          return "Height must be between 30 and 250 cm.";
        } else {
          // Height valid
          return null;
        }
      }
    }
  }

  // Helper method returning the maximum days in a given month and year
  int _get_days_in_month(int month, int year) {
    // Check leap year for February
    if (month == 2) {
      // Resolve leap year flag
      final bool is_leap =
          (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      // Return leap year days
      return is_leap ? 29 : 28;
    } else {
      // Set mapping 30 days months
      final Set<int> thirty_days = {4, 6, 9, 11};
      // Return month days
      return true == thirty_days.contains(month) ? 30 : 31;
    }
  }

  // Validator helper logic for Egyptian National ID form input field
  String? _validate_national_id(String? value) {
    // Trim input value
    final String val = (value ?? '').trim();
    // Validate empty ID
    if (val.isEmpty) {
      // National ID is empty
      return "National ID cannot be empty.";
    } else {
      // Validate length constraint
      if (val.length != 14) {
        // Length incorrect
        return "National ID must be exactly 14 digits.";
      } else {
        // Check for all identical digits
        if (val.runes.toSet().length == 1) {
          // Identical digits validation failed
          return "Please enter a valid National ID.";
        } else {
          // Parse first digit (century indicator)
          final String century_char = val[0];
          // Validate century bounds
          if (century_char != '2' && century_char != '3') {
            // Century incorrect
            return "Please enter a valid National ID.";
          } else {
            // Parse birth year, month, and day offsets
            final int year_offset = century_char == '2' ? 1900 : 2000;
            final int? year = int.tryParse(val.substring(1, 3));
            final int? month = int.tryParse(val.substring(3, 5));
            final int? day = int.tryParse(val.substring(5, 7));

            // Validate parsed values
            if (year == null || month == null || day == null) {
              // Parse failed
              return "Please enter a valid National ID.";
            } else {
              // Calculate birth year
              final int full_year = year_offset + year;
              // Validate month bounds
              if (month < 1 || month > 12) {
                // Month incorrect
                return "Please enter a valid National ID.";
              } else {
                // Verify days bound ranges
                final int max_days = _get_days_in_month(month, full_year);
                // Validate day bounds
                if (day < 1 || day > max_days) {
                  // Day incorrect
                  return "Please enter a valid National ID.";
                } else {
                  // Verify governorate code mappings
                  final String gov_code = val.substring(7, 9);
                  // Egyptian governorate code constants
                  final Set<String> valid_govs = {
                    '01', '02', '03', '04', '11', '12', '13', '14', '15',
                    '16', '17', '18', '19', '21', '22', '23', '24', '25',
                    '26', '27', '28', '29', '31', '32', '33', '34', '35', '88'
                  };
                  // Validate governorate code existence
                  if (false == valid_govs.contains(gov_code)) {
                    // Governorate code incorrect
                    return "Please enter a valid National ID.";
                  } else {
                    // ID is valid
                    return null;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  // Listener to extract Date of Birth automatically upon 14-digit National ID entry
  void _on_national_id_changed() {
    // Retrieve input value
    final String val = _national_id_controller.text.trim();
    // Validate completed input length
    if (val.length == 14) {
      // Resolve century
      final int? century = val[0] == '2' ? 1900 : (val[0] == '3' ? 2000 : null);
      // Validate century
      if (century != null) {
        // Resolve date fields
        final int? year_val = int.tryParse(val.substring(1, 3));
        final int? month_val = int.tryParse(val.substring(3, 5));
        final int? day_val = int.tryParse(val.substring(5, 7));

        // Validate resolved fields
        if (year_val != null && month_val != null && day_val != null) {
          // Attempt date formatting
          try {
            // Calculate year
            final int year = century + year_val;
            // Instantiating DateTime to trigger validation exceptions
            DateTime(year, month_val, day_val);
            // Format as DD/MM/YYYY
            _dob_controller.text =
                "${day_val.toString().padLeft(2, '0')}/${month_val.toString().padLeft(2, '0')}/$year";
            // Refresh state layout
            setState(() {});
          } catch (_) {
            // Invalid date components (ignored)
          }
        } else {
          // Parsing failure
        }
      } else {
        // Invalid century prefix
      }
    } else {
      // Incomplete ID input
    }
  }

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
    _phone_controller =
        TextEditingController(text: _strip_country_code(state.profile.phone));
    _dob_controller = TextEditingController(text: '05/12/1997');
    _initial_email = state.profile.email.trim().toLowerCase();
    // Add real-time listener for extracting Date of Birth
    _national_id_controller.addListener(_on_national_id_changed);
    // Trigger remote fetch API sequence in post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call fetchUserProfile on Cubit
      context.read<ProfileCubit>().fetchUserProfile();
    });
  }

  // Attach text change listeners after controllers binding
  void _attach_listeners() {
    // Ensure listeners are bound once
    if (false == _listeners_attached) {
      // Attach listeners to all inputs
      _first_name_controller.addListener(_on_fields_changed);
      _last_name_controller.addListener(_on_fields_changed);
      _email_controller.addListener(_on_fields_changed);
      _address_controller.addListener(_on_fields_changed);
      _national_id_controller.addListener(_on_fields_changed);
      _weight_controller.addListener(_on_fields_changed);
      _height_controller.addListener(_on_fields_changed);
      _dob_controller.addListener(_on_fields_changed);
      // Set active status
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
    _national_id_controller.removeListener(_on_national_id_changed);
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
    // Resolve localized strings
    final localizations = AppLocalizations.of(context);
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Show modal bottom sheet display
    showModalBottomSheet(
      // context parameter
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      // bottom sheet layout builder
      builder: (BuildContext context) {
        // Return Container providing sheet background and rounded corners
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(_LocalDimensions.border_radius_sheet)),
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
                  localizations.profile_upload_photo_title,
                  style: TextStyle(
                    fontSize: _LocalDimensions.title_font_size,
                    fontWeight: FontWeight.bold,
                    color: is_dark
                        ? AppColors.text_dark_primary
                        : AppColors.text_light_primary,
                  ),
                ),
                // Separator spacing gap
                const SizedBox(height: AppSpacing.space_m),
                // Choose Camera camera selection list item
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.primary_color),
                  title: Text(localizations.profile_take_photo_option),
                  onTap: () {
                    // Dismiss modal overlay sheet
                    Navigator.of(context).pop();
                    // Trigger camera picker source sequence
                    _pick_profile_image(ImageSource.camera);
                  },
                ),
                // Choose Gallery list item option
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: AppColors.primary_color),
                  title: Text(localizations.profile_choose_gallery_option),
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
    // Resolve localized strings
    final localizations = AppLocalizations.of(context);
    // Instantiate new ImagePicker controller helper representation
    final ImagePicker image_picker = ImagePicker();

    try {
      // Pick image file asynchronously using selected source
      final XFile? picked_file = await image_picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
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
            cubit.state.temp_profile.copyWith(
              avatar_url: picked_file.path,
            ),
          );
          // Show snackbar notifying success state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.profile_photo_selected_success),
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
      // Log error
      debugPrint("Error picking profile image: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${localizations.profile_photo_pick_failed_prefix}$error'),
            backgroundColor: AppColors.red,
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
      context: context,
      barrierDismissible: false,
      builder: (dialog_context) {
        return AlertDialog(
          title: Text(localizations.profile_unsaved_changes_title),
          content: Text(localizations.profile_unsaved_changes_message),
          actions: [
            // Stay button
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop(false);
              },
              child: Text(localizations.profile_unsaved_changes_stay),
            ),
            // Leave button
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop(true);
              },
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
      // Convert gender string label into standard API integer (0 for Male, 1 for Female)
      final String gender_str = context.read<ProfileCubit>().state.temp_profile.gender;
      final int? gender_val = 'Male' == gender_str ? 0 : ('Female' == gender_str ? 1 : null);
      // Format birthdate from DD/MM/YYYY to YYYY-MM-DD for backend API payload compatibility
      String? dob_api;
      if (_dob_controller.text.isNotEmpty) {
        final List<String> date_parts = _dob_controller.text.split('/');
        if (date_parts.length == 3) {
          dob_api = "${date_parts[2]}-${date_parts[1]}-${date_parts[0]}";
        }
      }
      // Create UpdateProfileRequestModel mapping the form parameters
      final request_model = UpdateProfileRequestModel(
        first_name: _first_name_controller.text.trim(),
        last_name: _last_name_controller.text.trim(),
        address: _address_controller.text.trim(),
        gender: gender_val,
        date_of_birth: dob_api,
      );
      // Trigger Cubit update profile API call
      context.read<ProfileCubit>().updateUserProfile(request_model);
    } else {
      // Form entries are invalid
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
            // Auto fill controllers on successful profile fetch
            if (state is ProfileLoaded && !_is_populated) {
              // Set populate status to true
              _is_populated = true;
              // Set firstName text
              _first_name_controller.text = state.user.first_name;
              // Set lastName text
              _last_name_controller.text = state.user.last_name;
              // Set email text
              _email_controller.text = state.user.email;
              // Set phone text
              _phone_controller.text = _strip_country_code(state.user.phone_number);
              // Set address text
              _address_controller.text = state.user.address ?? '';
              // Set medical history fields
              _national_id_controller.text = state.profile.national_id;
              _weight_controller.text = state.profile.weight;
              _height_controller.text = state.profile.height;
              // Format date of birth to match text input
              if (state.user.date_of_birth != null) {
                try {
                  final List<String> date_parts = state.user.date_of_birth!.split('-');
                  if (date_parts.length == 3) {
                    _dob_controller.text = "${date_parts[2]}/${date_parts[1]}/${date_parts[0]}";
                  }
                } catch (_) {}
              }
              // Set initial email
              _initial_email = state.user.email.trim().toLowerCase();
            }
            // Show a success snackbar when profile update succeeds
            if (state is ProfileUpdateSuccess) {
              context.read<ProfileCubit>().reset_status();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.profile_change_success_msg),
                  backgroundColor: AppColors.primary_color,
                ),
              );
              Navigator.of(context).pop();
            }
            // Show an error snackbar when update fails
            if (state is ProfileUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            // Show loading spinner if profile fetching is in progress
            if (state is ProfileLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary_color,
                  ),
                ),
              );
            }
            // Scaffold provides the page layout structure
            return Scaffold(
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
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
                                        width: _LocalDimensions.avatar_box_size,
                                        height: _LocalDimensions.avatar_box_size,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.primary_color,
                                            width: _LocalDimensions.avatar_border_width,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: is_dark
                                                  ? AppColors.black54
                                                  : AppColors.black12,
                                              blurRadius: _LocalDimensions.avatar_shadow_blur,
                                              offset: const Offset(0.0, _LocalDimensions.avatar_shadow_offset_y),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(_LocalDimensions.avatar_radius),
                                          child: state.temp_profile.avatar_url
                                                  .isNotEmpty
                                              ? (state.temp_profile.avatar_url
                                                      .startsWith('http')
                                                  ? Image.network(
                                                      state.temp_profile
                                                          .avatar_url,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(state.temp_profile
                                                          .avatar_url),
                                                      fit: BoxFit.cover,
                                                    ))
                                              : Container(
                                                  color: AppColors.primary_color
                                                      .withValues(alpha: 0.1),
                                                  child: const Icon(
                                                    Icons.person_rounded,
                                                    color:
                                                        AppColors.primary_color,
                                                    size: _LocalDimensions.default_avatar_icon_size,
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
                                          padding: const EdgeInsets.all(_LocalDimensions.camera_badge_padding),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary_color,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: AppColors.white,
                                            size: _LocalDimensions.camera_badge_icon_size,
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
                                padding: const EdgeInsets.all(_LocalDimensions.card_padding),
                                decoration: BoxDecoration(
                                  color: is_dark
                                      ? AppColors.surface_dark
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(_LocalDimensions.card_radius),
                                  border: Border.all(
                                    color: is_dark
                                        ? AppColors.border_dark
                                        : const Color(0xFFE2E8F0),
                                    width: _LocalDimensions.card_border_width,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: is_dark
                                          ? AppColors.black.withValues(alpha: 0.2)
                                          : AppColors.black
                                              .withValues(alpha: 0.03),
                                      blurRadius: _LocalDimensions.card_shadow_blur,
                                      spreadRadius: 0.0,
                                      offset: const Offset(0.0, _LocalDimensions.card_shadow_offset_y),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1: First name and Last name side-by-side Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          // Focus wrapper handling automatic sanitization on field blur
                                          child: Focus(
                                            onFocusChange: (bool has_focus) {
                                              if (false == has_focus) {
                                                // Trim leading and trailing spaces
                                                _first_name_controller.text =
                                                    _first_name_controller.text
                                                        .trim();
                                              } else {
                                                // Focus active
                                              }
                                            },
                                            child: AuthTextField(
                                              label: localizations
                                                  .profile_first_name_label,
                                              hint: '',
                                              controller:
                                                  _first_name_controller,
                                              keyboard_type: TextInputType.name,
                                              show_shadow: false,
                                              validator: _validate_first_name,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: _LocalDimensions.field_spacing_small),
                                        Expanded(
                                          // Focus wrapper handling automatic sanitization on field blur
                                          child: Focus(
                                            onFocusChange: (bool has_focus) {
                                              if (false == has_focus) {
                                                // Trim leading and trailing spaces
                                                _last_name_controller.text =
                                                    _last_name_controller.text
                                                        .trim();
                                              } else {
                                                // Focus active
                                              }
                                            },
                                            child: AuthTextField(
                                              label: localizations
                                                  .profile_last_name_label,
                                              hint: '',
                                              controller: _last_name_controller,
                                              keyboard_type: TextInputType.name,
                                              show_shadow: false,
                                              validator: _validate_last_name,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // Email input card (full width) with Focus wrapper for sanitization
                                    Focus(
                                      onFocusChange: (bool has_focus) {
                                        if (false == has_focus) {
                                          // Trim, convert to lowercase, and strip hidden control characters
                                          _email_controller.text = _email_controller
                                              .text
                                              .trim()
                                              .toLowerCase()
                                              .replaceAll(
                                                  RegExp(
                                                      r'[\u0000-\u001F\u007F-\u009F]'),
                                                  '');
                                        } else {
                                          // Focus active
                                        }
                                      },
                                      child: AuthTextField(
                                        label:
                                            localizations.profile_email_label,
                                        hint: '',
                                        controller: _email_controller,
                                        keyboard_type:
                                            TextInputType.emailAddress,
                                        show_shadow: false,
                                        validator: _validate_email,
                                      ),
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // Phone input card (full width) disabled and read-only
                                    AuthTextField(
                                      label: localizations.profile_phone_label,
                                      hint: '',
                                      controller: _phone_controller,
                                      keyboard_type: TextInputType.phone,
                                      is_phone: true,
                                      show_shadow: false,
                                      enabled: false,
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // Address input card (full width) with Focus wrapper for sanitization
                                    Focus(
                                      onFocusChange: (bool has_focus) {
                                        if (false == has_focus) {
                                          // Trim leading and trailing spaces
                                          _address_controller.text =
                                              _address_controller.text.trim();
                                        } else {
                                          // Focus active
                                        }
                                      },
                                      child: AuthTextField(
                                        label: true == localizations.is_arabic
                                            ? '${localizations.profile_address_label} (اختياري)'
                                            : '${localizations.profile_address_label} (Optional)',
                                        hint: '',
                                        controller: _address_controller,
                                        keyboard_type:
                                            TextInputType.streetAddress,
                                        show_shadow: false,
                                        validator: _validate_address,
                                      ),
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // National ID input card (full width)
                                    AuthTextField(
                                      label: localizations
                                          .profile_national_id_label,
                                      hint: '',
                                      controller: _national_id_controller,
                                      keyboard_type: TextInputType.number,
                                      is_national_id: true,
                                      show_shadow: false,
                                      input_formatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(14),
                                      ],
                                      validator: _validate_national_id,
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // Date of Birth input card (full width, tapping triggers custom calendar picker dialog)
                                    GestureDetector(
                                      onTap: () async {
                                        if (_national_id_controller
                                            .text.isNotEmpty) {
                                          return;
                                        } else {
                                          final DateTime? picked_date =
                                              await showAppDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                          );
                                          if (picked_date != null) {
                                            final String formatted =
                                                '${picked_date.day}/${picked_date.month}/${picked_date.year}';
                                            setState(() {
                                              _dob_controller.text = formatted;
                                            });
                                          } else {
                                            // Picker cancelled
                                          }
                                        }
                                      },
                                      child: IgnorePointer(
                                        child: AuthTextField(
                                          label: localizations
                                              .profile_birthdate_label,
                                          hint: '',
                                          controller: _dob_controller,
                                          enabled: false,
                                          show_shadow: false,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // Gender label
                                    Text(
                                      localizations.profile_gender_label,
                                      style: TextStyle(
                                        fontSize:
                                            AppSpacing.font_size_body_medium,
                                        fontWeight: FontWeight.w700,
                                        color: is_dark
                                            ? AppColors.text_dark_primary
                                            : AppColors.primary_color,
                                      ),
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_tiny),
                                    // Segmented chips for gender choices limited strictly to Male and Female
                                    _build_segmented_chips<String>(
                                      values: const ['Male', 'Female'],
                                      labels: [
                                        localizations.profile_gender_male,
                                        localizations.profile_gender_female,
                                      ],
                                      selectedValue:
                                          (state.temp_profile.gender ==
                                                      'Male' ||
                                                   state.temp_profile.gender ==
                                                      'Female')
                                              ? state.temp_profile.gender
                                              : 'Male',
                                      onChanged: (value) {
                                        context
                                            .read<ProfileCubit>()
                                            .update_temp_profile(
                                              state.temp_profile
                                                  .copyWith(gender: value),
                                            );
                                      },
                                      is_dark: is_dark,
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // Weight and Height side-by-side Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: AuthTextField(
                                            label: true ==
                                                    localizations.is_arabic
                                                ? '${localizations.profile_weight_label} (كجم)'
                                                : '${localizations.profile_weight_label} (kg)',
                                            hint: '',
                                            controller: _weight_controller,
                                            keyboard_type: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            show_shadow: false,
                                            input_formatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d{0,1}')),
                                            ],
                                            validator: _validate_weight,
                                          ),
                                        ),
                                        const SizedBox(width: _LocalDimensions.field_spacing_small),
                                        Expanded(
                                          child: AuthTextField(
                                            label: true ==
                                                    localizations.is_arabic
                                                ? '${localizations.profile_height_label} (سم)'
                                                : '${localizations.profile_height_label} (cm)',
                                            hint: '',
                                            controller: _height_controller,
                                            keyboard_type: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            show_shadow: false,
                                            input_formatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d{0,1}')),
                                            ],
                                            validator: _validate_height,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_large),
                                    // Smoking section header
                                    Text(
                                      localizations.profile_smoking_section,
                                      style: TextStyle(
                                        fontSize:
                                            AppSpacing.font_size_body_medium,
                                        fontWeight: FontWeight.w700,
                                        color: is_dark
                                            ? AppColors.text_dark_primary
                                            : AppColors.primary_color,
                                      ),
                                    ),
                                    const SizedBox(height: _LocalDimensions.field_spacing_tiny),
                                    // Segmented chips for smoking options
                                    _build_segmented_chips<String>(
                                      values: const ['Yes', 'No', 'Ex-Smoker'],
                                      labels: [
                                        localizations.profile_smoking_yes,
                                        localizations.profile_smoking_no,
                                        localizations.profile_smoking_ex,
                                      ],
                                      selectedValue: state.temp_profile.smoking,
                                      onChanged: (value) {
                                        context
                                            .read<ProfileCubit>()
                                            .update_temp_profile(
                                              state.temp_profile
                                                  .copyWith(smoking: value),
                                            );
                                      },
                                      is_dark: is_dark,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: _LocalDimensions.scroll_bottom_padding),
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
      height: _LocalDimensions.segmented_height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: is_dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(_LocalDimensions.segmented_radius),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          width: _LocalDimensions.segmented_border_width,
        ),
      ),
      padding: const EdgeInsets.all(_LocalDimensions.segmented_padding),
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
                padding: const EdgeInsets.symmetric(horizontal: _LocalDimensions.chip_padding_h),
                decoration: BoxDecoration(
                  color: is_selected
                      ? AppColors.primary_color
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(_LocalDimensions.chip_radius),
                ),
                // FittedBox dynamically scales text down to prevent truncation
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _LocalDimensions.chip_font_size,
                      fontWeight: FontWeight.bold,
                      color: is_selected
                          ? AppColors.white
                          : (is_dark
                              ? AppColors.white70
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

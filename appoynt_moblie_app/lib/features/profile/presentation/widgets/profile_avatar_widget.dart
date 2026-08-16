/*
 * File Name: profile_avatar_widget.dart
 * Author: Kholoud Khaled
 * Date of Creation: 13/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:image_picker/image_picker.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/core/theme/app_colors.dart,
 *   package:appoynt_mobile_app/core/theme/app_spacing.dart,
 *   package:appoynt_mobile_app/core/storage/token_storage.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Reusable stateful widget rendering the patient's circular
 *   profile avatar. Handles three visual states: network image (authenticated
 *   via Bearer token in httpHeaders), uploading spinner overlay, and initials
 *   badge fallback when no image URL is set or the network load fails.
 *   Tapping the avatar opens a Camera/Gallery source selection bottom sheet
 *   which delegates to ProfileCubit.pick_and_upload_avatar_from_source.
 */

// Importing dart:io for File type reference
import 'dart:io';
// Importing Flutter material design library
import 'package:flutter/material.dart';
// Importing BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing image_picker for camera and gallery source selection
import 'package:image_picker/image_picker.dart';
// Importing profile cubit for upload action dispatch
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing app color tokens for design consistency
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Importing token storage to retrieve Bearer token for authenticated image load
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';

// Importing PhotoSourceDialog component for pop-up dialog photo source selection
import 'package:appoynt_mobile_app/features/profile/presentation/widgets/photo_source_dialog.dart';

// Local dimension constants to eliminate hardcoded magic numbers in this widget
class _AvatarDimensions {
  // Total avatar container width and height in logical pixels
  static const double avatar_size = 100.0;
  // Circular border radius equals half the size for a perfect circle
  static const double avatar_radius = 50.0;
  // Camera icon overlay container width and height
  static const double overlay_size = 32.0;
  // Camera icon overlay border radius for rounded-square shape
  static const double overlay_radius = 10.0;
  // Camera icon size inside the overlay container
  static const double overlay_icon_size = 16.0;
  // Upload spinner size while the upload is pending
  static const double spinner_size = 36.0;
  // Upload spinner stroke width
  static const double spinner_stroke = 2.5;
  // Avatar border stroke width
  static const double border_width = 2.5;
  // Shadow blur radius for ambient depth
  static const double shadow_blur = 12.0;
  // Shadow Y offset for elevated appearance
  static const double shadow_offset_y = 4.0;
  // Initials font size inside the fallback badge
  static const double initials_font_size = 34.0;
  // Overlay bottom offset from container edge
  static const double overlay_bottom = 0.0;
  // Overlay right offset from container edge
  static const double overlay_right = 0.0;
  // Shadow opacity when in light mode
  static const double shadow_opacity_light = 0.08;
}

// Reusable circular profile avatar widget with upload and fallback capabilities
class ProfileAvatarWidget extends StatefulWidget {
  // The current avatar URL from the profile state (network or empty)
  final String avatar_url;
  // First name of the user for initials badge generation
  final String first_name;
  // Last name of the user for initials badge generation
  final String last_name;
  // Flag indicating whether an upload is currently in progress
  final bool is_uploading;
  // Flag controlling visibility of the camera edit icon overlay badge
  final bool show_camera_badge;
  // Optional custom tap callback handler
  final VoidCallback? on_tap;

  // Constructor requiring display parameters
  const ProfileAvatarWidget({
    super.key,
    // Required avatar URL (may be empty string when no photo is set)
    required this.avatar_url,
    // Required first name for initials fallback
    required this.first_name,
    // Required last name for initials fallback
    required this.last_name,
    // Required uploading flag to show spinner overlay
    required this.is_uploading,
    // Optional flag to show or hide camera edit badge overlay (defaults to true)
    this.show_camera_badge = true,
    // Optional custom tap callback override
    this.on_tap,
  });

  @override
  // Create the mutable state tracker instance
  State<ProfileAvatarWidget> createState() {
    // Return the concrete state class
    return _ProfileAvatarWidgetState();
  }
}

// Concrete mutable state for ProfileAvatarWidget managing token and tap events
class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  // Resolved Bearer token string used as httpHeaders for authenticated network image
  String? _resolved_token;

  @override
  // Initialize state and load the Bearer token for authenticated image loading
  void initState() {
    // Invoke base initState to complete standard lifecycle setup
    super.initState();
    // Load the access token asynchronously for network image authentication
    _load_token();
  }

  // Reads the access token from secure storage into the local state variable
  Future<void> _load_token() async {
    // Read the stored access token from secure local storage
    final String? token = await TokenStorage.get_access_token();
    // Guard against calling setState on a dismounted widget
    if (mounted) {
      // Apply the resolved token to trigger a rebuild with auth headers
      setState(() {
        // Assign the resolved token for use in httpHeaders
        _resolved_token = token;
      });
    } else {
      // Widget was unmounted before token resolved — discard result safely
    }
  }

  // Computes a two-character initials string from the provided name components
  String _compute_initials() {
    // Extract first character of first_name, uppercase, or empty string
    final String first_initial = widget.first_name.isNotEmpty
        ? widget.first_name[0].toUpperCase()
        : '';
    // Extract first character of last_name, uppercase, or empty string
    final String last_initial = widget.last_name.isNotEmpty
        ? widget.last_name[0].toUpperCase()
        : '';
    // Concatenate both initials into a two-character badge string
    final String initials = '$first_initial$last_initial';
    // Return computed initials or a generic person icon placeholder key
    return initials.isNotEmpty ? initials : '?';
  }

  // Presents the centered PhotoSourceDialog pop-up modal and dispatches
  // the selected image source (Camera vs Gallery) to the ProfileCubit upload handler.
  Future<void> _show_source_picker_sheet(BuildContext sheet_context) async {
    // Show pop-up dialog using the PhotoSourceDialog helper
    final ImageSource? selected_source =
        await show_photo_source_dialog(sheet_context);
    // Verify source selection and context mount status across async gap
    if (null != selected_source && sheet_context.mounted) {
      // Dispatch selected source to cubit avatar upload method
      sheet_context
          .read<ProfileCubit>()
          .pick_and_upload_avatar_from_source(selected_source);
    } else {
      // User cancelled dialog or context was unmounted
    }
  }

  @override
  // Build the avatar widget hierarchy
  Widget build(BuildContext context) {
    // Resolve theme brightness for adaptive UI elements
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Compute initials badge text from the current name values
    final String initials = _compute_initials();
    // Determine whether avatar_url is a valid network URL (starts with http)
    final bool is_network_url = widget.avatar_url.isNotEmpty &&
        widget.avatar_url.startsWith('http');
    // Determine whether avatar_url is a local file path (for preview before upload)
    final bool is_local_file = widget.avatar_url.isNotEmpty &&
        !widget.avatar_url.startsWith('http') &&
        File(widget.avatar_url).existsSync();

    // Return a GestureDetector wrapping the avatar container for tap events
    return GestureDetector(
      // Tap handler executes custom callback or opens source picker sheet
      onTap: widget.is_uploading
          ? null
          : (widget.on_tap ??
              (true == widget.show_camera_badge
                  ? () {
                      // Invoke the source picker bottom sheet helper
                      _show_source_picker_sheet(context);
                    }
                  : null)),
      // Outer Stack overlays the avatar container with the upload spinner
      child: Stack(
        // Clip child widgets within the stack bounds
        clipBehavior: Clip.none,
        children: [
          // Base avatar circular container
          Container(
            // Fixed width from dimension constants
            width: _AvatarDimensions.avatar_size,
            // Fixed height from dimension constants
            height: _AvatarDimensions.avatar_size,
            // Box decoration applying circular shape, border, and shadow
            decoration: BoxDecoration(
              // Circular container shape
              shape: BoxShape.circle,
              // Thin brand-blue border ring around the avatar
              border: Border.all(
                // Brand primary color for the border stroke
                color: AppColors.primary_color,
                // Thin stroke from dimension tokens
                width: _AvatarDimensions.border_width,
              ),
              // Ambient soft shadow for depth perception
              boxShadow: [
                BoxShadow(
                  // Adaptive shadow color based on brightness
                  color: is_dark
                      ? AppColors.black45
                      : AppColors.black.withValues(
                          alpha: _AvatarDimensions.shadow_opacity_light),
                  // Blur spread radius from dimension tokens
                  blurRadius: _AvatarDimensions.shadow_blur,
                  // Y offset for downward elevation look
                  offset: const Offset(0.0, _AvatarDimensions.shadow_offset_y),
                ),
              ],
            ),
            // ClipRRect ensures image respects circular border bounds
            child: ClipRRect(
              // Corner radius matching half of avatar_size for perfect circle
              borderRadius: BorderRadius.circular(
                _AvatarDimensions.avatar_radius,
              ),
              // Conditionally render network image, local file, or initials badge
              child: widget.is_uploading
                  ? _build_uploading_placeholder(is_dark)
                  : (is_network_url
                      ? _build_network_image()
                      : (is_local_file
                          ? _build_local_file_image()
                          : _build_initials_badge(initials, is_dark))),
            ),
          ),
          // Camera edit icon overlay — conditionally rendered based on flag
          if (true == widget.show_camera_badge)
            Positioned(
              // Flush to the bottom edge of the avatar container
              bottom: _AvatarDimensions.overlay_bottom,
              // Flush to the right edge of the avatar container
              right: _AvatarDimensions.overlay_right,
              // Overlay container styling the edit badge
              child: Container(
                // Fixed overlay width from dimension tokens
                width: _AvatarDimensions.overlay_size,
                // Fixed overlay height from dimension tokens
                height: _AvatarDimensions.overlay_size,
                // Style with brand primary blue background and rounded corners
                decoration: BoxDecoration(
                  // Brand primary color background for the camera badge
                  color: AppColors.primary_color,
                  // Rounded-square shape for the overlay container
                  borderRadius: BorderRadius.circular(
                    _AvatarDimensions.overlay_radius,
                  ),
                  // White border to visually separate from the avatar image
                  border: Border.all(
                    // White separator border color
                    color: AppColors.white,
                    // Thin border width matching avatar border weight
                    width: _AvatarDimensions.border_width,
                  ),
                ),
                // Center the camera icon inside the overlay container
                child: const Center(
                  child: Icon(
                    // Camera icon from Material icons library
                    Icons.camera_alt_rounded,
                    // White icon color for contrast against brand blue
                    color: AppColors.white,
                    // Icon size from dimension token
                    size: _AvatarDimensions.overlay_icon_size,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Builds the network image with authenticated Bearer token httpHeaders
  Widget _build_network_image() {
    // Guard: wait for Bearer token resolution before requesting image bytes
    if (null == _resolved_token) {
      return Container(
        width: _AvatarDimensions.avatar_size,
        height: _AvatarDimensions.avatar_size,
        color: AppColors.primary_color.withValues(alpha: 0.08),
        child: const Center(
          child: SizedBox(
            width: _AvatarDimensions.spinner_size,
            height: _AvatarDimensions.spinner_size,
            child: CircularProgressIndicator(
              strokeWidth: _AvatarDimensions.spinner_stroke,
              color: AppColors.primary_color,
            ),
          ),
        ),
      );
    } else {
      // Token resolved
    }
    // Construct the Authorization header map for authenticated image loading
    final Map<String, String> auth_headers = {
      'Authorization': 'Bearer $_resolved_token',
    };
    // Return an Image.network widget with auth headers and error fallback
    return Image.network(
      // Avatar URL from the profile state
      widget.avatar_url,
      // Scale image to cover the full circular container
      fit: BoxFit.cover,
      // Attach the Bearer token header for authenticated image fetching
      headers: auth_headers,
      // Error builder renders the initials fallback when network load fails
      errorBuilder: (error_context, error_obj, stack_trace) {
        // Resolve dark mode status in the error context
        final bool is_dark_err =
            Theme.of(error_context).brightness == Brightness.dark;
        // Return initials badge as a graceful fallback on network error
        return _build_initials_badge(_compute_initials(), is_dark_err);
      },
      // Loading builder shows a shimmer/spinner while image bytes are loading
      loadingBuilder: (loading_context, child_widget, load_progress) {
        // Guard: show the loaded image when loading_progress is null (complete)
        if (null == load_progress) {
          // Image is fully loaded — render the child widget
          return child_widget;
        } else {
          // Image is still loading — render a centered progress indicator
          return Container(
            // Match the exact container dimensions from constants
            width: _AvatarDimensions.avatar_size,
            // Match height from constants
            height: _AvatarDimensions.avatar_size,
            // Light brand color background while bytes are downloading
            color: AppColors.primary_color.withValues(alpha: 0.08),
            // Center the progress indicator inside the container
            child: const Center(
              child: SizedBox(
                // Spinner width from dimension constants
                width: _AvatarDimensions.spinner_size,
                // Spinner height from dimension constants
                height: _AvatarDimensions.spinner_size,
                child: CircularProgressIndicator(
                  // Stroke width from dimension constants
                  strokeWidth: _AvatarDimensions.spinner_stroke,
                  // Brand primary color for the progress indicator
                  color: AppColors.primary_color,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Builds a local file image preview (shown between selection and upload success)
  Widget _build_local_file_image() {
    // Return an Image.file widget rendering the locally selected file
    return Image.file(
      // Wrap the file path string in a File reference
      File(widget.avatar_url),
      // Scale to cover the full circular container
      fit: BoxFit.cover,
      // Error builder falls back to initials on file read error
      errorBuilder: (err_context, err_obj, stack_trace) {
        // Resolve dark mode status in the error context
        final bool is_dark_err =
            Theme.of(err_context).brightness == Brightness.dark;
        // Return initials fallback on file read failure
        return _build_initials_badge(_compute_initials(), is_dark_err);
      },
    );
  }

  // Builds the uploading placeholder with a centered circular progress indicator
  Widget _build_uploading_placeholder(bool is_dark) {
    // Return a container with a light brand background and centered spinner
    return Container(
      // Match the avatar container dimensions
      width: _AvatarDimensions.avatar_size,
      // Match height from constants
      height: _AvatarDimensions.avatar_size,
      // Brand blue tinted background during upload progress
      color: AppColors.primary_color.withValues(alpha: 0.1),
      // Center the spinner inside the uploading placeholder
      child: const Center(
        child: SizedBox(
          // Spinner width from dimension constants
          width: _AvatarDimensions.spinner_size,
          // Spinner height from dimension constants
          height: _AvatarDimensions.spinner_size,
          child: CircularProgressIndicator(
            // Stroke width from dimension constants
            strokeWidth: _AvatarDimensions.spinner_stroke,
            // Brand primary blue color for the upload progress ring
            color: AppColors.primary_color,
          ),
        ),
      ),
    );
  }

  // Builds the initials badge fallback shown when no avatar URL is available
  Widget _build_initials_badge(String initials, bool is_dark) {
    // Return a container with brand-tinted background and centered initials text
    return Container(
      // Match the avatar container dimensions from constants
      width: _AvatarDimensions.avatar_size,
      // Match height from constants
      height: _AvatarDimensions.avatar_size,
      // Light brand blue background for the initials fallback container
      color: AppColors.primary_color.withValues(alpha: 0.1),
      // Center the initials text inside the container
      child: Center(
        child: Text(
          // Display the computed two-character initials
          initials,
          // Style the initials with bold weight and brand color
          style: const TextStyle(
            // Large font size for prominent initials display
            fontSize: _AvatarDimensions.initials_font_size,
            // Bold font weight for visual emphasis
            fontWeight: FontWeight.bold,
            // Brand primary color for initials text
            color: AppColors.primary_color,
          ),
        ),
      ),
    );
  }
}

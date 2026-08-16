/*
 * File Name: image_preview_dialog.dart
 * Author: Kholoud Khaled
 * Date of Creation: 13/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart,
 *   package:appoynt_mobile_app/core/storage/token_storage.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Renders a full-screen zoomable image preview modal dialog
 *   allowing users to view their profile avatar photo with pinch-to-zoom support.
 */

// Importing I/O library for File operations check
import 'dart:io';
// Importing Flutter material design widget library
import 'package:flutter/material.dart';
// Importing app color constants for design system compliance
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Importing token storage service for authenticated image header retrieval
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';

// Local dimension constants eliminating hardcoded numbers in dialog
class _PreviewDimensions {
  // Close icon vector size
  static const double close_icon_size = 24.0;
  // Minimum zoom scale factor
  static const double min_scale = 0.5;
  // Maximum zoom scale factor
  static const double max_scale = 4.0;
  // Font size for initials badge fallback text
  static const double initials_font_size = 64.0;
  // Badge container dimensions for initials fallback
  static const double initials_badge_size = 180.0;
  // Close button top positioning offset
  static const double button_offset_top = 16.0;
  // Close button side positioning offset
  static const double button_offset_side = 16.0;
}

// Stateful widget presenting the full-screen zoomable avatar preview dialog
class ImagePreviewDialog extends StatefulWidget {
  // Target avatar image URL or local file path
  final String image_url;
  // Patient first name for initials fallback calculation
  final String first_name;
  // Patient last name for initials fallback calculation
  final String last_name;

  // Constructor requiring avatar image source and user name components
  const ImagePreviewDialog({
    super.key,
    // Required image URL or local path string
    required this.image_url,
    // Required first name string
    required this.first_name,
    // Required last name string
    required this.last_name,
  });

  @override
  // Create mutable state instance for image token loading
  State<ImagePreviewDialog> createState() {
    // Return concrete state representation
    return _ImagePreviewDialogState();
  }
}

// State class managing Bearer token retrieval and image preview lifecycle
class _ImagePreviewDialogState extends State<ImagePreviewDialog> {
  // Resolved Bearer access token for authenticated network image request
  String? _resolved_token;

  @override
  // Initialize state and resolve security token
  void initState() {
    // Call base class initState implementation
    super.initState();
    // Load security token asynchronously
    _load_token();
  }

  // Reads access token from secure storage into state
  Future<void> _load_token() async {
    // Fetch JWT token from storage service
    final String? token = await TokenStorage.get_access_token();
    // Verify widget mount status before updating state
    if (mounted) {
      // Set resolved token in state
      setState(() {
        // Assign token value
        _resolved_token = token;
      });
    } else {
      // Widget unmounted before token returned
    }
  }

  // Computes two-character initials from first and last names
  String _compute_initials() {
    // Extract first character of first_name if non-empty
    final String first_char = widget.first_name.isNotEmpty
        ? widget.first_name[0].toUpperCase()
        : '';
    // Extract first character of last_name if non-empty
    final String last_char = widget.last_name.isNotEmpty
        ? widget.last_name[0].toUpperCase()
        : '';
    // Concatenate initials
    final String result = '$first_char$last_char';
    // Return computed initials or fallback question mark
    return result.isNotEmpty ? result : '?';
  }

  @override
  // Build dialog UI hierarchy
  Widget build(BuildContext context) {
    // Determine whether image_url is a valid network URL
    final bool is_network_url = widget.image_url.isNotEmpty &&
        widget.image_url.startsWith('http');
    // Determine whether image_url is a valid local file path
    final bool is_local_file = widget.image_url.isNotEmpty &&
        !widget.image_url.startsWith('http') &&
        File(widget.image_url).existsSync();
    // Compute initials fallback string
    final String initials = _compute_initials();

    // Return full-screen Dialog container
    return Dialog.fullscreen(
      // Translucent dark background color for preview overlay
      backgroundColor: AppColors.black,
      // Stack positioning close button over zoomable image content
      child: Stack(
        // Fill stack area
        fit: StackFit.expand,
        children: [
          // Center zoomable preview viewport
          Center(
            // InteractiveViewer enabling pinch-to-zoom and pan gestures
            child: InteractiveViewer(
              // Set minimum scale bound
              minScale: _PreviewDimensions.min_scale,
              // Set maximum scale bound
              maxScale: _PreviewDimensions.max_scale,
              // Render target image or initials fallback badge
              child: is_network_url
                  ? _build_network_image()
                  : (is_local_file
                      ? _build_local_file_image()
                      : _build_initials_badge(initials)),
            ),
          ),
          // Positioned close button at top corner
          Positioned(
            // Top offset spacing
            top: _PreviewDimensions.button_offset_top,
            // Right offset spacing
            right: _PreviewDimensions.button_offset_side,
            // SafeArea wrapper avoiding status bar overlap
            child: SafeArea(
              // Circular background wrapper for close icon
              child: Material(
                // Translucent dark circular background
                color: AppColors.black45,
                // Circular shape for button background
                shape: const CircleBorder(),
                // Clip child within circle
                clipBehavior: Clip.antiAlias,
                // InkWell for ripple response on tap
                child: IconButton(
                  // Set icon size
                  iconSize: _PreviewDimensions.close_icon_size,
                  // Close cross icon
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.white,
                  ),
                  // Tap handler popping dialog screen
                  onPressed: () {
                    // Pop full screen modal dialog
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Renders authenticated network image
  Widget _build_network_image() {
    // Guard: wait for Bearer token resolution before requesting image bytes
    if (null == _resolved_token) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary_color,
        ),
      );
    } else {
      // Token resolved
    }
    // Construct header map with Bearer token
    final Map<String, String> headers = {
      'Authorization': 'Bearer $_resolved_token',
    };
    // Return Network Image with fit contain scaling
    return Image.network(
      // Target network URL
      widget.image_url,
      // Fit contain preserving aspect ratio
      fit: BoxFit.contain,
      // Attach auth headers
      headers: headers,
      // Fallback on network load error
      errorBuilder: (context, error, stackTrace) {
        // Render initials fallback on error
        return _build_initials_badge(_compute_initials());
      },
      // Loading spinner overlay
      loadingBuilder: (context, child, progress) {
        // Verify load completion using Yoda check
        if (null == progress) {
          // Render loaded image widget
          return child;
        } else {
          // Render progress indicator while bytes download
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary_color,
            ),
          );
        }
      },
    );
  }

  // Renders local file image
  Widget _build_local_file_image() {
    // Return File image widget
    return Image.file(
      // Create File object from path
      File(widget.image_url),
      // Fit contain preserving aspect ratio
      fit: BoxFit.contain,
      // Fallback on read error
      errorBuilder: (context, error, stackTrace) {
        // Render initials fallback on file error
        return _build_initials_badge(_compute_initials());
      },
    );
  }

  // Renders fallback badge showing user initials
  Widget _build_initials_badge(String initials) {
    // Circular container with brand background
    return Container(
      // Set fixed width
      width: _PreviewDimensions.initials_badge_size,
      // Set fixed height
      height: _PreviewDimensions.initials_badge_size,
      // Circular box decoration
      decoration: const BoxDecoration(
        // Brand primary color background
        color: AppColors.primary_color,
        // Circular shape
        shape: BoxShape.circle,
      ),
      // Center initials text inside circle
      child: Center(
        child: Text(
          // Display initials
          initials,
          // Style with white text and large font
          style: const TextStyle(
            color: AppColors.white,
            fontSize: _PreviewDimensions.initials_font_size,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Global helper function to present the image preview dialog
void show_image_preview_dialog(
  BuildContext context, {
  required String image_url,
  required String first_name,
  required String last_name,
}) {
  // Show full screen dialog modal
  showDialog<void>(
    // Parent context
    context: context,
    // Dark barrier background
    barrierColor: AppColors.black,
    // Dialog widget builder
    builder: (dialog_context) {
      // Instantiate and return preview dialog
      return ImagePreviewDialog(
        image_url: image_url,
        first_name: first_name,
        last_name: last_name,
      );
    },
  );
}

/*
 * File Name: security_privacy_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart,
 *   dart:ui,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Redesigned floating card dashboard displaying biometric adaptive toggles, password inputs, and account deletion warnings with blurs.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing UI library for blurs
import 'dart:ui';
// Importing flutter bloc for state handling
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing profile cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing profile state definition
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing change password page
import 'package:appoynt_mobile_app/features/profile/presentation/pages/change_password_page.dart';

// Stateful widget displaying Security details layout
class SecurityPrivacyPage extends StatefulWidget {
  // Constructor mapping key
  const SecurityPrivacyPage({super.key});

  @override
  // Create state tracker instance
  State<SecurityPrivacyPage> createState() {
    // Return state class instance
    return _SecurityPrivacyPageState();
  }
}

// State class managing biometric switches and modal displays
class _SecurityPrivacyPageState extends State<SecurityPrivacyPage> {
  // Face ID/biometrics toggler switch
  bool _biometrics_enabled = false;

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // Apply background color dynamically based on dark modes
      backgroundColor:
          true == is_dark ? AppColors.background_dark : const Color(0xFFF1F5F9),
      // Body wrap in safe area and scroll view
      body: SafeArea(
        // Scroll view protecting layout bounds
        child: SingleChildScrollView(
          // Outer padding margins (strictly 16px lateral padding)
          child: Padding(
            // Margins boundaries
            padding: const EdgeInsets.symmetric(
              // Horizontal offset (16px)
              horizontal: AppSpacing.space_xl,
              // Vertical offset
              vertical: AppSpacing.space_m,
            ),
            // Column stack grouping layouts
            child: BlocBuilder<ProfileCubit, ProfileState>(
              // Builder callback
              builder: (bloc_context, state) {
                // Column stacking widgets
                return Column(
                  // Align left coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list
                  children: [
                    // Top header row placing circular back button and screen title
                    Row(
                      // Distribute items
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // children list
                      children: [
                        // Back button gesture detector
                        GestureDetector(
                          // POP route on tap
                          onTap: () {
                            // pop navigation
                            Navigator.of(context).pop();
                          },
                          // Circular button container
                          child: Container(
                            // Fixed width
                            width: 44.0,
                            // Fixed height
                            height: 44.0,
                            // Styles
                            decoration: BoxDecoration(
                              // Dark/Light surface color fills
                              color: true == is_dark
                                  ? AppColors.surface_dark
                                  : Colors.white,
                              // Circular borders shape
                              shape: BoxShape.circle,
                              // Card soft shadows
                              boxShadow: [
                                BoxShadow(
                                  // Shadow colors
                                  color: true == is_dark
                                      ? Colors.black26
                                      : Colors.black.withValues(alpha: 0.05),
                                  // Blur spread
                                  blurRadius: 8.0,
                                  // Spread offsets
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            // Chevron arrow icon graphic
                            child: Icon(
                              // Arrow left symbol
                              Icons.arrow_back_rounded,
                              // Dynamic color
                              color: true == is_dark
                                  ? Colors.white
                                  : AppColors.text_light_primary,
                              // Size
                              size: AppSpacing.icon_size_m,
                            ),
                          ),
                        ),
                        // Screen Title Text widget
                        Text(
                          // Localized title
                          localizations.profile_security_privacy,
                          // Typography options
                          style: TextStyle(
                            // Header size
                            fontSize: 18.0,
                            // Bolder font weight
                            fontWeight: FontWeight.w800,
                            // Dynamic colors
                            color: true == is_dark
                                ? Colors.white
                                : AppColors.text_light_primary,
                          ),
                        ),
                        // Balancer spacer matching back button dimensions
                        const SizedBox(width: 44.0),
                      ],
                    ),
                    // Spacing offset
                    const SizedBox(height: AppSpacing.space_xl),

                    // CARD A: Floating Biometrics Card
                    Container(
                      // Padding margins
                      margin: const EdgeInsets.only(bottom: 16.0),
                      // Padding inside card (spacious 16px internal padding)
                      padding: const EdgeInsets.all(16.0),
                      // Card decorations styling
                      decoration: BoxDecoration(
                        // Dynamic surface colors
                        color: true == is_dark
                            ? AppColors.surface_dark
                            : Colors.white,
                        // Corners radius curvature
                        borderRadius: BorderRadius.circular(16.0),
                        // Ambient soft shadows list
                        boxShadow: [
                          BoxShadow(
                            // Shadow colors adapting to dark mode
                            color: true == is_dark
                                ? Colors.black.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.05),
                            // Blur spread
                            blurRadius: 10.0,
                            // Offset coordinates position
                            offset: const Offset(0, 4),
                          ),
                        ],
                        // Outline border lines
                        border: Border.all(
                          // Border colors matching theme mode
                          color: true == is_dark
                              ? AppColors.border_dark
                              : const Color(0xFFE2E8F0),
                          // Boundary line thickness
                          width: AppSpacing.border_width_thin,
                        ),
                      ),
                      // Horizontal row placing icon, description, and Switch component
                      child: Row(
                        // children list
                        children: [
                          // Rounded container housing fingerprint/biometric icon
                          Container(
                            // Width
                            width: 44.0,
                            // Height
                            height: 44.0,
                            // Style
                            decoration: BoxDecoration(
                              // Light transparent primary color
                              color: AppColors.primary_color
                                  .withValues(alpha: 0.08),
                              // Rounded corners
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            // Shield biometrics icon
                            child: const Icon(
                              // fingerprint icon representation
                              Icons.fingerprint_rounded,
                              // Color
                              color: AppColors.primary_color,
                              // Size
                              size: 22.0,
                            ),
                          ),
                          // Spacing gap width
                          const SizedBox(width: 12.0),
                          // Label stack column taking remaining width
                          Expanded(
                            // Column stack
                            child: Column(
                              // Align left coordinates
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // children list
                              children: [
                                // Title label text
                                Text(
                                  // Localized biometrics key
                                  localizations.profile_face_id,
                                  // Typography
                                  style: TextStyle(
                                    // Medium body size
                                    fontSize: 14.0,
                                    // Bold weight
                                    fontWeight: FontWeight.bold,
                                    // Dynamic colors
                                    color: true == is_dark
                                        ? Colors.white
                                        : AppColors.text_light_primary,
                                  ),
                                ),
                                // Spacing gap height
                                const SizedBox(height: 4.0),
                                // Subtitle detail description (proportional micro-font 12px)
                                const Text(
                                  // Professional medical account copywriting
                                  'Enable biometric authentication for quick and secure account access',
                                  // Typography
                                  style: TextStyle(
                                    // Micro-font size
                                    fontSize: 12.0,
                                    // Muted color
                                    color: AppColors.text_light_secondary,
                                    // Explicit line height to prevent overlapping
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Spacing gap width
                          const SizedBox(width: 8.0),
                          // Sleek proportional Switch toggle component (Material 3/iOS standard adaptive)
                          Switch.adaptive(
                            // Status value mapping variable
                            value: _biometrics_enabled,
                            // Toggle status on click
                            onChanged: (val) {
                              // Trigger rebuild
                              setState(() {
                                // Update value
                                _biometrics_enabled = val;
                              });
                            },
                            // Active track color primary brand blue
                            activeTrackColor: AppColors.primary_color,
                            // Active thumb color white contrast
                            activeThumbColor: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    // CARD B: Floating Change Password Card
                    Container(
                      // Padding margins
                      margin: const EdgeInsets.only(bottom: 16.0),
                      // Card decorations styling
                      decoration: BoxDecoration(
                        // Dynamic surface colors
                        color: true == is_dark
                            ? AppColors.surface_dark
                            : Colors.white,
                        // Corners radius curvature
                        borderRadius: BorderRadius.circular(16.0),
                        // Ambient soft shadows list
                        boxShadow: [
                          BoxShadow(
                            // Shadow colors adapting to dark mode
                            color: true == is_dark
                                ? Colors.black.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.05),
                            // Blur spread
                            blurRadius: 10.0,
                            // Offset coordinates position
                            offset: const Offset(0, 4),
                          ),
                        ],
                        // Outline border lines
                        border: Border.all(
                          // Border colors matching theme mode
                          color: true == is_dark
                              ? AppColors.border_dark
                              : const Color(0xFFE2E8F0),
                          // Boundary line thickness
                          width: AppSpacing.border_width_thin,
                        ),
                      ),
                      // InkWell wrapper to trigger click action
                      child: Material(
                        // Transparent colors
                        color: Colors.transparent,
                        // Clickable area
                        child: InkWell(
                          // Curved corners radius
                          borderRadius: BorderRadius.circular(16.0),
                          // Click handler trigger change password screen layout navigation
                          onTap: () {
                            // Push navigate to ChangePasswordPage layout screen
                            Navigator.of(context).push(
                              // Route builder
                              MaterialPageRoute(
                                // Builder constructor
                                builder: (route_context) => BlocProvider.value(
                                  // Carry cubit block context forward
                                  value: context.read<ProfileCubit>(),
                                  // Change password page widget
                                  child: const ChangePasswordPage(),
                                ),
                              ),
                            );
                          },
                          // Card design padding offsets (breathable 16px internal padding)
                          child: Padding(
                            // Padding
                            padding: const EdgeInsets.all(16.0),
                            // Horizontal alignment row placing icon, details column, and chevron arrow
                            child: Row(
                              // children details
                              children: [
                                // Soft circular background padding container for the leading icon
                                Container(
                                  // Width
                                  width: 44.0,
                                  // Height
                                  height: 44.0,
                                  // Layout shape style decoration
                                  decoration: BoxDecoration(
                                    // Soft circular background tint
                                    color: AppColors.primary_color
                                        .withValues(alpha: 0.08),
                                    // Circular shape
                                    shape: BoxShape.circle,
                                  ),
                                  // Lock reset icon centered
                                  child: const Icon(
                                    // Lock reset icon graphic representation
                                    Icons.lock_reset_rounded,
                                    // Primary brand color
                                    color: AppColors.primary_color,
                                    // Size
                                    size: 22.0,
                                  ),
                                ),
                                // Horizontal spacer gap width
                                const SizedBox(width: 12.0),
                                // Details column taking remaining space
                                Expanded(
                                  // Column
                                  child: Column(
                                    // Align left coordinates
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // children
                                    children: [
                                      // Section title label
                                      Text(
                                        // Localized password change key
                                        localizations.password_change_title,
                                        // Typographic settings
                                        style: TextStyle(
                                          // Size body
                                          fontSize: 14.0,
                                          // Bold weight
                                          fontWeight: FontWeight.bold,
                                          // Dynamic colors
                                          color: true == is_dark
                                              ? Colors.white
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                      // Spacer gap height
                                      const SizedBox(height: 4.0),
                                      // Subtitle description detail (12px micro-font)
                                      const Text(
                                        // Subtitle text copy
                                        'Update account password key credentials',
                                        // Styles
                                        style: TextStyle(
                                          // Micro-font size
                                          fontSize: 12.0,
                                          // Muted secondary colors
                                          color: AppColors.text_light_secondary,
                                          // Line height spacing
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Spacing partition gap width
                                const SizedBox(width: 8.0),
                                // Right directional chevron indicator
                                Icon(
                                  // Arrow chevron point right
                                  Icons.chevron_right_rounded,
                                  // Secondary color tint
                                  color: true == is_dark
                                      ? Colors.white30
                                      : AppColors.text_light_secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // CARD C: Floating Delete Account Card (Isolated at the bottom with breathing room)
                    Container(
                      // Margin spacing at the bottom (isolated action block)
                      margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                      // Card decorations styling
                      decoration: BoxDecoration(
                        // Dynamic surface colors
                        color: true == is_dark
                            ? AppColors.surface_dark
                            : Colors.white,
                        // Corners radius curvature
                        borderRadius: BorderRadius.circular(16.0),
                        // Ambient soft shadows list
                        boxShadow: [
                          BoxShadow(
                            // Shadow colors adapting to dark mode
                            color: true == is_dark
                                ? Colors.black.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.03),
                            // Blur spread
                            blurRadius: 10.0,
                            // Offset coordinates position
                            offset: const Offset(0, 4),
                          ),
                        ],
                        // Outline border lines (using low-saturated red error outline)
                        border: Border.all(
                          // Error red color outline
                          color: AppColors.error.withValues(alpha: 0.3),
                          // Boundary line thickness
                          width: AppSpacing.border_width_thin,
                        ),
                      ),
                      // InkWell wrapper to catch press events
                      child: Material(
                        // Transparent colors
                        color: Colors.transparent,
                        // Clickable area
                        child: InkWell(
                          // Curved corners radius
                          borderRadius: BorderRadius.circular(16.0),
                          // Trigger account deletion dialog on tap
                          onTap: () {
                            // Invoke warning alert dialog popup
                            _show_delete_account_dialog(context);
                          },
                          // Card design padding offsets (spacious 16px internal padding)
                          child: Padding(
                            // Padding bounds
                            padding: const EdgeInsets.all(16.0),
                            // Horizontal row placing icon and description details
                            child: Row(
                              // children details
                              children: [
                                // Soft background container wrapping the delete icon
                                Container(
                                  // Width
                                  width: 44.0,
                                  // Height
                                  height: 44.0,
                                  // Layout shape style decoration
                                  decoration: BoxDecoration(
                                    // Soft red background tint
                                    color:
                                        AppColors.error.withValues(alpha: 0.08),
                                    // Circular shape
                                    shape: BoxShape.circle,
                                  ),
                                  // Delete account icon centered
                                  child: const Icon(
                                    // Delete account icon representation
                                    Icons.no_accounts_rounded,
                                    // Error color red
                                    color: AppColors.error,
                                    // Size
                                    size: 20.0,
                                  ),
                                ),
                                // Horizontal spacer gap width
                                const SizedBox(width: 12.0),
                                // Details column taking remaining width space
                                Expanded(
                                  // Column stack
                                  child: Column(
                                    // Align left coordinates
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // children
                                    children: [
                                      // Warning header Title
                                      Text(
                                        // Localized delete account string key
                                        localizations.profile_delete_account,
                                        // Typographic settings
                                        style: const TextStyle(
                                          // Size body
                                          fontSize: 14.0,
                                          // Bold weight
                                          fontWeight: FontWeight.bold,
                                          // Error red warning colors
                                          color: AppColors.error,
                                        ),
                                      ),
                                      // Spacer gap height
                                      const SizedBox(height: 4.0),
                                      // Subtitle description detail (proportional 12px micro-font)
                                      const Text(
                                        // User-centric legal privacy copywriting text
                                        'Permanently erase your personal data and account logs according to privacy compliance rules',
                                        // Styles
                                        style: TextStyle(
                                          // Micro-font size
                                          fontSize: 12.0,
                                          // Muted secondary colors
                                          color: AppColors.text_light_secondary,
                                          // Line height spacing
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Helper method displaying native account deletion popup modal dialog with blurred screen backdrop
  void _show_delete_account_dialog(BuildContext context) {
    // Resolve localized strings
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Open blurred dialog
    showDialog(
      // Bind context
      context: context,
      // Dialog builder constructor
      builder: (dialog_context) {
        // BackdropFilter supplying premium blur effect on background screens
        return BackdropFilter(
          // Blur parameters values
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          // Dialog container
          child: AlertDialog(
            // Dialog surface color matching theme mode
            backgroundColor:
                true == is_dark ? AppColors.surface_dark : Colors.white,
            // Curved corners contours
            shape: RoundedRectangleBorder(
              // 16px corner radius bounds
              borderRadius: BorderRadius.circular(16.0),
            ),
            // Warning header title label
            title: Text(
              // Title string key
              localizations.profile_delete_account_dialog_title,
              // Typography
              style: const TextStyle(
                // Bold weight
                fontWeight: FontWeight.bold,
                // Danger red warning colors
                color: AppColors.error,
              ),
            ),
            // Description content details text widget
            content: Text(
              // warning details string key
              localizations.profile_delete_account_warning,
              // style
              style: TextStyle(
                // Size
                fontSize: 13.0,
                // Colors
                color: true == is_dark
                    ? Colors.white70
                    : AppColors.text_light_secondary,
              ),
            ),
            // Danger actions action triggers list
            actions: [
              // Muted Cancel button
              TextButton(
                // Close dialog onTap
                onPressed: () {
                  // POP context dialog
                  Navigator.of(dialog_context).pop();
                },
                // Cancel string
                child: Text(
                  // Label cancellation key
                  localizations.profile_cancel_button,
                  // Muted style options
                  style: TextStyle(
                    // Muted color theme
                    color: true == is_dark
                        ? Colors.white54
                        : AppColors.text_light_secondary,
                  ),
                ),
              ),
              // Destructive Red Delete execution trigger button
              ElevatedButton(
                // Confirm delete action onTap
                onPressed: () {
                  // POP context dialog
                  Navigator.of(dialog_context).pop();
                  // Show status SnackBar toast
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar configurations
                    const SnackBar(
                      // Delete message
                      content: Text('Account deletion process initiated.'),
                      // Warning red color background
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                // Style attributes conforming to destructive red colors
                style: ElevatedButton.styleFrom(
                  // Red background color fill
                  backgroundColor: AppColors.error,
                  // Curves radius contours
                  shape: RoundedRectangleBorder(
                    // Rounded curves radius
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                // Centered button title label Text
                child: Text(
                  // Localized delete label key
                  localizations.profile_delete_account,
                  // Text color contrast white
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

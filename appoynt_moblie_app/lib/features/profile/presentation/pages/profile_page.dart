/*
 * File Name: profile_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the Patient Profile View Mode screen showing summaries and medical sections.
 */

// Importing clipboard service for copy-to-clipboard interactions
import 'package:flutter/services.dart';
// Importing dart ui for image filter backdrop blur
import 'dart:ui';
// Importing BLoC library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing routing and localization exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing AuthCubit to manage dynamic logout lifecycle states
import 'package:appoynt_mobile_app/features/auth/presentation/cubit/auth_cubit.dart';
// Importing service locator container reference
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Importing profile Cubit and State declarations
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing sub-pages for navigation routing
import 'package:appoynt_mobile_app/features/profile/presentation/pages/update_profile_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/medical_context_page.dart';
import 'package:appoynt_mobile_app/features/payment/presentation/pages/payment_wallet_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/security_privacy_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/app_settings_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/help_about_page.dart';
// Importing reusable profile avatar widget with upload and fallback capabilities
import 'package:appoynt_mobile_app/features/profile/presentation/widgets/profile_avatar_widget.dart';
// Importing image preview dialog for full-screen zoomable avatar viewing
import 'package:appoynt_mobile_app/features/profile/presentation/widgets/image_preview_dialog.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_small = 10.0;
  static const double border_radius_large = 20.0;
  static const double border_width_thin = 0.5;
  static const double spacing_tiny = 2.0;
  static const double spacing_small = 4.0;
  static const double spacing_large = 8.0;
  static const double icon_container_size = 40.0;
  static const double icon_size_small = 20.0;
  static const double icon_size_tiny = 12.0;
  static const double font_size_subtitle = 16.0;
  static const double shadow_blur = 10.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.05;
}

// Patient profile view mode screen stateful widget
class ProfilePage extends StatefulWidget {
  // Constructor initializing the key
  const ProfilePage({super.key});

  // State builder definition
  @override
  State<ProfilePage> createState() {
    // Return state instance representation
    return _ProfilePageState();
  }
}

// Concrete state tracker implementation class for the ProfilePage
class _ProfilePageState extends State<ProfilePage> {
  // Triggers loading logic upon screen initialization
  @override
  void initState() {
    // Invoke base initState implementation
    super.initState();
    // Use Stale-While-Revalidate: emits cached profile instantly (zero latency),
    // then silently fetches fresh data from the API in the background and
    // re-emits only if the remote data differs from the cached snapshot.
    context.read<ProfileCubit>().load_from_cache_then_refresh();
  }

  // Draw the widget hierarchy
  @override
  Widget build(BuildContext context) {
    // Resolve localizations context parameters
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return BlocProvider<AuthCubit>.value(
      value: get_it<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.login, (route) => false);
          } else {
            // No action needed
          }
        },
        child: BlocListener<ProfileCubit, ProfileState>(
          // Listen for avatar upload result states to show feedback SnackBars
          listenWhen: (previous_state, current_state) {
            // Only trigger listener when avatar upload status changes
            return previous_state.status != current_state.status &&
                (ProfileStatus.avatarUploadError == current_state.status ||
                    ProfileStatus.avatarUploadSuccess == current_state.status);
          },
          listener: (listener_context, upload_state) {
            // Handle avatar upload success feedback notification
            if (ProfileStatus.avatarUploadSuccess == upload_state.status) {
              // Show success SnackBar confirming photo was updated
              ScaffoldMessenger.of(listener_context).showSnackBar(
                SnackBar(
                  // Success message sourced from localized string dictionary
                  content: Text(
                    localizations.profile_photo_upload_success,
                  ),
                  // Green tint background for success state
                  backgroundColor: AppColors.primary_color,
                  // Short duration to minimize screen real estate usage
                  duration: const Duration(seconds: 2),
                  // Rounded pill shape for the SnackBar container
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.space_m),
                  ),
                  // Float above bottom navigation bar
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (ProfileStatus.avatarUploadError == upload_state.status) {
              // Show error SnackBar with the failure message from the cubit
              ScaffoldMessenger.of(listener_context).showSnackBar(
                SnackBar(
                  // Display error from state or a localized generic fallback
                  content: Text(
                    upload_state.error_message ??
                        localizations.profile_photo_upload_error,
                  ),
                  // Error red-orange tint background for failure state
                  backgroundColor: AppColors.redAccent,
                  // Standard duration for error messages
                  duration: const Duration(seconds: 3),
                  // Rounded pill shape for the SnackBar container
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.space_m),
                  ),
                  // Float above bottom navigation bar
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              // No matching upload state — no action needed
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
          // Filter builder state rebuild constraints
          builder: (context, state) {
            // Check if error state is active
            if (ProfileStatus.error == state.status ||
                ProfileStatus.updateError == state.status) {
              // Render error layout option with retry actions
              return Scaffold(
                // Center column alignment
                body: Center(
                  // Column stacking error details
                  child: Column(
                    // Center alignment
                    mainAxisAlignment: MainAxisAlignment.center,
                    // List error details widgets
                    children: [
                      // Error message label
                      Text(
                        // Fallback localizations message
                        localizations.search_offline_error,
                        // Style label text parameters options
                        style: TextStyle(
                          // Text colors
                          color: is_dark
                              ? AppColors.text_dark_primary
                              : AppColors.text_light_primary,
                        ),
                      ),
                      // Separator spacing
                      const SizedBox(
                        // Height value
                        height: AppSpacing.space_m,
                      ),
                      // Retry action button layout
                      ElevatedButton(
                        // Trigger loading sequence again
                        onPressed: () {
                          // Call fetchUserProfile properties
                          context.read<ProfileCubit>().fetchUserProfile();
                        },
                        // Label text
                        child: Text(localizations.search_retry_button),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Render success patient details layout configurations
              return Scaffold(
                // SingleChildScrollView protecting text displays layout boundaries
                body: SingleChildScrollView(
                  // Set column listing sections
                  child: Column(
                    // Children list
                    children: [
                      // Wrap in SafeArea to prevent overlap with status bar
                      SafeArea(
                        // Inner padding
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.space_xl,
                            right: AppSpacing.space_xl,
                            top: AppSpacing.space_xl,
                            bottom: AppSpacing.space_m,
                          ),
                          // Column aligning top row, avatar, name, and email details
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top bar Row placing centered Title only (no back
                              // button on root tab — there is no prior route to
                              // pop to; the tab is managed by BottomNavigationBar)
                              CustomProfileAppBar(
                                title: localizations.profile_title,
                                // Suppress back button on root bottom-nav tab
                                show_back_button: false,
                              ),
                              // Spacing margin gap before photo avatar
                              const SizedBox(height: AppSpacing.space_xl),
                              // SECTION 1: Profile avatar widget — handles network
                              // image, uploading spinner, and initials fallback
                              ProfileAvatarWidget(
                                // Bind the current avatar URL from profile state
                                avatar_url: state.profile.avatar_url,
                                // Pass first name for initials badge fallback
                                first_name: state.profile.first_name,
                                // Pass last name for initials badge fallback
                                last_name: state.profile.last_name,
                                // Derive uploading flag from active avatar status
                                is_uploading: ProfileStatus.avatarUploading ==
                                    state.status,
                                // Hide camera edit badge overlay on main profile page
                                show_camera_badge: false,
                                // Open full-screen zoomable preview modal on avatar tap
                                on_tap: () {
                                  show_image_preview_dialog(
                                    context,
                                    image_url: state.profile.avatar_url,
                                    first_name: state.profile.first_name,
                                    last_name: state.profile.last_name,
                                  );
                                },
                              ),
                              // Spacing margin gap before name
                              const SizedBox(height: AppSpacing.space_m),
                              // Welcoming display patient name label text (16px Bold)
                              if (state.status == ProfileStatus.loading)
                                Container(
                                  width: 150,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: is_dark ? AppColors.grey800 : AppColors.grey300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: AppColors.primary_color,
                                      ),
                                    ),
                                  ),
                                )
                              else if (state is ProfileLoaded)
                                Text(
                                  '${state.user.first_name} ${state.user.last_name}',
                                  style: TextStyle(
                                    fontSize: _LocalDimensions.font_size_subtitle,
                                    fontWeight: FontWeight.bold,
                                    color: is_dark
                                        ? AppColors.white
                                        : AppColors.text_light_primary,
                                  ),
                                )
                              else
                                Text(
                                  '${state.profile.first_name} ${state.profile.last_name}',
                                  style: TextStyle(
                                    fontSize: _LocalDimensions.font_size_subtitle,
                                    fontWeight: FontWeight.bold,
                                    color: is_dark
                                        ? AppColors.white
                                        : AppColors.text_light_primary,
                                  ),
                                ),
                              // Spacing offset between name and PID badge
                              const SizedBox(height: AppSpacing.space_s),
                              // Resolve patient ID from remote model or fallback placeholder
                              Builder(
                                builder: (badge_context) {
                                  // Resolve patient ID string from loaded state or fallback
                                  final String patient_id = (state is ProfileLoaded)
                                      ? (state.user.patient_id ?? state.user.id)
                                      : state.profile.national_id.isNotEmpty
                                          ? state.profile.national_id
                                          : '100234';
                                  // Return compact PID badge container with copy action
                                  return Container(
                                    // Symmetric padding around badge content
                                    padding: const EdgeInsets.symmetric(
                                      // Horizontal padding token
                                      horizontal: _LocalDimensions.spacing_large,
                                      // Vertical padding token
                                      vertical: _LocalDimensions.spacing_small,
                                    ),
                                    // Box decoration applying brand blue tint with rounded pill shape
                                    decoration: BoxDecoration(
                                      // Light brand blue background tint
                                      color: AppColors.primary_color
                                          .withValues(alpha: 0.08),
                                      // Pill-shaped border radius
                                      borderRadius: BorderRadius.circular(
                                        _LocalDimensions.border_radius_large,
                                      ),
                                      // Thin brand blue border outline
                                      border: Border.all(
                                        color: AppColors.primary_color
                                            .withValues(alpha: 0.25),
                                        width: _LocalDimensions.border_width_thin,
                                      ),
                                    ),
                                    // Row laying out PID label and copy icon
                                    child: Row(
                                      // Shrink row to its children's widths
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // PID label text widget
                                        Text(
                                          // Formatted patient ID display string
                                          'PID: #$patient_id',
                                          // Text style using design token sizes
                                          style: const TextStyle(
                                            // Bold weight to emphasize ID
                                            fontWeight: FontWeight.bold,
                                            // Brand primary blue color
                                            color: AppColors.primary_color,
                                            // Body small font size token
                                            fontSize:
                                                AppSpacing.font_size_body_small,
                                          ),
                                        ),
                                        // Horizontal gap between label and icon
                                        const SizedBox(
                                          width: _LocalDimensions.spacing_large,
                                        ),
                                        // Copy-to-clipboard action icon
                                        InkWell(
                                          // Unique semantic identifier for testing
                                          key: const Key('pid_copy_button'),
                                          // Clip to circle for clean ripple bounds
                                          borderRadius: BorderRadius.circular(
                                            _LocalDimensions.border_radius_small,
                                          ),
                                          // Trigger clipboard write and snackbar feedback
                                          onTap: () {
                                            // Write patient ID string to clipboard
                                            Clipboard.setData(
                                              ClipboardData(text: patient_id),
                                            );
                                            // Show confirmation snackbar overlay
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              // Snackbar configuration
                                              const SnackBar(
                                                // Success message content
                                                content: Text(
                                                  'Patient ID copied to clipboard!',
                                                ),
                                                // Auto-dismiss duration
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          // Copy icon visual indicator
                                          child: const Icon(
                                            Icons.copy_rounded,
                                            // Icon size token
                                            size: _LocalDimensions.icon_size_tiny,
                                            // Brand blue color
                                            color: AppColors.primary_color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Spacing offset spacer before stats
                              const SizedBox(height: AppSpacing.space_m),
                              // Row layout presenting Height and Weight summary markers in capsule chips
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Height capsule pill container
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.space_l,
                                      vertical: AppSpacing.space_s,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary_color
                                          .withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(
                                          _LocalDimensions.border_radius_large),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.straighten_rounded,
                                          color: AppColors.primary_color,
                                          size: AppSpacing.icon_size_s,
                                        ),
                                        const SizedBox(
                                            width: AppSpacing.space_xs),
                                        Text(
                                          '${state.profile.height.isEmpty ? '--' : state.profile.height} CM',
                                          style: TextStyle(
                                            color: is_dark
                                                ? AppColors.white
                                                : AppColors.primary_color,
                                            fontSize:
                                                AppSpacing.font_size_body_small,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Horizontal gap between pills
                                  const SizedBox(width: AppSpacing.space_m),
                                  // Weight capsule pill container
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.space_l,
                                      vertical: AppSpacing.space_s,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary_color
                                          .withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(
                                          _LocalDimensions.border_radius_large),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.monitor_weight_outlined,
                                          color: AppColors.primary_color,
                                          size: AppSpacing.icon_size_s,
                                        ),
                                        const SizedBox(
                                            width: AppSpacing.space_xs),
                                        Text(
                                          '${state.profile.weight.isEmpty ? '--' : state.profile.weight} KG',
                                          style: TextStyle(
                                            color: is_dark
                                                ? AppColors.white
                                                : AppColors.primary_color,
                                            fontSize:
                                                AppSpacing.font_size_body_small,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Horizontal gap between pills
                                  const SizedBox(width: AppSpacing.space_s),
                                  // Blood Group capsule pill container
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.space_l,
                                      vertical: AppSpacing.space_s,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary_color
                                          .withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(
                                          _LocalDimensions.border_radius_large),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.bloodtype_outlined,
                                          color: AppColors.primary_color,
                                          size: AppSpacing.icon_size_s,
                                        ),
                                        const SizedBox(
                                            width: AppSpacing.space_xs),
                                        Text(
                                          state.profile.blood_group.isEmpty
                                              ? '--'
                                              : state.profile.blood_group,
                                          style: TextStyle(
                                            color: is_dark
                                                ? AppColors.white
                                                : AppColors.primary_color,
                                            fontSize:
                                                AppSpacing.font_size_body_small,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Spacing offset below header card
                      const SizedBox(height: AppSpacing.space_m),

                      // Settings dashboard options unified container card listing 5 sub-page navigators
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.space_m,
                          vertical: AppSpacing.space_xs,
                        ),
                        decoration: BoxDecoration(
                          color: is_dark
                              ? AppColors.surface_dark
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(
                              _LocalDimensions.border_radius_default),
                          boxShadow: [
                            BoxShadow(
                              color: is_dark
                                  ? AppColors.black.withValues(
                                      alpha:
                                          _LocalDimensions.shadow_opacity_dark)
                                  : AppColors.black.withValues(
                                      alpha: _LocalDimensions
                                          .shadow_opacity_light),
                              blurRadius: _LocalDimensions.shadow_blur,
                              offset: const Offset(0.0, 4.0),
                            ),
                          ],
                          border: Border.all(
                            color: is_dark
                                ? AppColors.border_dark
                                : AppColors.slate_200,
                            width: AppSpacing.border_width_thin,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Option 1: Personal Information
                            _ProfileOptionCard(
                              title: localizations.profile_personal_information,
                              subtitle: localizations
                                  .profile_personal_information_subtitle,
                              icon: Icons.person_outline_rounded,
                              on_press: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (route_context) =>
                                        BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: const UpdateProfilePage(),
                                    ),
                                  ),
                                );
                                if (context.mounted) {
                                  context.read<ProfileCubit>().fetchUserProfile();
                                } else {
                                  // Context unmounted
                                }
                              },
                            ),
                            const Divider(
                                height: 1.0,
                                thickness: _LocalDimensions.border_width_thin,
                                indent: 64.0),
                            // Option 2: Medical History
                            _ProfileOptionCard(
                              title: localizations.profile_medical_history,
                              subtitle:
                                  'Allergies, prescriptions, tests & plans',
                              icon: Icons.medical_services_outlined,
                              on_press: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (route_context) =>
                                        BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: const MedicalContextPage(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                                height: 1.0,
                                thickness: _LocalDimensions.border_width_thin,
                                indent: 64.0),
                            // Option 3: Payment & Wallet
                            _ProfileOptionCard(
                              title: localizations.profile_payment_wallet,
                              subtitle:
                                  'Wallet balance, saved cards & invoices',
                              icon: Icons.wallet_outlined,
                              on_press: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (route_context) =>
                                        BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: const PaymentWalletPage(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                                height: 1.0,
                                thickness: _LocalDimensions.border_width_thin,
                                indent: 64.0),
                            // Option 4: Security & Privacy
                            _ProfileOptionCard(
                              title: localizations.profile_security_privacy,
                              subtitle: 'Biometrics, passkey & delete account',
                              icon: Icons.security_outlined,
                              on_press: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (route_context) =>
                                        BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: const SecurityPrivacyPage(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                                height: 1.0,
                                thickness: _LocalDimensions.border_width_thin,
                                indent: 64.0),
                            // Option 5: App Settings
                            _ProfileOptionCard(
                              title: localizations.profile_app_settings,
                              subtitle: localizations.profile_app_settings_sub,
                              icon: Icons.settings_outlined,
                              on_press: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (route_context) =>
                                        BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: const AppSettingsPage(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                                height: 1.0,
                                thickness: _LocalDimensions.border_width_thin,
                                indent: 64.0),
                            // Option 6: Help & About App
                            _ProfileOptionCard(
                              title: localizations.profile_help_about,
                              subtitle: localizations.profile_help_about_sub,
                              icon: Icons.info_outline_rounded,
                              on_press: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (route_context) =>
                                        BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: const HelpAndAboutPage(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Spacing block gap providing explicit vertical breathing room (16px spacing)
                      const SizedBox(height: AppSpacing.space_xl),

                      // SECTION 6: Log Out Action (Standalone Card)
                      _build_logout_card(context, localizations, is_dark),

                      // Spacing bottom padding margin box
                      const SizedBox(
                        // Spacing offset
                        height: AppSpacing.space_xxl,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    ),
  );
  }

  // Helper builder rendering Standalone Logout Card widget
  Widget _build_logout_card(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Return standalone interactive card container
    return Container(
      // Outer margin padding
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space_m),
      // Double infinity width
      width: double.infinity,
      // Card background decoration
      decoration: BoxDecoration(
        // Dynamic surface color
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        // Rounded corner radius bounds (16.0px)
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        // Ambient soft shadow
        boxShadow: [
          BoxShadow(
            // Shadow colors
            color: is_dark
                ? AppColors.black
                    .withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                : AppColors.black
                    .withValues(alpha: _LocalDimensions.shadow_opacity_light),
            // Blur radius
            blurRadius: _LocalDimensions.shadow_blur,
            // Spread offset
            offset: const Offset(0.0, 4.0),
          ),
        ],
        // Thin border line
        border: Border.all(
          // Border color adaptions
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          // Thin width
          width: AppSpacing.border_width_thin,
        ),
      ),
      // InkWell ripple gesture container
      child: InkWell(
        // Rounded corners radius
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        // Trigger glassmorphic confirmation dialog workflow on tap
        onTap: () {
          // Invoke helper method to display confirmation dialog
          _show_logout_confirmation_dialog(context, localizations, is_dark);
        },
        // Padding inside card
        child: Padding(
          // Padding bounds
          padding: const EdgeInsets.all(AppSpacing.space_l),
          // Row placing leading soft red icon container, titles column, and chevron
          child: Row(
            // Align vertical center
            crossAxisAlignment: CrossAxisAlignment.center,
            // children list
            children: [
              // Circular soft low-saturated red tinted background icon container
              Container(
                // Width 40px
                width: _LocalDimensions.icon_container_size,
                // Height 40px
                height: _LocalDimensions.icon_container_size,
                // Styling
                decoration: BoxDecoration(
                  // Soft red tinted background fill
                  color: AppColors.error.withValues(alpha: 0.1),
                  // Shape circle
                  shape: BoxShape.circle,
                ),
                // Exit / Logout vector icon graphic
                child: const Icon(
                  // Door exit symbol
                  Icons.logout_rounded,
                  // Low-saturated destructive red color
                  color: AppColors.error,
                  // Icon size
                  size: _LocalDimensions.icon_size_small,
                ),
              ),
              // Horizontal gap spacer (12px)
              const SizedBox(width: AppSpacing.space_l),
              // Typography column taking remaining space
              Expanded(
                // Column stack
                child: Column(
                  // Align left coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list
                  children: [
                    // Main Log Out title text widget
                    Text(
                      // Localized Log Out label
                      localizations.profile_logout_confirm_yes,
                      // Typography options
                      style: const TextStyle(
                        // Body font size 14px
                        fontSize: AppSpacing.font_size_body_medium,
                        // Extra bold font weight
                        fontWeight: FontWeight.w800,
                        // Low-saturated destructive red color
                        color: AppColors.error,
                      ),
                    ),
                    // Spacing gap (2px)
                    const SizedBox(height: _LocalDimensions.spacing_tiny),
                    // Micro Subtitle detail text widget
                    Text(
                      // Localized subtitle description
                      localizations.profile_logout_sub,
                      // Typography options
                      style: TextStyle(
                        // Micro font size 12px
                        fontSize: AppSpacing.font_size_body_small,
                        // Height ratio 1.3
                        height: 1.3,
                        // Muted color adaptions
                        color: is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Horizontal gap spacer
              const SizedBox(width: AppSpacing.space_s),
              // Subtle right-arrow chevron indicator graphic
              const Icon(
                // Chevron right icon
                Icons.chevron_right_rounded,
                // Subdued color matching micro text summaries
                color: AppColors.text_light_secondary,
                // Icon size
                size: AppSpacing.icon_size_m,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method displaying glassmorphic Material Design 3 Modal Dialog
  void _show_logout_confirmation_dialog(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Trigger dialog modal popup
    showDialog(
      // Bind context
      context: context,
      // Dialog builder callback
      builder: (dialog_context) {
        // Wrap layout in BackdropFilter for glassmorphism backdrop blur
        return BackdropFilter(
          // Backdrop filter blur parameters (sigma 5.0)
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          // Return AlertDialog widget
          child: AlertDialog(
            // Rounded corners radius (16.0px)
            shape: RoundedRectangleBorder(
              // Radius 16.0
              borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
            ),
            // Background surface color mapping light/dark modes
            backgroundColor: is_dark ? AppColors.surface_dark : AppColors.white,
            // Title Text widget
            title: Text(
              // Localized dialog title
              localizations.profile_logout_confirm_title,
              // Typography options
              style: TextStyle(
                // Font size 18px
                fontSize: 18.0,
                // Extra bold weight
                fontWeight: FontWeight.w800,
                // Colors
                color: is_dark ? AppColors.white : AppColors.text_light_primary,
              ),
            ),
            // Content Body Description Text widget
            content: Text(
              // Localized dialog content body message
              localizations.profile_logout_confirm_message,
              // Typography options
              style: TextStyle(
                // Body font size 14px
                fontSize: AppSpacing.font_size_body_medium,
                // Line height ratio 1.4
                height: 1.4,
                // Muted text colors
                color: is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary,
              ),
            ),
            // Actions padding offsets
            actionsPadding: const EdgeInsets.all(AppSpacing.space_l),
            // Actions bottom row widget array
            actions: [
              // Row placing Cancel and Log Out action buttons
              Row(
                // children list
                children: [
                  // Cancel Button expanded
                  Expanded(
                    // Outlined button
                    child: OutlinedButton(
                      // Dismiss modal on tap
                      onPressed: () => Navigator.of(dialog_context).pop(),
                      // Styling
                      style: OutlinedButton.styleFrom(
                        // Border color adaptions
                        side: BorderSide(
                          // Muted border lines
                          color: is_dark
                              ? AppColors.border_dark
                              : AppColors.border_light,
                        ),
                        // Rounded corners radius
                        shape: RoundedRectangleBorder(
                          // Radius 12px
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radius_l,
                          ),
                        ),
                      ),
                      // Button label text
                      child: Text(
                        // Localized cancel label
                        localizations.profile_logout_confirm_no,
                        // Typography
                        style: TextStyle(
                          // Bold weight
                          fontWeight: FontWeight.bold,
                          // Dynamic colors
                          color: is_dark
                              ? AppColors.white70
                              : AppColors.text_light_primary,
                        ),
                      ),
                    ),
                  ),
                  // Horizontal gap spacer
                  const SizedBox(width: AppSpacing.space_l),
                  // Log Out Primary Red Button expanded
                  Expanded(
                    // Elevated button
                    child: ElevatedButton(
                      // Execute account termination and route replacement on tap
                      onPressed: () async {
                        // Dismiss modal dialog first
                        Navigator.of(dialog_context).pop();
                        // Trigger AuthCubit logout sequence
                        await context.read<AuthCubit>().logout();
                        // Immediate direct navigation fallback
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.login,
                            (route) => false,
                          );
                        } else {
                          // Context unmounted
                        }
                      },
                      // Styling
                      style: ElevatedButton.styleFrom(
                        // High-contrast solid red background
                        backgroundColor: AppColors.error,
                        // White foreground text
                        foregroundColor: AppColors.white,
                        // Zero elevation shadow
                        elevation: 0,
                        // Rounded corners radius
                        shape: RoundedRectangleBorder(
                          // Radius 12px
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radius_l,
                          ),
                        ),
                      ),
                      // Button label text
                      child: Text(
                        // Localized log out label
                        localizations.profile_logout_confirm_yes,
                        // Typography
                        style: const TextStyle(
                          // Bold weight
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Clickable option card item component displaying icon, titles, and chevrons
class _ProfileOptionCard extends StatelessWidget {
  // Option title text string
  final String title;
  // Option description detail subtitle string
  final String subtitle;
  // Section icon representation
  final IconData icon;
  // Tap callback handler
  final VoidCallback on_press;

  // Constructor matching properties
  const _ProfileOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.on_press,
  });

  // Draw card widget structure details
  @override
  Widget build(BuildContext context) {
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return InkWell catching tap feedback ripple effects
    return InkWell(
      // Bind callback
      onTap: on_press,
      // Padding offsets inside settings row
      child: Padding(
        padding: const EdgeInsets.symmetric(
          // Horizontal bounds padding
          horizontal: AppSpacing.space_m,
          // Vertical bounds padding
          vertical: AppSpacing.space_m,
        ),
        // Horizontal row placing icon, details column, and arrow chevron
        child: Row(
          // Row children
          children: [
            // Soft rounded container housing category icon
            Container(
              // Badge width
              width: _LocalDimensions.icon_container_size,
              // Badge height
              height: _LocalDimensions.icon_container_size,
              // Layout style configurations
              decoration: BoxDecoration(
                // Pastel primary brand shade background
                color: AppColors.primary_color.withValues(alpha: 0.08),
                // Soft rounded square corner layout
                borderRadius:
                    BorderRadius.circular(_LocalDimensions.border_radius_small),
              ),
              // Icon graphic centered inside container
              child: Icon(
                // Bind icon
                icon,
                // Primary brand color
                color: AppColors.primary_color,
                // Icon size constraint
                size: AppSpacing.icon_size_m,
              ),
            ),
            // Horizontal spacer gap
            const SizedBox(
              // Spacer width offset
              width: AppSpacing.space_m,
            ),
            // Details text fields column taking remaining width space
            Expanded(
              // Column stack grouping titles vertically
              child: Column(
                // Align text labels to start coordinates
                crossAxisAlignment: CrossAxisAlignment.start,
                // children array
                children: [
                  // Section option main title text label display
                  Text(
                    // Bind title
                    title,
                    // Style typographic settings
                    style: TextStyle(
                      // Medium body size
                      fontSize: AppSpacing.font_size_body_medium,
                      // Bold weight indicator
                      fontWeight: FontWeight.w700,
                      // Dynamic text color adjusting to dark/light surfaces
                      color: is_dark
                          ? AppColors.text_dark_primary
                          : AppColors.text_light_primary,
                    ),
                  ),
                  // Spacing offset partition
                  const SizedBox(
                    // Gap height value
                    height: AppSpacing.space_xs,
                  ),
                  // Option description subtitle label text
                  Text(
                    // Bind subtitle
                    subtitle,
                    // Subdued typography specs
                    style: const TextStyle(
                      // Small body size font
                      fontSize: AppSpacing.font_size_body_small,
                      // Secondary color styling
                      color: AppColors.text_light_secondary,
                    ),
                  ),
                ],
              ),
            ),
            // Spacing partition gap
            const SizedBox(
              // Separator width value
              width: AppSpacing.space_s,
            ),
            // Interactive directional navigation chevron indicator icon
            const Icon(
              // Arrow chevron token pointing right coordinates
              Icons.chevron_right_rounded,
              // Subdued color matching summaries
              color: AppColors.text_light_secondary,
              // Icon standard size
              size: AppSpacing.icon_size_m,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter class to draw a dashed circle outline border
class DashCirclePainter extends CustomPainter {
  // Border color configuration
  final Color color;

  // Constructor mapping the properties
  const DashCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Create line style Paint configurations
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Define dashboard dimensions parameters
    final double radius = size.width / 2;
    // Circle origin coordinates
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Number of dashes to draw
    const int dash_count = 12;
    // Circular arc angle per dash
    const double dash_angle = (2 * 3.1415926535) / dash_count;

    // Loop drawing dashes
    for (int i = 0; i < dash_count; i++) {
      // Calculate start angle coordinates
      final double start_angle = i * dash_angle;
      // Calculate sweep angle coordinates
      const double sweep_angle = dash_angle * 0.6;
      // Draw dashboard arc outline segment
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start_angle,
        sweep_angle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always return false as layout shape is static
    return false;
  }
}

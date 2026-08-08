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
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Defines the Patient Profile View Mode screen showing summaries and medical sections.
 */

// Importing standard I/O for File operations
import 'dart:io';
// Importing dart ui for image filter backdrop blur
import 'dart:ui';
// Importing BLoC library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing routing and localization exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing profile Cubit and State declarations
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing sub-pages for navigation routing
import 'package:appoynt_mobile_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/medical_context_page.dart';
import 'package:appoynt_mobile_app/features/payment/presentation/pages/payment_wallet_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/security_privacy_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/app_preferences_page.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_medium = 12.0;
  static const double border_radius_small = 10.0;
  static const double border_radius_large = 20.0;
  static const double border_radius_avatar = 50.0;
  static const double border_width_thin = 0.5;
  static const double spacing_tiny = 2.0;
  static const double spacing_small = 4.0;
  static const double spacing_large = 8.0;
  static const double avatar_size = 100.0;
  static const double icon_container_size = 40.0;
  static const double icon_size_large = 48.0;
  static const double icon_size_small = 20.0;
  static const double icon_size_tiny = 12.0;
  static const double font_size_subtitle = 16.0;
  static const double font_size_tiny = 11.0;
  static const double shadow_blur = 10.0;
  static const double shadow_blur_large = 12.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.05;
  static const double shadow_opacity_light_alt = 0.08;
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
    // Resolve cubit block to trigger load profile properties
    context.read<ProfileCubit>().load_profile();
  }

  // Draw the widget hierarchy
  @override
  Widget build(BuildContext context) {
    // Resolve localizations context parameters
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return BlocBuilder<ProfileCubit, ProfileState>(
      // Filter builder state rebuild constraints
      builder: (context, state) {
        // Check if loading state is active using Yoda comparisons
        if (ProfileStatus.loading == state.status) {
          // Render centered loading activity indicator
          return const Scaffold(
            // Center indicator body
            body: Center(
              // Themed circular progress indicator
              child: CircularProgressIndicator(
                // Color primary branding
                color: AppColors.primary_color,
              ),
            ),
          );
        } else if (ProfileStatus.error == state.status) {
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
                      // Call load_profile properties
                      context.read<ProfileCubit>().load_profile();
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
                          // SECTION 1: Personal Info - Premium circular avatar photo frame matching layout specs
                          GestureDetector(
                            // Tap handler calling interactive preview dialog modal
                            onTap: () {
                              // Invoke avatar preview dialog modal
                              _show_avatar_preview_dialog(
                                context,
                                state.profile.avatar_url,
                              );
                            },
                            // Clean isolated circular avatar image container layout
                            child: Container(
                              // Fixed width
                              width: _LocalDimensions.avatar_size,
                              // Fixed height
                              height: _LocalDimensions.avatar_size,
                              // Container decoration parameters
                              decoration: BoxDecoration(
                                // Circular shape
                                shape: BoxShape.circle,
                                // Ambient soft shadows
                                boxShadow: [
                                  BoxShadow(
                                    // Shadow colors adapting to dark mode
                                    color: is_dark
                                        ? AppColors.black45
                                        : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light_alt),
                                    // Blur spread radius
                                    blurRadius: _LocalDimensions.shadow_blur_large,
                                    // Offset position coordinates
                                    offset: const Offset(0.0, 4.0),
                                  ),
                                ],
                              ),
                              // Clip image inside circular bounds
                              child: ClipRRect(
                                // Corner radius matching half dimensions
                                borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_avatar),
                                // Render network image or fallback icon
                                child: state.profile.avatar_url.isNotEmpty
                                    ? (true == state.profile.avatar_url.startsWith('http')
                                        ? Image.network(
                                            state.profile.avatar_url,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(state.profile.avatar_url),
                                            fit: BoxFit.cover,
                                          ))
                                    : Container(
                                        // Surface fallback fill
                                        color: AppColors.primary_color
                                            .withValues(alpha: 0.1),
                                        // Fallback icon widget
                                        child: const Icon(
                                          Icons.person_rounded,
                                          color: AppColors.primary_color,
                                          size: _LocalDimensions.icon_size_large,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          // Spacing margin gap before name
                          const SizedBox(height: AppSpacing.space_m),
                          // Welcoming display patient name label text (16px Bold)
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
                          // Spacing offset
                          const SizedBox(height: AppSpacing.space_s),
                          // Verified badges row (Email & Phone)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Email verified badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: _LocalDimensions.spacing_large, vertical: _LocalDimensions.spacing_small),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
                                  border: Border.all(
                                    color: AppColors.success.withValues(alpha: 0.2),
                                    width: _LocalDimensions.border_width_thin,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.success,
                                      size: _LocalDimensions.icon_size_tiny,
                                    ),
                                    const SizedBox(width: _LocalDimensions.spacing_small),
                                    Text(
                                      state.profile.email,
                                      style: const TextStyle(
                                        fontSize: _LocalDimensions.font_size_tiny,
                                        color: AppColors.text_light_secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Separator spacing
                              const SizedBox(width: AppSpacing.space_s),
                              // Phone verified badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: _LocalDimensions.spacing_large, vertical: _LocalDimensions.spacing_small),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
                                  border: Border.all(
                                    color: AppColors.success.withValues(alpha: 0.2),
                                    width: _LocalDimensions.border_width_thin,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.success,
                                      size: _LocalDimensions.icon_size_tiny,
                                    ),
                                    const SizedBox(width: _LocalDimensions.spacing_small),
                                    Text(
                                      state.profile.phone,
                                      style: const TextStyle(
                                        fontSize: _LocalDimensions.font_size_tiny,
                                        color: AppColors.text_light_secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_large),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.straighten_rounded,
                                      color: AppColors.primary_color,
                                      size: AppSpacing.icon_size_s,
                                    ),
                                    const SizedBox(width: AppSpacing.space_xs),
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
                                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_large),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.monitor_weight_outlined,
                                      color: AppColors.primary_color,
                                      size: AppSpacing.icon_size_s,
                                    ),
                                    const SizedBox(width: AppSpacing.space_xs),
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
                      borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                      boxShadow: [
                        BoxShadow(
                          color: is_dark
                              ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                              : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
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
                          on_press: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (route_context) => BlocProvider.value(
                                  value: context.read<ProfileCubit>(),
                                  child: const EditProfilePage(),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                            height: 1.0, thickness: _LocalDimensions.border_width_thin, indent: 64.0),
                        // Option 2: Medical History
                        _ProfileOptionCard(
                          title: localizations.profile_medical_history,
                          subtitle: 'Allergies, prescriptions, tests & plans',
                          icon: Icons.medical_services_outlined,
                          on_press: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (route_context) => BlocProvider.value(
                                  value: context.read<ProfileCubit>(),
                                  child: const MedicalContextPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                            height: 1.0, thickness: _LocalDimensions.border_width_thin, indent: 64.0),
                        // Option 3: Payment & Wallet
                        _ProfileOptionCard(
                          title: localizations.profile_payment_wallet,
                          subtitle: 'Wallet balance, saved cards & invoices',
                          icon: Icons.wallet_outlined,
                          on_press: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (route_context) => BlocProvider.value(
                                  value: context.read<ProfileCubit>(),
                                  child: const PaymentWalletPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                            height: 1.0, thickness: _LocalDimensions.border_width_thin, indent: 64.0),
                        // Option 4: Security & Privacy
                        _ProfileOptionCard(
                          title: localizations.profile_security_privacy,
                          subtitle: 'Biometrics, passkey & delete account',
                          icon: Icons.security_outlined,
                          on_press: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (route_context) => BlocProvider.value(
                                  value: context.read<ProfileCubit>(),
                                  child: const SecurityPrivacyPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider(
                            height: 1.0, thickness: _LocalDimensions.border_width_thin, indent: 64.0),
                        // Option 5: App Preferences
                        _ProfileOptionCard(
                          title: localizations.profile_app_preferences,
                          subtitle: 'Notifications, language & app themes',
                          icon: Icons.settings_outlined,
                          on_press: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (route_context) => BlocProvider.value(
                                  value: context.read<ProfileCubit>(),
                                  child: const AppPreferencesPage(),
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
                ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
            // Blur radius
            blurRadius: _LocalDimensions.shadow_blur,
            // Spread offset
            offset: const Offset(0.0, 4.0),
          ),
        ],
        // Thin border line
        border: Border.all(
          // Border color adaptions
          color:
              is_dark ? AppColors.border_dark : AppColors.slate_200,
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
            backgroundColor:
                is_dark ? AppColors.surface_dark : AppColors.white,
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
                color: is_dark
                    ? AppColors.white
                    : AppColors.text_light_primary,
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
                      onPressed: () {
                        // Dismiss modal dialog first
                        Navigator.of(dialog_context).pop();
                        // Clear navigation stack and redirect to sign-in screen
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
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

  // Helper method displaying blurred full-screen avatar preview modal with action CTA
  void _show_avatar_preview_dialog(BuildContext context, String avatar_url) {
    // Resolve localized strings
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Show dialog popup modal
    showDialog(
      // Bind context
      context: context,
      // Barrier dismissible by tapping outside
      barrierDismissible: true,
      // Dialog builder constructor
      builder: (dialog_context) {
        // BackdropFilter supplying background blur
        return BackdropFilter(
          // Blur filter parameters
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          // Dialog wrapper container
          child: Dialog(
            // Transparent surface fill
            backgroundColor: AppColors.transparent,
            // Zero elevation shadow
            elevation: 0.0,
            // Inner content padding
            child: Column(
              // Minimize vertical size
              mainAxisSize: MainAxisSize.min,
              // Center cross axis items
              crossAxisAlignment: CrossAxisAlignment.center,
              // Children details list
              children: [
                // Top header row placing close (X) button
                Align(
                  // Align right coordinates
                  alignment: Alignment.centerRight,
                  // Close gesture detector button
                  child: IconButton(
                    // Icon configuration
                    icon: Container(
                      // Inner padding
                      padding: const EdgeInsets.all(6.0),
                      // Shape decoration
                      decoration: BoxDecoration(
                        // Dark transparent fill
                        color: AppColors.black.withValues(alpha: 0.4),
                        // Circular shape
                        shape: BoxShape.circle,
                      ),
                      // Close icon symbol
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                        size: 20.0,
                      ),
                    ),
                    // Tap handler popping modal
                    onPressed: () {
                      // Pop modal dialog
                      Navigator.of(dialog_context).pop();
                    },
                  ),
                ),
                // Spacing gap
                const SizedBox(height: 12.0),
                // Circular high-resolution avatar preview container (240px x 240px)
                Container(
                  // Fixed width
                  width: 240.0,
                  // Fixed height
                  height: 240.0,
                  // Layout shape decoration
                  decoration: BoxDecoration(
                    // Circular border shape
                    shape: BoxShape.circle,
                    // Outer border ring line
                    border: Border.all(
                      // White border ring
                      color: AppColors.white.withValues(alpha: 0.8),
                      // Border thickness
                      width: 3.0,
                    ),
                    // Soft floating shadow
                    boxShadow: const [
                      BoxShadow(
                        // Color
                        color: AppColors.black38,
                        // Blur
                        blurRadius: 20.0,
                        // Offset
                        offset: Offset(0.0, 8.0),
                      ),
                    ],
                  ),
                  // Clip image in circular mask
                  child: ClipRRect(
                    // Rounded corner radius matching half dimensions
                    borderRadius: BorderRadius.circular(120.0),
                    // Render image network or fallback icon
                    child: avatar_url.isNotEmpty
                        ? (true == avatar_url.startsWith('http')
                            ? Image.network(
                                avatar_url,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(avatar_url),
                                fit: BoxFit.cover,
                              ))
                        : Container(
                            // Surface fallback fill
                            color:
                                AppColors.primary_color.withValues(alpha: 0.15),
                            // Fallback icon
                            child: const Icon(
                              Icons.person_rounded,
                              color: AppColors.primary_color,
                              size: 110.0,
                            ),
                          ),
                  ),
                ),
                // Spacing gap
                const SizedBox(height: 24.0),
                // Secondary "Change Photo" action CTA button
                GestureDetector(
                  // Tap handler: dismiss dialog and navigate to profile editor
                  onTap: () {
                    // Close pop-up dialog modal
                    Navigator.of(dialog_context).pop();
                    // Navigate to EditProfilePage layout
                    Navigator.of(context).push(
                      // Route constructor
                      MaterialPageRoute(
                        // Builder constructor wrapping Cubit provider
                        builder: (route_context) => BlocProvider.value(
                          // Carry existing ProfileCubit block context forward
                          value: context.read<ProfileCubit>(),
                          // Edit profile page widget
                          child: const EditProfilePage(),
                        ),
                      ),
                    );
                  },
                  // Action chip container decoration
                  child: Container(
                    // Inner padding
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    // Decoration layout options
                    decoration: BoxDecoration(
                      // Primary brand blue fill
                      color: AppColors.primary_color,
                      // Rounded pill corners radius
                      borderRadius: BorderRadius.circular(24.0),
                      // Subtle drop shadow
                      boxShadow: [
                        BoxShadow(
                          // Shadow color fill
                          color:
                              AppColors.primary_color.withValues(alpha: 0.35),
                          // Blur radius
                          blurRadius: 10.0,
                          // Offset position coordinates
                          offset: const Offset(0.0, 4.0),
                        ),
                      ],
                    ),
                    // Action button row icon + text
                    child: Row(
                      // Wrap to contents
                      mainAxisSize: MainAxisSize.min,
                      // Children list
                      children: [
                        // Camera upload icon graphic
                        const Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.white,
                          size: 18.0,
                        ),
                        // Spacer gap
                        const SizedBox(width: 8.0),
                        // Localized "Change Photo" text label
                        Text(
                          // Localized string key
                          localizations.profile_change_photo,
                          // Typography properties
                          style: const TextStyle(
                            // White text
                            color: AppColors.white,
                            // Body font size
                            fontSize: 14.0,
                            // Bold weight
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_small),
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

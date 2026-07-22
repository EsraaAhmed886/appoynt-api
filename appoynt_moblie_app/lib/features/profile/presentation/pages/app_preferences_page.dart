/*
 * File Name: app_preferences_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Re-architected modular floating cards layout for App Preferences
 *   screen displaying granular notification switches, language toggle, theme
 *   segmented control, and support/legal hub.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing flutter bloc for state handling
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing profile cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing profile state definition
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing main to access global theme mode notifier
import 'package:appoynt_mobile_app/main.dart';

// Stateful widget displaying Preferences modular layout
class AppPreferencesPage extends StatefulWidget {
  // Constructor mapping key
  const AppPreferencesPage({super.key});

  @override
  // Create state tracker instance
  State<AppPreferencesPage> createState() {
    // Return state class instance
    return _AppPreferencesPageState();
  }
}

// State class managing switches and floating cards layouts
class _AppPreferencesPageState extends State<AppPreferencesPage> {
  // Granular notification: appointment reminders toggle state
  bool _notif_reminders = true;
  // Granular notification: invoices and statements toggle state
  bool _notif_invoices = true;
  // Granular notification: promotions and offers toggle state
  bool _notif_promos = false;

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
          // Outer padding margins following 8pt grid with 16px lateral margins
          child: Padding(
            // Margins boundaries
            padding: const EdgeInsets.symmetric(
              // Horizontal offset 16px
              horizontal: AppSpacing.space_xl,
              // Vertical offset 16px
              vertical: AppSpacing.space_xl,
            ),
            // Column stack grouping layout widgets
            child: BlocBuilder<ProfileCubit, ProfileState>(
              // Builder callback
              builder: (bloc_context, state) {
                // Column stacking header and modular floating cards
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
                            // pop navigation context
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
                          localizations.profile_app_preferences,
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
                    // Vertical breathing space (16px)
                    const SizedBox(height: AppSpacing.space_xl),

                    // CARD A: Granular Notification Settings floating card
                    _build_notification_card(context, localizations, is_dark),
                    // Vertical breathing space between floating cards (16px)
                    const SizedBox(height: AppSpacing.space_xl),

                    // CARD B: Language Selection Settings floating card
                    _build_language_card(context, localizations, is_dark),
                    // Vertical breathing space between floating cards (16px)
                    const SizedBox(height: AppSpacing.space_xl),

                    // CARD C: Display Theme Management floating card
                    _build_theme_card(context, localizations, is_dark),
                    // Vertical breathing space between floating cards (16px)
                    const SizedBox(height: AppSpacing.space_xl),

                    // CARD D: Support & Legal Hub floating card
                    _build_support_legal_card(context, localizations, is_dark),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // CARD A: Helper rendering Granular Notification Settings floating card
  Widget _build_notification_card(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Return floating card container
    return Container(
      // Card background border decoration
      decoration: BoxDecoration(
        // Dynamic surface color
        color: true == is_dark ? AppColors.surface_dark : Colors.white,
        // Rounded borders radius bounds (16.0px)
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        // Soft ambient shadow
        boxShadow: [
          BoxShadow(
            // Shadow color adaptions
            color: true == is_dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            // Blur spread
            blurRadius: 10.0,
            // Offset
            offset: const Offset(0.0, 4.0),
          ),
        ],
        // Thin border line
        border: Border.all(
          // Color mapping adaptive theme mode
          color:
              true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          // Thin thickness
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Padding internal layout bounds
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      // Column layout stacking header and switch items
      child: Column(
        // Align left coordinates
        crossAxisAlignment: CrossAxisAlignment.start,
        // children list
        children: [
          // Card Header Row placing icon and title
          Row(
            // children list
            children: [
              // Circular icon background container
              Container(
                // Width
                width: 36.0,
                // Height
                height: 36.0,
                // Styling
                decoration: BoxDecoration(
                  // Soft primary color shade background fill
                  color: AppColors.primary_color.withValues(alpha: 0.1),
                  // Shape circle
                  shape: BoxShape.circle,
                ),
                // Bell icon graphic
                child: const Icon(
                  // Notification symbol
                  Icons.notifications_active_rounded,
                  // Accent color fill
                  color: AppColors.primary_color,
                  // Icon size
                  size: 18.0,
                ),
              ),
              // Horizontal gap spacer
              const SizedBox(width: AppSpacing.space_l),
              // Header Title text widget
              Text(
                // Localized title string
                localizations.profile_notifications_title,
                // Style properties
                style: TextStyle(
                  // Font size
                  fontSize: AppSpacing.font_size_title - 10.0,
                  // Bold weight
                  fontWeight: FontWeight.w800,
                  // Dynamic text color adaptions
                  color: true == is_dark
                      ? Colors.white
                      : AppColors.text_light_primary,
                ),
              ),
            ],
          ),
          // Divider spacer line
          const SizedBox(height: AppSpacing.space_l),
          // Partition line
          Divider(
            // Line height
            height: 1.0,
            // Thickness
            thickness: AppSpacing.border_width_thin,
            // Subdued divider color
            color: true == is_dark
                ? AppColors.border_dark
                : AppColors.border_light.withValues(alpha: 0.4),
          ),
          // Vertical space before first row (12px to 14px padding)
          const SizedBox(height: AppSpacing.space_l),

          // Switch Row 1: Appointment Reminders
          _build_switch_row(
            // Context reference
            context: context,
            // Localized main title
            title: localizations.profile_notifications_reminders,
            // Localized micro subtitle detail
            subtitle: localizations.profile_notifications_reminders_sub,
            // Active status state
            value: _notif_reminders,
            // Dark mode flag
            is_dark: is_dark,
            // Callback update listener
            on_changed: (new_val) {
              // Update state variable
              setState(() {
                // Assign state value
                _notif_reminders = new_val;
              });
            },
          ),
          // Vertical padding gap between rows (12px to 14px)
          const SizedBox(height: AppSpacing.space_l),

          // Switch Row 2: Invoices & Statements
          _build_switch_row(
            // Context reference
            context: context,
            // Localized main title
            title: localizations.profile_notifications_invoices,
            // Localized micro subtitle detail
            subtitle: localizations.profile_notifications_invoices_sub,
            // Active status state
            value: _notif_invoices,
            // Dark mode flag
            is_dark: is_dark,
            // Callback update listener
            on_changed: (new_val) {
              // Update state variable
              setState(() {
                // Assign state value
                _notif_invoices = new_val;
              });
            },
          ),
          // Vertical padding gap between rows (12px to 14px)
          const SizedBox(height: AppSpacing.space_l),

          // Switch Row 3: Promotional Offers
          _build_switch_row(
            // Context reference
            context: context,
            // Localized main title
            title: localizations.profile_notifications_promos,
            // Localized micro subtitle detail
            subtitle: localizations.profile_notifications_promos_sub,
            // Active status state
            value: _notif_promos,
            // Dark mode flag
            is_dark: is_dark,
            // Callback update listener
            on_changed: (new_val) {
              // Update state variable
              setState(() {
                // Assign state value
                _notif_promos = new_val;
              });
            },
          ),
        ],
      ),
    );
  }

  // Helper builder for Switch row items in Notification card
  Widget _build_switch_row({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required bool is_dark,
    required ValueChanged<bool> on_changed,
  }) {
    // Return row placing title/subtitle column and switch toggle widget
    return Row(
      // Align items across vertical center
      crossAxisAlignment: CrossAxisAlignment.center,
      // children list
      children: [
        // Title and Subtitle column taking available space
        Expanded(
          // Column
          child: Column(
            // Align left coordinates
            crossAxisAlignment: CrossAxisAlignment.start,
            // children list
            children: [
              // Option Title Text
              Text(
                // Title string
                title,
                // Style typography
                style: TextStyle(
                  // Font size
                  fontSize: AppSpacing.font_size_body_medium,
                  // Semi bold weight
                  fontWeight: FontWeight.w700,
                  // Dynamic colors
                  color: true == is_dark
                      ? Colors.white
                      : AppColors.text_light_primary,
                ),
              ),
              // Spacing gap (2px)
              const SizedBox(height: 2.0),
              // Micro Subtitle detail Text widget
              Text(
                // Subtitle string
                subtitle,
                // Style typography
                style: TextStyle(
                  // Micro font size 12px
                  fontSize: AppSpacing.font_size_body_small,
                  // Height line height ratio 1.3
                  height: 1.3,
                  // Muted color adaptions
                  color: true == is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
              ),
            ],
          ),
        ),
        // Horizontal spacing gap
        const SizedBox(width: AppSpacing.space_l),
        // Sleek active Switch toggle widget
        Switch.adaptive(
          // Active state value
          value: value,
          // Callback handler listener
          onChanged: on_changed,
          // Active track fill background
          activeTrackColor: AppColors.primary_color,
          // Inactive track color
          inactiveTrackColor: true == is_dark
              ? Colors.white24
              : AppColors.inner_container_border_light,
        ),
      ],
    );
  }

  // CARD B: Helper rendering Language Selection Settings floating card
  Widget _build_language_card(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Boolean tracking active Arabic locale state
    final bool is_arabic = true == localizations.is_arabic;

    // Return floating card container widget
    return Container(
      // Card background border decoration
      decoration: BoxDecoration(
        // Dynamic surface color
        color: true == is_dark ? AppColors.surface_dark : Colors.white,
        // Rounded borders radius bounds (16.0px)
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        // Soft ambient shadow
        boxShadow: [
          BoxShadow(
            // Shadow color adaptions
            color: true == is_dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            // Blur spread
            blurRadius: 10.0,
            // Offset
            offset: const Offset(0.0, 4.0),
          ),
        ],
        // Thin border line
        border: Border.all(
          // Color mapping adaptive theme mode
          color:
              true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          // Thin thickness
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Padding internal layout bounds
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      // Column layout stacking headers and segmented button switcher
      child: Column(
        // Align left coordinates
        crossAxisAlignment: CrossAxisAlignment.start,
        // children list
        children: [
          // Title and Subtitle Row with language globe icon
          Row(
            // children list
            children: [
              // Soft blue circular container housing icon
              Container(
                // Width
                width: 36.0,
                // Height
                height: 36.0,
                // Styling
                decoration: BoxDecoration(
                  // Soft primary color shade background fill
                  color: AppColors.primary_color.withValues(alpha: 0.1),
                  // Shape circle
                  shape: BoxShape.circle,
                ),
                // Globe language icon graphic
                child: const Icon(
                  // Language globe symbol
                  Icons.language_rounded,
                  // Accent color fill
                  color: AppColors.primary_color,
                  // Icon size
                  size: 18.0,
                ),
              ),
              // Horizontal gap spacer
              const SizedBox(width: AppSpacing.space_l),
              // Text column layout
              Expanded(
                // Column
                child: Column(
                  // Align left coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list
                  children: [
                    // Language Title Text
                    Text(
                      // Localized title label
                      localizations.profile_language_row,
                      // Style typography
                      style: TextStyle(
                        // Font size
                        fontSize: AppSpacing.font_size_body_medium + 2.0,
                        // Bold font weight
                        fontWeight: FontWeight.w800,
                        // Dynamic text color adaptions
                        color: true == is_dark
                            ? Colors.white
                            : AppColors.text_light_primary,
                      ),
                    ),
                    // Spacing gap (2px)
                    const SizedBox(height: 2.0),
                    // Micro Subtitle detail Text widget
                    Text(
                      // Localized subtitle description
                      localizations.profile_language_sub,
                      // Style typography
                      style: TextStyle(
                        // Micro font size 12px
                        fontSize: AppSpacing.font_size_body_small,
                        // Height ratio 1.3
                        height: 1.3,
                        // Muted color adaptions
                        color: true == is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Vertical gap before segmented toggle button group
          const SizedBox(height: AppSpacing.space_xl),

          // Premium Segmented Button Toggle group container [English | العربية]
          Container(
            // Fixed height 44px
            height: 44.0,
            // Styling container frame
            decoration: BoxDecoration(
              // Dark or light track container background
              color: true == is_dark
                  ? AppColors.inner_container_dark
                  : AppColors.inner_container_light,
              // Rounded pill corners radius
              borderRadius: BorderRadius.circular(AppSpacing.radius_l),
              // Defined 1px border outline
              border: Border.all(
                // Color mapping light/dark modes
                color: true == is_dark
                    ? AppColors.inner_container_border_dark
                    : AppColors.inner_container_border_light,
                // Border thickness 1px
                width: AppSpacing.border_width_thin,
              ),
            ),
            // Outer padding around buttons
            padding: const EdgeInsets.all(3.0),
            // Row placing English and Arabic segmented pill buttons
            child: Row(
              // children list
              children: [
                // Segment 1: English Option Pill button
                Expanded(
                  // Gesture detector
                  child: GestureDetector(
                    // Trigger language switch to English on tap
                    onTap: () {
                      // If current locale is Arabic, toggle to English
                      if (true == is_arabic) {
                        // Invoke global cubit language switcher action
                        context.read<GlobalCubit>().toggle_language();
                      }
                    },
                    // Container pill representation
                    child: AnimatedContainer(
                      // Animation duration
                      duration: const Duration(milliseconds: 200),
                      // Alignment center
                      alignment: Alignment.center,
                      // Pill decoration
                      decoration: BoxDecoration(
                        // Accent fill if English is active
                        color: false == is_arabic
                            ? AppColors.primary_color
                            : Colors.transparent,
                        // Rounded corners radius
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radius_l - 2.0,
                        ),
                        // Ambient card shadow when active
                        boxShadow: false == is_arabic
                            ? [
                                BoxShadow(
                                  // Color
                                  color: AppColors.primary_color.withValues(
                                    alpha: 0.35,
                                  ),
                                  // Blur
                                  blurRadius: 6.0,
                                  // Offset
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ]
                            : [],
                      ),
                      // Label Text
                      child: Text(
                        // Label text string
                        'English',
                        // Typography options
                        style: TextStyle(
                          // Small font size 13px
                          fontSize: 13.0,
                          // Bold font weight
                          fontWeight: FontWeight.w700,
                          // High contrast color if selected or unselected
                          color: false == is_arabic
                              ? Colors.white
                              : (true == is_dark
                                  ? Colors.white70
                                  : AppColors.text_light_primary),
                        ),
                      ),
                    ),
                  ),
                ),
                // Segment 2: Arabic Option Pill button (العربية)
                Expanded(
                  // Gesture detector
                  child: GestureDetector(
                    // Trigger language switch to Arabic on tap
                    onTap: () {
                      // If current locale is English, toggle to Arabic
                      if (false == is_arabic) {
                        // Invoke global cubit language switcher action
                        context.read<GlobalCubit>().toggle_language();
                      }
                    },
                    // Container pill representation
                    child: AnimatedContainer(
                      // Animation duration
                      duration: const Duration(milliseconds: 200),
                      // Alignment center
                      alignment: Alignment.center,
                      // Pill decoration
                      decoration: BoxDecoration(
                        // Accent fill if Arabic is active
                        color: true == is_arabic
                            ? AppColors.primary_color
                            : Colors.transparent,
                        // Rounded corners radius
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radius_l - 2.0,
                        ),
                        // Ambient card shadow when active
                        boxShadow: true == is_arabic
                            ? [
                                BoxShadow(
                                  // Color
                                  color: AppColors.primary_color.withValues(
                                    alpha: 0.35,
                                  ),
                                  // Blur
                                  blurRadius: 6.0,
                                  // Offset
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ]
                            : [],
                      ),
                      // Label Text
                      child: Text(
                        // Label text string
                        'العربية',
                        // Typography options
                        style: TextStyle(
                          // Small font size 13px
                          fontSize: 13.0,
                          // Bold font weight
                          fontWeight: FontWeight.w700,
                          // High contrast color if selected or unselected
                          color: true == is_arabic
                              ? Colors.white
                              : (true == is_dark
                                  ? Colors.white70
                                  : AppColors.text_light_primary),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CARD C: Helper rendering Display Theme Management floating card
  Widget _build_theme_card(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Theme mode options list
    final List<ThemeMode> modes = [
      ThemeMode.light,
      ThemeMode.dark,
      ThemeMode.system,
    ];
    // Segmented localized labels list
    final List<String> labels = [
      localizations.profile_theme_light,
      localizations.profile_theme_dark,
      localizations.profile_theme_system,
    ];

    // Return floating card container widget
    return Container(
      // Card background border decoration
      decoration: BoxDecoration(
        // Dynamic surface color
        color: true == is_dark ? AppColors.surface_dark : Colors.white,
        // Rounded borders radius bounds (16.0px)
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        // Soft ambient shadow
        boxShadow: [
          BoxShadow(
            // Shadow color adaptions
            color: true == is_dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            // Blur spread
            blurRadius: 10.0,
            // Offset
            offset: const Offset(0.0, 4.0),
          ),
        ],
        // Thin border line
        border: Border.all(
          // Color mapping adaptive theme mode
          color:
              true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          // Thin thickness
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Padding internal layout bounds
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      // Column layout stacking headers and 3-tier segmented control
      child: Column(
        // Align left coordinates
        crossAxisAlignment: CrossAxisAlignment.start,
        // children list
        children: [
          // Header Row placing theme icon and title details
          Row(
            // children list
            children: [
              // Circular soft icon container
              Container(
                // Width
                width: 36.0,
                // Height
                height: 36.0,
                // Styling
                decoration: BoxDecoration(
                  // Soft primary color shade background fill
                  color: AppColors.primary_color.withValues(alpha: 0.1),
                  // Shape circle
                  shape: BoxShape.circle,
                ),
                // Theme palette icon graphic
                child: const Icon(
                  // Palette theme symbol
                  Icons.palette_rounded,
                  // Accent color fill
                  color: AppColors.primary_color,
                  // Icon size
                  size: 18.0,
                ),
              ),
              // Horizontal gap spacer
              const SizedBox(width: AppSpacing.space_l),
              // Text details column
              Expanded(
                // Column
                child: Column(
                  // Align left coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list
                  children: [
                    // Theme Row Title Text
                    Text(
                      // Localized theme label
                      localizations.profile_theme_row,
                      // Style typography
                      style: TextStyle(
                        // Font size
                        fontSize: AppSpacing.font_size_body_medium + 2.0,
                        // Bold font weight
                        fontWeight: FontWeight.w800,
                        // Dynamic text color adaptions
                        color: true == is_dark
                            ? Colors.white
                            : AppColors.text_light_primary,
                      ),
                    ),
                    // Spacing gap (2px)
                    const SizedBox(height: 2.0),
                    // Micro Subtitle detail Text widget
                    Text(
                      // Localized subtitle description
                      localizations.profile_theme_sub,
                      // Style typography
                      style: TextStyle(
                        // Micro font size 12px
                        fontSize: AppSpacing.font_size_body_small,
                        // Height ratio 1.3
                        height: 1.3,
                        // Muted color adaptions
                        color: true == is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Vertical gap before 3-tier segmented control
          const SizedBox(height: AppSpacing.space_xl),

          // 3-Tier Segmented Control Container [Light | Dark | System]
          Container(
            // Fixed height 44px
            height: 44.0,
            // Styling container frame
            decoration: BoxDecoration(
              // Dark or light track container background
              color: true == is_dark
                  ? AppColors.inner_container_dark
                  : AppColors.inner_container_light,
              // Rounded pill corners radius
              borderRadius: BorderRadius.circular(AppSpacing.radius_l),
              // Defined 1px border outline
              border: Border.all(
                // Color mapping light/dark modes
                color: true == is_dark
                    ? AppColors.inner_container_border_dark
                    : AppColors.inner_container_border_light,
                // Border thickness 1px
                width: AppSpacing.border_width_thin,
              ),
            ),
            // Outer padding around buttons
            padding: const EdgeInsets.all(3.0),
            // ListenableBuilder mapping ThemeModeNotifier updates
            child: ListenableBuilder(
              // Listen to global theme notifier
              listenable: theme_mode_notifier,
              // Builder callback
              builder: (builder_context, child) {
                // Resolve active selected theme mode
                final ThemeMode active_mode =
                    theme_mode_notifier.current_theme_mode;
                // Return Row listing segmented buttons
                return Row(
                  // children list
                  children: List.generate(modes.length, (index) {
                    // Current loop mode
                    final ThemeMode mode = modes[index];
                    // Flag tracking if current mode is selected
                    final bool is_selected = mode == active_mode;

                    // Return expanded segmented button pill
                    return Expanded(
                      // Gesture detector
                      child: GestureDetector(
                        // Set selected theme mode on tap
                        onTap: () {
                          // Invoke set_theme_mode method
                          theme_mode_notifier.set_theme_mode(mode);
                        },
                        // Animated pill container representation
                        child: AnimatedContainer(
                          // Animation duration
                          duration: const Duration(milliseconds: 200),
                          // Alignment center
                          alignment: Alignment.center,
                          // Pill decoration
                          decoration: BoxDecoration(
                            // Highlight background fill if selected
                            color: true == is_selected
                                ? AppColors.primary_color
                                : Colors.transparent,
                            // Rounded corners radius
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radius_l - 2.0,
                            ),
                            // Ambient card shadow when active
                            boxShadow: true == is_selected
                                ? [
                                    BoxShadow(
                                      // Color
                                      color: AppColors.primary_color.withValues(
                                        alpha: 0.35,
                                      ),
                                      // Blur
                                      blurRadius: 6.0,
                                      // Offset
                                      offset: const Offset(0.0, 2.0),
                                    ),
                                  ]
                                : [],
                          ),
                          // Option label text widget
                          child: Text(
                            // Localized label string
                            labels[index],
                            // Typography options
                            style: TextStyle(
                              // Font size 12px
                              fontSize: AppSpacing.font_size_body_small,
                              // Bold weight
                              fontWeight: FontWeight.w700,
                              // High-contrast color feedback
                              color: true == is_selected
                                  ? Colors.white
                                  : (true == is_dark
                                      ? Colors.white70
                                      : AppColors.text_light_primary),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // CARD D: Helper rendering Support & Legal Hub structured floating card
  Widget _build_support_legal_card(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Return floating card container widget
    return Container(
      // Card background border decoration
      decoration: BoxDecoration(
        // Dynamic surface color
        color: true == is_dark ? AppColors.surface_dark : Colors.white,
        // Rounded borders radius bounds (16.0px)
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        // Soft ambient shadow
        boxShadow: [
          BoxShadow(
            // Shadow color adaptions
            color: true == is_dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            // Blur spread
            blurRadius: 10.0,
            // Offset
            offset: const Offset(0.0, 4.0),
          ),
        ],
        // Thin border line
        border: Border.all(
          // Color mapping adaptive theme mode
          color:
              true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          // Thin thickness
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Internal padding bounds
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      // Column stacking header and list rows
      child: Column(
        // Align left coordinates
        crossAxisAlignment: CrossAxisAlignment.start,
        // children list
        children: [
          // Header Row placing support icon and title details
          Row(
            // children list
            children: [
              // Circular soft icon container
              Container(
                // Width
                width: 36.0,
                // Height
                height: 36.0,
                // Styling
                decoration: BoxDecoration(
                  // Soft primary color shade background fill
                  color: AppColors.primary_color.withValues(alpha: 0.1),
                  // Shape circle
                  shape: BoxShape.circle,
                ),
                // Help desk icon graphic
                child: const Icon(
                  // Headset support symbol
                  Icons.headset_mic_rounded,
                  // Accent color fill
                  color: AppColors.primary_color,
                  // Icon size
                  size: 18.0,
                ),
              ),
              // Horizontal gap spacer
              const SizedBox(width: AppSpacing.space_l),
              // Text details column
              Expanded(
                // Column
                child: Column(
                  // Align left coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list
                  children: [
                    // Support & Legal Title Text
                    Text(
                      // Localized title label
                      localizations.profile_support_legal_title,
                      // Style typography
                      style: TextStyle(
                        // Font size
                        fontSize: AppSpacing.font_size_body_medium + 2.0,
                        // Bold font weight
                        fontWeight: FontWeight.w800,
                        // Dynamic text color adaptions
                        color: true == is_dark
                            ? Colors.white
                            : AppColors.text_light_primary,
                      ),
                    ),
                    // Spacing gap (2px)
                    const SizedBox(height: 2.0),
                    // Micro Subtitle detail Text widget
                    Text(
                      // Localized subtitle description
                      localizations.profile_support_legal_sub,
                      // Style typography
                      style: TextStyle(
                        // Micro font size 12px
                        fontSize: AppSpacing.font_size_body_small,
                        // Height ratio 1.3
                        height: 1.3,
                        // Muted color adaptions
                        color: true == is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Vertical partition gap
          const SizedBox(height: AppSpacing.space_l),
          // Partition divider line
          Divider(
            // Height
            height: 1.0,
            // Thickness
            thickness: AppSpacing.border_width_thin,
            // Subdued color
            color: true == is_dark
                ? AppColors.border_dark
                : AppColors.border_light.withValues(alpha: 0.4),
          ),
          // Vertical space before row 1
          const SizedBox(height: AppSpacing.space_s),

          // Navigation Row 1: Support Hotline option
          _build_navigation_row(
            // Context reference
            context: context,
            // Leading icon graphic
            icon: Icons.phone_callback_rounded,
            // Localized main title label
            title: localizations.profile_support_hotline,
            // Localized micro subtitle detail
            subtitle: localizations.profile_support_hotline_sub,
            // Dark mode flag
            is_dark: is_dark,
            // Action trigger callback
            on_tap: () {
              // Open hotline confirmation alert dialog
              showDialog(
                // Bind context
                context: context,
                // Dialog builder callback
                builder: (dialog_context) {
                  // Return AlertDialog widget
                  return AlertDialog(
                    // Localized dialog title
                    title: Text(
                      localizations.profile_support_dial_dialog_title,
                    ),
                    // Dialogue content description
                    content: const Text(
                      'Would you like to place a secure call to Appoynt support desk at 19999?',
                    ),
                    // Action buttons list
                    actions: [
                      // Cancel trigger button
                      TextButton(
                        // Dismiss dialog
                        onPressed: () => Navigator.of(dialog_context).pop(),
                        // Label
                        child: Text(localizations.profile_cancel_button),
                      ),
                      // Dial trigger button
                      TextButton(
                        // Dismiss dialog and display feedback snackbar
                        onPressed: () {
                          // Pop dialog context route
                          Navigator.of(dialog_context).pop();
                          // Show feedback SnackBar toast message
                          ScaffoldMessenger.of(context).showSnackBar(
                            // SnackBar settings
                            const SnackBar(
                              content: Text('Hotline dialer opened.'),
                            ),
                          );
                        },
                        // Dial label
                        child: const Text('Dial'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // Indented partition line
          Padding(
            // Indent padding offset (48px)
            padding: const EdgeInsets.only(left: 48.0, right: 48.0),
            // Divider
            child: Divider(
              // Height
              height: 1.0,
              // Thickness
              thickness: AppSpacing.border_width_thin,
              // Subdued color
              color: true == is_dark
                  ? AppColors.border_dark
                  : AppColors.border_light.withValues(alpha: 0.3),
            ),
          ),

          // Navigation Row 2: Terms of Use option
          _build_navigation_row(
            // Context reference
            context: context,
            // Leading icon graphic
            icon: Icons.description_rounded,
            // Localized main title label
            title: localizations.profile_support_terms,
            // Localized micro subtitle detail
            subtitle: localizations.profile_support_terms_sub,
            // Dark mode flag
            is_dark: is_dark,
            // Action trigger callback
            on_tap: () {
              // Open Terms of Use bottom sheet modal
              _show_legal_modal(
                // Context reference
                context: context,
                // Title
                title: localizations.profile_terms_modal_title,
                // Content summary
                content: localizations.profile_terms_content,
                // Dark mode flag
                is_dark: is_dark,
                // Localizations reference
                localizations: localizations,
              );
            },
          ),
          // Indented partition line
          Padding(
            // Indent padding offset (48px)
            padding: const EdgeInsets.only(left: 48.0, right: 48.0),
            // Divider
            child: Divider(
              // Height
              height: 1.0,
              // Thickness
              thickness: AppSpacing.border_width_thin,
              // Subdued color
              color: true == is_dark
                  ? AppColors.border_dark
                  : AppColors.border_light.withValues(alpha: 0.3),
            ),
          ),

          // Navigation Row 3: Privacy Policy option
          _build_navigation_row(
            // Context reference
            context: context,
            // Leading icon graphic
            icon: Icons.security_rounded,
            // Localized main title label
            title: localizations.profile_support_privacy,
            // Localized micro subtitle detail
            subtitle: localizations.profile_support_privacy_sub,
            // Dark mode flag
            is_dark: is_dark,
            // Action trigger callback
            on_tap: () {
              // Open Privacy Policy bottom sheet modal
              _show_legal_modal(
                // Context reference
                context: context,
                // Title
                title: localizations.profile_privacy_modal_title,
                // Content summary
                content: localizations.profile_privacy_content,
                // Dark mode flag
                is_dark: is_dark,
                // Localizations reference
                localizations: localizations,
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper builder for navigation list item rows in Support & Legal card
  Widget _build_navigation_row({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool is_dark,
    required VoidCallback on_tap,
  }) {
    // Return InkWell gesture container giving native press ripple feedback
    return InkWell(
      // Bind tap action listener
      onTap: on_tap,
      // Rounded corners ripple bounds
      borderRadius: BorderRadius.circular(AppSpacing.radius_m),
      // Padding margins around row content
      child: Padding(
        // Padding symmetric bounds
        padding: const EdgeInsets.symmetric(
          // Horizontal offset 4.0
          horizontal: AppSpacing.space_s,
          // Vertical padding offset 12.0
          vertical: AppSpacing.space_l,
        ),
        // Horizontal Row placing icon, titles column, and chevron indicator
        child: Row(
          // children list
          children: [
            // Soft rounded container housing leading icon graphic
            Container(
              // Width
              width: 36.0,
              // Height
              height: 36.0,
              // Style
              decoration: BoxDecoration(
                // Soft blue tint fill
                color: AppColors.primary_color.withValues(alpha: 0.08),
                // Rounded corners radius
                borderRadius: BorderRadius.circular(AppSpacing.radius_m),
              ),
              // Icon graphic
              child: Icon(
                // Icon symbol
                icon,
                // Primary brand color accent
                color: AppColors.primary_color,
                // Icon size
                size: 18.0,
              ),
            ),
            // Horizontal spacing gap (12px)
            const SizedBox(width: AppSpacing.space_l),
            // Details column taking available width
            Expanded(
              // Column
              child: Column(
                // Align left coordinates
                crossAxisAlignment: CrossAxisAlignment.start,
                // children list
                children: [
                  // Option Title Text
                  Text(
                    // Title string
                    title,
                    // Style typography
                    style: TextStyle(
                      // Font size
                      fontSize: AppSpacing.font_size_body_medium,
                      // Bold font weight
                      fontWeight: FontWeight.w700,
                      // Dynamic text color adaptions
                      color: true == is_dark
                          ? Colors.white
                          : AppColors.text_light_primary,
                    ),
                  ),
                  // Spacing gap (2px)
                  const SizedBox(height: 2.0),
                  // Micro Subtitle detail Text widget
                  Text(
                    // Subtitle string
                    subtitle,
                    // Style typography
                    style: TextStyle(
                      // Micro font size 12px
                      fontSize: AppSpacing.font_size_body_small,
                      // Height line ratio 1.3
                      height: 1.3,
                      // Muted text color adaptions
                      color: true == is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary,
                    ),
                  ),
                ],
              ),
            ),
            // Horizontal gap spacer
            const SizedBox(width: AppSpacing.space_s),
            // Subtle trailing chevron navigation indicator symbol
            const Icon(
              // Chevron right icon
              Icons.chevron_right_rounded,
              // Subdued color matching micro text summaries
              color: AppColors.text_light_secondary,
              // Standard icon size
              size: AppSpacing.icon_size_m,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method displaying legal & terms modal bottom sheet
  void _show_legal_modal({
    required BuildContext context,
    required String title,
    required String content,
    required bool is_dark,
    required AppLocalizations localizations,
  }) {
    // Trigger bottom sheet display modal
    showModalBottomSheet(
      // Context reference
      context: context,
      // Rounded top corner boundaries
      shape: const RoundedRectangleBorder(
        // Border radius top parameters
        borderRadius: BorderRadius.vertical(
          // Top radius bound (24.0px)
          top: Radius.circular(AppSpacing.space_xxl),
        ),
      ),
      // Dark/Light surface color fills
      backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.white,
      // Builder callback
      builder: (modal_context) {
        // Return padding container layout
        return Padding(
          // Padding bounds
          padding: const EdgeInsets.all(AppSpacing.space_xxl),
          // Column stacking drag handle, title, body content, and close CTA
          child: Column(
            // Shrink wrap layout height
            mainAxisSize: MainAxisSize.min,
            // Align left coordinates
            crossAxisAlignment: CrossAxisAlignment.start,
            // children list
            children: [
              // Centered top drag handle pill indicator
              Center(
                // Pill container widget
                child: Container(
                  // Width
                  width: 40.0,
                  // Height
                  height: 4.0,
                  // Styling
                  decoration: BoxDecoration(
                    // Muted handle color
                    color: true == is_dark ? Colors.white30 : Colors.black26,
                    // Circular radius bounds
                    borderRadius: BorderRadius.circular(AppSpacing.radius_s),
                  ),
                ),
              ),
              // Vertical gap spacer (16px)
              const SizedBox(height: AppSpacing.space_xl),

              // Legal Modal Header Title Text
              Text(
                // Title string
                title,
                // Typography options
                style: TextStyle(
                  // Header font size (20px)
                  fontSize: 20.0,
                  // Extra bold weight
                  fontWeight: FontWeight.w800,
                  // Colors
                  color: true == is_dark
                      ? Colors.white
                      : AppColors.text_light_primary,
                ),
              ),
              // Vertical gap spacer (12px)
              const SizedBox(height: AppSpacing.space_l),

              // Legal Modal Content Summary Text
              Text(
                // Content summary text string
                content,
                // Typography options
                style: TextStyle(
                  // Body font size 14px
                  fontSize: AppSpacing.font_size_body_medium,
                  // Line height spacing ratio 1.4
                  height: 1.4,
                  // Muted text colors
                  color: true == is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
              ),
              // Vertical gap spacer (24px)
              const SizedBox(height: AppSpacing.space_xxl),

              // Full width Close CTA button
              SizedBox(
                // Full width
                width: double.infinity,
                // Height
                height: 48.0,
                // Elevated button
                child: ElevatedButton(
                  // Dismiss bottom sheet modal on tap
                  onPressed: () => Navigator.of(modal_context).pop(),
                  // Styling
                  style: ElevatedButton.styleFrom(
                    // Accent brand background color
                    backgroundColor: AppColors.primary_color,
                    // Foreground text color
                    foregroundColor: Colors.white,
                    // Rounded corner radius
                    shape: RoundedRectangleBorder(
                      // Radius 12px
                      borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                    ),
                  ),
                  // Button text label
                  child: Text(
                    // Localized close string label
                    localizations.profile_close_button,
                    // Typography
                    style: const TextStyle(
                      // Bold weight
                      fontWeight: FontWeight.bold,
                      // Size 15px
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*
 * File Name: home_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.0.0
 * Dependencies: flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the temporary dummy home screen and components.
 */

// TODO: START OF DUMMY HOME SCREEN IMPLEMENTATION - REMOVE ONCE FINAL HOME IS COMPLETED

// Importing central UI and route exports barrel file
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing BLoC provider library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing profile Cubit declaration
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing ProfilePage widget screen definition
import 'package:appoynt_mobile_app/features/profile/presentation/pages/profile_page.dart';
// Importing FavoritesPage widget screen definition
import 'package:appoynt_mobile_app/features/favorites/presentation/pages/favorites_page.dart';
// Importing NotificationsPage widget screen definition
import 'package:appoynt_mobile_app/features/notifications/presentation/pages/notifications_page.dart';

// Defining the HomePage stateful widget representation
class HomePage extends StatefulWidget {
  // Constructor initializing the widget key
  const HomePage({super.key});

  // Create state class definition
  @override
  State<HomePage> createState() {
    // Return a new state instance representation
    return _HomePageState();
  }
}

// State implementation class for the HomePage widget
class _HomePageState extends State<HomePage> {
  // Current active navigation index selection tracker
  int _selected_index = 0;

  // Build the main Scaffold layout containing bottom navigation and tabs
  @override
  Widget build(BuildContext context) {
    // Resolve localizations context configuration
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Return the root Scaffold page container layout settings
    return Scaffold(
      // Build the bottom navigation bar widget using the reusable AppBottomNavBar component
      bottomNavigationBar: AppBottomNavBar(
        // Pass active selected index
        selected_index: _selected_index,
        // On tap update local state and index tracker
        on_tap: (index) {
          // Check if search tab is tapped using Yoda style check (index 2)
          if (2 == index) {
            // TODO: START OF DUMMY HOME ROUTING - REMOVE ONCE FINAL HOME IS COMPLETED
            // Check if context remains mounted using Yoda style check
            if (true == context.mounted) {
              // Route to the dedicated search page using slide/fade transition
              Navigator.of(context)
                  .push<int>(
                // Page route transition configs
                PageRouteBuilder(
                  // Target search page constructor mapping builder
                  pageBuilder: (context, anim, secAnim) {
                    // Return SearchPage widget instance
                    return const SearchPage();
                  },
                  // Transition builder animating cross-fade layout sweep
                  transitionsBuilder: (context, anim, secAnim, child) {
                    // Return fade transition
                    return FadeTransition(
                      // Bind opacity factor to active transition
                      opacity: anim,
                      // Child display layout widget
                      child: child,
                    );
                  },
                  // Transition duration configs milliseconds limit
                  transitionDuration: const Duration(
                    // Delay milliseconds count
                    milliseconds: AppSpacing.duration_fade_ms,
                  ),
                ),
              )
                  .then((result_index) {
                // Check if a result index was returned and widget remains active
                if (result_index != null && true == context.mounted) {
                  // Rebuild screen selecting the requested tab index
                  setState(() {
                    // Update index selection
                    _selected_index = result_index;
                  });
                } else {
                  // Empty block
                }
              });
            } else {
              // No action needed
            }
            // TODO: END OF DUMMY HOME ROUTING
          } else {
            // Check if view remains mounted using Yoda style check
            if (true == context.mounted) {
              // Update state representation
              setState(() {
                // Bind index
                _selected_index = index;
              });
            } else {
              // Empty block
            }
          }
        },
      ),
      // Wrap content area within a safe area display container
      body: SafeArea(
        // Render the tab content based on the selected index
        child: 0 == _selected_index
            // Home tab content representation
            ? _HomeTab(
                onSearchReturn: (index) {
                  // Check if view remains active using Yoda style check
                  if (true == context.mounted) {
                    setState(() {
                      // Update selected index
                      _selected_index = index;
                    });
                  } else {
                    // Empty block
                  }
                },
              )
            : 3 == _selected_index
                // Instantiate the Favorites tab widget
                ? const FavoritesPage()
                : 4 == _selected_index
                    // Instantiate the Profile tab wrapped in its Cubit state controller
                    ? BlocProvider<ProfileCubit>(
                        // Create Cubit state controller instance
                        create: (context) {
                          // Return new ProfileCubit
                          return ProfileCubit();
                        },
                        // Renders the ProfilePage main screen widget
                        child: const ProfilePage(),
                      )
                    // Construction/Coming soon tab representation for other items
                    : _ComingSoonTab(
                        // Localized category label mapping active selection
                        label: 1 == _selected_index
                            ? localizations.dummy_appointments_tab_label
                            : localizations.dummy_search_tab_label,
                      ),
      ),
    );
  }

  // Builder method generating the customized bottom navigation bar widget
}

// Class representation of HomeTab layout layout showing widgets
class _HomeTab extends StatelessWidget {
  // Callback when a navigation index is returned from search screen
  final ValueChanged<int> onSearchReturn;

  // Constructor mapping properties
  const _HomeTab({
    required this.onSearchReturn,
  });

  // Build method drawing the Home tab contents layout hierarchy
  @override
  Widget build(BuildContext context) {
    // Resolve localized strings dictionary reference
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve dark mode active state context
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return scrollable list content wrapper container layout
    return SingleChildScrollView(
      // Standard page margins padding bounds
      padding: const EdgeInsets.symmetric(
        // Set horizontal margin padding using custom dummy tokens
        horizontal: AppSpacing.dummy_padding_home,
      ),
      // Linear column stack listing page sections widgets
      child: Column(
        // Align children starting from left side boundary points
        crossAxisAlignment: CrossAxisAlignment.start,
        // Add content section elements inside array layout representation
        children: [
          // Vertical space spacer offset
          const SizedBox(
            // Height space using dummy tokens
            height: AppSpacing.dummy_spacing_home,
          ),
          // Row container displaying logo and greeting header information
          Row(
            // List header details widgets
            children: [
              // Expanded block taking remaining width space
              Expanded(
                // Column stack grouping text messages vertically
                child: Column(
                  // Align text labels to start coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Text elements inside list
                  children: [
                    // Text welcome message title label representation
                    Text(
                      // Greeting text string
                      localizations.dummy_good_morning,
                      // Font typography layout parameters
                      style: const TextStyle(
                        // Typographic font size value
                        fontSize: AppSpacing.font_size_subtitle,
                        // Color styling from design token configurations
                        color: AppColors.text_light_secondary,
                      ),
                    ),
                    // Small vertical spacer box
                    const SizedBox(
                      // Height spacing value
                      height: AppSpacing.space_xs,
                    ),
                    // Welcome branding text label representation
                    Text(
                      // Welcome title string
                      localizations.dummy_welcome_to_appoynt_home,
                      // Typography styling layout parameters
                      style: TextStyle(
                        // Font size matching heading standards
                        fontSize: AppSpacing.dummy_font_size_welcome,
                        // Accent bold typographic weight indicator
                        fontWeight: FontWeight.w800,
                        // Dynamic text color adjusting to theme modes
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Container containing the notification bell wrapper
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
                child: Container(
                  // Bell box width constraint
                  width: AppSpacing.dummy_size_notification_bell,
                  // Bell box height constraint
                  height: AppSpacing.dummy_size_notification_bell,
                  // Layout border and backgrounds styling properties representation
                  decoration: BoxDecoration(
                    // Dynamic background color matching surface theme
                    color: is_dark
                        ? AppColors.surface_dark
                        : AppColors.background_light,
                    // Circular rounded container shape configurations
                    borderRadius: BorderRadius.circular(
                      // Radius value using dummy constants token
                      AppSpacing.radius_l,
                    ),
                    // Border lines border representations
                    border: Border.all(
                      // Border boundary outline color mappings
                      color: is_dark
                          ? AppColors.border_dark
                          : AppColors.border_light,
                      // Explicit border width definition
                      width: AppSpacing.border_width_thin,
                    ),
                  ),
                  // Stack overlaying alert indicators above icon
                  child: Stack(
                    // Center stack items content alignments
                    alignment: Alignment.center,
                    // Stack child elements
                    children: [
                      // Notification bell icon widget representation
                      Icon(
                        // Bell icon token
                        Icons.notifications_outlined,
                        // Bell color matching header texts
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                        // Icon display size bounds
                        size: AppSpacing.dummy_size_icon_notification,
                      ),
                      // Positioned notification indicator dot representation
                      Positioned(
                        // Top offset position coordinate
                        top: AppSpacing.dummy_notification_badge_offset,
                        // Right offset position coordinate
                        right: AppSpacing.dummy_notification_badge_offset,
                        // Red alert circle container
                        child: Container(
                          // Dot width layout constraint
                          width: AppSpacing.dummy_notification_badge_size,
                          // Dot height layout constraint
                          height: AppSpacing.dummy_notification_badge_size,
                          // Dot shape configurations
                          decoration: const BoxDecoration(
                            // Red accent color matching error notifications
                            color: AppColors.error,
                            // Round circle shape
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Vertical layout margin space
          const SizedBox(
            // Margin height spacing
            height: AppSpacing.dummy_spacing_home,
          ),
          // GestureDetector intercepting tap trigger to route to search page
          GestureDetector(
            // On tap callback navigation handler
            onTap: () {
              // TODO: START OF DUMMY HOME ROUTING - REMOVE ONCE FINAL HOME IS COMPLETED
              // Check if context remains mounted using Yoda style check
              if (true == context.mounted) {
                // Route to the dedicated search page using slide/fade transition
                Navigator.of(context)
                    .push<int>(
                  // Page route transition configs
                  PageRouteBuilder(
                    // Target search page constructor mapping builder
                    pageBuilder: (context, anim, secAnim) {
                      // Return SearchPage widget instance
                      return const SearchPage();
                    },
                    // Transition builder animating cross-fade layout sweep
                    transitionsBuilder: (context, anim, secAnim, child) {
                      // Return fade transition
                      return FadeTransition(
                        // Bind opacity factor to active transition
                        opacity: anim,
                        // Child display layout widget
                        child: child,
                      );
                    },
                    // Transition duration configs milliseconds limit
                    transitionDuration: const Duration(
                      // Delay milliseconds count
                      milliseconds: AppSpacing.duration_fade_ms,
                    ),
                  ),
                )
                    .then((result_index) {
                  // If a result index was returned, forward it through callback
                  if (result_index != null) {
                    onSearchReturn(result_index);
                  } else {
                    // Empty block
                  }
                });
              } else {
                // No action needed
              }
              // TODO: END OF DUMMY HOME ROUTING
            },
            // Hero widget establishing search bar morph transition trigger
            child: Hero(
              // Hero unique identifier tag
              tag: "search_bar",
              // Material wrapper ensuring input text style renders properly during hero morphs
              child: Material(
                // Fully transparent background representation
                color: AppColors.transparent,
                // Container mimicking search bar text field layout
                child: Container(
                  // Container height constraint
                  height: AppSpacing.dummy_height_search_bar,
                  // Card decorations style mappings
                  decoration: BoxDecoration(
                    // Dynamic background surface color
                    color: is_dark
                        ? AppColors.surface_dark
                        : AppColors.background_light,
                    // Rounded container corners configurations
                    borderRadius: BorderRadius.circular(
                      // Radius token value
                      AppSpacing.dummy_search_bar_radius,
                    ),
                    // Border line boundary decoration options
                    border: Border.all(
                      // Border outline colors matching dividers
                      color: is_dark
                          ? AppColors.border_dark
                          : AppColors.border_light,
                      // Explicit border width definition
                      width: AppSpacing.border_width_thin,
                    ),
                  ),
                  // Horizontal row placing search indicator and text
                  child: Row(
                    // Align elements vertically centered inside box
                    children: [
                      // Left margin space separator
                      const SizedBox(
                        // Width spacer value
                        width: AppSpacing.dummy_search_bar_padding_left,
                      ),
                      // Search icon graphic asset representation
                      const Icon(
                        // Search icon graphic representation
                        Icons.search_rounded,
                        // Icon color matching subtext descriptions
                        color: AppColors.text_light_secondary,
                        // Icon size constraint
                        size: AppSpacing.dummy_size_icon_notification,
                      ),
                      // Separator space between icon and label text
                      const SizedBox(
                        // Width spacer value
                        width: AppSpacing.dummy_search_bar_spacing,
                      ),
                      // Placeholder label text display option
                      Text(
                        // Search label text string
                        localizations.dummy_search_hint,
                        // Typographic text parameters options
                        style: const TextStyle(
                          // Small text body size
                          fontSize: AppSpacing.font_size_body_medium,
                          // Subdued color representing text inputs hint layout
                          color: AppColors.text_light_secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Section vertical separator spacing layout
          const SizedBox(
            // Space height size value
            height: AppSpacing.space_xxl,
          ),
          // Row grouping the quick actions buttons widgets horizontally
          Row(
            // Action button children list widgets
            children: [
              // Book Appointment quick action element representation
              _QuickAction(
                // Button icon
                icon: Icons.calendar_month_rounded,
                // Localized button label
                label: localizations.dummy_book_appointment,
                // Applied background theme color
                color: AppColors.primary_color,
              ),
              // Separator layout spacing box
              const SizedBox(
                // Separator width value
                width: AppSpacing.dummy_quick_action_spacing,
              ),
              // My Queue quick action element representation
              _QuickAction(
                // Button icon
                icon: Icons.queue_rounded,
                // Localized button label
                label: localizations.dummy_my_queue,
                // Applied background theme color
                color: AppColors.dummy_secondary_color,
              ),
              // Separator layout spacing box
              const SizedBox(
                // Separator width value
                width: AppSpacing.dummy_quick_action_spacing,
              ),
              // Video Consult quick action element representation
              _QuickAction(
                // Button icon
                icon: Icons.video_call_rounded,
                // Localized button label
                label: localizations.dummy_video_consult,
                // Applied background theme color
                color: AppColors.dummy_custom_purple,
              ),
              // Separator layout spacing box
              const SizedBox(
                // Separator width value
                width: AppSpacing.dummy_quick_action_spacing,
              ),
              // My Records quick action element representation
              _QuickAction(
                // Button icon
                icon: Icons.folder_special_rounded,
                // Localized button label
                label: localizations.dummy_my_records,
                // Applied background theme color
                color: AppColors.dummy_accent_color,
              ),
            ],
          ),
          // Section divider vertical space
          const SizedBox(
            // Divider height spacing value
            height: AppSpacing.dummy_spacing_large,
          ),
          // Gradient container block presenting next upcoming appointment details
          Container(
            // Set double infinity to take up full available width constraints
            width: double.infinity,
            // Padding offset inside banner boundary lines
            padding: const EdgeInsets.all(
              // Banner padding value
              AppSpacing.dummy_banner_padding,
            ),
            // Background decorations config parameters
            decoration: BoxDecoration(
              // Linear gradient fill colors transition
              gradient: const LinearGradient(
                // Colors array representing blue brand variations transitions
                colors: [
                  // Lighter primary brand shade start color
                  AppColors.primary_color,
                  // Darker primary brand shade end color
                  AppColors.dummy_primary_dark,
                ],
                // Begin gradient from top-left boundary corner
                begin: Alignment.topLeft,
                // Terminate gradient at bottom-right boundary corner
                end: Alignment.bottomRight,
              ),
              // Rounded card corners shape values
              borderRadius: BorderRadius.circular(
                // Radius token value
                AppSpacing.dummy_banner_radius,
              ),
            ),
            // Row placing text details next to calendar icon decoration
            child: Row(
              // Banner child elements
              children: [
                // Expanded block container taking remaining space
                Expanded(
                  // Column stack presenting details labels
                  child: Column(
                    // Align text labels to start coordinate
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Inner items listing
                    children: [
                      // Subheading title label widget
                      Text(
                        // Appointment banner subhead string
                        localizations.dummy_next_appointment,
                        // Label typography settings
                        style: const TextStyle(
                          // Text color white with moderate opacity levels
                          color: AppColors.white70,
                          // Small font size mapping subhead layouts
                          fontSize: AppSpacing.font_size_label,
                        ),
                      ),
                      // Spacer vertical height offset box
                      const SizedBox(
                        // Height spacing value
                        height: AppSpacing.space_xs,
                      ),
                      // Doctor name display text label
                      Text(
                        // Doctor name string
                        localizations.dummy_dr_ahmed_hassan,
                        // Label typography parameters options
                        style: const TextStyle(
                          // White text color for high contrast representation
                          color: AppColors.white,
                          // Moderate header font size
                          fontSize: AppSpacing.font_size_body_medium,
                          // Extra bold weight settings
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Spacer vertical height offset box
                      const SizedBox(
                        // Height spacing value
                        height: AppSpacing.space_xs,
                      ),
                      // Consultation details specialty and schedule timing string
                      Text(
                        // Localized timing string
                        localizations.dummy_general_medicine_today,
                        // Label typography settings
                        style: const TextStyle(
                          // White text color with moderate opacity levels
                          color: AppColors.white70,
                          // Small font size mapping subhead layouts
                          fontSize: AppSpacing.font_size_label,
                        ),
                      ),
                      // Spacer vertical height offset box
                      const SizedBox(
                        // Height spacing value
                        height: AppSpacing.space_l,
                      ),
                      // White badge container mimicking click action
                      Container(
                        // Padding within badge borders
                        padding: const EdgeInsets.symmetric(
                          // Horizontal padding value
                          horizontal: AppSpacing
                              .dummy_doctor_card_btn_padding_horizontal,
                          // Vertical padding value
                          vertical: AppSpacing.dummy_padding_small_badge,
                        ),
                        // Layout decorations details
                        decoration: BoxDecoration(
                          // Solid white background fill
                          color: AppColors.white,
                          // Rounded border edges configurations
                          borderRadius: BorderRadius.circular(
                            // Circular boundary radius parameter value
                            AppSpacing.dummy_bottom_nav_item_radius,
                          ),
                        ),
                        // Action label text
                        child: Text(
                          // Localized action button label string
                          localizations.dummy_view_details,
                          // Label text styling parameters options
                          style: const TextStyle(
                            // Color matching brand primary theme colors
                            color: AppColors.primary_color,
                            // Small font size
                            fontSize: AppSpacing.font_size_label,
                            // Bold text weight representation
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Calendar icon representing appointment category graphics
                Icon(
                  // Calendar icon representation
                  Icons.calendar_today_rounded,
                  // Semi-transparent white color to overlay subtly
                  color: AppColors.white
                      .withValues(alpha: AppSpacing.dummy_opacity_bell_badge),
                  // Large graphical representation boundaries size
                  size: AppSpacing.dummy_banner_icon_size,
                ),
              ],
            ),
          ),
          // Section divider vertical space
          const SizedBox(
            // Divider height spacing value
            height: AppSpacing.dummy_spacing_large,
          ),
          // Row header displaying Specialties category labels
          Row(
            // Align elements to opposite sides of row layout bounds
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Header items
            children: [
              // Specialties title label text representation
              Text(
                // Section header text string
                localizations.dummy_specialties,
                // Typographic layout options
                style: TextStyle(
                  // Font size for minor category section headers
                  fontSize: AppSpacing.font_size_action_button,
                  // Bold typography indicator
                  fontWeight: FontWeight.w700,
                  // Dynamic text color adjusting to brightness mode
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              // View All interactive text navigation link representation
              Text(
                // Action link text label string
                localizations.dummy_see_all,
                // Typographic layout options
                style: const TextStyle(
                  // Small font size for links
                  fontSize: AppSpacing.font_size_label,
                  // Color matching brand primary color tokens
                  color: AppColors.primary_color,
                  // Semi-bold font weight helper selection
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Spacer height offset
          const SizedBox(
            // Height spacer value
            height: AppSpacing.dummy_search_bar_padding_left,
          ),
          // Horizontal Specialties list container box
          SizedBox(
            // Container height constraint using dummy token
            height: AppSpacing.dummy_height_specialties_list,
            // Horizontal list view builder
            child: ListView(
              // Set horizontal scrolling configuration
              scrollDirection: Axis.horizontal,
              // Specialties children chips
              children: [
                // Cardiology category chip widget
                _SpecialtyChip(
                  // Category icon
                  icon: Icons.favorite_rounded,
                  // Localized category name label
                  label: localizations.dummy_cardiology,
                  // Color representation mapping cardiology themes
                  color: AppColors.dummy_custom_red,
                ),
                // Neurology category chip widget
                _SpecialtyChip(
                  // Category icon
                  icon: Icons.psychology_rounded,
                  // Localized category name label
                  label: localizations.dummy_neurology,
                  // Color representation mapping neurology themes
                  color: AppColors.dummy_custom_purple,
                ),
                // Pediatrics category chip widget
                _SpecialtyChip(
                  // Category icon
                  icon: Icons.child_care_rounded,
                  // Localized category name label
                  label: localizations.dummy_pediatrics,
                  // Color representation mapping pediatrics themes
                  color: AppColors.dummy_custom_blue,
                ),
                // Eye Care category chip widget
                _SpecialtyChip(
                  // Category icon
                  icon: Icons.visibility_rounded,
                  // Localized category name label
                  label: localizations.dummy_eye_care,
                  // Color representation mapping ophthalmology themes
                  color: AppColors.dummy_custom_green,
                ),
                // Orthopedic category chip widget
                _SpecialtyChip(
                  // Category icon
                  icon: Icons.healing_rounded,
                  // Localized category name label
                  label: localizations.dummy_orthopedic,
                  // Color representation mapping orthopedic themes
                  color: AppColors.dummy_custom_orange,
                ),
              ],
            ),
          ),
          // Section divider vertical space
          const SizedBox(
            // Divider height spacing value
            height: AppSpacing.dummy_spacing_large,
          ),
          // Row header displaying Top Doctors category labels
          Row(
            // Align elements to opposite sides of row layout bounds
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Header items
            children: [
              // Doctors category title label representation
              Text(
                // Section header text string
                localizations.dummy_top_doctors,
                // Typographic layout options
                style: TextStyle(
                  // Font size for minor category section headers
                  fontSize: AppSpacing.font_size_action_button,
                  // Bold typography indicator
                  fontWeight: FontWeight.w700,
                  // Dynamic text color adjusting to brightness mode
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              // View All interactive text navigation link representation
              Text(
                // Action link text label string
                localizations.dummy_see_all,
                // Typographic layout options
                style: const TextStyle(
                  // Small font size for links
                  fontSize: AppSpacing.font_size_label,
                  // Color matching brand primary color tokens
                  color: AppColors.primary_color,
                  // Semi-bold font weight helper selection
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Spacer height offset
          const SizedBox(
            // Height spacer value
            height: AppSpacing.dummy_search_bar_padding_left,
          ),
          // Doctor card displaying Dr. Sarah Johnson details
          _DoctorCard(
            // Doctor name label
            name: localizations.dummy_dr_sarah_johnson,
            // Specialty label description
            specialty: localizations.dummy_cardiologist,
            // Rating score value string
            rating: '4.9',
            // Practice experience length details
            experience: localizations.dummy_years_experience_sarah,
            // Accent color matching category chip
            color: AppColors.dummy_custom_red,
          ),
          // Separator vertical height spacing box
          const SizedBox(
            // Spacer value
            height: AppSpacing.dummy_specialty_chip_margin_right,
          ),
          // Doctor card displaying Dr. Mohammed Ali details
          _DoctorCard(
            // Doctor name label
            name: localizations.dummy_dr_mohammed_ali,
            // Specialty label description
            specialty: localizations.dummy_neurologist,
            // Rating score value string
            rating: '4.8',
            // Practice experience length details
            experience: localizations.dummy_years_experience_mohammed,
            // Accent color matching category chip
            color: AppColors.dummy_custom_purple,
          ),
          // Separator vertical height spacing box
          const SizedBox(
            // Spacer value
            height: AppSpacing.dummy_specialty_chip_margin_right,
          ),
          // Doctor card displaying Dr. Fatima Ahmed details
          _DoctorCard(
            // Doctor name label
            name: localizations.dummy_dr_fatima_ahmed,
            // Specialty label description
            specialty: localizations.dummy_pediatrician,
            // Rating score value string
            rating: '4.7',
            // Practice experience length details
            experience: localizations.dummy_years_experience_fatima,
            // Accent color matching category chip
            color: AppColors.dummy_custom_blue,
          ),
          // Spacer height offset at page bottom
          const SizedBox(
            // Extra large spacing spacer
            height: AppSpacing.space_xxxl,
          ),
        ],
      ),
    );
  }
}

// Stateful/Stateless widget representation of the ComingSoonTab fallback screen
class _ComingSoonTab extends StatelessWidget {
  // Label text string reference
  final String label;

  // Constructor mapping the widget label parameter
  const _ComingSoonTab({required this.label});

  // Build method drawing the Coming Soon screen
  @override
  Widget build(BuildContext context) {
    // Resolve localized strings dictionary reference
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve dark mode active state context
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return centered column widget laying out contents
    return Center(
      // Column group mapping vertical nodes
      child: Column(
        // Minimize vertical space consumed by list elements
        mainAxisSize: MainAxisSize.min,
        // Layout list children widgets
        children: [
          // Circle avatar container displaying construction graphic icon
          Container(
            // Circle width constraint
            width: AppSpacing.dummy_size_coming_soon_circle,
            // Circle height constraint
            height: AppSpacing.dummy_size_coming_soon_circle,
            // Circle decoration configurations parameters options
            decoration: BoxDecoration(
              // Brand primary color with light transparency tint overlay
              color: AppColors.primary_color
                  .withValues(alpha: AppSpacing.dummy_opacity_active),
              // Circular bounding shape decoration
              shape: BoxShape.circle,
            ),
            // Construction icon widget representation
            child: const Icon(
              // Construction graphic icon token representation
              Icons.construction_rounded,
              // Graphic color matching brand primary accent
              color: AppColors.primary_color,
              // Icon display size constraint
              size: AppSpacing.dummy_size_coming_soon_icon,
            ),
          ),
          // Spacer height vertical offset
          const SizedBox(
            // Height spacing size value
            height: AppSpacing.space_xl,
          ),
          // Text widget displaying page section label title
          Text(
            // Screen title name string
            label,
            // Typography configurations style attributes options
            style: TextStyle(
              // Heading size parameters
              fontSize: AppSpacing.dummy_bottom_nav_item_radius,
              // Bold typography weight indicator
              fontWeight: FontWeight.w800,
              // Dynamic text color adjusting to brightness mode
              color: is_dark
                  ? AppColors.text_dark_primary
                  : AppColors.text_light_primary,
            ),
          ),
          // Spacer height vertical offset
          const SizedBox(
            // Height spacing size value
            height: AppSpacing.space_m,
          ),
          // Subhead text widget displaying Coming Soon messages
          Text(
            // Under construction string
            localizations.dummy_coming_soon,
            // Typography layouts style parameters options
            style: const TextStyle(
              // Small body font size
              fontSize: AppSpacing.font_size_subtitle,
              // Subtle grey color token
              color: AppColors.text_light_secondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget representation of the quick action buttons layout
class _QuickAction extends StatelessWidget {
  // Action button icon graphic representation
  final IconData icon;
  // Localized button label text
  final String label;
  // Theme color for backgrounds and graphical borders
  final Color color;

  // Constructor mapping required properties
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  // Build method drawing the quick action button box
  @override
  Widget build(BuildContext context) {
    // Return flexible expanded block taking equal widths inside parent row layouts
    return Expanded(
      // Main styling decoration container
      child: Container(
        // Padding inside boundary bounds
        padding: const EdgeInsets.symmetric(
          // Vertical padding value
          vertical: AppSpacing.dummy_quick_action_padding_vertical,
        ),
        // Layout decorations details representation
        decoration: BoxDecoration(
          // Light background tint using transparency modifiers
          color: color.withValues(alpha: AppSpacing.dummy_opacity_badge),
          // Rounded container corner configurations
          borderRadius: BorderRadius.circular(
            // Radius value using dummy constants token
            AppSpacing.dummy_quick_action_radius,
          ),
          // Outline border lines options representation
          border: Border.all(
            // Border color using transparency modifiers
            color: color.withValues(alpha: AppSpacing.dummy_opacity_border),
            // Explicit border width definition
            width: AppSpacing.border_width_thin,
          ),
        ),
        // Column stack positioning icon and label text
        child: Column(
          // Align children vertically centered
          children: [
            // Graphical icon representation widget
            Icon(
              // Icon graphic token
              icon,
              // Icon color mapping action themes
              color: color,
              // Icon display size bounds
              size: AppSpacing.dummy_quick_action_icon_size,
            ),
            // Spacer vertical height offset box
            const SizedBox(
              // Height spacing value
              height: AppSpacing.dummy_space_small,
            ),
            // Subhead label text displaying quick action titles
            Text(
              // Action label string
              label,
              // Center align multi-line labels text representation
              textAlign: TextAlign.center,
              // Typography layouts options
              style: TextStyle(
                // Typography size matching design specifications
                fontSize: AppSpacing.dummy_font_size_nav_label,
                // Bold typography indicator
                fontWeight: FontWeight.w600,
                // Color matching parent category accent theme colors
                color: color,
                // Line height multiplier factor
                height: AppSpacing.dummy_line_height_nav,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget representation of horizontal SpecialtyCategory items list chips
class _SpecialtyChip extends StatelessWidget {
  // Specialty category icon graphic representation
  final IconData icon;
  // Localized category title name
  final String label;
  // Graphic accent theme color
  final Color color;

  // Constructor mapping required properties
  const _SpecialtyChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  // Build method drawing the category card box
  @override
  Widget build(BuildContext context) {
    // Resolve dark mode active state context
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return container styling layout box boundaries
    return Container(
      // Right side margin spacing offset
      margin: const EdgeInsets.only(
        // Margin spacer value
        right: AppSpacing.dummy_specialty_chip_margin_right,
      ),
      // Padding inside container boundaries
      padding: const EdgeInsets.symmetric(
        // Horizontal padding value
        horizontal: AppSpacing.dummy_specialty_chip_padding_horizontal,
        // Vertical padding value
        vertical: AppSpacing.dummy_specialty_chip_padding_vertical,
      ),
      // Card decorations style mappings
      decoration: BoxDecoration(
        // Dynamic background surface color
        color: is_dark
            ? AppColors.surface_dark
            : AppColors.background_light,
        // Rounded container corners configurations
        borderRadius: BorderRadius.circular(
          // Radius token value
          AppSpacing.dummy_specialty_chip_radius,
        ),
        // Border line boundary decoration options
        border: Border.all(
          // Border outline colors matching dividers
          color:
              is_dark ? AppColors.border_dark : AppColors.border_light,
          // Explicit border width definition
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Column layout listing icon and text vertically
      child: Column(
        // Center content layout vertically inside container box
        mainAxisAlignment: MainAxisAlignment.center,
        // Chip elements list widgets
        children: [
          // Graphical icon representation widget
          Icon(
            // Icon graphic token
            icon,
            // Icon color mapping action themes
            color: color,
            // Icon display size bounds
            size: AppSpacing.dummy_quick_action_icon_size,
          ),
          // Spacer vertical height offset box
          const SizedBox(
            // Height spacing value
            height: AppSpacing.dummy_space_small,
          ),
          // Label text displaying category name
          Text(
            // Specialty category string
            label,
            // Typography styles configurations
            style: TextStyle(
              // Small font size mapping chip labels
              fontSize: AppSpacing.dummy_font_size_specialty,
              // Semi-bold typography indicator
              fontWeight: FontWeight.w600,
              // Dynamic text color adjusting to theme modes
              color: is_dark
                  ? AppColors.text_dark_primary
                  : AppColors.text_light_primary,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget representation of a Doctor card item displayed in lists
class _DoctorCard extends StatelessWidget {
  // Doctor name label
  final String name;
  // Specialty label description
  final String specialty;
  // Rating score value string
  final String rating;
  // Practice experience length details
  final String experience;
  // Accent color matching category chip
  final Color color;

  // Constructor mapping required properties
  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.color,
  });

  // Build method drawing the doctor card box
  @override
  Widget build(BuildContext context) {
    // Resolve dark mode active state context
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve localized strings dictionary reference
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Return gesture detector wrapping container applying border and backgrounds styling details
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.doctor_profile,
          arguments: 'doc_101',
        );
      },
      child: Container(
        // Padding inside card boundary lines
        padding: const EdgeInsets.all(
          // Padding value using dummy constants token
          AppSpacing.dummy_doctor_card_padding,
        ),
        // Card decorations style mappings
        decoration: BoxDecoration(
          // Dynamic background surface color
          color: is_dark
              ? AppColors.surface_dark
              : AppColors.background_light,
          // Rounded container corners configurations
          borderRadius: BorderRadius.circular(
            // Radius token value
            AppSpacing.dummy_doctor_card_radius,
          ),
          // Border line boundary decoration options
          border: Border.all(
          // Border outline colors matching dividers
          color:
              is_dark ? AppColors.border_dark : AppColors.border_light,
          // Explicit border width definition
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Row horizontal layout listing avatar, details column, and CTA button
      child: Row(
        // Main children list widgets
        children: [
          // Circular container mimicking doctor profile avatar picture
          Container(
            // Avatar width constraint
            width: AppSpacing.dummy_size_doctor_avatar,
            // Avatar height constraint
            height: AppSpacing.dummy_size_doctor_avatar,
            // Bounding shape styling configs options representation
            decoration: BoxDecoration(
              // Category color background with light transparency tint overlay
              color: color.withValues(alpha: AppSpacing.dummy_opacity_avatar),
              // Circular bounding shape decoration
              shape: BoxShape.circle,
            ),
            // Profile icon graphics representation
            child: Icon(
              // Profile icon token
              Icons.person_rounded,
              // Icon color matching parent category accent
              color: color,
              // Icon display size constraint
              size: AppSpacing.dummy_doctor_card_avatar_icon_size,
            ),
          ),
          // Separator vertical layout spacing box
          const SizedBox(
            // Spacer value
            width: AppSpacing.dummy_search_bar_padding_left,
          ),
          // Expanded column stack grouping info labels
          Expanded(
            // Vertical stack column layout
            child: Column(
              // Align text labels to start coordinates
              crossAxisAlignment: CrossAxisAlignment.start,
              // Info elements listing
              children: [
                // Doctor name text label representation
                Text(
                  // Name string
                  name,
                  // Typography layouts parameters options
                  style: TextStyle(
                    // Font size matching standard list headers
                    fontSize: AppSpacing.font_size_forgot_link +
                        AppSpacing.border_width_thin,
                    // Bold typographic weight indicator
                    fontWeight: FontWeight.w700,
                    // Dynamic text color adjusting to theme modes
                    color: is_dark
                        ? AppColors.text_dark_primary
                        : AppColors.text_light_primary,
                  ),
                ),
                // Spacer vertical height offset box
                const SizedBox(
                  // Height spacing value
                  height: AppSpacing.dummy_space_tiny,
                ),
                // Specialty title description text label
                Text(
                  // Specialty title string
                  specialty,
                  // Typography layout parameter details
                  style: const TextStyle(
                    // Small font size mapping subhead layouts
                    fontSize: AppSpacing.font_size_label,
                    // Subdued color representing text descriptions
                    color: AppColors.text_light_secondary,
                  ),
                ),
                // Spacer vertical height offset box
                const SizedBox(
                  // Height spacing value
                  height: AppSpacing.dummy_space_small,
                ),
                // Row container displaying rating score and practice experience details
                Row(
                  // Rating detail widgets listing horizontally
                  children: [
                    // Rating star icon representation widget
                    const Icon(
                      // Star graphic icon token representation
                      Icons.star_rounded,
                      // Yellow color matching ratings indications
                      color: AppColors.dummy_rating_star_yellow,
                      // Star size constraint
                      size: AppSpacing.dummy_doctor_card_rating_icon_size,
                    ),
                    // Spacer horizontal layout spacing box
                    const SizedBox(
                      // Spacer value
                      width: AppSpacing.dummy_space_tiny,
                    ),
                    // Rating score display label
                    Text(
                      // Score string value representation
                      rating,
                      // Typography styling configurations
                      style: TextStyle(
                        // Extra small font size
                        fontSize: AppSpacing.dummy_font_size_rating,
                        // Semi-bold typography indicator
                        fontWeight: FontWeight.w600,
                        // Dynamic text color adjusting to theme modes
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    // Spacer horizontal layout spacing box
                    const SizedBox(
                      // Spacer value
                      width: AppSpacing.dummy_search_bar_spacing,
                    ),
                    // Work bag experience icon representation widget
                    const Icon(
                      // Work bag icon token
                      Icons.work_outline_rounded,
                      // Icon color matching subtext descriptions
                      color: AppColors.text_light_secondary,
                      // Icon display size constraint
                      size: AppSpacing.dummy_doctor_card_work_icon_size,
                    ),
                    // Spacer horizontal layout spacing box
                    const SizedBox(
                      // Spacer value
                      width: AppSpacing.dummy_space_tiny,
                    ),
                    // Experience length text label representation
                    Text(
                      // Experience string value representation
                      experience,
                      // Typography configurations style options
                      style: const TextStyle(
                        // Extra small font size
                        fontSize: AppSpacing.dummy_font_size_rating,
                        // Subdued color representing text descriptions
                        color: AppColors.text_light_secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Book trigger button container mimicking click interaction
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.doctor_profile,
                arguments: 'doc_101',
              );
            },
            child: Container(
              // Padding offset inside button boundary lines
              padding: const EdgeInsets.symmetric(
                // Horizontal padding value
                horizontal: AppSpacing.dummy_doctor_card_btn_padding_horizontal,
                // Vertical padding value
                vertical: AppSpacing.dummy_doctor_card_btn_padding_vertical,
              ),
              // Background decorations config parameters
              decoration: BoxDecoration(
                // Solid brand primary color fill
                color: AppColors.primary_color,
                // Rounded card corners shape values
                borderRadius: BorderRadius.circular(
                  // Radius token value
                  AppSpacing.dummy_doctor_card_btn_radius,
                ),
              ),
              // Action label text representation
              child: Text(
                // Localized action button label string
                localizations.dummy_book,
                // Label text styling parameters options
                style: const TextStyle(
                  // White text color for contrast representation
                  color: AppColors.white,
                  // Small font size
                  fontSize: AppSpacing.font_size_label,
                  // Bold text weight representation
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

// TODO: END OF DUMMY HOME SCREEN IMPLEMENTATION

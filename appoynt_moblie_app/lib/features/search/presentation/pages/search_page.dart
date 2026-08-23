/*
 * File Name: search_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.1.0
 * Dependencies: flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   search_cubit.dart, search_state.dart, app_spacing.dart, app_colors.dart, app_network_image.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Renders the dedicated Search Screen with dynamic states (A, B, C), inputs, and filters.
 */

// TODO: START OF DUMMY HOME SCREEN IMPLEMENTATION - REMOVE ONCE FINAL HOME IS COMPLETED

// Import standard UI framework
import 'package:flutter/material.dart';
// Import lucide icons library
import 'package:lucide_icons_flutter/lucide_icons.dart';
// Import BLoC state provider
import 'package:flutter_bloc/flutter_bloc.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import search history item entity definition
import 'package:appoynt_mobile_app/features/search/domain/entities/search_history_item.dart';
// Import business logic cubit manager
import 'package:appoynt_mobile_app/features/search/presentation/cubit/search_cubit.dart';
// Import search state definitions class
import 'package:appoynt_mobile_app/features/search/presentation/cubit/search_state.dart';
// Import reusable bottom navigation bar component
import 'package:appoynt_mobile_app/core/widgets/app_bottom_nav_bar.dart';
// Import shared reusable doctor card widget
import 'package:appoynt_mobile_app/features/shared/widgets/doctor_card.dart';
// Import unified search sort bottom sheet modal
import 'package:appoynt_mobile_app/features/search/presentation/widgets/search_sort_bottom_sheet.dart';
import 'package:appoynt_mobile_app/core/routing/routes.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/pages/doctor_profile_page.dart';


// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double filter_button_size = 64.0;
  static const double border_radius_sheet = 24.0;
  static const double sort_chip_radius = 10.0;
  static const double sort_chip_padding_h = 10.0;
  static const double sort_chip_padding_v = 6.0;
}


// Main search screen gateway page widget
class SearchPage extends StatefulWidget {
  // Constant constructor initializing widget key
  const SearchPage({super.key});

  @override
  // Create search page state instance
  State<SearchPage> createState() {
    // Return state class representation
    return _SearchPageState();
  }
}

// State class managing text controller and focus nodes
class _SearchPageState extends State<SearchPage> {
  // Controller binding search text input field
  late final TextEditingController _query_controller;
  // Focus node programmatically requesting keyboard popup
  late final FocusNode _search_focus_node;

  @override
  // Initialize controller and request active focus post-frame
  void initState() {
    // Invoke parent initialization
    super.initState();
    // Instantiate text editing controller
    _query_controller = TextEditingController();
    // Instantiate search focus node
    _search_focus_node = FocusNode();

    // Listen to focus changes to dynamically update hint text placeholder
    _search_focus_node.addListener(() {
      // Rebuild the layout state when focus changes
      if (mounted) {
        setState(() {});
      } else {
        // Empty block
      }
    });

    // Schedule a delayed focus request to run after the Hero transition completes (FLT-02)
    Future.delayed(const Duration(milliseconds: 300), () {
      // Check if widget is still active and focus node can receive focus
      if (mounted && true == _search_focus_node.canRequestFocus) {
        // Request active focus to trigger keyboard popup and cursor display
        _search_focus_node.requestFocus();
      } else {
        // Empty block
      }
    });
  }

  @override
  // Dispose resources to prevent memory leaks
  void dispose() {
    // Dispose text editing controller
    _query_controller.dispose();
    // Dispose search focus node
    _search_focus_node.dispose();
    // Invoke parent resource hygiene cleanup
    super.dispose();
  }

  @override
  // Draw primary Scaffold tree and bind cubit provider
  Widget build(BuildContext context) {
    // Return BlocProvider exposing search cubit to descendant tree
    return BlocProvider<SearchCubit>(
      // Instantiate and register SearchCubit
      create: (context) {
        // Return cubit instance
        return SearchCubit();
      },
      // Expose build context builder
      child: BlocBuilder<SearchCubit, SearchState>(
        // Rebuild builder callback mapping states
        builder: (context, state) {
          // Resolve dark mode theme config context
          final bool is_dark = Theme.of(context).brightness == Brightness.dark;
          // Resolve localized string dictionary
          final AppLocalizations localizations = AppLocalizations.of(context);
          // Resolve active search cubit instance
          final SearchCubit cubit = BlocProvider.of<SearchCubit>(context);

          // Synchronize controller text with cubit state query (e.g. from history search tap)
          if (_query_controller.text != state.query) {
            // Apply text query synchronization
            _query_controller.text = state.query;
            // Place cursor pointer at end of input line
            _query_controller.selection = TextSelection.fromPosition(
              // Position cursor configuration
              TextPosition(
                // Set offset index to text length
                offset: state.query.length,
              ),
            );
          } else {
            // Empty block to satisfy compiler
          }

           // Return base scaffold widget applying off-white background
          return Scaffold(
            // Allow scaffold to resize viewInsets when soft keyboard is active
            resizeToAvoidBottomInset: true,
            // Stack overlaying alert confirmation dialogs above body (BR-11/FR-15 wrapper)
            body: Stack(
              // Draw child layouts
              children: [
                // Ignore background interactions if clear modal overlay is active
                IgnorePointer(
                  // Ignore flag mapping modal visibility
                  ignoring: state.is_confirm_modal_visible,
                  // Safe area placing core components with bottom inset disabled for keyboard
                  child: SafeArea(
                    bottom: false,
                    // Column listing search header, chip filters, dynamic body, and bottom nav
                    child: Column(
                      // Align layout children
                      children: [
                        // Padding container hosting search bar and filter chips
                        Padding(
                          // Edges padding configuration matching layout rules (including top notch safety spacing)
                          padding: const EdgeInsets.only(
                            left: AppSpacing.space_xl,
                            right: AppSpacing.space_xl,
                            top: AppSpacing.space_xl,
                            bottom: AppSpacing.space_l,
                          ),
                          // Vertical layout listing search bar and chips
                          child: Column(
                            // Align widgets to the start (left)
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // List widgets
                            children: [
                              // Column grouping screen titles and descriptions
                              Column(
                                // Align left
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Page Title: Search
                                  Text(
                                    localizations.search_screen_title,
                                    style: TextStyle(
                                      fontSize: AppSpacing.font_size_forgot_link + AppSpacing.border_width_thick,
                                      fontWeight: FontWeight.bold,
                                      color: is_dark
                                          ? AppColors.text_dark_primary
                                          : AppColors.search_text_slate,
                                    ),
                                  ),
                                  // Vertical separator
                                  const SizedBox(height: AppSpacing.space_xs),
                                  // Header Page Subtitle: Find doctors, clinics, specialties and more
                                  Text(
                                    localizations.search_screen_subtitle,
                                    style: const TextStyle(
                                      fontSize: AppSpacing.font_size_body_medium,
                                      color: AppColors.text_light_secondary,
                                    ),
                                  ),
                                ],
                              ),
                              // Vertical space gap between titles and search input bar
                              const SizedBox(
                                height: AppSpacing.space_xl,
                              ),
                              // Hero widget establishing morph transition mapping home bar (transition flow)
                              Hero(
                                // Match home search tag ID
                                tag: "search_bar",
                                // Material wrapper ensuring input text style renders properly during hero morphs
                                child: Material(
                                  // Fully transparent background representation
                                  color: AppColors.transparent,
                                  // Bounded box hosting search input field
                                  child: Container(
                                    // Height constraint matching design tokens
                                    height: AppSpacing.search_bar_height,
                                    // Bounding styling configurations options representation
                                    decoration: BoxDecoration(
                                      // Dynamic background surface color matching Home Screen
                                      color: is_dark ? AppColors.surface_dark : AppColors.background_light,
                                      // Capsule corner radius shape
                                      borderRadius: BorderRadius.circular(
                                        // Radius token value
                                        AppSpacing.search_bar_radius,
                                      ),
                                      // Border line boundary matching Home Screen
                                      border: Border.all(
                                        color: is_dark ? AppColors.border_dark : AppColors.border_light,
                                        width: AppSpacing.border_width_thin,
                                      ),
                                    ),
                                    // Raw input text field layout
                                    child: TextField(
                                      // Bind text editing controller
                                      controller: _query_controller,
                                      // Bind programmatic focus node
                                      focusNode: _search_focus_node,
                                      // Input query changed handler callback
                                      onChanged: (value) {
                                        // Forward query text to cubit processing
                                        cubit.on_query_changed(value);
                                      },
                                      // Set search text typography styles options
                                      style: TextStyle(
                                        // Standard input size
                                        fontSize: AppSpacing.font_size_text,
                                        // Input font weight
                                        fontWeight: FontWeight.normal,
                                        // Color mapping theme
                                        color: is_dark
                                            ? AppColors.text_dark_primary
                                            : AppColors.text_light_primary,
                                      ),
                                      // Decoration styling configuration options
                                      decoration: InputDecoration(
                                        // Suppress default borders
                                        border: InputBorder.none,
                                        // Suppress focused borders
                                        focusedBorder: InputBorder.none,
                                        // Suppress enabled borders
                                        enabledBorder: InputBorder.none,
                                        // Localized placeholder hint text representation (removed when focused)
                                        hintText: true == _search_focus_node.hasFocus
                                            ? ''
                                            : localizations.search_screen_hint,
                                        // Hint text style options
                                        hintStyle: const TextStyle(
                                          // Subdued color representation
                                          color: AppColors.text_light_secondary,
                                          // Small text size
                                          fontSize: AppSpacing.font_size_body_medium,
                                        ),
                                        // Far left magnifying glass icon decoration
                                        prefixIcon: const Icon(
                                          // Magnifying glass token icon
                                          Icons.search_rounded,
                                          // Subdued color representation
                                          color: AppColors.text_light_secondary,
                                          // Standard icon size
                                          size: AppSpacing.dummy_size_icon_notification,
                                        ),
                                        // Far right clear icon decoration (visible only if text exists)
                                        suffixIcon: true == state.query.isNotEmpty
                                            ? IconButton(
                                                // Clear text button icon
                                                icon: const Icon(
                                                  // Clear icon token
                                                  Icons.clear_rounded,
                                                  // Muted color representation
                                                  color: AppColors.text_light_secondary,
                                                ),
                                                // Clear text click handler callback
                                                onPressed: () {
                                                  // Reset controller string
                                                  _query_controller.clear();
                                                  // Inform cubit text has cleared
                                                  cubit.on_query_changed("");
                                                },
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Spacing height reserved below search input bar
                              const SizedBox(
                                // Spacing grid value
                                height: AppSpacing.space_l,
                              ),
                              // Row grouping filter chips underneath search bar
                              Row(
                                // Filter chips list
                                children: [
                                  // Location filter chip container representation
                                  Expanded(
                                    child: GestureDetector(
                                      // Click handler displaying location sheet dropdown selection
                                      onTap: () {
                                        // Show modal location sheet
                                        _show_location_picker(context, cubit, localizations);
                                      },
                                      // Custom chip widget decorator wrapper
                                      child: _FilterChip(
                                        // Left location pin icon representation
                                        icon: Icons.location_on_rounded,
                                        // Title text mapping header label
                                        title: localizations.search_location_chip,
                                        // Selected value or default
                                        value: true == state.selected_location_id.isEmpty
                                            ? localizations.search_location_default
                                            : state.selected_location_id,
                                        // Highlights chip if filter criteria is selected
                                        is_active: state.selected_location_id.isNotEmpty,
                                      ),
                                    ),
                                  ),
                                  // Separator layout gap
                                  const SizedBox(
                                    // Gap width spacing value
                                    width: AppSpacing.search_chips_gap,
                                  ),
                                  // Specialty filter chip container representation
                                  Expanded(
                                    child: GestureDetector(
                                      // Click handler displaying specialty sheet dropdown selection
                                      onTap: () {
                                        // Show modal specialty sheet
                                        _show_specialty_picker(context, cubit, localizations);
                                      },
                                      // Custom chip widget decorator wrapper
                                      child: _FilterChip(
                                        // Left stethoscope medical icon representation
                                        icon: Icons.medical_services_outlined,
                                        // Title text mapping header label
                                        title: localizations.search_specialty_chip,
                                        // Selected value or default
                                        value: true == state.selected_specialty_id.isEmpty
                                            ? localizations.search_specialty_default
                                            : state.selected_specialty_id,
                                        // Highlights chip if filter criteria is selected
                                        is_active: state.selected_specialty_id.isNotEmpty,
                                      ),
                                    ),
                                  ),
                                  // Separator layout gap
                                  const SizedBox(
                                    // Gap width spacing value
                                    width: AppSpacing.search_chips_gap,
                                  ),
                                  // Advanced filters button (sliders icon as in mock-up)
                                  GestureDetector(
                                    // Click handler displaying advanced filters bottom sheet
                                    onTap: () {
                                      // Show modal advanced filters sheet
                                      _show_advanced_filters(context, cubit, localizations, is_dark);
                                    },
                                    // Styling container box
                                    child: Container(
                                      // Fixed width matching height (square button)
                                      width: _LocalDimensions.filter_button_size,
                                      // Matching height of the other filter chips
                                      height: _LocalDimensions.filter_button_size,
                                      // Styling decorations
                                      decoration: BoxDecoration(
                                        // Light blue background tint matching mock-up
                                        color: is_dark
                                            ? AppColors.surface_dark
                                            : const Color(0xFFE8F1FF),
                                        // Rounded corner radius matching chips
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.search_chip_radius,
                                        ),
                                        // Solid blue border outline matching active brand highlights
                                        border: Border.all(
                                          color: AppColors.primary_color,
                                          width: AppSpacing.border_width_thin,
                                        ),
                                      ),
                                      // Display sliders icon
                                      child: const Icon(
                                        // Sliders horizontal layout icon
                                        LucideIcons.sliders,
                                        // Blue color highlighting active button actions
                                        color: AppColors.primary_color,
                                        // Standard icon size
                                        size: AppSpacing.search_nav_icon_size,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Expanded view displaying active dynamic body state
                        Expanded(
                          // Switch widget representing different search statuses (dynamic body states)
                          child: _build_dynamic_body(context, state, cubit, localizations, is_dark),
                        ),
                        // Fixed Bottom Navigation Bar component shown only when soft keyboard is closed
                        if (0 == MediaQuery.of(context).viewInsets.bottom)
                          AppBottomNavBar(
                            // Highlight Search tab as active index 2
                            selected_index: 2,
                          // Handle tap on navigation items
                          on_tap: (index) {
                            // Check if page remains mounted using Yoda style check
                            if (true == context.mounted) {
                              // If search tab is tapped, do nothing since we are already on search page
                              if (2 == index) {
                                // Do nothing
                              } else {
                                // Dismiss dedicated search screen returning the selected index to the home screen
                                Navigator.of(context).pop(index);
                              }
                            } else {
                              // Empty block
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // confirmation overlay alert modal dialog (State A confirmation overlay)
                if (true == state.is_confirm_modal_visible)
                  // Full screen blur overlay layout
                  Container(
                    // Modal barrier color background fill matching tokens
                    color: AppColors.search_modal_barrier,
                    // Center alert dialog popup
                    child: Center(
                      // Confirmation dialogue box container
                      child: Container(
                        // Box width constraint size
                        width: AppSpacing.size_logo_box - AppSpacing.dummy_coming_soon_radius,
                        // Box padding margins configurations
                        padding: const EdgeInsets.all(
                          // Padding spacing value
                          AppSpacing.dummy_padding_home,
                        ),
                        // Card decoration styling options representation
                        decoration: BoxDecoration(
                          // Solid dialog background fill
                          color: is_dark ? AppColors.surface_dark : AppColors.search_alert_modal_bg,
                          // Rounded container corners
                          borderRadius: BorderRadius.circular(
                            // Radius value token
                            AppSpacing.dummy_doctor_card_radius,
                          ),
                        ),
                        // Column grouping alert text and action buttons
                        child: Column(
                          // Wrap content size vertically
                          mainAxisSize: MainAxisSize.min,
                          // Listing
                          children: [
                            // Info text warning patient user
                            Text(
                              // Localized warning message
                              localizations.search_clear_all_confirm_title,
                              // Center text alignments
                              textAlign: TextAlign.center,
                              // Style options
                              style: TextStyle(
                                // Medium text size
                                fontSize: AppSpacing.font_size_text,
                                // Semi-bold typographic weight
                                fontWeight: FontWeight.w600,
                                // Color mapping theme
                                color: is_dark
                                    ? AppColors.text_dark_primary
                                    : AppColors.text_light_primary,
                              ),
                            ),
                            // Separator height spacer box
                            const SizedBox(
                              // Height value
                              height: AppSpacing.space_xxl,
                            ),
                            // Row listing Cancel and Clear All CTA buttons horizontally
                            Row(
                              // Distribute elements equally
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // Actions list
                              children: [
                                // Cancel dismiss button widget
                                TextButton(
                                  // Click handler callback
                                  onPressed: () {
                                    // Forward cancel request to search cubit
                                    cubit.cancel_clear_history();
                                  },
                                  // Label text
                                  child: Text(
                                    // Localized cancel string
                                    localizations.search_cancel_button,
                                    // Style options
                                    style: const TextStyle(
                                      // Muted color representation
                                      color: AppColors.text_light_secondary,
                                      // Bold text weight
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Clear All confirm button widget
                                ElevatedButton(
                                  // Click handler callback
                                  onPressed: () {
                                    // Forward confirmation request to search cubit
                                    cubit.confirm_clear_history();
                                  },
                                  // Styling configurations parameters options
                                  style: ElevatedButton.styleFrom(
                                    // Brand primary color background fill
                                    backgroundColor: AppColors.primary_color,
                                    // Rounded corner values
                                    shape: RoundedRectangleBorder(
                                      // Bounding shape border radius configs
                                      borderRadius: BorderRadius.circular(
                                        // Radius token value
                                        AppSpacing.dummy_bottom_nav_item_radius,
                                      ),
                                    ),
                                  ),
                                  // Label text representation
                                  child: Text(
                                    // Localized clear all string
                                    localizations.search_clear_all_button,
                                    // Style options
                                    style: const TextStyle(
                                      // White text color contrast
                                      color: AppColors.white,
                                      // Bold weight
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  // Empty layout satisfying compiler condition
                  const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Bottom modal location picker selector sheets
  void _show_location_picker(BuildContext context, SearchCubit cubit, AppLocalizations localizations) {
    // Array listing available locations data mocks
    final List<String> locations = ["Cairo", "Giza", "Alexandria"];

    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Render bottom sheet dialog
    showModalBottomSheet(
      // Expose build context
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      // Widget builder compiling selector rows list
      builder: (context) {
        // Return column list listing options
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(_LocalDimensions.border_radius_sheet),
            ),
          ),
          // Padding container edges configurations
          padding: const EdgeInsets.symmetric(
            // Vertical padding
            vertical: AppSpacing.space_xl,
          ),
          // Wrap content size vertically
          child: Column(
            // Wrap vertical sizing
            mainAxisSize: MainAxisSize.min,
            // Listing items
            children: [
              // Header title indicator text
              Text(
                // Localized location chip label
                localizations.search_location_chip,
                // Styling text configurations options
                style: const TextStyle(
                  // Font weight bold
                  fontWeight: FontWeight.bold,
                  // Text header size
                  fontSize: AppSpacing.font_size_forgot_link + AppSpacing.border_width_thick,
                ),
              ),
              // Separator divider line
              const Divider(),
              // Generate selection list items
              ...locations.map((loc) {
                // Return row tile selection
                return ListTile(
                  // Display text location name
                  title: Text(loc),
                  // Left check mark indicator icon (visible if active)
                  trailing: cubit.state.selected_location_id == loc
                      ? const Icon(Icons.check_rounded, color: AppColors.primary_color)
                      : null,
                  // Selection handler callback
                  onTap: () {
                    // Update location filter selection criteria
                    cubit.select_location(cubit.state.selected_location_id == loc ? "" : loc);
                    // Dismiss modal sheet
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Bottom modal specialty picker selector sheets
  void _show_specialty_picker(BuildContext context, SearchCubit cubit, AppLocalizations localizations) {
    // Array listing available specialties data mocks
    final List<String> specialties = ["Cardiology", "Neurology", "Pediatrics"];

    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Render bottom sheet dialog
    showModalBottomSheet(
      // Expose build context
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      // Widget builder compiling selector rows list
      builder: (context) {
        // Return column list listing options
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(_LocalDimensions.border_radius_sheet),
            ),
          ),
          // Padding container edges configurations
          padding: const EdgeInsets.symmetric(
            // Vertical padding
            vertical: AppSpacing.space_xl,
          ),
          // Wrap content size vertically
          child: Column(
            // Wrap vertical sizing
            mainAxisSize: MainAxisSize.min,
            // Listing items
            children: [
              // Header title indicator text
              Text(
                // Localized specialty chip label
                localizations.search_specialty_chip,
                // Styling text configurations options
                style: const TextStyle(
                  // Font weight bold
                  fontWeight: FontWeight.bold,
                  // Text header size
                  fontSize: AppSpacing.font_size_forgot_link + AppSpacing.border_width_thick,
                ),
              ),
              // Separator divider line
              const Divider(),
              // Generate selection list items
              ...specialties.map((spec) {
                // Return row tile selection
                return ListTile(
                  // Display text specialty name
                  title: Text(spec),
                  // Left check mark indicator icon (visible if active)
                  trailing: cubit.state.selected_specialty_id == spec
                      ? const Icon(Icons.check_rounded, color: AppColors.primary_color)
                      : null,
                  // Selection handler callback
                  onTap: () {
                    // Update specialty filter selection criteria
                    cubit.select_specialty(cubit.state.selected_specialty_id == spec ? "" : spec);
                    // Dismiss modal sheet
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Switch helper returning appropriate dynamic widgets list matching state status
  Widget _build_dynamic_body(
    BuildContext context,
    SearchState state,
    SearchCubit cubit,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Switch state status mapping enum cases
    switch (state.status) {
      // Show search loading skeletons (Loading State)
      case SearchStatus.loading:
        // Return ListView compiling shimmer simulator boxes
        return ListView.builder(
          // Static skeleton card rows count limit
          itemCount: 4,
          // Build layout template placeholder card
          itemBuilder: (context, index) {
            // Return container representing loading skeleton row cards
            return Container(
              // Margin spacing surrounding skeletons cards
              margin: const EdgeInsets.symmetric(
                // Horizontal spacing
                horizontal: AppSpacing.space_xl,
                // Vertical spacing
                vertical: AppSpacing.space_m,
              ),
              // Skeletons box dimensions constraints (matching 68px row height)
              height: AppSpacing.search_row_height,
              // Card decorations style mappings
              decoration: BoxDecoration(
                // Dynamic surface background tint color
                color: is_dark ? AppColors.surface_dark : AppColors.search_chip_bg,
                // Rounded corner values
                borderRadius: BorderRadius.circular(
                  // Radius token
                  AppSpacing.search_chip_radius,
                ),
              ),
              // Horizontal row placeholder templates representation
              child: Row(
                // Children list
                children: [
                  // Spacer spacing vertical offset
                  const SizedBox(width: AppSpacing.space_xl),
                  // Simulated doctor profile avatar circle widget
                  CircleAvatar(
                    // Radius dimension mapping matching doctor suggestions
                    radius: AppSpacing.search_avatar_size / AppSpacing.border_width_thick,
                    // Subdued color fill representing shimmer background
                    backgroundColor: is_dark ? AppColors.background_dark : AppColors.background_light,
                  ),
                  // Separator spacer gap
                  const SizedBox(width: AppSpacing.space_xl),
                  // Simulated doctor name line bar template
                  Container(
                    // Simulated label width constraint
                    width: AppSpacing.size_logo_login,
                    // Simulated label height constraint
                    height: AppSpacing.dummy_search_bar_radius,
                    // Bounding shape configurations parameters options representation
                    decoration: BoxDecoration(
                      // Subdued color fill
                      color: is_dark ? AppColors.background_dark : AppColors.background_light,
                      // Rounded corners borders representation
                      borderRadius: BorderRadius.circular(
                        // Radius value
                        AppSpacing.radius_s,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

      // Show suggestions list cards matching queries input (State B Autocomplete suggestions)
      case SearchStatus.suggestionsLoaded:
        final int count = state.suggestions.length;
        final String count_label = (1 == count)
            ? localizations.favorites_count_single
            : localizations.favorites_count_plural(count);
        final String sort_label = _get_sort_label(state.selected_sort_option, localizations);

        return Column(
          children: [
            // Count indicator & Sort Trigger Pill Row matching FavoritesPage
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space_xl,
                vertical: AppSpacing.space_m,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Result count text
                  Text(
                    count_label,
                    style: TextStyle(
                      fontSize: AppSpacing.font_size_body_small,
                      fontWeight: FontWeight.w600,
                      color: is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary,
                    ),
                  ),
                  // Right: Sort Trigger Pill / Chip button
                  InkWell(
                    onTap: () {
                      show_search_sort_bottom_sheet(
                        context: context,
                        current_sort: state.selected_sort_option,
                        on_apply: (selected_sort) {
                          cubit.select_sort_option(selected_sort);
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(_LocalDimensions.sort_chip_radius),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _LocalDimensions.sort_chip_padding_h,
                        vertical: _LocalDimensions.sort_chip_padding_v,
                      ),
                      decoration: BoxDecoration(
                        color: is_dark
                            ? AppColors.primary_color.withValues(alpha: 0.15)
                            : AppColors.primary_color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(_LocalDimensions.sort_chip_radius),
                        border: Border.all(
                          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
                          width: AppSpacing.border_width_thin,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sort_rounded,
                            size: AppSpacing.font_size_body_medium,
                            color: AppColors.primary_color,
                          ),
                          const SizedBox(width: AppSpacing.space_xs),
                          Text(
                            sort_label,
                            style: const TextStyle(
                              fontSize: AppSpacing.font_size_body_small,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary_color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable list view of Doctor Cards
            Expanded(

              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space_xl,
                ),
                itemCount: state.suggestions.length,
                itemBuilder: (context, index) {
                  final doc = state.suggestions[index];
                  return DoctorCard(
                    doctor_name: doc.name,
                    specialization: doc.specialty,
                    location: doc.location,
                    rating: doc.rating,
                    review_count: doc.reviews_count,
                    price: doc.fee.toDouble(),
                    is_available: doc.is_available_today,
                    is_favorite: doc.is_favorite,
                    avatar_url: doc.avatar_url,
                    on_tap: () {
                      Navigator.of(context).pushNamed(
                        Routes.doctor_profile,
                        arguments: DoctorProfileArgs(doctor_id: doc.doctor_id),
                      );
                    },
                    on_book_tap: () {
                      Navigator.of(context).pushNamed(
                        Routes.doctor_profile,
                        arguments: DoctorProfileArgs(doctor_id: doc.doctor_id),
                      );
                    },
                    on_favorite_tap: () {
                      cubit.toggle_favorite(doc.doctor_id);
                    },
                  );
                },
              ),
            ),
          ],
        );

      // Show filter-only CTA button when query is empty but filter is active (State C)
      case SearchStatus.filtersOnly:
        // Return centered column contents layout
        return Center(
          // Vertical layout listing illustrations and button triggers
          child: Column(
            // Center content inside space constraints
            mainAxisAlignment: MainAxisAlignment.center,
            // Children widgets listing
            children: [
              // Clean medical illustration icon graphic representation (magnifying glass)
              const Icon(
                // Search icon graphic representation
                Icons.search_off_rounded,
                // Subdued light gray color fill
                color: AppColors.text_light_secondary,
                // Large display bounds dimension
                size: AppSpacing.dummy_size_coming_soon_circle,
              ),
              // Spacing separator vertical height offset box
              const SizedBox(
                // Height spacer value
                height: AppSpacing.space_xl,
              ),
              // Primary CTA action button triggering filtered lookup results (FR-40 CTA)
              ElevatedButton(
                // Click handler callback routing to results (simulated print toast)
                onPressed: () {
                  // Forward reveal request to search cubit to trigger results list (State C to State B)
                  cubit.reveal_filtered_results();
                },
                // Button style options representation
                style: ElevatedButton.styleFrom(
                  // Primary brand color fill
                  backgroundColor: AppColors.primary_color,
                  // Outer padding bounding button edges
                  padding: const EdgeInsets.symmetric(
                    // Horizontal offset
                    horizontal: AppSpacing.space_xxl,
                    // Vertical offset
                    vertical: AppSpacing.space_l,
                  ),
                  // Rounded corner radius settings
                  shape: RoundedRectangleBorder(
                    // Bounding shape border radius configs
                    borderRadius: BorderRadius.circular(
                      // Radius token value
                      AppSpacing.dummy_doctor_card_btn_radius,
                    ),
                  ),
                ),
                // Button label text representation
                child: Text(
                  // Localized view all filtered results button string
                  localizations.search_view_all_filtered_results,
                  // Text style options
                  style: const TextStyle(
                    // White text color contrast
                    color: AppColors.white,
                    // Bold weight
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );

      // Show no matching results indicator layout (No-Results State)
      case SearchStatus.empty:
        // Return centered text box
        return Center(
          // Vertical column grouping descriptions
          child: Column(
            // Center widgets
            mainAxisAlignment: MainAxisAlignment.center,
            // Elements
            children: [
              // Warning details icon
              const Icon(
                // Empty search result icons token representation
                Icons.find_in_page_outlined,
                // Subdued color representation
                color: AppColors.text_light_secondary,
                // Large size
                size: AppSpacing.dummy_size_coming_soon_circle,
              ),
              // Spacer box
              const SizedBox(height: AppSpacing.space_xl),
              // Feedback message text label
              Text(
                // Localized empty state message
                localizations.search_no_results,
                // Style options
                style: TextStyle(
                  // Title text sizes bounds
                  fontSize: AppSpacing.font_size_forgot_link + AppSpacing.border_width_thin,
                  // Bold typographic weight
                  fontWeight: FontWeight.w600,
                  // Muted color theme matching headings
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_secondary,
                ),
              ),
            ],
          ),
        );

      // Show offline connection failure state with a Retry action button (Offline State)
      case SearchStatus.offlineError:
        // Return centered warning box
        return Center(
          // Column stack grouping layout widgets
          child: Padding(
            // Margin boundaries padding
            padding: const EdgeInsets.symmetric(
              // Horizontal padding offset
              horizontal: AppSpacing.space_xxl,
            ),
            // Listing details
            child: Column(
              // Center column content vertical axes alignment
              mainAxisAlignment: MainAxisAlignment.center,
              // Elements listing
              children: [
                // Network signal connection error status graphic icon representation
                const Icon(
                  // Signal wifi bad status indicator icon token representation
                  Icons.signal_wifi_bad_rounded,
                  // Cardiology red alert color mapping token
                  color: AppColors.dummy_custom_red,
                  // Large size
                  size: AppSpacing.dummy_size_coming_soon_circle,
                ),
                // Spacer height box
                const SizedBox(height: AppSpacing.space_xl),
                // Descriptive connection failure explanation warning labels text
                Text(
                  // Localized offline error warning description details
                  localizations.search_offline_error,
                  // Center aligned paragraphs layout text representation
                  textAlign: TextAlign.center,
                  // Style options
                  style: TextStyle(
                    // Standard body size
                    fontSize: AppSpacing.font_size_text,
                    // Medium typographic weight
                    fontWeight: FontWeight.w500,
                    // Color matching theme
                    color: is_dark
                        ? AppColors.text_dark_primary
                        : AppColors.text_light_primary,
                  ),
                ),
                // Separator vertical height offset box
                const SizedBox(height: AppSpacing.space_xl),
                // Retry action trigger button widget (Retry CTA button)
                ElevatedButton.icon(
                  // Click handler invoking retry logic callback
                  onPressed: () {
                    // Forward retry command to cubit processing
                    cubit.retry_search();
                  },
                  // Retry icon graphic representation
                  icon: const Icon(
                    // Refresh icon token representation
                    Icons.refresh_rounded,
                    // Match white text contrast colors
                    color: AppColors.white,
                  ),
                  // Localized label string
                  label: Text(
                    // Localized retry string
                    localizations.search_retry_button,
                    // Style options
                    style: const TextStyle(
                      // White text color contrast
                      color: AppColors.white,
                      // Bold weight
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Button design styles configs parameters options
                  style: ElevatedButton.styleFrom(
                    // Brand primary color fill
                    backgroundColor: AppColors.primary_color,
                    // Outer padding constraints bounding borders
                    padding: const EdgeInsets.symmetric(
                      // Horizontal offset spacing value
                      horizontal: AppSpacing.space_xxl,
                      // Vertical offset spacing value
                      vertical: AppSpacing.space_l,
                    ),
                    // Rounded corner values
                    shape: RoundedRectangleBorder(
                      // Bounding shape border radius configs
                      borderRadius: BorderRadius.circular(
                        // Radius token value
                        AppSpacing.dummy_doctor_card_btn_radius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      // Default Active History state displaying history queries list (State A)
      case SearchStatus.historyLoaded:
      case SearchStatus.initial:
        // Check if recent search history list is empty using Yoda style check
        if (true == state.recent_searches.isEmpty) {
          // Return empty layout placeholder if no history items exist
          return const SizedBox.shrink();
        } else {
          // Empty block to satisfy compiler
        }

        // Return scrollable column listing recent search history items
        return Column(
          // Align header text to start coordinates
          crossAxisAlignment: CrossAxisAlignment.start,
          // List widgets
          children: [
            // Row grouping Section Header title 'RECENT SEARCHES' and clickable 'Clear' action link
            Padding(
              // Padding constraints configs matching token values
              padding: const EdgeInsets.symmetric(
                // Horizontal spacing margin edge offset
                horizontal: AppSpacing.space_xl,
                // Vertical spacing margin edge offset
                vertical: AppSpacing.space_m,
              ),
              // Horizontal row alignment
              child: Row(
                // Distribute items
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Text columns
                children: [
                  // Localized section header title text (Typography: 12px Bold, Muted Gray, uppercase)
                  Text(
                    // Localized recent searches uppercase section title text
                    localizations.search_recent_searches_title,
                    // Style options
                    style: const TextStyle(
                      // Font size matching specifications (12px)
                      fontSize: AppSpacing.dummy_font_size_rating,
                      // Bold typographic weight
                      fontWeight: FontWeight.bold,
                      // Muted gray color representation
                      color: AppColors.search_text_muted,
                    ),
                  ),
                  // Right-aligned clickable text "Clear" button (FR-27 Clear history action)
                  GestureDetector(
                    // Click handler displaying confirmation modal dialog popup
                    onTap: () {
                      // Trigger confirmation overlay dialog inside cubit state
                      cubit.clear_history();
                    },
                    // Action label text
                    child: Text(
                      // Localized clear label text string
                      localizations.search_clear_action,
                      // Text styling options
                      style: const TextStyle(
                        // Primary brand accent color represent
                        color: AppColors.primary_color,
                        // Bold weight indicator
                        fontWeight: FontWeight.bold,
                        // Small label size
                        fontSize: AppSpacing.font_size_label,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded scrollable list displaying max 5 recent search history rows (BR-35/FR-35)
            Expanded(
              // Scrollable list builder compiling history entries
              child: ListView.builder(
                // Limit list to display maximum 5 elements comfortably (BR-35 Comfort rule)
                itemCount: true == state.recent_searches.length > 5 ? 5 : state.recent_searches.length,
                // Compile history rows widgets
                itemBuilder: (context, index) {
                  // Resolve history entry item from array index
                  final SearchHistoryItem history_item = state.recent_searches[index];

                  // Return row layout representing search history entry
                  return ListTile(
                    // Edges margin indentation matching side bounds
                    contentPadding: const EdgeInsets.symmetric(
                      // Horizontal boundary offset
                      horizontal: AppSpacing.space_xl,
                    ),
                    // Left history icon graphics (clock/history vector icon)
                    leading: const Icon(
                      // Clock/History icon representation
                      Icons.history_rounded,
                      // Muted gray color fill
                      color: AppColors.text_light_secondary,
                      // Standard icon size
                      size: AppSpacing.dummy_size_icon_notification,
                    ),
                    // Clickable history search query text description labels
                    title: Text(
                      // Query string details
                      history_item.query,
                      // Text style options
                      style: TextStyle(
                        // Standard body text size
                        fontSize: AppSpacing.font_size_text,
                        // Color matching theme
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                    // Right individual item delete action button (small close X icon)
                    trailing: IconButton(
                      // Small close 'X' icon graphic representation
                      icon: const Icon(
                        // Close icon token representation
                        Icons.close_rounded,
                        // Muted color representation
                        color: AppColors.text_light_secondary,
                      ),
                      // Click handler deleting individual item (BR-21/FR-34)
                      onPressed: () {
                        // Forward deletion command to cubit processing
                        cubit.delete_history_item(history_item.id);
                      },
                    ),
                    // Row selection handler executing history query lookup immediately (BR-05/FR-03)
                    onTap: () {
                      // Execute search criteria directly using history item
                      cubit.execute_history_search(history_item);
                    },
                  );
                },
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Bottom modal advanced filters selector sheet
  void _show_advanced_filters(
      BuildContext context, SearchCubit cubit, AppLocalizations localizations, bool is_dark) {
    // Temporary variables to track local selection states before applying
    String temp_gender = cubit.state.selected_gender;
    String temp_price = cubit.state.selected_price_range;
    String temp_rating = cubit.state.selected_rating;

    // Render bottom sheet dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (context) {
        // Return StatefulBuilder to enable local state updates inside modal
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: is_dark ? AppColors.surface_dark : AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_LocalDimensions.border_radius_sheet),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.space_xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Close Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.search_filter_title,
                        style: const TextStyle(
                          fontSize: AppSpacing.font_size_forgot_link + AppSpacing.border_width_thick,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: AppSpacing.space_l),

                  // Section 1: Doctor Gender
                  Text(
                    localizations.search_filter_gender_title,
                    style: const TextStyle(
                      fontSize: AppSpacing.font_size_label,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space_m),
                  Row(
                    children: [
                      _build_modal_chip(
                        label: localizations.search_filter_gender_male,
                        is_selected: "Male" == temp_gender,
                        on_tap: () {
                          setModalState(() {
                            temp_gender = "Male" == temp_gender ? "" : "Male";
                          });
                        },
                        is_dark: is_dark,
                      ),
                      const SizedBox(width: AppSpacing.space_m),
                      _build_modal_chip(
                        label: localizations.search_filter_gender_female,
                        is_selected: "Female" == temp_gender,
                        on_tap: () {
                          setModalState(() {
                            temp_gender = "Female" == temp_gender ? "" : "Female";
                          });
                        },
                        is_dark: is_dark,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space_xl),

                  // Section 2: Consultation Fee
                  Text(
                    localizations.search_filter_price_title,
                    style: const TextStyle(
                      fontSize: AppSpacing.font_size_label,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space_m),
                  Wrap(
                    spacing: AppSpacing.space_m,
                    runSpacing: AppSpacing.space_m,
                    children: [
                      _build_modal_chip(
                        label: localizations.search_filter_price_under_100,
                        is_selected: "Under 100" == temp_price,
                        on_tap: () {
                          setModalState(() {
                            temp_price = "Under 100" == temp_price ? "" : "Under 100";
                          });
                        },
                        is_dark: is_dark,
                      ),
                      _build_modal_chip(
                        label: localizations.search_filter_price_100_200,
                        is_selected: "100-200" == temp_price,
                        on_tap: () {
                          setModalState(() {
                            temp_price = "100-200" == temp_price ? "" : "100-200";
                          });
                        },
                        is_dark: is_dark,
                      ),
                      _build_modal_chip(
                        label: localizations.search_filter_price_200_500,
                        is_selected: "200-500" == temp_price,
                        on_tap: () {
                          setModalState(() {
                            temp_price = "200-500" == temp_price ? "" : "200-500";
                          });
                        },
                        is_dark: is_dark,
                      ),
                      _build_modal_chip(
                        label: localizations.search_filter_price_above_500,
                        is_selected: "Above 500" == temp_price,
                        on_tap: () {
                          setModalState(() {
                            temp_price = "Above 500" == temp_price ? "" : "Above 500";
                          });
                        },
                        is_dark: is_dark,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space_xl),

                  // Section 3: Doctor Rating
                  Text(
                    localizations.search_filter_rating_title,
                    style: const TextStyle(
                      fontSize: AppSpacing.font_size_label,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space_m),
                  Wrap(
                    spacing: AppSpacing.space_m,
                    runSpacing: AppSpacing.space_m,
                    children: [
                      _build_modal_chip(
                        label: localizations.search_filter_rating_5,
                        is_selected: "5 Stars" == temp_rating,
                        on_tap: () {
                          setModalState(() {
                            temp_rating = "5 Stars" == temp_rating ? "" : "5 Stars";
                          });
                        },
                        is_dark: is_dark,
                      ),
                      _build_modal_chip(
                        label: localizations.search_filter_rating_4,
                        is_selected: "4+ Stars" == temp_rating,
                        on_tap: () {
                          setModalState(() {
                            temp_rating = "4+ Stars" == temp_rating ? "" : "4+ Stars";
                          });
                        },
                        is_dark: is_dark,
                      ),
                      _build_modal_chip(
                        label: localizations.search_filter_rating_3,
                        is_selected: "3+ Stars" == temp_rating,
                        on_tap: () {
                          setModalState(() {
                            temp_rating = "3+ Stars" == temp_rating ? "" : "3+ Stars";
                          });
                        },
                        is_dark: is_dark,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space_xxl),

                  // Actions Row: Reset & Apply
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              temp_gender = "";
                              temp_price = "";
                              temp_rating = "";
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary_color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
                            ),
                          ),
                          child: Text(
                            localizations.search_filter_reset,
                            style: const TextStyle(
                              color: AppColors.primary_color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space_m),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            cubit.apply_advanced_filters(
                              gender: temp_gender,
                              price_range: temp_price,
                              rating: temp_rating,
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary_color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
                            ),
                          ),
                          child: Text(
                            localizations.search_filter_apply,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space_l),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Custom helper to build Choice Chips in modal filters dialog
  Widget _build_modal_chip({
    required String label,
    required bool is_selected,
    required VoidCallback on_tap,
    required bool is_dark,
  }) {
    return GestureDetector(
      onTap: on_tap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space_xl,
          vertical: AppSpacing.space_m,
        ),
        decoration: BoxDecoration(
          color: is_selected
              ? AppColors.primary_color
              : (is_dark ? AppColors.surface_dark : const Color(0xFFF2F4F7)),
          borderRadius: BorderRadius.circular(AppSpacing.radius_l),
          border: Border.all(
            color: is_selected
                ? AppColors.primary_color
                : (is_dark ? AppColors.border_dark : const Color(0xFFE4E7EC)),
            width: AppSpacing.border_width_thin,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: is_selected
                ? AppColors.white
                : (is_dark ? AppColors.text_dark_secondary : AppColors.search_text_slate),
            fontWeight: is_selected ? FontWeight.bold : FontWeight.normal,
            fontSize: AppSpacing.font_size_label,
          ),
        ),
      ),
    );
  }

  // Helper method returning the localized string representation of a sorting option
  String _get_sort_label(SearchSortOption option, AppLocalizations localizations) {
    switch (option) {
      case SearchSortOption.recentlyAdded:
        return localizations.search_sort_recently_added;
      case SearchSortOption.nameAToZ:
        return localizations.search_sort_name_a_to_z;
      case SearchSortOption.nameZToA:
        return localizations.search_sort_name_z_to_a;
      case SearchSortOption.ratingHighToLow:
        return localizations.search_sort_rating_high_to_low;
      case SearchSortOption.feeLowToHigh:
        return localizations.search_sort_fee_low_to_high;
      case SearchSortOption.feeHighToLow:
        return localizations.search_sort_fee_high_to_low;
      default:
        return localizations.search_sort_recently_added;
    }
  }
}

// Custom internal stateless widget constructing Location and Specialty filter chips

class _FilterChip extends StatelessWidget {
  // Leading icon graphic asset representation
  final IconData icon;
  // Header title label string (e.g. Location or Specialty)
  final String title;
  // Selected value display string
  final String value;
  // Active highlight state indicator flag
  final bool is_active;

  // Constant constructor mapping properties
  const _FilterChip({
    required this.icon,
    required this.title,
    required this.value,
    required this.is_active,
  });

  @override
  // Render chip components layout box
  Widget build(BuildContext context) {
    // Resolve dark mode active status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return container applying shape dimensions and borders bounds
    return Container(
      // Height matching design tokens (64px spec height to fit double lines)
      height: _LocalDimensions.filter_button_size,
      // Padding margins within chip boundary lines
      padding: const EdgeInsets.symmetric(
        // Horizontal padding offset
        horizontal: AppSpacing.space_l,
      ),
      // Layout decorations style details
      decoration: BoxDecoration(
        // White background matching the screenshot
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        // Rounded chip corner radius (16px spec radius)
        borderRadius: BorderRadius.circular(
          // Radius value
          AppSpacing.search_chip_radius + AppSpacing.radius_s,
        ),
        // Outline border lines options representation
        border: Border.all(
          // Light blue border outline matching the screenshot
          color: is_dark ? AppColors.border_dark : AppColors.pale_blue,
          // Explicit thin line width
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Horizontal row grouping leading icon, text column, and trailing chevron
      child: Row(
        // Align children horizontally
        children: [
          // Leading icon graphic asset (colored blue)
          Icon(
            // Bind icon token
            icon,
            // Match color mapping active status (primary blue brand shade)
            color: AppColors.primary_color,
            // Standard size
            size: AppSpacing.dummy_size_icon_nav,
          ),
          // Spacer gap separator
          const SizedBox(
            // Separator width value
            width: AppSpacing.space_m,
          ),
          // Expanded text block containing title/value column
          Expanded(
            // Column layout hosting labels
            child: Column(
              // Center vertically within box
              mainAxisAlignment: MainAxisAlignment.center,
              // Align left
              crossAxisAlignment: CrossAxisAlignment.start,
              // Items
              children: [
                // Top label: e.g. Location or Specialty (small, muted)
                Text(
                  // Display label title
                  title,
                  // Truncate text using ellipsis if text overflows bounds
                  overflow: TextOverflow.ellipsis,
                  // Label text styling configurations options
                  style: const TextStyle(
                    // Muted color representation
                    color: AppColors.text_light_secondary,
                    // Small typographic size
                    fontSize: AppSpacing.dummy_font_size_nav_label,
                    // Normal weight
                    fontWeight: FontWeight.normal,
                  ),
                ),
                // Separator
                const SizedBox(height: AppSpacing.border_width_thin),
                // Bottom label: e.g. Cairo, Egypt or All Specialties (bold, dark navy)
                Text(
                  // Display selected or default value
                  value,
                  // Truncate text using ellipsis if text overflows bounds
                  overflow: TextOverflow.ellipsis,
                  // Label text styling configurations options
                  style: TextStyle(
                    // Dark navy slate color representation
                    color: is_dark ? AppColors.text_dark_primary : AppColors.search_text_slate,
                    // Medium typographic size
                    fontSize: AppSpacing.font_size_label,
                    // Bold weight
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Trailing dropdown chevron arrow icon (dark navy)
          Icon(
            // Dropdown chevron arrow icon token
            Icons.keyboard_arrow_down_rounded,
            // Dark navy color representation
            color: is_dark ? AppColors.text_dark_secondary : AppColors.search_text_slate,
            // Standard size
            size: AppSpacing.dummy_size_icon_notification,
          ),
        ],
      ),
    );
  }
}

// TODO: END OF DUMMY HOME SCREEN IMPLEMENTATION


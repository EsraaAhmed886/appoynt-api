/*
 * File Name: tests_results_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Defines the Tests and Results list screen supporting Lab Tests and Scanning tabs.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing test result entity
import 'package:appoynt_mobile_app/features/profile/domain/entities/test_result.dart';
// Importing add result page screen
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_test_result_page.dart';

// Tests Results Page layout stateful widget representation
class TestsResultsPage extends StatefulWidget {
  // Constructor mapping key
  const TestsResultsPage({super.key});

  // State builder definition
  @override
  State<TestsResultsPage> createState() {
    // Return state instance representation
    return _TestsResultsPageState();
  }
}

// Concrete state tracker implementation class for the TestsResultsPage
class _TestsResultsPageState extends State<TestsResultsPage> {
  // Active selected tab index (0: Lab Tests, 1: Scanning)
  int _active_tab = 0;

  // Draw widget views structures
  @override
  Widget build(BuildContext context) {
    // Resolve localized labels context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // Background colors
      backgroundColor: true == is_dark ? AppColors.background_dark : AppColors.background_light,
      // App bar details
      appBar: AppBar(
        // Center title
        centerTitle: true,
        // Title label text
        title: Text(
          // Tests results title string
          localizations.tests_title,
          // Styles
          style: TextStyle(
            // Size standard
            fontSize: AppSpacing.font_size_title,
            // bold weight
            fontWeight: FontWeight.w700,
            // Color parameters
            color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
          ),
        ),
        // Suffix action button trigger for uploads
        actions: [
          // Suffix upload icon
          IconButton(
            // Upload symbol icon selector
            icon: const Icon(
              // Upload icon token
              Icons.file_upload_outlined,
              // Color primary
              color: AppColors.primary_color,
              // Standard size
              size: AppSpacing.icon_size_m,
            ),
            // Navigate to upload page screen
            onPressed: () {
              // Open upload result page routing wrapped in ProfileCubit
              Navigator.of(context).push(
                // Route configurations
                MaterialPageRoute(
                  // Constructor mapping
                  builder: (route_context) {
                    // Return AddTestResultPage page widget wrapped in ProfileCubit
                    return BlocProvider.value(
                      // Provide existing ProfileCubit instance
                      value: context.read<ProfileCubit>(),
                      // Target page
                      child: AddTestResultPage(
                        // Pass current tab type context
                        initial_type: 0 == _active_tab ? 'lab_test' : 'scan',
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      // BLoC builder rendering filtered medical reports items
      body: BlocBuilder<ProfileCubit, ProfileState>(
        // Rebuild builder
        builder: (context, state) {
          // Filter results list matching active tab category type
          final List<TestResult> filtered_list = 0 == _active_tab
              ? state.profile.lab_tests
              : state.profile.scans;

          // Main vertical display stack
          return Column(
            // Stacking layout elements
            children: [
              // Horizontal custom toggle capsule bar mapping tabs selection options
              Container(
                // Spacing margins
                margin: const EdgeInsets.symmetric(
                  // Horizontal margin padding
                  horizontal: AppSpacing.space_m,
                  // Vertical margin padding
                  vertical: AppSpacing.space_s,
                ),
                // Height bounds
                height: AppSpacing.dummy_height_search_bar,
                // Card decorations
                decoration: BoxDecoration(
                  // Solid gray default background
                  color: true == is_dark ? AppColors.surface_dark : Colors.grey[100],
                  // Rounded boundaries configurations
                  borderRadius: BorderRadius.circular(
                    // Radius token
                    AppSpacing.radius_xl,
                  ),
                ),
                // Horizontal row capsule tabs selectors layout options
                child: Row(
                  // Children capsule tabs selection items options
                  children: [
                    // Lab Tests Tab button
                    Expanded(
                      // GestureDetector catching click actions
                      child: GestureDetector(
                        // Select index 0 on tap
                        onTap: () {
                          // Update active tab locally
                          setState(() {
                            // Bind selection
                            _active_tab = 0;
                          });
                        },
                        // Themed capsule background container depending on active selection
                        child: Container(
                          // Center content alignment
                          alignment: Alignment.center,
                          // decoration specs
                          decoration: BoxDecoration(
                            // Solid white background color fill when active
                            color: 0 == _active_tab
                                ? (true == is_dark ? AppColors.primary_color : Colors.white)
                                : Colors.transparent,
                            // Rounded boundaries corners configurations
                            borderRadius: BorderRadius.circular(
                              // Radius token
                              AppSpacing.radius_xl,
                            ),
                            // shadow constraints
                            boxShadow: 0 == _active_tab
                                ? [
                                    // Ambient card box shadows configuration
                                    BoxShadow(
                                      // Subdued gray shadow color
                                      color: true == is_dark
                                          ? Colors.black.withValues(alpha: 0.25)
                                          : Colors.black.withValues(alpha: 0.04),
                                      // Blur offset
                                      blurRadius: 6.0,
                                      // Spread offset
                                      spreadRadius: 1.0,
                                      offset: const Offset(0.0, 2.0),
                                    ),
                                  ]
                                : null,
                          ),
                          // Tab label text
                          child: Text(
                            // Localized Lab Tests label
                            localizations.tests_tab_lab,
                            // Style configurations
                            style: TextStyle(
                              // Bold indicator
                              fontWeight: FontWeight.w700,
                              // Color depending on active tab status
                              color: 0 == _active_tab
                                  ? (true == is_dark ? Colors.white : AppColors.primary_color)
                                  : AppColors.text_light_secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Scanning Tab button
                    Expanded(
                      // GestureDetector catching click actions
                      child: GestureDetector(
                        // Select index 1 on tap
                        onTap: () {
                          // Update active tab locally
                          setState(() {
                            // Bind selection
                            _active_tab = 1;
                          });
                        },
                        // Themed capsule background container depending on active selection
                        child: Container(
                          // Center content alignment
                          alignment: Alignment.center,
                          // decoration specs
                          decoration: BoxDecoration(
                            // Solid white background color fill when active
                            color: 1 == _active_tab
                                ? (true == is_dark ? AppColors.primary_color : Colors.white)
                                : Colors.transparent,
                            // Rounded boundaries corners configurations
                            borderRadius: BorderRadius.circular(
                              // Radius token
                              AppSpacing.radius_xl,
                            ),
                            // shadow constraints
                            boxShadow: 1 == _active_tab
                                ? [
                                    // Ambient card box shadows configuration
                                    BoxShadow(
                                      // Subdued gray shadow color
                                      color: true == is_dark
                                          ? Colors.black.withValues(alpha: 0.25)
                                          : Colors.black.withValues(alpha: 0.04),
                                      // Blur offset
                                      blurRadius: 6.0,
                                      // Spread offset
                                      spreadRadius: 1.0,
                                      offset: const Offset(0.0, 2.0),
                                    ),
                                  ]
                                : null,
                          ),
                          // Tab label text
                          child: Text(
                            // Localized Scanning label
                            localizations.tests_tab_scanning,
                            // Style configurations
                            style: TextStyle(
                              // Bold indicator
                              fontWeight: FontWeight.w700,
                              // Color depending on active tab status
                              color: 1 == _active_tab
                                  ? (true == is_dark ? Colors.white : AppColors.primary_color)
                                  : AppColors.text_light_secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded layout area placing filtered cards list or empty messages
              Expanded(
                // Switch between list elements or empty fallbacks
                child: true == filtered_list.isEmpty
                    // Render centered empty message alert display
                    ? Center(
                        // Stacking columns layout widgets
                        child: Column(
                          // Center alignment
                          mainAxisAlignment: MainAxisAlignment.center,
                          // children list
                          children: [
                            // Subdued empty reports message
                            Text(
                              // Localized empty check text string
                              0 == _active_tab ? localizations.tests_no_tests_found : localizations.tests_no_scans_found,
                              // Style label text parameters options
                              style: const TextStyle(
                                // Subdued colors
                                color: AppColors.text_light_secondary,
                                // body standard size
                                fontSize: AppSpacing.font_size_body_medium,
                              ),
                            ),
                          ],
                        ),
                      )
                    // Render report items cards list dynamically
                    : ListView.builder(
                        // Spacing offsets padding margin bounds within borders
                        padding: const EdgeInsets.symmetric(
                          // Horizontal offset bounds
                          horizontal: AppSpacing.space_m,
                          // Vertical offset bounds
                          vertical: AppSpacing.space_s,
                        ),
                        // Count
                        itemCount: filtered_list.length,
                        // Builder mapping
                        itemBuilder: (context, index) {
                          // Resolve report result
                          final TestResult result = filtered_list[index];
                          // Return card container layout
                          return Container(
                            // Padding within card
                            padding: const EdgeInsets.all(AppSpacing.space_m),
                            // Margin between cards
                            margin: const EdgeInsets.symmetric(
                              // Vertical space gap
                              vertical: AppSpacing.space_xs,
                            ),
                            // Style configurations
                            decoration: BoxDecoration(
                              // Surface colors
                              color: true == is_dark ? AppColors.surface_dark : Colors.white,
                              // Rounded corners configuration
                              borderRadius: BorderRadius.circular(
                                // Corner radius token
                                AppSpacing.radius_l,
                              ),
                              // Border lines boundary decoration outline
                              border: Border.all(
                                // Outline border colors dynamically adjusting to brightness modes
                                color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                                // Thin boundary lines thickness
                                width: AppSpacing.border_width_thin,
                              ),
                            ),
                            // Horizontal row displaying report details and icon
                            child: Row(
                              // Row elements
                              children: [
                                // Document clipboard decoration icon
                                const Icon(
                                  // Document icon token
                                  Icons.assignment_outlined,
                                  // Primary color
                                  color: AppColors.primary_color,
                                  // Size
                                  size: AppSpacing.icon_size_m,
                                ),
                                // Spacer horizontal gap
                                const SizedBox(
                                  // Spacer width offset
                                  width: AppSpacing.space_m,
                                ),
                                // Title and date stack
                                Expanded(
                                  // Column stack grouping text vertically
                                  child: Column(
                                    // Align text labels to start coordinates
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // children array
                                    children: [
                                      // Document name title
                                      Text(
                                        // Bind document name
                                        result.document_name,
                                        // style
                                        style: TextStyle(
                                          // Medium body size
                                          fontSize: AppSpacing.font_size_body_medium,
                                          // bold weight
                                          fontWeight: FontWeight.w700,
                                          // Dynamic text color adjusting to dark/light surfaces
                                          color: true == is_dark
                                              ? AppColors.text_dark_primary
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                      // Spacer gap
                                      const SizedBox(
                                        // Spacing height
                                        height: AppSpacing.space_xs,
                                      ),
                                      // diagnostic execution date label text
                                      Text(
                                        // Bind date
                                        result.date,
                                        // style
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
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/*
 * File Name: prescriptions_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Defines the Prescriptions page list layout and additions form dropdown selectors.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';

// Prescriptions Page layout stateful widget representation
class PrescriptionsPage extends StatefulWidget {
  // Constructor mapping key
  const PrescriptionsPage({super.key});

  // State builder definition
  @override
  State<PrescriptionsPage> createState() {
    // Return state instance representation
    return _PrescriptionsPageState();
  }
}

// Concrete state tracker implementation class for the PrescriptionsPage
class _PrescriptionsPageState extends State<PrescriptionsPage> {
  // Mock listing of common drug selections for dropdown options list
  final List<String> _medications_options = const [
    'Panadol 500mg',
    'Aspirin 100mg',
    'Amoxicillin 500mg',
    'Lipitor 20mg',
    'Metformin 850mg',
    'Augmentin 1g',
    'Voltaren 75mg',
  ];

  // Selected drug tracker value
  String? _selected_medication;

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
          // Prescriptions title string
          localizations.prescriptions_title,
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
      ),
      // BLoC builder rendering dynamic drug listings
      body: BlocBuilder<ProfileCubit, ProfileState>(
        // Rebuild builder
        builder: (context, state) {
          // Scrollable view layout
          return SingleChildScrollView(
            // Padding offset margin boundaries
            padding: const EdgeInsets.symmetric(
              // Horizontal offset bounds
              horizontal: AppSpacing.space_m,
              // Vertical offset bounds
              vertical: AppSpacing.space_m,
            ),
            // Column stack grouping fields
            child: Column(
              // Align elements start coordinates
              crossAxisAlignment: CrossAxisAlignment.start,
              // children array list
              children: [
                // Add medication Section Subtitle display label
                Text(
                  // Localized subtitle
                  localizations.prescriptions_add_medication,
                  // Styles
                  style: TextStyle(
                    // Size body standard
                    fontSize: AppSpacing.font_size_body_medium,
                    // bold weight
                    fontWeight: FontWeight.w700,
                    // Color styling
                    color: true == is_dark ? AppColors.text_dark_primary : AppColors.primary_color,
                  ),
                ),
                // Separator gap
                const SizedBox(
                  // Spacing height
                  height: AppSpacing.space_s,
                ),
                // Dropdown field card wrapping choice options
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      height: 50.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                          boxShadow: [
                            BoxShadow(
                              color: true == is_dark
                                  ? Colors.black.withValues(alpha: 0.25)
                                  : Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6.0,
                              spreadRadius: 1.0,
                              offset: const Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      // Full width
                      width: double.infinity,
                      height: 50.0,
                      // Padding within borders
                      padding: const EdgeInsets.symmetric(
                        // Horizontal offset
                        horizontal: AppSpacing.space_m,
                      ),
                      // Style decoration outline
                      decoration: BoxDecoration(
                        color: true == is_dark ? AppColors.surface_dark : AppColors.input_fill,
                        // Rounded corners
                        borderRadius: BorderRadius.circular(
                          // Spacing value
                          AppSpacing.radius_input,
                        ),
                        // Border outlines
                        border: Border.all(
                          // Color parameter gray
                          color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                          // Thin outlines
                          width: AppSpacing.border_width_thin,
                        ),
                      ),
                      // DropdownButton selector widget
                      child: DropdownButtonHideUnderline(
                        // Hide default underline line
                        child: DropdownButton<String>(
                          // Placeholder text value
                          hint: Text(
                            // Localized placeholder Type label
                            localizations.allergies_placeholder,
                            // Styles
                            style: const TextStyle(
                              // Secondary colors
                              color: AppColors.text_light_secondary,
                            ),
                          ),
                          // Bind selected tracker value
                          value: _selected_medication,
                          // Enable full width expansion
                          isExpanded: true,
                          // List dropdown items map
                          items: _medications_options.map((medication) {
                            // Return dropdown item structure
                            return DropdownMenuItem<String>(
                              // Bind value
                              value: medication,
                              // Content label text
                              child: Text(medication),
                            );
                          }).toList(),
                          // Handle dropdown selection changes adding item
                          onChanged: (value) {
                            // Verify value is not null
                            if (value != null) {
                              // Update locally selected state tracker
                              setState(() {
                                // Bind selection
                                _selected_medication = value;
                              });
                              // Dispatch addition to Cubit controller
                              context.read<ProfileCubit>().add_prescription(value);
                              // Reset selection back to null to restore placeholder dropdown hint
                              setState(() {
                                // Clear choice
                                _selected_medication = null;
                              });
                            } else {
                              // Empty selection
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Section divider space
                const SizedBox(
                  // Spacing height
                  height: AppSpacing.space_xl,
                ),
                // Added Prescription Section Header display label
                Text(
                  // Section header title string
                  localizations.prescriptions_added_title,
                  // Styles
                  style: TextStyle(
                    // Size body standard
                    fontSize: AppSpacing.font_size_body_medium,
                    // bold weight
                    fontWeight: FontWeight.w700,
                    // Color styling
                    color: true == is_dark ? AppColors.text_dark_primary : AppColors.primary_color,
                  ),
                ),
                // Spacing gap before list cards
                const SizedBox(
                  // Height offset
                  height: AppSpacing.space_s,
                ),
                // Display prescriptions items cards list dynamically
                ListView.builder(
                  // Disable scrolling physics since parent is scrollable
                  physics: const NeverScrollableScrollPhysics(),
                  // Wrap list height to match child count bounds
                  shrinkWrap: true,
                  // Bind count
                  itemCount: state.profile.prescriptions.length,
                  // Builder callback mapping cards
                  itemBuilder: (context, index) {
                    // Resolve drug name
                    final String drug = state.profile.prescriptions[index];
                    // Return card decoration container
                    return Container(
                      // Padding within card
                      padding: const EdgeInsets.symmetric(
                        // Horizontal margins padding
                        horizontal: AppSpacing.space_m,
                        // Vertical margins padding
                        vertical: AppSpacing.space_m,
                      ),
                      // Margin vertical spacing between rows
                      margin: const EdgeInsets.symmetric(
                        // Vertical space gap
                        vertical: AppSpacing.space_xs,
                      ),
                      // Decorations outline options
                      decoration: BoxDecoration(
                        // Surface background colors
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
                      // Horizontal row displaying drug Rx details and icon
                      child: Row(
                        // Row elements
                        children: [
                          // Rx folder/report design icon
                          const Icon(
                            // Report file asset token
                            Icons.medical_services_outlined,
                            // Primary brand blue color
                            color: AppColors.primary_color,
                            // Icon size standard
                            size: AppSpacing.icon_size_m,
                          ),
                          // Spacer horizontal gap
                          const SizedBox(
                            // Spacer width offset
                            width: AppSpacing.space_m,
                          ),
                          // Drug name description text field taking remaining width space
                          Expanded(
                            // Text details display option
                            child: Text(
                              // Bind drug name
                              drug,
                              // Style configurations
                              style: TextStyle(
                                // Medium body size font
                                fontSize: AppSpacing.font_size_body_medium,
                                // bold weight
                                fontWeight: FontWeight.w600,
                                // Dynamic text color adjusting to dark/light surfaces
                                color: true == is_dark
                                    ? AppColors.text_dark_primary
                                    : AppColors.text_light_primary,
                              ),
                            ),
                          ),
                          // Delete action icon button
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.error,
                              size: AppSpacing.icon_size_m,
                            ),
                            onPressed: () {
                              context.read<ProfileCubit>().remove_prescription(drug);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

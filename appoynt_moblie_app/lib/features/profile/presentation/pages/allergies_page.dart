/*
 * File Name: allergies_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Defines the Allergies page layout allowing patients to add food and medication allergies.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';

// Allergies Page layout stateful widget representation
class AllergiesPage extends StatefulWidget {
  // Constructor mapping key
  const AllergiesPage({super.key});

  // State builder definition
  @override
  State<AllergiesPage> createState() {
    // Return state instance representation
    return _AllergiesPageState();
  }
}

// Concrete state tracker implementation class for the AllergiesPage
class _AllergiesPageState extends State<AllergiesPage> {
  // Text controllers mapping inputs for food and medication allergies
  final TextEditingController _food_controller = TextEditingController();
  // Medication allergy text controller
  final TextEditingController _medication_controller = TextEditingController();

  // Dispose controllers freeing system resource locks
  @override
  void dispose() {
    // Dispose text field controllers
    _food_controller.dispose();
    _medication_controller.dispose();
    // Call base dispose
    super.dispose();
  }

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
          // Allergies title string
          localizations.allergies_title,
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
      // BLoC builder rendering dynamic list chips
      body: BlocBuilder<ProfileCubit, ProfileState>(
        // Rebuild builder
        builder: (context, state) {
          // Scrollable view layout
          return Column(
            // Linear column stacking sections
            children: [
              // Expanded scroll area
              Expanded(
                // Scrollable details list
                child: SingleChildScrollView(
                  // Padding offset margin boundaries
                  padding: const EdgeInsets.symmetric(
                    // Horizontal offset bounds
                    horizontal: AppSpacing.space_m,
                    // Vertical offset bounds
                    vertical: AppSpacing.space_m,
                  ),
                  // Column stack grouping fields
                  child: Column(
                    // Align elements start boundary coordinates
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // children array list
                    children: [
                      // Food allergies Section Header display label
                      Text(
                        // Section title
                        localizations.allergies_food_section,
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
                        height: AppSpacing.space_xs,
                      ),
                      // Add allergy subtitle
                      Text(
                        // Localized subtitle
                        localizations.allergies_add_allergy,
                        // style specs
                        style: const TextStyle(
                          // Small body size font
                          fontSize: AppSpacing.font_size_body_small,
                          // Subdued colors
                          color: AppColors.text_light_secondary,
                        ),
                      ),
                      // Spacer gap
                      const SizedBox(
                        // Spacing height
                        height: AppSpacing.space_s,
                      ),
                      // Input row combining food text input and save button next to it
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Expanded input box with shadow stack
                          Expanded(
                            child: Stack(
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
                                TextFormField(
                                  controller: _food_controller,
                                  style: TextStyle(
                                    fontSize: AppSpacing.font_size_text,
                                    color: true == is_dark
                                        ? AppColors.text_dark_primary
                                        : AppColors.text_light_primary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: localizations.allergies_placeholder,
                                    filled: true,
                                    fillColor: true == is_dark
                                        ? AppColors.surface_dark
                                        : AppColors.input_fill,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                                      borderSide: BorderSide(
                                        color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                                        width: AppSpacing.border_width_thin,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                                      borderSide: BorderSide(
                                        color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                                        width: AppSpacing.border_width_thin,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.space_xl,
                                      vertical: AppSpacing.padding_input_vertical,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Horizontal gap
                          const SizedBox(
                            width: AppSpacing.space_s,
                          ),
                          // Save button capsule layout
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProfileCubit>().add_allergy(
                                    _food_controller.text,
                                    'food',
                                  );
                              _food_controller.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary_color,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radius_m),
                              ),
                            ),
                            child: Text(
                              localizations.allergies_save_btn,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Spacing gap before tags listing
                      const SizedBox(
                        height: AppSpacing.space_s,
                      ),
                      // Wrap container holding added food allergy items chips tags
                      Wrap(
                        spacing: AppSpacing.space_xs,
                        children: state.profile.food_allergies.map((allergy) {
                          return Chip(
                            label: Text(allergy),
                            backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.grey[200],
                            deleteIcon: const Icon(
                              Icons.cancel_rounded,
                              size: 18.0,
                            ),
                            onDeleted: () {
                              context.read<ProfileCubit>().remove_allergy(allergy, 'food');
                            },
                          );
                        }).toList(),
                      ),
                      // Section vertical divider offset
                      const SizedBox(
                        // Divider height
                        height: AppSpacing.space_xl,
                      ),
                      // Medication allergies Section Header display label
                      Text(
                        // Section title
                        localizations.allergies_medication_section,
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
                        height: AppSpacing.space_xs,
                      ),
                      // Add allergy subtitle
                      Text(
                        // Localized subtitle
                        localizations.allergies_add_allergy,
                        // style specs
                        style: const TextStyle(
                          // Small body size font
                          fontSize: AppSpacing.font_size_body_small,
                          // Subdued colors
                          color: AppColors.text_light_secondary,
                        ),
                      ),
                      // Spacer gap
                      const SizedBox(
                        // Spacing height
                        height: AppSpacing.space_s,
                      ),
                      // Input row combining medication text input and save button next to it
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Expanded input box with shadow stack
                          Expanded(
                            child: Stack(
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
                                TextFormField(
                                  controller: _medication_controller,
                                  style: TextStyle(
                                    fontSize: AppSpacing.font_size_text,
                                    color: true == is_dark
                                        ? AppColors.text_dark_primary
                                        : AppColors.text_light_primary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: localizations.allergies_placeholder,
                                    filled: true,
                                    fillColor: true == is_dark
                                        ? AppColors.surface_dark
                                        : AppColors.input_fill,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                                      borderSide: BorderSide(
                                        color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                                        width: AppSpacing.border_width_thin,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                                      borderSide: BorderSide(
                                        color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                                        width: AppSpacing.border_width_thin,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.space_xl,
                                      vertical: AppSpacing.padding_input_vertical,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Horizontal gap
                          const SizedBox(
                            width: AppSpacing.space_s,
                          ),
                          // Save button capsule layout
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProfileCubit>().add_allergy(
                                    _medication_controller.text,
                                    'medication',
                                  );
                              _medication_controller.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary_color,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.radius_m),
                              ),
                            ),
                            child: Text(
                              localizations.allergies_save_btn,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Spacing gap before tags listing
                      const SizedBox(
                        height: AppSpacing.space_s,
                      ),
                      // Wrap container holding added medication allergy items chips tags
                      Wrap(
                        spacing: AppSpacing.space_xs,
                        children: state.profile.medication_allergies.map((allergy) {
                          return Chip(
                            label: Text(allergy),
                            backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.grey[200],
                            deleteIcon: const Icon(
                              Icons.cancel_rounded,
                              size: 18.0,
                            ),
                            onDeleted: () {
                              context.read<ProfileCubit>().remove_allergy(allergy, 'medication');
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Big bottom action status update button mockup representing status update triggers
              Padding(
                // Spacing offsets constraints
                padding: const EdgeInsets.symmetric(
                  // Horizontal padding
                  horizontal: AppSpacing.space_m,
                  // Vertical padding
                  vertical: AppSpacing.space_m,
                ),
                // Gradient options styling decorations wrapping button
                child: SizedBox(
                  // Full width available
                  width: double.infinity,
                  // Height dimensions matching standard buttons
                  height: AppSpacing.height_auth_button,
                  // ElevatedButton
                  child: ElevatedButton(
                    // Route back to profile screen on click
                    onPressed: () {
                      // Pop allergies screen layout
                      Navigator.of(context).pop();
                    },
                    // Style configurations
                    style: ElevatedButton.styleFrom(
                      // primary blue
                      backgroundColor: AppColors.primary_color,
                      // Clear shadows
                      elevation: 0.0,
                      // Curvature shape configurations
                      shape: RoundedRectangleBorder(
                        // Radius parameter value
                        borderRadius: BorderRadius.circular(
                          // standard spacing radius token
                          AppSpacing.radius_l,
                        ),
                      ),
                    ),
                    // Button label
                    child: Text(
                      // Localized submit button label
                      localizations.allergies_update_status_btn,
                      // Styles
                      style: const TextStyle(
                        // Color white
                        color: Colors.white,
                        // Size action button font
                        fontSize: AppSpacing.font_size_action_button,
                        // Bold typography weight
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

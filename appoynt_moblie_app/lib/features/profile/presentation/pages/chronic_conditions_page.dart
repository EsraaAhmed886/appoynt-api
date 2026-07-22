/*
 * File Name: chronic_conditions_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Defines the Chronic Conditions page displaying toggleable capsule condition tags.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';

// Chronic Conditions Page layout stateful widget representation
class ChronicConditionsPage extends StatefulWidget {
  // Constructor mapping key
  const ChronicConditionsPage({super.key});

  // State builder definition
  @override
  State<ChronicConditionsPage> createState() {
    // Return state instance representation
    return _ChronicConditionsPageState();
  }
}

// Concrete state tracker implementation class for the ChronicConditionsPage
class _ChronicConditionsPageState extends State<ChronicConditionsPage> {
  // Get IconData mapping matching icon key from Cubit
  IconData _get_icon_data(String icon_key) {
    switch (icon_key) {
      case 'diabetes':
        return Icons.opacity_rounded;
      case 'hypertension':
        return Icons.speed_rounded;
      case 'gout':
        return Icons.healing_rounded;
      case 'asthma':
        return Icons.air_rounded;
      case 'heart_disease':
        return Icons.heart_broken_rounded;
      default:
        return Icons.healing_rounded;
    }
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
          // Chronic conditions title string
          localizations.chronic_title,
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
      // BLoC builder rendering dynamic conditions tags
      body: BlocBuilder<ProfileCubit, ProfileState>(
        // Rebuild builder
        builder: (context, state) {
          // Retrieve master chronic conditions options list from Cubit
          final List<Map<String, String>> conditions_options = context.read<ProfileCubit>().available_conditions;

          // Scrollable view layout
          return SingleChildScrollView(
            // Padding offset margin boundaries
            padding: const EdgeInsets.all(AppSpacing.space_xl),
            // Column stacking cards and introduction text
            child: Column(
              // Align components to start
              crossAxisAlignment: CrossAxisAlignment.start,
              // children array
              children: [
                // Top explanation guide label
                Text(
                  localizations.chronic_description,
                  style: TextStyle(
                    // Standard size
                    fontSize: AppSpacing.font_size_body_medium,
                    // Subdued color
                    color: true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                  ),
                ),
                // Separator gap
                const SizedBox(height: AppSpacing.space_xl),
                // 2-column modern grid mapping medical option cards
                GridView.builder(
                  // Constrain height bounds
                  shrinkWrap: true,
                  // Disable grid inner scrolling
                  physics: const NeverScrollableScrollPhysics(),
                  // Grid structure options
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // Two items per row
                    crossAxisCount: 2,
                    // Horizontal spacing
                    crossAxisSpacing: AppSpacing.space_m,
                    // Vertical spacing
                    mainAxisSpacing: AppSpacing.space_m,
                    // Aspect ratio for cards
                    childAspectRatio: 1.25,
                  ),
                  // Items count
                  itemCount: conditions_options.length,
                  // Grid builder mapping
                  itemBuilder: (context, index) {
                    // Resolve item data
                    final option = conditions_options[index];
                    // Localize text label
                    final String label = true == localizations.is_arabic
                        ? (option['ar'] ?? '')
                        : (option['en'] ?? '');
                    // Get graphic icon data from key mapping
                    final IconData icon = _get_icon_data(option['icon_key'] ?? '');
                    // Verify if card is selected
                    final bool is_selected = state.profile.chronic_conditions.contains(option['en']) ||
                        state.profile.chronic_conditions.contains(option['ar']);

                    // Interactive card detector
                    return GestureDetector(
                      // Toggle status on tap
                      onTap: () {
                        // Dispatch action to profile cubit
                        context.read<ProfileCubit>().toggle_chronic_condition(option['en'] ?? '');
                      },
                      // Animated card container transitioning backgrounds and borders
                      child: AnimatedContainer(
                        // Duration specs
                        duration: const Duration(milliseconds: AppSpacing.duration_fade_ms),
                        // Inner card padding
                        padding: const EdgeInsets.all(AppSpacing.space_m),
                        // Box style configurations
                        decoration: BoxDecoration(
                          // Active tint color background when selected
                          color: true == is_selected
                              ? (true == is_dark
                                  ? AppColors.primary_color.withValues(alpha: 0.15)
                                  : AppColors.primary_color.withValues(alpha: 0.06))
                              : (true == is_dark ? AppColors.surface_dark : Colors.white),
                          // Rounded boundaries corners
                          borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                          // Outlines border configs
                          border: Border.all(
                            // Accent brand color for active state
                            color: true == is_selected
                                ? AppColors.primary_color
                                : (true == is_dark ? AppColors.border_dark : AppColors.border_light),
                            // Thickness specs
                            width: true == is_selected ? AppSpacing.border_width_thick : AppSpacing.border_width_thin,
                          ),
                          // Subtle card depth shadows
                          boxShadow: [
                            BoxShadow(
                              // Soft shadow colors
                              color: true == is_dark
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.04),
                              // Soft blur effect
                              blurRadius: 6.0,
                              // Offsets shadow projection
                              offset: const Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        // Column aligning icon header row and text label
                        child: Column(
                          // Maximize vertical spacing separation
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // Align components to start coordinates
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // children list
                          children: [
                            // Header Row containing medical icon and circular checkmark indicator
                            Row(
                              // Maximize horizontal separation
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // children list
                              children: [
                                // Circular backdrop container badge hosting icon
                                Container(
                                  // Padding
                                  padding: const EdgeInsets.all(AppSpacing.space_s),
                                  // Shape decoration details
                                  decoration: BoxDecoration(
                                    // Highlight backgrounds depending on selection state
                                    color: true == is_selected
                                        ? AppColors.primary_color
                                        : (true == is_dark ? AppColors.background_dark : Colors.grey[100]),
                                    // Circular boundaries
                                    shape: BoxShape.circle,
                                  ),
                                  // Diagnostic icon
                                  child: Icon(
                                    // Icon code representation
                                    icon,
                                    // Color configurations
                                    color: true == is_selected
                                        ? Colors.white
                                        : (true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary),
                                    // Badge icon size
                                    size: 22.0,
                                  ),
                                ),
                                // Selector checkbox indicator
                                Container(
                                  // Box width
                                  width: 20.0,
                                  // Box height
                                  height: 20.0,
                                  // decoration specs
                                  decoration: BoxDecoration(
                                    // circular shape
                                    shape: BoxShape.circle,
                                    // Border outlines
                                    border: Border.all(
                                      // Color outlines
                                      color: true == is_selected ? AppColors.primary_color : Colors.grey,
                                      // Outline line weight
                                      width: 1.5,
                                    ),
                                    // Solid brand color fill if selected
                                    color: true == is_selected ? AppColors.primary_color : Colors.transparent,
                                  ),
                                  // Check icon loaded when active
                                  child: true == is_selected
                                      ? const Icon(
                                          // check graphic token
                                          Icons.check,
                                          // High contrast white color
                                          color: Colors.white,
                                          // Icon size inside checkbox bounds
                                          size: 12.0,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                            // Condition name label text
                            Text(
                              // Bind text
                              label,
                              // Style details
                              style: TextStyle(
                                // body standard size
                                fontSize: AppSpacing.font_size_body_medium,
                                // Bold font weight
                                fontWeight: FontWeight.w700,
                                // Accent blue text when selected or dark/light primary text colors
                                color: true == is_selected
                                    ? (true == is_dark ? Colors.white : AppColors.primary_color)
                                    : (true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary),
                              ),
                            ),
                          ],
                        ),
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

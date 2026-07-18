/*
 * File Name: app_bottom_nav_bar.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/07/2026]
 * File Description: A reusable bottom navigation bar component mapping custom design tokens and localized text resources.
 */

// TODO: START OF DUMMY NAV BAR COMPONENT - REMOVE ONCE FINAL NAV IS FINALIZED


// Import routing and tokens barrel export file
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Import lucide icons package
import 'package:lucide_icons/lucide_icons.dart';

// NavItem definition schema class mapping tab properties
class AppNavItem {
  // Unselected icon graphic representation representation
  final IconData icon;
  // Selected icon graphic representation representation
  final IconData active_icon;
  // Localized navigation tab label text representation
  final String label;

  // Constructor mapping required properties
  const AppNavItem({
    required this.icon,
    required this.active_icon,
    required this.label,
  });
}

// Reusable bottom navigation bar widget component
class AppBottomNavBar extends StatelessWidget {
  // Current active navigation index selection tracker
  final int selected_index;
  // ValueChanged callback on selection tap
  final ValueChanged<int> on_tap;

  // Constructor initializing the widget parameters
  const AppBottomNavBar({
    super.key,
    required this.selected_index,
    required this.on_tap,
  });

  @override
  // Build reusable bottom navigation bar widget
  Widget build(BuildContext context) {
    // Resolve localizations context configuration
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve dark mode status using brightness context queries
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Define the list of navigation items for the bottom navigation bar
    final List<AppNavItem> nav_items = [
      // Home tab item declaration
      AppNavItem(
        // Unselected icon token representation
        icon: LucideIcons.home,
        // Selected icon token representation
        active_icon: LucideIcons.home,
        // Localized text label string
        label: localizations.dummy_home_tab_label,
      ),
      // Appointments tab item declaration
      AppNavItem(
        // Unselected icon token representation
        icon: LucideIcons.calendarDays,
        // Selected icon token representation
        active_icon: LucideIcons.calendarDays,
        // Localized text label string
        label: localizations.dummy_appointments_tab_label,
      ),
      // Search tab item declaration
      AppNavItem(
        // Unselected icon token representation
        icon: LucideIcons.search,
        // Selected icon token representation
        active_icon: LucideIcons.search,
        // Localized text label string
        label: localizations.dummy_search_tab_label,
      ),
      // Favorite tab item declaration (heart icon as required in Lucide design specs)
      AppNavItem(
        // Unselected icon token representation
        icon: LucideIcons.heart,
        // Selected icon token representation
        active_icon: LucideIcons.heart,
        // Localized text label string
        label: localizations.dummy_favorite_tab_label,
      ),
      // Profile tab item declaration
      AppNavItem(
        // Unselected icon token representation
        icon: LucideIcons.user,
        // Selected icon token representation
        active_icon: LucideIcons.user,
        // Localized text label string
        label: localizations.dummy_profile_tab_label,
      ),
    ];

    // Return container applying custom shadows and colors decoration bounds
    return Container(
      // Apply layout styling decorations to bottom nav wrapper box
      decoration: BoxDecoration(
        // Set container background color based on active dark theme status
        color: true == is_dark ? AppColors.surface_dark : AppColors.background_light,
        // Apply shadow parameters array
        boxShadow: const [
          // Shadow element representing bottom nav border elevation
          BoxShadow(
            // Shadow color offset using dummy constant token
            color: AppColors.dummy_shadow_color,
            // Blur radius offset using dummy constant token
            blurRadius: AppSpacing.dummy_bottom_nav_blur_radius,
            // Offset coordinates for the elevation projection
            offset: Offset(
              // Horizontal offset coordinate
              0.0,
              // Vertical offset coordinate
              AppSpacing.dummy_bottom_nav_shadow_offset_y,
            ),
          ),
        ],
      ),
      // Wrap children inside a safe area container
      child: SafeArea(
        // Add vertical and horizontal padding around navigation row layout
        child: Padding(
          // Apply symmetric padding bounds using dummy tokens
          padding: const EdgeInsets.symmetric(
            // Horizontal padding value
            horizontal: AppSpacing.dummy_bottom_nav_padding_horizontal,
            // Vertical padding value
            vertical: AppSpacing.dummy_bottom_nav_padding_vertical,
          ),
          // Align navigation children items horizontally inside row layout
          child: Row(
            // Position items evenly across container width bounds
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // Map the navigation items to interactive widgets list
            children: nav_items.asMap().entries.map((e) {
              // Resolve active selection status of target map entry
              final bool is_selected = e.key == selected_index;
              // Return interactive detector capturing tap gesture event handlers
              return GestureDetector(
                // Update state on user tap interaction
                onTap: () {
                  // Forward selected index to callback handler
                  on_tap(e.key);
                },
                // Animated container rendering smooth active indicators transitions
                child: AnimatedContainer(
                  // Set speed duration parameters
                  duration: const Duration(
                    // Set transition milliseconds count
                    milliseconds: AppSpacing.duration_fade_ms,
                  ),
                  // Set padding within container box bounds
                  padding: const EdgeInsets.symmetric(
                    // Horizontal padding value
                    horizontal: AppSpacing.dummy_bottom_nav_item_padding_horizontal,
                    // Vertical padding value
                    vertical: AppSpacing.dummy_bottom_nav_item_padding_vertical,
                  ),
                  // Apply rounded decoration borders to active nav button
                  decoration: BoxDecoration(
                    // Highlight selected item container with primary accent tint
                    color: true == is_selected
                        ? AppColors.primary_color.withValues(alpha: AppSpacing.dummy_opacity_active)
                        : Colors.transparent,
                    // Rounded corner radius settings mapping index indicator shapes
                    borderRadius: BorderRadius.circular(
                      // Radius value from dummy configuration token
                      AppSpacing.dummy_bottom_nav_item_radius,
                    ),
                  ),
                  // Stack elements inside vertical column container layout
                  child: Column(
                    // Wrap elements sizes tightly
                    mainAxisSize: MainAxisSize.min,
                    // Align elements horizontally centered inside box
                    children: [
                      // Render icon widget dynamically based on active selection status
                      Icon(
                        // Select icon mapping active status
                        true == is_selected ? e.value.active_icon : e.value.icon,
                        // Highlight active icon with primary brand color, else unselected gray
                        color: true == is_selected
                            ? AppColors.primary_color
                            : AppColors.dummy_unselected_item_color,
                        // Set icon display size
                        size: AppSpacing.dummy_size_icon_nav,
                      ),
                      // Separator vertical height offset box
                      const SizedBox(
                        // Height size spacer gap
                        height: AppSpacing.dummy_space_tiny,
                      ),
                      // Text label displaying translated category titles
                      Text(
                        // Category title text string value
                        e.value.label,
                        // Apply typographic styling options
                        style: TextStyle(
                          // Set typographic font size matching standard labels
                          fontSize: AppSpacing.dummy_font_size_nav_label,
                          // Highlight active label with primary brand color, else unselected gray
                          color: true == is_selected
                              ? AppColors.primary_color
                              : AppColors.dummy_unselected_item_color,
                          // Setup font weight active indicator
                          fontWeight: true == is_selected ? FontWeight.bold : FontWeight.w500,
                          // Setup height spacing scale
                          height: AppSpacing.dummy_line_height_nav,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// TODO: END OF DUMMY NAV BAR COMPONENT

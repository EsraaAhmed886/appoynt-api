/*
 * File Name: family_members_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/07/2026]
 * File Description: Defines the Family Members Page listing dependent profiles with switcher.
 */

// Importing global route export barrel
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing BLoC libraries
// Importing profile cubit controller
// Importing profile state definition
// Importing add family member page layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_family_member_page.dart';

// Stateful widget displaying Family Members layout
class FamilyMembersPage extends StatefulWidget {
  // Constructor mapping key
  const FamilyMembersPage({super.key});

  @override
  // Create state tracker instance
  State<FamilyMembersPage> createState() {
    // Return state class instance
    return _FamilyMembersPageState();
  }
}

// State class managing profile selection indexes
class _FamilyMembersPageState extends State<FamilyMembersPage> {
  // Selected family index
  int _selected_family_index = 0;

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // Background colors
      backgroundColor: true == is_dark
          ? AppColors.background_dark
          : AppColors.surface_light.withValues(alpha: 0.5),
      // SafeArea protect
      body: SafeArea(
        // Scroll view
        child: SingleChildScrollView(
          // Padding offsets
          child: Padding(
            // Safe side margins 16px
            padding: const EdgeInsets.symmetric(
              // Horizontal boundaries padding
              horizontal: AppSpacing.space_xl,
              // Vertical boundaries padding
              vertical: AppSpacing.space_m,
            ),
            // Stack columns
            child: Column(
              // Align left coordinates
              crossAxisAlignment: CrossAxisAlignment.start,
              // children
              children: [
                // Top header row placing circular back button and screen title
                Row(
                  // Distribute space
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // elements
                  children: [
                    // Back chevron button gesture detector wrapper
                    GestureDetector(
                      // POP route context on tap
                      onTap: () {
                        // POP navigation
                        Navigator.of(context).pop();
                      },
                      // Circular button container styling
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
                          // Shape circle
                          shape: BoxShape.circle,
                          // Soft shadow drop
                          boxShadow: [
                            // Shadow offset
                            BoxShadow(
                              // Color
                              color: true == is_dark
                                  ? Colors.black26
                                  : Colors.black.withValues(alpha: 0.05),
                              // Blur spread
                              blurRadius: 8.0,
                              // Position offsets
                              offset: const Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        // Chevron icon
                        child: Icon(
                          // Chevron left
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
                      localizations.profile_dependents_title,
                      // Typography options
                      style: TextStyle(
                        // Header size
                        fontSize: 18.0,
                        // Bolder font weight
                        fontWeight: FontWeight.w800,
                        // Dynamic color
                        color: true == is_dark
                            ? Colors.white
                            : AppColors.text_light_primary,
                      ),
                    ),
                    // Balancer spacer matching back button dimensions
                    const SizedBox(width: 44.0),
                  ],
                ),
                // Height gap spacer
                const SizedBox(height: AppSpacing.space_xl),

                // Family switcher Card
                Container(
                  // Card decoration styling
                  decoration: BoxDecoration(
                    // Background colors
                    color: true == is_dark
                        ? AppColors.surface_dark
                        : Colors.white,
                    // Round corners radius
                    borderRadius: BorderRadius.circular(16.0),
                    // Drop shadow
                    boxShadow: [
                      // Soft card shadow
                      BoxShadow(
                        // Color
                        color: true == is_dark
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.03),
                        // Spread blur
                        blurRadius: 10.0,
                      ),
                    ],
                    // Borders
                    border: Border.all(
                      // Color matching theme
                      color: true == is_dark
                          ? AppColors.border_dark
                          : AppColors.border_light.withValues(alpha: 0.5),
                      // Boundary line thickness
                      width: AppSpacing.border_width_thin,
                    ),
                  ),
                  // Card elements column
                  child: Column(
                    // Align left coordinates
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // children list
                    children: [
                      // Section title header label
                      Padding(
                        // Padding bounds
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0),
                        // Text widget
                        child: Text(
                          // Localized dependents key
                          localizations.profile_dependents_title,
                          // Typographic style configurations
                          style: TextStyle(
                            // Subtitle size
                            fontSize: 13.0,
                            // Bold weight
                            fontWeight: FontWeight.bold,
                            // Secondary color adaptions
                            color: true == is_dark
                                ? Colors.white70
                                : AppColors.text_light_primary,
                          ),
                        ),
                      ),
                      // Horizontal slider section
                      Container(
                        // Height constraints
                        height: 90.0,
                        // Margins
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        // Scroll view wrapper
                        child: SingleChildScrollView(
                          // Horizontal scroll direction
                          scrollDirection: Axis.horizontal,
                          // Inner padding bounds
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          // Align avatars in a row
                          child: Row(
                            // children
                            children: [
                              // User context avatar (Self - Index 0)
                              GestureDetector(
                                // Update state index selection on tap
                                onTap: () {
                                  // Trigger state rebuild
                                  setState(() {
                                    // Update selection tracker
                                    _selected_family_index = 0;
                                  });
                                },
                                // Column wrapper
                                child: Container(
                                  // Right margins
                                  margin: const EdgeInsets.only(right: 12.0),
                                  // Column
                                  child: Column(
                                    // children
                                    children: [
                                      // Distinctive primary outer ring selection style
                                      Container(
                                        // Padding space forming the gap
                                        padding: const EdgeInsets.all(2.0),
                                        // Decoration details
                                        decoration: BoxDecoration(
                                          // Circle shape
                                          shape: BoxShape.circle,
                                          // Blue active border boundary outline
                                          border: Border.all(
                                            // High contrast border color
                                            color: 0 == _selected_family_index
                                                ? AppColors.primary_color
                                                : Colors.transparent,
                                            // Thickness
                                            width: 2.0,
                                          ),
                                        ),
                                        // Inner container housing icon
                                        child: Container(
                                          // Width
                                          width: 44.0,
                                          // Height
                                          height: 44.0,
                                          // Decoration
                                          decoration: BoxDecoration(
                                            // Circle
                                            shape: BoxShape.circle,
                                            // Transparent primary blue background tint
                                            color: AppColors.primary_color.withValues(alpha: 0.1),
                                          ),
                                          // Person outline icon
                                          child: const Icon(Icons.person,
                                              color: AppColors.primary_color),
                                        ),
                                      ),
                                      // Spacer gap height
                                      const SizedBox(height: 4.0),
                                      // Label Text
                                      Text(
                                        // Main user label
                                        'Kareem (You)',
                                        // Style
                                        style: TextStyle(
                                          // Tiny size
                                          fontSize: 10.0,
                                          // Bold weight if active selection
                                          fontWeight: 0 == _selected_family_index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          // Color adaptions
                                          color: true == is_dark
                                              ? Colors.white70
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Dependent context avatar 1 (Leo - Index 1)
                              GestureDetector(
                                // Update state index selection on tap
                                onTap: () {
                                  // Rebuild states
                                  setState(() {
                                    // Set index to 1
                                    _selected_family_index = 1;
                                  });
                                },
                                // Column wrapper
                                child: Container(
                                  // Right margins spacer
                                  margin: const EdgeInsets.only(right: 12.0),
                                  // Column
                                  child: Column(
                                    // children
                                    children: [
                                      // Highlight ring outer container
                                      Container(
                                        // Inner white gap padding
                                        padding: const EdgeInsets.all(2.0),
                                        // Decoration styling
                                        decoration: BoxDecoration(
                                          // Circle
                                          shape: BoxShape.circle,
                                          // Outer active blue border highlight outline
                                          border: Border.all(
                                            // Colors selector
                                            color: 1 == _selected_family_index
                                                ? AppColors.primary_color
                                                : Colors.transparent,
                                            // Thickness
                                            width: 2.0,
                                          ),
                                        ),
                                        // Avatar base container
                                        child: Container(
                                          // Width
                                          width: 44.0,
                                          // Height
                                          height: 44.0,
                                          // Decoration
                                          decoration: BoxDecoration(
                                            // Shape
                                            shape: BoxShape.circle,
                                            // Primary color backing fill
                                            color: AppColors.primary_color.withValues(alpha: 0.1),
                                          ),
                                          // Child care graphic representation icon
                                          child: const Icon(
                                              Icons.child_care_rounded,
                                              color: AppColors.primary_color),
                                        ),
                                      ),
                                      // Spacer gap height
                                      const SizedBox(height: 4.0),
                                      // Label
                                      Text(
                                        // Son title
                                        'Leo (Son)',
                                        // Style
                                        style: TextStyle(
                                          // Size
                                          fontSize: 10.0,
                                          // Bold weights check using Yoda
                                          fontWeight: 1 == _selected_family_index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          // Adaptive color
                                          color: true == is_dark
                                              ? Colors.white70
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Dependent context avatar 2 (Sara - Index 2)
                              GestureDetector(
                                // Update state index selection on tap
                                onTap: () {
                                  // Rebuild states
                                  setState(() {
                                    // Set index to 2
                                    _selected_family_index = 2;
                                  });
                                },
                                // Column wrapper
                                child: Container(
                                  // Right margins spacer
                                  margin: const EdgeInsets.only(right: 12.0),
                                  // Column
                                  child: Column(
                                    // children
                                    children: [
                                      // Highlight ring outer container
                                      Container(
                                        // Inner white gap padding
                                        padding: const EdgeInsets.all(2.0),
                                        // Decoration styling
                                        decoration: BoxDecoration(
                                          // Circle
                                          shape: BoxShape.circle,
                                          // Active outer ring border check
                                          border: Border.all(
                                            // Color selection
                                            color: 2 == _selected_family_index
                                                ? AppColors.primary_color
                                                : Colors.transparent,
                                            // Thickness
                                            width: 2.0,
                                          ),
                                        ),
                                        // Avatar base container
                                        child: Container(
                                          // Width
                                          width: 44.0,
                                          // Height
                                          height: 44.0,
                                          // Decoration
                                          decoration: BoxDecoration(
                                            // Circle
                                            shape: BoxShape.circle,
                                            // Color fill
                                            color: AppColors.primary_color.withValues(alpha: 0.1),
                                          ),
                                          // Spouse face graphic icon
                                          child: const Icon(
                                              Icons.face_3_rounded,
                                              color: AppColors.primary_color),
                                        ),
                                      ),
                                      // Spacing gap height
                                      const SizedBox(height: 4.0),
                                      // Label
                                      Text(
                                        // Spouse title
                                        'Sara (Spouse)',
                                        // Style
                                        style: TextStyle(
                                          // Size
                                          fontSize: 10.0,
                                          // Bold weights check using Yoda
                                          fontWeight: 2 == _selected_family_index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          // Colors
                                          color: true == is_dark
                                              ? Colors.white70
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Add Family Member button (dashed borders with soft primary tint)
                              GestureDetector(
                                // Navigate to AddFamilyMemberPage onTap
                                onTap: () {
                                  // Navigate using standard push route
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      // Build AddFamilyMemberPage widget
                                      builder: (route_context) => const AddFamilyMemberPage(),
                                    ),
                                  );
                                },
                                // Column wrapper
                                child: Container(
                                  // Right margins spacer
                                  margin: const EdgeInsets.only(right: 12.0),
                                  // Column
                                  child: Column(
                                    // children list
                                    children: [
                                      // Custom paint drawing dashed borders circle
                                      Container(
                                        // Spacing gap
                                        padding: const EdgeInsets.all(2.0),
                                        // Dashed border painter block
                                        child: CustomPaint(
                                          // Bind dashed circle painter class
                                          painter: const DashCirclePainter(
                                              color: AppColors.primary_color),
                                          // Base container button styling
                                          child: Container(
                                            // Width
                                            width: 44.0,
                                            // Height
                                            height: 44.0,
                                            // Centered plus sign
                                            alignment: Alignment.center,
                                            // Rounded corners shape
                                            decoration: BoxDecoration(
                                              // Circle
                                              shape: BoxShape.circle,
                                              // Soft transparent blue primary brand tint backplate
                                              color: AppColors.primary_color.withValues(alpha: 0.05),
                                            ),
                                            // Plus icon graphic
                                            child: const Icon(
                                              // Plus symbol
                                              Icons.add_rounded,
                                              // Accent primary color
                                              color: AppColors.primary_color,
                                              // Size
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Spacing gap height
                                      const SizedBox(height: 4.0),
                                      // Text label
                                      const Text(
                                        // Label string
                                        'Add Family',
                                        // Typographic style configurations
                                        style: TextStyle(
                                          // Tiny size
                                          fontSize: 10.0,
                                          // Semi-bold indicators
                                          fontWeight: FontWeight.w600,
                                          // Colored primary brand tint
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
                      ),
                    ],
                  ),
                ),
                // Gap spacing 16px
                const SizedBox(height: 16.0),

                // Selected family member demographic profile card details
                Container(
                  // Full width
                  width: double.infinity,
                  // Padding
                  padding: const EdgeInsets.all(16.0),
                  // Decoration styling
                  decoration: BoxDecoration(
                    // Background colors
                    color: true == is_dark ? AppColors.surface_dark : Colors.white,
                    // Round corners radius
                    borderRadius: BorderRadius.circular(16.0),
                    // Drop shadow
                    boxShadow: [
                      // Soft shadow
                      BoxShadow(
                        // Color
                        color: true == is_dark
                            ? Colors.black26
                            : Colors.black.withValues(alpha: 0.03),
                        // Blur
                        blurRadius: 8.0,
                      ),
                    ],
                    // Border
                    border: Border.all(
                      // Color theme
                      color: true == is_dark
                          ? AppColors.border_dark
                          : AppColors.border_light.withValues(alpha: 0.5),
                      // Line thickness
                      width: AppSpacing.border_width_thin,
                    ),
                  ),
                  // Stacking demographic profile info details
                  child: Column(
                    // Align left
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Children
                    children: [
                      // Detail Row A: Full Name
                      Row(
                        // Distribute
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // children
                        children: [
                          // Key label
                          Text(
                            // Label
                            'Full Name',
                            // style
                            style: TextStyle(
                              // Size
                              fontSize: 13.0,
                              // Weight
                              fontWeight: FontWeight.w500,
                              // Color
                              color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                            ),
                          ),
                          // Value text
                          Text(
                            // Dynamically map values
                            0 == _selected_family_index
                                ? 'Kareem Mangood'
                                : 1 == _selected_family_index
                                    ? 'Leo Mangood'
                                    : 'Sara Mangood',
                            // style
                            style: TextStyle(
                              // Size
                              fontSize: 13.0,
                              // Bold weight
                              fontWeight: FontWeight.bold,
                              // Color
                              color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                            ),
                          ),
                        ],
                      ),
                      // Divider gap
                      const Divider(height: 24.0, thickness: 0.5),
                      // Detail Row B: Relationship
                      Row(
                        // Distribute
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // children
                        children: [
                          // Key label
                          Text(
                            // Label
                            'Relationship',
                            // style
                            style: TextStyle(
                              // Size
                              fontSize: 13.0,
                              // Weight
                              fontWeight: FontWeight.w500,
                              // Color
                              color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                            ),
                          ),
                          // Value text
                          Text(
                            // Dynamically map values
                            0 == _selected_family_index
                                ? 'Self (Primary)'
                                : 1 == _selected_family_index
                                    ? 'Son (Dependent)'
                                    : 'Spouse (Dependent)',
                            // style
                            style: TextStyle(
                              // Size
                              fontSize: 13.0,
                              // Bold weight
                              fontWeight: FontWeight.bold,
                              // Color
                              color: 0 == _selected_family_index
                                  ? AppColors.primary_color
                                  : Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      // Divider gap
                      const Divider(height: 24.0, thickness: 0.5),
                      // Detail Row C: Age/Demographics
                      Row(
                        // Distribute
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // children
                        children: [
                          // Key label
                          Text(
                            // Label
                            'Age & Gender',
                            // style
                            style: TextStyle(
                              // Size
                              fontSize: 13.0,
                              // Weight
                              fontWeight: FontWeight.w500,
                              // Color
                              color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                            ),
                          ),
                          // Value text
                          Text(
                            // Dynamically map values
                            0 == _selected_family_index
                                ? '28 Yrs / Male'
                                : 1 == _selected_family_index
                                    ? '4 Yrs / Male'
                                    : '26 Yrs / Female',
                            // style
                            style: TextStyle(
                              // Size
                              fontSize: 13.0,
                              // Bold weight
                              fontWeight: FontWeight.bold,
                              // Color
                              color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
  // Draw layout logic execution
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
  // Repaint state check
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always return false as layout shape is static
    return false;
  }
}

/*
 * File Name: medical_context_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V3.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/pages/add_family_member_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Dedicated screen displaying patient medical records, family dependents profile switcher, and health insurance.
 */

// Importing global route export barrel configuration
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing flutter bloc for state management
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing profile cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing profile state definition
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing sub-pages for medical records
import 'package:appoynt_mobile_app/features/profile/presentation/pages/allergies_page.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/family_members_page.dart';
// Importing prescriptions page layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/prescriptions_page.dart';
// Importing tests and results page layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/tests_results_page.dart';
// Importing chronic conditions page layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/chronic_conditions_page.dart';
// Importing insurance details page layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/insurance_details_page.dart';
// Importing full screen add family member page layout

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_badge = 12.0;
  static const double spacing_large = 16.0;
  static const double font_size_body = 14.0;
  static const double font_size_tiny = 11.0;
  static const double icon_size_medium = 20.0;
  static const double shadow_blur = 10.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.05;
  static const double dash_stroke_width = 1.5;
}

// Stateful widget displaying Medical Context layout
class MedicalContextPage extends StatefulWidget {
  // Constructor mapping key
  const MedicalContextPage({super.key});

  @override
  // Create state tracker instance
  State<MedicalContextPage> createState() {
    // Return state class instance
    return _MedicalContextPageState();
  }
}

// State class managing interactive sliders and dashboard categories
class _MedicalContextPageState extends State<MedicalContextPage> {
  // Selected dependent context switcher index

  // Helper to resolve localized count labels for general medical records/allergies/conditions
  String _get_item_count_label(int count, AppLocalizations localizations) {
    return localizations.get_items_count_text(count);
  }

  // Helper to resolve localized count labels for medication prescriptions list
  String _get_prescription_count_label(int count, AppLocalizations localizations) {
    return localizations.get_prescriptions_count_text(count);
  }

  // Helper to resolve localized count labels for medical files/results reports
  String _get_file_count_label(int count, AppLocalizations localizations) {
    return localizations.get_files_count_text(count);
  }

  // Helper to resolve localized count labels for insurance cards list
  String _get_insurance_count_label(int count, AppLocalizations localizations) {
    return localizations.get_cards_count_text(count);
  }

  // Helper to resolve localized count labels for family members
  String _get_members_count_label(int count, AppLocalizations localizations) {
    return localizations.get_members_count_text(count);
  }

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Return root Scaffold layout container
    return Scaffold(
      // SafeArea protect
      body: SafeArea(
        // Scroll view
        child: SingleChildScrollView(
          // Padding
          child: Padding(
            // Margins strictly at 16px safe side boundaries
            padding: const EdgeInsets.only(
              left: AppSpacing.space_xl,
              right: AppSpacing.space_xl,
              top: AppSpacing.space_xl,
              bottom: AppSpacing.space_m,
            ),
            // Bloc builder
            child: BlocBuilder<ProfileCubit, ProfileState>(
              // Builder callback
              builder: (bloc_context, state) {
                // Resolve all allergies combined count
                final List<String> all_allergies = [
                  ...state.profile.food_allergies,
                  ...state.profile.medication_allergies
                ];
                // Resolve all tests and scans files count combined
                final int files_count = state.profile.lab_tests.length + state.profile.scans.length;

                // Column stacking layout cards
                return Column(
                  // Align left coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children
                  children: [
                    // Top header row placing circular back button and screen title
                    CustomProfileAppBar(
                      title: localizations.profile_medical_history,
                    ),
                    // Height gap spacer
                    const SizedBox(height: AppSpacing.space_xl),

                    // SECTION 2: Separate clean navigation cards (No micro-data leaking into hub screen)
                    
                    // CARD 0: Family Members Card
                    _MedicalCategoryCard(
                      // Title
                      title: localizations.profile_dependents_title,
                      // People group icon
                      icon: Icons.people_outline_rounded,
                      // Deep Orange color
                      iconColor: AppColors.deepOrange,
                      // Background tint
                      iconBgColor: AppColors.deepOrange.withValues(alpha: 0.1),
                      // Localized count badge
                      badgeText: _get_members_count_label(3, localizations),
                      // Navigate onTap
                      onTap: () {
                        // Push navigation route
                        Navigator.of(context).push(
                          // Route builder
                          MaterialPageRoute(
                            // Builder
                            builder: (route_context) => BlocProvider.value(
                              // Propagate cubit
                              value: context.read<ProfileCubit>(),
                              // Target sub-page
                              child: const FamilyMembersPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    // Spacing gap (strictly 16px)
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // CARD A: Allergies Card
                    _MedicalCategoryCard(
                      // Title
                      title: localizations.profile_allergies,
                      // Warning icon
                      icon: Icons.warning_amber_rounded,
                      // Crimson red colors
                      iconColor: AppColors.error,
                      // Background tint
                      iconBgColor: AppColors.error.withValues(alpha: 0.1),
                      // Localized items count badge
                      badgeText: _get_item_count_label(all_allergies.length, localizations),
                      // Navigate onTap
                      onTap: () {
                        // Push navigation route
                        Navigator.of(context).push(
                          // Route builder
                          MaterialPageRoute(
                            // Builder
                            builder: (route_context) => BlocProvider.value(
                              // Propagate cubit
                              value: context.read<ProfileCubit>(),
                              // Target sub-page
                              child: const AllergiesPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    // Spacing gap (strictly 16px)
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // CARD B: Chronic Conditions Card
                    _MedicalCategoryCard(
                      // Title
                      title: localizations.profile_chronic_conditions,
                      // Pulse heart icon representation
                      icon: Icons.add_circle_outline_rounded,
                      // Teal color accent
                      iconColor: AppColors.teal,
                      // Icon background tint fill
                      iconBgColor: AppColors.teal.withValues(alpha: 0.1),
                      // Localized conditions count badge
                      badgeText: _get_item_count_label(state.profile.chronic_conditions.length, localizations),
                      // Navigate onTap
                      onTap: () {
                        // Push navigation route
                        Navigator.of(context).push(
                          // Route builder
                          MaterialPageRoute(
                            // Builder
                            builder: (route_context) => BlocProvider.value(
                              // Propagate cubit
                              value: context.read<ProfileCubit>(),
                              // Target sub-page
                              child: const ChronicConditionsPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    // Spacing gap (strictly 16px)
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // CARD C: Medications List Card
                    _MedicalCategoryCard(
                      // Title
                      title: localizations.profile_medications,
                      // Receipt list RX icon
                      icon: Icons.receipt_long_rounded,
                      // Accent primary color
                      iconColor: AppColors.primary_color,
                      // Background tint
                      iconBgColor: AppColors.primary_color.withValues(alpha: 0.1),
                      // Localized active prescriptions count badge
                      badgeText: _get_prescription_count_label(state.profile.prescriptions.length, localizations),
                      // Navigate onTap
                      onTap: () {
                        // Push navigation route
                        Navigator.of(context).push(
                          // Route builder
                          MaterialPageRoute(
                            // Builder
                            builder: (route_context) => BlocProvider.value(
                              // Propagate cubit
                              value: context.read<ProfileCubit>(),
                              // Target sub-page
                              child: const PrescriptionsPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    // Spacing gap (strictly 16px)
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // CARD D: Tests and Results Card
                    _MedicalCategoryCard(
                      // Title
                      title: localizations.profile_tests_results,
                      // Assignment folder outline icon
                      icon: Icons.assignment_outlined,
                      // Purple color accent
                      iconColor: AppColors.deepPurple,
                      // Background tint
                      iconBgColor: AppColors.deepPurple.withValues(alpha: 0.1),
                      // Localized file count badge
                      badgeText: _get_file_count_label(files_count, localizations),
                      // Navigate onTap
                      onTap: () {
                        // Push navigation route
                        Navigator.of(context).push(
                          // Route builder
                          MaterialPageRoute(
                            // Builder
                            builder: (route_context) => BlocProvider.value(
                              // Propagate cubit
                              value: context.read<ProfileCubit>(),
                              // Target sub-page
                              child: const TestsResultsPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    // Spacing gap (strictly 16px)
                    const SizedBox(height: _LocalDimensions.spacing_large),

                    // CARD E: Shared InsuranceCardWidget or NoInsuranceCardWidget depending on count
                    true == state.profile.insurance_cards.isEmpty
                        ? NoInsuranceCardWidget(
                            // Title
                            title: localizations.profile_insurance_details,
                            // Localized count badge
                            badgeText:
                                _get_insurance_count_label(0, localizations),
                            // Navigate onTap
                            onTap: () {
                              // Push navigate to insurance details screen layout onTap
                              Navigator.of(context).push(
                                // Route builder
                                MaterialPageRoute(
                                  // Builder constructor
                                  builder: (route_context) =>
                                      BlocProvider.value(
                                    // Carry cubit block context forward
                                    value: context.read<ProfileCubit>(),
                                    // Insurance details page screen
                                    child: const InsuranceDetailsPage(),
                                  ),
                                ),
                              );
                            },
                          )
                        : InsuranceCardWidget(
                            // Insurance card model data
                            card: state.profile.insurance_cards.first,
                            // Render styled digital gradient card
                            isGradientStyle: true,
                            // Push navigate to insurance details screen layout onTap
                            onTap: () {
                              // Push navigate
                              Navigator.of(context).push(
                                // Route builder
                                MaterialPageRoute(
                                  // Builder constructor
                                  builder: (route_context) =>
                                      BlocProvider.value(
                                    // Carry cubit block context forward
                                    value: context.read<ProfileCubit>(),
                                    // Insurance details page screen
                                    child: const InsuranceDetailsPage(),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable separate navigation card widget mapping title and count badge
class _MedicalCategoryCard extends StatelessWidget {
  // Category Title text string
  final String title;
  // Category Icon symbol representation
  final IconData icon;
  // Icon color configuration
  final Color iconColor;
  // Icon circle background color tint
  final Color iconBgColor;
  // Muted count badge label string
  final String badgeText;
  // Click handler tap callback
  final VoidCallback onTap;

  // Constructor mapping properties
  const _MedicalCategoryCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.badgeText,
    required this.onTap,
  });

  @override
  // Draw card widget structure details
  Widget build(BuildContext context) {
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Outer container card wrapper
    return Container(
      // Card decorations styling
      decoration: BoxDecoration(
        // Background color
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        // Corners radius curvature equivalent to 16 units
        // Corners radius curvature equivalent to 16 units
        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
        // Drop shadows
        boxShadow: [
          // Soft card shadow
          BoxShadow(
            // Shadow colors adapting to dark mode
            color: is_dark
                ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
            // Blur spread
            blurRadius: _LocalDimensions.shadow_blur,
            // Offset coordinates position
            offset: const Offset(0, 4),
          ),
        ],
        // Outline borders
        border: Border.all(
          // Border color
          color: is_dark
              ? AppColors.border_dark
              : AppColors.slate_200,
          // Boundary line thickness
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Material inkwell wrapper to support native press ripple feedback overlays
      child: Material(
        // Transparent colors
        color: AppColors.transparent,
        // Clickable area
        child: InkWell(
          // Curved corners radius
          borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
          // Bind click handler
          onTap: onTap,
          // Card padding offsets
          child: Padding(
            // Visual padding configurations
            padding: const EdgeInsets.symmetric(
              // Horizontal boundaries padding
              horizontal: AppSpacing.space_xl,
              // Vertical boundaries padding
              vertical: AppSpacing.space_l,
            ),
            // Horizontal row placing icon, title, badge, and navigation chevron
            child: Row(
              // Row elements
              children: [
                // Medical Icon graphic represent container
                Container(
                  // Padding offset
                  padding: const EdgeInsets.all(AppSpacing.space_s),
                  // Circle shape decoration
                  decoration: BoxDecoration(
                    // Background fill color tint
                    color: iconBgColor,
                    // Circle shape
                    shape: BoxShape.circle,
                  ),
                  // Icon vector graphic
                  child: Icon(
                    // Bind icon
                    icon,
                    // Color
                    color: iconColor,
                    // Size
                    size: _LocalDimensions.icon_size_medium,
                  ),
                ),
                // Divider spacing gap width
                const SizedBox(width: AppSpacing.space_m),
                // Title widget taking expanded horizontal space
                Expanded(
                  // Title text
                  child: Text(
                    // Bind title
                    title,
                    // Typographic specs
                    style: TextStyle(
                      // Size
                      fontSize: _LocalDimensions.font_size_body,
                      // Bold weights
                      fontWeight: FontWeight.bold,
                      // Color
                      color: is_dark ? AppColors.white : AppColors.text_light_primary,
                    ),
                  ),
                ),
                // Muted count items badge container
                Container(
                  // Padding offsets
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_s, vertical: AppSpacing.space_xs),
                  // Card decoration
                  decoration: BoxDecoration(
                    // Light blue transparent background or grey background
                    color: is_dark
                        ? AppColors.white.withValues(alpha: _LocalDimensions.shadow_opacity_light)
                        : AppColors.primary_color.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                    // Rounded border contours
                    borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_badge),
                  ),
                  // Badge count label
                  child: Text(
                    // Bind label
                    badgeText,
                    // Style specs
                    style: TextStyle(
                      // Tiny size
                      fontSize: _LocalDimensions.font_size_tiny,
                      // Semi-bold
                      fontWeight: FontWeight.w600,
                      // Color blue or white adapted
                      color: is_dark ? AppColors.white70 : AppColors.primary_color,
                    ),
                  ),
                ),
                // Spacing gap width
                const SizedBox(width: AppSpacing.space_s),
                // Right navigation chevron indicator
                Icon(
                  // Chevron right symbol
                  Icons.chevron_right_rounded,
                  // Muted color adaptions
                  color: is_dark ? AppColors.white30 : AppColors.text_light_secondary,
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
      ..strokeWidth = _LocalDimensions.dash_stroke_width
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

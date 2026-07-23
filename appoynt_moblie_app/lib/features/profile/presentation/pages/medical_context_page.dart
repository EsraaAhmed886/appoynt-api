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
 * Last Modified Date: [Kholoud Khaled - 20/07/2026]
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
    // Check if Arabic mode is active
    final bool is_ar = localizations.is_arabic;
    // Yoda comparison if zero count
    if (0 == count) {
      // Return localized empty string
      return true == is_ar ? 'لا يوجد' : 'No items';
    }
    // Yoda comparison if single item
    if (1 == count) {
      // Return singular label
      return true == is_ar ? 'عنصر واحد' : '1 item';
    }
    // Return plural label
    return true == is_ar ? '$count عناصر' : '$count items';
  }

  // Helper to resolve localized count labels for medication prescriptions list
  String _get_prescription_count_label(int count, AppLocalizations localizations) {
    // Check if Arabic mode is active
    final bool is_ar = localizations.is_arabic;
    // Yoda comparison if zero count
    if (0 == count) {
      // Return empty label
      return true == is_ar ? 'لا يوجد' : 'No prescriptions';
    }
    // Yoda comparison if single item
    if (1 == count) {
      // Return singular label
      return true == is_ar ? 'روشتة واحدة' : '1 prescription';
    }
    // Return plural label
    return true == is_ar ? '$count روشتات' : '$count prescriptions';
  }

  // Helper to resolve localized count labels for medical files/results reports
  String _get_file_count_label(int count, AppLocalizations localizations) {
    // Check if Arabic mode is active
    final bool is_ar = localizations.is_arabic;
    // Yoda comparison if zero count
    if (0 == count) {
      // Return empty label
      return true == is_ar ? 'لا يوجد' : 'No files';
    }
    // Yoda comparison if single item
    if (1 == count) {
      // Return singular label
      return true == is_ar ? 'ملف واحد' : '1 file';
    }
    // Return plural label
    return true == is_ar ? '$count ملفات' : '$count files';
  }



  // Helper to resolve localized count labels for insurance cards list
  String _get_insurance_count_label(int count, AppLocalizations localizations) {
    // Check if Arabic mode is active
    final bool is_ar = localizations.is_arabic;
    // Yoda comparison if zero count
    if (0 == count) {
      // Return empty label
      return true == is_ar ? 'لا يوجد بطاقات' : 'No cards';
    }
    // Yoda comparison if single item
    if (1 == count) {
      // Return singular label
      return true == is_ar ? 'بطاقة واحدة' : '1 card';
    }
    // Yoda comparison if dual items
    if (2 == count) {
      // Return dual label
      return true == is_ar ? 'بطاقتان' : '2 cards';
    }
    // Return plural label
    return true == is_ar ? '$count بطاقات' : '$count cards';
  }

  // Helper to resolve localized count labels for family members
  String _get_members_count_label(int count, AppLocalizations localizations) {
    // Check if Arabic mode is active
    final bool is_ar = localizations.is_arabic;
    // Yoda comparison if zero count
    if (0 == count) {
      // Return empty label
      return true == is_ar ? 'لا يوجد أفراد' : 'No members';
    }
    // Yoda comparison if single item
    if (1 == count) {
      // Return singular label
      return true == is_ar ? 'عضو واحد' : '1 member';
    }
    // Yoda comparison if dual items
    if (2 == count) {
      // Return dual label
      return true == is_ar ? 'عضوان' : '2 members';
    }
    // Return plural label
    return true == is_ar ? '$count أعضاء' : '$count members';
  }

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
          : const Color(0xFFF1F5F9),
      // SafeArea protect
      body: SafeArea(
        // Scroll view
        child: SingleChildScrollView(
          // Padding
          child: Padding(
            // Margins strictly at 16px safe side boundaries
            padding: const EdgeInsets.symmetric(
              // Horizontal boundaries padding
              horizontal: AppSpacing.space_xl,
              // Vertical boundaries padding
              vertical: AppSpacing.space_m,
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
                      iconColor: Colors.deepOrange,
                      // Background tint
                      iconBgColor: Colors.deepOrange.withValues(alpha: 0.1),
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
                    const SizedBox(height: 16.0),

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
                    const SizedBox(height: 16.0),

                    // CARD B: Chronic Conditions Card
                    _MedicalCategoryCard(
                      // Title
                      title: localizations.profile_chronic_conditions,
                      // Pulse heart icon representation
                      icon: Icons.add_circle_outline_rounded,
                      // Teal color accent
                      iconColor: Colors.teal,
                      // Icon background tint fill
                      iconBgColor: Colors.teal.withValues(alpha: 0.1),
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
                    const SizedBox(height: 16.0),

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
                    const SizedBox(height: 16.0),

                    // CARD D: Tests and Results Card
                    _MedicalCategoryCard(
                      // Title
                      title: localizations.profile_tests_results,
                      // Assignment folder outline icon
                      icon: Icons.assignment_outlined,
                      // Purple color accent
                      iconColor: Colors.deepPurple,
                      // Background tint
                      iconBgColor: Colors.deepPurple.withValues(alpha: 0.1),
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
                    const SizedBox(height: 16.0),

                    // CARD E: MetLife Egypt Health Insurance Card or Category Card depending on count
                    true == state.profile.insurance_cards.isEmpty
                        ? _MedicalCategoryCard(
                            // Title
                            title: localizations.profile_insurance_details,
                            // Wallet card icon
                            icon: Icons.wallet_membership_rounded,
                            // Blue color accent
                            iconColor: Colors.blue,
                            // Background tint
                            iconBgColor: Colors.blue.withValues(alpha: 0.1),
                            // Localized count badge
                            badgeText: _get_insurance_count_label(0, localizations),
                            // Navigate onTap
                            onTap: () {
                              // Push navigate
                              Navigator.of(context).push(
                                // Route builder
                                MaterialPageRoute(
                                  // Builder constructor
                                  builder: (route_context) => BlocProvider.value(
                                    // Carry cubit block context forward
                                    value: context.read<ProfileCubit>(),
                                    // Insurance details page screen
                                    child: const InsuranceDetailsPage(),
                                  ),
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                            // Push navigate to insurance details screen layout onTap
                            onTap: () {
                              // Push navigate
                              Navigator.of(context).push(
                                // Route builder
                                MaterialPageRoute(
                                  // Builder constructor
                                  builder: (route_context) => BlocProvider.value(
                                    // Carry cubit block context forward
                                    value: context.read<ProfileCubit>(),
                                    // Insurance details page screen
                                    child: const InsuranceDetailsPage(),
                                  ),
                                ),
                              );
                            },
                            // Gradient container card
                            child: Container(
                              // Full width fill
                              width: double.infinity,
                              // Spacing padding inside MetLife Egypt card
                              padding: const EdgeInsets.all(AppSpacing.space_xl),
                              // Linear gradient details
                              decoration: BoxDecoration(
                                // MetLife premium dark navy to teal gradient finish
                                gradient: const LinearGradient(
                                  // Start angle
                                  begin: Alignment.topLeft,
                                  // End angle
                                  end: Alignment.bottomRight,
                                  // Gradient colors
                                  colors: [
                                    Color(0xFF0F2042), // Premium Dark Navy
                                    Color(0xFF0D5E6F), // Deep Teal
                                  ],
                                ),
                                // Corner radius Curvature
                                borderRadius: BorderRadius.circular(16.0),
                                // Soft shadow offsets
                                boxShadow: const [
                                  // Shadow options
                                  BoxShadow(
                                    // Dark color transparent shade
                                    color: Colors.black12,
                                    // Blur spread
                                    blurRadius: 10.0,
                                    // Position coordinate offsets
                                    offset: Offset(0.0, 4.0),
                                  ),
                                ],
                              ),
                              // Card elements column
                              child: Column(
                                // Start align
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // children
                                children: [
                                  // Upper card title header row displaying logo details and badge
                                  Row(
                                    // Distribute elements
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // Row children
                                    children: [
                                      // MetLife Egypt Title uppercase label
                                      const Text(
                                        // Egypt MetLife provider descriptor
                                        'METLIFE EGYPT HEALTH CARD',
                                        // Typography
                                        style: TextStyle(
                                          // Colors white transparency
                                          color: Colors.white70,
                                          // Tiny size
                                          fontSize: 10.0,
                                          // Bold weights
                                          fontWeight: FontWeight.bold,
                                          // Horizontal character spacing offset
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      // Sharp vector security verification shield in top-right corner
                                      Container(
                                        // Padding
                                        padding: const EdgeInsets.all(4.0),
                                        // Shape
                                        decoration: const BoxDecoration(
                                          // White translucent circle backplate
                                          color: Colors.white12,
                                          // Circle shape
                                          shape: BoxShape.circle,
                                        ),
                                        // Shield icon vector representation
                                        child: const Icon(
                                          // Verified user shield symbol
                                          Icons.verified_user_rounded,
                                          // Gold color
                                          color: Color(0xFFFFD700),
                                          // Size
                                          size: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Height spacer gap
                                  const SizedBox(height: AppSpacing.space_l),
                                  // Provider Name Title Text widget
                                  Text(
                                    // Provider name mapping target provider
                                    state.profile.insurance_cards.first.provider_name,
                                    // Style
                                    style: const TextStyle(
                                      // Colors
                                      color: Colors.white,
                                      // Bold size
                                      fontSize: 18.0,
                                      // Heavy weight
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Height spacer gap
                                  const SizedBox(height: AppSpacing.space_m),
                                  // Structure policy details rows
                                  Row(
                                    // Distribute items
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // children
                                    children: [
                                      // Policy info column
                                      Column(
                                        // Start align
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // children
                                        children: [
                                          // Uppercase micro-fonts (10px, muted opacity) directly above actual values
                                          const Text(
                                            // POLICY NUMBER label
                                            'POLICY NUMBER',
                                            // Typographic specs
                                            style: TextStyle(
                                              // Muted white colors
                                              color: Colors.white60,
                                              // Micro size
                                              fontSize: 10.0,
                                              // Bold
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Spacer gap height
                                          const SizedBox(height: 4.0),
                                          // Policy value text widget with high-contrast typography
                                          Text(
                                            // Card identification number mapping details
                                            state.profile.insurance_cards.first.card_number,
                                            // Style
                                            style: const TextStyle(
                                              // High-contrast typography color
                                              color: Colors.white,
                                              // Size
                                              fontSize: 13.0,
                                              // Bolder weights
                                              fontWeight: FontWeight.bold,
                                              // Monospace text alignments
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Expiry info column
                                      Column(
                                        // Start align
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // children
                                        children: [
                                          // Uppercase micro-fonts (10px, muted opacity) directly above actual values
                                          const Text(
                                            // EXPIRY DATE label
                                            'EXPIRY DATE',
                                            // Typographic specs
                                            style: TextStyle(
                                              // Muted white colors
                                              color: Colors.white60,
                                              // Micro size
                                              fontSize: 10.0,
                                              // Bold
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Spacer gap height
                                          const SizedBox(height: 4.0),
                                          // Expiry date text widget with high-contrast typography
                                          Text(
                                            // Expiring date string representation
                                            state.profile.insurance_cards.first.expiry_date,
                                            // Style
                                            style: const TextStyle(
                                              // High-contrast typography color
                                              color: Colors.white,
                                              // Size
                                              fontSize: 13.0,
                                              // Bolder weights
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
        color: true == is_dark ? AppColors.surface_dark : Colors.white,
        // Corners radius curvature equivalent to 16 units
        borderRadius: BorderRadius.circular(16.0),
        // Drop shadows
        boxShadow: [
          // Soft card shadow
          BoxShadow(
            // Shadow colors adapting to dark mode
            color: true == is_dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            // Blur spread
            blurRadius: 10.0,
            // Offset coordinates position
            offset: const Offset(0, 4),
          ),
        ],
        // Outline borders
        border: Border.all(
          // Border color
          color: true == is_dark
              ? AppColors.border_dark
              : const Color(0xFFE2E8F0),
          // Boundary line thickness
          width: AppSpacing.border_width_thin,
        ),
      ),
      // Material inkwell wrapper to support native press ripple feedback overlays
      child: Material(
        // Transparent colors
        color: Colors.transparent,
        // Clickable area
        child: InkWell(
          // Curved corners radius
          borderRadius: BorderRadius.circular(16.0),
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
                  padding: const EdgeInsets.all(8.0),
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
                    size: 20.0,
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
                      fontSize: 14.0,
                      // Bold weights
                      fontWeight: FontWeight.bold,
                      // Color
                      color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                    ),
                  ),
                ),
                // Muted count items badge container
                Container(
                  // Padding offsets
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  // Card decoration
                  decoration: BoxDecoration(
                    // Light blue transparent background or grey background
                    color: true == is_dark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.primary_color.withValues(alpha: 0.05),
                    // Rounded border contours
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  // Badge count label
                  child: Text(
                    // Bind label
                    badgeText,
                    // Style specs
                    style: TextStyle(
                      // Tiny size
                      fontSize: 11.0,
                      // Semi-bold
                      fontWeight: FontWeight.w600,
                      // Color blue or white adapted
                      color: true == is_dark ? Colors.white70 : AppColors.primary_color,
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
                  color: true == is_dark ? Colors.white30 : AppColors.text_light_secondary,
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

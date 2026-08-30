/*
 * File Name: medical_context_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V3.1.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Dedicated screen displaying patient medical records, family dependents, chronic conditions, and health insurance using unified MedicalHistoryTile.
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

                    // SECTION: Unified Reusable Medical History Cards

                    // CARD 0: Family Members Card
                    MedicalHistoryTile(
                      icon: Icons.people_outline_rounded,
                      iconColor: AppColors.deepOrange,
                      iconBgColor: AppColors.deepOrange.withValues(alpha: 0.1),
                      title: localizations.profile_dependents_title,
                      statusText: _get_members_count_label(3, localizations),
                      hasItems: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (route_context) => BlocProvider.value(
                              value: context.read<ProfileCubit>(),
                              child: const FamilyMembersPage(),
                            ),
                          ),
                        );
                      },
                    ),

                    // CARD 1: Allergies Card
                    MedicalHistoryTile(
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.error,
                      iconBgColor: AppColors.error.withValues(alpha: 0.1),
                      title: localizations.profile_allergies,
                      statusText: _get_item_count_label(all_allergies.length, localizations),
                      hasItems: true == all_allergies.isNotEmpty,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (route_context) => BlocProvider.value(
                              value: context.read<ProfileCubit>(),
                              child: const AllergiesPage(),
                            ),
                          ),
                        );
                      },
                    ),

                    // CARD 2: Chronic Conditions Card
                    MedicalHistoryTile(
                      icon: Icons.add_circle_outline_rounded,
                      iconColor: AppColors.teal,
                      iconBgColor: AppColors.teal.withValues(alpha: 0.1),
                      title: localizations.profile_chronic_conditions,
                      statusText: _get_item_count_label(state.profile.chronic_conditions.length, localizations),
                      hasItems: true == state.profile.chronic_conditions.isNotEmpty,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (route_context) => BlocProvider.value(
                              value: context.read<ProfileCubit>(),
                              child: const ChronicConditionsPage(),
                            ),
                          ),
                        );
                      },
                    ),

                    // CARD 3: Medications List Card
                    MedicalHistoryTile(
                      icon: Icons.medication_outlined,
                      iconColor: AppColors.primary_color,
                      iconBgColor: AppColors.primary_color.withValues(alpha: 0.1),
                      title: localizations.profile_medications,
                      statusText: _get_prescription_count_label(state.profile.prescriptions.length, localizations),
                      hasItems: true == state.profile.prescriptions.isNotEmpty,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (route_context) => BlocProvider.value(
                              value: context.read<ProfileCubit>(),
                              child: const PrescriptionsPage(),
                            ),
                          ),
                        );
                      },
                    ),

                    // CARD 4: Tests and Results Card
                    MedicalHistoryTile(
                      icon: Icons.assignment_outlined,
                      iconColor: AppColors.deepPurple,
                      iconBgColor: AppColors.deepPurple.withValues(alpha: 0.1),
                      title: localizations.profile_tests_results,
                      statusText: _get_file_count_label(files_count, localizations),
                      hasItems: 0 < files_count,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (route_context) => BlocProvider.value(
                              value: context.read<ProfileCubit>(),
                              child: const TestsResultsPage(),
                            ),
                          ),
                        );
                      },
                    ),

                    // CARD 5: Insurance Details Card (Unified MedicalHistoryTile without text truncation)
                    MedicalHistoryTile(
                      icon: Icons.credit_card_rounded,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                      title: localizations.profile_insurance_details,
                      statusText: _get_insurance_count_label(state.profile.insurance_cards.length, localizations),
                      hasItems: true == state.profile.insurance_cards.isNotEmpty,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (route_context) => BlocProvider.value(
                              value: context.read<ProfileCubit>(),
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

// -----------------------------------------------------------------------------
// Unified Reusable Medical History Card Widget
// -----------------------------------------------------------------------------
class MedicalHistoryTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String statusText;
  final bool hasItems;
  final VoidCallback onTap;

  const MedicalHistoryTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.statusText,
    required this.hasItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate200,
          width: AppSpacing.border_width_thin,
        ),
        boxShadow: is_dark
            ? []
            : [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.02),
                  blurRadius: 10.0,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // 1. Icon Container
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(icon, color: iconColor, size: 20.0),
                ),
                const SizedBox(width: 14.0),

                // 2. Title (Takes remaining available space with no premature clipping)
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: is_dark ? AppColors.darkTextPrimary : AppColors.slate900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),

                // 3. Status Badge (Compact Chip)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: true == hasItems
                        ? AppColors.primary_color.withValues(alpha: 0.12)
                        : (is_dark ? AppColors.darkBackground : AppColors.primary.withValues(alpha: 0.08)),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: true == hasItems ? AppColors.primary_color : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),

                // 4. Chevron Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.0,
                  color: is_dark ? AppColors.darkTextMuted : AppColors.slate400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

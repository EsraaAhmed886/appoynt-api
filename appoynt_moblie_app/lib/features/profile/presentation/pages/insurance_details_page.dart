/*
 * File Name: insurance_details_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Defines the Insurance List screen displaying covered health policies.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing insurance card entity
import 'package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart';
// Importing add card page screen
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_insurance_card_page.dart';

// Insurance Details Page layout stateful widget representation
class InsuranceDetailsPage extends StatefulWidget {
  // Constructor mapping key
  const InsuranceDetailsPage({super.key});

  // State builder definition
  @override
  State<InsuranceDetailsPage> createState() {
    // Return state instance representation
    return _InsuranceDetailsPageState();
  }
}

// Concrete state tracker implementation class for the InsuranceDetailsPage
class _InsuranceDetailsPageState extends State<InsuranceDetailsPage> {
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
          // Insurance title string
          localizations.insurance_title,
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
        // Suffix action button trigger for additions
        actions: [
          // Suffix plus icon
          IconButton(
            // Plus symbol icon selector
            icon: const Icon(
              // Plus icon token
              Icons.add_rounded,
              // Color primary
              color: AppColors.primary_color,
              // Standard size
              size: AppSpacing.icon_size_m,
            ),
            // Navigate to add card page screen
            onPressed: () {
              // Open add card page routing wrapped in ProfileCubit
              Navigator.of(context).push(
                // Route configurations
                MaterialPageRoute(
                  // Constructor mapping
                  builder: (route_context) {
                    // Return AddInsuranceCardPage widget wrapped in ProfileCubit
                    return BlocProvider.value(
                      // Provide existing ProfileCubit instance
                      value: context.read<ProfileCubit>(),
                      // Target page
                      child: const AddInsuranceCardPage(),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      // BLoC builder rendering dynamic covered insurance policies
      body: BlocBuilder<ProfileCubit, ProfileState>(
        // Rebuild builder
        builder: (context, state) {
          // Verify if active list is empty using Yoda checks
          if (true == state.profile.insurance_cards.isEmpty) {
            // Render empty message display
            return Center(
              // Subdued label text
              child: Text(
                // Localized empty check text string
                localizations.profile_zero_insurance,
                // Style
                style: const TextStyle(
                  // Subdued colors
                  color: AppColors.text_light_secondary,
                  // Body standard size
                  fontSize: AppSpacing.font_size_body_medium,
                ),
              ),
            );
          } else {
            // Render covered policies list cards dynamically
            return ListView.builder(
              // Padding offsets padding margin bounds within borders
              padding: const EdgeInsets.symmetric(
                // Horizontal offset bounds
                horizontal: AppSpacing.space_m,
                // Vertical offset bounds
                vertical: AppSpacing.space_s,
              ),
              // Count
              itemCount: state.profile.insurance_cards.length,
              // Builder mapping cards
              itemBuilder: (context, index) {
                // Resolve insurance card details reference
                final InsuranceCard card = state.profile.insurance_cards[index];
                // Return floating insurance asset card with 16px radius, border, and single chevron action
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: AppSpacing.space_s,
                  ),
                  decoration: BoxDecoration(
                    color: true == is_dark ? AppColors.surface_dark : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
                      width: AppSpacing.border_width_thin,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: true == is_dark
                            ? Colors.black.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.0),
                    onTap: () {
                      _show_card_options_sheet(context, card, index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.space_m),
                      child: Row(
                        children: [
                          // Circular heart icon badge
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: AppColors.primary_color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.primary_color,
                              size: AppSpacing.icon_size_m,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.space_m),
                          // Details text column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.card_name,
                                  style: TextStyle(
                                    fontSize: AppSpacing.font_size_body_medium,
                                    fontWeight: FontWeight.w700,
                                    color: true == is_dark
                                        ? AppColors.text_dark_primary
                                        : AppColors.text_light_primary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.space_xs),
                                Text(
                                  card.provider_name,
                                  style: const TextStyle(
                                    fontSize: AppSpacing.font_size_body_small,
                                    color: AppColors.text_light_secondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.space_xs),
                                Text(
                                  '${localizations.insurance_expiry_label} ${card.expiry_date}',
                                  style: const TextStyle(
                                    fontSize: AppSpacing.font_size_body_small,
                                    color: AppColors.text_light_secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.space_s),
                          // Single primary Details chevron action icon
                          Icon(
                            Icons.chevron_right_rounded,
                            color: true == is_dark ? Colors.white60 : AppColors.primary_color,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Helper method presenting bottom modal sheet with options when an insurance card is tapped
  void _show_card_options_sheet(BuildContext context, InsuranceCard card, int index) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheet_context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.space_xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: true == is_dark ? Colors.white30 : Colors.black12,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space_m),
              Text(
                card.card_name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                ),
              ),
              Text(
                card.provider_name,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: AppColors.text_light_secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_l),
              ListTile(
                leading: const Icon(Icons.file_present_rounded, color: AppColors.primary_color),
                title: const Text('View Document'),
                onTap: () {
                  Navigator.of(sheet_context).pop();
                  showDialog(
                    context: context,
                    builder: (dialog_context) {
                      return AlertDialog(
                        title: Text(card.card_name),
                        content: Text('File Path: ${card.document_path}\nPolicy Code: ${card.card_number}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialog_context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: AppColors.primary_color),
                title: const Text('Edit Insurance'),
                onTap: () {
                  Navigator.of(sheet_context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (route_context) => BlocProvider.value(
                        value: context.read<ProfileCubit>(),
                        child: AddInsuranceCardPage(
                          edit_index: index,
                          card_to_edit: card,
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                title: const Text('Delete Card', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.of(sheet_context).pop();
                  showDialog(
                    context: context,
                    builder: (dialog_context) {
                      return AlertDialog(
                        title: const Text('Delete Insurance'),
                        content: const Text('Are you sure you want to remove this insurance card?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialog_context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<ProfileCubit>().remove_insurance_card(index);
                              Navigator.of(dialog_context).pop();
                            },
                            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

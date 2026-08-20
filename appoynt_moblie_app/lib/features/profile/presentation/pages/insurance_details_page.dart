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
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
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

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_sheet = 24.0;
  static const double border_radius_tiny = 2.0;
  static const double drag_handle_width = 40.0;
  static const double drag_handle_height = 4.0;
  static const double font_size_title = 18.0;
  static const double font_size_body = 13.0;
}

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

    // Return root Scaffold layout container
    return Scaffold(
      // Fixed sticky bottom action bar containing full-width primary CTA
      bottomNavigationBar: StickyBottomBar(
        // Full width action container wrapper
        child: SizedBox(
          // Match full screen available width
          width: double.infinity,
          // Standard CTA height matching auth buttons (50.0px)
          height: AppSpacing.height_auth_button,
          // Primary Elevated Button trigger for adding a new card
          child: ElevatedButton(
            // Navigate to Add Insurance Card page route on tap
            onPressed: () {
              // Open add card screen wrapped in existing ProfileCubit instance
              Navigator.of(context).push(
                // Material route configuration
                MaterialPageRoute(
                  // Route builder callback
                  builder: (route_context) {
                    // Return AddInsuranceCardPage widget wrapped in ProfileCubit
                    return BlocProvider.value(
                      // Provide active ProfileCubit controller instance
                      value: context.read<ProfileCubit>(),
                      // Target screen widget
                      child: const AddInsuranceCardPage(),
                    );
                  },
                ),
              );
            },
            // Button styling configuration
            style: ElevatedButton.styleFrom(
              // Vibrant brand blue primary color tint (#1D4ED8)
              backgroundColor: AppColors.primary_color,
              // Clear shadows for flat surface alignment
              elevation: 0.0,
              // Curved corner radius shape (12.0px radius token)
              shape: RoundedRectangleBorder(
                // Rounded corner radius 12px
                borderRadius: BorderRadius.circular(AppSpacing.radius_l),
              ),
            ),
            // Button label text child widget
            child: Text(
              // Localized action string "Add Insurance Card" / "إضافة بطاقة تأمين"
              localizations.insurance_add_card_full_btn,
              // Text typography styling parameters
              style: const TextStyle(
                // White text color tint
                color: AppColors.white,
                // Action button font size token
                fontSize: AppSpacing.font_size_action_button,
                // Bold typography font weight
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      // Screen main body wrapped in SafeArea and 16px lateral padding
      body: SafeArea(
        // Outer padding applying strict 16px side canvas margins
        child: Padding(
          // Horizontal side margins 16.0px
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          // Column stacking header and body list
          child: Column(
            // Align children to start horizontal axis
            crossAxisAlignment: CrossAxisAlignment.start,
            // Children array
            children: [
              // Top 16px vertical baseline spacing margin gap
              const SizedBox(height: AppSpacing.space_xl),
              // Shared Squircle Back Button AppBar component
              CustomProfileAppBar(
                // Centered screen title string
                title: localizations.insurance_title,
              ),
              // Vertical separation gap
              const SizedBox(height: AppSpacing.space_l),
              // Expanded container wrapping dynamic card list or empty view
              Expanded(
                // BLoC builder listening to ProfileState updates
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  // State builder callback
                  builder: (context, state) {
                    // Yoda check verifying if insurance cards list is empty
                    if (true == state.profile.insurance_cards.isEmpty) {
                      // Render empty state layout
                      return Center(
                        // Empty message text widget
                        child: Text(
                          // Localized zero insurance cards message
                          localizations.profile_zero_insurance,
                          // Subdued text style
                          style: const TextStyle(
                            // Secondary muted text color tint
                            color: AppColors.text_light_secondary,
                            // Medium body font size token
                            fontSize: AppSpacing.font_size_body_medium,
                          ),
                        ),
                      );
                    } else {
                      // Render ListView builder displaying health policies
                      return ListView.builder(
                        // Remove default list view padding as parent padding applies 16px horizontal margin
                        padding: const EdgeInsets.symmetric(
                          // Vertical list padding margin bounds
                          vertical: AppSpacing.space_s,
                        ),
                        // Item count matching cards array length
                        itemCount: state.profile.insurance_cards.length,
                        // Item builder function
                        itemBuilder: (context, index) {
                          // Resolve insurance card instance reference
                          final InsuranceCard card = state.profile.insurance_cards[index];
                          // Return shared zero-overflow insurance card widget
                          return InsuranceCardWidget(
                            // Insurance card model instance
                            card: card,
                            // Card tap callback handler
                            onTap: () {
                              // Launch bottom sheet options modal
                              _show_card_options_sheet(context, card, index);
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method presenting bottom modal sheet with options when an insurance card is tapped
  void _show_card_options_sheet(BuildContext context, InsuranceCard card, int index) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      builder: (sheet_context) {
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(_LocalDimensions.border_radius_sheet)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space_xl),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: _LocalDimensions.drag_handle_width,
                  height: _LocalDimensions.drag_handle_height,
                  decoration: BoxDecoration(
                    color: is_dark ? AppColors.white30 : AppColors.black12,
                    borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_tiny),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space_m),
              Text(
                card.card_name,
                style: TextStyle(
                  fontSize: _LocalDimensions.font_size_title,
                  fontWeight: FontWeight.bold,
                  color: is_dark ? AppColors.white : AppColors.text_light_primary,
                ),
              ),
              Text(
                card.provider_name,
                style: const TextStyle(
                  fontSize: _LocalDimensions.font_size_body,
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
        ),
      );
    },
    );
  }
}

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
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
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
                // Return card container layout outline
                return Container(
                  // Padding within card
                  padding: const EdgeInsets.all(AppSpacing.space_m),
                  // Margin between cards
                  margin: const EdgeInsets.symmetric(
                    // Vertical space gap
                    vertical: AppSpacing.space_s,
                  ),
                  // Style configurations
                  decoration: BoxDecoration(
                    // Surface background colors
                    color: true == is_dark ? AppColors.surface_dark : Colors.white,
                    // Rounded corners configuration
                    borderRadius: BorderRadius.circular(
                      // Corner radius token
                      AppSpacing.radius_l,
                    ),
                    // soft shadows
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
                  // Horizontal row displaying card details and actions
                  child: Row(
                    // Row elements
                    children: [
                      // Blue heart shield icon badge representing coverage options
                      Container(
                        // Badge width
                        width: 48.0,
                        // Badge height
                        height: 48.0,
                        // Layout style configurations
                        decoration: BoxDecoration(
                          // Brand primary blue background with slight opacity
                          color: AppColors.primary_color.withValues(alpha: 0.1),
                          // Shape settings circular
                          shape: BoxShape.circle,
                        ),
                        // Plus plus icon graphic centered inside badge
                        child: const Icon(
                          // Heart plus icon token
                          Icons.favorite_rounded,
                          // Color primary
                          color: AppColors.primary_color,
                          // Standard size
                          size: AppSpacing.icon_size_m,
                        ),
                      ),
                      // Spacer horizontal gap
                      const SizedBox(
                        // Spacer width offset
                        width: AppSpacing.space_m,
                      ),
                      // Details text fields column taking remaining width space
                      Expanded(
                        // Column stack grouping titles vertically
                        child: Column(
                          // Align text labels to start coordinates
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // children array
                          children: [
                            // Card name label
                            Text(
                              // Bind card name
                              card.card_name,
                              // style
                              style: TextStyle(
                                // Medium body size
                                fontSize: AppSpacing.font_size_body_medium,
                                // bold weight
                                fontWeight: FontWeight.w700,
                                // Dynamic text color adjusting to dark/light surfaces
                                color: true == is_dark
                                    ? AppColors.text_dark_primary
                                    : AppColors.text_light_primary,
                              ),
                            ),
                            // Spacer gap
                            const SizedBox(
                              // Spacing height
                              height: AppSpacing.space_xs,
                            ),
                            // Provider name label
                            Text(
                              // Bind provider
                              card.provider_name,
                              // style
                              style: const TextStyle(
                                // Small body size font
                                fontSize: AppSpacing.font_size_body_small,
                                // Secondary color styling
                                color: AppColors.text_light_secondary,
                              ),
                            ),
                            // Spacer gap
                            const SizedBox(
                              // Spacing height
                              height: AppSpacing.space_xs,
                            ),
                            // Expiry date label text
                            Text(
                              // Localized expiry date string format
                              '${localizations.insurance_expiry_label} ${card.expiry_date}',
                              // style
                              style: const TextStyle(
                                // Small body size font
                                fontSize: AppSpacing.font_size_body_small,
                                // Secondary color styling
                                color: AppColors.text_light_secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Spacer horizontal gap
                      const SizedBox(
                        // Separator width value
                        width: AppSpacing.space_s,
                      ),
                      // Column stacking View button and Edit/Delete icon buttons
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Outlined View button
                          SizedBox(
                            height: 32.0,
                            child: OutlinedButton(
                              // View attached document on click
                              onPressed: () {
                                // Show document feedback dialog mockup
                                showDialog(
                                  // Context
                                  context: context,
                                  // Builder
                                  builder: (dialog_context) {
                                    // Return dialog
                                    return AlertDialog(
                                      // Title
                                      title: Text(card.card_name),
                                      // Content detail path
                                      content: Text('File Path: ${card.document_path}\nPolicy Code: ${card.card_number}'),
                                      // Actions
                                      actions: [
                                        // OK button
                                        TextButton(
                                          // Pop dialog
                                          onPressed: () {
                                            // Close modal
                                            Navigator.of(dialog_context).pop();
                                          },
                                          // label
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              // Style configs
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_m),
                                // outline border colors
                                side: const BorderSide(
                                  // primary blue
                                  color: AppColors.primary_color,
                                  // thickness
                                  width: AppSpacing.border_width_thin,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.radius_m),
                                ),
                              ),
                              // Label text
                              child: Text(
                                // Localized View label
                                localizations.insurance_view_btn,
                                // style
                                style: const TextStyle(
                                  // primary blue
                                  color: AppColors.primary_color,
                                  // bold weight
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space_xs),
                          // Row displaying Edit & Delete buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  color: AppColors.primary_color,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  // Open edit card page screen wrapped in ProfileCubit provider
                                  Navigator.of(context).push(
                                    // Route configurations
                                    MaterialPageRoute(
                                      // Constructor mapping
                                      builder: (route_context) {
                                        // Return AddInsuranceCardPage widget wrapped in ProfileCubit
                                        return BlocProvider.value(
                                          // Provide existing ProfileCubit instance
                                          value: context.read<ProfileCubit>(),
                                          // Target page in edit mode
                                          child: AddInsuranceCardPage(
                                            edit_index: index,
                                            card_to_edit: card,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: AppSpacing.space_m),
                              // Delete button
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  // Confirm deletion dialog popup
                                  showDialog(
                                    context: context,
                                    builder: (dialog_context) {
                                      return AlertDialog(
                                        title: const Text('Delete Insurance'),
                                        content: const Text('Are you sure you want to remove this insurance card?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialog_context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Remove card from cubit list index
                                              context.read<ProfileCubit>().remove_insurance_card(index);
                                              // Dismiss confirmation modal
                                              Navigator.of(dialog_context).pop();
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(color: AppColors.error),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

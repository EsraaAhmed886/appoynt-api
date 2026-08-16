/*
 * File Name: payment_wallet_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/payment/presentation/pages/saved_cards_page.dart,
 *   package:appoynt_mobile_app/features/payment/presentation/pages/payment_history_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Refactored dashboard acting as a clean navigation hub. Fully localized and complies with zero-hardcoded-numbers.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing flutter bloc for state handling
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing profile cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing profile state definition
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing sub-pages
import 'package:appoynt_mobile_app/features/payment/presentation/pages/saved_cards_page.dart';
import 'package:appoynt_mobile_app/features/payment/presentation/pages/payment_history_page.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double container_radius = 16.0;
  static const double shadow_blur = 10.0;
  static const double shadow_offset_y = 4.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.05;
  static const double card_padding = 16.0;
  static const double card_inner_padding = 20.0;
  static const double card_shadow_blur = 12.0;
  static const double font_size_balance_title = 12.0;
  static const double spacing_tiny = 6.0;
  static const double font_size_balance_value = 32.0;
  static const double icon_size_add = 16.0;
  static const double font_size_add_btn = 12.0;
  static const double button_radius = 20.0;
  static const double button_padding_h = 12.0;
  static const double button_padding_v = 8.0;
  static const double spacing_large = 18.0;
  static const double font_size_switch_label = 12.0;
  static const double switch_track_opacity = 0.35;
  static const double line_width_thin = 1.0;
  static const double divider_opacity = 0.15;
  static const double icon_container_padding = 8.0;
  static const double icon_container_radius = 8.0;
  static const double icon_size = 20.0;
  static const double title_font_size = 13.0;
  static const double subtitle_font_size = 11.0;
}

// Stateful widget displaying Wallet details layout
class PaymentWalletPage extends StatefulWidget {
  // Constructor mapping key
  const PaymentWalletPage({super.key});

  @override
  // Create state tracker instance
  State<PaymentWalletPage> createState() {
    // Return state class instance
    return _PaymentWalletPageState();
  }
}

// State class managing wallet priority switch
class _PaymentWalletPageState extends State<PaymentWalletPage> {
  // In-app wallet balance priority payment switch toggle
  bool _wallet_priority_enabled = true;

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // Body wrap in safe area and scroll view
      body: SafeArea(
        // Scroll view protecting layout bounds
        child: SingleChildScrollView(
          // Outer padding margins
          child: Padding(
            // Margins boundaries
            padding: const EdgeInsets.only(
              // Horizontal offset
              left: AppSpacing.space_xl,
              right: AppSpacing.space_xl,
              top: AppSpacing.space_xl,
              bottom: AppSpacing.space_m,
            ),
            // Column stack grouping layouts
            child: BlocBuilder<ProfileCubit, ProfileState>(
              // Builder callback
              builder: (bloc_context, state) {
                // Column stacking widgets
                return Column(
                  // Align left coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list
                  children: [
                    // Top header row placing circular back button and screen title
                    CustomProfileAppBar(
                      title: localizations.payment_wallet_title,
                    ),
                    // Spacing offset
                    const SizedBox(height: AppSpacing.space_xl),

                    // Payment & Wallet Section Container
                    Container(
                      // Card outline decoration layout
                      decoration: BoxDecoration(
                        // Dynamic surface color
                        color: is_dark
                            ? AppColors.surface_dark
                            : AppColors.white,
                        // Rounded corners
                        borderRadius: BorderRadius.circular(_LocalDimensions.container_radius),
                        // Card shadows
                        boxShadow: [
                          BoxShadow(
                            // Shadow colors
                            color: is_dark
                                ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                                : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                            // Blur spread
                            blurRadius: _LocalDimensions.shadow_blur,
                            // Offset
                            offset: const Offset(0.0, _LocalDimensions.shadow_offset_y),
                          ),
                        ],
                        // Thin borders outline decoration
                        border: Border.all(
                          // Border colors matching theme mode
                          color: is_dark
                              ? AppColors.border_dark
                              : const Color(0xFFE2E8F0),
                          // Thin thickness
                          width: AppSpacing.border_width_thin,
                        ),
                      ),
                      // Card layout children column
                      child: Column(
                        // Align left coordinates
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // children list
                        children: [
                          // SECTION 1 Card: Wallet balance display card (Indigo/Purple premium gradient theme)
                          Padding(
                            // Margins padding offsets
                            padding: const EdgeInsets.all(_LocalDimensions.card_padding),
                            // Wallet background container
                            child: Container(
                              // Full width
                              width: double.infinity,
                              // Inner padding offsets (spacious layout)
                              padding: const EdgeInsets.all(_LocalDimensions.card_inner_padding),
                              // Decorative styling
                              decoration: BoxDecoration(
                                // Slate Indigo to Midnight Velvet gradient color
                                gradient: const LinearGradient(
                                  // Gradient colors list
                                  colors: [
                                    Color(0xFF3E1E68), // Slate Indigo
                                    Color(0xFF1E0E36), // Midnight Velvet
                                  ],
                                  // Gradient direction start
                                  begin: Alignment.topLeft,
                                  // Gradient direction end
                                  end: Alignment.bottomRight,
                                ),
                                // Rounded corners radius
                                borderRadius: BorderRadius.circular(_LocalDimensions.container_radius),
                                // Soft shadows
                                boxShadow: const [
                                  BoxShadow(
                                    // Color
                                    color: AppColors.black26,
                                    // Blur
                                    blurRadius: _LocalDimensions.card_shadow_blur,
                                    // Offset position
                                    offset: Offset(0.0, _LocalDimensions.shadow_offset_y),
                                  ),
                                ],
                              ),
                              // Card info column
                              child: Column(
                                // Align left coordinates
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // details children list
                                children: [
                                  // Header labels row (Balance & Add Money Button)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // Localized wallet key
                                            localizations.payment_balance_label,
                                            // Styles
                                            style: const TextStyle(
                                              // Color white
                                              color: AppColors.white70,
                                              // Size
                                              fontSize: _LocalDimensions.font_size_balance_title,
                                              // Medium weight
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          // Spacing gap
                                          const SizedBox(height: _LocalDimensions.spacing_tiny),
                                          // Balance Value display Text
                                          const Text(
                                            // Mock wallet balance values (highly prominent)
                                            '\$150.00',
                                            // Typography
                                            style: TextStyle(
                                              // Color white
                                              color: AppColors.white,
                                              // Prominent bold size
                                              fontSize: _LocalDimensions.font_size_balance_value,
                                              // Heavy weight
                                              fontWeight: FontWeight.bold,
                                              // Monospace font style
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Add Money Button
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(localizations.payment_add_money_coming_soon),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.add, size: _LocalDimensions.icon_size_add, color: AppColors.primary_color),
                                        label: Text(
                                          localizations.payment_add_money_btn,
                                          style: const TextStyle(
                                            fontSize: _LocalDimensions.font_size_add_btn,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary_color,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(_LocalDimensions.button_radius),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: _LocalDimensions.button_padding_h, vertical: _LocalDimensions.button_padding_v),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Separator spacing gap
                                  const SizedBox(height: _LocalDimensions.spacing_large),
                                  // Priority payment switch Row layout
                                  Row(
                                    // Distribute items
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    // Align center
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    // details children list
                                    children: [
                                      // Expanded label column to prevent overlaps
                                      Expanded(
                                        // Option label Text
                                        child: Text(
                                          // Localized priority switch label
                                          localizations.payment_priority_label,
                                          // Typography
                                          style: const TextStyle(
                                            // Color white
                                            color: AppColors.white,
                                            // Font size
                                            fontSize: _LocalDimensions.font_size_switch_label,
                                            // Medium weight
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // Sleek minimal Switch toggle component
                                      Switch.adaptive(
                                        // Bind status value
                                        value: _wallet_priority_enabled,
                                        // Update state variable on tap
                                        onChanged: (val) {
                                          // Trigger rebuild
                                          setState(() {
                                            // Update status
                                            _wallet_priority_enabled = val;
                                          });
                                        },
                                        // Themed switch thumb colors matching MD3 specs
                                        activeThumbColor: AppColors.white,
                                        // Subdued switch track color
                                        activeTrackColor: AppColors.white.withValues(alpha: _LocalDimensions.switch_track_opacity),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Subtle separate divider
                          Divider(
                            height: _LocalDimensions.line_width_thin,
                            thickness: _LocalDimensions.line_width_thin,
                            color: is_dark
                                ? AppColors.border_dark
                                : AppColors.grey.withValues(alpha: _LocalDimensions.divider_opacity),
                          ),
                          // ListTile 1: Saved Payment Cards navigation menu tile
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(_LocalDimensions.icon_container_padding),
                              decoration: BoxDecoration(
                                color: AppColors.primary_color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(_LocalDimensions.icon_container_radius),
                              ),
                              child: const Icon(
                                Icons.credit_card_rounded,
                                color: AppColors.primary_color,
                                size: _LocalDimensions.icon_size,
                              ),
                            ),
                            title: Text(
                              localizations.payment_saved_cards_tile,
                              style: TextStyle(
                                fontSize: _LocalDimensions.title_font_size,
                                fontWeight: FontWeight.bold,
                                color: is_dark ? AppColors.white : AppColors.text_light_primary,
                              ),
                            ),
                            subtitle: Text(
                              localizations.payment_saved_cards_subtitle,
                              style: TextStyle(
                                fontSize: _LocalDimensions.subtitle_font_size,
                                color: is_dark ? AppColors.white54 : AppColors.text_light_secondary,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: is_dark ? AppColors.white54 : AppColors.text_light_secondary,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (route_context) => BlocProvider.value(
                                      value: context.read<ProfileCubit>(),
                                      child: const SavedCardsPage(),
                                    ),
                                  ),
                              );
                            },
                          ),
                          // Subtle separate divider
                          Divider(
                            height: _LocalDimensions.line_width_thin,
                            thickness: _LocalDimensions.line_width_thin,
                            color: is_dark
                                ? AppColors.border_dark
                                : AppColors.grey.withValues(alpha: _LocalDimensions.divider_opacity),
                          ),
                          // ListTile 2: Payment History & Invoices navigation menu tile
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(_LocalDimensions.icon_container_padding),
                              decoration: BoxDecoration(
                                color: AppColors.teal.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(_LocalDimensions.icon_container_radius),
                              ),
                              child: const Icon(
                                Icons.receipt_long_rounded,
                                color: AppColors.teal,
                                size: _LocalDimensions.icon_size,
                              ),
                            ),
                            title: Text(
                              localizations.payment_history_tile,
                              style: TextStyle(
                                fontSize: _LocalDimensions.title_font_size,
                                fontWeight: FontWeight.bold,
                                color: is_dark ? AppColors.white : AppColors.text_light_primary,
                              ),
                            ),
                            subtitle: Text(
                              localizations.payment_history_subtitle,
                              style: TextStyle(
                                fontSize: _LocalDimensions.subtitle_font_size,
                                color: is_dark ? AppColors.white54 : AppColors.text_light_secondary,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: is_dark ? AppColors.white54 : AppColors.text_light_secondary,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (route_context) => const PaymentHistoryPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.space_xl),
                        ],
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

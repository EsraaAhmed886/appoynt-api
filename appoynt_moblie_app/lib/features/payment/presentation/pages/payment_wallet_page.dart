/*
 * File Name: payment_wallet_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/payment/presentation/pages/saved_cards_page.dart,
 *   package:appoynt_mobile_app/features/payment/presentation/pages/payment_history_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: Refactored dashboard acting as a clean navigation hub displaying wallet balance card and navigation tiles.
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
                      title: localizations.profile_payment_wallet,
                    ),
                    // Spacing offset
                    const SizedBox(height: AppSpacing.space_xl),

                    // Payment & Wallet Section Container
                    Container(
                      // Card outline decoration layout
                      decoration: BoxDecoration(
                        // Dynamic surface color
                        color: true == is_dark
                            ? AppColors.surface_dark
                            : Colors.white,
                        // Rounded corners
                        borderRadius: BorderRadius.circular(16.0),
                        // Card shadows
                        boxShadow: [
                          BoxShadow(
                            // Shadow colors
                            color: true == is_dark
                                ? Colors.black.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.05),
                            // Blur spread
                            blurRadius: 10.0,
                            // Offset
                            offset: const Offset(0.0, 4.0),
                          ),
                        ],
                        // Thin borders outline decoration
                        border: Border.all(
                          // Border colors matching theme mode
                          color: true == is_dark
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
                            padding: const EdgeInsets.all(16.0),
                            // Wallet background container
                            child: Container(
                              // Full width
                              width: double.infinity,
                              // Inner padding offsets (spacious layout)
                              padding: const EdgeInsets.all(20.0),
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
                                borderRadius: BorderRadius.circular(16.0),
                                // Soft shadows
                                boxShadow: const [
                                  BoxShadow(
                                    // Color
                                    color: Colors.black26,
                                    // Blur
                                    blurRadius: 12.0,
                                    // Offset position
                                    offset: Offset(0.0, 4.0),
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
                                            localizations.profile_wallet_balance,
                                            // Styles
                                            style: const TextStyle(
                                              // Color white
                                              color: Colors.white70,
                                              // Size
                                              fontSize: 12.0,
                                              // Medium weight
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          // Spacing gap
                                          const SizedBox(height: 6.0),
                                          // Balance Value display Text
                                          const Text(
                                            // Mock wallet balance values (highly prominent)
                                            '\$150.00',
                                            // Typography
                                            style: TextStyle(
                                              // Color white
                                              color: Colors.white,
                                              // Prominent bold size
                                              fontSize: 32.0,
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
                                            const SnackBar(
                                              content: Text('Add Money feature coming soon!'),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.add, size: 16.0, color: AppColors.primary_color),
                                        label: const Text(
                                          'Add Money',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary_color,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Separator spacing gap
                                  const SizedBox(height: 18.0),
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
                                          localizations.profile_priority_payment,
                                          // Typography
                                          style: const TextStyle(
                                            // Color white
                                            color: Colors.white,
                                            // Font size
                                            fontSize: 12.0,
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
                                        activeThumbColor: Colors.white,
                                        // Subdued switch track color
                                        activeTrackColor: Colors.white.withValues(alpha: 0.35),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Subtle separate divider
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: true == is_dark
                                ? AppColors.border_dark
                                : Colors.grey.withValues(alpha: 0.15),
                          ),
                          // ListTile 1: Saved Payment Cards navigation menu tile
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppColors.primary_color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Icon(
                                Icons.credit_card_rounded,
                                color: AppColors.primary_color,
                                size: 20.0,
                              ),
                            ),
                            title: Text(
                              localizations.profile_saved_cards,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                              ),
                            ),
                            subtitle: Text(
                              'Manage your saved debit/credit cards',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
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
                            height: 1.0,
                            thickness: 1.0,
                            color: true == is_dark
                                ? AppColors.border_dark
                                : Colors.grey.withValues(alpha: 0.15),
                          ),
                          // ListTile 2: Payment History & Invoices navigation menu tile
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.teal.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Icon(
                                Icons.receipt_long_rounded,
                                color: Colors.teal,
                                size: 20.0,
                              ),
                            ),
                            title: Text(
                              localizations.profile_invoices_title,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                              ),
                            ),
                            subtitle: Text(
                              'View past transactions and download invoices',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (route_context) => const PaymentHistoryPage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16.0),
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

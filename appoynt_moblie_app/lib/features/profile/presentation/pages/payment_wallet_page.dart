/*
 * File Name: payment_wallet_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Redesigned screen displaying wallet balance, priority payment switches, saved payment cards, and invoices.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing flutter bloc for state handling
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing profile cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing profile state definition
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/pages/manage_saved_cards_page.dart';


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
      // Apply background color dynamically based on dark modes
      backgroundColor: true == is_dark
          ? AppColors.background_dark
          : const Color(0xFFF1F5F9),
      // Body wrap in safe area and scroll view
      body: SafeArea(
        // Scroll view protecting layout bounds
        child: SingleChildScrollView(
          // Outer padding margins (strictly 16px boundaries)
          child: Padding(
            // Margins boundaries
            padding: const EdgeInsets.symmetric(
              // Horizontal offset
              horizontal: AppSpacing.space_xl,
              // Vertical offset
              vertical: AppSpacing.space_m,
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
                                  // Header labels
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
                          // Saved Cards Slider & Manage card label
                          Padding(
                            // Margins
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            // Row listing saved card layout structures
                            child: Row(
                              // Distribute items
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // children list
                              children: [
                                // Cards list header label Text
                                Text(
                                  // Localized saved cards label
                                  localizations.profile_saved_cards,
                                  // Typography
                                  style: TextStyle(
                                    // Body size
                                    fontSize: 13.0,
                                    // Bold weight
                                    fontWeight: FontWeight.bold,
                                    // Colors adaptions
                                    color: true == is_dark
                                        ? Colors.white70
                                        : AppColors.text_light_primary,
                                  ),
                                ),
                                // Manage button gesture detector link
                                GestureDetector(
                                  // Push navigate to Manage Saved Cards screen
                                  onTap: () {
                                    // Push navigate
                                    Navigator.of(context).push(
                                      // Route builder
                                      MaterialPageRoute(
                                        // Builder constructor
                                        builder: (route_context) => BlocProvider.value(
                                          // Carry cubit block context forward
                                          value: context.read<ProfileCubit>(),
                                          // Manage saved cards page
                                          child: const ManageSavedCardsPage(),
                                        ),
                                      ),
                                    );
                                  },
                                  // Action chip decorator container
                                  child: Container(
                                    // Padding bounds
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4.0,
                                    ),
                                    // Decoration
                                    decoration: BoxDecoration(
                                      // Light transparent primary color
                                      color: AppColors.primary_color.withValues(alpha: 0.1),
                                      // Rounded corners
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    // Action label Text
                                    child: const Text(
                                      // Label text
                                      'Manage',
                                      // Styles
                                      style: TextStyle(
                                        // Small size
                                        fontSize: 10.0,
                                        // Bold weight
                                        fontWeight: FontWeight.bold,
                                        // Accent primary colors
                                        color: AppColors.primary_color,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Horizontal scroll view listing saved cards
                          Container(
                            // Fixed slider height
                            height: 96.0,
                            // Margins spacer
                            margin: const EdgeInsets.symmetric(vertical: 12.0),
                            // Scroll list wrapper
                            child: SingleChildScrollView(
                              // Set scrolling direction to horizontal
                              scrollDirection: Axis.horizontal,
                              // Inner padding bounds
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              // Align cards in a row
                              child: Row(
                                // children list
                                children: [
                                  // Card 1 (Visa Primary default)
                                  Container(
                                    // Fixed width
                                    width: 190.0,
                                    // Inner padding (breathable layout)
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0,
                                      vertical: 14.0,
                                    ),
                                    // Decorator outline styling
                                    decoration: BoxDecoration(
                                      // Light gray surface or dark themed container background
                                      color: true == is_dark
                                          ? Colors.white10
                                          : AppColors.surface_light,
                                      // Rounded corners (strict 16px symmetry)
                                      borderRadius: BorderRadius.circular(16.0),
                                      // Blue primary color border indicating default cards status
                                      border: Border.all(
                                        color: AppColors.primary_color,
                                        width: 1.5,
                                      ),
                                    ),
                                    // Horizontal row placing logo silhouette and card text info
                                    child: Row(
                                      // children list
                                      children: [
                                        // High-fidelity custom VISA logo design
                                        Text(
                                          // Visa brand name
                                          'VISA',
                                          // Typography styling
                                          style: TextStyle(
                                            // Monospace
                                            fontFamily: 'monospace',
                                            // Heavy weight
                                            fontWeight: FontWeight.w900,
                                            // Italic angle
                                            fontStyle: FontStyle.italic,
                                            // Size
                                            fontSize: 15.0,
                                            // Custom brand blue color or white
                                            color: true == is_dark
                                                ? Colors.white
                                                : const Color(0xFF1A1F71),
                                          ),
                                        ),
                                        // Horizontal spacer
                                        const SizedBox(width: 12.0),
                                        // Masked details column text
                                        Expanded(
                                          // Column
                                          child: Column(
                                            // Align left coordinates
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // Center alignments
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            // details children list
                                            children: [
                                              // Masked number Text
                                              const Text(
                                                // digits
                                                'Visa **** 4321',
                                                // Style
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // Default badge capsule pill container
                                              Container(
                                                // Margins
                                                margin: const EdgeInsets.only(top: 2.0),
                                                // Inner padding
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                  vertical: 1.5,
                                                ),
                                                // Badge style
                                                decoration: BoxDecoration(
                                                  // Pastel primary background shade
                                                  color: AppColors.primary_color
                                                      .withValues(alpha: 0.1),
                                                  // Rounded corners radius
                                                  borderRadius: BorderRadius.circular(4.0),
                                                ),
                                                // Localized Default label Text
                                                child: Text(
                                                  // Localized default string
                                                  localizations.profile_default_card,
                                                  // Style
                                                  style: const TextStyle(
                                                    // Small text size
                                                    fontSize: 8.0,
                                                    // Primary color
                                                    color: AppColors.primary_color,
                                                    // Bold
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Spacing gap spacer
                                  const SizedBox(width: 12.0),
                                  // Card 2 (Mastercard Secondary)
                                  Container(
                                    // Fixed width
                                    width: 190.0,
                                    // Inner padding (breathable layout)
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0,
                                      vertical: 14.0,
                                    ),
                                    // Decorator outline layout
                                    decoration: BoxDecoration(
                                      // Inner container background
                                      color: true == is_dark
                                          ? AppColors.inner_container_dark
                                          : AppColors.inner_container_light,
                                      // Rounded corners (strict 16px symmetry)
                                      borderRadius: BorderRadius.circular(16.0),
                                      // Soft border
                                      border: Border.all(
                                        color: true == is_dark
                                            ? AppColors.inner_container_border_dark
                                            : AppColors.inner_container_border_light,
                                        width: 1.0,
                                      ),
                                    ),
                                    // Horizontal row placing icon and name details
                                    child: Row(
                                      // children list
                                      children: [
                                        // Mastercard overlapping circles logo representation
                                        SizedBox(
                                          // Fixed space width
                                          width: 32.0,
                                          // Stack container
                                          child: Stack(
                                            // Align center
                                            alignment: Alignment.centerLeft,
                                            // Circles children list
                                            children: [
                                              // Red circle
                                              Container(
                                                // Width
                                                width: 14.0,
                                                // Height
                                                height: 14.0,
                                                // Shape
                                                decoration: const BoxDecoration(
                                                  // Brand red color
                                                  color: Color(0xFFEB001B),
                                                  // Circle
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              // Orange circle offset
                                              Positioned(
                                                // Shift alignment left boundary
                                                left: 8.0,
                                                // Orange circle
                                                child: Container(
                                                  // Width
                                                  width: 14.0,
                                                  // Height
                                                  height: 14.0,
                                                  // Shape
                                                  decoration: BoxDecoration(
                                                    // Brand orange colors
                                                    color: const Color(0xFFF79E1B)
                                                        .withValues(alpha: 0.85),
                                                    // Circle
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Horizontal spacer
                                        const SizedBox(width: 8.0),
                                        // Details column
                                        const Expanded(
                                          // Column
                                          child: Column(
                                            // Align left coordinates
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // Center alignments
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            // children list
                                            children: [
                                              // Masked number Text
                                              Text(
                                                // digits
                                                'Mastercard **** 8877',
                                                // Style
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Subtle separate divider (1px height, light gray tint)
                          Divider(
                            height: 24.0,
                            thickness: 1.0,
                            color: true == is_dark
                                ? AppColors.border_dark
                                : Colors.grey.withValues(alpha: 0.15),
                          ),

                          // Payment History Title
                          Padding(
                            // Margins boundaries offsets
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                            // Text widget
                            child: Text(
                              // Localized invoices history title key
                              localizations.profile_invoices_title,
                              // Typographic settings
                              style: TextStyle(
                                // Font size standard
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
                          // Invoices transaction rows list
                          Padding(
                            // Inner margin padding around invoices stack column
                            padding: const EdgeInsets.all(16.0),
                            // Column listing transactions
                            child: Column(
                              // children list
                              children: [
                                // Invoice Row 1: Consultation transaction (Andrew Fletcher)
                                Padding(
                                  // Margins offset
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  // Horizontal row representing details
                                  child: Row(
                                    // children list
                                    children: [
                                      // Stethoscope / clinic icon badge container
                                      Container(
                                        // Margins inner padding
                                        padding: const EdgeInsets.all(8.0),
                                        // Badge shape styling
                                        decoration: BoxDecoration(
                                          // Teal background tint
                                          color: Colors.teal.withValues(alpha: 0.1),
                                          // Rounded corners
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        // Clinic building / medical service icon
                                        child: const Icon(
                                          // Medical services icon graphic
                                          Icons.medical_services_rounded,
                                          // Teal color
                                          color: Colors.teal,
                                          // Size
                                          size: 18.0,
                                        ),
                                      ),
                                      // Horizontal spacer
                                      const SizedBox(width: 12.0),
                                      // Details text column
                                      Expanded(
                                        // Column stack
                                        child: Column(
                                          // Align left coordinates
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          // children
                                          children: [
                                            // Doctor name details Text
                                            Text(
                                              // Doctor key name details
                                              'Dr. Andrew Fletcher',
                                              // Style properties
                                              style: TextStyle(
                                                // Size body medium
                                                fontSize: 12.0,
                                                // Bold weight
                                                fontWeight: FontWeight.bold,
                                                // Dynamic colors adaptions
                                                color: true == is_dark
                                                    ? Colors.white
                                                    : AppColors.text_light_primary,
                                              ),
                                            ),
                                            // Expiration/payment dates details label
                                            const Text(
                                              // Date details representation
                                              '15 July 2026 • Consultation',
                                              // Style subdued properties
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: AppColors.text_light_secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Value balance indicator Text
                                      Text(
                                        // Charge value representation
                                        r'$85.00',
                                        // Typographic settings
                                        style: TextStyle(
                                          // Font size standard
                                          fontSize: 12.0,
                                          // Bold weight
                                          fontWeight: FontWeight.bold,
                                          // Colors adaptions
                                          color: true == is_dark
                                              ? Colors.white
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                      // Horizontal gap spacer (optimized touch target)
                                      const SizedBox(width: 16.0),
                                      // PDF invoice download button icon (with large touch target bounding-box)
                                      SizedBox(
                                        // Target Width
                                        width: 44.0,
                                        // Target Height
                                        height: 44.0,
                                        // Icon button
                                        child: IconButton(
                                          // Small padding for spacious touch targeting
                                          padding: const EdgeInsets.all(10.0),
                                          // Download outline icon graphic
                                          icon: const Icon(
                                            Icons.download_for_offline_outlined,
                                            color: AppColors.primary_color,
                                            size: 20.0,
                                          ),
                                          // Trigger download feedback on click
                                          onPressed: () {
                                            // Show feedback SnackBar toast message info
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              // SnackBar configs
                                              const SnackBar(
                                                content: Text('Downloading Invoice PDF...'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Soft light divider between transactions
                                Divider(
                                  // Height gap
                                  height: 16.0,
                                  // Thickness thin
                                  thickness: 0.5,
                                  // Grey colors tint
                                  color: Colors.grey.withValues(alpha: 0.15),
                                ),
                                // Invoice Row 2: Lab Test Report (Clara Oswald)
                                Padding(
                                  // Margins offset
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  // Horizontal row representing details
                                  child: Row(
                                    // children list
                                    children: [
                                      // Science / test tube badge container
                                      Container(
                                        // Margins inner padding
                                        padding: const EdgeInsets.all(8.0),
                                        // Badge shape styling
                                        decoration: BoxDecoration(
                                          // Purple background tint
                                          color: Colors.purple.withValues(alpha: 0.1),
                                          // Rounded corners
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        // Test tube icon
                                        child: const Icon(
                                          // Science icon graphic
                                          Icons.science_rounded,
                                          // Purple color
                                          color: Colors.purple,
                                          // Size
                                          size: 18.0,
                                        ),
                                      ),
                                      // Horizontal spacer
                                      const SizedBox(width: 12.0),
                                      // Details text column
                                      Expanded(
                                        // Column stack
                                        child: Column(
                                          // Align left coordinates
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          // children
                                          children: [
                                            // Doctor name details Text
                                            Text(
                                              // Doctor key name details
                                              'Dr. Clara Oswald',
                                              // Style properties
                                              style: TextStyle(
                                                // Size body medium
                                                fontSize: 12.0,
                                                // Bold weight
                                                fontWeight: FontWeight.bold,
                                                // Dynamic colors adaptions
                                                color: true == is_dark
                                                    ? Colors.white
                                                    : AppColors.text_light_primary,
                                              ),
                                            ),
                                            // Expiration/payment dates details label
                                            const Text(
                                              // Date details representation
                                              '02 July 2026 • Lab Test Report',
                                              // Style subdued properties
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                color: AppColors.text_light_secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Value balance indicator Text
                                      Text(
                                        // Charge value representation
                                        r'$45.00',
                                        // Typographic settings
                                        style: TextStyle(
                                          // Font size standard
                                          fontSize: 12.0,
                                          // Bold weight
                                          fontWeight: FontWeight.bold,
                                          // Colors adaptions
                                          color: true == is_dark
                                              ? Colors.white
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                      // Horizontal gap spacer (optimized touch target)
                                      const SizedBox(width: 16.0),
                                      // PDF invoice download button icon (with large touch target bounding-box)
                                      SizedBox(
                                        // Target Width
                                        width: 44.0,
                                        // Target Height
                                        height: 44.0,
                                        // Icon button
                                        child: IconButton(
                                          // Small padding for spacious touch targeting
                                          padding: const EdgeInsets.all(10.0),
                                          // Download outline icon graphic
                                          icon: const Icon(
                                            Icons.download_for_offline_outlined,
                                            color: AppColors.primary_color,
                                            size: 20.0,
                                          ),
                                          // Trigger download feedback on click
                                          onPressed: () {
                                            // Show feedback SnackBar toast message info
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              // SnackBar configs
                                              const SnackBar(
                                                content: Text('Downloading Invoice PDF...'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

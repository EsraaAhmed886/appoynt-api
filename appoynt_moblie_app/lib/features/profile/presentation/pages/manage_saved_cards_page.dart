/*
 * File Name: manage_saved_cards_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Redesigned page to manage saved payment cards with realistic physical card previews and default status togglers.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing add card sub-page form layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_saved_card_page.dart';

// Stateful widget displaying card management screen details
class ManageSavedCardsPage extends StatefulWidget {
  // Constructor mapping key
  const ManageSavedCardsPage({super.key});

  @override
  // Create state tracker instance
  State<ManageSavedCardsPage> createState() {
    // Return state class instance
    return _ManageSavedCardsPageState();
  }
}

// State class managing saved cards list and simulation dialogs
class _ManageSavedCardsPageState extends State<ManageSavedCardsPage> {
  // Mock list of cards representing visual states
  final List<Map<String, String>> _saved_cards = [
    {
      'id': '1',
      'brand': 'Visa',
      'number': '4000 1234 5678 4321',
      'expiry': '12/2029',
      'holder': 'Kareem Mangood',
      'is_default': 'true',
    },
    {
      'id': '2',
      'brand': 'Mastercard',
      'number': '5105 4321 8765 8877',
      'expiry': '08/2028',
      'holder': 'Kareem Mangood',
      'is_default': 'false',
    },
  ];

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // Apply background color dynamically based on dark modes
      backgroundColor: true == is_dark
          ? AppColors.background_dark
          : AppColors.surface_light.withValues(alpha: 0.5),
      // Body content stack
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space_m),
              const CustomProfileAppBar(
                title: 'Manage Saved Cards',
              ),
              const SizedBox(height: AppSpacing.space_xl),
              Expanded(
                child: Stack(
          // Stack children list
          children: [
            // List view scrollable container
            Padding(
              // Margins around page
              padding: const EdgeInsets.symmetric(
                // Horizontal limits spacing (strictly 16px)
                horizontal: AppSpacing.space_xl,
                // Top spacing offset
                vertical: AppSpacing.space_l,
              ),
              // Scroll list builder
              child: ListView.builder(
                // Length of cards
                itemCount: _saved_cards.length,
                // Builder callback
                itemBuilder: (list_context, index) {
                  // Reference index card map details
                  final card = _saved_cards[index];
                  // Resolve brand name
                  final String brand = card['brand'] ?? 'Visa';
                  // Resolve default status
                  final bool is_default = 'true' == card['is_default'];

                  // Realistic Credit Card preview layout
                  return GestureDetector(
                    // Toggle default payment method on tap
                    onTap: () {
                      // Update state
                      setState(() {
                        // Set selection
                        _saved_cards[index]['is_default'] = 'true';
                        // Set others to false
                        for (int i = 0; i < _saved_cards.length; i++) {
                          if (i != index) {
                            _saved_cards[i]['is_default'] = 'false';
                          }
                        }
                      });
                    },
                    // AspectRatio widget enforcing 16:9 credit card dimensions
                    child: AspectRatio(
                      // AspectRatio value matching 16:9 proportions
                      aspectRatio: 16 / 9,
                      // Card container wrapper
                      child: Container(
                        // Spacing gap below card (strictly 16px layout guard)
                        margin: const EdgeInsets.only(bottom: 16.0),
                        // Card design padding offsets
                        padding: const EdgeInsets.all(AppSpacing.space_xl),
                        // Physical credit card styles
                        decoration: BoxDecoration(
                          // Corners radius (16px corner radius)
                          borderRadius: BorderRadius.circular(16.0),
                          // Premium dual-tone matte linear gradient backgrounds
                          gradient: true == ('Visa' == brand)
                              ? const LinearGradient(
                                  // Begin Alignment
                                  begin: Alignment.topLeft,
                                  // End Alignment
                                  end: Alignment.bottomRight,
                                  // Colors Navy to Teal
                                  colors: [
                                    Color(0xFF0F3A5F), // Ocean Navy
                                    Color(0xFF0D253A), // Deep Ocean Teal
                                  ],
                                )
                              : const LinearGradient(
                                  // Begin Alignment
                                  begin: Alignment.topLeft,
                                  // End Alignment
                                  end: Alignment.bottomRight,
                                  // Charcoal/Dark Gray matte
                                  colors: [
                                    Color(0xFF333333), // Slate Charcoal
                                    Color(0xFF1E1E1E), // Dark Black-charcoal
                                  ],
                                ),
                          // Glowing border wrapper highlight indicating default active status
                          border: Border.all(
                            // Glowing teal color if default, transparent if normal
                            color: true == is_default ? Colors.teal : Colors.transparent,
                            // Border line thickness
                            width: 2.0,
                          ),
                          // Hard credit card shadows
                          boxShadow: [
                            BoxShadow(
                              // Shadow colors adapting to dark mode
                              color: true == is_dark
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.1),
                              // Blur spread
                              blurRadius: 12.0,
                              // Position offsets
                              offset: const Offset(0.0, 4.0),
                            ),
                          ],
                        ),
                        // Stacking card widgets
                        child: Column(
                          // Align start
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // MainAxisAlignment
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // children details
                          children: [
                            // Upper row placing EMV chip on left, Radio indicator & Brand on right
                            Row(
                              // Distribute items
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // children list
                              children: [
                                // Golden EMV Chip container
                                Container(
                                  // Width dimensions
                                  width: 40.0,
                                  // Height dimensions
                                  height: 30.0,
                                  // Decoration
                                  decoration: BoxDecoration(
                                    // Yellow-gold color metallic look
                                    color: const Color(0xFFFFD700).withValues(alpha: 0.8),
                                    // Rounded corners radius
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                // Row grouping Radio Indicator and Brand Logo
                                Row(
                                  // children
                                  children: [
                                    // Active default indicator badge
                                    true == is_default
                                        ? Container(
                                            // Margins
                                            margin: const EdgeInsets.only(right: 8.0),
                                            // Padding offsets
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            // Badge styling
                                            decoration: BoxDecoration(
                                              // Teal active background color
                                              color: Colors.teal.withValues(alpha: 0.2),
                                              // Rounded corners
                                              borderRadius: BorderRadius.circular(8.0),
                                              // Teal border outline
                                              border: Border.all(color: Colors.teal, width: 1.0),
                                            ),
                                            // Default string text
                                            child: const Text(
                                              // Default label string
                                              'DEFAULT',
                                              // Typography
                                              style: TextStyle(
                                                // Micro size
                                                fontSize: 8.0,
                                                // White contrast text
                                                color: Colors.white,
                                                // Bold
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    // Interactive radio check indicator badge inside the card
                                    Icon(
                                      // Check circle icon if default, radio unchecked icon if normal
                                      true == is_default
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_off_rounded,
                                      // Color contrast
                                      color: true == is_default ? Colors.teal : Colors.white60,
                                      // Size standard
                                      size: 20.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Middle row: spaced credit card masked numbers (Monospace font)
                            Text(
                              // Card digits string
                              card['number'] ?? '',
                              // Typography
                              style: const TextStyle(
                                // Monospace
                                fontFamily: 'monospace',
                                // Large prominent size
                                fontSize: 18.0,
                                // White contrast
                                color: Colors.white,
                                // Bold
                                fontWeight: FontWeight.w600,
                                // Spaced characters
                                letterSpacing: 2.0,
                              ),
                            ),
                            // Bottom row placing card holder and expiration date
                            Row(
                              // Distribute items
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // Align elements bottom
                              crossAxisAlignment: CrossAxisAlignment.end,
                              // children details
                              children: [
                                // Holder name column
                                Column(
                                  // Start align
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // children details
                                  children: [
                                    // Label CARDHOLDER
                                    const Text(
                                      // Micro label
                                      'CARDHOLDER',
                                      // Typography
                                      style: TextStyle(
                                        // Micro size
                                        fontSize: 8.0,
                                        // Muted white colors
                                        color: Colors.white60,
                                      ),
                                    ),
                                    // Spacer gap height
                                    const SizedBox(height: 2.0),
                                    // Holder value
                                    Text(
                                      // Holder text
                                      card['holder'] ?? '',
                                      // Style
                                      style: const TextStyle(
                                        // Small font size
                                        fontSize: 12.0,
                                        // Bold
                                        fontWeight: FontWeight.bold,
                                        // Colors white
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                // Expiration column
                                Column(
                                  // Start align
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // children details
                                  children: [
                                    // Label VALID THRU
                                    const Text(
                                      // Micro label
                                      'VALID THRU',
                                      // Typography
                                      style: TextStyle(
                                        // Micro size
                                        fontSize: 8.0,
                                        // Muted white colors
                                        color: Colors.white60,
                                      ),
                                    ),
                                    // Spacer gap height
                                    const SizedBox(height: 2.0),
                                    // Expiry value
                                    Text(
                                      // Expiry date text
                                      card['expiry'] ?? '',
                                      // Style
                                      style: const TextStyle(
                                        // Small font size
                                        fontSize: 12.0,
                                        // Bold
                                        fontWeight: FontWeight.bold,
                                        // Colors white
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                // Trash bin remove card icon button placed discreetly inside card footer
                                SizedBox(
                                  // Bounding box size
                                  width: 36.0,
                                  // Height size
                                  height: 36.0,
                                  // Icon button wrapper
                                  child: IconButton(
                                    // Icon padding zero
                                    padding: EdgeInsets.zero,
                                    // Icon vector
                                    icon: const Icon(
                                      // Delete Outline rounded symbol representation
                                      Icons.delete_outline_rounded,
                                      // Sleek low-opacity white color
                                      color: Colors.white70,
                                      // Size
                                      size: 20.0,
                                    ),
                                    // Trigger deletion warning dialog popup onTap
                                    onPressed: () {
                                      // Show confirmation warning popup
                                      _confirm_card_deletion(context, card['number'] ?? '', index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Positioned primary solid CTA button placed at the absolute bottom
            Align(
              // Bottom center alignment anchor
              alignment: Alignment.bottomCenter,
              // Spacing wrapper padding
              child: Padding(
                // Spacing boundaries limits (strictly 16px safe margin)
                padding: const EdgeInsets.all(AppSpacing.space_xl),
                // Custom AuthButton structure conforming to theme design language
                child: SizedBox(
                  // Full width CTA layout
                  width: double.infinity,
                  // Set standard button height parameters
                  height: 50.0,
                  // Solid elevated button
                  child: ElevatedButton(
                    // Action callback simulator overlay onTap
                    onPressed: () {
                      // Navigate to AddSavedCardPage sub-page
                      Navigator.of(context).push(
                        // Slide transition route builder
                        MaterialPageRoute(
                          // Target screen layout page class
                          builder: (route_context) => const AddSavedCardPage(),
                        ),
                      );
                    },
                    // Style attributes conforming to primary blue theme colors
                    style: ElevatedButton.styleFrom(
                      // Blue primary color fill
                      backgroundColor: AppColors.primary_color,
                      // Curve contours radius bounds
                      shape: RoundedRectangleBorder(
                        // Curve contours radius bounds
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      // Shadows
                      elevation: 4.0,
                    ),
                    // Centered button title label Text
                    child: const Text(
                      // CTA Button text label
                      'Add New Card',
                      // Typographic settings
                      style: TextStyle(
                        // Color white high contrast
                        color: Colors.white,
                        // Medium size
                        fontSize: 14.0,
                        // Bold weights
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Deletion confirmation warning alert modal dialogue frame
  void _confirm_card_deletion(BuildContext context, String card_number, int index) {
    // Show standard modal alert dialogue popup
    showDialog(
      // context
      context: context,
      // builder
      builder: (dialog_context) {
        // Return alert frame
        return AlertDialog(
          // Title header Text
          title: const Text(
            // Warning header string
            'Remove Card',
            // Bold style specs
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Description content string widget
          content: Text(
            // Question asking consent
            'Are you sure you want to remove card "$card_number"? This action cannot be undone.',
          ),
          // Action button list elements
          actions: [
            // Option A: Cancel option button
            TextButton(
              // Action handler onTap close alert popup
              onPressed: () {
                // POP navigation context
                Navigator.of(dialog_context).pop();
              },
              // Label text widget
              child: const Text('Cancel'),
            ),
            // Option B: Remove confirmation button
            TextButton(
              // Action handler onTap perform deletion operations
              onPressed: () {
                // POP alert popup frame
                Navigator.of(dialog_context).pop();
                // Perform state variable list update
                setState(() {
                  // Delete index card item target
                  _saved_cards.removeAt(index);
                });
                // Show success status indicator message toast feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  // Toast configs
                  const SnackBar(
                    content: Text('Card removed successfully.'),
                  ),
                );
              },
              // Red text label style option
              child: const Text(
                // Title label
                'Remove',
                // Red color
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

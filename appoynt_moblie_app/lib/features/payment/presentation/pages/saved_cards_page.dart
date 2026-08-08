/*
 * File Name: saved_cards_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: Ultra-modern, premium FinTech style Saved Cards management page with standard bottom primary action button.
 */

// Importing BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing ProfileCubit
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing add card sub-page form layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_saved_card_page.dart';

// Stateful widget displaying saved cards list screen details
class SavedCardsPage extends StatefulWidget {
  // Constant constructor initializing widget key
  const SavedCardsPage({super.key});

  @override
  // Create state tracker instance
  State<SavedCardsPage> createState() {
    // Return state class instance
    return _SavedCardsPageState();
  }
}

// State class managing saved cards list and simulation dialogs
class _SavedCardsPageState extends State<SavedCardsPage> {
  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve saved cards list from cubit reactively
    final List<Map<String, dynamic>> saved_cards =
        context.watch<ProfileCubit>().state.profile.payment_cards;

    // Return root Scaffold layout container
    return Scaffold(
      // Body content stack wrapper in SafeArea
      body: SafeArea(
        child: Padding(
          // Outer padding bounds
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          // Column stack layout
          child: Column(
            // Align start horizontal
            crossAxisAlignment: CrossAxisAlignment.start,
            // children list
            children: [
              // Top padding separator
              const SizedBox(height: AppSpacing.space_xl),
              // Custom profile back-navigation appBar header with card count badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: CustomProfileAppBar(
                      title: 'Saved Cards',
                    ),
                  ),
                  // Count indicator badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary_color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${saved_cards.length} Cards',
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary_color,
                      ),
                    ),
                  ),
                ],
              ),
              // Spacing gap separator
              const SizedBox(height: AppSpacing.space_xl),
              // Scrollable card list view area
              Expanded(
                child: true == saved_cards.isEmpty
                    ? _build_empty_state(context, is_dark)
                    : ListView.builder(
                        // Length of cards
                        itemCount: saved_cards.length,
                        // Builder callback
                        itemBuilder: (list_context, index) {
                          // Reference index card map details
                          final card = saved_cards[index];
                          // Detect card brand dynamically based on number prefix
                          final String raw_num =
                              (card['number'] ?? '').replaceAll(' ', '');
                          final String detected_brand =
                              true == raw_num.startsWith('4')
                                  ? 'Visa'
                                  : (true == raw_num.startsWith('5')
                                      ? 'Mastercard'
                                      : (card['brand'] ?? 'Visa'));
                          // Resolve default status
                          final bool is_default = 'true' == card['is_default'];

                          // AspectRatio widget enforcing standard credit card dimensions (1.586 : 1)
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: AspectRatio(
                              // AspectRatio value matching standard credit card proportions
                              aspectRatio: 1.586 / 1,
                              // Card container wrapper
                              child: Container(
                                // Card design padding offsets
                                padding:
                                    const EdgeInsets.all(AppSpacing.space_xl),
                                // Physical credit card styles
                                decoration: BoxDecoration(
                                  // Corners radius
                                  borderRadius: BorderRadius.circular(20.0),
                                  // Premium dual-tone matte linear gradient backgrounds
                                  gradient: true == is_default
                                      ? const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF0F172A), // Slate Dark
                                            Color(0xFF581C87), // Deep Purple
                                          ],
                                        )
                                      : const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF1E293B), // Slate Grey
                                            Color(0xFF334155), // Light Slate
                                          ],
                                        ),
                                  // Glowing border wrapper highlight indicating default active status
                                  border: Border.all(
                                    // Glowing subtle color if default, transparent if normal
                                    color: true == is_default
                                        ? const Color(0xFF10B981)
                                        : Colors.white10,
                                    // Border line thickness
                                    width: true == is_default ? 2.0 : 1.0,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // children details
                                  children: [
                                    // Upper row placing EMV chip on left, Radio indicator & Brand on right
                                    Row(
                                      // Distribute items
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // children list
                                      children: [
                                        // EMV Chip graphic simulation container
                                        Container(
                                          width: 44.0,
                                          height: 32.0,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFCD34D), // Light Gold
                                                Color(0xFFD97706), // Dark Gold
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 2.0,
                                                offset: Offset(0.0, 1.0),
                                              ),
                                            ],
                                          ),
                                          // Add subtle metallic lines on the chip
                                          child: CustomPaint(
                                            painter: _EmvChipPainter(),
                                          ),
                                        ),
                                        // Row grouping Radio Indicator and Brand Logo
                                        Row(
                                          children: [
                                            // Active default indicator badge
                                            true == is_default
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xFF10B981)
                                                          .withValues(
                                                              alpha: 0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xFF10B981),
                                                          width: 1.0),
                                                    ),
                                                    child: const Text(
                                                      '✓ DEFAULT',
                                                      style: TextStyle(
                                                        fontSize: 8.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                            // Crisp authentic brand logo text
                                            if (true ==
                                                ('Visa' == detected_brand))
                                              const Text(
                                                'VISA',
                                                style: TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 18.0,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              )
                                            else
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 22.0,
                                                    height: 14.0,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      children: [
                                                        Container(
                                                          width: 12.0,
                                                          height: 12.0,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xFFEB001B),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          left: 8.0,
                                                          child: Container(
                                                            width: 12.0,
                                                            height: 12.0,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xFFF79E1B),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  const Text(
                                                    'mc',
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Middle row: spaced credit card masked numbers (Monospace font) with 4-digit grouping
                                    Text(
                                      // Card digits string
                                      (() {
                                        final String cleaned =
                                            (card['number'] ?? '')
                                                .replaceAll(' ', '');
                                        final StringBuffer sb = StringBuffer();
                                        for (int i = 0;
                                            i < cleaned.length;
                                            i++) {
                                          if (i > 0 && i % 4 == 0) {
                                            sb.write(' ');
                                          } else {
                                            // Empty block
                                          }
                                          sb.write(cleaned[i]);
                                        }
                                        return sb.toString();
                                      })(),
                                      // Typography
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    // Bottom row placing card holder, expiration date, and popup context menu
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Holder name column
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'CARDHOLDER',
                                              style: TextStyle(
                                                fontSize: 8.0,
                                                color: Colors.white60,
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),
                                            Text(
                                              card['holder'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Expiration column
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'VALID THRU',
                                              style: TextStyle(
                                                fontSize: 8.0,
                                                color: Colors.white60,
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),
                                            Text(
                                              card['expiry'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Popup Context Menu button for actions
                                        PopupMenuButton<String>(
                                          icon: const Icon(
                                            Icons.more_vert_rounded,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                          color: true == is_dark
                                              ? AppColors.surface_dark
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          onSelected: (String action) {
                                            if ('default' == action) {
                                              context
                                                  .read<ProfileCubit>()
                                                  .set_default_card(
                                                      card['id'] ?? '');
                                            } else if ('delete' == action) {
                                              _confirm_card_deletion(
                                                  context,
                                                  card['number'] ?? '',
                                                  card['id'] ?? '');
                                            } else {
                                              // Unsupported action
                                            }
                                          },
                                          itemBuilder: (menu_context) {
                                            return [
                                              if (false == is_default)
                                                const PopupMenuItem<String>(
                                                  value: 'default',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .check_circle_outline_rounded,
                                                          size: 18.0),
                                                      SizedBox(width: 8.0),
                                                      Text('Set as Default',
                                                          style: TextStyle(
                                                              fontSize: 12.0)),
                                                    ],
                                                  ),
                                                ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color: AppColors.error,
                                                        size: 18.0),
                                                    SizedBox(width: 8.0),
                                                    Text('Delete Card',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: AppColors
                                                                .error)),
                                                  ],
                                                ),
                                              ),
                                            ];
                                          },
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
            ],
          ),
        ),
      ),
      // Standard bottom primary action button
      bottomNavigationBar: true == saved_cards.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () => _navigate_to_add_card(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary_color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      '+ Add New Card',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // Navigate to add card screen helper
  void _navigate_to_add_card(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (route_context) => const AddSavedCardPage(),
      ),
    );
  }

  // Build clean empty state screen when no cards are active
  Widget _build_empty_state(BuildContext context, bool is_dark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space_xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.primary_color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.credit_card_off_rounded,
                size: 64.0,
                color: AppColors.primary_color,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'No Saved Cards Yet',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: true == is_dark
                    ? Colors.white
                    : AppColors.text_light_primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Add a debit/credit card for faster, secure booking checkouts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: true == is_dark
                    ? Colors.white54
                    : AppColors.text_light_secondary,
              ),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton.icon(
                onPressed: () => _navigate_to_add_card(context),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text(
                  'Add New Card',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Deletion confirmation warning alert modal dialogue frame
  void _confirm_card_deletion(
      BuildContext context, String card_number, String card_id) {
    showDialog(
      context: context,
      builder: (dialog_context) {
        return AlertDialog(
          title: const Text(
            'Remove Card',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to remove card "$card_number"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop();
                context.read<ProfileCubit>().remove_payment_card(card_id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Card removed successfully.'),
                  ),
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter to draw EMV gold chip inner metallic tracks
class _EmvChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFB45309).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw grid tracks
    canvas.drawLine(Offset(size.width * 0.33, 0.0),
        Offset(size.width * 0.33, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.66, 0.0),
        Offset(size.width * 0.66, size.height), paint);
    canvas.drawLine(Offset(0.0, size.height * 0.5),
        Offset(size.width, size.height * 0.5), paint);

    // Draw center core
    final Rect centerRect = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.5,
    );
    canvas.drawRRect(
        RRect.fromRectAndRadius(centerRect, const Radius.circular(2.0)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

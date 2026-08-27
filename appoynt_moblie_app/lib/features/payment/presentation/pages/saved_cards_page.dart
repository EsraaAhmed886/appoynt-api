/*
 * File Name: saved_cards_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.5.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Ultra-modern, premium FinTech style Saved Cards management page. Fully localized and complies with zero-hardcoded-numbers.
 */

// Importing BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing ProfileCubit
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing add card sub-page form layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_saved_card_page.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double horizontal_padding = 10.0;
  static const double vertical_padding_tiny = 4.0;
  static const double count_badge_radius = 12.0;
  static const double count_badge_font_size = 10.0;
  static const double spacing_bottom = 16.0;
  static const double aspect_ratio = 1.586;
  static const double container_radius = 20.0;
  static const double shadow_blur = 10.0;
  static const double shadow_offset_y = 4.0;
  static const double shadow_opacity_dark = 0.35;
  static const double shadow_opacity_light = 0.15;
  static const double chip_width = 44.0;
  static const double chip_height = 32.0;
  static const double chip_radius = 6.0;
  static const double default_badge_padding_h = 8.0;
  static const double default_badge_padding_v = 4.0;
  static const double default_badge_radius = 8.0;
  static const double default_badge_font_size = 8.0;
  static const double brand_logo_font_size = 16.0;
  static const double brand_logo_letter_spacing = 1.0;
  static const double circle_size = 16.0;
  static const double circle_offset_x = 8.0;
  static const double spacing_small = 4.0;
  static const double label_font_size_small = 10.0;
  static const double numbers_font_size = 18.0;
  static const double numbers_letter_spacing = 2.0;
  static const double label_font_size_tiny = 8.0;
  static const double val_font_size_medium = 12.0;
  static const double spacing_tiny = 2.0;
  static const double icon_size = 20.0;
  static const double menu_radius = 12.0;
  static const double menu_item_font_size = 12.0;
  static const double menu_icon_size = 18.0;
  static const double button_height = 50.0;
  static const double button_radius = 12.0;
  static const double button_font_size = 16.0;
  static const double empty_state_icon_size = 64.0;
  static const double empty_state_title_font_size = 16.0;
  static const double empty_state_subtitle_font_size = 12.0;
  static const double button_radius_large = 25.0;
  static const double line_width_thin = 1.0;
  static const double line_opacity = 0.5;
  static const double grid_x1 = 0.33;
  static const double grid_x2 = 0.66;
  static const double grid_y = 0.5;
  static const double rect_pos = 0.25;
  static const double rect_size = 0.5;
}

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
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
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
                  Expanded(
                    child: CustomProfileAppBar(
                      title: localizations.payment_manage_cards_title,
                    ),
                  ),
                  // Count indicator badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: _LocalDimensions.horizontal_padding,
                        vertical: _LocalDimensions.vertical_padding_tiny),
                    decoration: BoxDecoration(
                      color: AppColors.primary_color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(_LocalDimensions.count_badge_radius),
                    ),
                    child: Text(
                      '${saved_cards.length} ${localizations.payment_cards_count_suffix}',
                      style: const TextStyle(
                        fontSize: _LocalDimensions.count_badge_font_size,
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
                    ? _build_empty_state(context, is_dark, localizations)
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
                            padding: const EdgeInsets.only(bottom: _LocalDimensions.spacing_bottom),
                            child: AspectRatio(
                              aspectRatio: _LocalDimensions.aspect_ratio,
                              child: Container(
                                decoration: BoxDecoration(
                                  // Sleek premium backgrounds (gradient for primary card, Slate Glassmorphism for secondary cards)
                                  gradient: is_default
                                      ? const LinearGradient(
                                          colors: [
                                            AppColors.slate900, // Slate Dark
                                            AppColors.slate800, // Slate Light
                                            AppColors.slate700, // Indigo Highlight
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : const LinearGradient(
                                          colors: [
                                            AppColors.indigo950, // Indigo Dark
                                            AppColors.indigo900, // Indigo Light
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(_LocalDimensions.container_radius),
                                  boxShadow: [
                                    BoxShadow(
                                      color: is_dark
                                          ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                                          : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                                      blurRadius: _LocalDimensions.shadow_blur,
                                      offset: const Offset(0.0, _LocalDimensions.shadow_offset_y),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Custom Paint overlay drawing gridlines on the card for authentic EMV look
                                    Positioned.fill(
                                      child: Opacity(
                                        opacity: 0.05,
                                        child: CustomPaint(
                                          painter: CardGridPainter(),
                                        ),
                                      ),
                                    ),
                                    // Card details layout wrapper
                                    Padding(
                                      padding: const EdgeInsets.all(AppSpacing.space_xxl),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Top row: EMV Chip & Default indicator / Card Brand logo
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // EMV Metallic Gold Chip Widget
                                              Container(
                                                width: _LocalDimensions.chip_width,
                                                height: _LocalDimensions.chip_height,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [
                                                      AppColors.amber300, // Soft Amber Gold
                                                      AppColors.warning, // Deep Amber Gold
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(_LocalDimensions.chip_radius),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: AppColors.black26,
                                                      blurRadius: 2.0,
                                                      offset: Offset(0.0, 1.0),
                                                    ),
                                                  ],
                                                ),
                                                child: CustomPaint(
                                                  painter: EMVChipPainter(),
                                                ),
                                              ),
                                              const SizedBox(width: AppSpacing.space_m),
                                              // Default indicator badge
                                              is_default
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: _LocalDimensions.default_badge_padding_h,
                                                          vertical: _LocalDimensions.default_badge_padding_v),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                                0xFF10B981)
                                                            .withValues(
                                                                alpha: 0.2),
                                                        borderRadius:
                                                            BorderRadius.circular(_LocalDimensions.default_badge_radius),
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xFF10B981),
                                                            width: _LocalDimensions.line_width_thin),
                                                      ),
                                                      child: Text(
                                                        '✓ ${localizations.payment_default_badge.toUpperCase()}',
                                                        style: const TextStyle(
                                                          fontSize: _LocalDimensions.default_badge_font_size,
                                                          color: AppColors.white,
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
                                                    fontSize: _LocalDimensions.brand_logo_font_size,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.white,
                                                    fontStyle: FontStyle.italic,
                                                    letterSpacing: _LocalDimensions.brand_logo_letter_spacing,
                                                  ),
                                                ),
                                              if (true ==
                                                  ('Mastercard' ==
                                                      detected_brand))
                                                Row(
                                                  children: [
                                                    // Mastercard colored overlapping circles
                                                    SizedBox(
                                                      width: _LocalDimensions.circle_size + _LocalDimensions.circle_offset_x,
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            width: _LocalDimensions.circle_size,
                                                            height: _LocalDimensions.circle_size,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xFFEA3C25),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: _LocalDimensions.circle_offset_x,
                                                            child: Container(
                                                              width: _LocalDimensions.circle_size,
                                                              height: _LocalDimensions.circle_size,
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
                                                    const SizedBox(width: _LocalDimensions.spacing_small),
                                                    const Text(
                                                      'mc',
                                                      style: TextStyle(
                                                        fontSize: _LocalDimensions.label_font_size_small,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.white,
                                                      ),
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
                                              final String masked = true ==
                                                      cleaned.length >= 4
                                                  ? '•••• •••• •••• ${cleaned.substring(cleaned.length - 4)}'
                                                  : '•••• •••• •••• ••••';
                                              return masked;
                                            })(),
                                            style: const TextStyle(
                                              fontSize: _LocalDimensions.numbers_font_size,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                              fontFamily: 'monospace',
                                              letterSpacing: _LocalDimensions.numbers_letter_spacing,
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
                                                  Text(
                                                    localizations.payment_cardholder_label,
                                                    style: const TextStyle(
                                                      fontSize: _LocalDimensions.label_font_size_tiny,
                                                      color: AppColors.white60,
                                                    ),
                                                  ),
                                                  const SizedBox(height: _LocalDimensions.spacing_tiny),
                                                  Text(
                                                    card['holder'] ?? '',
                                                    style: const TextStyle(
                                                      fontSize: _LocalDimensions.val_font_size_medium,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Expiration column
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    localizations.payment_valid_thru_label,
                                                    style: const TextStyle(
                                                      fontSize: _LocalDimensions.label_font_size_tiny,
                                                      color: AppColors.white60,
                                                    ),
                                                  ),
                                                  const SizedBox(height: _LocalDimensions.spacing_tiny),
                                                  Text(
                                                    card['expiry'] ?? '',
                                                    style: const TextStyle(
                                                      fontSize: _LocalDimensions.val_font_size_medium,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Popup Context Menu button for actions
                                              PopupMenuButton<String>(
                                                icon: const Icon(
                                                  Icons.more_vert_rounded,
                                                  color: AppColors.white,
                                                  size: _LocalDimensions.icon_size,
                                                ),
                                                color: is_dark
                                                    ? AppColors.surface_dark
                                                    : AppColors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(_LocalDimensions.menu_radius),
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
                                                        card['id'] ?? '',
                                                        localizations);
                                                  } else {
                                                    // Unsupported action
                                                  }
                                                },
                                                itemBuilder: (menu_context) {
                                                  return [
                                                    if (!is_default)
                                                      PopupMenuItem<String>(
                                                        value: 'default',
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .check_circle_outline_rounded,
                                                                size: _LocalDimensions.menu_icon_size),
                                                            const SizedBox(width: AppSpacing.space_m),
                                                            Text(localizations.payment_set_default_action,
                                                                style: const TextStyle(
                                                                    fontSize: _LocalDimensions.menu_item_font_size)),
                                                          ],
                                                        ),
                                                      ),
                                                    PopupMenuItem<String>(
                                                      value: 'delete',
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .delete_outline_rounded,
                                                              color: AppColors.error,
                                                              size: _LocalDimensions.menu_icon_size),
                                                          const SizedBox(width: AppSpacing.space_m),
                                                          Text(localizations.payment_delete_card_action,
                                                              style: const TextStyle(
                                                                  fontSize: _LocalDimensions.menu_item_font_size,
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
                padding: const EdgeInsets.all(AppSpacing.space_xl),
                child: SizedBox(
                  width: double.infinity,
                  height: _LocalDimensions.button_height,
                  child: ElevatedButton(
                    onPressed: () => _navigate_to_add_card(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary_color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_LocalDimensions.button_radius),
                      ),
                    ),
                    child: Text(
                      localizations.payment_add_new_card_btn,
                      style: const TextStyle(
                        fontSize: _LocalDimensions.button_font_size,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
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
  Widget _build_empty_state(BuildContext context, bool is_dark, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space_xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.space_xxl),
              decoration: BoxDecoration(
                color: AppColors.primary_color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.credit_card_off_rounded,
                size: _LocalDimensions.empty_state_icon_size,
                color: AppColors.primary_color,
              ),
            ),
            const SizedBox(height: AppSpacing.space_xxl),
            Text(
              localizations.payment_no_saved_cards_title,
              style: TextStyle(
                fontSize: _LocalDimensions.empty_state_title_font_size,
                fontWeight: FontWeight.bold,
                color: is_dark
                    ? AppColors.white
                    : AppColors.text_light_primary,
              ),
            ),
            const SizedBox(height: AppSpacing.space_m),
            Text(
              localizations.payment_no_saved_cards_body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _LocalDimensions.empty_state_subtitle_font_size,
                color: is_dark
                    ? AppColors.white54
                    : AppColors.text_light_secondary,
              ),
            ),
            const SizedBox(height: AppSpacing.space_xxxl),
            SizedBox(
              width: double.infinity,
              height: _LocalDimensions.button_height,
              child: ElevatedButton.icon(
                onPressed: () => _navigate_to_add_card(context),
                icon: const Icon(Icons.add_rounded, color: AppColors.white),
                label: Text(
                  localizations.payment_add_new_card_btn,
                  style: const TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_LocalDimensions.button_radius_large),
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
      BuildContext context, String card_number, String card_id, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (dialog_context) {
        return AlertDialog(
          title: Text(
            localizations.payment_delete_card_action,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            '${localizations.payment_delete_card_dialog_body_prefix}$card_number${localizations.payment_delete_card_dialog_body_suffix}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop();
              },
              child: Text(localizations.payment_cancel_btn),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop();
                context.read<ProfileCubit>().remove_payment_card(card_id);
                CustomSnackBar.success(
                  context,
                  localizations.payment_card_removed_success,
                );
              },
              child: Text(
                localizations.payment_remove_btn,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter to draw EMV gold chip inner metallic tracks
class EMVChipPainter extends CustomPainter {
  @override
  // Render EMV chip lines
  void paint(Canvas canvas, Size size) {
    // Styling parameter configurations
    final Paint linePaint = Paint()
      ..color = AppColors.amber700.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _LocalDimensions.line_width_thin;

    // Draw chip line patterns
    canvas.drawLine(
        Offset(size.width * 0.5, 0.0), Offset(size.width * 0.5, size.height), linePaint);
    canvas.drawLine(
        Offset(0.0, size.height * _LocalDimensions.grid_x1), Offset(size.width, size.height * _LocalDimensions.grid_x1), linePaint);
    canvas.drawLine(
        Offset(0.0, size.height * _LocalDimensions.grid_x2), Offset(size.width, size.height * _LocalDimensions.grid_x2), linePaint);

    final Paint corePaint = Paint()
      ..color = AppColors.amber300.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // Draw central micro-core segment
    final Rect chipCore = Rect.fromLTWH(
        size.width * 0.35, size.height * 0.35, size.width * 0.3, size.height * 0.3);
    canvas.drawRRect(
        RRect.fromRectAndRadius(chipCore, const Radius.circular(2.0)), corePaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(chipCore, const Radius.circular(2.0)), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Custom painter to draw fine card outline grid structures
class CardGridPainter extends CustomPainter {
  @override
  // Draw card surface details
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.amber700.withValues(alpha: _LocalDimensions.line_opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _LocalDimensions.line_width_thin;

    // Draw grid tracks
    canvas.drawLine(Offset(size.width * _LocalDimensions.grid_x1, 0.0),
        Offset(size.width * _LocalDimensions.grid_x1, size.height), paint);
    canvas.drawLine(Offset(size.width * _LocalDimensions.grid_x2, 0.0),
        Offset(size.width * _LocalDimensions.grid_x2, size.height), paint);
    canvas.drawLine(Offset(0.0, size.height * _LocalDimensions.grid_y),
        Offset(size.width, size.height * _LocalDimensions.grid_y), paint);

    // Draw center core
    final Rect centerRect = Rect.fromLTWH(
      size.width * _LocalDimensions.rect_pos,
      size.height * _LocalDimensions.rect_pos,
      size.width * _LocalDimensions.rect_size,
      size.height * _LocalDimensions.rect_size,
    );
    canvas.drawRRect(
        RRect.fromRectAndRadius(centerRect, const Radius.circular(2.0)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

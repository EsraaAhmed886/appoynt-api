/*
 * File Name: doctor_slot_grid.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart,
 *   doctor_slot_entity.dart, slot_card_item.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Responsive 3-column GridView rendering doctor time slot cards
 *   with tuned cross-axis aspect ratios preventing any RenderFlex layout overflows.
 */

// Import Flutter material framework
import 'package:flutter/material.dart';
// Import design tokens and widget components
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/features/booking/domain/entities/doctor_slot_entity.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/slot_card_item.dart';

/// 3-column grid of doctor appointment slots.
class DoctorSlotGrid extends StatelessWidget {
  // Slots to display
  final List<DoctorSlotEntity> slots;
  // Currently selected slot
  final DoctorSlotEntity? selected_slot;
  // Whether a hold is currently being acquired
  final bool is_holding_slot;
  // Slot selection callback
  final ValueChanged<DoctorSlotEntity> on_slot_selected;

  // Constant constructor
  const DoctorSlotGrid({
    super.key,
    required this.slots,
    required this.selected_slot,
    required this.is_holding_slot,
    required this.on_slot_selected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.85,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final DoctorSlotEntity slot = slots[index];
        final bool is_selected = selected_slot?.slot_id == slot.slot_id;
        final bool is_loading = is_selected && is_holding_slot;

        return SlotCardItem(
          slot: slot,
          is_selected: is_selected,
          is_loading: is_loading,
          on_tap: () => on_slot_selected(slot),
        );
      },
    );
  }
}

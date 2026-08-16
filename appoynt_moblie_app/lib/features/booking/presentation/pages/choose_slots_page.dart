/*
 * File Name: choose_slots_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 17/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   service_locator.dart, app_colors.dart, app_spacing.dart, custom_profile_app_bar.dart,
 *   slot_booking_cubit.dart, slot_booking_state.dart, clinic_context_selector_card.dart,
 *   change_clinic_bottom_sheet.dart, horizontal_calendar_date_strip.dart,
 *   time_of_day_filter_chips.dart, doctor_slot_grid.dart, active_hold_countdown_banner.dart,
 *   empty_slots_widget.dart, sticky_slot_booking_bottom_bar.dart,
 *   hold_release_confirmation_dialog.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/08/2026]
 * File Description: Comprehensive Doctor Multi-Clinic & Time Slot Booking screen featuring
 *   generous 68px toolbar with AppBackButton, doctor verification badge, equal-width segmented
 *   filters, docked hold indicator, and animated hold expiration dialogs.
 */

// Import Flutter and BLoC frameworks
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import service locator and design tokens
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/widgets/custom_profile_app_bar.dart';
// Import Cubit and State
import 'package:appoynt_mobile_app/features/booking/presentation/cubit/slot_booking_cubit.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/cubit/slot_booking_state.dart';
// Import UI Components
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/clinic_context_selector_card.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/change_clinic_bottom_sheet.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/horizontal_calendar_date_strip.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/time_of_day_filter_chips.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/doctor_slot_grid.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/active_hold_countdown_banner.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/empty_slots_widget.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/sticky_slot_booking_bottom_bar.dart';
import 'package:appoynt_mobile_app/features/booking/presentation/widgets/hold_release_confirmation_dialog.dart';

/// Arguments bundle required for navigating to ChooseSlotsPage.
class ChooseSlotsArgs {
  final String doctor_id;
  final String doctor_name;
  final String specialty;
  final double consultation_fee;
  final String currency;
  final String? profile_photo_url;

  const ChooseSlotsArgs({
    required this.doctor_id,
    required this.doctor_name,
    required this.specialty,
    required this.consultation_fee,
    this.currency = 'EGP',
    this.profile_photo_url,
  });
}

/// Main entry screen for choosing an appointment slot.
class ChooseSlotsPage extends StatelessWidget {
  final ChooseSlotsArgs args;

  const ChooseSlotsPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get_it<SlotBookingCubit>()..init(doctor_id: args.doctor_id),
      child: _ChooseSlotsView(args: args),
    );
  }
}

class _ChooseSlotsView extends StatelessWidget {
  final ChooseSlotsArgs args;

  const _ChooseSlotsView({
    required this.args,
  });

  void _show_expired_hold_modal(BuildContext context, SlotBookingCubit cubit) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: AppColors.transparent,
      builder: (modal_context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.space_xxl),
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radius_xxl),
              topRight: Radius.circular(AppSpacing.radius_xxl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFD97706).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.alarm_off_rounded,
                  color: Color(0xFFD97706),
                  size: 32.0,
                ),
              ),
              const SizedBox(height: AppSpacing.space_l),
              Text(
                'Reservation Expired',
                style: TextStyle(
                  fontSize: AppSpacing.font_size_title_medium,
                  fontWeight: FontWeight.w800,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_s),
              Text(
                "Your temporary slot hold has expired. We've refreshed the schedule for you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_small,
                  height: 1.4,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_xl),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(modal_context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: const Text(
                    'Select New Slot',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final SlotBookingCubit cubit = context.read<SlotBookingCubit>();

    return BlocConsumer<SlotBookingCubit, SlotBookingState>(
      listener: (context, state) {
        if (state is SlotBookingLoaded && state.feedback_message != null) {
          if (state.feedback_message!.contains('expired')) {
            _show_expired_hold_modal(context, cubit);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.feedback_message!),
                backgroundColor: AppColors.amber,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final bool has_active_hold =
            state is SlotBookingLoaded && state.has_active_hold;

        return PopScope(
          canPop: !has_active_hold,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final bool should_leave =
                await HoldReleaseConfirmationDialog.show(context);
            if (should_leave && context.mounted) {
              await cubit.releaseActiveHold();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: Scaffold(
            backgroundColor:
                is_dark ? AppColors.background_dark : AppColors.scaffold_light,
            appBar: AppBar(
              backgroundColor: is_dark
                  ? AppColors.surface_dark
                  : AppColors.background_light,
              elevation: 0.5,
              toolbarHeight: 68.0,
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Center(
                  child: AppBackButton(
                    onTap: () async {
                      if (has_active_hold) {
                        final bool should_leave =
                            await HoldReleaseConfirmationDialog.show(context);
                        if (should_leave && context.mounted) {
                          await cubit.releaseActiveHold();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                  ),
                ),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Appointment Slot',
                    style: TextStyle(
                      fontSize: AppSpacing.font_size_title_medium,
                      fontWeight: FontWeight.w800,
                      color: is_dark
                          ? AppColors.text_dark_primary
                          : AppColors.text_light_primary,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 14.0,
                        color: AppColors.primary_color,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        args.doctor_name,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary_color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: SafeArea(
              top: false,
              bottom: false,
              child: _build_body(context, state, cubit, is_dark),
            ),
          ),
        );
      },
    );
  }

  Widget _build_body(
    BuildContext context,
    SlotBookingState state,
    SlotBookingCubit cubit,
    bool is_dark,
  ) {
    if (state is SlotBookingLoading || state is SlotBookingInitial) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary_color,
          strokeWidth: 3.0,
        ),
      );
    }

    if (state is SlotBookingError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space_xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48.0,
                color: AppColors.red.withValues(alpha: 0.8),
              ),
              const SizedBox(height: AppSpacing.space_l),
              Text(
                'Failed to load clinic slots',
                style: TextStyle(
                  fontSize: AppSpacing.font_size_title_medium,
                  fontWeight: FontWeight.w700,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_xl),
              ElevatedButton.icon(
                onPressed: () => cubit.init(doctor_id: args.doctor_id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_color,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18.0),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is SlotBookingLoaded) {
      return Stack(
        children: [
          // Scrollable Content Surface
          RefreshIndicator(
            color: AppColors.primary_color,
            onRefresh: () async {
              await cubit.selectDate(state.selected_date);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.space_m),

                  // 1. Clinic Branch Context Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                    ),
                    child: ClinicContextSelectorCard(
                      clinic: state.selected_clinic,
                      on_change_clinic: () {
                        ChangeClinicBottomSheet.show(
                          context: context,
                          clinics: state.clinics,
                          selected_clinic: state.selected_clinic,
                          on_clinic_selected: (new_clinic) {
                            cubit.selectClinic(new_clinic);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space_l),

                  // 2. Calendar Timeline Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                    ),
                    child: Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: AppSpacing.font_size_body_medium + 1.0,
                        fontWeight: FontWeight.w800,
                        color: is_dark
                            ? AppColors.text_dark_primary
                            : AppColors.text_light_primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space_m),
                  HorizontalCalendarDateStrip(
                    selected_date: state.selected_date,
                    clinic: state.selected_clinic,
                    on_date_selected: (date) => cubit.selectDate(date),
                  ),

                  // Enhanced 20px rhythm spacing between Date Strip and Slots Title
                  const SizedBox(height: 20.0),

                  // 3. Time Slots Header & Filter Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Time Slots',
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_medium + 1.0,
                            fontWeight: FontWeight.w800,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                        if (state.is_refreshing_slots)
                          const SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              color: AppColors.primary_color,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space_m + 2.0),
                  TimeOfDayFilterChips(
                    active_filter: state.active_filter,
                    on_filter_changed: (filter) => cubit.setFilter(filter),
                  ),

                  // Enhanced 16px rhythm spacing between Filter Bar and Slots Grid
                  const SizedBox(height: 16.0),

                  // 4. Responsive Slots Grid or Empty State
                  if (state.filtered_slots.isNotEmpty)
                    DoctorSlotGrid(
                      slots: state.filtered_slots,
                      selected_slot: state.selected_slot,
                      is_holding_slot: state.is_holding_slot,
                      on_slot_selected: (slot) => cubit.selectSlot(slot),
                    )
                  else
                    EmptySlotsWidget(
                      on_next_date_tap: () {
                        cubit.selectDate(
                          state.selected_date.add(const Duration(days: 1)),
                        );
                      },
                    ),

                  // Bottom padding spacer to clear sticky confirmation bar and banner
                  const SizedBox(height: 170.0),
                ],
              ),
            ),
          ),

          // Docked Bottom Section: Urgency Countdown Banner + Sticky Booking Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.has_active_hold)
                  ActiveHoldCountdownBanner(
                    remaining_seconds: state.remaining_seconds,
                    is_visible: state.has_active_hold,
                  ),
                StickySlotBookingBottomBar(
                  clinic: state.selected_clinic,
                  selected_date: state.selected_date,
                  selected_slot: state.selected_slot,
                  has_active_hold: state.has_active_hold,
                  on_continue_pressed: () {
                    _on_continue_to_confirmation(context, state);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _on_continue_to_confirmation(
    BuildContext context,
    SlotBookingLoaded state,
  ) {
    // Show success confirmation bottom modal / navigation feedback
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (modal_context) {
        final bool is_dark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.space_xxl),
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radius_xxl),
              topRight: Radius.circular(AppSpacing.radius_xxl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: AppColors.dummy_custom_green.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.dummy_custom_green,
                  size: 36.0,
                ),
              ),
              const SizedBox(height: AppSpacing.space_l),
              Text(
                'Slot Reserved Successfully!',
                style: TextStyle(
                  fontSize: AppSpacing.font_size_title_medium,
                  fontWeight: FontWeight.w800,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_m),
              Text(
                "Your appointment with ${args.doctor_name} at ${state.selected_clinic.name} on ${state.selected_slot?.start_time} is locked.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_small,
                  height: 1.4,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_xl),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(modal_context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

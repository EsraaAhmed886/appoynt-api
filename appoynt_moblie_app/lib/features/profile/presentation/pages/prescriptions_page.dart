/*
 * File Name: prescriptions_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V3.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/pages/add_prescription_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
 * File Description: Defines the Prescription List screen featuring rich
 * floating clinical cards, an empty-state hero view, and a delete confirmation
 * dialog. The add-medication flow navigates to the standalone AddPrescriptionPage.
 */

// Importing BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations and design system barrel via route export
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller for dispatching profile actions
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing ProfileState for BlocBuilder type binding
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';
// Importing standalone add-prescription page for navigation
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_prescription_page.dart';

// Prescriptions Page layout stateful widget representation
class PrescriptionsPage extends StatefulWidget {
  // Default constructor
  const PrescriptionsPage({super.key});

  // State builder factory
  @override
  State<PrescriptionsPage> createState() {
    // Return the concrete state instance
    return _PrescriptionsPageState();
  }
}

// Concrete state tracker implementation for PrescriptionsPage
class _PrescriptionsPageState extends State<PrescriptionsPage> {
  // Navigate to the standalone AddPrescriptionPage via full page route
  void _navigate_to_add(BuildContext page_context) {
    // Push the full-screen add prescription form
    Navigator.of(page_context).push(
      // Standard material page route with slide transition
      MaterialPageRoute<void>(
        // Pass the inherited ProfileCubit via BlocProvider.value
        builder: (route_context) => BlocProvider.value(
          // Propagate the existing cubit instance to the new route
          value: page_context.read<ProfileCubit>(),
          // Target standalone add prescription form screen
          child: const AddPrescriptionPage(),
        ),
      ),
    );
  }

  // Show a delete confirmation dialog before removing a prescription entry
  void _show_delete_confirm(
    BuildContext page_context,
    String prescription_id,
    AppLocalizations localizations,
  ) {
    // Display native alert dialog
    showDialog<void>(
      context: page_context,
      builder: (dialog_context) {
        return AlertDialog(
          // Rounded corner shape
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          // Dialog title text
          title: Text(
            localizations.prescriptions_delete_confirm_title,
          ),
          // Dialog body text
          content: Text(
            localizations.prescriptions_delete_confirm_body,
          ),
          // Action buttons
          actions: [
            // Cancel button — dismiss without action
            TextButton(
              onPressed: () => Navigator.of(dialog_context).pop(),
              child: Text(
                localizations.prescriptions_delete_confirm_no,
              ),
            ),
            // Confirm remove button — dispatches cubit deletion
            TextButton(
              onPressed: () {
                // Dispatch remove action to cubit using the id key
                page_context
                    .read<ProfileCubit>()
                    .remove_prescription(prescription_id);
                // Close confirmation dialog
                Navigator.of(dialog_context).pop();
              },
              child: Text(
                localizations.prescriptions_delete_confirm_yes,
                style: const TextStyle(
                  // Error red color for destructive action
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─── Widget Build ──────────────────────────────────────────────────────────

  // Draw primary widget view structure
  @override
  Widget build(BuildContext context) {
    // Resolve localized strings from context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness flag
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Canvas background color adapts to theme mode
      backgroundColor:
          true == is_dark ? AppColors.background_dark : const Color(0xFFF8FAFC),
      // ── Sticky bottom "+ Add New Medication" action bar ─────────────────
      bottomNavigationBar: SafeArea(
        // Apply 16px padding on all sides for safe inset clearance
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            // Left 16px margin
            AppSpacing.space_xl,
            // Top 8px spacing above button
            8.0,
            // Right 16px margin
            AppSpacing.space_xl,
            // Bottom 16px safe margin above system navigation bar
            AppSpacing.space_xl,
          ),
          child: SizedBox(
            // Full width fill
            width: double.infinity,
            // Standard button height token
            height: AppSpacing.height_auth_button,
            child: ElevatedButton.icon(
              // Navigate to standalone add-prescription screen on tap
              onPressed: () => _navigate_to_add(context),
              // Leading "+" icon
              icon: const Icon(
                // Add circle icon
                Icons.add_circle_outline_rounded,
                // White icon
                color: Colors.white,
                // Icon display size
                size: 20.0,
              ),
              // Button label text
              label: Text(
                // Localized CTA label
                localizations.prescriptions_add_btn,
                style: const TextStyle(
                  // White text
                  color: Colors.white,
                  // Action button font size token
                  fontSize: AppSpacing.font_size_action_button,
                  // Bold weight for CTA
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Style configuration
              style: ElevatedButton.styleFrom(
                // Primary brand blue fill
                backgroundColor: AppColors.primary_color,
                // No elevation shadow
                elevation: 0.0,
                // 16px rounded corners
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
        ),
      ),
      // Scaffold body safe area wrapper
      body: SafeArea(
        child: Padding(
          // Symmetric horizontal padding
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          child: Column(
            // Align children to left axis
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top spacer before app bar
              const SizedBox(height: AppSpacing.space_m),

              // ── Standard back navigation header ─────────────────────
              CustomProfileAppBar(
                // Localized page title
                title: localizations.prescriptions_title,
              ),
              const SizedBox(height: AppSpacing.space_m),

              // ── Reactive Prescriptions List ──────────────────────────
              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  // Rebuild on every relevant state change
                  builder: (bloc_context, state) {
                    // Resolve prescriptions list from cubit state
                    final List<Map<String, dynamic>> prescriptions =
                        state.profile.prescriptions;

                    // ── Empty State View ─────────────────────────────
                    if (prescriptions.isEmpty) {
                      return _build_empty_state(
                        context,
                        localizations,
                        is_dark,
                      );
                    } else {
                      // ── Rich Cards List View ─────────────────────
                      return ListView.builder(
                        // Zero edge padding at list boundaries
                        padding: EdgeInsets.zero,
                        // Bind card count to prescriptions length
                        itemCount: prescriptions.length,
                        // Build each prescription card
                        itemBuilder: (list_context, index) {
                          // Resolve current prescription map entry
                          final Map<String, dynamic> rx =
                              prescriptions[index];
                          // Return the rich prescription card widget
                          return _build_prescription_card(
                            context,
                            rx,
                            localizations,
                            is_dark,
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

  // ─── Sub-Widgets ───────────────────────────────────────────────────────────

  // Build a centered empty state hero view when the list is empty
  Widget _build_empty_state(
    BuildContext context,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    return Center(
      child: Padding(
        // Symmetric padding for empty state content
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
        child: Column(
          // Center content vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Soft blue circular pill illustration ─────────────────
            Container(
              // Circle container size
              width: 100.0,
              height: 100.0,
              // Circular decoration with primary tint
              decoration: BoxDecoration(
                // Pale blue tint background
                color: AppColors.primary_color.withValues(alpha: 0.08),
                // Perfect circle
                shape: BoxShape.circle,
              ),
              child: const Icon(
                // Medication pill icon
                Icons.medication_rounded,
                // Primary blue icon color
                color: AppColors.primary_color,
                // Large icon size
                size: 48.0,
              ),
            ),
            const SizedBox(height: 24.0),

            // ── Empty State Title ─────────────────────────────────────
            Text(
              // Localized empty title string
              localizations.prescriptions_empty_title,
              // Center aligned text
              textAlign: TextAlign.center,
              style: TextStyle(
                // Large section title size
                fontSize: 20.0,
                // Heavy bold weight
                fontWeight: FontWeight.w800,
                // Adaptive primary text color
                color: true == is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.text_light_primary,
              ),
            ),
            const SizedBox(height: 12.0),

            // ── Empty State Subtitle ──────────────────────────────────
            Text(
              // Localized empty subtitle description
              localizations.prescriptions_empty_subtitle,
              // Center aligned text
              textAlign: TextAlign.center,
              style: const TextStyle(
                // Smaller body text size
                fontSize: 14.0,
                // Normal weight for supporting text
                fontWeight: FontWeight.normal,
                // Muted secondary color
                color: AppColors.text_light_secondary,
                // Relaxed line height for readability
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32.0),

            // ── Primary Empty CTA Button ──────────────────────────────
            SizedBox(
              // Full width fill
              width: double.infinity,
              // Button height token
              height: AppSpacing.height_auth_button,
              child: ElevatedButton.icon(
                // Navigate to add-medication standalone screen
                onPressed: () => _navigate_to_add(context),
                // Leading add icon
                icon: const Icon(
                  // Add rounded icon
                  Icons.add_rounded,
                  // White icon
                  color: Colors.white,
                ),
                // Button label text
                label: Text(
                  // Localized empty CTA string
                  localizations.prescriptions_empty_cta,
                  style: const TextStyle(
                    // White text
                    color: Colors.white,
                    // Action font size
                    fontSize: AppSpacing.font_size_action_button,
                    // Bold weight
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Style configuration
                style: ElevatedButton.styleFrom(
                  // Primary blue fill
                  backgroundColor: AppColors.primary_color,
                  // No elevation
                  elevation: 0.0,
                  // Rounded corners
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a rich floating prescription card with header, metadata, and actions
  Widget _build_prescription_card(
    BuildContext context,
    Map<String, dynamic> rx,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // Resolve medication name safely with fallback
    final String name = (rx['name'] as String? ?? 'Unknown Medication');
    // Resolve dosage string
    final String dosage = (rx['dosage'] as String? ?? '1 Tablet');
    // Resolve frequency string
    final String frequency = (rx['frequency'] as String? ?? '—');
    // Resolve duration string
    final String duration = (rx['duration'] as String? ?? '—');
    // Resolve status badge text with localized fallback
    final String status =
        (rx['status'] as String? ?? localizations.prescriptions_status_active);
    // Resolve doctor name
    final String doctor = (rx['doctor'] as String? ?? '—');
    // Resolve date added
    final String date = (rx['date'] as String? ?? '—');
    // Resolve unique prescription id for deletion
    final String id = (rx['id'] as String? ?? name);

    // Determine status badge color (Active = green, else grey)
    final Color status_color =
        ('Active' == status || 'فعّال' == status)
            ? const Color(0xFF10B981)
            : const Color(0xFF94A3B8);

    // Return the fully decorated floating card container
    return Container(
      // Vertical bottom margin between cards
      margin: const EdgeInsets.only(bottom: 14.0),
      // Card decoration with shadow
      decoration: BoxDecoration(
        // White surface background
        color: true == is_dark ? AppColors.surface_dark : Colors.white,
        // 16px rounded corners
        borderRadius: BorderRadius.circular(16.0),
        // Thin border outline
        border: Border.all(
          // Adaptive border color
          color: true == is_dark
              ? AppColors.border_dark
              : const Color(0xFFE2E8F0),
          // Border width
          width: AppSpacing.border_width_thin,
        ),
        // Ambient shadow for floating card effect
        boxShadow: [
          BoxShadow(
            // Soft shadow tint
            color: true == is_dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            // Blur radius
            blurRadius: 12.0,
            // Vertical shadow offset
            offset: const Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Padding(
        // Internal card padding
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Cross axis stretches full width
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Row: Icon, Title, Status Badge ───────────────
            Row(
              // Align children to center vertical axis
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Soft blue circular pill icon tint
                Container(
                  // Circle container dimensions
                  width: 44.0,
                  height: 44.0,
                  // Circular decoration
                  decoration: BoxDecoration(
                    // Pale blue tint background
                    color: AppColors.primary_color.withValues(alpha: 0.1),
                    // Perfect circle
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    // Medication pill icon
                    Icons.medication_rounded,
                    // Primary blue icon
                    color: AppColors.primary_color,
                    // Icon size
                    size: 22.0,
                  ),
                ),
                const SizedBox(width: 12.0),

                // Medication name label takes expanded space
                Expanded(
                  child: Text(
                    // Medication name string
                    name,
                    style: TextStyle(
                      // Medium-large body size
                      fontSize: 15.0,
                      // Bold weight
                      fontWeight: FontWeight.bold,
                      // Adaptive primary text color
                      color: true == is_dark
                          ? AppColors.text_dark_primary
                          : AppColors.text_light_primary,
                    ),
                    // Truncate overflow with ellipsis
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),

                // ── Status Badge Pill ──────────────────────────────
                Container(
                  // Horizontal padding inside badge
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  // Rounded pill badge
                  decoration: BoxDecoration(
                    // Light tint of status color as background
                    color: status_color.withValues(alpha: 0.12),
                    // Pill border radius
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    // Status label string
                    status,
                    style: TextStyle(
                      // Small badge text
                      fontSize: 11.0,
                      // Bold weight
                      fontWeight: FontWeight.bold,
                      // Status badge text color
                      color: status_color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // ── Divider separator line ─────────────────────────────
            Container(
              // Full width divider
              height: 1.0,
              color: true == is_dark
                  ? AppColors.border_dark
                  : const Color(0xFFF1F5F9),
            ),
            const SizedBox(height: 12.0),

            // ── Sub-data Row: Dosage, Frequency, Duration ──────────
            Row(
              children: [
                // Pharmacy icon for dosage indicator
                const Icon(
                  Icons.local_pharmacy_outlined,
                  // Muted icon color
                  color: AppColors.text_light_secondary,
                  // Small icon size
                  size: 14.0,
                ),
                const SizedBox(width: 4.0),
                // Dosage and frequency metadata text
                Expanded(
                  child: Text(
                    // Format: "1 Tablet • Twice Daily"
                    '$dosage • $frequency',
                    style: const TextStyle(
                      // Small metadata text size
                      fontSize: 12.5,
                      // Muted secondary color
                      color: AppColors.text_light_secondary,
                    ),
                    // Clamp to single line
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Calendar icon for duration
                const Icon(
                  Icons.calendar_today_outlined,
                  // Muted icon color
                  color: AppColors.text_light_secondary,
                  // Small icon size
                  size: 14.0,
                ),
                const SizedBox(width: 4.0),
                // Duration text label
                Text(
                  // Duration string value
                  duration,
                  style: const TextStyle(
                    // Small metadata size
                    fontSize: 12.5,
                    // Muted secondary color
                    color: AppColors.text_light_secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            // ── Footer: Doctor, Date, Action Icons ─────────────────
            Row(
              // Space between content and action icons
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Doctor name and date added sub-row
                Expanded(
                  child: Row(
                    children: [
                      // Person icon for doctor
                      const Icon(
                        Icons.person_outline_rounded,
                        // Muted color
                        color: AppColors.text_light_secondary,
                        // Small size
                        size: 13.0,
                      ),
                      const SizedBox(width: 4.0),
                      // Doctor name and date text
                      Expanded(
                        child: Text(
                          // Format: "Doctor Name  •  Date"
                          '$doctor  •  $date',
                          style: const TextStyle(
                            // Small text size
                            fontSize: 11.5,
                            // Muted color
                            color: AppColors.text_light_secondary,
                          ),
                          // Truncate overflow
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action icon row: Edit + Delete
                Row(
                  children: [
                    // Low-opacity edit icon button placeholder
                    Opacity(
                      // 50% opacity for de-emphasis
                      opacity: 0.5,
                      child: IconButton(
                        // Compact visual density
                        visualDensity: VisualDensity.compact,
                        // TODO: Navigate to edit prescription flow
                        onPressed: () {},
                        icon: const Icon(
                          // Edit pencil icon
                          Icons.edit_outlined,
                          // Slate muted color
                          color: Color(0xFF64748B),
                          // Icon size
                          size: 18.0,
                        ),
                        // Constrained padding
                        padding: EdgeInsets.zero,
                        // Minimum size for tap target
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(width: 4.0),

                    // Low-opacity delete icon button
                    Opacity(
                      // 70% opacity for muted error state
                      opacity: 0.7,
                      child: IconButton(
                        // Compact visual density
                        visualDensity: VisualDensity.compact,
                        // Show confirm dialog before deletion
                        onPressed: () {
                          // Trigger delete confirmation dialog
                          _show_delete_confirm(
                            context,
                            id,
                            localizations,
                          );
                        },
                        icon: const Icon(
                          // Trash delete icon
                          Icons.delete_outline_rounded,
                          // Muted error color
                          color: AppColors.error,
                          // Icon size
                          size: 18.0,
                        ),
                        // Constrained padding
                        padding: EdgeInsets.zero,
                        // Minimum size for tap target
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

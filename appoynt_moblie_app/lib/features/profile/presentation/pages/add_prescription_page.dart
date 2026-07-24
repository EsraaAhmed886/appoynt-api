/*
 * File Name: add_prescription_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/07/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
 * File Description: Dedicated full-screen standalone form for adding a new
 * prescription entry. Dispatches the rich map payload directly to ProfileCubit
 * on save and pops back to the Prescription List screen.
 */

// Importing BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing design system barrel and route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing AuthTextField component for branded input fields
import 'package:appoynt_mobile_app/core/widgets/auth/auth_text_field.dart';
// Importing ProfileCubit for dispatching add prescription action
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';

// Stateful widget representing the standalone Add Prescription page
class AddPrescriptionPage extends StatefulWidget {
  // Optional prescription data for edit mode
  final Map<String, dynamic>? prescription;

  // Default constructor
  const AddPrescriptionPage({
    super.key,
    this.prescription,
  });

  // State builder factory
  @override
  State<AddPrescriptionPage> createState() {
    // Return concrete state instance
    return _AddPrescriptionPageState();
  }
}

// Concrete state class managing prescription input form fields
class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  // Text controller for medication name and dosage strength field
  final TextEditingController _name_controller = TextEditingController();

  // Text controller for dosage amount field (e.g., 1 Tablet)
  final TextEditingController _dosage_controller = TextEditingController();

  // Text controller for treatment duration in days
  final TextEditingController _duration_controller = TextEditingController();

  // Text controller for prescribing doctor name
  final TextEditingController _doctor_controller = TextEditingController();

  // Tracks the currently selected frequency chip option (default second)
  String _selected_frequency = 'Twice Daily';

  // Tracks the mock Rx attachment file name (null = no file attached)
  String? _attachment_name;

  @override
  void initState() {
    super.initState();
    // Pre-populate form controllers and state tracking fields if in Edit Mode (Yoda style check)
    if (null != widget.prescription) {
      final Map<String, dynamic> rx = widget.prescription!;
      _name_controller.text = rx['name'] as String? ?? '';
      _dosage_controller.text = rx['dosage'] as String? ?? '';
      _doctor_controller.text = rx['doctor'] as String? ?? '';
      _selected_frequency = rx['frequency'] as String? ?? 'Twice Daily';
      _attachment_name = rx['attachment'] as String?;

      // Strip " Days" suffix if it exists to populate the number input cleanly
      final String duration_raw = rx['duration'] as String? ?? '';
      if (duration_raw.endsWith(' Days')) {
        _duration_controller.text = duration_raw.replaceAll(' Days', '');
      } else {
        _duration_controller.text = duration_raw;
      }
    } else {
      // Empty block
    }
  }

  // Dispose all controllers to release memory resources on widget teardown
  @override
  void dispose() {
    // Dispose medication name controller
    _name_controller.dispose();
    // Dispose dosage controller
    _dosage_controller.dispose();
    // Dispose duration controller
    _duration_controller.dispose();
    // Dispose doctor name controller
    _doctor_controller.dispose();
    // Call super dispose
    super.dispose();
  }

  // Handle the save action — validates, builds map, dispatches cubit, pops
  void _on_save(BuildContext save_context, AppLocalizations localizations) {
    // Read medication name trimming whitespace
    final String name = _name_controller.text.trim();
    // Return early if name is empty — no action taken
    if (name.isEmpty) {
      return;
    } else {
      // Resolve dosage with default fallback
      final String dosage = _dosage_controller.text.trim().isEmpty
          ? '1 Tablet'
          : _dosage_controller.text.trim();
      // Resolve duration with default fallback label
      final String duration = _duration_controller.text.trim().isEmpty
          ? 'Ongoing'
          : '${_duration_controller.text.trim()} Days';
      // Resolve doctor name with default fallback label
      final String doctor = _doctor_controller.text.trim().isEmpty
          ? 'Self-Recorded'
          : _doctor_controller.text.trim();

      // Check if in Edit Mode (Yoda style check)
      final bool is_edit = null != widget.prescription;
      final String rx_id = true == is_edit
          ? (widget.prescription!['id'] as String? ??
              DateTime.now().millisecondsSinceEpoch.toString())
          : DateTime.now().millisecondsSinceEpoch.toString();
      final String rx_status = true == is_edit
          ? (widget.prescription!['status'] as String? ??
              localizations.prescriptions_status_active)
          : localizations.prescriptions_status_active;
      final String rx_date = true == is_edit
          ? (widget.prescription!['date'] as String? ?? 'Today')
          : 'Today';

      // Build the rich prescription data map matching the entity schema
      final Map<String, dynamic> rx_data = {
        // Unique timestamp-based ID field
        'id': rx_id,
        // Medication name with dosage strength string
        'name': name,
        // Dosage amount resolved string
        'dosage': dosage,
        // Selected frequency chip value
        'frequency': _selected_frequency,
        // Resolved duration label string
        'duration': duration,
        // Status defaults to Active for new prescriptions
        'status': rx_status,
        // Doctor name or self-recorded fallback
        'doctor': doctor,
        // Date string set to today
        'date': rx_date,
        // Optional Rx file attachment name
        'attachment': _attachment_name,
      };

      if (true == is_edit) {
        // Dispatch the update prescription action to cubit
        save_context.read<ProfileCubit>().update_prescription(rx_id, rx_data);
      } else {
        // Dispatch the rich map payload to the ProfileCubit
        save_context.read<ProfileCubit>().add_prescription(rx_data);
      }

      // Pop back to the Prescription List screen
      Navigator.of(save_context).pop();
    }
  }

  // ─── Widget Build ──────────────────────────────────────────────────────────

  // Build the full-screen form layout
  @override
  Widget build(BuildContext context) {
    // Resolve localized strings from ambient context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness flag
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final bool is_ar = localizations.is_arabic;
    final bool is_edit = null != widget.prescription;

    // Resolve dynamic page title copy
    final String page_title = true == is_edit
        ? (true == is_ar ? 'تعديل بيانات الدواء' : 'Edit Medication')
        : localizations.prescriptions_modal_title;

    // Resolve dynamic button label copy
    final String cta_label = true == is_edit
        ? (true == is_ar ? 'تحديث الدواء' : 'Update Prescription')
        : localizations.prescriptions_save_btn;

    // Build localized frequency chip labels from localization dictionary
    final List<String> freq_options = [
      localizations.prescriptions_freq_once,
      localizations.prescriptions_freq_twice,
      localizations.prescriptions_freq_every8,
      localizations.prescriptions_freq_as_needed,
    ];

    return Scaffold(
      // Canvas background color adapts to theme mode
      backgroundColor:
          true == is_dark ? AppColors.background_dark : const Color(0xFFF8FAFC),
      // Primary form body wrapped in safe area
      body: SafeArea(
        child: Padding(
          // 16px lateral canvas margins
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          child: Column(
            // Align children to leading axis
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top gap spacer before AppBar
              const SizedBox(height: AppSpacing.space_xl),

              // ── Standard back navigation header ─────────────────────
              CustomProfileAppBar(
                // Localized page title
                title: page_title,
              ),
              const SizedBox(height: AppSpacing.space_xl),

              // ── Scrollable form body ─────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  // Zero extra padding — margin is on parent Padding widget
                  padding: EdgeInsets.zero,
                  child: Column(
                    // Align children to leading axis
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── SECTION CARD 1: Medication Details ───────────
                      _build_section_card(
                        is_dark: is_dark,
                        // Section heading title (serves as the sole label)
                        title: 'Medication Details',
                        children: [
                          // Medication name and dosage strength text field
                          AuthTextField(
                            // Pass empty label so no second label renders
                            label: '',
                            // Localized placeholder hint string
                            hint: localizations.prescriptions_field_name_hint,
                            // Bind text controller
                            controller: _name_controller,
                          ),
                          const SizedBox(height: AppSpacing.space_m),

                          // Dosage amount text field
                          AuthTextField(
                            // Static dosage label
                            label: 'Dosage',
                            // Placeholder hint for dosage amount
                            hint: 'e.g., 1 Tablet, 10ml',
                            // Bind dosage controller
                            controller: _dosage_controller,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space_l),

                      // ── SECTION CARD 2: Schedule & Frequency ─────────
                      _build_section_card(
                        is_dark: is_dark,
                        // Section heading title
                        title: 'Schedule & Duration',
                        children: [
                          // Frequency chip group label
                          Text(
                            // Localized frequency label
                            localizations.prescriptions_field_freq_label,
                            style: TextStyle(
                              // Small label font size
                              fontSize: 12.0,
                              // Bold weight
                              fontWeight: FontWeight.bold,
                              // Adaptive text color
                              color: true == is_dark
                                  ? Colors.white
                                  : AppColors.text_light_primary,
                            ),
                          ),
                          const SizedBox(height: 8.0),

                          // Horizontal scrollable animated frequency chip row
                          SingleChildScrollView(
                            // Horizontal scroll direction
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              // Build each chip from the localized options list
                              children: freq_options.map((freq) {
                                // Determine if this chip is currently selected
                                final bool is_selected =
                                    _selected_frequency == freq;
                                return Padding(
                                  // Right spacing between chips
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: GestureDetector(
                                    // Update selection state on tap
                                    onTap: () {
                                      setState(() {
                                        // Bind new frequency selection
                                        _selected_frequency = freq;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      // Smooth state transition duration
                                      duration:
                                          const Duration(milliseconds: 200),
                                      // Internal horizontal and vertical padding
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0,
                                        vertical: 9.0,
                                      ),
                                      // Chip decoration adapting to selection state
                                      decoration: BoxDecoration(
                                        // Selected: primary blue fill
                                        color: true == is_selected
                                            ? AppColors.primary_color
                                            : (true == is_dark
                                                ? AppColors.background_dark
                                                : const Color(0xFFF1F5F9)),
                                        // Pill-shape 30px radius
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        // Chip border outline
                                        border: Border.all(
                                          // Selected: primary color border
                                          color: true == is_selected
                                              ? AppColors.primary_color
                                              : (true == is_dark
                                                  ? AppColors.border_dark
                                                  : const Color(0xFFE2E8F0)),
                                          // Slightly thicker border
                                          width: 1.5,
                                        ),
                                      ),
                                      // Chip label text widget
                                      child: Text(
                                        // Frequency option label string
                                        freq,
                                        style: TextStyle(
                                          // Small chip text size
                                          fontSize: 12.0,
                                          // Bold when selected
                                          fontWeight: true == is_selected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          // White when selected else secondary
                                          color: true == is_selected
                                              ? Colors.white
                                              : (true == is_dark
                                                  ? Colors.white70
                                                  : AppColors
                                                      .text_light_primary),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space_m),

                          // Treatment duration text field
                          AuthTextField(
                            // Localized duration label
                            label: localizations
                                .prescriptions_field_duration_label,
                            // Localized duration hint
                            hint:
                                localizations.prescriptions_field_duration_hint,
                            // Bind duration controller
                            controller: _duration_controller,
                          ),
                          const SizedBox(height: AppSpacing.space_m),

                          // Prescribing doctor optional text field
                          AuthTextField(
                            // Localized doctor label
                            label:
                                localizations.prescriptions_field_doctor_label,
                            // Localized doctor hint
                            hint: localizations.prescriptions_field_doctor_hint,
                            // Bind doctor controller
                            controller: _doctor_controller,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.space_l),

                      // ── SECTION CARD 3: Rx Attachment ────────────────
                      _build_section_card(
                        is_dark: is_dark,
                        // Section heading title
                        title: localizations.prescriptions_field_rx_label,
                        children: [
                          // Tap-to-attach Rx file picker mock area
                          GestureDetector(
                            // Simulate file picker action on tap
                            onTap: () {
                              setState(() {
                                // Mock attached file name value
                                _attachment_name =
                                    'prescription_attachment.pdf';
                              });
                            },
                            child: Container(
                              // Fill available horizontal width
                              width: double.infinity,
                              // Vertical padding inside touch area
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 16.0,
                              ),
                              // Rounded outline decoration
                              decoration: BoxDecoration(
                                // Slightly tinted canvas background
                                color: true == is_dark
                                    ? AppColors.background_dark
                                    : const Color(0xFFF8FAFC),
                                // Rounded 12px corners
                                borderRadius: BorderRadius.circular(12.0),
                                // Thin border outline
                                border: Border.all(
                                  color: true == is_dark
                                      ? AppColors.border_dark
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Attachment or check icon
                                  Icon(
                                    // Show check when file is attached
                                    _attachment_name != null
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.attach_file_rounded,
                                    // Green when attached else primary blue
                                    color: _attachment_name != null
                                        ? const Color(0xFF10B981)
                                        : AppColors.primary_color,
                                    // Icon display size
                                    size: 22.0,
                                  ),
                                  const SizedBox(width: 10.0),
                                  // Attached file name or placeholder text
                                  Expanded(
                                    child: Text(
                                      // Show filename or placeholder
                                      _attachment_name ??
                                          'Upload Rx Photo / Document (Optional)',
                                      style: TextStyle(
                                        // Body font size
                                        fontSize: 13.0,
                                        // Bold if file attached
                                        fontWeight: _attachment_name != null
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        // Green when attached else secondary
                                        color: _attachment_name != null
                                            ? const Color(0xFF10B981)
                                            : AppColors.text_light_secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ── Sticky Save CTA at bottom of scrollable form ──
                      const SizedBox(height: AppSpacing.space_xl),

                      // Full-width primary Save Prescription button
                      SizedBox(
                        // Fill full horizontal width
                        width: double.infinity,
                        // Standard button height token
                        height: AppSpacing.height_auth_button,
                        child: ElevatedButton(
                          // Dispatch save action on press
                          onPressed: () => _on_save(context, localizations),
                          // Button styling configuration
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
                          child: Text(
                            // Localized save button label
                            cta_label,
                            style: const TextStyle(
                              // White text on blue fill
                              color: Colors.white,
                              // Action font size token
                              fontSize: AppSpacing.font_size_action_button,
                              // Bold weight
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Bottom spacing before edge of scroll view
                      const SizedBox(height: AppSpacing.space_xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Sub-Widgets ───────────────────────────────────────────────────────────

  // Build a reusable floating section card with title and children
  Widget _build_section_card({
    required bool is_dark,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      // Internal card padding
      padding: const EdgeInsets.all(AppSpacing.space_l),
      // Card decoration with shadow and border
      decoration: BoxDecoration(
        // White surface in light mode, dark surface in dark mode
        color: true == is_dark ? AppColors.surface_dark : Colors.white,
        // 16px rounded corners
        borderRadius: BorderRadius.circular(16.0),
        // Thin border outline
        border: Border.all(
          // Adaptive border color
          color:
              true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
          // Border width token
          width: AppSpacing.border_width_thin,
        ),
        // Soft ambient shadow for floating card effect
        boxShadow: [
          BoxShadow(
            // Tinted shadow adapts to theme
            color: true == is_dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            // Blur radius
            blurRadius: 8.0,
            // Vertical shadow offset
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Column(
        // Align children to start axis
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading title text
          Text(
            // Section title label
            title,
            style: TextStyle(
              // Medium font size
              fontSize: 15.0,
              // Bold weight
              fontWeight: FontWeight.bold,
              // Adaptive text color
              color:
                  true == is_dark ? Colors.white : AppColors.text_light_primary,
            ),
          ),
          const SizedBox(height: AppSpacing.space_m),
          // Render all section content children
          ...children,
        ],
      ),
    );
  }
}

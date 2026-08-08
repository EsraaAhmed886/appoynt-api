/*
 * File Name: add_test_result_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 23/07/2026]
 * File Description: Defines the upload form screen to attach new diagnostic lab reports or scanning files with modern cards and upload zones.
 */

// Importing standard dart UI for dasher border metrics
import 'dart:ui';
// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing custom date picker
import 'package:appoynt_mobile_app/core/widgets/app_date_picker.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';


// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_medium = 12.0;
  static const double border_width_thick = 1.5;
  static const double border_width_thin = 1.0;
  static const double border_width_accent = 2.0;
  static const double button_height = 50.0;
  static const double button_height_large = 100.0;
  static const double button_height_small = 44.0;
  static const double upload_zone_height = 120.0;
  static const double spacing_tiny = 4.0;
  static const double spacing_small = 8.0;
  static const double spacing_medium = 12.0;
  static const double spacing_large = 16.0;
  static const double spacing_xl = 20.0;
  static const double padding_card = 20.0;
  static const double padding_large = 16.0;
  static const double padding_small = 8.0;
  static const double font_size_body = 14.0;
  static const double font_size_medium = 13.0;
  static const double font_size_small = 12.0;
  static const double font_size_tiny = 11.0;
  static const double icon_size_small = 20.0;
  static const double icon_size_medium = 24.0;
  static const double icon_size_large = 36.0;
  static const double icon_size_tiny = 12.0;
  static const double file_icon_container_size = 48.0;
  static const double shadow_blur_default = 10.0;
  static const double shadow_blur_small = 6.0;
  static const double shadow_opacity_dark = 0.25;
  static const double shadow_opacity_light = 0.03;
  static const double shadow_opacity_light_alt = 0.04;
  static const double dash_width = 6.0;
  static const double dash_space = 4.0;
}

// Add Test Result Page layout stateful widget representation
class AddTestResultPage extends StatefulWidget {
  // Initial active category type (lab_test / scan)
  final String initial_type;

  // Constructor mapping initial type parameter
  const AddTestResultPage({
    super.key,
    required this.initial_type,
  });

  // State builder definition
  @override
  State<AddTestResultPage> createState() {
    // Return state instance representation
    return _AddTestResultPageState();
  }
}

// Concrete state tracker implementation class for the AddTestResultPage
class _AddTestResultPageState extends State<AddTestResultPage> {
  // Global form key validation tracker configuration
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();

  // Input controllers mapping text entries
  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _facility_controller = TextEditingController();
  final TextEditingController _date_controller = TextEditingController();
  final TextEditingController _doctor_controller = TextEditingController();
  final TextEditingController _notes_controller = TextEditingController();

  // Active status selector type: normal, abnormal, pending
  String _status = 'normal';
  // Active category selection type (lab_test / scan)
  late String _active_type;

  // Mock file attachment tracker path details
  String _uploaded_file_path = '';
  String _uploaded_file_name = '';
  String _uploaded_file_size = '';

  // Initialize status copying initial configurations
  @override
  void initState() {
    // Invoke base initState
    super.initState();
    // Bind active type parameter
    _active_type = widget.initial_type;
  }

  // Dispose controllers freeing system resources
  @override
  void dispose() {
    // Dispose text field controllers
    _name_controller.dispose();
    _facility_controller.dispose();
    _date_controller.dispose();
    _doctor_controller.dispose();
    _notes_controller.dispose();
    // Call base dispose
    super.dispose();
  }

  // Modern custom Calendar Card popover Dialog matching second reference image specifications
  void _show_custom_date_picker(BuildContext context, bool is_dark,
      AppLocalizations localizations) async {
    // Resolve showAppDatePicker future using Yoda comparisons and correct limits
    final DateTime? selected = await showAppDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selected != null && context.mounted) {
      final String month = localizations.month_names[selected.month - 1];

      // E.g. "23 July 2026" / "23 يوليو 2026"
      final String formatted = "${selected.day} $month ${selected.year}";
      setState(() {
        _date_controller.text = formatted;
      });
    }
  }

  // Submit test result attachment form
  void _submit_upload() {
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Validate form fields using validator triggers
    if (true == _form_key.currentState?.validate()) {
      // Check if document was uploaded using mock path checks
      if (_uploaded_file_path.isEmpty) {
        // Show feedback warning warning message info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Warning message text
            content: Text(localizations.tests_error_no_file),
            // Error background color
            backgroundColor: AppColors.error,
          ),
        );
      } else {
        // Dispatch test result details to Cubit controller
        context.read<ProfileCubit>().add_test_result(
              // Document Name text
              _name_controller.text,
              // Diagnostic date selection text
              _date_controller.text,
              // digital file path reference
              _uploaded_file_path,
              // Category type selection
              _active_type,
              facility_name: _facility_controller.text.trim().isEmpty
                  ? null
                  : _facility_controller.text,
              status: _status,
              doctor_name: _doctor_controller.text.trim().isEmpty
                  ? null
                  : _doctor_controller.text,
              notes: _notes_controller.text.trim().isEmpty
                  ? null
                  : _notes_controller.text,
            );
        // Show success notification message info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Success label text
            content: Text(localizations.tests_success_upload),
            // Primary color
            backgroundColor: AppColors.primary_color,
          ),
        );
        // Pop upload form screen layout returning back to list screen
        Navigator.of(context).pop();
      }
    }
  }

  // Reusable custom layout card container
  Widget _build_card({
    required List<Widget> children,
    required bool is_dark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_LocalDimensions.padding_card),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : Colors.white,
        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? Colors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                : Colors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
            blurRadius: _LocalDimensions.shadow_blur_default,
            spreadRadius: _LocalDimensions.border_width_thin,
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // Reusable text input field structured exactly like the auth inputs
  Widget _build_input_field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool is_dark,
    String? Function(String?)? validator,
    int max_lines = 1,
    bool read_only = false,
    IconData? prefix_icon,
    VoidCallback? on_tap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label header text above input card field
        Text(
          label,
          style: TextStyle(
            fontSize: AppSpacing.font_size_body_medium,
            fontWeight: FontWeight.w700,
            color: is_dark
                ? AppColors.text_dark_primary
                : AppColors.text_light_primary,
          ),
        ),
        const SizedBox(height: _LocalDimensions.spacing_small),
        // Isolated TextFormField with shadow
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              height: max_lines == 1 ? _LocalDimensions.button_height : _LocalDimensions.button_height_large,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                  boxShadow: [
                    BoxShadow(
                      color: is_dark
                          ? Colors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                          : Colors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light_alt),
                      blurRadius: _LocalDimensions.shadow_blur_small,
                      spreadRadius: _LocalDimensions.border_width_thin,
                      offset: const Offset(0.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
            TextFormField(
              controller: controller,
              readOnly: read_only,
              maxLines: max_lines,
              style: TextStyle(
                fontSize: AppSpacing.font_size_text,
                color: is_dark
                    ? AppColors.text_dark_primary
                    : AppColors.text_light_primary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: AppSpacing.font_size_text,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
                filled: true,
                fillColor:
                    is_dark ? AppColors.surface_dark : AppColors.input_fill,
                prefixIcon: prefix_icon != null
                    ? Icon(
                        prefix_icon,
                        color: is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary,
                        size: _LocalDimensions.icon_size_small,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                  borderSide: BorderSide(
                    color: is_dark
                        ? AppColors.border_dark
                        : AppColors.border_light,
                    width: AppSpacing.border_width_thin,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                  borderSide: BorderSide(
                    color: is_dark
                        ? AppColors.border_dark
                        : AppColors.border_light,
                    width: AppSpacing.border_width_thin,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space_xl,
                  vertical: AppSpacing.padding_input_vertical,
                ),
              ),
              validator: validator,
              onTap: on_tap,
            ),
          ],
        ),
      ],
    );
  }

  // Segmented status chip widget builder
  Widget _build_status_chip(
    String value,
    String label,
    Color bg_color,
    Color border_color,
    Color text_color,
    bool is_dark,
  ) {
    final bool is_selected = _status == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _status = value;
          });
        },
        child: Container(
          height: _LocalDimensions.button_height_small,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: is_selected
                ? bg_color
                : (is_dark ? AppColors.surface_dark : Colors.white),
            borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
            border: Border.all(
              color: is_selected
                  ? border_color
                  : (is_dark ? AppColors.border_dark : AppColors.slate_200),
              width: is_selected ? _LocalDimensions.border_width_accent : _LocalDimensions.border_width_thin,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: is_selected
                  ? text_color
                  : (is_dark ? Colors.white70 : AppColors.text_light_secondary),
              fontWeight: is_selected ? FontWeight.bold : FontWeight.normal,
              fontSize: _LocalDimensions.font_size_medium,
            ),
          ),
        ),
      ),
    );
  }

  // Draw widget views structures
  @override
  Widget build(BuildContext context) {
    // Resolve localized labels context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Localized layout Strings
    final String doc_name_label = localizations.add_test_doc_name_label;
    final String doc_name_hint = localizations.add_test_doc_name_hint;

    final String facility_label = localizations.add_test_facility_label;
    final String facility_hint = localizations.add_test_facility_hint;

    final String date_label = localizations.add_test_date_label;
    final String date_hint = localizations.add_test_date_hint;

    final String status_label = localizations.add_test_status_label;

    final String status_normal = localizations.add_test_status_normal;
    final String status_abnormal = localizations.add_test_status_abnormal;
    final String status_pending = localizations.add_test_status_pending;

    final String doctor_label = localizations.add_test_doctor_label;
    final String doctor_hint = localizations.add_test_doctor_hint;

    final String notes_label = localizations.add_test_notes_label;
    final String notes_hint = localizations.add_test_notes_hint;

    final String upload_label = localizations.add_test_upload_label;
    final String dropzone_text = localizations.add_test_dropzone_text;
    final String dropzone_sub = localizations.add_test_dropzone_sub;

    // Return root Scaffold layout container
    return Scaffold(
      // Scrollable view wrapping upload form fields
      body: SafeArea(
        child: Form(
          key: _form_key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: _LocalDimensions.padding_large,
                  right: _LocalDimensions.padding_large,
                  top: _LocalDimensions.padding_large,
                  bottom: _LocalDimensions.padding_small,
                ),
                child: CustomProfileAppBar(
                  title: localizations.tests_add_title,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space_m),
                child: Column(
                  children: [
                    // Horizontal custom category toggle capsule bar
                    Container(
                      height: AppSpacing.dummy_height_search_bar,
                      decoration: BoxDecoration(
                        color:
                            is_dark ? AppColors.surface_dark : Colors.grey[200],
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radius_xl),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _active_type = 'lab_test';
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: 'lab_test' == _active_type
                                      ? (is_dark
                                          ? AppColors.primary_color
                                          : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radius_xl),
                                ),
                                child: Text(
                                  localizations.tests_tab_lab,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: 'lab_test' == _active_type
                                        ? (is_dark
                                            ? Colors.white
                                            : AppColors.primary_color)
                                        : AppColors.text_light_secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _active_type = 'scan';
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: 'scan' == _active_type
                                      ? (is_dark
                                          ? AppColors.primary_color
                                          : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radius_xl),
                                ),
                                child: Text(
                                  localizations.tests_tab_scanning,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: 'scan' == _active_type
                                        ? (is_dark
                                            ? Colors.white
                                            : AppColors.primary_color)
                                        : AppColors.text_light_secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_xl),

                    // Card 1: Document & Lab Details
                    _build_card(
                      is_dark: is_dark,
                      children: [
                        // Document Name input field
                        _build_input_field(
                          label: doc_name_label,
                          hint: doc_name_hint,
                          controller: _name_controller,
                          is_dark: is_dark,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.add_test_validation_name_empty;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: _LocalDimensions.spacing_large),
                        // Facility Name input field
                        _build_input_field(
                          label: facility_label,
                          hint: facility_hint,
                          controller: _facility_controller,
                          is_dark: is_dark,
                        ),
                        const SizedBox(height: _LocalDimensions.spacing_large),
                        // Test Date picker field
                        _build_input_field(
                          label: date_label,
                          hint: date_hint,
                          controller: _date_controller,
                          is_dark: is_dark,
                          read_only: true,
                          prefix_icon: Icons.calendar_today_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.add_test_validation_date_empty;
                            }
                            return null;
                          },
                          on_tap: () {
                            _show_custom_date_picker(
                                context, is_dark, localizations);
                          },
                        ),
                        const SizedBox(height: _LocalDimensions.spacing_large),
                        // Doctor Name input field
                        _build_input_field(
                          label: doctor_label,
                          hint: doctor_hint,
                          controller: _doctor_controller,
                          is_dark: is_dark,
                        ),
                      ],
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_xl),

                    // Card 2: File Upload & Status
                    _build_card(
                      is_dark: is_dark,
                      children: [
                        // Result Status Indicator Label
                        Text(
                          status_label,
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.w700,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                        const SizedBox(height: _LocalDimensions.spacing_medium),
                        // Segmented Chip Selector Row
                        Row(
                          children: [
                            _build_status_chip(
                              'normal',
                              status_normal,
                              is_dark
                                  ? const Color(0xFF14532D)
                                  : const Color(0xFFDCFCE7),
                              is_dark
                                  ? const Color(0xFF166534)
                                  : const Color(0xFF86EFAC),
                              is_dark
                                  ? const Color(0xFF4ADE80)
                                  : const Color(0xFF15803D),
                              is_dark,
                            ),
                            const SizedBox(width: _LocalDimensions.spacing_small),
                            _build_status_chip(
                              'abnormal',
                              status_abnormal,
                              is_dark
                                  ? const Color(0xFF7F1D1D)
                                  : const Color(0xFFFEE2E2),
                              is_dark
                                  ? const Color(0xFF991B1B)
                                  : const Color(0xFFFCA5A5),
                              is_dark
                                  ? const Color(0xFFFCA5A5)
                                  : const Color(0xFFB91C1C),
                              is_dark,
                            ),
                            const SizedBox(width: _LocalDimensions.spacing_small),
                            _build_status_chip(
                              'pending',
                              status_pending,
                              is_dark
                                  ? const Color(0xFF7C2D12)
                                  : const Color(0xFFFFEDD5),
                              is_dark
                                  ? const Color(0xFF9A3412)
                                  : const Color(0xFFFDBA74),
                              is_dark
                                  ? const Color(0xFFFED7AA)
                                  : const Color(0xFFC2410C),
                              is_dark,
                            ),
                          ],
                        ),
                        const SizedBox(height: _LocalDimensions.spacing_xl),
                        // Upload label
                        Text(
                          upload_label,
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.w700,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                        const SizedBox(height: _LocalDimensions.spacing_medium),
                        // Dashed dropzone box or file preview card
                        _uploaded_file_path.isEmpty
                            ? CustomPaint(
                                painter: _DashedBorderPainter(
                                  color: is_dark
                                      ? AppColors.border_dark
                                      : AppColors.slate_300,
                                  strokeWidth: _LocalDimensions.border_width_thick,
                                  dashWidth: _LocalDimensions.dash_width,
                                  dashSpace: _LocalDimensions.dash_space,
                                  radius: _LocalDimensions.border_radius_default,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _uploaded_file_path =
                                          '/mock/device/upload_doc.pdf';
                                      _uploaded_file_name = 'cbc_report.pdf';
                                      _uploaded_file_size = '1.2 MB';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(localizations
                                            .tests_file_attached_toast),
                                        backgroundColor:
                                            AppColors.primary_color,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: _LocalDimensions.upload_zone_height,
                                    decoration: BoxDecoration(
                                      color: is_dark
                                          ? AppColors.surface_dark
                                          : AppColors.slate_50,
                                      borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.cloud_upload_outlined,
                                          color: AppColors.primary_color,
                                          size: _LocalDimensions.icon_size_large,
                                        ),
                                        const SizedBox(height: _LocalDimensions.spacing_small),
                                        Text(
                                          dropzone_text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: _LocalDimensions.font_size_body,
                                            fontWeight: FontWeight.w600,
                                            color: is_dark
                                                ? Colors.white70
                                                : AppColors.slate_600,
                                          ),
                                        ),
                                        const SizedBox(height: _LocalDimensions.spacing_tiny),
                                        Text(
                                          dropzone_sub,
                                          style: const TextStyle(
                                            fontSize: _LocalDimensions.font_size_tiny,
                                            color: AppColors.slate_400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(_LocalDimensions.padding_large),
                                decoration: BoxDecoration(
                                  color: is_dark
                                      ? AppColors.surface_dark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                                  border: Border.all(
                                    color: is_dark
                                        ? AppColors.border_dark
                                        : AppColors.slate_200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // File type icon container (PDF representation)
                                    Container(
                                      width: _LocalDimensions.file_icon_container_size,
                                      height: _LocalDimensions.file_icon_container_size,
                                      decoration: BoxDecoration(
                                        color: is_dark
                                            ? AppColors.border_dark
                                            : AppColors.slate_50,
                                        borderRadius:
                                            BorderRadius.circular(_LocalDimensions.border_radius_medium),
                                      ),
                                      child: const Icon(
                                        Icons.picture_as_pdf_rounded,
                                        color: AppColors.primary_color,
                                        size: _LocalDimensions.icon_size_medium,
                                      ),
                                    ),
                                    const SizedBox(width: _LocalDimensions.spacing_medium),
                                    // File details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _uploaded_file_name,
                                            style: TextStyle(
                                              fontSize: _LocalDimensions.font_size_body,
                                              fontWeight: FontWeight.bold,
                                              color: is_dark
                                                  ? Colors.white
                                                  : AppColors
                                                      .text_light_primary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: _LocalDimensions.spacing_tiny),
                                          Text(
                                            "$_uploaded_file_size • ${localizations.add_test_uploaded_status}",
                                            style: const TextStyle(
                                              fontSize: _LocalDimensions.font_size_small,
                                              color: AppColors.slate_400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: _LocalDimensions.spacing_small),
                                    // Success checkmark badge
                                    Container(
                                      width: _LocalDimensions.icon_size_small,
                                      height: _LocalDimensions.icon_size_small,
                                      decoration: const BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: _LocalDimensions.icon_size_tiny,
                                      ),
                                    ),
                                    const SizedBox(width: _LocalDimensions.spacing_medium),
                                    // Trash Icon to remove file
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.error,
                                        size: _LocalDimensions.icon_size_small,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _uploaded_file_path = '';
                                          _uploaded_file_name = '';
                                          _uploaded_file_size = '';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: _LocalDimensions.spacing_xl),
                        // Quick Notes optional multi-line input field
                        _build_input_field(
                          label: notes_label,
                          hint: notes_hint,
                          controller: _notes_controller,
                          is_dark: is_dark,
                          max_lines: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
      // Sticky bottom navigation bar for primary Confirm Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space_m,
            vertical: AppSpacing.space_m,
          ),
          child: SizedBox(
            width: double.infinity,
            height: AppSpacing.height_auth_button,
            child: ElevatedButton(
              onPressed: _submit_upload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_color,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                ),
              ),
              child: Text(
                localizations.tests_confirm_upload_btn,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppSpacing.font_size_action_button,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// Dashed border painter implementation
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    this.radius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);

    final Path dashedPath = Path();
    double distance = 0.0;
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

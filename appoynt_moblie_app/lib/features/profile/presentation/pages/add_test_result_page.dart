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
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';

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
    final DateTime? selected = await showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (dialog_context) {
        return _CustomCalendarDialog(
          initialDate: DateTime.now(),
          isDark: is_dark,
          localizations: localizations,
        );
      },
    );

    if (selected != null && context.mounted) {
      final List<String> months_en = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      final List<String> months_ar = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      final String month = localizations.is_arabic
          ? months_ar[selected.month - 1]
          : months_en[selected.month - 1];

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
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: is_dark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.0,
            spreadRadius: 1.0,
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
        const SizedBox(height: 8.0),
        // Isolated TextFormField with shadow
        Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              height: max_lines == 1 ? 50.0 : 100.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                  boxShadow: [
                    BoxShadow(
                      color: is_dark
                          ? Colors.black.withValues(alpha: 0.25)
                          : Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
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
                        size: 20.0,
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
          height: 44.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: is_selected
                ? bg_color
                : (is_dark ? AppColors.surface_dark : Colors.white),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: is_selected
                  ? border_color
                  : (is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0)),
              width: is_selected ? 2.0 : 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: is_selected
                  ? text_color
                  : (is_dark ? Colors.white70 : AppColors.text_light_secondary),
              fontWeight: is_selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13.0,
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
    final String doc_name_label =
        localizations.is_arabic ? "اسم المستند" : "Document Name";
    final String doc_name_hint = localizations.is_arabic
        ? "مثال: صورة دم كاملة (CBC)"
        : "e.g., Complete Blood Count (CBC)";

    final String facility_label = localizations.is_arabic
        ? "المعمل / المركز الطبي"
        : "Facility / Lab Name";
    final String facility_hint = localizations.is_arabic
        ? "مثال: معمل البرج، كايرو سكان"
        : "e.g., Al Borg Laboratories, Cairo Scan";

    final String date_label =
        localizations.is_arabic ? "تاريخ الفحص / الأشعة" : "Test / Scan Date";
    final String date_hint =
        localizations.is_arabic ? "اختر التاريخ" : "Select Date";

    final String status_label =
        localizations.is_arabic ? "حالة النتيجة" : "Result Status";

    final String status_normal = localizations.is_arabic ? "طبيعي" : "Normal";
    final String status_abnormal =
        localizations.is_arabic ? "غير طبيعي" : "Abnormal";
    final String status_pending =
        localizations.is_arabic ? "قيد المراجعة" : "Pending";

    final String doctor_label = localizations.is_arabic
        ? "الطبيب المعالج (اختياري)"
        : "Prescribing Doctor (Optional)";
    final String doctor_hint = localizations.is_arabic
        ? "اسم الطبيب المعالج"
        : "Prescribed by Dr. ...";

    final String notes_label = localizations.is_arabic
        ? "ملاحظات إضافية (اختياري)"
        : "Quick Notes (Optional)";
    final String notes_hint = localizations.is_arabic
        ? "أضف أي ملاحظات أو تفاصيل إضافية هنا..."
        : "Add any additional details or notes here...";

    final String upload_label =
        localizations.is_arabic ? "تحميل التقرير" : "Upload Document";
    final String dropzone_text = localizations.is_arabic
        ? "اضغط هنا لرفع صورة أو ملف PDF للتقرير"
        : "Tap to upload image or PDF report";
    final String dropzone_sub = localizations.is_arabic
        ? "الحد الأقصى للملف 10 ميجابايت (JPG, PNG, PDF)"
        : "Supports JPG, PNG, PDF up to 10MB";

    // Return root Scaffold layout container
    return Scaffold(
      // Background colors canvas
      backgroundColor:
          is_dark ? AppColors.background_dark : const Color(0xFFF8FAFC),
      // App bar details
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.tests_add_title,
          style: TextStyle(
            fontSize: AppSpacing.font_size_title,
            fontWeight: FontWeight.w700,
            color: is_dark
                ? AppColors.text_dark_primary
                : AppColors.text_light_primary,
          ),
        ),
      ),
      // Scrollable view wrapping upload form fields
      body: Form(
        key: _form_key,
        child: Column(
          children: [
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
                    const SizedBox(height: 20.0),

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
                              return 'Document Name cannot be empty.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Facility Name input field
                        _build_input_field(
                          label: facility_label,
                          hint: facility_hint,
                          controller: _facility_controller,
                          is_dark: is_dark,
                        ),
                        const SizedBox(height: 16.0),
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
                              return 'Please select a date.';
                            }
                            return null;
                          },
                          on_tap: () {
                            _show_custom_date_picker(
                                context, is_dark, localizations);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Doctor Name input field
                        _build_input_field(
                          label: doctor_label,
                          hint: doctor_hint,
                          controller: _doctor_controller,
                          is_dark: is_dark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

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
                        const SizedBox(height: 12.0),
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
                            const SizedBox(width: 8.0),
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
                            const SizedBox(width: 8.0),
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
                        const SizedBox(height: 20.0),
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
                        const SizedBox(height: 12.0),
                        // Dashed dropzone box or file preview card
                        _uploaded_file_path.isEmpty
                            ? CustomPaint(
                                painter: _DashedBorderPainter(
                                  color: is_dark
                                      ? AppColors.border_dark
                                      : const Color(0xFFCBD5E1),
                                  strokeWidth: 1.5,
                                  dashWidth: 6.0,
                                  dashSpace: 4.0,
                                  radius: 16.0,
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
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      color: is_dark
                                          ? AppColors.surface_dark
                                          : const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.cloud_upload_outlined,
                                          color: AppColors.primary_color,
                                          size: 36.0,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          dropzone_text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: is_dark
                                                ? Colors.white70
                                                : const Color(0xFF475569),
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          dropzone_sub,
                                          style: const TextStyle(
                                            fontSize: 11.0,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: is_dark
                                      ? AppColors.surface_dark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: is_dark
                                        ? AppColors.border_dark
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // File type icon container (PDF representation)
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: is_dark
                                            ? const Color(0xFF1E293B)
                                            : const Color(0xFFEFF6FF),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: const Icon(
                                        Icons.picture_as_pdf_rounded,
                                        color: AppColors.primary_color,
                                        size: 24.0,
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    // File details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _uploaded_file_name,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: is_dark
                                                  ? Colors.white
                                                  : AppColors
                                                      .text_light_primary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            "$_uploaded_file_size • Uploaded",
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    // Success checkmark badge
                                    Container(
                                      width: 20.0,
                                      height: 20.0,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12.0,
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    // Trash Icon to remove file
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFEF4444),
                                        size: 20.0,
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
                        const SizedBox(height: 20.0),
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

// Custom High-Fidelity Calendar Card Dialog matching specifications
class _CustomCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  final bool isDark;
  final AppLocalizations localizations;

  const _CustomCalendarDialog({
    required this.initialDate,
    required this.isDark,
    required this.localizations,
  });

  @override
  State<_CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<_CustomCalendarDialog> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  // Helper to check if a day is the same day
  bool _isSameDay(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Helper to check if it is today
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;
    final AppLocalizations localizations = widget.localizations;

    // Number of days in the month
    final int daysInMonth =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    // Day of the week of the 1st of the month (1 for Monday, 7 for Sunday)
    final int firstDayWeekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

    // Months translation maps
    final List<String> monthsEn = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final List<String> monthsAr = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    final String monthText = localizations.is_arabic
        ? monthsAr[_currentMonth.month - 1]
        : monthsEn[_currentMonth.month - 1];

    final String yearText = "${_currentMonth.year}";

    // Weekdays headers
    final List<String> weekdaysEn = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final List<String> weekdaysAr = ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'];
    final List<String> weekdays =
        localizations.is_arabic ? weekdaysAr : weekdaysEn;

    // Days grid building
    final int offset = firstDayWeekday - 1;
    final int totalCells = daysInMonth + offset;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Container(
        width: 320.0,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface_dark : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12.0,
              spreadRadius: 2.0,
              offset: const Offset(0.0, 4.0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row Header: Month / Year + Navigation Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Month and Year aligned to the left
                Text(
                  "$monthText $yearText",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.text_light_primary,
                  ),
                ),
                // Navigation controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, size: 24.0),
                      color: isDark ? Colors.white54 : Colors.black45,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          int prevMonth = _currentMonth.month - 1;
                          int prevYear = _currentMonth.year;
                          if (prevMonth == 0) {
                            prevMonth = 12;
                            prevYear--;
                          }
                          _currentMonth = DateTime(prevYear, prevMonth);
                        });
                      },
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, size: 24.0),
                      color: isDark ? Colors.white54 : Colors.black45,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          int nextMonth = _currentMonth.month + 1;
                          int nextYear = _currentMonth.year;
                          if (nextMonth == 13) {
                            nextMonth = 1;
                            nextYear++;
                          }
                          _currentMonth = DateTime(nextYear, nextMonth);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Days Header (M T W T F S S)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekdays.map((day) {
                return SizedBox(
                  width: 36.0,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8), // Muted gray typography
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8.0),
            // Days Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalCells,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                if (index < offset) {
                  return const SizedBox.shrink();
                }

                final int dayNum = index - offset + 1;
                final DateTime date =
                    DateTime(_currentMonth.year, _currentMonth.month, dayNum);
                final bool isSelected = _isSameDay(date, _selectedDate);
                final bool isTodayDate = _isToday(date);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primary_color
                          : Colors.transparent,
                      border: isTodayDate && !isSelected
                          ? Border.all(
                              color: AppColors.primary_color, width: 1.0)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary_color
                                    .withValues(alpha: 0.3),
                                blurRadius: 6.0,
                                offset: const Offset(0.0, 2.0),
                              )
                            ]
                          : null,
                    ),
                    child: Text(
                      "$dayNum",
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? Colors.white
                                : AppColors.text_light_primary),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24.0),
            // Footer: Rounded Pill Action Buttons
            Row(
              children: [
                // Left Button: Cancel
                Expanded(
                  child: SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                      child: Text(
                        localizations.is_arabic ? 'إلغاء' : 'Cancel',
                        style: TextStyle(
                          color:
                              isDark ? Colors.white70 : const Color(0xFF475569),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                // Right Button: Done / Confirm
                Expanded(
                  child: SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary_color,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, _selectedDate);
                      },
                      child: Text(
                        localizations.is_arabic ? 'تأكيد' : 'Confirm',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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

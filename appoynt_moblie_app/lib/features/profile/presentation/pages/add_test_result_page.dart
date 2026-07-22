/*
 * File Name: add_test_result_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Defines the upload form screen to attach new diagnostic lab reports or scanning files.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing reusable text field widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';

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
  // Date selection controller
  final TextEditingController _date_controller = TextEditingController();

  // Active category selection type (lab_test / scan)
  late String _active_type;
  // Mock file attachment tracker path
  String _uploaded_file_path = '';

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
    _date_controller.dispose();
    // Call base dispose
    super.dispose();
  }

  // Submit test result attachment form
  void _submit_upload() {
    // Validate form fields using validator triggers
    if (true == _form_key.currentState?.validate()) {
      // Check if document was uploaded using mock path checks
      if (_uploaded_file_path.isEmpty) {
        // Show feedback warning warning message info
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar settings
          const SnackBar(
            // Warning message text
            content: Text('Please upload a document file from your device.'),
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
            );
        // Show success notification message info
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar settings
          const SnackBar(
            // Success label text
            content: Text('Document uploaded successfully.'),
            // Primary color
            backgroundColor: AppColors.primary_color,
          ),
        );
        // Pop upload form screen layout returning back to list screen
        Navigator.of(context).pop();
      }
    } else {
      // Form entries are invalid
    }
  }

  // Draw widget views structures
  @override
  Widget build(BuildContext context) {
    // Resolve localized labels context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // Background colors
      backgroundColor: true == is_dark ? AppColors.background_dark : AppColors.background_light,
      // App bar details
      appBar: AppBar(
        // Center title
        centerTitle: true,
        // Title label text
        title: Text(
          // Add test result title string
          localizations.tests_add_title,
          // Styles
          style: TextStyle(
            // Size standard
            fontSize: AppSpacing.font_size_title,
            // bold weight
            fontWeight: FontWeight.w700,
            // Color parameters
            color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
          ),
        ),
      ),
      // Scrollable view wrapping upload form fields
      body: Form(
        // Bind global key
        key: _form_key,
        // Scrollable area wrapping inputs
        child: Column(
          // Stack vertical layouts
          children: [
            // Expanded inputs list area
            Expanded(
              // SingleChildScrollView protecting boundary lines
              child: SingleChildScrollView(
                // Padding offsets padding margin bounds within borders
                padding: const EdgeInsets.symmetric(
                  // Horizontal offset bounds
                  horizontal: AppSpacing.space_m,
                  // Vertical offset bounds
                  vertical: AppSpacing.space_m,
                ),
                // Column stack grouping inputs
                child: Column(
                  // Align elements start coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list array
                  children: [
                    // Horizontal custom category toggle capsule bar
                    Container(
                      // Height bounds
                      height: AppSpacing.dummy_height_search_bar,
                      // Card decorations
                      decoration: BoxDecoration(
                        // Solid gray default background
                        color: true == is_dark ? AppColors.surface_dark : Colors.grey[100],
                        // Rounded boundaries configurations
                        borderRadius: BorderRadius.circular(
                          // Radius token
                          AppSpacing.radius_xl,
                        ),
                      ),
                      // Row capsule selectors layout options
                      child: Row(
                        // Children options
                        children: [
                          // Lab Tests selector tab option button
                          Expanded(
                            // GestureDetector catching click actions
                            child: GestureDetector(
                              // Select Lab Test tab type on tap
                              onTap: () {
                                // Update active selection type locally
                                setState(() {
                                  // Bind type
                                  _active_type = 'lab_test';
                                });
                              },
                              // Themed capsule background container depending on selection
                              child: Container(
                                // Center content alignment
                                alignment: Alignment.center,
                                // decoration specs
                                decoration: BoxDecoration(
                                  // Solid white background color fill when active
                                  color: 'lab_test' == _active_type
                                      ? (true == is_dark ? AppColors.primary_color : Colors.white)
                                      : Colors.transparent,
                                  // Rounded boundaries corners configurations
                                  borderRadius: BorderRadius.circular(
                                    // Radius token
                                    AppSpacing.radius_xl,
                                  ),
                                ),
                                // Tab label text
                                child: Text(
                                  // Localized Lab Tests label
                                  localizations.tests_tab_lab,
                                  // Style configurations
                                  style: TextStyle(
                                    // Bold indicator
                                    fontWeight: FontWeight.w700,
                                    // Color depending on active tab status
                                    color: 'lab_test' == _active_type
                                        ? (true == is_dark ? Colors.white : AppColors.primary_color)
                                        : AppColors.text_light_secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Scanning selector tab option button
                          Expanded(
                            // GestureDetector catching click actions
                            child: GestureDetector(
                              // Select Scan tab type on tap
                              onTap: () {
                                // Update active selection type locally
                                setState(() {
                                  // Bind type
                                  _active_type = 'scan';
                                });
                              },
                              // Themed capsule background container depending on selection
                              child: Container(
                                // Center content alignment
                                alignment: Alignment.center,
                                // decoration specs
                                decoration: BoxDecoration(
                                  // Solid white background color fill when active
                                  color: 'scan' == _active_type
                                      ? (true == is_dark ? AppColors.primary_color : Colors.white)
                                      : Colors.transparent,
                                  // Rounded boundaries corners configurations
                                  borderRadius: BorderRadius.circular(
                                    // Radius token
                                    AppSpacing.radius_xl,
                                  ),
                                ),
                                // Tab label text
                                child: Text(
                                  // Localized Scanning label
                                  localizations.tests_tab_scanning,
                                  // Style configurations
                                  style: TextStyle(
                                    // Bold indicator
                                    fontWeight: FontWeight.w700,
                                    // Color depending on active tab status
                                    color: 'scan' == _active_type
                                        ? (true == is_dark ? Colors.white : AppColors.primary_color)
                                        : AppColors.text_light_secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Spacing gap
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_xl,
                    ),
                    // Document Name TextFormField input card
                    AuthTextField(
                      label: localizations.tests_doc_name_label,
                      hint: localizations.allergies_placeholder,
                      controller: _name_controller,
                      validator: (value) {
                        if (true == (value ?? '').trim().isEmpty) {
                          return 'Document Name cannot be empty.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // Spacing gap
                    const SizedBox(
                      height: AppSpacing.space_m,
                    ),
                    // Diagnostic execution date TextFormField input card picker
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          height: 50.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                              boxShadow: [
                                BoxShadow(
                                  color: true == is_dark
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
                          readOnly: true,
                          controller: _date_controller,
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_text,
                            color: true == is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                          decoration: InputDecoration(
                            labelText: localizations.tests_date_label,
                            hintText: localizations.tests_select_date_btn,
                            filled: true,
                            fillColor: true == is_dark
                                ? AppColors.surface_dark
                                : AppColors.input_fill,
                            suffixIcon: Icon(
                              Icons.calendar_today_rounded,
                              color: true == is_dark
                                  ? AppColors.text_dark_secondary
                                  : AppColors.text_light_secondary,
                              size: 20.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                              borderSide: BorderSide(
                                color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                                width: AppSpacing.border_width_thin,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                              borderSide: BorderSide(
                                color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                                width: AppSpacing.border_width_thin,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.space_xl,
                              vertical: AppSpacing.padding_input_vertical,
                            ),
                          ),
                          validator: (value) {
                            if (true == (value ?? '').trim().isEmpty) {
                              return 'Please select a date.';
                            } else {
                              return null;
                            }
                          },
                          onTap: () async {
                            final DateTime? selected = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (selected != null && context.mounted) {
                              final String formatted = "${selected.year}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}";
                              _date_controller.text = formatted;
                            }
                          },
                        ),
                      ],
                    ),
                    // Spacing gap
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_m,
                    ),
                    // Upload Document Label display
                    Text(
                      // Localized upload label
                      'Upload Document',
                      // Style typographic parameters options
                      style: TextStyle(
                        // Body standard size
                        fontSize: AppSpacing.font_size_body_medium,
                        // bold weight
                        fontWeight: FontWeight.w700,
                        // Colors
                        color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
                      ),
                    ),
                    // Spacing horizontal separator offset
                    const SizedBox(
                      // Separator height value
                      height: AppSpacing.space_xs,
                    ),
                    // Custom Upload from device button container card displaying green text/borders
                    GestureDetector(
                      // Simulate file choice on tap
                      onTap: () {
                        // Update mock path trigger
                        setState(() {
                          // Bind mockup file path
                          _uploaded_file_path = '/mock/device/upload_doc.pdf';
                        });
                        // Show feedback notification message info
                        ScaffoldMessenger.of(context).showSnackBar(
                          // SnackBar settings
                          const SnackBar(
                            // Message text
                            content: Text('Document file attached from device.'),
                            // Primary color
                            backgroundColor: AppColors.primary_color,
                          ),
                        );
                      },
                      // Outlined container card displaying green outline borders
                      child: Container(
                        // banner width
                        width: double.infinity,
                        // card height
                        height: AppSpacing.dummy_height_search_bar,
                        // Layout decorations details
                        decoration: BoxDecoration(
                          // Solid white or dark surface backgrounds
                          color: true == is_dark ? AppColors.surface_dark : Colors.white,
                          // Rounded border edges configurations
                          borderRadius: BorderRadius.circular(
                            // Circular boundary radius parameter value
                            AppSpacing.radius_m,
                          ),
                          // Primary outline borders
                          border: Border.all(
                            // primary blue brand color
                            color: AppColors.primary_color,
                            // outline borders thickness
                            width: AppSpacing.border_width_thick,
                          ),
                        ),
                        // Center row containing upload icon and label text
                        child: Row(
                          // Align items centered inside container card layout bounds
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Inner elements list
                          children: [
                            // Upload icon graphic asset representation in primary blue
                            const Icon(
                              // upload arrow icon token
                              Icons.file_upload_outlined,
                              // primary blue color
                              color: AppColors.primary_color,
                              // Icon display size bounds
                              size: AppSpacing.icon_size_m,
                            ),
                            // Separator spacing gap
                            const SizedBox(
                              // width spacer
                              width: AppSpacing.space_s,
                            ),
                            // Label description in primary blue
                            Text(
                              // Localized upload action label string
                              localizations.tests_upload_doc_btn,
                              // style
                              style: const TextStyle(
                                // primary blue color
                                color: AppColors.primary_color,
                                // bold weight
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Show mock upload verification check badge if file path is not empty
                    if (_uploaded_file_path.isNotEmpty) ...[
                      // Separator spacing
                      const SizedBox(
                        // Height offset
                        height: AppSpacing.space_s,
                      ),
                      // Text label displaying attached mockup path in green color check indicators
                      Row(
                        // elements
                        children: [
                          // Check badge icon
                          const Icon(
                            // Check icon token
                            Icons.check_circle_outline_rounded,
                            // green color
                            color: AppColors.dummy_custom_green,
                            // size
                            size: AppSpacing.icon_size_s,
                          ),
                          // separator
                          const SizedBox(
                            // width spacer
                            width: AppSpacing.space_xs,
                          ),
                          // attached message
                          Expanded(
                            // text
                            child: Text(
                              // attached filename path
                              'File: ${_uploaded_file_path.split("/").last} attached.',
                              // green style
                              style: const TextStyle(
                                // green color
                                color: AppColors.dummy_custom_green,
                                // small body size
                                fontSize: AppSpacing.font_size_body_small,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Empty lists elements
                      const SizedBox.shrink(),
                    ],
                  ],
                ),
              ),
            ),
            // Primary action submit button representing Confirm Upload trigger
            Padding(
              // Spacing offsets constraints
              padding: const EdgeInsets.symmetric(
                // Horizontal padding
                horizontal: AppSpacing.space_m,
                // Vertical padding
                vertical: AppSpacing.space_m,
              ),
              // Button sized layout wrapper
              child: SizedBox(
                // Full width available
                width: double.infinity,
                // Height dimensions matching standard buttons
                height: AppSpacing.height_auth_button,
                // ElevatedButton
                child: ElevatedButton(
                  // Submit upload results form on click
                  onPressed: _submit_upload,
                  // Style configurations
                  style: ElevatedButton.styleFrom(
                    // primary blue
                    backgroundColor: AppColors.primary_color,
                    // Clear shadows
                    elevation: 0.0,
                    // Curvature shape configurations
                    shape: RoundedRectangleBorder(
                      // Radius parameter value
                      borderRadius: BorderRadius.circular(
                        // standard spacing radius token
                        AppSpacing.radius_l,
                      ),
                    ),
                  ),
                  // Button label
                  child: Text(
                    // Localized submit button label
                    localizations.tests_confirm_upload_btn,
                    // Styles
                    style: const TextStyle(
                      // Color white
                      color: Colors.white,
                      // Size action button font
                      fontSize: AppSpacing.font_size_action_button,
                      // Bold typography weight
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
 * File Name: add_insurance_card_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Defines the upload form screen to attach new health insurance policy cards.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing Cubit controller
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing reusable text field widgets
import 'package:appoynt_mobile_app/core/widgets/auth/auth_widgets.dart';
// Importing insurance card entity
import 'package:appoynt_mobile_app/features/profile/domain/entities/insurance_card.dart';

// Add Insurance Card Page layout stateful widget representation
class AddInsuranceCardPage extends StatefulWidget {
  // Optional edit list index mapping parameter
  final int? edit_index;
  // Optional existing insurance card model if editing
  final InsuranceCard? card_to_edit;

  // Constructor mapping key
  const AddInsuranceCardPage({
    // key parameter
    super.key,
    // edit index value
    this.edit_index,
    // card data to edit
    this.card_to_edit,
  });

  // State builder definition
  @override
  State<AddInsuranceCardPage> createState() {
    // Return state instance representation
    return _AddInsuranceCardPageState();
  }
}

// Concrete state tracker implementation class for the AddInsuranceCardPage
class _AddInsuranceCardPageState extends State<AddInsuranceCardPage> {
  // Global form key validation tracker configuration
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  // Input controllers mapping text entries
  late final TextEditingController _name_controller;
  // Card Number text controller
  late final TextEditingController _number_controller;

  // Selected provider name tracker
  String _selected_provider = '';
  // Mock file attachment tracker path
  String _uploaded_document_path = '';

  // Initialize state configurations pre-filling values if editing
  @override
  void initState() {
    // Call super
    super.initState();
    // Initialize card name controller with existing text or blank
    _name_controller = TextEditingController(
      // Yoda comparison or null check
      text: widget.card_to_edit != null ? widget.card_to_edit!.card_name : '',
    );
    // Initialize policy identifier controller
    _number_controller = TextEditingController(
      // Yoda comparison or null check
      text: widget.card_to_edit != null ? widget.card_to_edit!.card_number : '',
    );
    // Bind selected provider name
    _selected_provider = widget.card_to_edit != null ? widget.card_to_edit!.provider_name : '';
    // Bind uploaded file path details
    _uploaded_document_path = widget.card_to_edit != null ? widget.card_to_edit!.document_path : '';
  }

  // Dispose controllers freeing system resources
  @override
  void dispose() {
    // Dispose text field controllers
    _name_controller.dispose();
    // Dispose number controller
    _number_controller.dispose();
    // Call base dispose
    super.dispose();
  }

  // Show bottom sheet picker select active provider options list matching mockup
  void _show_provider_picker(BuildContext context) {
    // Resolve localized labels context
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Mock providers array list
    const List<String> providers = [
      'MetLife Egypt',
      'AXA Egypt',
      'Bupa Egypt',
      'Allianz Egypt',
    ];

    // Show modal sheet overlay builder
    showModalBottomSheet(
      // Context
      context: context,
      // Builder
      builder: (sheet_context) {
        // Return scrollable list wrapping items
        return Container(
          // Wrap padding margins offsets
          padding: const EdgeInsets.symmetric(
            // Horizontal padding
            horizontal: AppSpacing.space_m,
            // Vertical padding
            vertical: AppSpacing.space_m,
          ),
          // List column stacking options
          child: Column(
            // Auto size height limits
            mainAxisSize: MainAxisSize.min,
            // Align elements start coordinates
            crossAxisAlignment: CrossAxisAlignment.start,
            // children options list
            children: [
              // Bottom sheet title label text
              Text(
                // Localized Select Provider title
                localizations.insurance_select_provider_btn,
                // style
                style: const TextStyle(
                  // Body standard size font
                  fontSize: AppSpacing.font_size_body_medium,
                  // bold weight
                  fontWeight: FontWeight.w700,
                  // Color brand primary blue
                  color: AppColors.primary_color,
                ),
              ),
              // Separator gap
              const SizedBox(
                // Spacing height
                height: AppSpacing.space_m,
              ),
              // List providers choice options maps
              ...providers.map((provider) {
                // Return selection list tile item
                return ListTile(
                  // Content text label
                  title: Text(provider),
                  // Handle click selection closing sheet
                  onTap: () {
                    // Update state selector tracker values
                    setState(() {
                      // Bind choice
                      _selected_provider = provider;
                    });
                    // Pop bottom modal sheet
                    Navigator.of(sheet_context).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Submit insurance policy creation form
  void _submit_insurance() {
    // Validate form fields using validator triggers
    if (true == _form_key.currentState?.validate()) {
      // Check if provider was chosen using check variables
      if (_selected_provider.isEmpty) {
        // Show feedback warning warning message info
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar settings
          const SnackBar(
            // Warning message text
            content: Text('Please select an insurance provider.'),
            // Error background color
            backgroundColor: AppColors.error,
          ),
        );
      } else if (_uploaded_document_path.isEmpty) {
        // Check if document was uploaded
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar settings
          const SnackBar(
            // Warning message text
            content: Text('Please upload insurance documents.'),
            // Error background color
            backgroundColor: AppColors.error,
          ),
        );
      } else {
        // Check if editing or adding using widgets parameters
        if (widget.edit_index != null) {
          // Dispatch updated card parameters to Cubit controller
          context.read<ProfileCubit>().edit_insurance_card(
                // index parameters
                widget.edit_index!,
                // Card Name text
                _name_controller.text,
                // Card Number policy code text
                _number_controller.text,
                // Provider brand name choice
                _selected_provider,
                // attached file path
                _uploaded_document_path,
                // Maintain current expiry date or set mockup default
                widget.card_to_edit?.expiry_date ?? '26 December 2026',
              );
          // Show success notification message info
          ScaffoldMessenger.of(context).showSnackBar(
            // SnackBar settings
            const SnackBar(
              // Success label text
              content: Text('Insurance card updated successfully.'),
              // Primary color
              backgroundColor: AppColors.primary_color,
            ),
          );
        } else {
          // Dispatch insurance policy details to Cubit controller to add new card
          context.read<ProfileCubit>().add_insurance_card(
                // Card Name text
                _name_controller.text,
                // Card Number policy code text
                _number_controller.text,
                // Provider brand name choice
                _selected_provider,
                // attached file path
                _uploaded_document_path,
                // Expiry date mockup (e.g. 1 year from now)
                '26 December 2026',
              );
          // Show success notification message info
          ScaffoldMessenger.of(context).showSnackBar(
            // SnackBar settings
            const SnackBar(
              // Success label text
              content: Text('Insurance card added successfully.'),
              // Primary color
              backgroundColor: AppColors.primary_color,
            ),
          );
        }
        // Pop addition form screen layout returning back to list screen
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
          // Add card title string or Edit title depending on edit status
          widget.edit_index != null ? 'Edit Insurance' : localizations.insurance_add_title,
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
      // Scrollable view wrapping addition form fields
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
                    // Card Name TextFormField input card
                    AuthTextField(
                      label: localizations.insurance_card_name_label,
                      hint: 'e.g., MetLife Executive Plan',
                      controller: _name_controller,
                      validator: (value) {
                        if (true == (value ?? '').trim().isEmpty) {
                          return 'Card Name cannot be empty.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // Spacing gap
                    const SizedBox(
                      height: AppSpacing.space_m,
                    ),
                    // Card Number TextFormField input card
                    AuthTextField(
                      label: localizations.insurance_card_number_label,
                      hint: 'e.g., POL-987654321',
                      controller: _number_controller,
                      validator: (value) {
                        if (true == (value ?? '').trim().isEmpty) {
                          return 'Card Number cannot be empty.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    // Spacing gap
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_m,
                    ),
                    // Select Provider Label display
                    Text(
                      // Localized Select Provider title
                      localizations.insurance_select_provider_btn,
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
                    // Select Provider dropdown container picker
                    GestureDetector(
                      // Launch provider bottom sheet on tap
                      onTap: () {
                        // Show picker sheet
                        _show_provider_picker(context);
                      },
                      // Outlined container card displaying dropdown field styling
                      child: Container(
                        // banner width
                        width: double.infinity,
                        // card height
                        height: AppSpacing.dummy_height_search_bar,
                        // Layout decorations details
                        decoration: BoxDecoration(
                          // Solid white or dark surface backgrounds
                          color: true == is_dark ? AppColors.surface_dark : Colors.white,
                          // Rounded border edges configurations (12px radius)
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radius_input,
                          ),
                          // Subtle 1px neutral border
                          border: Border.all(
                            color: true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
                            width: AppSpacing.border_width_thin,
                          ),
                        ),
                        // Row containing chosen provider name and trailing chevron
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_m),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selected_provider.isEmpty ? 'Select Insurance Provider' : _selected_provider,
                                style: TextStyle(
                                  color: _selected_provider.isEmpty
                                      ? AppColors.text_light_secondary
                                      : (true == is_dark ? Colors.white : AppColors.text_light_primary),
                                  fontSize: AppSpacing.font_size_text,
                                  fontWeight: _selected_provider.isEmpty ? FontWeight.w400 : FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: true == is_dark ? Colors.white60 : const Color(0xFF64748B),
                                size: AppSpacing.icon_size_m,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Spacing gap
                    const SizedBox(
                      // Spacing height
                      height: AppSpacing.space_m,
                    ),
                    // Upload Insurance documents Label display
                    Text(
                      // Localized upload label
                      'Upload Insurance Documents',
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
                    // Neutral slate-gray upload document button
                    GestureDetector(
                      // Simulate file choice on tap
                      onTap: () {
                        // Update mock path trigger
                        setState(() {
                          // Bind mockup file path
                          _uploaded_document_path = '/mock/device/upload_insurance_card.pdf';
                        });
                        // Show feedback notification message info
                        ScaffoldMessenger.of(context).showSnackBar(
                          // SnackBar settings
                          const SnackBar(
                            // Message text
                            content: Text('Insurance document file attached from device.'),
                            // Primary color
                            backgroundColor: AppColors.primary_color,
                          ),
                        );
                      },
                      // Neutral slate-gray border outline
                      child: Container(
                        // banner width
                        width: double.infinity,
                        // card height
                        height: AppSpacing.dummy_height_search_bar,
                        // Layout decorations details
                        decoration: BoxDecoration(
                          // Solid white or dark surface backgrounds
                          color: true == is_dark ? AppColors.surface_dark : const Color(0xFFF8FAFC),
                          // Rounded border edges configurations
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radius_input,
                          ),
                          // Neutral slate-gray outline border
                          border: Border.all(
                            color: true == is_dark ? AppColors.border_dark : const Color(0xFFE2E8F0),
                            width: AppSpacing.border_width_thin,
                          ),
                        ),
                        // Center row containing upload icon and label text
                        child: Row(
                          // Align items centered inside container card layout bounds
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Inner elements list
                          children: [
                            // Upload icon graphic representation in slate-gray
                            Icon(
                              Icons.file_upload_outlined,
                              color: true == is_dark ? Colors.white70 : const Color(0xFF475569),
                              size: AppSpacing.icon_size_m,
                            ),
                            // Separator spacing gap
                            const SizedBox(
                              width: AppSpacing.space_s,
                            ),
                            // Label description in slate-gray
                            Text(
                              localizations.insurance_upload_doc_btn,
                              style: TextStyle(
                                color: true == is_dark ? Colors.white70 : const Color(0xFF475569),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Show mock upload verification check badge if file path is not empty
                    if (_uploaded_document_path.isNotEmpty) ...[
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
                              'File: ${_uploaded_document_path.split("/").last} attached.',
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
            // Primary action submit button representing Add Card trigger
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
                  // Submit insurance card results form on click
                  onPressed: _submit_insurance,
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
                    // Localized submit button label or Edit button label depending on status
                    widget.edit_index != null ? 'Save Changes' : localizations.insurance_add_card_btn,
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

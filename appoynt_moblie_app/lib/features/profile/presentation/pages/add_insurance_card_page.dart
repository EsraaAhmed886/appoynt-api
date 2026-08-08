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

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_sheet = 24.0;
}

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

    // Attach listeners for dynamic form validity updates
    _name_controller.addListener(_on_form_changed);
    _number_controller.addListener(_on_form_changed);
  }

  // Listener callback triggering setState on form changes
  void _on_form_changed() {
    setState(() {});
  }

  // Getter evaluating full form validity state
  bool get _is_form_valid {
    return _name_controller.text.trim().isNotEmpty &&
        _number_controller.text.trim().isNotEmpty &&
        _selected_provider.isNotEmpty &&
        _uploaded_document_path.isNotEmpty;
  }

  // Dispose controllers freeing system resources
  @override
  void dispose() {
    // Remove form change listeners
    _name_controller.removeListener(_on_form_changed);
    _number_controller.removeListener(_on_form_changed);
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

    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Show modal sheet overlay builder
    showModalBottomSheet(
      // Context
      context: context,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.barrier_color,
      // Builder
      builder: (sheet_context) {
        // Return scrollable list wrapping items
        return Container(
          decoration: BoxDecoration(
            color: is_dark ? AppColors.surface_dark : AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(_LocalDimensions.border_radius_sheet),
            ),
          ),
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
        // Show feedback warning message info
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an insurance provider.'),
            backgroundColor: AppColors.error,
          ),
        );
      } else if (_uploaded_document_path.isEmpty) {
        // Check if document was uploaded
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload insurance documents.'),
            backgroundColor: AppColors.error,
          ),
        );
      } else {
        // Check if editing or adding using widgets parameters
        if (widget.edit_index != null) {
          // Dispatch updated card parameters to Cubit controller
          context.read<ProfileCubit>().edit_insurance_card(
                widget.edit_index!,
                _name_controller.text,
                _number_controller.text,
                _selected_provider,
                _uploaded_document_path,
                widget.card_to_edit?.expiry_date ?? '26 December 2026',
              );
          // Show success notification message info
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Insurance card updated successfully.'),
              backgroundColor: AppColors.primary_color,
            ),
          );
        } else {
          // Dispatch insurance policy details to Cubit controller to add new card
          context.read<ProfileCubit>().add_insurance_card(
                _name_controller.text,
                _number_controller.text,
                _selected_provider,
                _uploaded_document_path,
                '26 December 2026',
              );
          // Show success notification message info
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Insurance card added successfully.'),
              backgroundColor: AppColors.primary_color,
            ),
          );
        }
        // Pop addition form screen layout returning back to list screen
        Navigator.of(context).pop();
      }
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
      // Fixed sticky bottom action bar containing full-width CTA button
      bottomNavigationBar: StickyBottomBar(
        child: SizedBox(
          width: double.infinity,
          height: AppSpacing.height_auth_button,
          child: ElevatedButton(
            // Enable button only when form is completely valid
            onPressed: true == _is_form_valid ? _submit_insurance : null,
            style: ElevatedButton.styleFrom(
              // Vibrant blue when enabled, muted gray when disabled (#E2E8F0)
              backgroundColor: true == _is_form_valid
                  ? AppColors.primary_color
                  : AppColors.slate_200,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radius_l),
              ),
            ),
            child: Text(
              // Localized "Save Card" action button text label
              localizations.insurance_save_card_btn,
              style: TextStyle(
                // White text when enabled, muted gray text when disabled
                color: true == _is_form_valid ? AppColors.white : AppColors.slate_400,
                fontSize: AppSpacing.font_size_action_button,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
      // Body wrapped in SafeArea and strict 16px lateral padding
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          child: Form(
            key: _form_key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.space_xl),
                // Standardized Squircle Back Button AppBar component
                CustomProfileAppBar(
                  title: widget.edit_index != null
                      ? 'Edit Insurance'
                      : localizations.insurance_add_title,
                ),
                const SizedBox(height: AppSpacing.space_l),
                // Form fields wrapped in SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Name TextFormField input field
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
                        const SizedBox(height: AppSpacing.space_m),
                        // Card Number TextFormField input field
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
                        const SizedBox(height: AppSpacing.space_m),
                        // Select Provider Label display
                        Text(
                          localizations.insurance_select_provider_btn,
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.w700,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space_xs),
                        // Select Provider dropdown container picker
                        GestureDetector(
                          onTap: () {
                            _show_provider_picker(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: AppSpacing.dummy_height_search_bar,
                            decoration: BoxDecoration(
                              color: is_dark
                                  ? AppColors.surface_dark
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radius_input,
                              ),
                              border: Border.all(
                                color: is_dark
                                    ? AppColors.border_dark
                                    : AppColors.slate_200,
                                width: AppSpacing.border_width_thin,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.space_m),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selected_provider.isEmpty
                                        ? 'Select Insurance Provider'
                                        : _selected_provider,
                                    style: TextStyle(
                                      color: _selected_provider.isEmpty
                                          ? AppColors.text_light_secondary
                                          : (is_dark
                                              ? AppColors.white
                                              : AppColors.text_light_primary),
                                      fontSize: AppSpacing.font_size_text,
                                      fontWeight: _selected_provider.isEmpty
                                          ? FontWeight.w400
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: is_dark
                                        ? AppColors.white60
                                        : AppColors.slate_500,
                                    size: AppSpacing.icon_size_m,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space_m),
                        // Upload Insurance documents Label display
                        Text(
                          'Upload Insurance Documents',
                          style: TextStyle(
                            fontSize: AppSpacing.font_size_body_medium,
                            fontWeight: FontWeight.w700,
                            color: is_dark
                                ? AppColors.text_dark_primary
                                : AppColors.text_light_primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space_xs),
                        // Neutral slate-gray upload document button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _uploaded_document_path =
                                  '/mock/device/upload_insurance_card.pdf';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Insurance document file attached from device.'),
                                backgroundColor: AppColors.primary_color,
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: AppSpacing.dummy_height_search_bar,
                            decoration: BoxDecoration(
                              color: is_dark
                                  ? AppColors.surface_dark
                                  : AppColors.slate_50,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radius_input,
                              ),
                              border: Border.all(
                                color: is_dark
                                    ? AppColors.border_dark
                                    : AppColors.slate_200,
                                width: AppSpacing.border_width_thin,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_upload_outlined,
                                  color: is_dark
                                      ? AppColors.white70
                                      : AppColors.slate_600,
                                  size: AppSpacing.icon_size_m,
                                ),
                                const SizedBox(width: AppSpacing.space_s),
                                Text(
                                  localizations.insurance_upload_doc_btn,
                                  style: TextStyle(
                                    color: is_dark
                                        ? AppColors.white70
                                        : AppColors.slate_600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_uploaded_document_path.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.space_s),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppColors.dummy_custom_green,
                                size: AppSpacing.icon_size_s,
                              ),
                              const SizedBox(width: AppSpacing.space_xs),
                              Expanded(
                                child: Text(
                                  'File: ${_uploaded_document_path.split("/").last} attached.',
                                  style: const TextStyle(
                                    color: AppColors.dummy_custom_green,
                                    fontSize: AppSpacing.font_size_body_small,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: AppSpacing.space_xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

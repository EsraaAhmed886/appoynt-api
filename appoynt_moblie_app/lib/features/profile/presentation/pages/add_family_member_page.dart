/*
 * File Name: add_family_member_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Dedicated full-screen sub-page layout to register and add a new family dependent profile.
 */

// Importing global route export barrel configuration
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing custom date picker
import 'package:appoynt_mobile_app/core/widgets/app_date_picker.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_medium = 12.0;
  static const double border_radius_large = 20.0;
  static const double border_width_thick = 1.5;
  static const double border_width_thin = 1.0;
  static const double border_width_half = 0.5;
  static const double button_height = 50.0;
  static const double choice_chip_height = 38.0;
  static const double spacing_small = 6.0;
  static const double font_size_body = 14.0;
  static const double font_size_medium = 13.0;
  static const double font_size_small = 12.0;
  static const double font_size_tiny = 11.0;
  static const double icon_size_small = 18.0;
  static const double shadow_blur = 10.0;
  static const double shadow_offset_y = 4.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.03;
  static const double choice_chip_padding_h = 2.0;
  static const double input_padding = 10.0;
  static const double bottom_spacing_safe = 80.0;
}

// Stateful widget representing the full screen Add Family Member page
class AddFamilyMemberPage extends StatefulWidget {
  // Optional family member data for edit mode
  final Map<String, dynamic>? member;

  // Constructor mapping key
  const AddFamilyMemberPage({
    super.key,
    this.member,
  });

  @override
  // Create state tracker instance
  State<AddFamilyMemberPage> createState() {
    // Return state class instance
    return _AddFamilyMemberPageState();
  }
}

// State class managing demographic selections and form inputs
class _AddFamilyMemberPageState extends State<AddFamilyMemberPage> {
  // Global key to track form state validations
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  // Controller managing full name input value
  final TextEditingController _name_controller = TextEditingController();
  // Controller managing Date of Birth input value
  final TextEditingController _dob_controller = TextEditingController();
  // Controller managing medical tags input value
  final TextEditingController _medical_tags_controller =
      TextEditingController();

  // Selected relationship value defaulting to Son
  String _selected_relationship = 'Son';
  // Selected gender value defaulting to Male
  String _selected_gender = 'Male';

  @override
  void initState() {
    super.initState();
    // Pre-populate form controllers and state tracking fields if in Edit Mode (Yoda style check)
    if (null != widget.member) {
      final Map<String, dynamic> member = widget.member!;
      _name_controller.text = member['name'] as String? ?? '';
      _dob_controller.text = member['dob'] as String? ?? '';
      _selected_gender = member['gender'] as String? ?? 'Male';
      _selected_relationship = member['relationship'] as String? ?? 'Son';
    } else {
      // Empty block
    }
  }

  @override
  // Clean resources on dispose
  void dispose() {
    // Clean name controller
    _name_controller.dispose();
    // Clean date of birth controller
    _dob_controller.dispose();
    // Clean medical tags controller
    _medical_tags_controller.dispose();
    // Invoke super dispose
    super.dispose();
  }

  @override
  // Draw full screen layout widget tree
  Widget build(BuildContext context) {
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve localization dictionary helper
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_edit = null != widget.member;

    // Resolve dynamic page title copy
    final String page_title = is_edit
        ? localizations.add_member_edit_title
        : localizations.add_member_add_title;

    // Resolve dynamic button label copy
    final String cta_label = is_edit
        ? localizations.add_member_update_btn
        : localizations.add_member_save_btn;

    // Return root Scaffold container
    return Scaffold(
      bottomNavigationBar: StickyBottomBar(
        child: SizedBox(
          width: double.infinity,
          height: _LocalDimensions.button_height,
          child: ElevatedButton(
            // Trigger validations and pop context route on tap
            onPressed: () {
              // Perform form validations check
              if (true == _form_key.currentState?.validate()) {
                // Pop back to Medical History Screen
                Navigator.of(context).pop();
                // Show floating successfully saved snackbar message
                CustomSnackBar.success(
                  context,
                  localizations.add_member_success_toast,
                );
              } else {
                // Form validation failed
              }
            },
            // Button style properties
            style: ElevatedButton.styleFrom(
              // Accent primary background color
              backgroundColor: AppColors.primary_color,
              // Curved radius shape
              shape: RoundedRectangleBorder(
                // Rounded corner radius
                borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              ),
            ),
            // Bold button label text widget
            child: Text(
              // CTA Label
              cta_label,
              // Typographic style configurations
              style: const TextStyle(
                // White colors
                color: AppColors.white,
                // Bold label indicators
                fontWeight: FontWeight.bold,
                // Size
                fontSize: _LocalDimensions.font_size_body,
              ),
            ),
          ),
        ),
      ),
      // Scaffold body element
      body: SafeArea(
        // Single child scroll wrapper to prevent keyboard layout overflow issues
        child: SingleChildScrollView(
          // Scroll padding boundaries
          child: Padding(
            // Margins space
            padding: const EdgeInsets.only(
              left: AppSpacing.space_xl,
              right: AppSpacing.space_xl,
              top: AppSpacing.space_xl,
              bottom: AppSpacing.space_m,
            ),
            // Form layout wrapper
            child: Form(
              // Bind global key validator
              key: _form_key,
              // Stacking columns layout
              child: Column(
                // Align left coordinates
                crossAxisAlignment: CrossAxisAlignment.start,
                // children lists
                children: [
                  // Custom back chevron navigation row
                  CustomProfileAppBar(
                    title: page_title,
                  ),
                  // Spacing gap height
                  const SizedBox(height: AppSpacing.space_xl),

                  // BLOCK A: Identity Card Container
                  Container(
                    // Full width fill
                    width: double.infinity,
                    // Spacing bounds padding inside card block
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                      vertical: AppSpacing.space_l,
                    ),
                    // Decoration layouts details
                    decoration: BoxDecoration(
                      // Color
                      color: is_dark
                          ? AppColors.surface_dark
                          : AppColors.white,
                      // Corner curvature matching radius tokens
                      borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                      // Drop shadows
                      boxShadow: [
                        // Soft card shadow
                        BoxShadow(
                          // Color
                          color: is_dark
                              ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                              : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                          // Blur
                          blurRadius: _LocalDimensions.shadow_blur,
                          // Offsets
                          offset: const Offset(0.0, _LocalDimensions.shadow_offset_y),
                        ),
                      ],
                      // Border boundary outline
                      border: Border.all(
                        // Colors
                        color: is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light.withValues(alpha: _LocalDimensions.border_width_half),
                        // Thickness
                        width: AppSpacing.border_width_thin,
                      ),
                    ),
                    // Identity input columns
                    child: Column(
                      // Align left coordinates
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // children
                      children: [
                        // Card header title
                        Text(
                          // Block label title
                          localizations.add_member_identity_details_header,
                          // Typographic options
                          style: TextStyle(
                            // Size
                            fontSize: _LocalDimensions.font_size_medium,
                            // Bold indicators
                            fontWeight: FontWeight.bold,
                            // Muted text colors
                            color: is_dark
                                ? AppColors.white70
                                : AppColors.text_light_secondary,
                          ),
                        ),
                        // Spacing gap height
                        const SizedBox(height: AppSpacing.space_l),
                        // Full Name Input text field with floating Material 3 labels
                        TextFormField(
                          // Bind controller
                          controller: _name_controller,
                          // Styling
                          style: TextStyle(
                            // Color
                            color: is_dark
                                ? AppColors.white
                                : AppColors.text_light_primary,
                          ),
                          // Decoration parameters
                          decoration: InputDecoration(
                            // Floating label text
                            labelText: localizations.add_member_full_name_label,
                            // Label style
                            labelStyle: TextStyle(
                              // Muted colors
                              color: is_dark
                                  ? AppColors.white54
                                  : AppColors.text_light_secondary,
                            ),
                            // Placeholders hint
                            hintText: localizations.add_member_full_name_hint,
                            // Style
                            hintStyle: const TextStyle(color: AppColors.grey),
                            // Prefix person outline icon
                            prefixIcon: const Icon(Icons.person_outline_rounded,
                                color: AppColors.primary_color),
                            // Color fills parameters
                            filled: true,
                            // Fill background colors
                            fillColor: is_dark
                                ? AppColors.black12
                                : AppColors.input_fill,
                            // Boundary outline borders
                            border: OutlineInputBorder(
                              // Radius
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radius_l),
                              // No borders
                              borderSide: BorderSide.none,
                            ),
                          ),
                          // Validation callback
                          validator: (val) {
                            // Check if blank
                            if (null == val || val.trim().isEmpty) {
                              // Validation error
                              return localizations.add_member_name_empty_error;
                            } else if (val.trim().length < 3) {
                              // Too short error message
                              return localizations.add_member_name_short_error;
                            } else {
                              // Return null if valid
                              return null;
                            }
                          },
                        ),
                        // Spacing gap height
                        const SizedBox(height: AppSpacing.space_l),
                        // Relationship Label Text widget
                        Text(
                          // Label text
                          localizations.add_member_relationship_header,
                          // Typographic options
                          style: TextStyle(
                            // Small font size
                            fontSize: _LocalDimensions.font_size_tiny,
                            // Color adaptions
                            color: is_dark
                                ? AppColors.white70
                                : AppColors.text_light_secondary,
                          ),
                        ),
                        // Spacer gap
                        const SizedBox(height: _LocalDimensions.spacing_small),
                        // Segmented relationship selector buttons row
                        Row(
                          // children list mapping selection values
                          children: ['Son', 'Daughter', 'Spouse', 'Parent']
                              .map((rel) {
                            // Localize relationship display text
                            final String display_text = 'Son' == rel
                                ? localizations.rel_son
                                : ('Daughter' == rel
                                    ? localizations.rel_daughter
                                    : ('Spouse' == rel
                                        ? localizations.rel_spouse
                                        : localizations.rel_parent));
                            // Selected state check using Yoda condition comparison
                            final bool is_selected =
                                rel == _selected_relationship;
                            // Segment item button layout wrapper
                            return Expanded(
                              // Tappable selector bounds
                              child: GestureDetector(
                                // Update selection index state on tap
                                onTap: () {
                                  // Rebuild state parameters
                                  setState(() {
                                    // Update relationship tracker
                                    _selected_relationship = rel;
                                  });
                                },
                                // Container item styling
                                child: Container(
                                  // Height constraints
                                  height: _LocalDimensions.choice_chip_height,
                                  // Centered text
                                  alignment: Alignment.center,
                                  // Margins offset spacing
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: _LocalDimensions.choice_chip_padding_h),
                                  // Decoration properties
                                  decoration: BoxDecoration(
                                    // Active solid blue color or inactive background fills
                                    color: is_selected
                                        ? AppColors.primary_color
                                        : (is_dark
                                            ? AppColors.black12
                                            : AppColors.input_fill),
                                    // Rounded borders matching design tokens radius
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radius_m),
                                    // Borders outline line
                                    border: Border.all(
                                      // Active blue outline or default borders
                                      color: is_selected
                                          ? AppColors.primary_color
                                          : (is_dark
                                              ? AppColors.border_dark
                                              : AppColors.border_light),
                                      // Thin outline size
                                      width: _LocalDimensions.border_width_thin,
                                    ),
                                  ),
                                  // Relationship label text widget
                                  child: Text(
                                    // Bind relationship text value
                                    display_text,
                                    // Styles options
                                    style: TextStyle(
                                      // Small font sizes
                                      fontSize: _LocalDimensions.font_size_tiny,
                                      // Bold indicator if active selected state
                                      fontWeight: is_selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      // White color if active, or default primary text color
                                      color: is_selected
                                          ? AppColors.white
                                          : (is_dark
                                              ? AppColors.white70
                                              : AppColors.text_light_primary),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            // Convert to List
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  // Spacing gap height between card block sections
                  const SizedBox(height: AppSpacing.space_l),

                  // BLOCK B: Demographics Card Container
                  Container(
                    // Full width fill
                    width: double.infinity,
                    // Spacing bounds padding inside card block
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                      vertical: AppSpacing.space_l,
                    ),
                    // Decoration details
                    decoration: BoxDecoration(
                      // Colors surface adaptions
                      color: is_dark
                          ? AppColors.surface_dark
                          : AppColors.white,
                      // Radius corner shape
                      borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                      // Drop shadows
                      boxShadow: [
                        // Soft card shadow
                        BoxShadow(
                          // Color
                          color: is_dark
                              ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                              : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                          // Blur spreads
                          blurRadius: _LocalDimensions.shadow_blur,
                        ),
                      ],
                      // Outline borders
                      border: Border.all(
                        // Border colors
                        color: is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light.withValues(alpha: _LocalDimensions.border_width_half),
                        // Thickness
                        width: AppSpacing.border_width_thin,
                      ),
                    ),
                    // Demographics row layouts (Split 50/50 horizontal layouts)
                    child: Row(
                      // Align elements
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // children
                      children: [
                        // Date of Birth calendar input field column layout block
                        Expanded(
                          // Column
                          child: Column(
                            // Align left
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // children
                            children: [
                              // Text label
                              Text(
                                // Date of birth label
                                localizations.add_member_dob_header,
                                // Typographic specs
                                style: TextStyle(
                                  // Size
                                  fontSize: _LocalDimensions.font_size_tiny,
                                  // Muted colors
                                  color: is_dark
                                      ? AppColors.white70
                                      : AppColors.text_light_secondary,
                                ),
                              ),
                              // Spacer gap height
                              const SizedBox(height: _LocalDimensions.spacing_small),
                              // DOB input text field
                              TextFormField(
                                // Bind controller
                                controller: _dob_controller,
                                // Read-only parameters to prevent manual inputs
                                readOnly: true,
                                // Styles
                                style: TextStyle(
                                  // Colors
                                  color: is_dark
                                      ? AppColors.white
                                      : AppColors.text_light_primary,
                                ),
                                // Input decorations
                                decoration: InputDecoration(
                                  // Placeholder hints
                                  hintText: localizations.add_member_dob_hint,
                                  // Hint style
                                  hintStyle: const TextStyle(
                                      color: AppColors.grey, fontSize: _LocalDimensions.font_size_small),
                                  // Prefix calendar icon graphic representation
                                  prefixIcon: const Icon(
                                      Icons.calendar_month_outlined,
                                      color: AppColors.primary_color,
                                      size: _LocalDimensions.icon_size_small),
                                  // Color fills parameters
                                  filled: true,
                                  // Fill background colors
                                  fillColor: is_dark
                                      ? AppColors.black12
                                      : AppColors.input_fill,
                                  // Inner input field content padding
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: _LocalDimensions.input_padding, vertical: _LocalDimensions.input_padding),
                                  // Outline borders
                                  border: OutlineInputBorder(
                                    // Radius
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radius_l),
                                    // No borders
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                // Date picker trigger onTap
                                onTap: () async {
                                  // Resolve showAppDatePicker future using Yoda comparisons and correct limits
                                  final DateTime? picked_date =
                                      await showAppDatePicker(
                                    // Bind context
                                    context: context,
                                    // Starting default date
                                    initialDate: DateTime.now(),
                                    // Earliest limits
                                    firstDate: DateTime(1900),
                                    // Latest limits
                                    lastDate: DateTime.now(),
                                  );
                                  // Check if picked
                                  if (null != picked_date) {
                                    // Format string representation
                                    final String formatted =
                                        '${picked_date.day}/${picked_date.month}/${picked_date.year}';
                                    // Trigger layout state update
                                    setState(() {
                                      // Set controller text value
                                      _dob_controller.text = formatted;
                                    });
                                  } else {
                                    // Date picker cancelled
                                  }
                                },
                                // Validation logic
                                validator: (val) {
                                  // Required check
                                  if (null == val || val.trim().isEmpty) {
                                    // Validation error
                                    return localizations.add_member_required_error;
                                  } else {
                                    // Return null if valid
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        // Spacing gap width between split columns
                        const SizedBox(width: AppSpacing.space_xl),
                        // Gender Option Selection pills column layout block
                        Expanded(
                          // Column
                          child: Column(
                            // Align left
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // children
                            children: [
                              // Text label
                              Text(
                                // Gender label
                                localizations.add_member_gender_header,
                                // Typographic style specs
                                style: TextStyle(
                                  // Size
                                  fontSize: _LocalDimensions.font_size_tiny,
                                  // Muted colors adaptions
                                  color: is_dark
                                      ? AppColors.white70
                                      : AppColors.text_light_secondary,
                                ),
                              ),
                              // Spacer gap height
                              const SizedBox(height: _LocalDimensions.spacing_small),
                              // Fluid premium clickable option pills row
                              Row(
                                // children
                                children: ['Male', 'Female'].map((gen) {
                                  // Localize gender display text
                                  final String display_text = 'Male' == gen
                                      ? localizations.gender_male
                                      : localizations.gender_female;
                                  // Selected state check using Yoda comparison
                                  final bool is_selected =
                                      gen == _selected_gender;
                                  // Expanded tap capsule wrapper
                                  return Expanded(
                                    // Tappable detector bounds
                                    child: GestureDetector(
                                      // Update gender value on tap
                                      onTap: () {
                                        // Trigger state rebuild
                                        setState(() {
                                          // Update gender tracker
                                          _selected_gender = gen;
                                        });
                                      },
                                      // Capsule container styling
                                      child: Container(
                                        // Height constraints
                                        height: _LocalDimensions.choice_chip_height,
                                        // Centered text
                                        alignment: Alignment.center,
                                        // Margins bounds spacer
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: _LocalDimensions.choice_chip_padding_h),
                                        // Decoration options
                                        decoration: BoxDecoration(
                                          // Active primary blue color fill or default inactive background
                                          color: is_selected
                                              ? AppColors.primary_color
                                              : (is_dark
                                                  ? AppColors.black12
                                                  : AppColors.input_fill),
                                          // Capsule rounded shape (20px radius)
                                          borderRadius:
                                              BorderRadius.circular(_LocalDimensions.border_radius_large),
                                          // Outline borders
                                          border: Border.all(
                                            // Selected primary blue color border or default boundary lines
                                            color: is_selected
                                                ? AppColors.primary_color
                                                : (is_dark
                                                    ? AppColors.border_dark
                                                    : AppColors.border_light),
                                            // Thin border line thickness
                                            width: _LocalDimensions.border_width_thin,
                                          ),
                                        ),
                                        // Gender text label widget
                                        child: Text(
                                          // Bind gender text value
                                          display_text,
                                          // Styles options
                                          style: TextStyle(
                                            // Size
                                            fontSize: _LocalDimensions.font_size_tiny,
                                            // Bold weight if active selection
                                            fontWeight: is_selected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            // White color if active, or default primary text color
                                            color: is_selected
                                                ? AppColors.white
                                                : (is_dark
                                                    ? AppColors.white70
                                                    : AppColors.text_light_primary),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  // Convert list elements
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacing gap height between card block sections
                  const SizedBox(height: AppSpacing.space_l),

                  // BLOCK C: Critical Medical Background Card Container
                  Container(
                    // Full width fill
                    width: double.infinity,
                    // Spacing bounds padding inside card block
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space_xl,
                      vertical: AppSpacing.space_l,
                    ),
                    // Decoration details
                    decoration: BoxDecoration(
                      // Colors surface adaptions
                      color: is_dark
                          ? AppColors.surface_dark
                          : AppColors.white,
                      // Rounded corner radius shape
                      borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                      // Drop shadows
                      boxShadow: [
                        // Soft card shadow
                        BoxShadow(
                          // Color
                          color: is_dark
                              ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                              : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                          // Spread blur
                          blurRadius: _LocalDimensions.shadow_blur,
                        ),
                      ],
                      // Outline borders
                      border: Border.all(
                        // Colors
                        color: is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light.withValues(alpha: _LocalDimensions.border_width_half),
                        // Thickness
                        width: AppSpacing.border_width_thin,
                      ),
                    ),
                    // Background inputs columns
                    child: Column(
                      // Align left coordinates
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // children
                      children: [
                        // Card header title
                        Text(
                          // Block title label
                          localizations.add_member_medical_bg_header,
                          // Typographic options
                          style: TextStyle(
                            // Size
                            fontSize: _LocalDimensions.font_size_medium,
                            // Bold indicators
                            fontWeight: FontWeight.bold,
                            // Subdued colors
                            color: is_dark
                                ? AppColors.white70
                                : AppColors.text_light_secondary,
                          ),
                        ),
                        // Spacing gap height
                        const SizedBox(height: AppSpacing.space_l),
                        // Spacious multiline text area for critical medical tags/background
                        TextFormField(
                          // Bind controller
                          controller: _medical_tags_controller,
                          // Spacious multiline heights parameter
                          maxLines: 5,
                          // Text style options
                          style: TextStyle(
                            // Color
                            color: is_dark
                                ? AppColors.white
                                : AppColors.text_light_primary,
                          ),
                          // Input decoration configurations
                          decoration: InputDecoration(
                            // Floating label text
                            labelText:
                                localizations.add_member_medical_bg_label,
                            // Label text style
                            labelStyle: TextStyle(
                              // Muted colors
                              color: is_dark
                                  ? AppColors.white54
                                  : AppColors.text_light_secondary,
                            ),
                            // Placeholder instructions hint
                            hintText:
                                localizations.add_member_medical_bg_hint,
                            // Hint style
                            hintStyle: const TextStyle(
                                color: AppColors.grey, fontSize: _LocalDimensions.font_size_medium),
                            // Color fills parameters
                            filled: true,
                            // Fill background colors
                            fillColor: is_dark
                                ? AppColors.black12
                                : AppColors.input_fill,
                            // Outline borders
                            border: OutlineInputBorder(
                              // Radius
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radius_l),
                              // No border outline lines
                              borderSide: BorderSide.none,
                            ),
                            // Focused state border line
                            focusedBorder: OutlineInputBorder(
                              // Radius
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radius_l),
                              // Active blue outline accent boundary line
                              borderSide: const BorderSide(
                                  color: AppColors.primary_color, width: _LocalDimensions.border_width_thick),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: _LocalDimensions.bottom_spacing_safe),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

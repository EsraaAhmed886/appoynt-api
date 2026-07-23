/*
 * File Name: add_family_member_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/07/2026]
 * File Description: Dedicated full-screen sub-page layout to register and add a new family dependent profile.
 */

// Importing global route export barrel configuration
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Stateful widget representing the full screen Add Family Member page
class AddFamilyMemberPage extends StatefulWidget {
  // Constructor mapping key
  const AddFamilyMemberPage({super.key});

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
  final TextEditingController _medical_tags_controller = TextEditingController();

  // Selected relationship value defaulting to Son
  String _selected_relationship = 'Son';
  // Selected gender value defaulting to Male
  String _selected_gender = 'Male';

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

    // Return root Scaffold container
    return Scaffold(
      // Dynamic background surface colors
      backgroundColor: true == is_dark
          ? AppColors.background_dark
          : AppColors.surface_light.withValues(alpha: 0.5),
      // Sticky bottom navigation bar for the Save Profile button
      bottomNavigationBar: SafeArea(
        // Sticky container wrapper
        child: Container(
          // Border outline spacing
          padding: const EdgeInsets.all(AppSpacing.space_xl),
          // Decoration details
          decoration: BoxDecoration(
            // Matching dark/light background styles
            color: true == is_dark ? AppColors.surface_dark : Colors.white,
            // Thin top border outline line separation
            border: Border(
              top: BorderSide(
                color: true == is_dark
                    ? AppColors.border_dark
                    : AppColors.border_light.withValues(alpha: 0.5),
                width: AppSpacing.border_width_thin,
              ),
            ),
          ),
          // Prominent Save Profile CTA button
          child: ElevatedButton(
            // Trigger validations and pop context route on tap
            onPressed: () {
              // Perform form validations check
              if (true == _form_key.currentState?.validate()) {
                // Pop back to Medical History Screen
                Navigator.of(context).pop();
                // Show successfully saved toast message
                ScaffoldMessenger.of(context).showSnackBar(
                  // SnackBar configs
                  const SnackBar(
                    // Label text content
                    content: Text('Saved Member Profile successfully.'),
                    // Primary blue success color tint
                    backgroundColor: AppColors.primary_color,
                  ),
                );
              }
            },
            // Button style properties
            style: ElevatedButton.styleFrom(
              // Accent primary background color
              backgroundColor: AppColors.primary_color,
              // Fixed heights constraints matching auth button tokens
              minimumSize: const Size(double.infinity, 50.0),
              // Curved radius shape
              shape: RoundedRectangleBorder(
                // Rounded corner radius
                borderRadius: BorderRadius.circular(AppSpacing.radius_l),
              ),
            ),
            // Bold button label text widget
            child: const Text(
              // CTA Label
              'Save Member Profile',
              // Typographic style configurations
              style: TextStyle(
                // White colors
                color: Colors.white,
                // Bold label indicators
                fontWeight: FontWeight.bold,
                // Size
                fontSize: 14.0,
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space_xl,
              vertical: AppSpacing.space_m,
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
                  const CustomProfileAppBar(
                    title: 'Add Family Member',
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
                      color: true == is_dark ? AppColors.surface_dark : Colors.white,
                      // Corner curvature matching radius tokens
                      borderRadius: BorderRadius.circular(16.0),
                      // Drop shadows
                      boxShadow: [
                        // Soft card shadow
                        BoxShadow(
                          // Color
                          color: true == is_dark
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.03),
                          // Blur
                          blurRadius: 10.0,
                          // Offsets
                          offset: const Offset(0.0, 4.0),
                        ),
                      ],
                      // Border boundary outline
                      border: Border.all(
                        // Colors
                        color: true == is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light.withValues(alpha: 0.5),
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
                          'Identity Details',
                          // Typographic options
                          style: TextStyle(
                            // Size
                            fontSize: 13.0,
                            // Bold indicators
                            fontWeight: FontWeight.bold,
                            // Muted text colors
                            color: true == is_dark ? Colors.white70 : AppColors.text_light_secondary,
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
                            color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                          ),
                          // Decoration parameters
                          decoration: InputDecoration(
                            // Floating label text
                            labelText: 'Full Name',
                            // Label style
                            labelStyle: TextStyle(
                              // Muted colors
                              color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                            ),
                            // Placeholders hint
                            hintText: 'e.g. Leo Mangood',
                            // Style
                            hintStyle: const TextStyle(color: Colors.grey),
                            // Prefix person outline icon
                            prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary_color),
                            // Color fills parameters
                            filled: true,
                            // Fill background colors
                            fillColor: true == is_dark ? Colors.black12 : AppColors.input_fill,
                            // Boundary outline borders
                            border: OutlineInputBorder(
                              // Radius
                              borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                              // No borders
                              borderSide: BorderSide.none,
                            ),
                          ),
                          // Validation callback
                          validator: (val) {
                            // Check if blank
                            if (null == val || val.trim().isEmpty) {
                              // Validation error
                              return 'Please enter a name';
                            }
                            // Check characters size
                            if (val.trim().length < 3) {
                              // Too short error message
                              return 'Name must be at least 3 characters';
                            }
                            // Return null if valid
                            return null;
                          },
                        ),
                        // Spacing gap height
                        const SizedBox(height: AppSpacing.space_l),
                        // Relationship Label Text widget
                        Text(
                          // Label text
                          'Relationship Type',
                          // Typographic options
                          style: TextStyle(
                            // Small font size
                            fontSize: 11.0,
                            // Color adaptions
                            color: true == is_dark ? Colors.white70 : AppColors.text_light_secondary,
                          ),
                        ),
                        // Spacer gap
                        const SizedBox(height: 6.0),
                        // Segmented relationship selector buttons row
                        Row(
                          // children list mapping selection values
                          children: ['Son', 'Daughter', 'Spouse', 'Parent'].map((rel) {
                            // Selected state check using Yoda condition comparison
                            final bool is_selected = rel == _selected_relationship;
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
                                  height: 38.0,
                                  // Centered text
                                  alignment: Alignment.center,
                                  // Margins offset spacing
                                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                  // Decoration properties
                                  decoration: BoxDecoration(
                                    // Active solid blue color or inactive background fills
                                    color: true == is_selected
                                        ? AppColors.primary_color
                                        : (true == is_dark ? Colors.black12 : AppColors.input_fill),
                                    // Rounded borders matching design tokens radius
                                    borderRadius: BorderRadius.circular(AppSpacing.radius_m),
                                    // Borders outline line
                                    border: Border.all(
                                      // Active blue outline or default borders
                                      color: true == is_selected
                                          ? AppColors.primary_color
                                          : (true == is_dark ? AppColors.border_dark : AppColors.border_light),
                                      // Thin outline size
                                      width: 1.0,
                                    ),
                                  ),
                                  // Relationship label text widget
                                  child: Text(
                                    // Bind relationship text value
                                    rel,
                                    // Styles options
                                    style: TextStyle(
                                      // Small font sizes
                                      fontSize: 11.0,
                                      // Bold indicator if active selected state
                                      fontWeight: true == is_selected ? FontWeight.bold : FontWeight.normal,
                                      // White color if active, or default primary text color
                                      color: true == is_selected
                                          ? Colors.white
                                          : (true == is_dark ? Colors.white70 : AppColors.text_light_primary),
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
                      color: true == is_dark ? AppColors.surface_dark : Colors.white,
                      // Radius corner shape
                      borderRadius: BorderRadius.circular(16.0),
                      // Drop shadows
                      boxShadow: [
                        // Soft card shadow
                        BoxShadow(
                          // Color
                          color: true == is_dark
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.03),
                          // Blur spreads
                          blurRadius: 10.0,
                        ),
                      ],
                      // Outline borders
                      border: Border.all(
                        // Border colors
                        color: true == is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light.withValues(alpha: 0.5),
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
                                'Date of Birth',
                                // Typographic specs
                                style: TextStyle(
                                  // Size
                                  fontSize: 11.0,
                                  // Muted colors
                                  color: true == is_dark ? Colors.white70 : AppColors.text_light_secondary,
                                ),
                              ),
                              // Spacer gap height
                              const SizedBox(height: 6.0),
                              // DOB input text field
                              TextFormField(
                                // Bind controller
                                controller: _dob_controller,
                                // Read-only parameters to prevent manual inputs
                                readOnly: true,
                                // Styles
                                style: TextStyle(
                                  // Colors
                                  color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                                ),
                                // Input decorations
                                decoration: InputDecoration(
                                  // Placeholder hints
                                  hintText: 'Select Date',
                                  // Hint style
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
                                  // Prefix calendar icon graphic representation
                                  prefixIcon: const Icon(Icons.calendar_month_outlined, color: AppColors.primary_color, size: 18.0),
                                  // Color fills parameters
                                  filled: true,
                                  // Fill background colors
                                  fillColor: true == is_dark ? Colors.black12 : AppColors.input_fill,
                                  // Inner input field content padding
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  // Outline borders
                                  border: OutlineInputBorder(
                                    // Radius
                                    borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                                    // No borders
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                // Date picker trigger onTap
                                onTap: () async {
                                  // Resolve showDatePicker future
                                  final DateTime? picked_date = await showDatePicker(
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
                                    final String formatted = '${picked_date.day}/${picked_date.month}/${picked_date.year}';
                                    // Trigger layout state update
                                    setState(() {
                                      // Set controller text value
                                      _dob_controller.text = formatted;
                                    });
                                  }
                                },
                                // Validation logic
                                validator: (val) {
                                  // Required check
                                  if (null == val || val.trim().isEmpty) {
                                    // Validation error
                                    return 'Required';
                                  }
                                  // Return null if valid
                                  return null;
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
                                'Gender Selection',
                                // Typographic style specs
                                style: TextStyle(
                                  // Size
                                  fontSize: 11.0,
                                  // Muted colors adaptions
                                  color: true == is_dark ? Colors.white70 : AppColors.text_light_secondary,
                                ),
                              ),
                              // Spacer gap height
                              const SizedBox(height: 6.0),
                              // Fluid premium clickable option pills row
                              Row(
                                // children
                                children: ['Male', 'Female'].map((gen) {
                                  // Selected state check using Yoda comparison
                                  final bool is_selected = gen == _selected_gender;
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
                                        height: 38.0,
                                        // Centered text
                                        alignment: Alignment.center,
                                        // Margins bounds spacer
                                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                        // Decoration options
                                        decoration: BoxDecoration(
                                          // Active primary blue color fill or default inactive background
                                          color: true == is_selected
                                              ? AppColors.primary_color
                                              : (true == is_dark ? Colors.black12 : AppColors.input_fill),
                                          // Capsule rounded shape (20px radius)
                                          borderRadius: BorderRadius.circular(20.0),
                                          // Outline borders
                                          border: Border.all(
                                            // Selected primary blue color border or default boundary lines
                                            color: true == is_selected
                                                ? AppColors.primary_color
                                                : (true == is_dark ? AppColors.border_dark : AppColors.border_light),
                                            // Thin border line thickness
                                            width: 1.0,
                                          ),
                                        ),
                                        // Gender text label widget
                                        child: Text(
                                          // Bind gender text value
                                          gen,
                                          // Styles options
                                          style: TextStyle(
                                            // Size
                                            fontSize: 11.0,
                                            // Bold weight if active selection
                                            fontWeight: true == is_selected ? FontWeight.bold : FontWeight.normal,
                                            // White color if active, or default primary text color
                                            color: true == is_selected
                                                ? Colors.white
                                                : (true == is_dark ? Colors.white70 : AppColors.text_light_primary),
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
                      color: true == is_dark ? AppColors.surface_dark : Colors.white,
                      // Rounded corner radius shape
                      borderRadius: BorderRadius.circular(16.0),
                      // Drop shadows
                      boxShadow: [
                        // Soft card shadow
                        BoxShadow(
                          // Color
                          color: true == is_dark
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.03),
                          // Spread blur
                          blurRadius: 10.0,
                        ),
                      ],
                      // Outline borders
                      border: Border.all(
                        // Colors
                        color: true == is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light.withValues(alpha: 0.5),
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
                          'Medical Background',
                          // Typographic options
                          style: TextStyle(
                            // Size
                            fontSize: 13.0,
                            // Bold indicators
                            fontWeight: FontWeight.bold,
                            // Subdued colors
                            color: true == is_dark ? Colors.white70 : AppColors.text_light_secondary,
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
                            color: true == is_dark ? Colors.white : AppColors.text_light_primary,
                          ),
                          // Input decoration configurations
                          decoration: InputDecoration(
                            // Floating label text
                            labelText: 'Allergies, Medications or Chronic Conditions',
                            // Label text style
                            labelStyle: TextStyle(
                              // Muted colors
                              color: true == is_dark ? Colors.white54 : AppColors.text_light_secondary,
                            ),
                            // Placeholder instructions hint
                            hintText: 'Describe medical history details dynamically...',
                            // Hint style
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.0),
                            // Color fills parameters
                            filled: true,
                            // Fill background colors
                            fillColor: true == is_dark ? Colors.black12 : AppColors.input_fill,
                            // Outline borders
                            border: OutlineInputBorder(
                              // Radius
                              borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                              // No border outline lines
                              borderSide: BorderSide.none,
                            ),
                            // Focused state border line
                            focusedBorder: OutlineInputBorder(
                              // Radius
                              borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                              // Active blue outline accent boundary line
                              borderSide: const BorderSide(color: AppColors.primary_color, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

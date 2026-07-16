/*
 * File Name: smart_password_field.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:flutter/services.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Secure Password input field forcing LTR directionality with visibility toggles.
 */

// Importing central design systems barrel configuration definitions
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing standard services for input formatting constraints
import 'package:flutter/services.dart';

// Stateful password input widget managing obfuscation toggles internally
class SmartPasswordField extends StatefulWidget {
  // Controller managing text state modifications
  final TextEditingController controller;

  // Localized label text shown above input box
  final String label;

  // Form validator function checking password rules constraints
  final String? Function(String?) validator;

  // Constructor mapping required variables
  const SmartPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
  });

  @override
  // Create state method initializing obfuscation tracking
  State<SmartPasswordField> createState() {
    // Return state class instance
    return _SmartPasswordFieldState();
  }
}

// State class managing visibility flags for password inputs
class _SmartPasswordFieldState extends State<SmartPasswordField> {
  // Flag indicating if password text remains hidden
  bool _obscure = true;

  // Focus node to monitor active typing/focus updates
  late final FocusNode _focus_node;

  // Flag tracking whether user touched/interacted with the field and blurred it
  bool _touched = false;

  @override
  // Initialize state registers and focus listeners
  void initState() {
    // Invoke parent initialization
    super.initState();
    // Instantiate new focus node
    _focus_node = FocusNode();
    // Attach listener to track focus changes
    _focus_node.addListener(_on_focus_changed);
  }

  // Method executing when focus updates on input field
  void _on_focus_changed() {
    // Check if focus was lost using Yoda style check
    if (false == _focus_node.hasFocus) {
      // Refresh layout state to trigger validation
      setState(() {
        // Mark field as touched
        _touched = true;
      });
    } else {
      // Empty action block to satisfy compiler
    }
    // Refresh layout state for outline border color updates
    setState(() {});
  }

  @override
  // Clean up listeners and dispose focus nodes to avoid memory leaks
  void dispose() {
    // Remove focus listener tracker
    _focus_node.removeListener(_on_focus_changed);
    // Dispose focus node resources
    _focus_node.dispose();
    // Invoke parent dispose logic
    super.dispose();
  }

  @override
  // Build method drawing password text field elements
  Widget build(BuildContext context) {
    // Check if device locale is set to Arabic
    final bool is_arabic = AppLocalizations.of(context).is_arabic;

    // Check if standard system brightness is dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return Column layout grouping label and password input
    return Column(
      // Align children components starting from the horizontal edge
      crossAxisAlignment: CrossAxisAlignment.start,
      // Place children inside layout array
      children: [
        // Text widget rendering field label
        Text(
          // Active label text
          widget.label,
          // Pull centralized style registry
          style: AppTextStyles.get_field_label(is_arabic),
        ),
        // Height divider using spacing constants
        const SizedBox(height: AppSpacing.space_m),
        // Listen to controller text changes to dynamically update text alignment
        ValueListenableBuilder<TextEditingValue>(
          // Bind value listenable to text controller
          valueListenable: widget.controller,
          // Builder method rebuilding on value changes
          builder: (context, value, child) {
            // Return Stack layering shadow background behind the TextFormField
            return Stack(
              // Allow child widgets to paint outside stack boundary lines
              clipBehavior: Clip.none,
              // Children widgets list
              children: [
                // Positioned shadow decorator container matching input box height
                Positioned(
                  // Align to top edge
                  top: 0.0,
                  // Align to left edge
                  left: 0.0,
                  // Align to right edge
                  right: 0.0,
                  // Restrict shadow container height to input box area
                  height: 50.0,
                  // Shadow background widget
                  child: Container(
                    // Visual styling decoration
                    decoration: BoxDecoration(
                      // Set corner radius using spacing constants
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radius_input),
                      // Shadows list
                      boxShadow: [
                        BoxShadow(
                          // Choose shadow color based on dark mode using Yoda style check
                          color: true == is_dark
                              ? Colors.black.withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.04),
                          // Shadow blur radius
                          blurRadius: 6.0,
                          // Shadow thickness spread
                          spreadRadius: 1.0,
                          // Shadow displacement offset coordinates
                          offset: const Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
                // Render standard TextFormField on top of the shadow decorator
                TextFormField(
                // Bind text controller
                controller: widget.controller,
                // Bind focus node
                focusNode: _focus_node,
                // Set text obfuscation status
                obscureText: _obscure,
                // Bind validator logic
                validator: widget.validator,
                // Enable validation modes onBlur once touched using Yoda style checks
                autovalidateMode: true == _touched
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                // Limit password length to maximum 30 characters
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                ],
                // Force password inputs to LTR direction even in Arabic
                textDirection: TextDirection.ltr,
                // Align password bullets dynamically to the right in Arabic RTL mode (BUG-006)
                textAlign: true == is_arabic ? TextAlign.right : TextAlign.left,
                // Text styling inside field
                style: TextStyle(
                  // Set font size using spacing constants
                  fontSize: AppSpacing.font_size_text,
                  // Apply theme-appropriate text color token using Yoda style
                  color: true == is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
                // Input field decoration configuration
                decoration: InputDecoration(
                  // Set static bullet hints for passwords
                  hintText: '••••••••',
                  // Set hints text styling
                  hintStyle: const TextStyle(
                    // Set hint text color using secondary text color
                    color: AppColors.text_light_secondary,
                  ),
                  // Suffix icon layout containing toggle action button
                  suffixIcon: IconButton(
                    // Define toggle button press event
                    onPressed: () {
                      // Refresh layout state
                      setState(() {
                        // Toggle visibility flag
                        _obscure = !_obscure;
                      });
                    },
                    // Render appropriate visibility icon based on state using Yoda style check
                    icon: Icon(
                      // Choose eye or eye slash icon
                      true == _obscure
                          // Hidden state icon
                          ? Icons.visibility_off_outlined
                          // Visible state icon
                          : Icons.visibility_outlined,
                      // Set icon color using secondary text color
                      color: AppColors.text_light_secondary,
                    ),
                  ),
                  // Custom error text styling allowing multi-line wrapping
                  errorStyle: const TextStyle(
                    // Error color
                    color: AppColors.error,
                    // Small size for validation text labels
                    fontSize: 11.0,
                    // High readable lines multiplier spacing
                    height: 1.4,
                  ),
                  // Allow up to 3 lines of error text wrapping
                  errorMaxLines: 3,
                  // Enable background color fills
                  filled: true,
                  // Apply dynamic background color fill using Yoda style check
                  fillColor: true == is_dark
                      ? AppColors.surface_dark
                      : AppColors.input_fill,
                  // Standard enabled border configuration
                  enabledBorder: OutlineInputBorder(
                    // Set standard corner curves radius using spacing constants
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radius_input),
                    // Set line border color options using Yoda style check
                    borderSide: BorderSide(
                      // Set color token dynamically
                      color: true == is_dark
                          ? AppColors.border_dark
                          : AppColors.border_light,
                      // Set border line thickness using spacing constants
                      width: AppSpacing.border_width_thin,
                    ),
                  ),
                  // Focused active border configuration
                  focusedBorder: OutlineInputBorder(
                    // Set standard corner curves radius using spacing constants
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radius_input),
                    // Set active brand primary border line
                    borderSide: const BorderSide(
                      // Set color token to primary brand
                      color: AppColors.primary_color,
                      // Set line thickness using spacing constants
                      width: AppSpacing.border_width_thick,
                    ),
                  ),
                  // Failed validation error border configuration
                  errorBorder: OutlineInputBorder(
                    // Set standard corner curves radius using spacing constants
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radius_input),
                    // Set warning error border line
                    borderSide: const BorderSide(
                      // Set color token to error
                      color: AppColors.error,
                      // Set line thickness using spacing constants
                      width: AppSpacing.border_width_thin,
                    ),
                  ),
                  // Failed validation active focused border configuration
                  focusedErrorBorder: OutlineInputBorder(
                    // Set standard corner curves radius using spacing constants
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radius_input),
                    // Set thick warning error border line
                    borderSide: const BorderSide(
                      // Set color token to error
                      color: AppColors.error,
                      // Set line thickness using spacing constants
                      width: AppSpacing.border_width_thick,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      ],
    );
  }
}

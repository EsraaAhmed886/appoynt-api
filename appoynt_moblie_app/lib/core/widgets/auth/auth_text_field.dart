/*
 * File Name: auth_text_field.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:flutter/services.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 12/07/2026]
 * File Description:
 *   Standardized, premium text input component designed for authentication forms.
 *   Provides automatic dark mode adaptation, LTR forcing for credentials, and localized fonts.
 */

// Importing central design systems barrel configuration definitions
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing standard system services for inputs formatting
import 'package:flutter/services.dart';

// Standardized text input component widget for auth forms
class AuthTextField extends StatefulWidget {
  // Label text displayed above input field
  final String label;

  // Placeholder hint text shown inside input field
  final String hint;

  // Text controller tracking input characters
  final TextEditingController controller;

  // Prefix icon displayed at the start of input row
  final IconData? prefix_icon;

  // Flag determining if text values should be obfuscated
  final bool is_password;

  // Flag indicating if text field maps phone inputs
  final bool is_phone;

  // Validator function mapping input rules validation checks
  final String? Function(String?)? validator;

  // Layout keyboard type mapping
  final TextInputType? keyboard_type;

  // Keyboard return actions configuration
  final TextInputAction? text_input_action;

  // Constructor mapping standard parameters
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.prefix_icon,
    this.is_password = false,
    this.is_phone = false,
    this.validator,
    this.keyboard_type,
    this.text_input_action,
  });

  @override
  // Create state tracking class instance
  State<AuthTextField> createState() {
    // Return state class instance
    return _AuthTextFieldState();
  }
}

// State class managing visibility flags for password text fields
class _AuthTextFieldState extends State<AuthTextField> {
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
  // Build method drawing input components
  Widget build(BuildContext context) {
    // Check if system locale is set to Arabic
    final bool is_arabic = AppLocalizations.of(context).is_arabic;

    // Check if system brightness matches dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Check if field is credential input to force LTR configuration using Yoda style comparison
    final bool force_ltr = true == widget.is_password ||
        true == widget.is_phone ||
        TextInputType.emailAddress == widget.keyboard_type;

    // Return Column layout structuring labels and input fields
    return Column(
      // Align items starting from the horizontal edge
      crossAxisAlignment: CrossAxisAlignment.start,
      // Contain visual children list
      children: [
        // Text widget rendering field label
        Text(
          // Active label text
          widget.label,
          // Pull centralized style registry with theme-adaptive colors
          style: AppTextStyles.get_field_label(is_arabic).copyWith(
            // Select label color based on theme using Yoda style check
            color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
          ),
        ),
        // Space margin before text field using spacing constants
        const SizedBox(height: AppSpacing.space_m),
        // Listen to controller text changes to dynamically update text alignment
        ValueListenableBuilder<TextEditingValue>(
          // Bind value listenable to text controller
          valueListenable: widget.controller,
          // Builder method rebuilding on value changes
          builder: (context, value, child) {
            // Resolve text alignment dynamically depending on LTR checks using Yoda style check (BUG-006 / Confirm Password)
            final TextAlign dynamic_align = true == force_ltr
                ? (true == widget.is_password && true == is_arabic ? TextAlign.right : TextAlign.left)
                : (true == is_arabic ? TextAlign.right : TextAlign.left);

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
                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
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
                // Bind controller
                controller: widget.controller,
                // Bind focus node
                focusNode: _focus_node,
                // Obfuscate text based on password flags using Yoda style check
                obscureText: true == widget.is_password && true == _obscure,
                // Bind validator
                validator: widget.validator,
                // Enable validation modes onBlur once touched using Yoda style checks
                autovalidateMode: true == _touched
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                // Resolve virtual keyboard configuration layout
                keyboardType: true == widget.is_phone
                    ? TextInputType.phone
                    : widget.keyboard_type ??
                        (true == widget.is_password
                            ? TextInputType.visiblePassword
                            : TextInputType.text),
                // Resolve keyboard return action using Yoda style check
                textInputAction: widget.text_input_action ?? TextInputAction.next,
                // Format digits-only if phone field is active using Yoda style check
                inputFormatters: true == widget.is_phone
                    ? [
                        // Use custom Egyptian phone input formatter
                        PhoneInputFormatter(),
                      ]
                    : null,
                // Force input directionality text rules
                textDirection: true == force_ltr
                    ? TextDirection.ltr
                    : (true == is_arabic ? TextDirection.rtl : TextDirection.ltr),
                // Set resolved dynamic text alignments
                textAlign: dynamic_align,
                // Input text styling
                style: TextStyle(
                    // Font size from spacing constants
                    fontSize: AppSpacing.font_size_text,
                    // Select text color based on theme using Yoda style check
                    color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
                  ),
                  // Text field decoration settings
                  decoration: InputDecoration(
                    // Localized placeholder hint
                    hintText: widget.hint,
                    // Placeholder styling
                    hintStyle: TextStyle(
                      // Hint size matches standard inputs
                      fontSize: AppSpacing.font_size_text,
                      // Select hint color based on theme using Yoda style check
                      color: true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                    ),
                    // Enable background color fills
                    filled: true,
                    // Adapt background colors based on dark mode using Yoda style check
                    fillColor: true == is_dark ? AppColors.surface_dark : AppColors.input_fill,
                    // Optional prefix icon rendering
                    prefixIcon: null != widget.prefix_icon
                        ? Icon(
                            // Icon data representation
                            widget.prefix_icon,
                            // Select icon color dynamically using Yoda style check
                            color: true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                            // Set layout size
                            size: 20.0,
                          )
                        : null,
                    // Suffix icon rendering visibility toggler if password is active using Yoda style check
                    suffixIcon: true == widget.is_password
                        ? IconButton(
                            // Define toggle handler
                            onPressed: () {
                              // Update state flags
                              setState(() {
                                // Toggle obfuscation state
                                _obscure = !_obscure;
                              });
                            },
                            // Render corresponding eye icon using Yoda style check
                            icon: Icon(
                              // Choose eye icon
                              true == _obscure
                                  // Eye off icon
                                  ? Icons.visibility_off_outlined
                                  // Eye on icon
                                  : Icons.visibility_outlined,
                              // Select icon color dynamically using Yoda style check
                              color: true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                              // Set layout size
                              size: 20.0,
                            ),
                          )
                        : null,
                    // Default outline border configurations
                    border: OutlineInputBorder(
                      // Set corner radius using spacing constants
                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                      // Set border side specifications
                      borderSide: BorderSide(
                        // Select border color based on theme using Yoda style check
                        color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                        // Set line thickness using spacing constants
                        width: AppSpacing.border_width_thin,
                      ),
                    ),
                    // Enabled but unfocused border styling
                    enabledBorder: OutlineInputBorder(
                      // Set corner radius using spacing constants
                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                      // Set border side specifications
                      borderSide: BorderSide(
                        // Select border color based on theme using Yoda style check
                        color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                        // Set line thickness using spacing constants
                        width: AppSpacing.border_width_thin,
                      ),
                    ),
                    // Focused active input border styling
                    focusedBorder: OutlineInputBorder(
                      // Set corner radius using spacing constants
                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                      // Highlight with primary brand color border
                      borderSide: const BorderSide(
                        // Primary brand color
                        color: AppColors.primary_color,
                        // Set line thickness using spacing constants
                        width: AppSpacing.border_width_thick,
                      ),
                    ),
                    // Validation failed error border styling
                    errorBorder: OutlineInputBorder(
                      // Set corner radius using spacing constants
                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                      // Set warning red border line
                      borderSide: const BorderSide(
                        // Error color
                        color: AppColors.error,
                        // Set line thickness using spacing constants
                        width: AppSpacing.border_width_thin,
                      ),
                    ),
                    // Validation failed focused active border styling
                    focusedErrorBorder: OutlineInputBorder(
                      // Set corner radius using spacing constants
                      borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                      // Set thick warning red border line
                      borderSide: const BorderSide(
                        // Error color
                        color: AppColors.error,
                        // Set line thickness using spacing constants
                        width: AppSpacing.border_width_thick,
                      ),
                    ),
                    // Error labels typography styling
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
                    // Internal margins padding layout rules
                    contentPadding: const EdgeInsets.symmetric(
                      // Horizontal spacing using spacing constants
                      horizontal: AppSpacing.space_xl,
                      // Vertical spacing using spacing constants
                      vertical: AppSpacing.padding_input_vertical,
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

// Custom text input formatter to sanitize and format phone numbers in real-time
class PhoneInputFormatter extends TextInputFormatter {
  @override
  // Intercept and rewrite typed character states
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Retrieve new value string representation
    String text = newValue.text;
    
    // Convert Arabic numerals to English digits if any exist
    final Map<String, String> arabic_to_english = {
      '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4',
      '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9'
    };
    // Translate each character in map
    arabic_to_english.forEach((arabic, english) {
      text = text.replaceAll(arabic, english);
    });

    // Remove any characters that are not digits or the plus prefix sign
    text = text.replaceAll(RegExp(r'[^\d+]'), '');

    // Strip Egyptian country code variants starting at index points using Yoda checks
    if (true == text.startsWith('+201')) {
      // Replace with standard leading Egyptian zero digit
      text = '01${text.substring(4)}';
    } else if (true == text.startsWith('00201')) {
      // Replace with standard leading Egyptian zero digit
      text = '01${text.substring(5)}';
    } else if (true == text.startsWith('201')) {
      // Replace with standard leading Egyptian zero digit
      text = '01${text.substring(3)}';
    } else {
      // Empty action block to satisfy compiler
    }

    // Strip any remaining plus symbols or non-digit characters
    text = text.replaceAll(RegExp(r'[^\d]'), '');

    // Truncate to maximum 11 Egyptian digits limit using Yoda style check
    if (11 < text.length) {
      // Strip extra inputs past maximum length
      text = text.substring(0, 11);
    } else {
      // Empty action block to satisfy compiler
    }

    // Resolve cursor index pointer position
    int selection_index = newValue.selection.end;
    // Adjust cursor position if text length changed using Yoda style check
    if (selection_index > text.length) {
      // Clamp index within bounds
      selection_index = text.length;
    } else {
      // Empty action block to satisfy compiler
    }

    // Return updated text value with adjusted selection range
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selection_index),
    );
  }
}

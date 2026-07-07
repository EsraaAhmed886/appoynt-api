/*
 * File Name: auth_text_field.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:flutter/services.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
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
        // Force directionality layout depending on forced LTR requirements using Yoda style check
        Directionality(
          // Resolve direction settings
          textDirection: true == force_ltr
              ? TextDirection.ltr
              : (true == is_arabic ? TextDirection.rtl : TextDirection.ltr),
          // Listen to controller text changes to dynamically update text alignment
          child: ValueListenableBuilder<TextEditingValue>(
            // Bind value listenable to text controller
            valueListenable: widget.controller,
            // Builder method rebuilding on value changes
            builder: (context, value, child) {
              // Resolve text alignment dynamically depending on LTR checks and empty status using Yoda style check
              final TextAlign dynamic_align = true == force_ltr
                  ? (true == value.text.isEmpty && true == is_arabic ? TextAlign.right : TextAlign.left)
                  : (true == is_arabic ? TextAlign.right : TextAlign.left);

              // Return standard TextFormField
              return TextFormField(
                // Bind controller
                controller: widget.controller,
                // Obfuscate text based on password flags using Yoda style check
                obscureText: true == widget.is_password && true == _obscure,
                // Bind validator
                validator: widget.validator,
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
                        // Permit only digits inputs
                        FilteringTextInputFormatter.digitsOnly,
                        // Restrict inputs to Egyptian length standard
                        LengthLimitingTextInputFormatter(11),
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
                  // Enable background fills
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
                  // Internal margins padding layout rules
                  contentPadding: const EdgeInsets.symmetric(
                    // Horizontal spacing using spacing constants
                    horizontal: AppSpacing.space_xl,
                    // Vertical spacing using spacing constants
                    vertical: AppSpacing.space_xl,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

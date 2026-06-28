/*
 * File Name: smart_identifier_field.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Intelligent Email/Phone input field forcing LTR directionality.
 */

// Importing central barrel configuration mapping design tokens
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Stateless widget rendering the dynamic identifier field with type icon detection
class SmartIdentifierField extends StatelessWidget {
  // Controller managing text state modifications
  final TextEditingController controller;

  // Prefix icon displayed at the start of input row
  final IconData prefix_icon;

  // Localized label text shown above input box
  final String label;

  // Localized placeholder hint text shown when empty
  final String hint;

  // TextInputType configuration (phone pad or email keyboard)
  final TextInputType keyboard_type;

  // Form validator function checking constraint inputs
  final String? Function(String?) validator;

  // Constructor mapping required variables
  const SmartIdentifierField({
    super.key,
    required this.controller,
    required this.prefix_icon,
    required this.label,
    required this.hint,
    required this.keyboard_type,
    required this.validator,
  });

  @override
  // Build method drawing form field elements
  Widget build(BuildContext context) {
    // Check if device locale is set to Arabic
    final bool is_arabic = AppLocalizations.of(context).is_arabic;

    // Check if standard system brightness is dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return Column layout grouping label and text form field
    return Column(
      // Align children components starting from the horizontal edge
      crossAxisAlignment: CrossAxisAlignment.start,
      // Place children inside layout array
      children: [
        // Text widget rendering field label
        Text(
          // Active label text
          label,
          // Pull centralized style registry
          style: AppTextStyles.get_field_label(is_arabic),
        ),
        // Height divider using spacing constants
        const SizedBox(height: AppSpacing.space_m),
        // Force text direction layout to LTR to keep prefix icon on the left
        Directionality(
          // Set directionality strictly to LTR
          textDirection: TextDirection.ltr,
          // Listen to controller text changes to dynamically update text alignment
          child: ValueListenableBuilder<TextEditingValue>(
            // Bind value listenable to text controller
            valueListenable: controller,
            // Builder method rebuilding on value changes
            builder: (context, value, child) {
              // Resolve dynamic text alignment based on empty status and language direction using Yoda style check
              final TextAlign dynamic_align = (true == value.text.isEmpty && true == is_arabic)
                  // Right-align placeholder in Arabic mode when empty
                  ? TextAlign.right
                  // Left-align inputs and placeholders in other states
                  : TextAlign.left;

              // TextFormField wrapper
              return TextFormField(
                // Bind text controller
                controller: controller,
                // Bind validator logic
                validator: validator,
                // Bind keyboard configuration
                keyboardType: keyboard_type,
                // Force credential inputs to LTR direction even in Arabic
                textDirection: TextDirection.ltr,
                // Set dynamic text alignment to support right-aligned placeholders in Arabic
                textAlign: dynamic_align,
                // Text styling inside field
                style: TextStyle(
                  // Set font size using spacing constants
                  fontSize: AppSpacing.font_size_text,
                  // Apply theme-appropriate text color token using Yoda style check
                  color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
                ),
                // Input field decoration configuration
                decoration: InputDecoration(
                  // Localized placeholder hint string
                  hintText: hint,
                  // Set hints text styling
                  hintStyle: const TextStyle(
                    // Set hint text color using secondary text color
                    color: AppColors.text_light_secondary,
                  ),
                  // Display resolved detection prefix icon
                  prefixIcon: Icon(
                    // prefix icon data
                    prefix_icon,
                    // Set icon color using secondary text color
                    color: AppColors.text_light_secondary,
                  ),
                  // Enable background color fills
                  filled: true,
                  // Apply dynamic background color fill using Yoda style check
                  fillColor: true == is_dark ? AppColors.surface_dark : AppColors.input_fill,
                  // Standard enabled border configuration
                  enabledBorder: OutlineInputBorder(
                    // Set standard corner curves radius using spacing constants
                    borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                    // Set line border color options using Yoda style check
                    borderSide: BorderSide(
                      // Set color token dynamically
                      color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
                      // Set border line thickness using spacing constants
                      width: AppSpacing.border_width_thin,
                    ),
                  ),
                  // Focused active border configuration
                  focusedBorder: OutlineInputBorder(
                    // Set standard corner curves radius using spacing constants
                    borderRadius: BorderRadius.circular(AppSpacing.radius_input),
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
                    borderRadius: BorderRadius.circular(AppSpacing.radius_input),
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
                    borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                    // Set thick warning error border line
                    borderSide: const BorderSide(
                      // Set color token to error
                      color: AppColors.error,
                      // Set line thickness using spacing constants
                      width: AppSpacing.border_width_thick,
                    ),
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

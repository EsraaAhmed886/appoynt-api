/*
 * File Name: smart_password_field.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Secure Password input field forcing LTR directionality with visibility toggles.
 */

// Importing central design systems barrel configuration definitions
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

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
        // Force text direction layout to LTR to keep suffix icon on the right
        Directionality(
          // Set directionality strictly to LTR
          textDirection: TextDirection.ltr,
          // TextFormField wrapper
          child: TextFormField(
            // Bind text controller
            controller: widget.controller,
            // Set text obfuscation status
            obscureText: _obscure,
            // Bind validator logic
            validator: widget.validator,
            // Force password inputs to LTR direction even in Arabic
            textDirection: TextDirection.ltr,
            // Force password inputs to be left-aligned even in Arabic
            textAlign: TextAlign.left,
            // Text styling inside field
            style: TextStyle(
              // Set font size using spacing constants
              fontSize: AppSpacing.font_size_text,
              // Apply theme-appropriate text color token using Yoda style check
              color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
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
                  // Select eye or eye slash icon
                  true == _obscure
                      // Hidden state icon
                      ? Icons.visibility_off_outlined
                      // Visible state icon
                      : Icons.visibility_outlined,
                  // Set icon color using secondary text color
                  color: AppColors.text_light_secondary,
                ),
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
          ),
        ),
      ],
    );
  }
}

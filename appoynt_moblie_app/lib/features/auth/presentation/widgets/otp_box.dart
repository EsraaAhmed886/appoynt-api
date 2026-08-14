/*
 * File Name: otp_box.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:flutter/services.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: A single digit input box designed specifically for OTP verification.
 *   Features specialized styling and automatic focus management.
 */

import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing services package to access text input formatter properties
import 'package:flutter/services.dart';

/// A stateless widget representing one segment of an OTP input field.
class OtpBox extends StatelessWidget {
  /// Controller for managing the digit value.
  final TextEditingController controller;
  /// Focus node to control the field's focus state.
  final FocusNode focusNode;
  /// Callback triggered when the digit changes.
  final ValueChanged<String> onChanged;
  /// Flag to enable/disable the box (BUG-010).
  final bool enabled;

  /// Constructor requiring controller, focus node, change callback, and optional enablement flag.
  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    /// Flag indicating if system brightness matches dark mode.
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    /// Flag indicating if the box currently contains a digit.
    final bool filled = controller.text.isNotEmpty;
    
    return SizedBox(
      width: 46, // Standard width for the OTP digit box
      height: 54, // Standard height for the OTP digit box
      child: TextFormField(
        controller: controller, // Linking to external controller
        focusNode: focusNode, // Linking to external focus node
        onChanged: onChanged, // Linking to external change logic
        // Bind enabled property (BUG-010)
        enabled: enabled,
        textAlign: TextAlign.center, // Centering the digit
        textDirection: TextDirection.ltr, // Enforcing LTR direction for digits
        keyboardType: TextInputType.number, // Restricting to numeric keyboard
        /// Enforcing numeric-only input and a maximum length of 1 character.
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        style: TextStyle(
          fontSize: 22, // Large font for readability
          fontWeight: FontWeight.w700, // Bold for emphasis
          color: is_dark
              ? AppColors.text_dark_primary
              : AppColors.text_light_primary, // Dynamic text color
        ),
        decoration: InputDecoration(
          counterText: '', // Hiding the character counter
          filled: true, // Enabling background fill
          /// Applying a subtle brand-themed background color.
          fillColor: AppColors.primary_color.withValues(alpha: 0.08),
          /// Defining the default border state.
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners matching design
            borderSide: BorderSide(
              color: is_dark
                  ? AppColors.border_dark
                  : AppColors.border_light,
              width: AppSpacing.border_width_thin,
            ),
          ),
          /// Defining the border state when disabled (BUG-010).
          disabledBorder: OutlineInputBorder(
            // Rounded corners matching design
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              // Same color as default border when disabled
              color: is_dark
                  ? AppColors.border_dark
                  : AppColors.border_light,
              // Thin border width
              width: AppSpacing.border_width_thin,
            ),
          ),
          /// Defining the border state when enabled.
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              /// Highlighting with a subtle border if a value is present, otherwise using default border.
              color: true == filled
                  ? AppColors.primary_color.withValues(alpha: 0.5)
                  : (is_dark
                      ? AppColors.border_dark
                      : AppColors.border_light),
              width: true == filled ? 1.5 : AppSpacing.border_width_thin,
            ),
          ),
          /// Defining the border state when focused.
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary_color, // Full brand color on focus
              width: 2, // Increased thickness
            ),
          ),
          // Removing internal padding for perfect centering
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

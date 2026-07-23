/*
 * File Name: add_saved_card_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
 * File Description: Dedicated page to input new credit card details with strict Luhn and CVV validations.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Stateful widget displaying credit card add form layout
class AddSavedCardPage extends StatefulWidget {
  // Constructor mapping key
  const AddSavedCardPage({super.key});

  @override
  // Create state tracker instance
  State<AddSavedCardPage> createState() {
    // Return state class instance
    return _AddSavedCardPageState();
  }
}

// State class managing credit card validation checks and input formatting
class _AddSavedCardPageState extends State<AddSavedCardPage> {
  // Form state key to validate fields
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();

  // Text controllers tracking inputs
  final TextEditingController _holder_controller = TextEditingController();
  // Card number input controller
  final TextEditingController _number_controller = TextEditingController();
  // Expiry input controller
  final TextEditingController _expiry_controller = TextEditingController();
  // CVV input controller
  final TextEditingController _cvv_controller = TextEditingController();

  // Active validation state variables
  bool _validated_once = false;

  // Luhn algorithm validator check implementation
  bool _luhn_check(String number) {
    // Remove space gaps
    final String cleaned = number.replaceAll(' ', '');
    // Must contain exactly 16 digits
    if (16 != cleaned.length) {
      // Failed
      return false;
    }
    // Track cumulative sum
    int sum = 0;
    // Track alternation state
    bool alternate = false;
    // Run backward iteration check loop
    for (int i = cleaned.length - 1; i >= 0; i--) {
      // Parse individual digits
      int digit = int.tryParse(cleaned[i]) ?? -1;
      // If parsing fails
      if (-1 == digit) {
        // Failed
        return false;
      }
      // Alternate digits double multiplication
      if (alternate) {
        // Double digit
        digit *= 2;
        // Check if double digit is greater than 9
        if (digit > 9) {
          // Subtract nine
          digit -= 9;
        }
      }
      // Add digit value to total
      sum += digit;
      // Alternate status toggle
      alternate = !alternate;
    }
    // Return status if sum is divisible by ten
    return 0 == (sum % 10);
  }

  // Expiration date validity MM/YY format validator check
  bool _validate_expiry(String value) {
    // Regular expression matching MM/YY format
    final RegExp regex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
    // Check match
    if (false == regex.hasMatch(value)) {
      // Invalid format
      return false;
    }
    // Split date components
    final parts = value.split('/');
    // Parse month
    final int month = int.tryParse(parts[0]) ?? 0;
    // Parse year offset mapped to 2000s
    final int year = (int.tryParse(parts[1]) ?? 0) + 2000;

    // Constant current date rules bounds (strictly 2026/07)
    const int current_year = 2026;
    // Current month July
    const int current_month = 7;

    // Validate year limit
    if (year < current_year) {
      // Card has expired
      return false;
    }
    // Validate current year month limits
    if (year == current_year && month < current_month) {
      // Card has expired
      return false;
    }
    // Valid expiration parameters
    return true;
  }

  // Cardholder alphabetical format validation check
  bool _validate_cardholder(String value) {
    // Clean string bounds
    final String trimmed = value.trim();
    // Regex ensuring alphabetical and space values only
    final RegExp name_regex = RegExp(r'^[a-zA-Z\s]+$');
    // Match check
    if (false == name_regex.hasMatch(trimmed)) {
      // Contains invalid characters
      return false;
    }
    // Split spacing segments
    final List<String> parts = trimmed.split(RegExp(r'\s+'));
    // Ensure at least first and last name values exist
    if (parts.length < 2) {
      // Too short
      return false;
    }
    // Check characters boundaries for each name segment
    for (final part in parts) {
      // Must contain at least 2 alphabet characters
      if (part.length < 2) {
        // Segment invalid
        return false;
      }
    }
    // Valid cardholder name parameters
    return true;
  }

  // CVV numeric structure validation checks
  bool _validate_cvv(String value) {
    // Regex matching exactly three digits
    final RegExp regex = RegExp(r'^[0-9]{3}$');
    // Return check status
    return regex.hasMatch(value);
  }

  @override
  // Clean allocations upon state disposal
  void dispose() {
    // Dispose text fields controllers
    _holder_controller.dispose();
    // Card controller dispose
    _number_controller.dispose();
    // Expiry controller dispose
    _expiry_controller.dispose();
    // CVV controller dispose
    _cvv_controller.dispose();
    // Super call
    super.dispose();
  }

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // Background colors mapping
      backgroundColor: true == is_dark
          ? AppColors.background_dark
          : AppColors.surface_light.withValues(alpha: 0.5),
      // Body content form layout
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space_m),
              const CustomProfileAppBar(
                title: 'Add New Card',
              ),
              const SizedBox(height: AppSpacing.space_xl),
              Expanded(
                child: SingleChildScrollView(
                  // Padding offsets
                  padding: const EdgeInsets.symmetric(
                    // Vertical padding only since horizontal padding is on parent
                    vertical: AppSpacing.space_m,
                  ),
          // Form validation state wrap
          child: Form(
            // Bind global key
            key: _form_key,
            // Dynamic validation mode configs
            autovalidateMode: true == _validated_once
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            // Input elements column
            child: Column(
              // Align left coordinates
              crossAxisAlignment: CrossAxisAlignment.start,
              // children details
              children: [
                // Section Title: Holder Info
                const Text(
                  // Label holder name
                  'Cardholder Name',
                  // Style specs
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Gap spacer height
                const SizedBox(height: 6.0),
                // Custom input textbox stack
                _build_secure_input(
                  // Controller link
                  controller: _holder_controller,
                  // Hint holder text
                  hint: 'e.g., Kholoud Khaled',
                  // User icon vector
                  icon: Icons.person_outline_rounded,
                  // Validation callback block
                  validator: (val) {
                    // Check alphabetical name structure
                    if (null == val || false == _validate_cardholder(val)) {
                      // Return strict validation error
                      return 'Please enter the full name as written on the card.';
                    }
                    // Valid status
                    return null;
                  },
                ),
                // Height spacer gap
                const SizedBox(height: 16.0),

                // Section Title: Card Number
                const Text(
                  // Label card number
                  'Card Number',
                  // Style specs
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Gap spacer height
                const SizedBox(height: 6.0),
                // Custom input textbox stack (forced LTR/credentials alignment)
                _build_secure_input(
                  // Controller link
                  controller: _number_controller,
                  // Hint number text
                  hint: '4532 •••• •••• 8899',
                  // Credit card logo vector representation
                  icon: Icons.credit_card_rounded,
                  // Force LTR alignment status
                  force_ltr: true,
                  // Digit values type
                  keyboard_type: TextInputType.number,
                  // Validation callback block
                  validator: (val) {
                    // Verify Luhn algorithm criteria
                    if (null == val || false == _luhn_check(val)) {
                      // Return strict error
                      return 'Please enter a valid 16-digit card number.';
                    }
                    // Valid status
                    return null;
                  },
                ),
                // Height spacer gap
                const SizedBox(height: 16.0),

                // Expiry and CVV side-by-side row
                Row(
                  // Align coordinates
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children list
                  children: [
                    // Expiry Column
                    Expanded(
                      // Stack layout
                      child: Column(
                        // Align left
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // children details
                        children: [
                          // Label Expiry text
                          const Text(
                            // Label
                            'Expiry Date',
                            // Style
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Spacer height gap
                          const SizedBox(height: 6.0),
                          // Input box (forced LTR)
                          _build_secure_input(
                            // Controller link
                            controller: _expiry_controller,
                            // Hint format MM/YY
                            hint: 'MM/YY (e.g. 12/28)',
                            // Calendar vector icon
                            icon: Icons.calendar_month_outlined,
                            // Force LTR text
                            force_ltr: true,
                            // Validation callback block
                            validator: (val) {
                              // Verify expiry limits and date formatting
                              if (null == val ||
                                  false == _validate_expiry(val)) {
                                // Return strict error
                                return 'Card has expired or date format is invalid.';
                              }
                              // Valid status
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    // Horizontal gap spacer
                    const SizedBox(width: 16.0),
                    // CVV Column
                    Expanded(
                      // Stack layout
                      child: Column(
                        // Align left
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // children details
                        children: [
                          // Label CVV text
                          const Text(
                            // Label
                            'CVV',
                            // Style
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Spacer height gap
                          const SizedBox(height: 6.0),
                          // Input box (forced LTR/Secure CVV mask digits)
                          _build_secure_input(
                            // Controller link
                            controller: _cvv_controller,
                            // Hint mask CVV
                            hint: '••• (e.g. 123)',
                            // Lock icon vector representation
                            icon: Icons.lock_outline_rounded,
                            // Force LTR text
                            force_ltr: true,
                            // Hide CVV typing character values
                            obscure_text: true,
                            // Limit numbers
                            keyboard_type: TextInputType.number,
                            // Validation callback block
                            validator: (val) {
                              // Verify CVV criteria length
                              if (null == val || false == _validate_cvv(val)) {
                                // Return strict error
                                return 'Invalid CVV code.';
                              }
                              // Valid status
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Height spacer padding offset
                const SizedBox(height: 36.0),

                // Save Card Action Button solid CTA
                SizedBox(
                  // Full width
                  width: double.infinity,
                  // Height dimensions standard
                  height: 50.0,
                  // Elevated button solid
                  child: ElevatedButton(
                    // Action tap trigger validation loop
                    onPressed: () {
                      // Mark form as verified once
                      setState(() {
                        // Toggle state check
                        _validated_once = true;
                      });
                      // Verify form validation criteria states
                      if (true == _form_key.currentState!.validate()) {
                        // Pop subpage return back
                        Navigator.of(context).pop();
                        // Show success SnackBar status feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          // SnackBar specs
                          const SnackBar(
                            content:
                                Text('New card saved securely to profile.'),
                          ),
                        );
                      }
                    },
                    // Style matching primary brand blue theme colors
                    style: ElevatedButton.styleFrom(
                      // Blue primary color fill
                      backgroundColor: AppColors.primary_color,
                      // Curves
                      shape: RoundedRectangleBorder(
                        // Rounded radius bounds
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    // Centered CTA label Text
                    child: const Text(
                      // Save Card string
                      'Securely Save Card',
                      // Typography
                      style: TextStyle(
                        // Color white high contrast
                        color: Colors.white,
                        // Medium
                        fontSize: 14.0,
                        // Bold
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builder method generating shadow-decorated input fields matching authentication forms layout
  Widget _build_secure_input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool force_ltr = false,
    bool obscure_text = false,
    TextInputType keyboard_type = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    // Resolve theme brightness modes status
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Stack container layout wrapping positioned shadow box decorator and standard field
    return Stack(
      // Stack children list
      children: [
        // Bottom container supplying shadow offset boundaries
        Positioned(
          // Anchored top
          top: 0.0,
          // Anchored left
          left: 0.0,
          // Anchored right
          right: 0.0,
          // Height constraints matches field height
          height: 50.0,
          // Shadow decorator container
          child: Container(
            // Shadow decoration specs
            decoration: BoxDecoration(
              // Rounded contours
              borderRadius: BorderRadius.circular(25.0),
              // Shadow list
              boxShadow: [
                BoxShadow(
                  // Dynamic shadow opacity matching light/dark configurations
                  color: true == is_dark
                      ? Colors.black.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.03),
                  // Spread
                  blurRadius: 10.0,
                  // Position offset coordinates
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
        // Active editable text field structure
        TextFormField(
          // Controller link
          controller: controller,
          // Obscure CVV typing values status
          obscureText: obscure_text,
          // Keyboard inputs type
          keyboardType: keyboard_type,
          // Forced text direction bounds
          textDirection: true == force_ltr ? TextDirection.ltr : null,
          // Validation delegate callback
          validator: validator,
          // Styles text entry
          style: TextStyle(
            // Size body normal
            fontSize: 13.0,
            // Colors
            color:
                true == is_dark ? Colors.white : AppColors.text_light_primary,
          ),
          // Input decorations settings
          decoration: InputDecoration(
            // Hint string
            hintText: hint,
            // Subdued hint style properties
            hintStyle: const TextStyle(
              // Size
              fontSize: 13.0,
              // Colors secondary
              color: AppColors.text_light_secondary,
            ),
            // Text alignment bounds
            alignLabelWithHint: true,
            // Prefix prefix icon vector
            prefixIcon: Icon(
              // icon
              icon,
              // Colors secondary
              color: AppColors.text_light_secondary,
              // Size standard
              size: 18.0,
            ),
            // Background fill enabled
            filled: true,
            // Background surface color mapping
            fillColor: true == is_dark ? AppColors.surface_dark : Colors.white,
            // Padding offsets details
            contentPadding: const EdgeInsets.symmetric(
              // Horizontal bounds padding offsets
              horizontal: AppSpacing.space_xl,
              // Vertical bounds padding offsets
              vertical: AppSpacing.space_m,
            ),
            // Default border outline contour settings
            border: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(25.0),
              // Thin border line thickness
              borderSide: BorderSide(
                // Color border matching theme
                color: true == is_dark
                    ? AppColors.border_dark
                    : AppColors.border_light.withValues(alpha: 0.5),
                // Thickness thin
                width: 1.0,
              ),
            ),
            // Enabled state borders
            enabledBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(25.0),
              // Thin border line thickness
              borderSide: BorderSide(
                // Color border matching theme
                color: true == is_dark
                    ? AppColors.border_dark
                    : AppColors.border_light.withValues(alpha: 0.5),
                // Thickness thin
                width: 1.0,
              ),
            ),
            // Focused state borders
            focusedBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(25.0),
              // Primary colors brand outline borders
              borderSide: const BorderSide(
                // Colors theme primary
                color: AppColors.primary_color,
                // Thickness double thin
                width: 1.5,
              ),
            ),
            // High-contrast Error state borders outline
            errorBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(25.0),
              // Red error outline borders
              borderSide: const BorderSide(
                // Red error colors
                color: AppColors.error,
                // Thickness double thin
                width: 1.0,
              ),
            ),
            // High-contrast Focused Error state borders outline
            focusedErrorBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(25.0),
              // Red error outline borders
              borderSide: const BorderSide(
                // Red error colors
                color: AppColors.error,
                // Thickness
                width: 1.5,
              ),
            ),
            // Style properties for the error message label
            errorStyle: const TextStyle(
              // Colors red
              color: AppColors.error,
              // Size
              fontSize: 11.0,
              // Semi-bold
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

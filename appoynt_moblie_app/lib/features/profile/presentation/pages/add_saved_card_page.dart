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
// Importing ProfileCubit for saving new payment card
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
// Importing flutter_bloc for read context extension method
import 'package:flutter_bloc/flutter_bloc.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_medium = 12.0;
  static const double border_width_thick = 1.5;
  static const double border_width_thin = 1.0;
  static const double button_height = 50.0;
  static const double spacing_small = 6.0;
  static const double spacing_medium = 12.0;
  static const double spacing_large = 16.0;
  static const double font_size_body = 14.0;
  static const double font_size_medium = 13.0;
  static const double font_size_small = 12.0;
  static const double font_size_tiny = 11.0;
  static const double icon_size_small = 18.0;
  static const double shadow_blur = 10.0;
  static const double shadow_opacity_dark = 0.15;
  static const double shadow_opacity_light = 0.03;
  static const double input_padding_h = 16.0;
  static const double input_padding_v = 14.0;
  static const double bottom_spacing_safe = 80.0;
}

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

  @override
  void initState() {
    super.initState();
    _holder_controller.addListener(_on_fields_changed);
    _number_controller.addListener(_on_fields_changed);
    _expiry_controller.addListener(_on_fields_changed);
    _cvv_controller.addListener(_on_fields_changed);
  }

  void _on_fields_changed() {
    setState(() {});
  }

  // Getter evaluating if all input fields contain valid formats
  bool get _is_form_valid {
    return _validate_cardholder(_holder_controller.text) &&
        _luhn_check(_number_controller.text) &&
        _validate_expiry(_expiry_controller.text) &&
        _validate_cvv(_cvv_controller.text);
  }

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
    _holder_controller.removeListener(_on_fields_changed);
    _number_controller.removeListener(_on_fields_changed);
    _expiry_controller.removeListener(_on_fields_changed);
    _cvv_controller.removeListener(_on_fields_changed);
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
    // Return root Scaffold layout container
    return Scaffold(
      // Body content form layout
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space_xl),
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
                            fontSize: _LocalDimensions.font_size_small,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Gap spacer height
                        const SizedBox(height: _LocalDimensions.spacing_small),
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
                            if (null == val ||
                                false == _validate_cardholder(val)) {
                              // Return strict validation error
                              return 'Please enter the full name as written on the card.';
                            }
                            // Valid status
                            return null;
                          },
                        ),
                        // Height spacer gap
                        const SizedBox(height: _LocalDimensions.spacing_large),

                        // Section Title: Card Number
                        const Text(
                          // Label card number
                          'Card Number',
                          // Style specs
                          style: TextStyle(
                            fontSize: _LocalDimensions.font_size_small,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Gap spacer height
                        const SizedBox(height: _LocalDimensions.spacing_small),
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
                                      fontSize: _LocalDimensions.font_size_small,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Spacer height gap
                                  const SizedBox(height: _LocalDimensions.spacing_small),
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
                            const SizedBox(width: _LocalDimensions.spacing_medium),
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
                                      fontSize: _LocalDimensions.font_size_small,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Spacer height gap
                                  const SizedBox(height: _LocalDimensions.spacing_small),
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
                                      if (null == val ||
                                          false == _validate_cvv(val)) {
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
                        const SizedBox(height: _LocalDimensions.bottom_spacing_safe),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: SizedBox(
          // Full width
          width: double.infinity,
          // Height dimensions standard
          height: _LocalDimensions.button_height,
          // Elevated button solid
          child: ElevatedButton(
            // Action tap trigger validation loop
            onPressed: _is_form_valid
                ? () {
                    // Mark form as verified once
                    setState(() {
                      // Toggle state check
                      _validated_once = true;
                    });
                    // Verify form validation criteria states
                    if (true == _form_key.currentState!.validate()) {
                      final String raw_num = _number_controller.text.trim();
                      // Format with 4-digit grouping if it's just raw digits
                      String formatted_num = raw_num.replaceAll(' ', '');
                      final String brand = formatted_num.startsWith('4')
                          ? 'Visa'
                          : (formatted_num.startsWith('5')
                              ? 'Mastercard'
                              : 'Visa');

                      // Ensure 4-digit grouping spacing
                      final StringBuffer sb = StringBuffer();
                      for (int i = 0; i < formatted_num.length; i++) {
                        if (i > 0 && i % 4 == 0) {
                          sb.write(' ');
                        }
                        sb.write(formatted_num[i]);
                      }
                      formatted_num = sb.toString();

                      final Map<String, dynamic> card_data = {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'brand': brand,
                        'number': formatted_num,
                        'expiry': _expiry_controller.text.trim(),
                        'holder': _holder_controller.text.trim(),
                        'is_default': 'false',
                      };

                      // Dispatch add_payment_card on cubit context
                      context.read<ProfileCubit>().add_payment_card(card_data);

                      // Pop subpage return back
                      Navigator.of(context).pop();
                      // Show success SnackBar status feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        // SnackBar specs
                        const SnackBar(
                          content: Text('New card saved securely to profile.'),
                        ),
                      );
                    }
                  }
                : null,
            // Style matching primary brand blue theme colors dynamically based on validity state
            style: ElevatedButton.styleFrom(
              // Muted grey background when disabled, solid primary blue when enabled
              backgroundColor: _is_form_valid
                  ? AppColors.primary_color
                  : AppColors.slate_200,
              disabledBackgroundColor: AppColors.slate_200,
              foregroundColor: AppColors.white,
              disabledForegroundColor: AppColors.slate_400,
              elevation: _is_form_valid ? 2.0 : 0.0,
              // Curves
              shape: RoundedRectangleBorder(
                // Rounded radius bounds
                borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              ),
            ),
            // Centered CTA label Text
            child: Text(
              // Save Card string
              'Securely Save Card',
              // Typography
              style: TextStyle(
                // Color white high contrast when enabled, subtle gray when disabled
                color: _is_form_valid ? AppColors.white : AppColors.slate_400,
                // Medium
                fontSize: _LocalDimensions.font_size_body,
                // Bold
                fontWeight: FontWeight.bold,
              ),
            ),
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
          height: _LocalDimensions.button_height,
          // Shadow decorator container
          child: Container(
            // Shadow decorator container
            decoration: BoxDecoration(
              // Rounded contours
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              // Shadow list
              boxShadow: [
                BoxShadow(
                  // Dynamic shadow opacity matching light/dark configurations
                  color: is_dark
                      ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                      : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                  // Spread
                  blurRadius: _LocalDimensions.shadow_blur,
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
            fontSize: _LocalDimensions.font_size_medium,
            // Colors
            color:
                is_dark ? AppColors.white : AppColors.text_light_primary,
          ),
          // Input decorations settings
          decoration: InputDecoration(
            // Hint string
            hintText: hint,
            // Subdued hint style properties
            hintStyle: const TextStyle(
              // Size
              fontSize: _LocalDimensions.font_size_medium,
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
              size: _LocalDimensions.icon_size_small,
            ),
            // Background fill enabled
            filled: true,
            // Background surface color mapping
            fillColor: is_dark ? AppColors.surface_dark : AppColors.white,
            // Padding offsets details
            contentPadding: const EdgeInsets.symmetric(
              // Horizontal bounds padding offsets
              horizontal: _LocalDimensions.input_padding_h,
              // Vertical bounds padding offsets
              vertical: _LocalDimensions.input_padding_v,
            ),
            // Default border outline contour settings
            border: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              // Thin border line thickness
              borderSide: BorderSide(
                // Color border matching theme
                color: is_dark
                    ? AppColors.border_dark
                    : AppColors.slate_200,
                // Thickness thin
                width: _LocalDimensions.border_width_thin,
              ),
            ),
            // Enabled state borders
            enabledBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              // Thin border line thickness
              borderSide: BorderSide(
                // Color border matching theme
                color: is_dark
                    ? AppColors.border_dark
                    : AppColors.slate_200,
                // Thickness thin
                width: _LocalDimensions.border_width_thin,
              ),
            ),
            // Focused state borders
            focusedBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              // Primary colors brand outline borders
              borderSide: const BorderSide(
                // Colors theme primary
                color: AppColors.primary_color,
                // Thickness double thin
                width: _LocalDimensions.border_width_thick,
              ),
            ),
            // High-contrast Error state borders outline
            errorBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              // Red error outline borders
              borderSide: const BorderSide(
                // Red error colors
                color: AppColors.error,
                // Thickness double thin
                width: _LocalDimensions.border_width_thin,
              ),
            ),
            // High-contrast Focused Error state borders outline
            focusedErrorBorder: OutlineInputBorder(
              // Rounded contours
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              // Red error outline borders
              borderSide: const BorderSide(
                // Red error colors
                color: AppColors.error,
                // Thickness
                width: _LocalDimensions.border_width_thick,
              ),
            ),
            // Style properties for the error message label
            errorStyle: const TextStyle(
              // Colors red
              color: AppColors.error,
              // Size
              fontSize: _LocalDimensions.font_size_tiny,
              // Semi-bold
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

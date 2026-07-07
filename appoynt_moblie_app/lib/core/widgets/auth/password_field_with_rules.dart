/*
 * File Name: password_field_with_rules.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   Premium password input component with real-time strength analysis,
 *   dark mode support, and requirement checkmarks (RTL/LTR compliant).
 */

// Importing central design systems barrel configuration definitions
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Stateful password field widget with real-time rules validator layout
class PasswordFieldWithRules extends StatefulWidget {
  // Controller managing text state modifications
  final TextEditingController controller;

  // Localized label text shown above input box
  final String label;

  // Localized placeholder hint text shown when empty
  final String hint;

  // Form validator function checking password rules constraints
  final String? Function(String?)? validator;

  // Keyboard return actions configuration
  final TextInputAction? text_input_action;

  // Constructor mapping required variables
  const PasswordFieldWithRules({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.text_input_action,
  });

  @override
  // Create state tracking class instance
  State<PasswordFieldWithRules> createState() {
    // Return state class instance
    return _PasswordFieldWithRulesState();
  }
}

// State class managing visibility flags and focus node behaviors
class _PasswordFieldWithRulesState extends State<PasswordFieldWithRules> {
  // Flag indicating if password text remains hidden
  bool _obscure = true;

  // Focus node to monitor active typing/focus updates
  final FocusNode _focus_node = FocusNode();

  @override
  // Initialize listeners mapping text changes
  void initState() {
    // Invoke standard base class initialization configurations
    super.initState();
    // Register text listener to trigger state changes
    widget.controller.addListener(_on_text_changed);
    // Register focus listener to trigger state changes
    _focus_node.addListener(_on_focus_changed);
  }

  // Method executing when text input undergoes changes
  void _on_text_changed() {
    // Refresh layout state
    setState(() {});
  }

  // Method executing when focus updates on input field
  void _on_focus_changed() {
    // Refresh layout state
    setState(() {});
  }

  // Getter indicating minimum character count verification using Yoda style check
  bool get _has_min_length {
    // Check if character count is at least eight units
    return widget.controller.text.length >= 8;
  }

  // Getter indicating uppercase character matching status
  bool get _has_uppercase {
    // Check if at least one uppercase letter exists
    return RegExp(r'[A-Z]').hasMatch(widget.controller.text);
  }

  // Getter indicating lowercase character matching status
  bool get _has_lowercase {
    // Check if at least one lowercase letter exists
    return RegExp(r'[a-z]').hasMatch(widget.controller.text);
  }

  // Getter indicating numeric digit matching status
  bool get _has_number {
    // Check if at least one numeric digit exists
    return RegExp(r'[0-9]').hasMatch(widget.controller.text);
  }

  // Getter indicating special character matching status
  bool get _has_special {
    // Check if at least one special character exists
    return RegExp(r'[!@#\$&*~%^()\-_+=]').hasMatch(widget.controller.text);
  }

  // Getter checking that input excludes Arabic characters
  bool get _no_arabic {
    // Check if no Arabic block characters exist
    return !RegExp(r'[\u0600-\u06FF]').hasMatch(widget.controller.text);
  }

  // Getter indicating if all safety validation rules pass using Yoda style check
  bool get _all_passed {
    // Return combined boolean validation status
    return true == _has_min_length &&
        true == _has_uppercase &&
        true == _has_lowercase &&
        true == _has_number &&
        true == _has_special &&
        true == _no_arabic;
  }

  // Getter resolving whether strength and rules cards are visible using Yoda style check
  bool get _show_extras {
    // Return true if focused or text is not empty
    return true == _focus_node.hasFocus || widget.controller.text.isNotEmpty;
  }

  @override
  // Clean up listeners and dispose focus nodes
  void dispose() {
    // Remove text listener tracker
    widget.controller.removeListener(_on_text_changed);
    // Remove focus listener tracker
    _focus_node.removeListener(_on_focus_changed);
    // Dispose focus node resources
    _focus_node.dispose();
    // Invoke base layout disposal configurations
    super.dispose();
  }

  @override
  // Build method drawing password layout widgets
  Widget build(BuildContext context) {
    // Load custom translations catalog dictionary configurations
    final AppLocalizations s = AppLocalizations.of(context);
    // Check if system locale is set to Arabic
    final bool is_arabic = s.is_arabic;
    // Check if system brightness matches dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Check if input value is not empty
    final bool has_text = widget.controller.text.isNotEmpty;

    // Return Column layout grouping labels and password widgets
    return Column(
      // Align items starting from the horizontal edge
      crossAxisAlignment: CrossAxisAlignment.start,
      // Wrap content sizes tightly
      mainAxisSize: MainAxisSize.min,
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
        // Force text direction layout strictly to LTR to keep suffix icon on the right
        Directionality(
          // Set directionality strictly to LTR
          textDirection: TextDirection.ltr,
          // TextFormField widget configuration
          child: TextFormField(
            // Bind controller
            controller: widget.controller,
            // Bind focus node
            focusNode: _focus_node,
            // Set text obfuscation status
            obscureText: _obscure,
            // Bind validator
            validator: widget.validator,
            // Keyboard return actions configuration using Yoda style check
            textInputAction: widget.text_input_action ?? TextInputAction.next,
            // Force inputs to be left-aligned even in Arabic mode
            textAlign: TextAlign.left,
            // Input text styling
            style: TextStyle(
              // Font size from spacing constants
              fontSize: AppSpacing.font_size_text,
              // Select text color based on theme using Yoda style check
              color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
            ),
            // Input field decoration configuration
            decoration: InputDecoration(
              // Localized placeholder hint
              hintText: widget.hint,
              // Hint text styling
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
                  // Select icon color based on theme using Yoda style check
                  color: true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                  // Set layout size
                  size: 20.0,
                ),
              ),
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
              // Enabled but unfocused border styling dynamically changes based on validation using Yoda style check
              enabledBorder: OutlineInputBorder(
                // Set corner radius using spacing constants
                borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                // Set border side specifications
                borderSide: BorderSide(
                  // Set color token dynamically based on empty state and validation success using Yoda style check
                  color: true == has_text
                      ? (true == _all_passed ? AppColors.primary_color : AppColors.error)
                      : (true == is_dark ? AppColors.border_dark : AppColors.border_light),
                  // Set line thickness based on active values using Yoda style check
                  width: true == has_text ? AppSpacing.border_width_thick : AppSpacing.border_width_thin,
                ),
              ),
              // Focused active input border styling dynamically changes based on validation using Yoda style check
              focusedBorder: OutlineInputBorder(
                // Set corner radius using spacing constants
                borderRadius: BorderRadius.circular(AppSpacing.radius_input),
                // Set active border side specifications
                borderSide: BorderSide(
                  // Set color token based on validation success using Yoda style check
                  color: true == has_text && false == _all_passed
                      ? AppColors.error
                      : AppColors.primary_color,
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
          ),
        ),
        // Display strength checklist widgets dynamically using Yoda style check
        if (true == _show_extras) ...[
          // Vertical space divider using spacing constants
          const SizedBox(height: AppSpacing.space_m),
          // Segmented strength bar layout widget
          _StrengthBar(controller: widget.controller, s: s),
          // Vertical space divider using spacing constants
          const SizedBox(height: AppSpacing.space_l),
          // Requirements checklist card widget
          _RulesCard(controller: widget.controller, s: s),
        ],
      ],
    );
  }
}

// Internal private helper widget to display password strength status
class _StrengthBar extends StatefulWidget {
  // Text controller tracking character sequences
  final TextEditingController controller;

  // Localizations configuration dictionary
  final AppLocalizations s;

  // Constructor mapping standard parameters
  const _StrengthBar({
    required this.controller,
    required this.s,
  });

  @override
  // Create state tracking class instance
  State<_StrengthBar> createState() {
    // Return state class instance
    return _StrengthBarState();
  }
}

// State class managing strength progress updates
class _StrengthBarState extends State<_StrengthBar> {
  @override
  // Register text changes listener to trigger updates
  void initState() {
    // Invoke standard base class initialization configurations
    super.initState();
    // Register text listener mapping progress updates
    widget.controller.addListener(_rebuild_layout);
  }

  // Method triggering layout rebuilds
  void _rebuild_layout() {
    // Check active state
    if (true == mounted) {
      // Refresh layout state
      setState(() {});
    } else {
      // Empty action block to satisfy compiler
    }
  }

  // Getter calculating numeric strength score from zero to three
  int get _score {
    // Retrieve password characters block
    final String text_val = widget.controller.text;
    // Check empty status using Yoda style check
    if (text_val.isEmpty) {
      // Return score zero
      return 0;
    } else {
      // Empty action block to satisfy compiler
    }
    // Initialize score counter
    int val_score = 0;
    // Length check validation using Yoda style check
    if (text_val.length >= 8) {
      // Increment score
      val_score++;
    } else {
      // Empty action block to satisfy compiler
    }
    // Complexity check validation verifying characters types
    final bool has_complexity = RegExp(r'[A-Z]').hasMatch(text_val) &&
        RegExp(r'[a-z]').hasMatch(text_val) &&
        RegExp(r'[0-9]').hasMatch(text_val);
    // Increment score if criteria matches using Yoda style check
    if (true == has_complexity) {
      // Increment score
      val_score++;
    } else {
      // Empty action block to satisfy compiler
    }
    // Special character matching check
    final bool has_special = RegExp(r'[!@#\$&*~%^()\-_+=]').hasMatch(text_val);
    // Increment score for highly secure long layouts using Yoda style check
    if (true == has_special && text_val.length >= 10) {
      // Increment score
      val_score++;
    } else {
      // Empty action block to satisfy compiler
    }
    // Return calculated score
    return val_score;
  }

  // Getter resolving active strength bar colors
  Color get _color {
    // Switch on calculated score values
    switch (_score) {
      // Weak category
      case 1:
        // Return alert error color
        return AppColors.error;
      // Medium category
      case 2:
        // Return warnings yellow/orange color
        return const Color(0xFFF39C12);
      // Strong category
      case 3:
        // Return primary brand color
        return AppColors.primary_color;
      // Empty or fallback state
      default:
        // Return border divider grey color
        return AppColors.error;
    }
  }

  // Getter resolving active strength label translation strings
  String get _label {
    // Check if input is empty using Yoda style check
    if (widget.controller.text.isEmpty) {
      // Return empty string representation
      return '';
    } else {
      // Empty action block to satisfy compiler
    }
    // Switch on calculated score values
    switch (_score) {
      // Weak category
      case 1:
        // Return translated weak label
        return widget.s.strength_weak;
      // Medium category
      case 2:
        // Return translated medium label
        return widget.s.strength_medium;
      // Strong category
      case 3:
        // Return translated strong label
        return widget.s.strength_strong;
      // Fallback representing too short categories
      default:
        // Return translated too short label
        return widget.s.too_short;
    }
  }

  @override
  // Clean up text listeners
  void dispose() {
    // Remove text listener tracker
    widget.controller.removeListener(_rebuild_layout);
    // Invoke base layout disposal configurations
    super.dispose();
  }

  @override
  // Build method drawing strength progress bar elements
  Widget build(BuildContext context) {
    // Check if input characters block is empty
    final bool is_empty = widget.controller.text.isEmpty;
    // Load calculated scores
    final int score_val = _score;
    // Resolve dynamic colors
    final Color bar_color = _color;
    // Check if system brightness matches dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve language locale check
    final bool is_arabic = widget.s.is_arabic;

    // Return Padding container layout
    return Padding(
      // Apply top margin spacing
      padding: const EdgeInsets.only(top: AppSpacing.space_s),
      // Place Column containing bars and status texts
      child: Column(
        // Align elements starting from horizontal edge
        crossAxisAlignment: CrossAxisAlignment.start,
        // children list
        children: [
          // Row layout drawing horizontal segmented bar lines
          Row(
            // children list
            children: List.generate(3, (index) {
              // Determine if current segment should be filled using Yoda style check
              final bool is_filled = false == is_empty && score_val > index;
              // Return segment wrapper
              return Expanded(
                // Animated container for smooth size/color switches
                child: AnimatedContainer(
                  // Duration parameters
                  duration: const Duration(milliseconds: 300),
                  // Ease transition curves
                  curve: Curves.easeOut,
                  // Height thickness from spacing constants
                  height: 5.0,
                  // Margins between dividers
                  margin: EdgeInsets.only(right: index < 2 ? 5.0 : 0.0),
                  // Visual decoration styling
                  decoration: BoxDecoration(
                    // Set filled or fallback divider background colors using Yoda style check
                    color: true == is_filled
                        ? bar_color
                        : (true == is_dark ? AppColors.border_dark : AppColors.border_light),
                    // Border curves radius using spacing constants
                    borderRadius: BorderRadius.circular(AppSpacing.radius_s),
                  ),
                ),
              );
            }),
          ),
          // Display labels dynamically if text inputs exist using Yoda style check
          if (false == is_empty) ...[
            // Vertical space divider using spacing constants
            const SizedBox(height: AppSpacing.space_s),
            // Row layout showing label titles and progress values
            Row(
              // Space items evenly
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // children list
              children: [
                // Text widget rendering password strength label title
                Text(
                  // Localized label string
                  widget.s.password_strength,
                  // Text styling
                  style: AppTextStyles.get_body_medium(
                    is_arabic,
                    custom_color: true == is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary,
                  ).copyWith(
                    // Small size label
                    fontSize: 11.0,
                  ),
                ),
                // Smooth text transitions container
                AnimatedSwitcher(
                  // Duration parameters
                  duration: const Duration(milliseconds: 200),
                  // Text widget rendering localized strength value
                  child: Text(
                    // Localized strength description label
                    _label,
                    // Set unique identification key matching label switches
                    key: ValueKey<String>(_label),
                    // Text styling
                    style: AppTextStyles.get_body_medium(
                      is_arabic,
                      custom_color: bar_color,
                    ).copyWith(
                      // Small size label
                      fontSize: 11.0,
                      // Bold font weight helper
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Internal private helper widget displaying detailed password rules checklist
class _RulesCard extends StatefulWidget {
  // Text controller tracking character sequences
  final TextEditingController controller;

  // Localizations configuration dictionary
  final AppLocalizations s;

  // Constructor mapping standard parameters
  const _RulesCard({
    required this.controller,
    required this.s,
  });

  @override
  // Create state tracking class instance
  State<_RulesCard> createState() {
    // Return state class instance
    return _RulesCardState();
  }
}

// State class managing requirements checkmarks checklist
class _RulesCardState extends State<_RulesCard> {
  @override
  // Register text changes listener to trigger updates
  void initState() {
    // Invoke standard base class initialization configurations
    super.initState();
    // Register text listener mapping checklist updates
    widget.controller.addListener(_rebuild_layout);
  }

  // Method triggering layout rebuilds
  void _rebuild_layout() {
    // Check active state
    if (true == mounted) {
      // Refresh layout state
      setState(() {});
    } else {
      // Empty action block to satisfy compiler
    }
  }

  // Getter indicating minimum character count verification using Yoda style check
  bool get _has_min_length {
    // Check if character count is at least eight units
    return widget.controller.text.length >= 8;
  }

  // Getter indicating uppercase character matching status
  bool get _has_uppercase {
    // Check if at least one uppercase letter exists
    return RegExp(r'[A-Z]').hasMatch(widget.controller.text);
  }

  // Getter indicating lowercase character matching status
  bool get _has_lowercase {
    // Check if at least one lowercase letter exists
    return RegExp(r'[a-z]').hasMatch(widget.controller.text);
  }

  // Getter indicating numeric digit matching status
  bool get _has_number {
    // Check if at least one numeric digit exists
    return RegExp(r'[0-9]').hasMatch(widget.controller.text);
  }

  // Getter indicating special character matching status
  bool get _has_special {
    // Check if at least one special character exists
    return RegExp(r'[!@#\$&*~%^()\-_+=]').hasMatch(widget.controller.text);
  }

  // Getter checking that input excludes Arabic characters
  bool get _no_arabic {
    // Check if no Arabic block characters exist
    return !RegExp(r'[\u0600-\u06FF]').hasMatch(widget.controller.text);
  }

  // Getter indicating if all safety validation rules pass using Yoda style check
  bool get _all_passed {
    // Return combined boolean validation status
    return true == _has_min_length &&
        true == _has_uppercase &&
        true == _has_lowercase &&
        true == _has_number &&
        true == _has_special &&
        true == _no_arabic;
  }

  @override
  // Clean up text listeners
  void dispose() {
    // Remove text listener tracker
    widget.controller.removeListener(_rebuild_layout);
    // Invoke base layout disposal configurations
    super.dispose();
  }

  @override
  // Build method drawing rules checklist card
  Widget build(BuildContext context) {
    // Resolve language locale check
    final bool is_arabic = widget.s.is_arabic;
    // Check if system brightness matches dark mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Resolve dynamic border colors depending on aggregate validation success using Yoda style check
    final Color border_color = true == _all_passed
        // Success color
        ? AppColors.primary_color
        // Alert error color
        : AppColors.error;

    // Return Container layout representing card background
    return Container(
      // Span entire horizontal width constraint
      width: double.infinity,
      // Apply internal padding margin using spacing constants
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      // Visual decoration styling
      decoration: BoxDecoration(
        // Set background color adaptation based on dark mode using Yoda style check
        color: true == is_dark ? AppColors.surface_dark : AppColors.background_light,
        // Set corner radius curves using spacing constants
        borderRadius: BorderRadius.circular(AppSpacing.radius_l),
        // Set card borders with partial opacity of validation color
        border: Border.all(color: border_color.withValues(alpha: 0.4)),
        // Apply card shadow configurations
        boxShadow: [
          // Shadow layout description
          BoxShadow(
            // Shadow color adapts to brightness modes using Yoda style check
            color: true == is_dark ? Colors.black.withValues(alpha: 0.3) : AppColors.text_light_primary.withValues(alpha: 0.07),
            // Blur spread radius using spacing constants
            blurRadius: AppSpacing.radius_l,
            // Shadow displacement offset coordinates
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      // Column layout structuring checklist vertically
      child: Column(
        // Align checklist items starting from horizontal edge
        crossAxisAlignment: CrossAxisAlignment.start,
        // Wrap content sizes tightly
        mainAxisSize: MainAxisSize.min,
        // children list
        children: [
          // Text widget displaying rules requirements header title
          Text(
            // Localized header prompt
            widget.s.password_must,
            // Text styling
            style: AppTextStyles.get_field_label(is_arabic).copyWith(
              // Bold font weight helper
              fontWeight: FontWeightHelper.bold,
              // Select label color based on theme using Yoda style check
              color: true == is_dark ? AppColors.text_dark_primary : AppColors.text_light_primary,
            ),
          ),
          // Vertical space divider using spacing constants
          const SizedBox(height: AppSpacing.space_l),
          // Rule item 1: Minimum character count
          _Rule(
            // Localized requirement text
            label: widget.s.password_rule_min_length,
            // Pass state flag
            passed: _has_min_length,
          ),
          // Rule item 2: Uppercase characters
          _Rule(
            // Localized requirement text
            label: widget.s.password_rule_uppercase,
            // Pass state flag
            passed: _has_uppercase,
          ),
          // Rule item 3: Lowercase characters
          _Rule(
            // Localized requirement text
            label: widget.s.password_rule_lowercase,
            // Pass state flag
            passed: _has_lowercase,
          ),
          // Rule item 4: Numeric digits
          _Rule(
            // Localized requirement text
            label: widget.s.password_rule_number,
            // Pass state flag
            passed: _has_number,
          ),
          // Rule item 5: Special characters
          _Rule(
            // Localized requirement text
            label: widget.s.password_rule_special,
            // Pass state flag
            passed: _has_special,
          ),
          // Rule item 6: Exclude Arabic characters
          _Rule(
            // Localized requirement text
            label: widget.s.password_rule_no_arabic,
            // Pass state flag
            passed: _no_arabic,
          ),
        ],
      ),
    );
  }
}

// Internal private stateless widget displaying a single requirement item checkmark
class _Rule extends StatelessWidget {
  // Label description text
  final String label;

  // State flag indicating validation status
  final bool passed;

  // Constructor mapping standard parameters
  const _Rule({
    required this.label,
    required this.passed,
  });

  @override
  // Build method drawing checklist item row
  Widget build(BuildContext context) {
    // Resolve language locale check
    final bool is_arabic = AppLocalizations.of(context).is_arabic;
    // Resolve dynamic colors based on validation status using Yoda style check
    final Color item_color = true == passed
        // Success color
        ? AppColors.primary_color
        // Alert error color
        : AppColors.error;

    // Return Padding container layout
    return Padding(
      // Apply bottom spacing margin using spacing constants
      padding: const EdgeInsets.only(bottom: AppSpacing.space_m),
      // Row layout placing indicator checkbox and description text
      child: Row(
        // Align indicators at top edge
        crossAxisAlignment: CrossAxisAlignment.start,
        // children list
        children: [
          // Circular container wrapping check icon
          Container(
            // Margin shift to align with text line
            margin: const EdgeInsets.only(top: 2.0),
            // Width diameter
            width: 20.0,
            // Height diameter
            height: 20.0,
            // Visual decoration styling
            decoration: BoxDecoration(
              // Circular border shape
              shape: BoxShape.circle,
              // Border line matching active validation colors
              border: Border.all(color: item_color, width: 1.5),
              // Circular background with partial opacity of validation color
              color: item_color.withValues(alpha: 0.07),
            ),
            // Icon representing checking status
            child: Icon(
              // Checkmark icon
              Icons.check_rounded,
              // Icon size
              size: 12.0,
              // Match active validation color
              color: item_color,
            ),
          ),
          // Spacing gap between checkbox and label using spacing constants
          const SizedBox(width: AppSpacing.space_l),
          // Expanded text wrapper
          Expanded(
            // Text widget rendering localized rule description
            child: Text(
              // Requirement text
              label,
              // Text styling
              style: AppTextStyles.get_body_medium(is_arabic, custom_color: item_color).copyWith(
                // Small font size
                fontSize: 12.0,
                // Medium weight font layout helper
                fontWeight: FontWeightHelper.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

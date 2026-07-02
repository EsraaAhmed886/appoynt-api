/*
 * File Name: global_language_button.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/05/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Renders the language toggle dropdown popup menu capsule.
 */

// Importing central routing and UI definitions barrel file
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

// Stateless widget rendering the dynamic language selection capsule dropdown
class GlobalLanguageButton extends StatelessWidget {
  // Flag indicating if Arabic is currently active
  final bool is_arabic;

  // Callback function triggered when a new language is selected
  final VoidCallback on_tap;

  // Option configuration toggling if colors adapt for dark backgrounds
  final bool light;

  // Constructor initializing configuration values
  const GlobalLanguageButton({
    super.key,
    required this.is_arabic,
    required this.on_tap,
    this.light = false,
  });

  @override
  // Build method creating the language toggle widget elements
  Widget build(BuildContext context) {
    // Fetch dynamically resolved localized font name
    final String font_family = AppFonts.by_locale(is_arabic);

    // Load custom translations catalog dictionary configurations
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Resolve color indicator for button elements based on light option check using Yoda style
    final Color icon_color = true == light
        // Set icon to white for dark backgrounds
        ? Colors.white
        // Set icon to primary text color
        : AppColors.text_light_primary;

    // Resolve background fill color configurations using Yoda style check
    final Color bg_color = true == light
        // Transparent white background capsule overlay
        ? Colors.white.withValues(alpha: 0.15)
        // Completely transparent fallback
        : Colors.transparent;

    // Resolve capsule border line color configurations using Yoda style check
    final Color border_color = true == light
        // Subtly visible white line
        ? Colors.white.withValues(alpha: 0.35)
        // Completely transparent fallback
        : Colors.transparent;

    // Resolve active language short label based on locale direction check using Yoda style
    final String current_label = true == is_arabic
        // Arabic code label
        ? localizations.language_code_ar
        // English code label
        : localizations.language_code_en;

    // Resolve active language full name spelling based on locale direction check using Yoda style
    final String current_full = true == is_arabic
        // Arabic full name spelling
        ? localizations.language_name_ar
        // English full name spelling
        : localizations.language_name_en;

    // Resolve alternate language short label based on locale direction check using Yoda style
    final String other_label = true == is_arabic
        // English code label
        ? localizations.language_code_en
        // Arabic code label
        : localizations.language_code_ar;

    // Resolve alternate language full name spelling based on locale direction check using Yoda style
    final String other_full = true == is_arabic
        // English full name spelling
        ? localizations.language_name_en
        // Arabic full name spelling
        : localizations.language_name_ar;

    // Return PopupMenuButton rendering the dropdown selections list
    return PopupMenuButton<String>(
      // Offset position to place dropdown list below capsule
      offset: const Offset(0.0, 36.0),
      // Apply primary surface color setting to dropdown background card
      color: Colors.white,
      // Set dropdown shadow depth representation
      elevation: 8.0,
      // Apply rounded container borders to dropdown shape
      shape: RoundedRectangleBorder(
        // Set border corners radius
        borderRadius: BorderRadius.circular(AppSpacing.radius_l),
        // Draw thin container line borders
        side: BorderSide(
          // Set border line color
          color: AppColors.border_light.withValues(alpha: 0.5),
        ),
      ),
      // Event handler triggered upon item selection
      onSelected: (String selected_value) {
        // Trigger callback only if selection changes using Yoda style check
        if (selected_value != current_label) {
          // Fire configuration toggle logic callback
          on_tap();
        } else {
          // Do nothing since selection has not changed
        }
      },
      // Item builder drawing selection list widgets
      itemBuilder: (BuildContext inner_context) {
        // Return dropdown item widgets list array
        return [
          // PopupMenuItem configuration for active language choice
          PopupMenuItem<String>(
            // Value representation key
            value: current_label,
            // Display row structure nesting indicators and labels
            child: Row(
              // Place children inside list
              children: [
                // Globe iconography indicator
                const Icon(
                  // Set standard language globe icon
                  Icons.language_rounded,
                  // Set dimensions size
                  size: 16.0,
                  // Set brand primary color
                  color: AppColors.primary_color,
                ),
                // Horizontal spacing divider
                const SizedBox(width: 8.0),
                // Text widget rendering current code label
                Text(
                  // Display code label
                  current_label,
                  // Custom text styling options
                  style: TextStyle(
                    // Set localized font family
                    fontFamily: font_family,
                    // Set standard size
                    fontSize: 14.0,
                    // Apply bold weight
                    fontWeight: FontWeight.w700,
                    // Apply primary color
                    color: AppColors.primary_color,
                  ),
                ),
                // Horizontal spacing divider
                const SizedBox(width: 6.0),
                // Text widget rendering active spelling name
                Text(
                  // Display active name spelling
                  current_full,
                  // Custom text styling options
                  style: const TextStyle(
                    // Set size
                    fontSize: 13.0,
                    // Apply secondary color
                    color: AppColors.text_light_secondary,
                  ),
                ),
                // Spacer separating name from check indicator
                const Spacer(),
                // Check mark validation indicator icon
                const Icon(
                  // Set check indicator icon
                  Icons.check_rounded,
                  // Set dimensions size
                  size: 16.0,
                  // Set brand primary color
                  color: AppColors.primary_color,
                ),
              ],
            ),
          ),
          // Separator line splitting choices
          const PopupMenuDivider(height: 1.0),
          // PopupMenuItem configuration for alternate language choice
          PopupMenuItem<String>(
            // Value representation key
            value: other_label,
            // Display row structure nesting indicators and labels
            child: Row(
              // Place children inside list
              children: [
                // Globe iconography indicator
                const Icon(
                  // Set standard language globe icon
                  Icons.language_rounded,
                  // Set dimensions size
                  size: 16.0,
                  // Set secondary color
                  color: AppColors.text_light_secondary,
                ),
                // Horizontal spacing divider
                const SizedBox(width: 8.0),
                // Text widget rendering alternative code label
                Text(
                  // Display alternative label
                  other_label,
                  // Custom text styling options
                  style: TextStyle(
                    // Set localized font family
                    fontFamily: font_family,
                    // Set standard size
                    fontSize: 14.0,
                    // Apply bold weight
                    fontWeight: FontWeight.w700,
                    // Apply primary color
                    color: AppColors.text_light_primary,
                  ),
                ),
                // Horizontal spacing divider
                const SizedBox(width: 6.0),
                // Text widget rendering alternative spelling name
                Text(
                  // Display name spelling
                  other_full,
                  // Custom text styling options
                  style: const TextStyle(
                    // Set size
                    fontSize: 13.0,
                    // Apply secondary color
                    color: AppColors.text_light_secondary,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      // Target capsule button widget rendering the active selection
      child: Container(
        // Capsule inner padding margins
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        // Box decoration styling borders and colors
        decoration: BoxDecoration(
          // Apply resolved background fill color
          color: bg_color,
          // Apply rounded borders capsule shape
          borderRadius: BorderRadius.circular(20.0),
          // Apply capsule line borders
          border: Border.all(
            // Set border line color
            color: border_color,
            // Set line thickness
            width: 1.0,
          ),
        ),
        // Row layout structuring capsule contents
        child: Row(
          // Wrap visual widgets tightly
          mainAxisSize: MainAxisSize.min,
          // Place children elements inside list
          children: [
            // Globe icon wrapper
            Icon(
              // Set language icon
              Icons.language_rounded,
              // Set dimensions size
              size: 18.0,
              // Apply resolved color token
              color: icon_color,
            ),
            // Horizontal spacing divider
            const SizedBox(width: 5.0),
            // Text widget displaying the short code label
            Text(
              // Display code label
              current_label,
              // Custom text styling options
              style: TextStyle(
                // Set localized font family
                fontFamily: font_family,
                // Set standard size
                fontSize: 14.0,
                // Apply bold weight
                fontWeight: FontWeight.w700,
                // Apply resolved color token
                color: icon_color,
              ),
            ),
            // Horizontal spacing divider
            const SizedBox(width: 3.0),
            // Dropdown down arrow indicator icon
            Icon(
              // Set arrow down icon
              Icons.arrow_drop_down_rounded,
              // Set dimensions size
              size: 16.0,
              // Apply resolved color token
              color: icon_color,
            ),
          ],
        ),
      ),
    );
  }
}

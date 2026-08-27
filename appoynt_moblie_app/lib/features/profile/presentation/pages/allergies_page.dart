/*
 * File Name: allergies_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_text_field.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Redesigned Medical Allergies page with master switch, modular category cards, quick-add chips, and severity-coded tags.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing localizations and design tokens
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing AuthTextField component
import 'package:appoynt_mobile_app/core/widgets/auth/auth_text_field.dart';
// Importing Cubit controller and state
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double disabled_opacity = 0.45;
  static const double border_radius_default = 16.0;
  static const double border_radius_medium = 12.0;
  static const double border_radius_large = 20.0;
  static const double shadow_blur_default = 8.0;
  static const double shadow_offset_y = 2.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.04;
  static const double icon_size_large = 36.0;
  static const double icon_size_small = 20.0;
  static const double spacing_small = 8.0;
  static const double spacing_medium = 10.0;
  static const double spacing_large = 12.0;
  static const double font_size_medium = 14.0;
  static const double font_size_small = 12.0;
  static const double font_size_tiny = 11.0;
  static const double font_size_micro = 10.0;
  static const double image_size = 50.0;
  static const double spacing_tiny = 6.0;
  static const double spacing_micro = 4.0;
  static const double chip_border_width = 1.0;
  static const double dot_size = 8.0;
  static const double severity_icon_size = 16.0;
  static const double border_width_thick = 2.0;
  static const double border_width_thin = 1.0;
  static const double icon_container_size = 40.0;
  static const double icon_size_medium = 22.0;
}

// Allergies Page layout stateful widget representation
class AllergiesPage extends StatefulWidget {
  // Constructor mapping key
  const AllergiesPage({super.key});

  @override
  State<AllergiesPage> createState() {
    return _AllergiesPageState();
  }
}

// Concrete state tracker implementation class for the AllergiesPage
class _AllergiesPageState extends State<AllergiesPage> {
  // Text controllers mapping inputs for categories
  final TextEditingController _food_controller = TextEditingController();
  final TextEditingController _medication_controller = TextEditingController();
  final TextEditingController _environmental_controller =
      TextEditingController();

  // Master switch status tracking "No Known Medical Allergies"
  bool _no_known_allergies = false;

  // Active allergy items list models with severity levels (Mild / Severe)
  final List<Map<String, String>> _food_allergies = [
    {'name': 'Peanuts', 'severity': 'Severe'},
    {'name': 'Dairy', 'severity': 'Mild'},
  ];

  final List<Map<String, String>> _medication_allergies = [
    {'name': 'Penicillin', 'severity': 'Severe'},
  ];

  final List<Map<String, String>> _environmental_allergies = [
    {'name': 'Pollen', 'severity': 'Mild'},
  ];

  // Preset popular quick-add options
  final List<String> _popular_food = [
    'Peanuts',
    'Dairy',
    'Gluten',
    'Eggs',
    'Shellfish',
    'Soy'
  ];
  final List<String> _popular_medication = [
    'Penicillin',
    'Aspirin',
    'Ibuprofen',
    'Sulfa',
    'Codeine'
  ];
  final List<String> _popular_environmental = [
    'Dust Mites',
    'Pollen',
    'Cat Dander',
    'Mold',
    'Latex'
  ];

  @override
  void dispose() {
    _food_controller.dispose();
    _medication_controller.dispose();
    _environmental_controller.dispose();
    super.dispose();
  }

  // Helper adding a tag chip to a specific category
  void _add_allergy_chip(String tag, List<Map<String, String>> list,
      TextEditingController controller) {
    final String clean_tag = tag.trim();
    if (clean_tag.isNotEmpty &&
        false ==
            list.any((item) =>
                item['name']?.toLowerCase() == clean_tag.toLowerCase())) {
      setState(() {
        list.add({'name': clean_tag, 'severity': 'Mild'});
      });
      controller.clear();
    } else {
      // Tag is empty or already in list
    }
  }

  // Helper toggling severity level between Mild and Severe
  void _toggle_severity(Map<String, String> item) {
    setState(() {
      item['severity'] = 'Mild' == item['severity'] ? 'Severe' : 'Mild';
    });
  }

  // Helper building a modular category card layout
  Widget _build_category_card({
    required BuildContext context,
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required String hint_text,
    required List<String> popular_options,
    required List<Map<String, String>> active_list,
    required bool is_disabled,
    required bool is_dark,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: is_disabled ? _LocalDimensions.disabled_opacity : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space_l),
        padding: const EdgeInsets.all(AppSpacing.space_l),
        decoration: BoxDecoration(
          color: is_dark ? AppColors.surface_dark : AppColors.white,
          borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
          border: Border.all(
            color: is_dark
                ? AppColors.border_dark
                : AppColors.slate200,
            width: AppSpacing.border_width_thin,
          ),
          boxShadow: [
            BoxShadow(
              color: is_dark
                  ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                  : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
              blurRadius: _LocalDimensions.shadow_blur_default,
              offset: const Offset(0.0, _LocalDimensions.shadow_offset_y),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header Row
            Row(
              children: [
                Container(
                  width: _LocalDimensions.icon_size_large,
                  height: _LocalDimensions.icon_size_large,
                  decoration: BoxDecoration(
                    color: AppColors.primary_color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary_color, size: _LocalDimensions.icon_size_small),
                ),
                const SizedBox(width: _LocalDimensions.spacing_medium),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2, // Allow up to 2 lines to prevent truncation
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _LocalDimensions.font_size_medium,
                      fontWeight: FontWeight.bold,
                      color: is_dark
                          ? AppColors.white
                          : AppColors.text_light_primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space_m),

            // Single Search / Input Field with + button
            IgnorePointer(
              ignoring: is_disabled,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AuthTextField(
                      label: '',
                      hint: hint_text,
                      controller: controller,
                    ),
                  ),
                  const SizedBox(width: _LocalDimensions.spacing_small),
                  Container(
                    height: _LocalDimensions.image_size,
                    width: _LocalDimensions.image_size,
                    decoration: BoxDecoration(
                      color: AppColors.primary_color,
                      borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_rounded, color: AppColors.white),
                      onPressed: () {
                        _add_allergy_chip(
                            controller.text, active_list, controller);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.space_m),

            // Quick-Add Popular Options Chips Carousel
            Text(
              'Popular Options',
              style: TextStyle(
                fontSize: _LocalDimensions.font_size_tiny,
                fontWeight: FontWeight.w600,
                color: is_dark
                    ? AppColors.white54
                    : AppColors.text_light_secondary,
              ),
            ),
            const SizedBox(height: _LocalDimensions.spacing_tiny),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: popular_options.map((option) {
                  final bool is_added = active_list.any((item) =>
                      item['name']?.toLowerCase() == option.toLowerCase());
                  return Padding(
                    padding: const EdgeInsets.only(right: _LocalDimensions.spacing_tiny),
                    child: ActionChip(
                      elevation: 0.0,
                      pressElevation: 0.0,
                      backgroundColor: is_added
                          ? AppColors.primary_color.withValues(alpha: 0.12)
                          : (is_dark
                              ? AppColors.background_dark
                              : AppColors.slate100),
                      side: BorderSide(
                        color: is_added
                            ? AppColors.primary_color
                            : AppColors.transparent,
                        width: _LocalDimensions.chip_border_width,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_large),
                      ),
                      label: Text(
                        '+ $option',
                        style: TextStyle(
                          fontSize: _LocalDimensions.font_size_tiny,
                          fontWeight: FontWeight.w600,
                          color: is_added
                              ? AppColors.primary_color
                              : (is_dark
                                  ? AppColors.white70
                                  : AppColors.text_light_primary),
                        ),
                      ),
                      onPressed: is_disabled
                          ? null
                          : () {
                              if (!is_added) {
                                _add_allergy_chip(
                                    option, active_list, controller);
                              } else {
                                // Already added
                              }
                            },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.space_m),

            // Active Severity-Coded Allergy Chips Wrap List
            if (active_list.isNotEmpty) ...[
              Text(
                'Active Allergies (Tap tag to toggle severity)',
                style: TextStyle(
                  fontSize: _LocalDimensions.font_size_tiny,
                  fontWeight: FontWeight.w600,
                  color: is_dark
                      ? AppColors.white54
                      : AppColors.text_light_secondary,
                ),
              ),
              const SizedBox(height: _LocalDimensions.spacing_small),
              Wrap(
                spacing: _LocalDimensions.spacing_small,
                runSpacing: _LocalDimensions.spacing_small,
                children: active_list.map((item) {
                  final bool is_severe = 'Severe' == item['severity'];
                  final Color dot_color = is_severe
                      ? AppColors.error
                      : AppColors.warning;
                  final Color chip_bg = is_severe
                      ? AppColors.errorLight
                      : AppColors.warningLight;
                  final Color border_color = is_severe
                      ? AppColors.red300
                      : AppColors.amber200;

                  return GestureDetector(
                    onTap: is_disabled
                        ? null
                        : () => _toggle_severity(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: _LocalDimensions.spacing_medium, vertical: _LocalDimensions.spacing_tiny),
                      decoration: BoxDecoration(
                        color: is_dark
                            ? AppColors.background_dark
                            : chip_bg,
                        borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_large),
                        border: Border.all(
                          color: is_dark
                              ? dot_color.withValues(alpha: 0.5)
                              : border_color,
                          width: _LocalDimensions.chip_border_width,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Severity Colored Dot Indicator
                           Container(
                             width: _LocalDimensions.dot_size,
                             height: _LocalDimensions.dot_size,
                             decoration: BoxDecoration(
                               color: dot_color,
                               shape: BoxShape.circle,
                             ),
                           ),
                           const SizedBox(width: _LocalDimensions.spacing_tiny),
                           Text(
                             '${item['name']} • ${item['severity']}',
                             style: TextStyle(
                               fontSize: _LocalDimensions.font_size_micro,
                               fontWeight: FontWeight.bold,
                               color: is_dark
                                   ? AppColors.white
                                   : AppColors.text_light_primary,
                             ),
                           ),
                           const SizedBox(width: _LocalDimensions.spacing_micro),
                           // Inline close icon (X) to delete chip
                           GestureDetector(
                             onTap: is_disabled
                                 ? null
                                 : () {
                                     setState(() {
                                       active_list.remove(item);
                                     });
                                   },
                             child: Icon(
                               Icons.close_rounded,
                               size: _LocalDimensions.severity_icon_size,
                               color: is_dark
                                   ? AppColors.white54
                                   : AppColors.text_light_secondary,
                             ),
                           ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space_xl),
              CustomProfileAppBar(
                title: localizations.allergies_title,
              ),
              const SizedBox(height: AppSpacing.space_xl),
              Expanded(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                // Top Master Switch Card: "No Known Medical Allergies"
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.space_l),
                  padding: const EdgeInsets.all(AppSpacing.space_l),
                  decoration: BoxDecoration(
                    color:
                        is_dark ? AppColors.surface_dark : AppColors.white,
                    borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                    border: Border.all(
                      color: true == _no_known_allergies
                          ? AppColors.primary_color
                          : (is_dark
                              ? AppColors.border_dark
                              : AppColors.slate200),
                      width: true == _no_known_allergies ? _LocalDimensions.border_width_thick : _LocalDimensions.border_width_thin,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: is_dark
                            ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                            : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
                        blurRadius: _LocalDimensions.shadow_blur_default,
                        offset: const Offset(0.0, _LocalDimensions.shadow_offset_y),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _LocalDimensions.icon_container_size,
                        height: _LocalDimensions.icon_container_size,
                        decoration: BoxDecoration(
                          color: AppColors.primary_color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppColors.primary_color,
                          size: _LocalDimensions.icon_size_medium,
                        ),
                      ),
                      const SizedBox(width: _LocalDimensions.spacing_large),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Known Medical Allergies',
                              style: TextStyle(
                                fontSize: _LocalDimensions.font_size_medium,
                                fontWeight: FontWeight.bold,
                                color: is_dark
                                    ? AppColors.white
                                    : AppColors.text_light_primary,
                              ),
                            ),
                            const SizedBox(height: _LocalDimensions.spacing_tiny),
                            const Text(
                              'لا يوجد لدي حساسية معروفة',
                              style: TextStyle(
                                fontSize: _LocalDimensions.font_size_small,
                                color: AppColors.text_light_secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _no_known_allergies,
                        activeTrackColor: AppColors.primary_color,
                        onChanged: (val) {
                          setState(() {
                            _no_known_allergies = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Category Card 1: Food Allergies
                _build_category_card(
                  context: context,
                  title: localizations.allergies_food_section,
                  icon: Icons.restaurant_rounded,
                  controller: _food_controller,
                  hint_text: 'e.g., Peanuts, Dairy, Shellfish',
                  popular_options: _popular_food,
                  active_list: _food_allergies,
                  is_disabled: _no_known_allergies,
                  is_dark: is_dark,
                ),

                // Category Card 2: Medication Allergies
                _build_category_card(
                  context: context,
                  title: localizations.allergies_medication_section,
                  icon: Icons.medication_rounded,
                  controller: _medication_controller,
                  hint_text: 'e.g., Penicillin, Aspirin, Ibuprofen',
                  popular_options: _popular_medication,
                  active_list: _medication_allergies,
                  is_disabled: _no_known_allergies,
                  is_dark: is_dark,
                ),

                // Category Card 3: Environmental & Seasonal Allergies
                _build_category_card(
                  context: context,
                  title: localizations.environmental_seasonal_allergies,
                  icon: Icons.grass_rounded,
                  controller: _environmental_controller,
                  hint_text: 'e.g., Dust Mites, Pollen, Cat Dander',
                  popular_options: _popular_environmental,
                  active_list: _environmental_allergies,
                  is_disabled: _no_known_allergies,
                  is_dark: is_dark,
                ),
              ],
            ),
          );
        },
      ),
    ),
  ],
),
        ),
      ),
      // Unified Primary Bottom CTA Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space_xl),
          child: SizedBox(
            width: double.infinity,
            height: AppSpacing.height_auth_button,
            child: ElevatedButton(
              onPressed: () {
                final profile_cubit = context.read<ProfileCubit>();
                if (true == _no_known_allergies) {
                  profile_cubit.add_allergy('None', 'food');
                } else {
                  for (final item in _food_allergies) {
                    profile_cubit.add_allergy(
                        '${item['name']} (${item['severity']})', 'food');
                  }
                  for (final item in _medication_allergies) {
                    profile_cubit.add_allergy(
                        '${item['name']} (${item['severity']})', 'medication');
                  }
                }

                CustomSnackBar.success(
                  context,
                  'Allergy Profile saved successfully.',
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_color,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text(
                'Save Allergy Profile',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSpacing.font_size_action_button,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

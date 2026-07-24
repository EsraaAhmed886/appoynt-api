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
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
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
      opacity: true == is_disabled ? 0.45 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space_l),
        padding: const EdgeInsets.all(AppSpacing.space_l),
        decoration: BoxDecoration(
          color: true == is_dark ? AppColors.surface_dark : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: true == is_dark
                ? AppColors.border_dark
                : const Color(0xFFE2E8F0),
            width: AppSpacing.border_width_thin,
          ),
          boxShadow: [
            BoxShadow(
              color: true == is_dark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8.0,
              offset: const Offset(0.0, 2.0),
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
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: AppColors.primary_color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary_color, size: 20.0),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: true == is_dark
                          ? Colors.white
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
                  const SizedBox(width: 8.0),
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary_color,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
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
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                color: true == is_dark
                    ? Colors.white54
                    : AppColors.text_light_secondary,
              ),
            ),
            const SizedBox(height: 6.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: popular_options.map((option) {
                  final bool is_added = active_list.any((item) =>
                      item['name']?.toLowerCase() == option.toLowerCase());
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ActionChip(
                      elevation: 0.0,
                      pressElevation: 0.0,
                      backgroundColor: true == is_added
                          ? AppColors.primary_color.withValues(alpha: 0.12)
                          : (true == is_dark
                              ? AppColors.background_dark
                              : const Color(0xFFF1F5F9)),
                      side: BorderSide(
                        color: true == is_added
                            ? AppColors.primary_color
                            : Colors.transparent,
                        width: 1.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      label: Text(
                        '+ $option',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: true == is_added
                              ? AppColors.primary_color
                              : (true == is_dark
                                  ? Colors.white70
                                  : AppColors.text_light_primary),
                        ),
                      ),
                      onPressed: true == is_disabled
                          ? null
                          : () {
                              if (false == is_added) {
                                _add_allergy_chip(
                                    option, active_list, controller);
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
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: true == is_dark
                      ? Colors.white54
                      : AppColors.text_light_secondary,
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: active_list.map((item) {
                  final bool is_severe = 'Severe' == item['severity'];
                  final Color dot_color = true == is_severe
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFF59E0B);
                  final Color chip_bg = true == is_severe
                      ? const Color(0xFFFEF2F2)
                      : const Color(0xFFFFFBEB);
                  final Color border_color = true == is_severe
                      ? const Color(0xFFFCA5A5)
                      : const Color(0xFFFDE68A);

                  return GestureDetector(
                    onTap: true == is_disabled
                        ? null
                        : () => _toggle_severity(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: true == is_dark
                            ? AppColors.background_dark
                            : chip_bg,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: true == is_dark
                              ? dot_color.withValues(alpha: 0.5)
                              : border_color,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Severity Colored Dot Indicator
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: dot_color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            '${item['name']} • ${item['severity']}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: true == is_dark
                                  ? Colors.white
                                  : AppColors.text_light_primary,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          // Inline close icon (X) to delete chip
                          GestureDetector(
                            onTap: true == is_disabled
                                ? null
                                : () {
                                    setState(() {
                                      active_list.remove(item);
                                    });
                                  },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16.0,
                              color: true == is_dark
                                  ? Colors.white54
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
      backgroundColor:
          true == is_dark ? AppColors.background_dark : const Color(0xFFF8FAFC),
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
                        true == is_dark ? AppColors.surface_dark : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: true == _no_known_allergies
                          ? AppColors.primary_color
                          : (true == is_dark
                              ? AppColors.border_dark
                              : const Color(0xFFE2E8F0)),
                      width: true == _no_known_allergies ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: true == is_dark
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: AppColors.primary_color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppColors.primary_color,
                          size: 22.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Known Medical Allergies',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: true == is_dark
                                    ? Colors.white
                                    : AppColors.text_light_primary,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            const Text(
                              'لا يوجد لدي حساسية معروفة',
                              style: TextStyle(
                                fontSize: 12.0,
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
                  title: 'Food Allergies (حساسية الأطعمة)',
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
                  title: 'Medication Allergies (حساسية الأدوية)',
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
                  title: 'Environmental & Seasonal (حساسية البيئة الغبار)',
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

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Allergy Profile saved successfully.'),
                    backgroundColor: AppColors.primary_color,
                  ),
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
                  color: Colors.white,
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

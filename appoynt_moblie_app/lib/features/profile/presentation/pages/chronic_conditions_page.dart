/*
 * File Name: chronic_conditions_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.3.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/core/widgets/auth/auth_text_field.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Redesigned Chronic Conditions page featuring compact list cards, expandable sub-forms, top search bar, and master toggle switch.
 */

// Importing BLoC libraries
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing design system barrel and route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing AuthTextField component
import 'package:appoynt_mobile_app/core/widgets/auth/auth_text_field.dart';
// Importing Cubit controller and state
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/cubit/profile_state.dart';


// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_medium = 12.0;
  static const double border_radius_small = 10.0;
  static const double border_radius_tiny = 8.0;
  static const double border_width_accent = 2.0;
  static const double button_height = 50.0;
  static const double button_height_small = 42.0;
  static const double avatar_size = 38.0;
  static const double action_icon_size = 22.0;
  static const double spacing_tiny = 2.0;
  static const double spacing_small = 6.0;
  static const double spacing_medium = 8.0;
  static const double spacing_large = 12.0;
  static const double font_size_title = 18.0;
  static const double font_size_body = 14.0;
  static const double font_size_medium = 13.0;
  static const double font_size_small = 12.0;
  static const double font_size_tiny = 11.0;
  static const double font_size_micro = 10.0;
  static const double icon_size_small = 14.0;
  static const double icon_size_medium = 20.0;
  static const double shadow_blur = 8.0;
  static const double shadow_opacity_dark = 0.2;
  static const double shadow_opacity_light = 0.04;
  static const double disabled_opacity = 0.45;
  static const double full_opacity = 1.0;
}

// Chronic Conditions Page layout stateful widget representation
class ChronicConditionsPage extends StatefulWidget {
  // Constructor mapping key
  const ChronicConditionsPage({super.key});

  @override
  State<ChronicConditionsPage> createState() {
    return _ChronicConditionsPageState();
  }
}

// Concrete state tracker implementation class for the ChronicConditionsPage
class _ChronicConditionsPageState extends State<ChronicConditionsPage> {
  // Search query controller
  final TextEditingController _search_controller = TextEditingController();
  String _search_query = '';

  // Master switch tracking "No Chronic Conditions"
  bool _no_chronic_conditions = false;

  // Predefined default medical conditions
  final List<Map<String, String>> _predefined_conditions = [
    {'en': 'Diabetes', 'ar': 'مرض السكري', 'icon_key': 'diabetes'},
    {'en': 'Hypertension', 'ar': 'ارتفاع ضغط الدم', 'icon_key': 'hypertension'},
    {'en': 'Gout', 'ar': 'النقرس', 'icon_key': 'gout'},
    {'en': 'Asthma', 'ar': 'الربو', 'icon_key': 'asthma'},
    {'en': 'Heart Disease', 'ar': 'أمراض القلب', 'icon_key': 'heart_disease'},
  ];

  // Custom user-added chronic conditions list
  final List<Map<String, String>> _custom_conditions = [];

  // Active selections details maps tracking diagnoses parameters: {ConditionName: {year: 2023, status: Controlled}}
  final Map<String, Map<String, dynamic>> _condition_details = {
    'Hypertension': {'year': '2023', 'status': 'Controlled'},
    'Diabetes': {'year': '2021', 'status': 'Requires Monitoring'},
  };

  @override
  void initState() {
    super.initState();
    _search_controller.addListener(() {
      setState(() {
        _search_query = _search_controller.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _search_controller.dispose();
    super.dispose();
  }

  // Confirmation dialog workflow for deleting/removing active or custom conditions
  Future<bool> _show_delete_confirmation_dialog({
    required BuildContext context,
    required String label,
    required bool is_arabic,
  }) async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final String title = localizations.chronic_remove_dialog_title;
    final String body = localizations.chronic_remove_dialog_body(label);
    final String cancel_txt = localizations.chronic_cancel_btn;
    final String remove_txt = localizations.chronic_remove_btn;

    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialog_context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
          ),
          title: Text(
            title,
            textAlign: is_arabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontSize: _LocalDimensions.font_size_title,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            body,
            textAlign: is_arabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontSize: _LocalDimensions.font_size_body,
            ),
          ),
          actionsAlignment: is_arabic ? MainAxisAlignment.start : MainAxisAlignment.end,
          actions: [
            // Cancel Action
            TextButton(
              onPressed: () => Navigator.pop(dialog_context, false),
              child: Text(
                cancel_txt,
                style: const TextStyle(
                  color: AppColors.text_light_secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Confirm/Destructive Action
            ElevatedButton(
              onPressed: () => Navigator.pop(dialog_context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_tiny),
                ),
              ),
              child: Text(
                remove_txt,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
    return confirm ?? false;
  }

  // Get IconData mapping matching icon key
  IconData _get_icon_data(String icon_key) {
    switch (icon_key) {
      case 'diabetes':
        return Icons.opacity_rounded;
      case 'hypertension':
        return Icons.speed_rounded;
      case 'gout':
        return Icons.healing_rounded;
      case 'asthma':
        return Icons.air_rounded;
      case 'heart_disease':
        return Icons.heart_broken_rounded;
      default:
        return Icons.healing_rounded;
    }
  }

  // Helper adding customized condition
  void _add_custom_condition() {
    final String clean_query = _search_query.trim();
    if (clean_query.isNotEmpty) {
      final bool exists = _predefined_conditions.any((c) =>
              c['en']!.toLowerCase() == clean_query.toLowerCase() ||
              c['ar']!.toLowerCase() == clean_query.toLowerCase()) ||
          _custom_conditions.any((c) =>
              c['en']!.toLowerCase() == clean_query.toLowerCase() ||
              c['ar']!.toLowerCase() == clean_query.toLowerCase());

      if (false == exists) {
        setState(() {
          final Map<String, String> new_cond = {
            'en': clean_query,
            'ar': clean_query,
            'icon_key': 'custom',
          };
          _custom_conditions.insert(0, new_cond);
          _condition_details[clean_query] = {
            'year': '2026',
            'status': 'Controlled',
          };
          _search_controller.clear();
        });
      } else {
        // Condition already exists
      }
    } else {
      // Query is empty
    }
  }

  // Build compact expandable condition list card widget
  Widget _build_condition_card({
    required BuildContext context,
    required Map<String, String> option,
    required bool is_dark,
    required AppLocalizations localizations,
    required bool is_disabled,
  }) {
    final bool is_arabic = localizations.is_arabic;
    final String name_en = option['en'] ?? '';
    final String label = is_arabic
        ? (option['ar'] ?? '')
        : name_en;

    final IconData icon = _get_icon_data(option['icon_key'] ?? '');
    final bool is_selected = _condition_details.containsKey(name_en);

    // Fetch details map if selected
    final Map<String, dynamic>? details = _condition_details[name_en];
    final String diag_year = details?['year'] ?? '2026';
    final String diag_status = details?['status'] ?? 'Controlled';

    final List<String> years =
        List.generate(17, (index) => (2026 - index).toString());

    // Localized dynamic badges & labels
    final String status_label = 'Controlled' == diag_status
        ? localizations.chronic_status_controlled
        : localizations.chronic_status_monitoring;

    final String subtitle_text = localizations.get_chronic_subtitle(diag_year, status_label);

    final String diag_year_header = localizations.chronic_diag_year_header;
    final String treatment_status_header = localizations.chronic_treatment_status_header;
    final String controlled_btn_label = localizations.chronic_controlled_label;
    final String monitoring_btn_label = localizations.chronic_monitoring_label;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: is_disabled ? _LocalDimensions.disabled_opacity : _LocalDimensions.full_opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space_m),
        decoration: BoxDecoration(
          color: is_dark ? AppColors.surface_dark : AppColors.white,
          borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
          border: Border.all(
            color: is_selected
                ? AppColors.primary_color
                : (is_dark
                    ? AppColors.border_dark
                    : AppColors.slate_200),
            width: is_selected ? _LocalDimensions.border_width_accent : AppSpacing.border_width_thin,
          ),
          boxShadow: [
            BoxShadow(
              color: is_dark
                  ? AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_dark)
                  : AppColors.black.withValues(alpha: _LocalDimensions.shadow_opacity_light),
              blurRadius: _LocalDimensions.shadow_blur,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Main Card Row
            InkWell(
              onTap: is_disabled
                  ? null
                  : () {
                      setState(() {
                        if (is_selected) {
                          _condition_details.remove(name_en);
                        } else {
                          _condition_details[name_en] = {
                            'year': '2026',
                            'status': 'Controlled',
                          };
                        }
                      });
                    },
              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space_l),
                child: Row(
                  children: [
                    // Leading tinted icon badge container
                    Container(
                      width: _LocalDimensions.avatar_size,
                      height: _LocalDimensions.avatar_size,
                      decoration: BoxDecoration(
                        color: is_selected
                            ? AppColors.primary_color.withValues(alpha: 0.12)
                            : (is_dark
                                ? AppColors.background_dark
                                : AppColors.slate_50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: is_selected
                            ? AppColors.primary_color
                            : (is_dark
                                ? AppColors.white54
                                : AppColors.text_light_secondary),
                        size: _LocalDimensions.icon_size_medium,
                      ),
                    ),
                    const SizedBox(width: _LocalDimensions.spacing_large),

                    // Title & Description Subtitle Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: _LocalDimensions.font_size_body,
                              fontWeight: FontWeight.bold,
                              color: is_dark
                                  ? AppColors.white
                                  : AppColors.text_light_primary,
                            ),
                          ),
                          if (is_selected) ...[
                            const SizedBox(height: _LocalDimensions.spacing_tiny),
                            Text(
                              subtitle_text,
                              style: const TextStyle(
                                fontSize: _LocalDimensions.font_size_small,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary_color,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Trailing Checkbox and Deletion action indicators row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Subtle trash icon for selected items OR permanent deletion for custom conditions
                        if (is_selected || 'custom' == option['icon_key']) ...[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              final bool confirm = await _show_delete_confirmation_dialog(
                                context: context,
                                label: label,
                                is_arabic: is_arabic,
                              );
                              if (true == confirm) {
                                setState(() {
                                  if ('custom' == option['icon_key']) {
                                    _custom_conditions.remove(option);
                                  } else {
                                    // Predefined condition
                                  }
                                  _condition_details.remove(name_en);
                                });
                              } else {
                                // Deletion cancelled
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error,
                                size: _LocalDimensions.icon_size_medium,
                              ),
                            ),
                          ),
                        ],
                        // Trailing Checkbox indicator
                        Container(
                          width: _LocalDimensions.action_icon_size,
                          height: _LocalDimensions.action_icon_size,
                          decoration: BoxDecoration(
                            color: is_selected
                                ? AppColors.primary_color
                                : AppColors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: is_selected
                                  ? AppColors.primary_color
                                  : (is_dark
                                      ? AppColors.white30
                                      : AppColors.slate_300),
                              width: _LocalDimensions.border_width_accent,
                            ),
                          ),
                          child: is_selected
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: _LocalDimensions.icon_size_small,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Expandable details collector drawer
            if (is_selected && !is_disabled) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.space_l,
                  right: AppSpacing.space_l,
                  bottom: AppSpacing.space_l,
                ),
                child: Column(
                  children: [
                    const Divider(height: 1.0, color: AppColors.slate_200),
                    const SizedBox(height: _LocalDimensions.spacing_large),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Diagnosed Year dropdown details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diag_year_header,
                                style: const TextStyle(
                                  fontSize: _LocalDimensions.font_size_tiny,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_light_secondary,
                                ),
                              ),
                              const SizedBox(height: _LocalDimensions.spacing_small),
                              Container(
                                height: _LocalDimensions.button_height_small,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: _LocalDimensions.spacing_large),
                                decoration: BoxDecoration(
                                  color: is_dark
                                      ? AppColors.background_dark
                                      : AppColors.slate_50,
                                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_small),
                                  border: Border.all(
                                    color: is_dark
                                        ? AppColors.border_dark
                                        : AppColors.slate_200,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: diag_year,
                                    isExpanded: true,
                                    items: years.map((y) {
                                      return DropdownMenuItem<String>(
                                        value: y,
                                        child: Text(y,
                                            style: const TextStyle(
                                                fontSize: 13.0)),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _condition_details[name_en]!['year'] =
                                              val;
                                        });
                                      } else {
                                        // No change
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: _LocalDimensions.spacing_large),

                        // Controlled status segment tags
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                treatment_status_header,
                                style: const TextStyle(
                                  fontSize: _LocalDimensions.font_size_tiny,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_light_secondary,
                                ),
                              ),
                              const SizedBox(height: _LocalDimensions.spacing_small),
                              Row(
                                children: [
                                  // Controlled Pill Choice
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _condition_details[name_en]![
                                              'status'] = 'Controlled';
                                        });
                                      },
                                      child: Container(
                                        height: _LocalDimensions.button_height_small,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: 'Controlled' == diag_status
                                              ? AppColors.primary_color
                                              : (is_dark
                                                  ? AppColors.background_dark
                                                  : AppColors.slate_50),
                                          borderRadius:
                                              const BorderRadiusDirectional.horizontal(
                                            start: Radius.circular(_LocalDimensions.border_radius_small),
                                          ),
                                          border: Border.all(
                                            color: is_dark
                                                ? AppColors.border_dark
                                                : AppColors.slate_200,
                                          ),
                                        ),
                                        child: Text(
                                          controlled_btn_label,
                                          style: TextStyle(
                                            fontSize: _LocalDimensions.font_size_micro,
                                            fontWeight: FontWeight.bold,
                                            color: 'Controlled' == diag_status
                                                ? AppColors.white
                                                : (is_dark
                                                    ? AppColors.white70
                                                    : AppColors
                                                        .text_light_primary),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Requires Monitoring Pill Choice
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _condition_details[name_en]![
                                              'status'] = 'Monitoring';
                                        });
                                      },
                                      child: Container(
                                        height: _LocalDimensions.button_height_small,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: 'Monitoring' == diag_status
                                              ? AppColors.primary_color
                                              : (is_dark
                                                  ? AppColors.background_dark
                                                  : AppColors.slate_50),
                                          borderRadius:
                                              const BorderRadiusDirectional.horizontal(
                                            end: Radius.circular(_LocalDimensions.border_radius_small),
                                          ),
                                          border: Border.all(
                                            color: is_dark
                                                ? AppColors.border_dark
                                                : AppColors.slate_200,
                                          ),
                                        ),
                                        child: Text(
                                          monitoring_btn_label,
                                          style: TextStyle(
                                            fontSize: _LocalDimensions.font_size_micro,
                                            fontWeight: FontWeight.bold,
                                            color: 'Monitoring' == diag_status
                                                ? AppColors.white
                                                : (is_dark
                                                    ? AppColors.white70
                                                    : AppColors
                                                        .text_light_primary),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
    final bool is_arabic = localizations.is_arabic;

    final List<Map<String, String>> combined_list = [
      ..._custom_conditions,
      ..._predefined_conditions,
    ];

    final List<Map<String, String>> filtered_list = combined_list.where((cond) {
      final String term = _search_query.toLowerCase();
      final String en = (cond['en'] ?? '').toLowerCase();
      final String ar = (cond['ar'] ?? '').toLowerCase();
      return en.contains(term) || ar.contains(term);
    }).toList();

    // Localized search hint
    final String search_hint = localizations.chronic_search_hint;

    // Localized master toggle labels
    final String master_title = localizations.chronic_no_conditions_label;

    // Localized bottom button label
    final String save_button_label = localizations.chronic_save_btn;

    // Localized snackbar content
    final String snackbar_message = localizations.chronic_saved_success_toast;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top navigation header sitting directly on native screen canvas
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.space_xl,
                    right: AppSpacing.space_xl,
                    top: AppSpacing.space_xl,
                    bottom: AppSpacing.space_m,
                  ),
                  child: CustomProfileAppBar(
                    title: localizations.chronic_title,
                  ),
                ),

                // Search & Custom Add Input Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xl,
                    vertical: AppSpacing.space_s,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AuthTextField(
                          label: '',
                          hint: search_hint,
                          controller: _search_controller,
                        ),
                      ),
                      if (_search_query.isNotEmpty) ...[
                        const SizedBox(width: _LocalDimensions.spacing_medium),
                        Container(
                          height: _LocalDimensions.button_height,
                          width: _LocalDimensions.button_height,
                          decoration: BoxDecoration(
                            color: AppColors.primary_color,
                            borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
                          ),
                          child: IconButton(
                            icon:
                                const Icon(Icons.add_rounded, color: AppColors.white),
                            onPressed: _add_custom_condition,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xl,
                    vertical: AppSpacing.space_s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top explanation guide label
                      Text(
                        localizations.chronic_description,
                        style: TextStyle(
                          fontSize: _LocalDimensions.font_size_medium,
                          color: is_dark
                              ? AppColors.text_dark_secondary
                              : AppColors.text_light_secondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space_l),

                      // Top Switch Card: "No Chronic Conditions"
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: AppSpacing.space_l),
                        padding: const EdgeInsets.all(AppSpacing.space_l),
                        decoration: BoxDecoration(
                          color: is_dark
                              ? AppColors.surface_dark
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: true == _no_chronic_conditions
                                ? AppColors.primary_color
                                : (is_dark
                                    ? AppColors.border_dark
                                    : const Color(0xFFE2E8F0)),
                            width: true == _no_chronic_conditions ? 2.0 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: is_dark
                                  ? AppColors.black.withValues(alpha: 0.2)
                                  : AppColors.black.withValues(alpha: 0.04),
                              blurRadius: 8.0,
                              offset: const Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: _LocalDimensions.avatar_size,
                              height: _LocalDimensions.avatar_size,
                              decoration: BoxDecoration(
                                color: AppColors.primary_color
                                    .withValues(alpha: 0.1),
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
                                    master_title,
                                    style: TextStyle(
                                      fontSize: _LocalDimensions.font_size_body,
                                      fontWeight: FontWeight.bold,
                                      color: is_dark
                                          ? AppColors.white
                                          : AppColors.text_light_primary,
                                    ),
                                  ),
                                  const SizedBox(height: _LocalDimensions.spacing_tiny),
                                  Text(
                                    is_arabic
                                        ? 'تحديد هذا الخيار سيلغي تحديد جميع الأمراض'
                                        : 'Activating this unchecks all conditions',
                                    style: const TextStyle(
                                      fontSize: _LocalDimensions.font_size_small,
                                      color: AppColors.text_light_secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: _no_chronic_conditions,
                              activeTrackColor: AppColors.primary_color,
                              onChanged: (val) {
                                setState(() {
                                  _no_chronic_conditions = val;
                                  if (val) {
                                    _condition_details.clear();
                                  } else {
                                    // Switch disabled
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // Conditions List Builder
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered_list.length,
                        itemBuilder: (context, index) {
                          return _build_condition_card(
                            context: context,
                            option: filtered_list[index],
                            is_dark: is_dark,
                            localizations: localizations,
                            is_disabled: _no_chronic_conditions,
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.height_auth_button),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
      bottomNavigationBar: StickyBottomBar(
        child: SizedBox(
          width: double.infinity,
          height: AppSpacing.height_auth_button,
          child: ElevatedButton(
            onPressed: () {
              final List<String> conditions_to_save = [];
              if (false == _no_chronic_conditions) {
                _condition_details.forEach((name, details) {
                  conditions_to_save.add(
                      '$name (${details['year']} • ${details['status']})');
                });
              } else {
                // No chronic conditions
              }

              context.read<ProfileCubit>().update_profile_field(
                    'chronic_conditions',
                    conditions_to_save,
                  );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(snackbar_message),
                  backgroundColor: AppColors.primary_color,
                ),
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary_color,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_medium),
              ),
            ),
            child: Text(
              save_button_label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: AppSpacing.font_size_action_button,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

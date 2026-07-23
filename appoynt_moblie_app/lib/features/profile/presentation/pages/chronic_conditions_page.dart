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
 * Last Modified Date: [Kholoud Khaled - 22/07/2026]
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
    final String title = true == is_arabic ? 'إزالة الحالة المرضية؟' : 'Remove Condition?';
    final String body = true == is_arabic
        ? 'هل أنت متأكد من إزالة $label من سجلك الطبي؟ لن يظهر هذا المرض في ملفك الطبي المشارك مع الأطباء.'
        : 'Are you sure you want to remove $label from your medical record? This will no longer be visible to your healthcare providers.';
    final String cancel_txt = true == is_arabic ? 'إلغاء' : 'Cancel';
    final String remove_txt = true == is_arabic ? 'إزالة' : 'Remove';

    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialog_context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            title,
            textAlign: true == is_arabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            body,
            textAlign: true == is_arabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          actionsAlignment: true == is_arabic ? MainAxisAlignment.start : MainAxisAlignment.end,
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
                backgroundColor: const Color(0xFFDC2626),
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                remove_txt,
                style: const TextStyle(
                  color: Colors.white,
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
      }
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
    final String label = true == is_arabic
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
        ? (true == is_arabic ? 'حالة مستقرة' : 'Controlled')
        : (true == is_arabic ? 'تتطلب المتابعة' : 'Requires Monitoring');

    final String subtitle_text = true == is_arabic
        ? 'تم التشخيص في $diag_year • $status_label'
        : 'Diagnosed in $diag_year • $status_label';

    final String diag_year_header = true == is_arabic ? 'سنة التشخيص' : 'Diagnosed Year';
    final String treatment_status_header = true == is_arabic ? 'حالة العلاج' : 'Treatment Status';
    final String controlled_btn_label = true == is_arabic ? 'مستقرة' : 'Controlled';
    final String monitoring_btn_label = true == is_arabic ? 'متابعة' : 'Monitoring';

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: true == is_disabled ? 0.45 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.space_m),
        decoration: BoxDecoration(
          color: true == is_dark ? AppColors.surface_dark : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: true == is_selected
                ? AppColors.primary_color
                : (true == is_dark
                    ? AppColors.border_dark
                    : const Color(0xFFE2E8F0)),
            width: true == is_selected ? 2.0 : AppSpacing.border_width_thin,
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
          children: [
            // Top Main Card Row
            InkWell(
              onTap: true == is_disabled
                  ? null
                  : () {
                      setState(() {
                        if (true == is_selected) {
                          _condition_details.remove(name_en);
                        } else {
                          _condition_details[name_en] = {
                            'year': '2026',
                            'status': 'Controlled',
                          };
                        }
                      });
                    },
              borderRadius: BorderRadius.circular(16.0),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space_l),
                child: Row(
                  children: [
                    // Leading tinted icon badge container
                    Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                        color: true == is_selected
                            ? AppColors.primary_color.withValues(alpha: 0.12)
                            : (true == is_dark
                                ? AppColors.background_dark
                                : const Color(0xFFF1F5F9)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: true == is_selected
                            ? AppColors.primary_color
                            : (true == is_dark
                                ? Colors.white54
                                : AppColors.text_light_secondary),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),

                    // Title & Description Subtitle Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: true == is_dark
                                  ? Colors.white
                                  : AppColors.text_light_primary,
                            ),
                          ),
                          if (true == is_selected) ...[
                            const SizedBox(height: 2.0),
                            Text(
                              subtitle_text,
                              style: const TextStyle(
                                fontSize: 12.0,
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
                        if (true == is_selected || 'custom' == option['icon_key']) ...[
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
                                  }
                                  _condition_details.remove(name_en);
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.error,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                        // Trailing Checkbox indicator
                        Container(
                          width: 22.0,
                          height: 22.0,
                          decoration: BoxDecoration(
                            color: true == is_selected
                                ? AppColors.primary_color
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: true == is_selected
                                  ? AppColors.primary_color
                                  : (true == is_dark
                                      ? Colors.white30
                                      : const Color(0xFFCBD5E1)),
                              width: 2.0,
                            ),
                          ),
                          child: true == is_selected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14.0,
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
            if (true == is_selected && false == is_disabled) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.space_l,
                  right: AppSpacing.space_l,
                  bottom: AppSpacing.space_l,
                ),
                child: Column(
                  children: [
                    const Divider(height: 1.0, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 12.0),
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
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_light_secondary,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Container(
                                height: 42.0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                decoration: BoxDecoration(
                                  color: true == is_dark
                                      ? AppColors.background_dark
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: true == is_dark
                                        ? AppColors.border_dark
                                        : const Color(0xFFE2E8F0),
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
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12.0),

                        // Controlled status segment tags
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                treatment_status_header,
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_light_secondary,
                                ),
                              ),
                              const SizedBox(height: 6.0),
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
                                        height: 42.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: 'Controlled' == diag_status
                                              ? AppColors.primary_color
                                              : (true == is_dark
                                                  ? AppColors.background_dark
                                                  : const Color(0xFFF8FAFC)),
                                          borderRadius:
                                              const BorderRadiusDirectional.horizontal(
                                            start: Radius.circular(10.0),
                                          ),
                                          border: Border.all(
                                            color: true == is_dark
                                                ? AppColors.border_dark
                                                : const Color(0xFFE2E8F0),
                                          ),
                                        ),
                                        child: Text(
                                          controlled_btn_label,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: 'Controlled' == diag_status
                                                ? Colors.white
                                                : (true == is_dark
                                                    ? Colors.white70
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
                                        height: 42.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: 'Monitoring' == diag_status
                                              ? AppColors.primary_color
                                              : (true == is_dark
                                                  ? AppColors.background_dark
                                                  : const Color(0xFFF8FAFC)),
                                          borderRadius:
                                              const BorderRadiusDirectional.horizontal(
                                            end: Radius.circular(10.0),
                                          ),
                                          border: Border.all(
                                            color: true == is_dark
                                                ? AppColors.border_dark
                                                : const Color(0xFFE2E8F0),
                                          ),
                                        ),
                                        child: Text(
                                          monitoring_btn_label,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: 'Monitoring' == diag_status
                                                ? Colors.white
                                                : (true == is_dark
                                                    ? Colors.white70
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
    final String search_hint = true == is_arabic
        ? 'البحث أو إضافة حالة جديدة (مثل: الربو)...'
        : 'Search or add condition (e.g., Asthma)...';

    // Localized master toggle labels
    final String master_title = true == is_arabic ? 'لا أعاني من أمراض مزمنة' : 'No Chronic Conditions';

    // Localized bottom button label
    final String save_button_label = true == is_arabic ? 'حفظ سجل الأمراض المزمنة' : 'Save Conditions Profile';

    // Localized snackbar content
    final String snackbar_message = true == is_arabic
        ? 'تم حفظ سجل الأمراض المزمنة بنجاح.'
        : 'Chronic Conditions profile saved successfully.';

    return Scaffold(
      backgroundColor:
          true == is_dark ? AppColors.background_dark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor:
            true == is_dark ? AppColors.surface_dark : Colors.white,
        title: Text(
          localizations.chronic_title,
          style: TextStyle(
            fontSize: AppSpacing.font_size_title,
            fontWeight: FontWeight.w700,
            color: true == is_dark
                ? AppColors.text_dark_primary
                : AppColors.text_light_primary,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Column(
            children: [
              // Search & Custom Add Input Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space_l,
                  vertical: AppSpacing.space_m,
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
                      const SizedBox(width: 8.0),
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: AppColors.primary_color,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: IconButton(
                          icon:
                              const Icon(Icons.add_rounded, color: Colors.white),
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
                    horizontal: AppSpacing.space_l,
                    vertical: AppSpacing.space_s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top explanation guide label
                      Text(
                        localizations.chronic_description,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: true == is_dark
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
                          color: true == is_dark
                              ? AppColors.surface_dark
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: true == _no_chronic_conditions
                                ? AppColors.primary_color
                                : (true == is_dark
                                    ? AppColors.border_dark
                                    : const Color(0xFFE2E8F0)),
                            width: true == _no_chronic_conditions ? 2.0 : 1.0,
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
                              width: 38.0,
                              height: 38.0,
                              decoration: BoxDecoration(
                                color: AppColors.primary_color
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: AppColors.primary_color,
                                size: 20.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    master_title,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: true == is_dark
                                          ? Colors.white
                                          : AppColors.text_light_primary,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    true == is_arabic
                                        ? 'تحديد هذا الخيار سيلغي تحديد جميع الأمراض'
                                        : 'Activating this unchecks all conditions',
                                    style: const TextStyle(
                                      fontSize: 12.0,
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
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // Locked Primary Bottom Save Action Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space_l),
          child: SizedBox(
            width: double.infinity,
            height: AppSpacing.height_auth_button,
            child: ElevatedButton(
              onPressed: () {
                final List<String> conditions_to_save = [];
                if (false == _no_chronic_conditions) {
                  _condition_details.forEach((name, details) {
                    conditions_to_save.add('$name (${details['year']} • ${details['status']})');
                  });
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
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                save_button_label,
                style: const TextStyle(
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

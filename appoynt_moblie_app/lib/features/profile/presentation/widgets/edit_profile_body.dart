/*
 * File Name: edit_profile_body.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.2.0
 * Dependencies: package:flutter/material.dart,
 *   package:flutter_bloc/flutter_bloc.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart,
 *   package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Widget providing dynamic auto-detected Date of Birth and Gender Info Badges
 *   and cascaded Egyptian Governorate & City dropdown selectors with dark/light theme support.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/widgets/smart_search_picker.dart';
import 'package:appoynt_mobile_app/features/profile/data/models/governorate_model.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_cubit.dart';
import 'package:appoynt_mobile_app/features/profile/presentation/bloc/edit_profile_state.dart';

/// Compact auto-detected Date of Birth and Gender badge widget.
class NationalIdInfoBadges extends StatelessWidget {
  /// The extracted birth date DateTime object
  final DateTime? birthDate;

  /// The extracted gender string ('male' or 'female')
  final String? gender;

  /// Constructor
  const NationalIdInfoBadges({
    super.key,
    required this.birthDate,
    required this.gender,
  });

  String _formatDisplayDate(DateTime date, String langCode) {
    const List<String> arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    const List<String> englishMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String day = date.day.toString().padLeft(2, '0');
    final String month = ('ar' == langCode)
        ? arabicMonths[date.month - 1]
        : englishMonths[date.month - 1];
    return '$day $month ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations loc = AppLocalizations.of(context);
    final String currentLocale =
        Localizations.localeOf(context).languageCode;
    final bool isVisible = birthDate != null && gender != null;

    return AnimatedCrossFade(
      firstChild: const SizedBox(width: double.infinity),
      secondChild: isVisible
          ? Container(
              margin: const EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Birth Date Badge
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cake_outlined,
                              size: 16.0,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6.0),
                            Flexible(
                              child: Text(
                                _formatDisplayDate(birthDate!, currentLocale),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.slate800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Vertical Divider
                      Container(
                        height: 16.0,
                        width: 1.0,
                        color: AppColors.primary.withValues(alpha: 0.3),
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),

                      // Gender Badge
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              gender!.toLowerCase() == 'female'
                                  ? Icons.female_rounded
                                  : Icons.male_rounded,
                              size: 17.0,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              gender!.toLowerCase() == 'female'
                                  ? loc.profile_gender_female
                                  : loc.profile_gender_male,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.slate800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 12.0,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.slate400,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        loc.auto_detected_from_national_id,
                        style: TextStyle(
                          fontSize: 11.0,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.slate500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox(width: double.infinity),
      crossFadeState: isVisible
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
    );
  }
}

/// Stacked modern Governorate and City bottom sheet selector input section widget.
class GovernorateCityDropdowns extends StatelessWidget {
  const GovernorateCityDropdowns({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String langCode = Localizations.localeOf(context).languageCode;
    final AppLocalizations loc = AppLocalizations.of(context);

    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        final cubit = context.read<EditProfileCubit>();
        final bool isGovLoading = state.isGovernoratesLoading;
        final bool isCityLoading = state.isCitiesLoading;
        final bool hasSelectedGov = null != state.selectedGovernorate;
        final List<CityModel> availableCities = state.cities.isNotEmpty
            ? state.cities
            : (state.selectedGovernorate?.cities ?? []);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------------------
            // 1. Governorate Field
            // -------------------------------------------------------------
            Text(
              loc.governorate_label,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.slate700,
              ),
            ),
            const SizedBox(height: 8.0),
            _SelectionContainer(
              icon: Icons.map_outlined,
              hint: isGovLoading
                  ? loc.loading_governorates
                  : loc.select_governorate_hint,
              value: state.selectedGovernorate?.getName(langCode),
              isLoading: isGovLoading,
              onTap: () async {
                if (state.governorates.isNotEmpty) {
                  final GovernorateModel? selected =
                      await showSmartSearchPicker<GovernorateModel>(
                    context: context,
                    title: loc.governorate_label,
                    searchHint: loc.search_governorate_hint,
                    items: state.governorates,
                    itemLabel: (gov) => gov.getName(langCode),
                    selectedItem: state.selectedGovernorate,
                  );
                  if (selected != null) {
                    cubit.onGovernorateChanged(selected);
                  } else {
                    // Dialog dismissed
                  }
                } else {
                  // No governorates available
                }
              },
            ),

            const SizedBox(height: 16.0),

            // -------------------------------------------------------------
            // 2. City Field (Dependent on Governorate)
            // -------------------------------------------------------------
            Text(
              loc.city_label,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.slate700,
              ),
            ),
            const SizedBox(height: 8.0),
            Opacity(
              opacity: hasSelectedGov ? 1.0 : 0.6,
              child: _SelectionContainer(
                icon: Icons.location_city_outlined,
                hint: !hasSelectedGov
                    ? loc.select_gov_first_hint
                    : loc.select_city_hint,
                value: state.selectedCity?.getName(langCode),
                isLoading: isCityLoading,
                onTap: (!hasSelectedGov || isCityLoading)
                    ? null
                    : () async {
                        if (availableCities.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                loc.no_cities_available,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        } else {
                          final CityModel? selected =
                              await showSmartSearchPicker<CityModel>(
                            context: context,
                            title: loc.select_city_hint,
                            searchHint: loc.search_city_hint,
                            items: availableCities,
                            itemLabel: (city) => city.getName(langCode),
                            selectedItem: state.selectedCity,
                          );
                          if (selected != null) {
                            cubit.onCityChanged(selected);
                          } else {
                            // Dialog dismissed
                          }
                        }
                      },
              ),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Custom Selection Container (Matches Blood Group & Inputs Style)
// -----------------------------------------------------------------------------
class _SelectionContainer extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final bool isLoading;
  final VoidCallback? onTap;

  const _SelectionContainer({
    required this.icon,
    required this.hint,
    this.value,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasValue = null != value && value!.trim().isNotEmpty;
    final bool isEnabled = null != onTap;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 52.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.slate50,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.slate200,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isEnabled ? AppColors.primary : AppColors.slate400,
              size: 20.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                hasValue ? value! : hint,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                  color: hasValue
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.slate900)
                      : (isDark ? AppColors.darkTextMuted : AppColors.slate400),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: AppColors.primary,
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isEnabled ? AppColors.primary : AppColors.slate400,
                size: 22.0,
              ),
          ],
        ),
      ),
    );
  }
}

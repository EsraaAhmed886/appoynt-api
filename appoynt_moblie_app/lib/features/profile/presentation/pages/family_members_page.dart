/*
 * File Name: family_members_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/07/2026
 * Version Information: V1.4.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/profile/presentation/pages/add_family_member_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Redesigned Family Members & Dependents page displaying vertical member cards with bottom primary CTA.
 */

// Importing global route export barrel
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing add family member page layout
import 'package:appoynt_mobile_app/features/profile/presentation/pages/add_family_member_page.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double border_radius_default = 16.0;
  static const double border_radius_badge = 12.0;
  static const double border_width_thin = 1.0;
  static const double border_width_accent = 2.0;
  static const double avatar_size = 48.0;
  static const double icon_size_large = 48.0;
  static const double icon_size_medium = 24.0;
  static const double icon_size_small = 18.0;
  static const double icon_size_badge = 22.0;
  static const double spacing_small = 6.0;
  static const double spacing_medium = 8.0;
  static const double spacing_large = 12.0;
  static const double spacing_xl = 14.0;
  static const double font_size_title = 16.0;
  static const double font_size_body = 14.0;
  static const double font_size_small = 12.0;
  static const double font_size_tiny = 11.0;
  static const double font_size_micro = 10.0;
  static const double shadow_blur = 8.0;
  static const double shadow_opacity_dark = 0.25;
  static const double shadow_opacity_light = 0.04;
  static const double card_padding = 16.0;
  static const double action_padding = 4.0;
  static const double badge_padding_h = 8.0;
  static const double badge_padding_v = 3.0;
}

// Stateful widget displaying Family Members layout
class FamilyMembersPage extends StatefulWidget {
  // Constructor mapping key
  const FamilyMembersPage({super.key});

  @override
  // Create state tracker instance
  State<FamilyMembersPage> createState() {
    // Return state class instance
    return _FamilyMembersPageState();
  }
}

// State class managing family members list and active profile selection
class _FamilyMembersPageState extends State<FamilyMembersPage> {
  // Active selected family member index tracker
  int _selected_family_index = 0;

  // Mock array list of family members data models
  final List<Map<String, dynamic>> _family_members = [
    {
      'id': '1',
      'name': 'Mark Adam',
      'relationship': 'Self (Primary)',
      'is_primary': true,
      'age': '28 Yrs',
      'dob': '20/7/1998',
      'gender': 'Male',
      'medical_id': 'ID: #8821',
      'icon': Icons.person_rounded,
      'color': AppColors.primary_color,
    },
    {
      'id': '2',
      'name': 'Leo Adam',
      'relationship': 'Son',
      'is_primary': false,
      'age': '4 Yrs',
      'dob': '15/3/2022',
      'gender': 'Male',
      'medical_id': 'ID: #8822',
      'icon': Icons.child_care_rounded,
      'color': AppColors.indigo,
    },
    {
      'id': '3',
      'name': 'Kate Adam',
      'relationship': 'Spouse',
      'is_primary': false,
      'age': '26 Yrs',
      'dob': '12/11/2000',
      'gender': 'Female',
      'medical_id': 'ID: #8823',
      'icon': Icons.face_3_rounded,
      'color': AppColors.teal,
    },
  ];

  // Helper method confirming dependent member deletion popup alert dialog
  void _confirm_member_deletion(
      BuildContext context, String member_name, int index) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialog_context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
          ),
          title: Text(
            localizations.remove_member_title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _LocalDimensions.font_size_title,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "$member_name" from family dependents? Medical history records associated with this profile will be unlinked.',
            style: const TextStyle(
              fontSize: _LocalDimensions.font_size_body,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop();
              },
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialog_context).pop();
                setState(() {
                  _family_members.removeAt(index);
                  if (_selected_family_index >= _family_members.length) {
                    _selected_family_index = 0;
                  } else {
                    // Index is valid
                  }
                });
                CustomSnackBar.success(
                  context,
                  'Member profile removed successfully.',
                );
              },
              child: Text(
                localizations.remove_action,
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return root Scaffold layout container
    return Scaffold(
      // SafeArea protecting mobile notch bounds
      body: SafeArea(
        // Padding safe side margins
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.space_xl,
            right: AppSpacing.space_xl,
            top: AppSpacing.space_xl,
            bottom: AppSpacing.space_m,
          ),
          // Column grouping header bar and vertical list
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header row placing circular back button and centered screen title
              CustomProfileAppBar(
                title: localizations.profile_dependents_title,
              ),
              // Spacing gap
              const SizedBox(height: AppSpacing.space_xl),

              // Active Profile Info Banner Subtitle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${localizations.family_profiles_count} (${_family_members.length})',
                    style: TextStyle(
                      fontSize: _LocalDimensions.font_size_body,
                      fontWeight: FontWeight.bold,
                      color: is_dark
                          ? AppColors.white
                          : AppColors.text_light_primary,
                    ),
                  ),
                  const Text(
                    'Tap card to select profile',
                    style: TextStyle(
                      fontSize: _LocalDimensions.font_size_tiny,
                      color: AppColors.text_light_secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space_s),

              // Vertical list of individual Member Cards
              Expanded(
                child: _family_members.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_off_rounded,
                              size: _LocalDimensions.icon_size_large,
                              color: is_dark
                                  ? AppColors.white38
                                  : AppColors.slate_400,
                            ),
                            const SizedBox(height: _LocalDimensions.spacing_large),
                            const Text(
                              'No family members added yet.',
                              style: TextStyle(
                                fontSize: _LocalDimensions.font_size_body,
                                color: AppColors.text_light_secondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _family_members.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: _LocalDimensions.spacing_large),
                        itemBuilder: (context, index) {
                          final member = _family_members[index];
                          final bool is_selected =
                              index == _selected_family_index;
                          final bool is_primary = true == member['is_primary'];
                          final Color theme_color = member['color'] as Color;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selected_family_index = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: is_dark
                                    ? AppColors.surface_dark
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                                border: Border.all(
                                  color: is_selected
                                      ? AppColors.primary_color
                                      : (is_dark
                                          ? AppColors.border_dark
                                          : AppColors.slate_200),
                                  width: is_selected ? _LocalDimensions.border_width_accent : _LocalDimensions.border_width_thin,
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
                              child: Padding(
                                padding: const EdgeInsets.all(_LocalDimensions.card_padding),
                                child: Row(
                                  children: [
                                    // Leading Element: Circular Avatar with role/gender role color tint
                                    Container(
                                      width: _LocalDimensions.avatar_size,
                                      height: _LocalDimensions.avatar_size,
                                      decoration: BoxDecoration(
                                        color:
                                            theme_color.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        member['icon'] as IconData,
                                        color: theme_color,
                                        size: _LocalDimensions.icon_size_medium,
                                      ),
                                    ),
                                    const SizedBox(width: _LocalDimensions.spacing_xl),

                                    // Middle Section: Name, Relationship Pill Badge & Demographics
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Title & Soft Pill Badge Row
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  member['name'] as String,
                                                  style: TextStyle(
                                                    fontSize: _LocalDimensions.font_size_title,
                                                    fontWeight: FontWeight.w700,
                                                    color: is_dark
                                                        ? AppColors.white
                                                        : AppColors
                                                            .text_light_primary,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: _LocalDimensions.spacing_medium),
                                              // Soft pill-shaped relationship badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: _LocalDimensions.badge_padding_h,
                                                  vertical: _LocalDimensions.badge_padding_v,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: is_primary
                                                      ? AppColors.primary_color
                                                          .withValues(
                                                              alpha: 0.12)
                                                      : theme_color.withValues(
                                                          alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          _LocalDimensions.border_radius_badge),
                                                ),
                                                child: Text(
                                                  member['relationship']
                                                      as String,
                                                  style: TextStyle(
                                                    fontSize: _LocalDimensions.font_size_micro,
                                                    fontWeight: FontWeight.bold,
                                                    color: is_primary
                                                        ? AppColors
                                                            .primary_color
                                                        : theme_color,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: _LocalDimensions.spacing_small),
                                          // Subtitle Details: Age, Gender & Medical ID preview
                                          Text(
                                            '${member['age']} • ${member['gender']} • ${member['medical_id']}',
                                            style: const TextStyle(
                                              fontSize: _LocalDimensions.font_size_small,
                                              color: AppColors
                                                  .text_light_secondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Trailing Actions: Edit, Delete (if dependent), and Chevron
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Subtle edit pencil icon button
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(_LocalDimensions.action_padding),
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            size: _LocalDimensions.icon_size_small,
                                            color: is_dark
                                                ? AppColors.white38
                                                : AppColors.slate_400,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (route_context) =>
                                                    AddFamilyMemberPage(
                                                  member: member,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Subtle delete trash icon button for dependents
                                        if (!is_primary) ...[
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(_LocalDimensions.action_padding),
                                            icon: Icon(
                                              Icons.delete_outline_rounded,
                                              size: _LocalDimensions.icon_size_small,
                                              color: AppColors.error
                                                  .withValues(alpha: 0.7),
                                            ),
                                            onPressed: () {
                                              _confirm_member_deletion(
                                                context,
                                                member['name'] as String,
                                                index,
                                              );
                                            },
                                          ),
                                        ],
                                        // Selection Radio / Chevron indicator
                                        Icon(
                                          is_selected
                                              ? Icons.check_circle_rounded
                                              : Icons.chevron_right_rounded,
                                          color: is_selected
                                              ? AppColors.primary_color
                                              : (is_dark
                                                  ? AppColors.white30
                                                  : AppColors.slate_400),
                                          size: _LocalDimensions.icon_size_badge,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      // Locked Primary Bottom Action CTA Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space_xl),
          child: SizedBox(
            width: double.infinity,
            height: AppSpacing.height_auth_button,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (route_context) => const AddFamilyMemberPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary_color,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_LocalDimensions.border_radius_default),
                ),
              ),
              icon: const Icon(
                Icons.add_rounded,
                color: AppColors.white,
                size: _LocalDimensions.icon_size_medium,
              ),
              label: Text(
                localizations.add_family_member_btn,
                style: const TextStyle(
                  fontSize: AppSpacing.font_size_action_button,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

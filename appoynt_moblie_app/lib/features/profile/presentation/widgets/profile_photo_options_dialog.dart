/*
 * File Name: profile_photo_options_dialog.dart
 * Author: Kholoud Khaled
 * Date of Creation: 28/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Vertical full-width modal bottom sheet options dialog for
 *   updating or deleting patient profile photo with pastel icon badges and destructive styling.
 */

import 'package:flutter/material.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

/// Modal bottom sheet presenting full-width vertical options for updating or removing profile photo
class ProfilePhotoOptionsDialog extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback onDeleteTap;
  final bool hasExistingPhoto;

  const ProfilePhotoOptionsDialog({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
    required this.onDeleteTap,
    this.hasExistingPhoto = true,
  });

  /// Displays the options sheet using showModalBottomSheet
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onGalleryTap,
    required VoidCallback onCameraTap,
    required VoidCallback onDeleteTap,
    bool hasExistingPhoto = true,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) => ProfilePhotoOptionsDialog(
        onGalleryTap: onGalleryTap,
        onCameraTap: onCameraTap,
        onDeleteTap: onDeleteTap,
        hasExistingPhoto: hasExistingPhoto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.white,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate200,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle indicator
          Container(
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: is_dark ? AppColors.slate700 : AppColors.slate300,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 16.0),

          // Title
          Text(
            context.tr('updateProfilePhoto'),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: is_dark ? AppColors.text_dark_primary : AppColors.slate900,
            ),
          ),
          const SizedBox(height: 20.0),

          // 1. Choose from Gallery Option
          _PhotoOptionTile(
            icon: Icons.photo_library_outlined,
            iconColor: AppColors.primary,
            iconBgColor: is_dark ? AppColors.slate800 : AppColors.slate100,
            title: context.tr('chooseFromGallery'),
            onTap: () {
              Navigator.pop(context);
              onGalleryTap();
            },
          ),
          const SizedBox(height: 12.0),

          // 2. Take a Photo Option
          _PhotoOptionTile(
            icon: Icons.camera_alt_outlined,
            iconColor: AppColors.primary,
            iconBgColor: is_dark ? AppColors.slate800 : AppColors.slate100,
            title: context.tr('takePhoto'),
            onTap: () {
              Navigator.pop(context);
              onCameraTap();
            },
          ),

          // 3. Delete Photo Option (Shown only if the user has an existing photo)
          _build_delete_option(context, is_dark),

          const SizedBox(height: 16.0),

          // Cancel Button
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: is_dark ? AppColors.border_dark : AppColors.slate200,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor:
                    is_dark ? AppColors.dark_surface_2 : AppColors.slate50,
              ),
              child: Text(
                context.tr('cancel'),
                style: TextStyle(
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.slate700,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the delete photo option tile when hasExistingPhoto is true
  Widget _build_delete_option(BuildContext context, bool is_dark) {
    if (hasExistingPhoto) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: _PhotoOptionTile(
          icon: Icons.delete_outline_rounded,
          iconColor: AppColors.error,
          iconBgColor:
              is_dark ? AppColors.redDarkBg : AppColors.errorLight,
          title: context.tr('deletePhoto'),
          textColor: AppColors.error,
          onTap: () {
            Navigator.pop(context);
            onDeleteTap();
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _PhotoOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final Color? textColor;
  final VoidCallback onTap;

  const _PhotoOptionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: is_dark ? AppColors.dark_surface_2 : AppColors.slate50,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: is_dark ? AppColors.border_dark : AppColors.slate200,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(icon, color: iconColor, size: 22.0),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: textColor ??
                      (is_dark
                          ? AppColors.text_dark_primary
                          : AppColors.slate800),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.0,
              color: is_dark ? AppColors.slate600 : AppColors.slate400,
            ),
          ],
        ),
      ),
    );
  }
}

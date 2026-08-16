/*
 * File Name: doctor_certificates_gallery.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, app_colors.dart, app_spacing.dart,
 *   app_localizations.dart, app_network_image.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Displays official medical board certifications and accredited
 *   diplomas in a horizontal gallery with tap-to-zoom full screen modal preview and localization.
 */

// Import Flutter material library
import 'package:flutter/material.dart';
// Import layout design tokens, colors, and localization
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
import 'package:appoynt_mobile_app/core/widgets/app_network_image.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Horizontal certificates gallery with full-screen zoom preview.
class DoctorCertificatesGallery extends StatelessWidget {
  // Certificates list
  final List<CertificateEntity> certificates_list;

  // Constant constructor
  const DoctorCertificatesGallery({
    super.key,
    required this.certificates_list,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (certificates_list.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_xl,
        vertical: AppSpacing.space_s,
      ),
      padding: const EdgeInsets.all(AppSpacing.space_xl),
      decoration: BoxDecoration(
        color: is_dark ? AppColors.surface_dark : AppColors.background_light,
        borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
        border: Border.all(
          color: is_dark ? AppColors.border_dark : AppColors.slate_200,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.deepPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  size: 20.0,
                  color: AppColors.deepPurple,
                ),
              ),
              const SizedBox(width: AppSpacing.space_m),
              Text(
                localizations.certificates_label,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_title_medium,
                  fontWeight: FontWeight.w700,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space_l),

          // Horizontal scrollable list
          SizedBox(
            height: 175.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: certificates_list.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.space_m),
              itemBuilder: (context, index) {
                final cert = certificates_list[index];
                return _build_certificate_card(context, cert, is_dark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_certificate_card(
    BuildContext context,
    CertificateEntity cert,
    bool is_dark,
  ) {
    return GestureDetector(
      onTap: () => _show_full_screen_certificate(context, cert),
      child: Container(
        width: 150.0,
        decoration: BoxDecoration(
          color: is_dark
              ? AppColors.inner_container_dark
              : AppColors.slate_100,
          borderRadius: BorderRadius.circular(AppSpacing.radius_l),
          border: Border.all(
            color: is_dark ? AppColors.border_dark : AppColors.slate_200,
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Image
            Stack(
              children: [
                AppNetworkImage(
                  image_url: cert.image_url,
                  width: 150.0,
                  height: 95.0,
                  border_radius: 0.0,
                  fallback_icon: Icons.workspace_premium_rounded,
                ),
                Positioned(
                  top: 6.0,
                  right: 6.0,
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.zoom_in_rounded,
                      color: AppColors.white,
                      size: 14.0,
                    ),
                  ),
                ),
              ],
            ),

            // Certificate Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cert.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppSpacing.font_size_caption,
                      fontWeight: FontWeight.w700,
                      color: is_dark
                          ? AppColors.text_dark_primary
                          : AppColors.text_light_primary,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    cert.issue_date,
                    style: TextStyle(
                      fontSize: AppSpacing.font_size_caption - 1.0,
                      color: is_dark
                          ? AppColors.text_dark_secondary
                          : AppColors.text_light_secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _show_full_screen_certificate(
    BuildContext context,
    CertificateEntity cert,
  ) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.85),
      builder: (dialog_context) {
        return Dialog(
          backgroundColor: AppColors.transparent,
          insetPadding: const EdgeInsets.all(AppSpacing.space_m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Title and Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cert.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppSpacing.font_size_title_medium,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.white,
                      size: 28.0,
                    ),
                    onPressed: () => Navigator.of(dialog_context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space_m),

              // Zoomable Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radius_xl),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: AppNetworkImage(
                      image_url: cert.image_url,
                      width: double.infinity,
                      height: 350.0,
                      border_radius: 0.0,
                      fallback_icon: Icons.workspace_premium_rounded,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

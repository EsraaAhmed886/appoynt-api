/*
 * File Name: doctor_profile_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.1.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   app_colors.dart, app_spacing.dart, service_locator.dart, doctor_profile_cubit.dart,
 *   doctor_profile_state.dart, doctor_hero_header.dart, doctor_quick_stats_row.dart,
 *   doctor_about_section.dart, doctor_timeline_section.dart, doctor_procedures_section.dart,
 *   doctor_certificates_gallery.dart, doctor_media_gallery.dart,
 *   doctor_sticky_booking_bar.dart, favorite_heart_button.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Comprehensive Doctor Profile page implementing a fluid
 *   CustomScrollView with collapsible SliverAppBar, interactive medical sections,
 *   credentials galleries, and sticky confirmation bar with safe bottom padding.
 */

// Import Flutter framework
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import design tokens and colors
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Import Cubit and State
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/cubit/doctor_profile_cubit.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/cubit/doctor_profile_state.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';
// Import Components
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_hero_header.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_quick_stats_row.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_about_section.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_timeline_section.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_procedures_section.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_certificates_gallery.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_media_gallery.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_reviews_section.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/presentation/widgets/doctor_sticky_booking_bar.dart';

/// Arguments bundle for navigating to DoctorProfilePage.
class DoctorProfileArgs {
  final String doctor_id;

  const DoctorProfileArgs({
    required this.doctor_id,
  });
}

/// Main entry page for the Doctor Profile feature.
class DoctorProfilePage extends StatelessWidget {
  // Doctor ID parameter
  final String doctor_id;

  // Constant constructor
  const DoctorProfilePage({
    super.key,
    required this.doctor_id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorProfileCubit>(
      create: (_) => get_it<DoctorProfileCubit>()..load_doctor_profile(doctor_id),
      child: _DoctorProfileView(doctor_id: doctor_id),
    );
  }
}

class _DoctorProfileView extends StatelessWidget {
  final String doctor_id;

  const _DoctorProfileView({
    required this.doctor_id,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          is_dark ? AppColors.background_dark : AppColors.scaffold_light,
      body: BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
        listener: (context, state) {
          // Listen for any toast or snackbar notifications
        },
        builder: (context, state) {
          if (state is DoctorProfileLoading || state is DoctorProfileInitial) {
            return _build_loading_shimmer(context, is_dark);
          } else if (state is DoctorProfileError) {
            return _build_error_view(context, state.error_message, is_dark);
          } else if (state is DoctorProfileLoaded) {
            return _build_loaded_content(context, state, is_dark);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _build_loaded_content(
    BuildContext context,
    DoctorProfileLoaded state,
    bool is_dark,
  ) {
    final DoctorProfileEntity profile = state.profile;
    final cubit = context.read<DoctorProfileCubit>();

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Scrollable Content with Edge-to-Edge Hero Header
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // 1. Edge-to-Edge Hero Banner Header
                  DoctorHeroHeader(
                    profile: profile,
                    is_favorite: state.is_favorited,
                    on_favorite_tap: () => cubit.toggle_favorite(),
                    on_back_tap: () => Navigator.of(context).pop(),
                  ),

                  // 2. Quick 4-Stat Banner
                  DoctorQuickStatsRow(profile: profile),

                  // 3. Biography Section
                  DoctorAboutSection(bio: profile.bio),

                  // 4. Clinical Career & Education Timeline
                  DoctorTimelineSection(
                    experience_list: profile.experience_list,
                    education_list: profile.education_list,
                  ),

                  // 5. Procedures & Services Wrap
                  DoctorProceduresSection(
                    procedures_list: profile.procedures_list,
                  ),

                  // 6. Certificates & Accreditation Gallery
                  DoctorCertificatesGallery(
                    certificates_list: profile.certificates_list,
                  ),

                  // 7. Media Gallery (Photos & Video Tours)
                  DoctorMediaGallery(
                    media_list: profile.media_list,
                  ),

                  // 8. Verified Patient Reviews
                  DoctorReviewsSection(profile: profile),

                  // Bottom padding spacer to clear floating bottom bar
                  const SizedBox(height: 120.0),
                ],
              ),
            ),
          ],
        ),

        // Sticky Bottom Booking Floating Bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DoctorStickyBookingBar(
            profile: profile,
            on_book_pressed: () {
              // Placeholder preparing for upcoming ChooseSlotsPage navigation
            },
          ),
        ),
      ],
    );
  }

  Widget _build_loading_shimmer(BuildContext context, bool is_dark) {
    return Scaffold(
      backgroundColor:
          is_dark ? AppColors.background_dark : AppColors.scaffold_light,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: is_dark
                ? AppColors.text_dark_primary
                : AppColors.text_light_primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primary_color,
            ),
            const SizedBox(height: AppSpacing.space_l),
            Text(
              'Loading Doctor Profile...',
              style: TextStyle(
                fontSize: AppSpacing.font_size_body_medium,
                fontWeight: FontWeight.w600,
                color: is_dark
                    ? AppColors.text_dark_secondary
                    : AppColors.text_light_secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build_error_view(
    BuildContext context,
    String message,
    bool is_dark,
  ) {
    return Scaffold(
      backgroundColor:
          is_dark ? AppColors.background_dark : AppColors.scaffold_light,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: is_dark
                ? AppColors.text_dark_primary
                : AppColors.text_light_primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space_xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64.0,
                color: AppColors.red,
              ),
              const SizedBox(height: AppSpacing.space_l),
              Text(
                'Could Not Load Profile',
                style: TextStyle(
                  fontSize: AppSpacing.font_size_title_large,
                  fontWeight: FontWeight.w700,
                  color: is_dark
                      ? AppColors.text_dark_primary
                      : AppColors.text_light_primary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_s),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSpacing.font_size_body_medium,
                  color: is_dark
                      ? AppColors.text_dark_secondary
                      : AppColors.text_light_secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.space_xxl),
              ElevatedButton(
                onPressed: () => context
                    .read<DoctorProfileCubit>()
                    .load_doctor_profile(doctor_id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary_color,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xxl,
                    vertical: AppSpacing.space_l,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radius_l),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

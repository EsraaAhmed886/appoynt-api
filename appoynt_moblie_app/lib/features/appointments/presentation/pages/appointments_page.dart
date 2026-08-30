/*
 * File Name: appointments_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: V1.2.0
 * Dependencies: flutter/material.dart, flutter_bloc,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/core/localization/appointments_strings.dart,
 *   package:appoynt_mobile_app/core/routing/routes.dart,
 *   package:appoynt_mobile_app/core/utils/custom_snackbar.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/08/2026]
 * File Description: Master Appointments screen composing tabs, debounced search, active filters, cards, cancellation & rescheduling flows, recommendations, and AI assistant FAB.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointments_mock_repository.dart';
import '../bloc/appointments_bloc.dart';
import '../bloc/appointments_event.dart';
import '../bloc/appointments_state.dart';
import '../widgets/appointment_cancellation_dialog.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointments_filter_modal.dart';
import '../widgets/appointment_reschedule_bottom_sheet.dart';
import '../widgets/appointments_empty_state.dart';
import '../widgets/appointments_header.dart';
import '../widgets/appointments_search_bar.dart';
import '../widgets/appointments_tab_bar.dart';
import '../widgets/quick_actions_strip.dart';
import '../widgets/recommendation_banner.dart';

/// Main screen entry widget for Patient Appointments module.
class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentsBloc(
        repository: AppointmentsMockRepository(),
      )
        ..add(const LoadAppointmentsTab(AppointmentTabType.upcoming))
        ..add(const RefreshQuickActions())
        ..add(const RefreshRecommendations()),
      child: const _AppointmentsView(),
    );
  }
}

class _AppointmentsView extends StatefulWidget {
  const _AppointmentsView();

  @override
  State<_AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<_AppointmentsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<AppointmentsBloc>().add(const LoadMoreAppointments());
    } else {
      // No action needed
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabSelected(AppointmentTabType tab) {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    context.read<AppointmentsBloc>().add(LoadAppointmentsTab(tab));
  }

  void _openFilterModal(AppointmentsState state) {
    AppointmentsFilterModal.show(
      context: context,
      initialFilter: state.activeFilter,
      onApply: (newFilter) {
        context.read<AppointmentsBloc>().add(ApplyFilter(newFilter));
      },
    );
  }

  void _openCancelDialog(AppointmentModel appt) {
    AppointmentCancellationDialog.show(
      context: context,
      appointment: appt,
      onConfirm: (reason) {
        context.read<AppointmentsBloc>().add(
              CancelAppointmentRequested(appt.id, reason: reason),
            );
      },
    );
  }

  void _openRescheduleSheet(AppointmentModel appt) {
    final repo = context.read<AppointmentsBloc>().repository;
    AppointmentRescheduleBottomSheet.show(
      context: context,
      appointment: appt,
      repository: repo,
      onConfirm: (newDateTime) {
        context.read<AppointmentsBloc>().add(
              RescheduleAppointmentRequested(appt.id, newDateTime),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.slate900 : AppColors.slate50,
      body: SafeArea(
        child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
          listener: (context, state) {
            if (null != state.actionSuccessMessage) {
              CustomSnackBar.success(
                context,
                AppointmentsStrings.of(context, state.actionSuccessMessage!),
              );
            } else {
              // No action needed
            }
            if (null != state.errorMessage) {
              CustomSnackBar.error(
                context,
                state.errorMessage!,
              );
            } else {
              // No action needed
            }
          },
          builder: (context, state) {
            final appointments = state.currentTabAppointments;

            return Column(
              children: [
                // ==========================================
                // 1. FIXED TOP SECTION (Pinned on Scroll)
                // ==========================================
                Container(
                  color: isDark ? AppColors.slate900 : AppColors.slate50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1.1 Header Title & Notification Icon
                      const AppointmentsHeader(),

                      // 1.2 Category Filter Chips (Upcoming, Completed, Cancelled, All)
                      AppointmentsTabBar(
                        activeTab: state.activeTab,
                        onTabSelected: _onTabSelected,
                      ),

                      // 1.3 Search Bar & Filter Button
                      AppointmentsSearchBar(
                        initialQuery: state.searchQuery,
                        onQueryChanged: (query) {
                          context
                              .read<AppointmentsBloc>()
                              .add(SearchQueryChanged(query));
                        },
                        onFilterTap: () => _openFilterModal(state),
                        activeFiltersCount:
                            state.activeFilter.activeFiltersCount,
                      ),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                ),

                // ==========================================
                // 2. SCROLLABLE BODY CONTENT
                // ==========================================
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<AppointmentsBloc>().add(
                            LoadAppointmentsTab(state.activeTab,
                                forceRefresh: true),
                          );
                      context
                          .read<AppointmentsBloc>()
                          .add(const RefreshQuickActions());
                      context
                          .read<AppointmentsBloc>()
                          .add(const RefreshRecommendations());
                    },
                    color: AppColors.sky600,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        // 2.1 Quick Actions Strip (Prescriptions, Labs, Radiology - Guarded)
                        _build_quick_actions_sliver(state),

                        // 2.2 Appointments List / Empty State / Loader
                        ..._build_main_appointments_slivers(
                            context, state, appointments),

                        // 2.3 Recommendation Banner (Conditional on query being empty)
                        _build_recommendations_sliver(state),

                        const SliverToBoxAdapter(
                          child: SizedBox(
                              height: 80.0), // Padding for bottom nav / FAB
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds the quick actions sliver if summary resources exist.
  Widget _build_quick_actions_sliver(AppointmentsState state) {
    if (state.shouldShowQuickActions) {
      return SliverToBoxAdapter(
        child: QuickActionsStrip(
          summary: state.quickActionsSummary,
        ),
      );
    } else {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  /// Builds the main appointments list, empty state, or loading indicator.
  List<Widget> _build_main_appointments_slivers(
    BuildContext context,
    AppointmentsState state,
    List<AppointmentModel> appointments,
  ) {
    if (state.isLoading) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.sky600,
            ),
          ),
        ),
      ];
    } else if (appointments.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppointmentsEmptyState(
            tab: state.activeTab,
            isSearching: state.searchQuery.trim().isNotEmpty,
            isFiltering: state.activeFilter.isActive,
            onActionTap: () {
              // Navigate to Search to book appointment
            },
          ),
        ),
      ];
    } else {
      final List<Widget> slivers = [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final appt = appointments[index];
              return AppointmentCard(
                appointment: appt,
                onViewDetails: () {
                  Navigator.pushNamed(
                    context,
                    Routes.doctor_profile,
                    arguments: appt.doctorId,
                  );
                },
                onCancel: () => _openCancelDialog(appt),
                onReschedule: () => _openRescheduleSheet(appt),
                onJoinCall: () {
                  CustomSnackBar.success(
                    context,
                    'Joining video call with ${appt.doctorName}...',
                  );
                },
                onBookAgain: () {
                  Navigator.pushNamed(
                    context,
                    Routes.choose_slots,
                    arguments: appt.doctorId,
                  );
                },
              );
            },
            childCount: appointments.length,
          ),
        ),
      ];

      if (state.isLoadMoreLoading) {
        slivers.add(
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: AppColors.sky600,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        // No action needed
      }

      return slivers;
    }
  }

  /// Builds the recommendation banner sliver if recommendations exist.
  Widget _build_recommendations_sliver(AppointmentsState state) {
    if (state.shouldShowRecommendations) {
      return SliverToBoxAdapter(
        child: RecommendationBanner(
          recommendations: state.recommendations,
          onBookTap: (doc) {
            Navigator.pushNamed(
              context,
              Routes.choose_slots,
              arguments: doc.id,
            );
          },
        ),
      );
    } else {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}

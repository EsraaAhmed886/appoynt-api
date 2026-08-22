/*
 * File Name: appointments_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Dependencies: flutter/material.dart, flutter_bloc, appointments_strings.dart, routes.dart, appointment_model.dart, appointments_mock_repository.dart, appointments_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Master Appointments screen composing tabs, debounced search, active filters, cards, cancellation & rescheduling flows, recommendations, and AI assistant FAB.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/appointments_strings.dart';
import '../../../../core/routing/routes.dart';
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
import '../widgets/ask_ai_fab.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      floatingActionButton: AskAiFab(
        onTap: () {
          // Open AI Assistant modal / sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppointmentsStrings.of(context, 'ask_ai')),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
      body: SafeArea(
        child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
          listener: (context, state) {
            if (state.actionSuccessMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppointmentsStrings.of(context, state.actionSuccessMessage!)),
                  backgroundColor: const Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final appointments = state.currentTabAppointments;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AppointmentsBloc>().add(
                      LoadAppointmentsTab(state.activeTab, forceRefresh: true),
                    );
                context.read<AppointmentsBloc>().add(const RefreshQuickActions());
                context.read<AppointmentsBloc>().add(const RefreshRecommendations());
              },
              color: const Color(0xFF0284C7),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // 1. Header (Title, Notification, Profile)
                  const SliverToBoxAdapter(
                    child: AppointmentsHeader(),
                  ),

                  // 2. Tab Bar (Upcoming, Completed, Cancelled, All)
                  SliverToBoxAdapter(
                    child: AppointmentsTabBar(
                      activeTab: state.activeTab,
                      onTabSelected: _onTabSelected,
                    ),
                  ),

                  // 3. Search & Filter Bar
                  SliverToBoxAdapter(
                    child: AppointmentsSearchBar(
                      initialQuery: state.searchQuery,
                      onQueryChanged: (query) {
                        context.read<AppointmentsBloc>().add(SearchQueryChanged(query));
                      },
                      onFilterTap: () => _openFilterModal(state),
                      activeFiltersCount: state.activeFilter.activeFiltersCount,
                    ),
                  ),

                  // 4. Quick Actions Strip (Prescriptions, Labs, Radiology - Guarded)
                  if (state.shouldShowQuickActions)
                    SliverToBoxAdapter(
                      child: QuickActionsStrip(
                        summary: state.quickActionsSummary,
                      ),
                    ),

                  // 5. Appointments List / Empty State / Loader
                  if (state.isLoading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    )
                  else if (appointments.isEmpty)
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
                    )
                  else ...[
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Joining video call with ${appt.doctorName}...'),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
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

                    // Loading indicator for pagination
                    if (state.isLoadMoreLoading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],

                  // 6. Recommendation Banner (Conditional on query being empty)
                  if (state.shouldShowRecommendations)
                    SliverToBoxAdapter(
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
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80.0), // Padding for bottom nav / FAB
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

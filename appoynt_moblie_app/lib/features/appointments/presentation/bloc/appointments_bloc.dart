/*
 * File Name: appointments_bloc.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter_bloc, dartz, ../../data/models/appointment_model.dart, ../../data/models/appointment_filter_model.dart, ../../data/repositories/appointments_mock_repository.dart, ./appointments_event.dart, ./appointments_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Main business logic component managing appointment tabs, debounced search, filtering, pagination, cancellation, and rescheduling workflows.
 */

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/appointment_filter_model.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointments_mock_repository.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

/// Event transformer for 300ms search input debouncing.
EventTransformer<E> debounceTransformer<E>(Duration duration) {
  return (events, mapper) => events.transform(_DebounceStreamTransformer<E>(duration)).asyncExpand(mapper);
}

class _DebounceStreamTransformer<E> extends StreamTransformerBase<E, E> {
  final Duration duration;
  const _DebounceStreamTransformer(this.duration);

  @override
  Stream<E> bind(Stream<E> stream) {
    Timer? timer;
    late final StreamController<E> controller;

    controller = StreamController<E>(
      onListen: () {
        final subscription = stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () {
              if (!controller.isClosed) {
                controller.add(data);
              } else {
                // No action needed
              }
            });
          },
          onError: (error, stackTrace) => controller.addError(error, stackTrace),
          onDone: () => timer?.cancel(),
        );

        controller.onCancel = () {
          timer?.cancel();
          return subscription.cancel();
        };
      },
    );

    return controller.stream;
  }
}

/// BLoC state controller for the Appointments module.
class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentsRepository repository;

  AppointmentsBloc({required this.repository}) : super(const AppointmentsState()) {
    on<LoadAppointmentsTab>(_onLoadAppointmentsTab);
    on<SearchQueryChanged>(_onSearchQueryChanged, transformer: debounceTransformer(const Duration(milliseconds: 300)));
    on<ApplyFilter>(_onApplyFilter);
    on<ClearFilters>(_onClearFilters);
    on<LoadMoreAppointments>(_onLoadMoreAppointments);
    on<CancelAppointmentRequested>(_onCancelAppointmentRequested);
    on<RescheduleAppointmentRequested>(_onRescheduleAppointmentRequested);
    on<RefreshQuickActions>(_onRefreshQuickActions);
    on<RefreshRecommendations>(_onRefreshRecommendations);
  }

  Future<void> _onLoadAppointmentsTab(
    LoadAppointmentsTab event,
    Emitter<AppointmentsState> emit,
  ) async {
    final isSwitchingTab = event.tab != state.activeTab;

    // When switching tabs, clear search text and active filters (BR-03, BR-04, VR-03)
    final newSearchQuery = isSwitchingTab ? '' : state.searchQuery;
    final newFilter = isSwitchingTab ? const AppointmentFilter() : state.activeFilter;

    emit(state.copyWith(
      activeTab: event.tab,
      searchQuery: newSearchQuery,
      activeFilter: newFilter,
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final items = await repository.getAppointments(
        tab: event.tab,
        searchQuery: newSearchQuery,
        filter: newFilter,
        page: 1,
        pageSize: 20,
      );

      final hasReachedMax = items.length < 20;

      switch (event.tab) {
        case AppointmentTabType.upcoming:
          emit(state.copyWith(
            isLoading: false,
            upcomingAppointments: items,
            upcomingPage: 1,
            upcomingHasReachedMax: hasReachedMax,
          ));
          break;
        case AppointmentTabType.completed:
          emit(state.copyWith(
            isLoading: false,
            completedAppointments: items,
            completedPage: 1,
            completedHasReachedMax: hasReachedMax,
          ));
          break;
        case AppointmentTabType.cancelled:
          emit(state.copyWith(
            isLoading: false,
            cancelledAppointments: items,
            cancelledPage: 1,
            cancelledHasReachedMax: hasReachedMax,
          ));
          break;
        case AppointmentTabType.all:
          emit(state.copyWith(
            isLoading: false,
            allAppointments: items,
            allPage: 1,
            allHasReachedMax: hasReachedMax,
          ));
          break;
        default:
          emit(state.copyWith(
            isLoading: false,
            allAppointments: items,
            allPage: 1,
            allHasReachedMax: hasReachedMax,
          ));
          break;
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load appointments.',
      ));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(state.copyWith(
      searchQuery: event.query,
      isLoading: true,
      clearError: true,
    ));

    try {
      final items = await repository.getAppointments(
        tab: state.activeTab,
        searchQuery: event.query,
        filter: state.activeFilter,
        page: 1,
        pageSize: 20,
      );

      final hasReachedMax = items.length < 20;
      _updateTabAppointments(emit, state.activeTab, items, 1, hasReachedMax);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to search appointments.',
      ));
    }
  }

  Future<void> _onApplyFilter(
    ApplyFilter event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(state.copyWith(
      activeFilter: event.filter,
      isLoading: true,
      clearError: true,
    ));

    try {
      final items = await repository.getAppointments(
        tab: state.activeTab,
        searchQuery: state.searchQuery,
        filter: event.filter,
        page: 1,
        pageSize: 20,
      );

      final hasReachedMax = items.length < 20;
      _updateTabAppointments(emit, state.activeTab, items, 1, hasReachedMax);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to apply filter.',
      ));
    }
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(state.copyWith(
      activeFilter: const AppointmentFilter(),
      isLoading: true,
      clearError: true,
    ));

    try {
      final items = await repository.getAppointments(
        tab: state.activeTab,
        searchQuery: state.searchQuery,
        filter: const AppointmentFilter(),
        page: 1,
        pageSize: 20,
      );

      final hasReachedMax = items.length < 20;
      _updateTabAppointments(emit, state.activeTab, items, 1, hasReachedMax);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to clear filters.',
      ));
    }
  }

  Future<void> _onLoadMoreAppointments(
    LoadMoreAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    if (state.isLoadMoreLoading || state.currentTabHasReachedMax) {
      return;
    } else {
      emit(state.copyWith(isLoadMoreLoading: true));

      final nextPage = _getCurrentPage(state.activeTab) + 1;

      try {
        final newItems = await repository.getAppointments(
          tab: state.activeTab,
          searchQuery: state.searchQuery,
          filter: state.activeFilter,
          page: nextPage,
          pageSize: 20,
        );

        final currentList = state.currentTabAppointments;
        final existingIds = currentList.map((a) => a.id).toSet();
        final deduplicatedNewItems = newItems.where((a) => !existingIds.contains(a.id)).toList();
        final merged = [...currentList, ...deduplicatedNewItems];
        final hasReachedMax = newItems.length < 20;

        _updateTabAppointments(emit, state.activeTab, merged, nextPage, hasReachedMax, isLoadMore: true);
      } catch (e) {
        emit(state.copyWith(isLoadMoreLoading: false));
      }
    }
  }

  Future<void> _onCancelAppointmentRequested(
    CancelAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      final cancelled = await repository.cancelAppointment(
        event.appointmentId,
        reason: event.reason,
      );

      // 1. Remove from Upcoming
      final updatedUpcoming = state.upcomingAppointments.where((a) => a.id != event.appointmentId).toList();

      // 2. Add to / Update in Cancelled list
      final updatedCancelled = [cancelled, ...state.cancelledAppointments.where((a) => a.id != event.appointmentId)];

      // 3. Update in All list
      final updatedAll = state.allAppointments.map((a) => a.id == event.appointmentId ? cancelled : a).toList();

      emit(state.copyWith(
        upcomingAppointments: updatedUpcoming,
        cancelledAppointments: updatedCancelled,
        allAppointments: updatedAll,
        actionSuccessMessage: 'appointment_cancelled_success',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onRescheduleAppointmentRequested(
    RescheduleAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      final rescheduled = await repository.rescheduleAppointment(
        event.appointmentId,
        event.newDateTime,
      );

      // Re-sort upcoming with new date
      final updatedUpcoming = state.upcomingAppointments.map((a) => a.id == event.appointmentId ? rescheduled : a).toList()
        ..sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));

      final updatedAll = state.allAppointments.map((a) => a.id == event.appointmentId ? rescheduled : a).toList();

      emit(state.copyWith(
        upcomingAppointments: updatedUpcoming,
        allAppointments: updatedAll,
        actionSuccessMessage: 'appointment_rescheduled_success',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to reschedule appointment.',
      ));
    }
  }

  Future<void> _onRefreshQuickActions(
    RefreshQuickActions event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(state.copyWith(isQuickActionsLoading: true));
    try {
      final summary = await repository.getQuickActionsSummary();
      emit(state.copyWith(
        quickActionsSummary: summary,
        isQuickActionsLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isQuickActionsLoading: false));
    }
  }

  Future<void> _onRefreshRecommendations(
    RefreshRecommendations event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(state.copyWith(isRecommendationsLoading: true));
    try {
      final list = await repository.getDoctorRecommendations();
      emit(state.copyWith(
        recommendations: list,
        isRecommendationsLoading: false,
      ));
    } catch (_) {
      emit(state.copyWith(isRecommendationsLoading: false));
    }
  }

  int _getCurrentPage(AppointmentTabType tab) {
    switch (tab) {
      case AppointmentTabType.upcoming:
        return state.upcomingPage;
      case AppointmentTabType.completed:
        return state.completedPage;
      case AppointmentTabType.cancelled:
        return state.cancelledPage;
      case AppointmentTabType.all:
        return state.allPage;
      default:
        return 1;
    }
  }

  void _updateTabAppointments(
    Emitter<AppointmentsState> emit,
    AppointmentTabType tab,
    List<AppointmentModel> items,
    int page,
    bool hasReachedMax, {
    bool isLoadMore = false,
  }) {
    switch (tab) {
      case AppointmentTabType.upcoming:
        emit(state.copyWith(
          isLoading: false,
          isLoadMoreLoading: false,
          upcomingAppointments: items,
          upcomingPage: page,
          upcomingHasReachedMax: hasReachedMax,
        ));
        break;
      case AppointmentTabType.completed:
        emit(state.copyWith(
          isLoading: false,
          isLoadMoreLoading: false,
          completedAppointments: items,
          completedPage: page,
          completedHasReachedMax: hasReachedMax,
        ));
        break;
      case AppointmentTabType.cancelled:
        emit(state.copyWith(
          isLoading: false,
          isLoadMoreLoading: false,
          cancelledAppointments: items,
          cancelledPage: page,
          cancelledHasReachedMax: hasReachedMax,
        ));
        break;
      case AppointmentTabType.all:
        emit(state.copyWith(
          isLoading: false,
          isLoadMoreLoading: false,
          allAppointments: items,
          allPage: page,
          allHasReachedMax: hasReachedMax,
        ));
        break;
      default:
        emit(state.copyWith(
          isLoading: false,
          isLoadMoreLoading: false,
          allAppointments: items,
          allPage: page,
          allHasReachedMax: hasReachedMax,
        ));
        break;
    }
  }
}

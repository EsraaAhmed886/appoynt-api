/*
 * File Name: appointments_state.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: ../../data/models/appointment_model.dart, ../../data/models/appointment_filter_model.dart, ../../data/models/quick_action_item_model.dart, ../../data/models/doctor_recommendation_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Defines the immutable state container for the Appointments module with tab-isolated cached datasets and pagination cursors.
 */

import 'package:equatable/equatable.dart';
import '../../data/models/appointment_filter_model.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/doctor_recommendation_model.dart';
import '../../data/models/quick_action_item_model.dart';

/// Immutable state holding all tab datasets, filters, search, and pagination indices.
class AppointmentsState extends Equatable {
  // Active Tab
  final AppointmentTabType activeTab;

  // Search & Filter
  final String searchQuery;
  final AppointmentFilter activeFilter;

  // Loading States
  final bool isLoading;
  final bool isLoadMoreLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final String? actionSuccessMessage;

  // Tab-Isolated Cached Appointment Lists
  final List<AppointmentModel> upcomingAppointments;
  final List<AppointmentModel> completedAppointments;
  final List<AppointmentModel> cancelledAppointments;
  final List<AppointmentModel> allAppointments;

  // Pagination Cursors per Tab
  final int upcomingPage;
  final bool upcomingHasReachedMax;
  final int completedPage;
  final bool completedHasReachedMax;
  final int cancelledPage;
  final bool cancelledHasReachedMax;
  final int allPage;
  final bool allHasReachedMax;

  // Auxiliary Section States
  final QuickActionsSummaryModel? quickActionsSummary;
  final bool isQuickActionsLoading;
  final List<DoctorRecommendationModel> recommendations;
  final bool isRecommendationsLoading;

  const AppointmentsState({
    this.activeTab = AppointmentTabType.upcoming,
    this.searchQuery = '',
    this.activeFilter = const AppointmentFilter(),
    this.isLoading = true,
    this.isLoadMoreLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.actionSuccessMessage,
    this.upcomingAppointments = const [],
    this.completedAppointments = const [],
    this.cancelledAppointments = const [],
    this.allAppointments = const [],
    this.upcomingPage = 1,
    this.upcomingHasReachedMax = false,
    this.completedPage = 1,
    this.completedHasReachedMax = false,
    this.cancelledPage = 1,
    this.cancelledHasReachedMax = false,
    this.allPage = 1,
    this.allHasReachedMax = false,
    this.quickActionsSummary,
    this.isQuickActionsLoading = true,
    this.recommendations = const [],
    this.isRecommendationsLoading = true,
  });

  /// Returns appointments corresponding strictly to the currently active tab.
  List<AppointmentModel> get currentTabAppointments {
    switch (activeTab) {
      case AppointmentTabType.upcoming:
        return upcomingAppointments;
      case AppointmentTabType.completed:
        return completedAppointments;
      case AppointmentTabType.cancelled:
        return cancelledAppointments;
      case AppointmentTabType.all:
        return allAppointments;
      default:
        return upcomingAppointments;
    }
  }

  /// Returns pagination status of the currently active tab.
  bool get currentTabHasReachedMax {
    switch (activeTab) {
      case AppointmentTabType.upcoming:
        return upcomingHasReachedMax;
      case AppointmentTabType.completed:
        return completedHasReachedMax;
      case AppointmentTabType.cancelled:
        return cancelledHasReachedMax;
      case AppointmentTabType.all:
        return allHasReachedMax;
      default:
        return upcomingHasReachedMax;
    }
  }

  /// Checks if current tab list is completely empty.
  bool get isCurrentTabEmpty => currentTabAppointments.isEmpty;

  /// Checks if recommendations banner should be rendered (BR-63).
  /// Hidden instantly when search is active or list is empty.
  bool get shouldShowRecommendations =>
      recommendations.isNotEmpty && searchQuery.trim().isEmpty;

  /// Checks if quick actions strip should be displayed (BR-34).
  /// Hidden when total resources equal 0.
  bool get shouldShowQuickActions =>
      quickActionsSummary != null && quickActionsSummary!.hasAnyResources;

  /// Creates a copy of this state with specified replacements.
  AppointmentsState copyWith({
    AppointmentTabType? activeTab,
    String? searchQuery,
    AppointmentFilter? activeFilter,
    bool? isLoading,
    bool? isLoadMoreLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    String? actionSuccessMessage,
    bool clearSuccess = false,
    List<AppointmentModel>? upcomingAppointments,
    List<AppointmentModel>? completedAppointments,
    List<AppointmentModel>? cancelledAppointments,
    List<AppointmentModel>? allAppointments,
    int? upcomingPage,
    bool? upcomingHasReachedMax,
    int? completedPage,
    bool? completedHasReachedMax,
    int? cancelledPage,
    bool? cancelledHasReachedMax,
    int? allPage,
    bool? allHasReachedMax,
    QuickActionsSummaryModel? quickActionsSummary,
    bool? isQuickActionsLoading,
    List<DoctorRecommendationModel>? recommendations,
    bool? isRecommendationsLoading,
  }) {
    return AppointmentsState(
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter ?? this.activeFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadMoreLoading: isLoadMoreLoading ?? this.isLoadMoreLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionSuccessMessage:
          clearSuccess ? null : (actionSuccessMessage ?? this.actionSuccessMessage),
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      completedAppointments: completedAppointments ?? this.completedAppointments,
      cancelledAppointments: cancelledAppointments ?? this.cancelledAppointments,
      allAppointments: allAppointments ?? this.allAppointments,
      upcomingPage: upcomingPage ?? this.upcomingPage,
      upcomingHasReachedMax:
          upcomingHasReachedMax ?? this.upcomingHasReachedMax,
      completedPage: completedPage ?? this.completedPage,
      completedHasReachedMax:
          completedHasReachedMax ?? this.completedHasReachedMax,
      cancelledPage: cancelledPage ?? this.cancelledPage,
      cancelledHasReachedMax:
          cancelledHasReachedMax ?? this.cancelledHasReachedMax,
      allPage: allPage ?? this.allPage,
      allHasReachedMax: allHasReachedMax ?? this.allHasReachedMax,
      quickActionsSummary: quickActionsSummary ?? this.quickActionsSummary,
      isQuickActionsLoading:
          isQuickActionsLoading ?? this.isQuickActionsLoading,
      recommendations: recommendations ?? this.recommendations,
      isRecommendationsLoading:
          isRecommendationsLoading ?? this.isRecommendationsLoading,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        searchQuery,
        activeFilter,
        isLoading,
        isLoadMoreLoading,
        isRefreshing,
        errorMessage,
        actionSuccessMessage,
        upcomingAppointments,
        completedAppointments,
        cancelledAppointments,
        allAppointments,
        upcomingPage,
        upcomingHasReachedMax,
        completedPage,
        completedHasReachedMax,
        cancelledPage,
        cancelledHasReachedMax,
        allPage,
        allHasReachedMax,
        quickActionsSummary,
        isQuickActionsLoading,
        recommendations,
        isRecommendationsLoading,
      ];
}

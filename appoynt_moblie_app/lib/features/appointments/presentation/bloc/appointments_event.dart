/*
 * File Name: appointments_event.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: ../../data/models/appointment_model.dart, ../../data/models/appointment_filter_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Defines the complete set of BLoC event triggers for the Appointments mobile screen.
 */

import 'package:equatable/equatable.dart';
import '../../data/models/appointment_filter_model.dart';
import '../../data/models/appointment_model.dart';

/// Base abstract event for the Appointments BLoC.
abstract class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers initial load or tab switch for an appointments category.
class LoadAppointmentsTab extends AppointmentsEvent {
  final AppointmentTabType tab;
  final bool forceRefresh;

  const LoadAppointmentsTab(this.tab, {this.forceRefresh = false});

  @override
  List<Object?> get props => [tab, forceRefresh];
}

/// Dispatched when the user enters or clears search query input.
class SearchQueryChanged extends AppointmentsEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Applies active filter criteria to the current tab.
class ApplyFilter extends AppointmentsEvent {
  final AppointmentFilter filter;

  const ApplyFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Clears all applied filters for the active tab.
class ClearFilters extends AppointmentsEvent {
  const ClearFilters();
}

/// Requests the next page of appointments for pagination.
class LoadMoreAppointments extends AppointmentsEvent {
  const LoadMoreAppointments();
}

/// Dispatched when patient confirms cancellation of a scheduled appointment.
class CancelAppointmentRequested extends AppointmentsEvent {
  final String appointmentId;
  final String? reason;

  const CancelAppointmentRequested(this.appointmentId, {this.reason});

  @override
  List<Object?> get props => [appointmentId, reason];
}

/// Dispatched when patient selects a new date and time for an appointment.
class RescheduleAppointmentRequested extends AppointmentsEvent {
  final String appointmentId;
  final DateTime newDateTime;

  const RescheduleAppointmentRequested(this.appointmentId, this.newDateTime);

  @override
  List<Object?> get props => [appointmentId, newDateTime];
}

/// Fetches quick action counters for prescriptions, labs, and radiology.
class RefreshQuickActions extends AppointmentsEvent {
  const RefreshQuickActions();
}

/// Fetches recommended doctors for the patient.
class RefreshRecommendations extends AppointmentsEvent {
  const RefreshRecommendations();
}

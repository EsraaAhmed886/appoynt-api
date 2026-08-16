/*
 * File Name: notifications_cubit.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V2.0.0
 * Dependencies: dart:async, package:flutter_bloc/flutter_bloc.dart,
 *   token_storage.dart, app_notification.dart,
 *   notifications_repository.dart, notifications_state.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Business logic controller for the Notifications feature managing
 *   auth verification, paginated fetching, category filtering, infinite scrolling,
 *   mark as read, and mark all as read.
 */

// Import asynchronous support for unawaited background calls
import 'dart:async';
// Import Flutter BLoC library
import 'package:flutter_bloc/flutter_bloc.dart';
// Import TokenStorage to verify authentication session
import 'package:appoynt_mobile_app/core/storage/token_storage.dart';
// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';
// Import domain repository contract
import 'package:appoynt_mobile_app/features/notifications/domain/repositories/notifications_repository.dart';
// Import state and enums
import 'package:appoynt_mobile_app/features/notifications/presentation/cubit/notifications_state.dart';

// Controller class orchestrating state transitions for Notifications screen
class NotificationsCubit extends Cubit<NotificationsState> {
  // Notifications repository dependency injected via constructor
  final NotificationsRepository repository;
  // Page size constant for pagination batches
  static const int _page_size = 10;

  // Constructor mapping repository and triggering authentication verification
  NotificationsCubit({
    required this.repository,
  }) : super(NotificationsState.initial()) {
    check_auth_and_load();
  }

  // Verifies user session and initiates notifications load or marks as unauthenticated
  Future<void> check_auth_and_load() async {
    final String? token = await TokenStorage.get_access_token();
    if (null == token || token.isEmpty) {
      if (!isClosed) {
        emit(state.copyWith(
          is_authenticated: false,
          status: NotificationsStatus.failure,
        ));
      } else {
        // Discard emit if cubit closed
      }
    } else {
      if (!isClosed) {
        emit(state.copyWith(is_authenticated: true));
        load_notifications();
      } else {
        // Discard emit if cubit closed
      }
    }
  }

  // Updates active category filter chip selection without re-fetching network data
  void set_filter(NotificationFilter filter) {
    if (filter == state.selected_filter) {
      return;
    } else {
      emit(state.copyWith(selected_filter: filter));
    }
  }

  // Loads initial or refreshed batch of notifications
  Future<void> load_notifications({bool is_refresh = false}) async {
    if (false == is_refresh) {
      emit(state.copyWith(status: NotificationsStatus.loading));
    } else {
      // Keep displaying current list during pull-to-refresh without blank screen
    }

    try {
      final List<AppNotification> items = await repository.get_notifications(
        page: 1,
        page_size: _page_size,
      );

      final int unread = items.where((item) => false == item.is_read).length;
      final bool has_more = items.length >= _page_size;

      if (!isClosed) {
        emit(state.copyWith(
          status: NotificationsStatus.success,
          notifications: items,
          unread_count: unread,
          current_page: 1,
          has_more_data: has_more,
          is_loading_more: false,
          error_message: null,
        ));
      } else {
        // Discard emit if cubit closed
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: NotificationsStatus.failure,
          error_message: e.toString(),
        ));
      } else {
        // Discard emit if cubit closed
      }
    }
  }

  // Loads next paginated batch of notifications on infinite scroll
  Future<void> load_next_page() async {
    if (true == state.is_loading_more ||
        false == state.has_more_data ||
        NotificationsStatus.success != state.status) {
      return;
    } else {
      emit(state.copyWith(is_loading_more: true));

      final int next_page = state.current_page + 1;
      try {
        final List<AppNotification> next_items = await repository.get_notifications(
          page: next_page,
          page_size: _page_size,
        );

        final List<AppNotification> merged_items = List<AppNotification>.from(
          state.notifications,
        )..addAll(next_items);

        final int unread = merged_items.where((item) => false == item.is_read).length;
        final bool has_more = next_items.length >= _page_size;

        if (!isClosed) {
          emit(state.copyWith(
            notifications: merged_items,
            unread_count: unread,
            current_page: next_page,
            has_more_data: has_more,
            is_loading_more: false,
          ));
        } else {
          // Discard emit if cubit closed
        }
      } catch (e) {
        if (!isClosed) {
          emit(state.copyWith(is_loading_more: false));
        } else {
          // Discard emit if cubit closed
        }
      }
    }
  }

  // Marks a specific notification as read non-blockingly and updates unread badge
  void mark_notification_as_read(String notification_id) {
    final int target_index = state.notifications.indexWhere(
      (item) => item.id == notification_id,
    );

    if (-1 == target_index) {
      return;
    } else {
      final AppNotification target = state.notifications[target_index];
      if (true == target.is_read) {
        return;
      } else {
        final List<AppNotification> updated_list = List<AppNotification>.from(
          state.notifications,
        );
        updated_list[target_index] = target.copyWith(is_read: true);

        final int new_unread = state.unread_count > 0
            ? state.unread_count - 1
            : 0;

        emit(state.copyWith(
          notifications: updated_list,
          unread_count: new_unread,
        ));

        // Fire-and-forget remote update asynchronously without blocking the UI thread
        unawaited(repository.mark_as_read(notification_id).catchError((_) {}));
      }
    }
  }

  // Marks all notifications in list as read non-blockingly and resets unread counter to 0
  void mark_all_as_read() {
    if (0 == state.unread_count) {
      return;
    } else {
      final List<AppNotification> updated_list = state.notifications.map((item) {
        return item.copyWith(is_read: true);
      }).toList();

      emit(state.copyWith(
        notifications: updated_list,
        unread_count: 0,
      ));

      // Fire-and-forget remote update asynchronously without blocking the UI thread
      unawaited(repository.mark_all_as_read().catchError((_) {}));
    }
  }
}

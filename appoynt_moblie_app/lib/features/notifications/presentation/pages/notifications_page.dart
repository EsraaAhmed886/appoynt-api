/*
 * File Name: notifications_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 15/08/2026
 * Version Information: V2.0.0
 * Dependencies: package:flutter/material.dart, package:flutter_bloc/flutter_bloc.dart,
 *   app_spacing.dart, app_colors.dart, app_localizations.dart,
 *   service_locator.dart, notifications_cubit.dart, notifications_state.dart,
 *   notification_item_card.dart, empty_notifications_widget.dart,
 *   notifications_shimmer_widget.dart, notifications_error_widget.dart,
 *   notification_filter_chips.dart, notification_details_page.dart,
 *   app_notification.dart, routes.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Notifications screen featuring centered geometric header,
 *   dynamic filter chips, chronological grouping, pull-to-refresh, infinite scroll,
 *   and navigation to the dedicated Notification Details screen.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import BLoC state management library
import 'package:flutter_bloc/flutter_bloc.dart';
// Import layout design tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
import 'package:appoynt_mobile_app/core/utils/custom_snackbar.dart';
// Import localization dictionary
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';
// Import service locator to resolve NotificationsCubit
import 'package:appoynt_mobile_app/core/di/service_locator.dart';
// Import cubit and state
import 'package:appoynt_mobile_app/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:appoynt_mobile_app/features/notifications/presentation/cubit/notifications_state.dart';
// Import domain entity
import 'package:appoynt_mobile_app/features/notifications/domain/entities/app_notification.dart';
// Import presentation widgets
import 'package:appoynt_mobile_app/features/notifications/presentation/widgets/notification_item_card.dart';
import 'package:appoynt_mobile_app/features/notifications/presentation/widgets/notification_filter_chips.dart';
import 'package:appoynt_mobile_app/features/notifications/presentation/widgets/empty_notifications_widget.dart';
import 'package:appoynt_mobile_app/features/notifications/presentation/widgets/notifications_shimmer_widget.dart';
import 'package:appoynt_mobile_app/features/notifications/presentation/widgets/notifications_error_widget.dart';
// Import Notification Details screen
import 'package:appoynt_mobile_app/features/notifications/presentation/pages/notification_details_page.dart';
// Import routes constants
import 'package:appoynt_mobile_app/core/routing/routes.dart';

// Local layout dimension constants strictly eliminating raw numbers
class _LocalDimensions {
  static const double header_height = 44.0;
  static const double back_button_size = 40.0;
  static const double back_button_radius = 12.0;
  static const double back_icon_size = 20.0;
  static const double scroll_trigger_threshold = 0.80;
  static const double pagination_loader_size = 24.0;
  static const double pagination_loader_stroke = 2.5;
  static const double section_spacing_top = 16.0;
  static const double section_spacing_bottom = 8.0;
}

// Notifications screen widget wrapped in BlocProvider
class NotificationsPage extends StatelessWidget {
  // Constant constructor
  const NotificationsPage({super.key});

  @override
  // Build method injecting NotificationsCubit
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (context) {
        return get_it<NotificationsCubit>();
      },
      child: const _NotificationsView(),
    );
  }
}

// Concrete stateful view managing scroll listener and layout
class _NotificationsView extends StatefulWidget {
  // Constant constructor
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() {
    return _NotificationsViewState();
  }
}

class _NotificationsViewState extends State<_NotificationsView> {
  // ScrollController for infinite pagination tracking
  late final ScrollController _scroll_controller;

  @override
  void initState() {
    super.initState();
    _scroll_controller = ScrollController();
    _scroll_controller.addListener(_on_scroll);
  }

  @override
  void dispose() {
    _scroll_controller.removeListener(_on_scroll);
    _scroll_controller.dispose();
    super.dispose();
  }

  // Detects 80% scroll depth to trigger next pagination batch
  void _on_scroll() {
    if (false == _scroll_controller.hasClients) {
      return;
    } else {
      final double max_scroll = _scroll_controller.position.maxScrollExtent;
      final double current_scroll = _scroll_controller.position.pixels;
      if (max_scroll > 0 &&
          current_scroll >=
              (max_scroll * _LocalDimensions.scroll_trigger_threshold)) {
        context.read<NotificationsCubit>().load_next_page();
      } else {
        // Not yet reached pagination boundary
      }
    }
  }

  // Navigates cleanly to NotificationDetailsPage passing notification model safely
  void _open_notification_details(
    BuildContext context,
    AppNotification notification,
  ) {
    // Mark as read asynchronously in cubit without freezing main UI thread
    context.read<NotificationsCubit>().mark_notification_as_read(notification.id);

    // Navigate cleanly to the dedicated Notification Details screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotificationDetailsPage(
          notification: notification,
        ),
      ),
    );
  }

  // Splits notifications list into chronological sections (Today, Yesterday, Earlier)
  _GroupedNotifications _group_notifications(List<AppNotification> list) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final List<AppNotification> today_items = <AppNotification>[];
    final List<AppNotification> yesterday_items = <AppNotification>[];
    final List<AppNotification> earlier_items = <AppNotification>[];

    // Sort list by created_at descending with fallback by ID
    final List<AppNotification> sorted_list = List<AppNotification>.from(list)
      ..sort((a, b) {
        final int comparison = b.created_at.compareTo(a.created_at);
        if (0 != comparison) {
          return comparison;
        } else {
          return b.id.compareTo(a.id);
        }
      });

    for (final AppNotification item in sorted_list) {
      final DateTime item_date = DateTime(
        item.created_at.year,
        item.created_at.month,
        item.created_at.day,
      );
      final int diff_days = today.difference(item_date).inDays;

      if (0 == diff_days) {
        today_items.add(item);
      } else if (1 == diff_days) {
        yesterday_items.add(item);
      } else {
        earlier_items.add(item);
      }
    }

    return _GroupedNotifications(
      today: today_items,
      yesterday: yesterday_items,
      earlier: earlier_items,
    );
  }

  @override
  // Build method drawing the complete Notifications screen
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        // FLT-01 & BR-01: Redirect unauthenticated patients to Login screen
        if (false == state.is_authenticated) {
          Navigator.of(context).pushReplacementNamed(Routes.login);
        } else {
          // Patient session authenticated
        }
      },
      builder: (context, state) {
        final bool has_unread = state.unread_count > 0;

        return Scaffold(
          backgroundColor: is_dark
              ? AppColors.background_dark
              : AppColors.scaffold_light,
          body: SafeArea(
            child: Column(
              children: [
                // ── 1. Geometrically Centered Top Header ───────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space_xl,
                    vertical: AppSpacing.space_m,
                  ),
                  child: SizedBox(
                    height: _LocalDimensions.header_height,
                    child: Stack(
                      children: [
                        // Centered Header Title (Guaranteed Geometric Center)
                        Center(
                          child: Text(
                            localizations.notifications_page_title,
                            style: TextStyle(
                              fontSize: AppSpacing.font_size_dialog_title,
                              fontWeight: FontWeight.bold,
                              color: is_dark
                                  ? AppColors.text_dark_primary
                                  : AppColors.text_light_primary,
                            ),
                          ),
                        ),

                        // Back Button Aligned to Leading Left
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: _LocalDimensions.back_button_size,
                            height: _LocalDimensions.back_button_size,
                            decoration: BoxDecoration(
                              color: is_dark
                                  ? AppColors.surface_dark
                                  : AppColors.background_light,
                              borderRadius: BorderRadius.circular(
                                _LocalDimensions.back_button_radius,
                              ),
                              border: Border.all(
                                color: is_dark
                                    ? AppColors.border_dark
                                    : AppColors.border_light,
                                width: 1.0,
                              ),
                            ),
                            child: Material(
                              color: AppColors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  _LocalDimensions.back_button_radius,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: _LocalDimensions.back_icon_size,
                                    color: is_dark
                                        ? AppColors.text_dark_primary
                                        : AppColors.text_light_primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // "Mark all as read" Action Aligned to Trailing Right
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: has_unread
                                ? () {
                                    context
                                        .read<NotificationsCubit>()
                                        .mark_all_as_read();
                                    CustomSnackBar.success(
                                      context,
                                      localizations
                                          .notifications_marked_all_read_success,
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                : null,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.space_s,
                              ),
                              foregroundColor: has_unread
                                  ? AppColors.primary_color
                                  : (is_dark
                                      ? AppColors.text_dark_secondary
                                      : AppColors.text_light_secondary),
                            ),
                            child: Text(
                              localizations.notifications_mark_all_read,
                              style: TextStyle(
                                fontSize: AppSpacing.font_size_body_small,
                                fontWeight: has_unread
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: has_unread
                                    ? AppColors.primary_color
                                    : (is_dark
                                        ? AppColors.text_dark_secondary
                                            .withValues(alpha: 0.5)
                                        : AppColors.text_light_secondary
                                            .withValues(alpha: 0.5)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 2. Smart Horizontal Category Filter Chips Bar ──────────
                NotificationFilterChips(
                  selected_filter: state.selected_filter,
                  unread_count: state.unread_count,
                  on_select_filter: (filter) {
                    context.read<NotificationsCubit>().set_filter(filter);
                  },
                ),
                const SizedBox(height: AppSpacing.space_m),

                // ── 3. Screen Body Content ─────────────────────────────────
                Expanded(
                  child: _build_body_content(
                    context,
                    state,
                    localizations,
                    is_dark,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Selects and builds body based on loading, error, empty, or list states
  Widget _build_body_content(
    BuildContext context,
    NotificationsState state,
    AppLocalizations localizations,
    bool is_dark,
  ) {
    // 1. Initial Loading Shimmer
    if (NotificationsStatus.loading == state.status &&
        state.notifications.isEmpty) {
      return const NotificationsShimmerWidget();
    } else if (NotificationsStatus.failure == state.status &&
        state.notifications.isEmpty) {
      // 2. Error Fallback State
      return NotificationsErrorWidget(
        on_retry: () {
          context.read<NotificationsCubit>().load_notifications();
        },
      );
    } else if (state.notifications.isEmpty) {
      // 3. Empty State (No notifications at all)
      return EmptyNotificationsWidget(
        on_go_home: () {
          Navigator.of(context).pop();
        },
      );
    } else if (state.filtered_notifications.isEmpty) {
      // 4. Empty State for active filter chip
      return EmptyNotificationsWidget(
        on_go_home: () {
          context.read<NotificationsCubit>().set_filter(NotificationFilter.all);
        },
      );
    } else {
      // 5. Grouped Filtered Notifications List with Pull-to-Refresh & Infinite Scroll
      final _GroupedNotifications grouped =
          _group_notifications(state.filtered_notifications);

      return RefreshIndicator(
        color: AppColors.primary_color,
        onRefresh: () async {
          await context
              .read<NotificationsCubit>()
              .load_notifications(is_refresh: true);
        },
        child: ListView(
          controller: _scroll_controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space_xl,
            vertical: AppSpacing.space_m,
          ),
          children: [
            // Today Group
            if (grouped.today.isNotEmpty) ...[
              _build_section_header(
                localizations.notifications_section_today,
                is_dark,
              ),
              ...grouped.today.map((item) {
                return NotificationItemCard(
                  notification: item,
                  on_tap: () {
                    _open_notification_details(context, item);
                  },
                );
              }),
            ],

            // Yesterday Group
            if (grouped.yesterday.isNotEmpty) ...[
              _build_section_header(
                localizations.notifications_section_yesterday,
                is_dark,
              ),
              ...grouped.yesterday.map((item) {
                return NotificationItemCard(
                  notification: item,
                  on_tap: () {
                    _open_notification_details(context, item);
                  },
                );
              }),
            ],

            // Earlier Group
            if (grouped.earlier.isNotEmpty) ...[
              _build_section_header(
                localizations.notifications_section_earlier,
                is_dark,
              ),
              ...grouped.earlier.map((item) {
                return NotificationItemCard(
                  notification: item,
                  on_tap: () {
                    _open_notification_details(context, item);
                  },
                );
              }),
            ],

            // Pagination Bottom Loading Spinner
            if (true == state.is_loading_more)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.space_l),
                child: Center(
                  child: SizedBox(
                    width: _LocalDimensions.pagination_loader_size,
                    height: _LocalDimensions.pagination_loader_size,
                    child: CircularProgressIndicator(
                      strokeWidth: _LocalDimensions.pagination_loader_stroke,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary_color),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: AppSpacing.space_m),
          ],
        ),
      );
    }
  }

  // Section title header component (Today / Yesterday / Earlier)
  Widget _build_section_header(String title, bool is_dark) {
    return Padding(
      padding: const EdgeInsets.only(
        top: _LocalDimensions.section_spacing_top,
        bottom: _LocalDimensions.section_spacing_bottom,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppSpacing.font_size_body_medium,
          fontWeight: FontWeight.bold,
          color: is_dark
              ? AppColors.text_dark_primary
              : AppColors.text_light_primary,
        ),
      ),
    );
  }
}

// Data holder class grouping sorted notifications into chronological bins
class _GroupedNotifications {
  final List<AppNotification> today;
  final List<AppNotification> yesterday;
  final List<AppNotification> earlier;

  const _GroupedNotifications({
    required this.today,
    required this.yesterday,
    required this.earlier,
  });
}

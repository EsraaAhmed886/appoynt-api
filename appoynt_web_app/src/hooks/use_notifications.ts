/*
 * File Name: use_notifications.ts
 * Author: Shimaa Salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/types/notification
 *   - @/data/mockNotifications
 *   - @/lib/validators
 * Contributors: [Shimaa Salah]
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Custom React hook managing state, search debouncing, category filtering, pagination, and undo actions for user notifications.
 */

import { useState, useMemo, useEffect, useCallback, useRef } from "react";
import type { NotificationItem, NotificationCategory } from "@/types/notification";
import { mockNotifications } from "@/data/mockNotifications";
import { sanitizeSearchQuery } from "@/lib/validators";

const DEFAULT_PAGE_SIZE = 10;
const MOCK_LOADING_DELAY_MS = 600;
const DEBOUNCE_DELAY_MS = 250;
const UNDO_TOAST_TIMEOUT_MS = 5000;

export function useNotifications(page_size: number = DEFAULT_PAGE_SIZE) {
  const [notifications_list, set_notifications_list] = useState<NotificationItem[]>([]);
  const [active_category_tab, set_active_category_tab] = useState<NotificationCategory>("all");
  const [raw_search_query, set_raw_search_query] = useState<string>("");
  const [debounced_search_query, set_debounced_search_query] = useState<string>("");
  const [active_detail_notification, set_active_detail_notification] = useState<NotificationItem | null>(null);

  const [is_delete_dialog_open, set_is_delete_dialog_open] = useState<boolean>(false);
  const [is_data_loading, set_is_data_loading] = useState<boolean>(true);
  const [has_loading_error] = useState<boolean>(false);
  const [is_processing_action, set_is_processing_action] = useState<boolean>(false);
  const [current_page_number, set_current_page_number] = useState<number>(1);

  // Undo state management
  const [last_deleted_item, set_last_deleted_item] = useState<{
    item: NotificationItem;
    originalIndex: number;
  } | null>(null);
  const undo_timeout_ref = useRef<NodeJS.Timeout | null>(null);

  // Initial data loading simulation
  useEffect(() => {
    let is_mounted = true;
    const timer = setTimeout(() => {
      if (is_mounted) {
        set_notifications_list(mockNotifications);
        set_is_data_loading(false);
      } else {
        // Unmounted ignore
      }
    }, MOCK_LOADING_DELAY_MS);

    return () => {
      is_mounted = false;
      clearTimeout(timer);
    };
  }, []);

  // 1. Search Input Debouncing & Sanitization
  useEffect(() => {
    const handler = setTimeout(() => {
      const sanitized = sanitizeSearchQuery(raw_search_query);
      set_debounced_search_query(sanitized);
    }, DEBOUNCE_DELAY_MS);

    return () => {
      clearTimeout(handler);
    };
  }, [raw_search_query]);

  // Single memoized pass for category counts (DRY)
  const tab_counters_map = useMemo(() => {
    const counts = {
      all: notifications_list.length,
      unread: 0,
      appointments: 0,
      reviews: 0,
    };

    notifications_list.forEach((item) => {
      if (!item.isRead) {
        counts.unread += 1;
      } else {
        // Already read
      }

      if (
        "appointment" === item.type ||
        "cancellation" === item.type ||
        "reschedule" === item.type
      ) {
        counts.appointments += 1;
      } else {
        // Non-appointment type
      }

      if ("review" === item.type) {
        counts.reviews += 1;
      } else {
        // Non-review type
      }
    });

    return counts;
  }, [notifications_list]);

  // Category & Debounced Search Text filtering
  const filtered_notifications_list = useMemo(() => {
    const query = debounced_search_query.trim().toLowerCase();

    return notifications_list.filter((item) => {
      let category_match = true;
      if ("unread" === active_category_tab) {
        category_match = !item.isRead;
      } else if ("appointments" === active_category_tab) {
        category_match =
          "appointment" === item.type ||
          "cancellation" === item.type ||
          "reschedule" === item.type;
      } else if ("reviews" === active_category_tab) {
        category_match = "review" === item.type;
      } else {
        category_match = true;
      }

      if (!category_match) {
        return false;
      } else if (!query) {
        return true;
      } else {
        const title = item.title ? item.title.toLowerCase() : "";
        const desc = item.description ? item.description.toLowerCase() : "";
        return title.includes(query) || desc.includes(query);
      }
    });
  }, [notifications_list, active_category_tab, debounced_search_query]);

  const total_pages_count = useMemo(() => {
    return Math.ceil(filtered_notifications_list.length / page_size) || 1;
  }, [filtered_notifications_list, page_size]);

  // Pagination Boundary Validation
  useEffect(() => {
    if (current_page_number > total_pages_count && total_pages_count > 0) {
      set_current_page_number(total_pages_count);
    } else {
      // Within bounds
    }
  }, [current_page_number, total_pages_count]);

  // Paginated output
  const paginated_notifications_list = useMemo(() => {
    const valid_page = Math.min(Math.max(1, current_page_number), total_pages_count);
    const start_index = (valid_page - 1) * page_size;
    return filtered_notifications_list.slice(start_index, start_index + page_size);
  }, [filtered_notifications_list, current_page_number, total_pages_count, page_size]);

  // Action Handlers
  const handle_mark_as_read = useCallback((notification_id: string) => {
    set_notifications_list((prev) =>
      prev.map((item) => (item.id === notification_id ? { ...item, isRead: true } : item))
    );
  }, []);

  const handle_mark_all_as_read = useCallback(async () => {
    if (is_processing_action) {
      return;
    } else {
      set_is_processing_action(true);
      try {
        set_notifications_list((prev) => prev.map((item) => ({ ...item, isRead: true })));
      } finally {
        set_is_processing_action(false);
      }
    }
  }, [is_processing_action]);

  // Single Item Delete with Undo Toast capability
  const handle_delete_notification = useCallback((notification_id: string) => {
    set_notifications_list((prev) => {
      const index = prev.findIndex((item) => item.id === notification_id);
      if (-1 !== index) {
        const item_to_delete = prev[index];
        set_last_deleted_item({ item: item_to_delete, originalIndex: index });

        if (null !== undo_timeout_ref.current) {
          clearTimeout(undo_timeout_ref.current);
        } else {
          // No timer
        }

        undo_timeout_ref.current = setTimeout(() => {
          set_last_deleted_item(null);
        }, UNDO_TOAST_TIMEOUT_MS);
      } else {
        // Item not found
      }
      return prev.filter((item) => item.id !== notification_id);
    });

    set_active_detail_notification((prev) => (prev?.id === notification_id ? null : prev));
  }, []);

  // Restore deleted item from Undo Stack
  const handle_undo_delete = useCallback(() => {
    if (!last_deleted_item) {
      return;
    } else {
      const { item, originalIndex } = last_deleted_item;

      set_notifications_list((prev) => {
        const new_list = [...prev];
        new_list.splice(originalIndex, 0, item);
        return new_list;
      });

      set_last_deleted_item(null);
      if (null !== undo_timeout_ref.current) {
        clearTimeout(undo_timeout_ref.current);
      } else {
        // No timer
      }
    }
  }, [last_deleted_item]);

  const handle_confirm_delete_all = useCallback(async () => {
    if (is_processing_action) {
      return;
    } else {
      set_is_processing_action(true);
      try {
        set_notifications_list([]);
        set_is_delete_dialog_open(false);
        set_active_detail_notification(null);
        set_last_deleted_item(null);
      } finally {
        set_is_processing_action(false);
      }
    }
  }, [is_processing_action]);

  const handle_select_notification_card = useCallback(
    (item: NotificationItem) => {
      set_active_detail_notification(item);
      if (!item.isRead) {
        handle_mark_as_read(item.id);
      } else {
        // Already read
      }
    },
    [handle_mark_as_read]
  );

  const handle_category_change = useCallback((category: NotificationCategory) => {
    set_active_category_tab(category);
    set_current_page_number(1);
  }, []);

  const handle_search_change = useCallback((text: string) => {
    set_raw_search_query(text);
    set_current_page_number(1);
  }, []);

  const handle_clear_search = useCallback(() => {
    set_raw_search_query("");
    set_debounced_search_query("");
    set_current_page_number(1);
  }, []);

  return {
    notificationsList: notifications_list,
    notifications_list,
    filteredNotificationsList: filtered_notifications_list,
    filtered_notifications_list,
    paginatedNotificationsList: paginated_notifications_list,
    paginated_notifications_list,
    tabCountersMap: tab_counters_map,
    tab_counters_map,
    totalUnreadCount: tab_counters_map.unread,
    total_unread_count: tab_counters_map.unread,
    activeCategoryTab: active_category_tab,
    active_category_tab,
    searchTextQuery: raw_search_query,
    search_text_query: raw_search_query,
    debouncedSearchQuery: debounced_search_query,
    debounced_search_query,
    activeDetailNotification: active_detail_notification,
    active_detail_notification,
    isDeleteDialogOpen: is_delete_dialog_open,
    is_delete_dialog_open,
    isDataLoading: is_data_loading,
    is_data_loading,
    hasLoadingError: has_loading_error,
    has_loading_error,
    isProcessingAction: is_processing_action,
    is_processing_action,
    currentPageNumber: current_page_number,
    current_page_number,
    totalPagesCount: total_pages_count,
    total_pages_count,
    lastDeletedItem: last_deleted_item,
    last_deleted_item,
    hasSearchFilterActive: debounced_search_query.trim().length > 0,
    has_search_filter_active: debounced_search_query.trim().length > 0,
    // Methods
    handleMarkAsRead: handle_mark_as_read,
    handle_mark_as_read,
    handleMarkAllAsRead: handle_mark_all_as_read,
    handle_mark_all_as_read,
    handleDeleteNotification: handle_delete_notification,
    handle_delete_notification,
    handleUndoDelete: handle_undo_delete,
    handle_undo_delete,
    handleConfirmDeleteAll: handle_confirm_delete_all,
    handle_confirm_delete_all,
    handleSelectNotificationCard: handle_select_notification_card,
    handle_select_notification_card,
    handleCategoryChange: handle_category_change,
    handle_category_change,
    handleSearchChange: handle_search_change,
    handle_search_change,
    handleClearSearch: handle_clear_search,
    handle_clear_search,
    setCurrentPageNumber: set_current_page_number,
    set_current_page_number,
    setIsDeleteDialogOpen: set_is_delete_dialog_open,
    set_is_delete_dialog_open,
    setActiveDetailNotification: set_active_detail_notification,
    set_active_detail_notification,
    dismissUndoToast: () => set_last_deleted_item(null),
    dismiss_undo_toast: () => set_last_deleted_item(null),
  };
}

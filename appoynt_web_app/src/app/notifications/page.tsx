/*
 * File Name: page.tsx
 * Author: Shimaa Salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 *   - @/components/common/*
 *   - @/components/notifications/*
 *   - @/hooks/use_notifications
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Notifications Management page component for viewing, filtering, searching, marking as read, and deleting notifications.
 */

"use client";

import { CheckCheck, Trash2, SearchX } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import EmptyState from "@/components/common/empty_state";
import ErrorState from "@/components/common/error_state";
import LoadingState from "@/components/common/loading_state";
import Pagination from "@/components/common/pagination";
import { useNotifications } from "@/hooks/use_notifications";
import NotificationCategoryTabs from "@/components/notifications/notification_category_tabs";
import NotificationSearchBar from "@/components/notifications/notification_search_bar";
import NotificationItemCard from "@/components/notifications/notification_item_card";
import NotificationDetailsDrawer from "@/components/notifications/notification_details_drawer";
import NotificationDeleteModal from "@/components/notifications/notification_delete_modal";
import NotificationToast from "@/components/notifications/notification_toast";

export default function NotificationsPage() {
  const { current_locale, t } = useTranslation();
  const is_right_to_left = "ar" === current_locale;

  const {
    notifications_list,
    filtered_notifications_list,
    paginated_notifications_list,
    tab_counters_map,
    total_unread_count,
    active_category_tab,
    search_text_query,
    active_detail_notification,
    is_delete_dialog_open,
    is_data_loading,
    has_loading_error,
    is_processing_action,
    current_page_number,
    total_pages_count,
    last_deleted_item,
    has_search_filter_active,
    handle_mark_all_as_read,
    handle_delete_notification,
    handle_undo_delete,
    handle_confirm_delete_all,
    handle_select_notification_card,
    handle_category_change,
    handle_search_change,
    handle_clear_search,
    set_current_page_number,
    set_is_delete_dialog_open,
    set_active_detail_notification,
    dismiss_undo_toast,
  } = useNotifications();

  if (has_loading_error) {
    return (
      <div className="p-8">
        <ErrorState />
      </div>
    );
  } else {
    return (
      <div
        className={`space-y-4 w-full ${is_right_to_left ? "font-cairo" : "font-sans"}`}
      >
        {/* Top Header Actions & Filtering */}
        <div className="flex flex-col gap-3">
          {/* Bulk Action Buttons */}
          <div className="flex items-center justify-end gap-2.5">
            <button
              type="button"
              disabled={0 === total_unread_count || is_processing_action}
              onClick={handle_mark_all_as_read}
              className="flex items-center gap-2 px-3.5 py-2 rounded-xl text-xs md:text-sm font-semibold border border-app-border bg-app-surface text-blue-500 hover:bg-app-border/40 transition-all shadow-sm disabled:opacity-40 disabled:pointer-events-none"
            >
              <CheckCheck className="w-4 h-4" />
              <span>{t("notif_mark_all_read")}</span>
            </button>

            <button
              type="button"
              disabled={0 === notifications_list.length || is_processing_action}
              onClick={() => set_is_delete_dialog_open(true)}
              className="flex items-center gap-2 px-3.5 py-2 rounded-xl text-xs md:text-sm font-semibold border border-red-500/20 bg-app-surface text-red-400 hover:bg-red-500/10 transition-all shadow-sm disabled:opacity-40 disabled:pointer-events-none"
            >
              <Trash2 className="w-4 h-4" />
              <span>{t("notif_delete_all")}</span>
            </button>
          </div>

          {/* Category Tabs & Search Input */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-3">
            <NotificationCategoryTabs
              activeTab={active_category_tab}
              countersMap={tab_counters_map}
              onTabChange={handle_category_change}
            />

            <NotificationSearchBar
              value={search_text_query}
              onChange={handle_search_change}
              onClear={handle_clear_search}
            />
          </div>
        </div>

        {/* Main Notifications Content Container */}
        <div className="bg-app-background border border-app-border rounded-2xl p-3 md:p-5 shadow-sm">
          {is_data_loading ? (
            <div className="py-16 flex justify-center items-center">
              <LoadingState variant="list" rows={5} />
            </div>
          ) : (
            <div className="flex flex-col lg:flex-row gap-5 relative items-start">
              {/* Details Panel / Sheet Drawer */}
              <NotificationDetailsDrawer
                notification={active_detail_notification}
                onClose={() => set_active_detail_notification(null)}
              />

              {/* Main Notifications List */}
              <div className="flex-1 w-full space-y-2.5 lg:order-1">
                {0 === paginated_notifications_list.length ? (
                  <div className="flex flex-col items-center justify-center p-8 text-center space-y-3">
                    {has_search_filter_active ? (
                      <>
                        <div className="w-12 h-12 rounded-full bg-app-surface border border-app-border flex items-center justify-center text-app-text-secondary">
                          <SearchX className="w-6 h-6" />
                        </div>
                        <h3 className="text-xs md:text-sm font-bold text-app-text-primary">
                          {t("notif_no_search_match")}
                        </h3>
                        <button
                          type="button"
                          onClick={handle_clear_search}
                          className="px-3.5 py-1.5 rounded-xl text-xs font-semibold bg-app-primary text-white hover:opacity-90 transition-opacity"
                        >
                          {t("notif_clear_search")}
                        </button>
                      </>
                    ) : (
                      <>
                        <EmptyState />
                        <h3 className="text-xs md:text-sm font-bold text-app-text-primary mt-2">
                          {t("notif_no_found")}
                        </h3>
                      </>
                    )}
                  </div>
                ) : (
                  paginated_notifications_list.map((item) => (
                    <NotificationItemCard
                      key={item.id}
                      item={item}
                      isSelected={active_detail_notification?.id === item.id}
                      onSelect={handle_select_notification_card}
                      onDelete={handle_delete_notification}
                    />
                  ))
                )}

                {/* Pagination Controls */}
                {filtered_notifications_list.length > 0 ? (
                  <div className="pt-4 flex justify-center">
                    <Pagination
                      current_page={current_page_number}
                      total_pages={total_pages_count}
                      on_page_change={set_current_page_number}
                    />
                  </div>
                ) : null}
              </div>
            </div>
          )}
        </div>

        {/* Delete Confirmation Modal */}
        <NotificationDeleteModal
          isOpen={is_delete_dialog_open}
          onClose={() => set_is_delete_dialog_open(false)}
          onConfirm={handle_confirm_delete_all}
        />

        {/* Undo Toast Notification */}
        <NotificationToast
          deletedItem={last_deleted_item?.item || null}
          onUndo={handle_undo_delete}
          onDismiss={dismiss_undo_toast}
        />
      </div>
    );
  }
}

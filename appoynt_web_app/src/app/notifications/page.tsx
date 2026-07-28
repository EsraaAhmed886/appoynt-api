/**
 * File Name : page.tsx
 * Author : Shimaa Salah
 * Created Date : 2026-07-28
 * Version : v1.0.0
 * Dependencies :
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 *   - @/components/common/empty_state
 *   - @/components/common/error_state
 *   - @/components/common/loading_state
 *   - @/components/common/pagination
 *   - @/components/notifications/notification_badge
 *   - @/components/notifications/notification_category_tabs
 *   - @/components/notifications/notification_delete_modal
 *   - @/components/notifications/notification_details_drawer
 *   - @/components/notifications/notification_item_card
 *   - @/components/notifications/notification_search_bar
 *   - @/components/notifications/notification_toast
 *   - @/types/notification
 *   - @/data/mockNotifications
 * Contributors : [Shimaa Salah]
 * Last Modified : Shimaa Salah - 2026-07-28
 * Description : Notifications Management page component for viewing, filtering,
 *               searching, marking as read, and deleting user notifications with
 *               pagination, side detail drawer, and confirmation modal states.
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
  const isRightToLeft = current_locale === "ar";

  const {
    notificationsList,
    filteredNotificationsList,
    paginatedNotificationsList,
    tabCountersMap,
    totalUnreadCount,
    activeCategoryTab,
    searchTextQuery,
    activeDetailNotification,
    isDeleteDialogOpen,
    isDataLoading,
    hasLoadingError,
    isProcessingAction,
    currentPageNumber,
    totalPagesCount,
    lastDeletedItem,
    hasSearchFilterActive,
    handleMarkAllAsRead,
    handleDeleteNotification,
    handleUndoDelete,
    handleConfirmDeleteAll,
    handleSelectNotificationCard,
    handleCategoryChange,
    handleSearchChange,
    handleClearSearch,
    setCurrentPageNumber,
    setIsDeleteDialogOpen,
    setActiveDetailNotification,
    dismissUndoToast,
  } = useNotifications();

  if (hasLoadingError) {
    return (
      <div className="p-8">
        <ErrorState />
      </div>
    );
  }

  return (
    <div
      className={`space-y-4 w-full ${isRightToLeft ? "font-cairo" : "font-sans"}`}
    >
      {/* ── Top Header Actions & Filtering ───────────────────────────── */}
      <div className="flex flex-col gap-3">
        {/* Bulk Action Buttons */}
        <div className="flex items-center justify-end gap-2.5">
          <button
            type="button"
            disabled={totalUnreadCount === 0 || isProcessingAction}
            onClick={handleMarkAllAsRead}
            className="flex items-center gap-2 px-3.5 py-2 rounded-xl text-xs md:text-sm font-semibold border border-app-border bg-app-surface text-blue-500 hover:bg-app-border/40 transition-all shadow-sm disabled:opacity-40 disabled:pointer-events-none"
          >
            <CheckCheck className="w-4 h-4" />
            <span>{t("notif_mark_all_read")}</span>
          </button>

          <button
            type="button"
            disabled={notificationsList.length === 0 || isProcessingAction}
            onClick={() => setIsDeleteDialogOpen(true)}
            className="flex items-center gap-2 px-3.5 py-2 rounded-xl text-xs md:text-sm font-semibold border border-red-500/20 bg-app-surface text-red-400 hover:bg-red-500/10 transition-all shadow-sm disabled:opacity-40 disabled:pointer-events-none"
          >
            <Trash2 className="w-4 h-4" />
            <span>{t("notif_delete_all")}</span>
          </button>
        </div>

        {/* Category Tabs & Search Input */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-3">
          <NotificationCategoryTabs
            activeTab={activeCategoryTab}
            countersMap={tabCountersMap}
            onTabChange={handleCategoryChange}
          />

          <NotificationSearchBar
            value={searchTextQuery}
            onChange={handleSearchChange}
            onClear={handleClearSearch}
          />
        </div>
      </div>

      {/* ── Main Notifications Content Container ────────────────────────── */}
      <div className="bg-app-background border border-app-border rounded-2xl p-3 md:p-5 shadow-sm">
        {isDataLoading ? (
          <div className="py-16 flex justify-center items-center">
            <LoadingState variant="list" rows={5} />
          </div>
        ) : (
          <div className="flex flex-col lg:flex-row gap-5 relative items-start">
            {/* Details Panel / Sheet Drawer */}
            <NotificationDetailsDrawer
              notification={activeDetailNotification}
              onClose={() => setActiveDetailNotification(null)}
            />

            {/* Main Notifications List */}
            <div className="flex-1 w-full space-y-2.5 lg:order-1">
              {paginatedNotificationsList.length === 0 ? (
                <div className="flex flex-col items-center justify-center p-8 text-center space-y-3">
                  {hasSearchFilterActive ? (
                    <>
                      <div className="w-12 h-12 rounded-full bg-app-surface border border-app-border flex items-center justify-center text-app-text-secondary">
                        <SearchX className="w-6 h-6" />
                      </div>
                      <h3 className="text-xs md:text-sm font-bold text-app-text-primary">
                        {t("notif_no_search_match")}
                      </h3>
                      <button
                        type="button"
                        onClick={handleClearSearch}
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
                paginatedNotificationsList.map((item) => (
                  <NotificationItemCard
                    key={item.id}
                    item={item}
                    isSelected={activeDetailNotification?.id === item.id}
                    onSelect={handleSelectNotificationCard}
                    onDelete={handleDeleteNotification}
                  />
                ))
              )}

              {/* Pagination Controls */}
              {filteredNotificationsList.length > 0 && (
                <div className="pt-4 flex justify-center">
                  <Pagination
                    currentPage={currentPageNumber}
                    totalPages={totalPagesCount}
                    onPageChange={setCurrentPageNumber}
                  />
                </div>
              )}
            </div>
          </div>
        )}
      </div>

      {/* Delete Confirmation Modal */}
      <NotificationDeleteModal
        isOpen={isDeleteDialogOpen}
        onClose={() => setIsDeleteDialogOpen(false)}
        onConfirm={handleConfirmDeleteAll}
      />

      {/* Undo Toast Notification */}
      <NotificationToast
        deletedItem={lastDeletedItem?.item || null}
        onUndo={handleUndoDelete}
        onDismiss={dismissUndoToast}
      />
    </div>
  );
}

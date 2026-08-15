/*
 * File Name: notification_toast.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/notification
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Floating toast alert component for notification deletion feedback with undo action and manual dismissal.
 */
import React from "react";
import { Undo2, X } from "lucide-react";
import type { NotificationItem } from "@/types/notification";
import { useTranslation } from "@/context/language_context";

interface NotificationToastProps {
  deletedItem: NotificationItem | null;
  onUndo: () => void;
  onDismiss: () => void;
}

export default function NotificationToast({
  deletedItem,
  onUndo,
  onDismiss,
}: NotificationToastProps) {
  const { t } = useTranslation();
  if (!deletedItem) {
    return null;
  } else {
    return (
      <div
        role="status"
        aria-live="polite"
        className="fixed bottom-5 right-5 z-50 flex items-center justify-between gap-4 px-4 py-3 rounded-xl bg-app-surface border border-app-border text-app-text-primary shadow-2xl animate-in slide-in-from-bottom-5 duration-200 max-w-md"
      >
        <div className="flex items-center gap-2.5 min-w-0">
          <span className="text-xs truncate">{t("notif_deleted_toast")}</span>
        </div>

        <div className="flex items-center gap-2 flex-shrink-0">
          <button
            type="button"
            onClick={onUndo}
            className="flex items-center gap-1 px-2.5 py-1 rounded-lg bg-app-primary text-white text-xs font-bold shadow-sm hover:opacity-90 transition-opacity focus:outline-none"
          >
            <Undo2 className="w-3.5 h-3.5" />
            <span>{t("notif_undo")}</span>
          </button>

          <button
            type="button"
            onClick={onDismiss}
            aria-label="Dismiss toast"
            className="p-1 rounded-lg text-app-text-secondary hover:text-app-text-primary transition-colors focus:outline-none"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      </div>
    );
  }
}

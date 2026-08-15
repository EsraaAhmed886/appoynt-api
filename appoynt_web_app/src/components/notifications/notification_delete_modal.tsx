/*
 * File Name: notification_delete_modal.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Accessible confirmation modal for deleting notifications with keyboard event listener (Escape key) and localized action labels.
 */
import React, { useEffect } from "react";
import { useTranslation } from "@/context/language_context";

interface NotificationDeleteModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
}

export default function NotificationDeleteModal({
  isOpen,
  onClose,
  onConfirm,
}: NotificationDeleteModalProps) {
  const { t } = useTranslation();

  useEffect(() => {
    if (!isOpen) {
      return;
    }

    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        onClose();
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, onClose]);

  if (!isOpen) {
    return null;
  }

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="delete-dialog-title"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-150"
    >
      <div
        onClick={(e) => e.stopPropagation()}
        className="w-full max-w-sm rounded-2xl bg-app-background border border-app-border p-5 shadow-2xl space-y-3 animate-in zoom-in-95 duration-150"
      >
        <h3
          id="delete-dialog-title"
          className="text-base font-bold text-app-text-primary"
        >
          {t("notif_delete_modal_title")}
        </h3>
        <p className="text-xs text-app-text-secondary leading-relaxed">
          {t("notif_delete_modal_desc")}
        </p>

        <div className="flex items-center justify-end gap-2.5 pt-3">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 rounded-xl text-xs font-semibold border border-app-border text-app-text-primary hover:bg-app-surface transition-colors focus:outline-none"
          >
            {t("notif_cancel")}
          </button>
          <button
            type="button"
            onClick={onConfirm}
            className="px-4 py-2 rounded-xl text-xs font-semibold bg-red-600 text-white hover:bg-red-700 shadow-sm transition-colors focus:outline-none"
          >
            {t("notif_confirm_delete")}
          </button>
        </div>
      </div>
    </div>
  );
}

/*
 * File Name: delete_receptionist_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/receptionist
 *   - @/context/receptionist_context
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Destructive action modal confirming permanent hard deletion of a clinic receptionist account with loading states and toast notifications.
 */

"use client";

import React, { useState, useEffect } from "react";
import { Trash2, AlertTriangle, Loader2 } from "lucide-react";
import { Receptionist } from "@/types/receptionist";
import { useReceptionists } from "@/context/receptionist_context";
import { useTranslation } from "@/context/language_context";

interface DeleteReceptionistModalProps {
  receptionist: Receptionist | null;
  isOpen: boolean;
  onClose: () => void;
}

export default function DeleteReceptionistModal({
  receptionist,
  isOpen,
  onClose,
}: DeleteReceptionistModalProps) {
  const { deleteReceptionist, showToast } = useReceptionists();
  const { translations } = useTranslation();
  const [isDeleting, setIsDeleting] = useState(false);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape" && !isDeleting) {
        onClose();
      } else {
        // No action needed
      }
    };
    if (isOpen) {
      window.addEventListener("keydown", handleKeyDown);
    } else {
      // Modal closed
    }
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, isDeleting, onClose]);

  if (!isOpen || !receptionist) {
    return null;
  } else {
    // Render modal
  }

  const handleDelete = async () => {
    setIsDeleting(true);
    try {
      await deleteReceptionist(receptionist.id);
      showToast(translations.toast_deleted || "Receptionist account deleted successfully.", "success");
      onClose();
    } catch (err: any) {
      showToast(err?.message || "Failed to delete receptionist account", "error");
    } finally {
      setIsDeleting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/70 backdrop-blur-xs animate-in fade-in duration-150">
      <div className="w-full max-w-md bg-white dark:bg-[#0E1726] border-2 border-red-200 dark:border-red-900/60 rounded-2xl shadow-2xl p-6 space-y-5 animate-in zoom-in-95 duration-150 text-start">
        <div className="flex items-start gap-4">
          <div className="p-3.5 bg-red-50 dark:bg-red-950/80 text-red-600 dark:text-red-400 rounded-2xl border border-red-200 dark:border-red-800 shrink-0">
            <Trash2 className="w-6 h-6" />
          </div>
          <div>
            <h3 className="text-base font-bold text-slate-900 dark:text-white">
              {translations.delete_receptionist_title || "Delete Receptionist Account"}
            </h3>
            <p className="text-xs md:text-sm text-slate-600 dark:text-slate-400 mt-1 leading-relaxed">
              {(translations.delete_receptionist_desc || "Are you sure you want to permanently delete {name}? This action cannot be undone and will immediately revoke all clinic access.")
                .replace("{name}", `${receptionist.full_name} (@${receptionist.username})`)}
            </p>
          </div>
        </div>

        <div className="flex flex-col sm:flex-row items-center justify-end gap-2.5 pt-2">
          <button
            type="button"
            disabled={isDeleting}
            onClick={onClose}
            className="w-full sm:w-auto px-4 py-2.5 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl transition disabled:opacity-50 cursor-pointer"
          >
            {translations.cancel || "Cancel"}
          </button>

          <button
            type="button"
            disabled={isDeleting}
            onClick={handleDelete}
            className="w-full sm:w-auto px-4 py-2.5 bg-red-600 hover:bg-red-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md transition flex items-center justify-center gap-2 disabled:opacity-60 cursor-pointer"
          >
            {isDeleting ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                <span>Deleting...</span>
              </>
            ) : (
              <>
                <Trash2 className="w-4 h-4" />
                <span>{translations.delete_confirm_btn || "Delete Account"}</span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}

/*
 * File Name: confirm_deletion_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Accessible modal dialog confirming destructive or irreversible actions including medication deletion, test order cancellation, draft discarding, and record locking.
 */

"use client";

import React from "react";
import { AlertTriangle, Trash2, X, Check } from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface ConfirmDeletionModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  description: string;
  confirmLabel?: string;
  cancelLabel?: string;
  variant?: "danger" | "warning" | "primary";
  isLoading?: boolean;
}

export default function ConfirmDeletionModal({
  isOpen,
  onClose,
  onConfirm,
  title,
  description,
  confirmLabel,
  cancelLabel,
  variant = "danger",
  isLoading = false,
}: ConfirmDeletionModalProps) {
  const { translations } = useTranslation();

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-150 text-slate-900 dark:text-slate-100">
      <div
        className="w-full max-w-md bg-white dark:bg-[#0E1726] rounded-2xl shadow-2xl border-2 border-slate-200 dark:border-slate-800 p-6 space-y-5 text-start"
        role="alertdialog"
        aria-modal="true"
      >
        <div className="flex items-start gap-3.5">
          <div
            className={`p-3 rounded-2xl shrink-0 ${
              "danger" === variant
                ? "bg-red-100 dark:bg-red-950/60 text-red-600 dark:text-red-400"
                : "warning" === variant
                ? "bg-amber-100 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400"
                : "bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400"
            }`}
          >
            {"danger" === variant ? (
              <Trash2 className="w-6 h-6" />
            ) : "warning" === variant ? (
              <AlertTriangle className="w-6 h-6" />
            ) : (
              <Check className="w-6 h-6" />
            )}
          </div>

          <div className="space-y-1 overflow-hidden">
            <h3 className="text-base font-bold text-slate-900 dark:text-slate-100">
              {title}
            </h3>
            <p className="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
              {description}
            </p>
          </div>
        </div>

        <div className="flex items-center justify-end gap-2.5 pt-3 border-t-2 border-slate-200 dark:border-slate-800">
          <button
            type="button"
            disabled={isLoading}
            onClick={onClose}
            className="px-4 py-2 text-xs font-semibold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition"
          >
            {cancelLabel || translations.cancel}
          </button>
          <button
            type="button"
            disabled={isLoading}
            onClick={() => {
              onConfirm();
              onClose();
            }}
            className={`px-4 py-2 text-xs font-bold text-white rounded-xl shadow-xs transition flex items-center gap-1.5 ${
              "danger" === variant
                ? "bg-red-600 hover:bg-red-700 dark:bg-red-600 dark:hover:bg-red-500"
                : "warning" === variant
                ? "bg-amber-600 hover:bg-amber-700 dark:bg-amber-600 dark:hover:bg-amber-500"
                : "bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500"
            }`}
          >
            {confirmLabel || translations.delete}
          </button>
        </div>
      </div>
    </div>
  );
}

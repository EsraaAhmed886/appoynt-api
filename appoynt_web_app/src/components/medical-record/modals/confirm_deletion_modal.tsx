/*
 * File Name: confirm_deletion_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Accessible confirmation dialog supporting danger/primary/warning variants with high-contrast actions and circular indicator icons.
 */

"use client";

import React from "react";
import { Trash2, AlertTriangle, ShieldCheck, CheckCircle2 } from "lucide-react";
import { useTranslation } from "@/context/language_context";

export interface ConfirmDeletionModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title?: string;
  description?: string;
  confirmLabel?: string;
  cancelLabel?: string;
  isLoading?: boolean;
  variant?: "danger" | "primary" | "warning" | string;
}

export default function ConfirmDeletionModal({
  isOpen,
  onClose,
  onConfirm,
  title,
  description,
  confirmLabel,
  cancelLabel,
  isLoading = false,
  variant = "danger",
}: ConfirmDeletionModalProps) {
  const { translations } = useTranslation();

  if (!isOpen) return null;

  const isPrimary = variant === "primary";
  const isWarning = variant === "warning";

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-150 text-slate-900 dark:text-slate-100">
      <div
        className="w-full max-w-md bg-white dark:bg-[#0E1726] rounded-2xl shadow-2xl border-2 border-slate-200 dark:border-slate-800 p-6 space-y-5 text-center"
        role="alertdialog"
        aria-modal="true"
      >
        {/* Centered Circular Warning Icon */}
        <div
          className={`mx-auto w-14 h-14 rounded-full flex items-center justify-center border-2 ${
            isPrimary
              ? "bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 border-blue-200 dark:border-blue-800"
              : isWarning
              ? "bg-amber-100 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400 border-amber-200 dark:border-amber-800"
              : "bg-rose-100 dark:bg-rose-950/60 text-rose-600 dark:text-rose-400 border-rose-200 dark:border-rose-800"
          }`}
        >
          {isPrimary ? (
            <ShieldCheck className="w-7 h-7" />
          ) : isWarning ? (
            <AlertTriangle className="w-7 h-7" />
          ) : (
            <Trash2 className="w-7 h-7" />
          )}
        </div>

        {/* Text */}
        <div className="space-y-1.5">
          <h3 className="text-lg font-bold text-slate-900 dark:text-white">
            {title || (translations.confirm_deletion || "Confirm Deletion")}
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400 leading-relaxed max-w-sm mx-auto">
            {description || "Are you sure you want to delete this item? This action cannot be undone."}
          </p>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center justify-center gap-3 pt-3 border-t-2 border-slate-200 dark:border-slate-800">
          <button
            type="button"
            disabled={isLoading}
            onClick={onClose}
            className="w-full py-2.5 px-4 text-xs font-bold text-slate-700 dark:text-slate-300 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 rounded-xl transition cursor-pointer"
          >
            {cancelLabel || (translations.cancel || "Cancel")}
          </button>
          <button
            type="button"
            disabled={isLoading}
            onClick={() => {
              onConfirm();
              onClose();
            }}
            className={`w-full py-2.5 px-4 text-xs font-bold text-white rounded-xl shadow-md transition cursor-pointer flex items-center justify-center gap-1.5 ${
              isPrimary
                ? "bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500"
                : isWarning
                ? "bg-amber-600 hover:bg-amber-700 dark:bg-amber-600 dark:hover:bg-amber-500"
                : "bg-rose-600 hover:bg-rose-700 dark:bg-rose-600 dark:hover:bg-rose-500"
            }`}
          >
            {isPrimary ? (
              <CheckCircle2 className="w-4 h-4" />
            ) : isWarning ? (
              <AlertTriangle className="w-4 h-4" />
            ) : (
              <Trash2 className="w-4 h-4" />
            )}
            <span>{confirmLabel || (translations.delete || "Delete")}</span>
          </button>
        </div>
      </div>
    </div>
  );
}

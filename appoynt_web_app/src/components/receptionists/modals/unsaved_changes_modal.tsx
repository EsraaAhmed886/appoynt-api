/*
 * File Name: unsaved_changes_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Guard modal intercepting dismiss actions when unpersisted form modifications exist, offering explicit choices to continue editing or discard changes.
 */

"use client";

import React, { useEffect } from "react";
import { AlertTriangle, X } from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface UnsavedChangesModalProps {
  isOpen: boolean;
  onStay: () => void;
  onLeave: () => void;
}

export default function UnsavedChangesModal({
  isOpen,
  onStay,
  onLeave,
}: UnsavedChangesModalProps) {
  const { translations } = useTranslation();

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        onStay();
      }
    };
    if (isOpen) {
      window.addEventListener("keydown", handleKeyDown);
    }
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, onStay]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-60 flex items-center justify-center p-4 bg-slate-950/70 backdrop-blur-xs animate-in fade-in duration-150">
      <div className="w-full max-w-md bg-white dark:bg-[#0E1726] border-2 border-amber-300 dark:border-amber-900/60 rounded-2xl shadow-2xl p-6 space-y-5 animate-in zoom-in-95 duration-150">
        <div className="flex items-start gap-3.5">
          <div className="p-3 bg-amber-50 dark:bg-amber-950/80 text-amber-600 dark:text-amber-400 rounded-2xl border border-amber-200 dark:border-amber-800 shrink-0">
            <AlertTriangle className="w-6 h-6" />
          </div>
          <div>
            <h3 className="text-base font-bold text-slate-900 dark:text-white">
              {translations.unsaved_changes_title || "Unsaved Changes"}
            </h3>
            <p className="text-xs md:text-sm text-slate-600 dark:text-slate-400 mt-1 leading-relaxed">
              {translations.unsaved_changes_desc || "You have unsaved changes. Are you sure you want to discard them?"}
            </p>
          </div>
        </div>

        <div className="flex flex-col sm:flex-row items-center justify-end gap-2.5 pt-2">
          <button
            type="button"
            onClick={onStay}
            className="w-full sm:w-auto px-4 py-2.5 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl transition cursor-pointer"
          >
            {translations.stay_btn || "Stay & Continue Editing"}
          </button>
          <button
            type="button"
            onClick={onLeave}
            className="w-full sm:w-auto px-4 py-2.5 bg-amber-600 hover:bg-amber-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md transition cursor-pointer"
          >
            {translations.leave_btn || "Leave & Discard Changes"}
          </button>
        </div>
      </div>
    </div>
  );
}

/**
 * File Name : conflict_dialog.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Confirmation dialog for rescheduling affected patient appointments upon schedule modification.
 */

"use client";

import { AlertOctagon } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type ConflictDialogProps = {
  is_open: boolean;
  affected_count?: number;
  on_close: () => void;
  on_confirm_reschedule: () => void;
};

export default function ConflictDialog({
  is_open,
  affected_count = 3,
  on_close,
  on_confirm_reschedule,
}: ConflictDialogProps) {
  const { translations } = useTranslation();

  if (!is_open) {
    return null;
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm">
      <div className="w-full max-w-md rounded-2xl border border-app-border bg-app-surface p-6 shadow-2xl space-y-4">
        <div className="flex justify-center">
          <div className="flex h-16 w-16 items-center justify-center rounded-full bg-amber-100 dark:bg-amber-950/40">
            <AlertOctagon className="h-8 w-8 text-amber-600 dark:text-amber-400" />
          </div>
        </div>

        <div className="text-center space-y-2">
          <h3 className="text-xl font-bold text-app-text-primary">
            Schedule Conflict Detected
          </h3>
          <p className="text-sm text-app-text-secondary leading-relaxed">
            Updating the clinic working schedule or break times affects{" "}
            <span className="font-bold text-amber-600">{affected_count} confirmed patient appointments</span>.
          </p>
          <p className="text-xs text-app-text-secondary">
            Confirming will mark affected bookings as &quot;Requires Reschedule&quot; and notify patients automatically.
          </p>
        </div>

        <div className="flex items-center justify-end gap-3 border-t border-app-border pt-4">
          <button
            type="button"
            onClick={on_close}
            className="rounded-xl border border-app-border bg-app-surface px-4 py-2 text-sm font-medium text-app-text-primary hover:bg-app-input_fill transition-all"
          >
            {translations.btn_cancel}
          </button>
          <button
            type="button"
            onClick={on_confirm_reschedule}
            className="rounded-xl bg-amber-600 px-5 py-2 text-sm font-semibold text-white hover:bg-amber-700 transition-all shadow-md"
          >
            Confirm & Reschedule Patients
          </button>
        </div>
      </div>
    </div>
  );
}

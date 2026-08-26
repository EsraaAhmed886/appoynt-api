/*
 * File Name: confirm_end_modal.tsx
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.0.0
 * Dependencies: react, lucide-react, @/context/language_context
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Modal dialog prompting confirmation before ending active consultation session.
 */

"use client";

import { TriangleAlert, Loader2 } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type confirm_end_modal_props = {
  is_open: boolean;
  is_submitting?: boolean;
  on_close: () => void;
  on_confirm: () => void;
};

export default function confirm_end_modal({
  is_open,
  is_submitting = false,
  on_close,
  on_confirm,
}: confirm_end_modal_props) {
  const { translations } = useTranslation();

  if (false === is_open) {
    return null;
  } else {
    return (
      <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 px-4 backdrop-blur-xs">
        <div className="w-full max-w-md rounded-2xl bg-app-surface p-6 md:p-8 shadow-xl border border-app-border">
          <div className="mb-5 flex justify-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-full bg-amber-100 dark:bg-amber-900/30">
              <TriangleAlert className="h-8 w-8 text-amber-600 dark:text-amber-400" />
            </div>
          </div>

          <h2 className="text-center text-xl md:text-2xl font-bold text-app-text-primary">
            {translations.modal_end_consultation_title}
          </h2>

          <p className="mt-3 text-center text-sm md:text-base text-app-text-secondary">
            {translations.modal_end_consultation_desc}
          </p>

          <div className="mt-8 flex justify-center gap-4">
            <button
              type="button"
              disabled={is_submitting}
              onClick={on_confirm}
              className="
                flex items-center justify-center gap-2
                rounded-xl
                bg-app-primary
                px-6
                py-2.5
                text-sm
                font-medium
                text-white
                transition
                hover:opacity-90
                disabled:opacity-50
              "
            >
              {true === is_submitting ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : null}
              {translations.btn_end_consultation}
            </button>

            <button
              type="button"
              disabled={is_submitting}
              onClick={on_close}
              className="
                rounded-xl
                border
                border-app-border
                bg-app-surface
                px-6
                py-2.5
                text-sm
                font-medium
                text-app-text-primary
                transition
                hover:bg-app-input_fill
                disabled:opacity-50
              "
            >
              {translations.btn_cancel}
            </button>
          </div>
        </div>
      </div>
    );
  }
}

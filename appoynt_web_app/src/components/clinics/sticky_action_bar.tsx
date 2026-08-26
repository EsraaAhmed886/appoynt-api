/**
 * File Name : sticky_action_bar.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Sticky bottom action bar displaying unsaved changes warning, Cancel, and Save Changes buttons matching reference image.
 */

"use client";

import { AlertTriangle, Save } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type StickyActionBarProps = {
  is_visible: boolean;
  is_saving?: boolean;
  on_cancel: () => void;
  on_save: () => void;
};

export default function StickyActionBar({
  is_visible,
  is_saving = false,
  on_cancel,
  on_save,
}: StickyActionBarProps) {
  const { translations } = useTranslation();

  if (!is_visible) {
    return null;
  } else {
    // No action needed
  }

  return (
    <div className="fixed bottom-0 left-0 right-0 z-40 border-t border-app-border bg-app-surface/95 p-4 shadow-2xl backdrop-blur-md transition-all">
      <div className="mx-auto flex max-w-7xl flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        {/* Left Warning Container */}
        <div className="flex items-center gap-3 rounded-xl border border-amber-300/40 bg-amber-50 px-4 py-3 text-amber-800 dark:bg-amber-950/30 dark:text-amber-300">
          <AlertTriangle className="h-5 w-5 shrink-0 text-amber-600 dark:text-amber-400" />
          <div>
            <p className="text-sm font-bold">
              {translations.msg_unsaved_warning_title}
            </p>
            <p className="text-xs text-amber-700/80 dark:text-amber-400/80">
              {translations.msg_unsaved_warning_desc}
            </p>
          </div>
        </div>

        {/* Right Action Buttons */}
        <div className="flex items-center justify-end gap-3">
          <button
            type="button"
            onClick={on_cancel}
            className="rounded-xl border border-app-border bg-app-surface px-6 py-2.5 text-sm font-semibold text-app-text-primary hover:bg-app-input_fill transition-all"
          >
            {translations.btn_cancel}
          </button>

          <button
            type="button"
            disabled={is_saving}
            onClick={on_save}
            className="flex items-center gap-2 rounded-xl bg-app-primary px-6 py-2.5 text-sm font-semibold text-white shadow-md hover:opacity-90 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Save size={16} />
            <span>
              {is_saving
                ? translations.api_checking
                : translations.btn_save_changes}
            </span>
          </button>
        </div>
      </div>
    </div>
  );
}

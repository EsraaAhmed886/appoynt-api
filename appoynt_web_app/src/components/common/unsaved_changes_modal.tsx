/*
 * File Name: unsaved_changes_modal.tsx
 * Author: shimaa salah
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Warning modal when closing forms with dirty unsaved state.
 */

"use client";

import { useTranslation } from "@/context/language_context";

type UnsavedChangesModalProps = {
  is_open: boolean;
  on_stay: () => void;
  on_leave: () => void;
};

export default function UnsavedChangesModal({
  is_open,
  on_stay,
  on_leave,
}: UnsavedChangesModalProps) {
  const { translations } = useTranslation();

  if (false === is_open) {
    return null;
  } else {
    return (
      <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-sm px-4">
        <div className="w-full max-w-md rounded-2xl border border-app-border bg-app-surface px-8 py-10 shadow-2xl">
          <h2 className="text-center text-3xl font-bold text-app-primary">
            {translations.modal_unsaved_title}
          </h2>

          <p className="mt-6 text-center text-base font-semibold leading-7 text-app-text-primary">
            {translations.modal_unsaved_desc}
          </p>

          <div className="mt-10 flex items-center justify-center gap-4">
            <button
              type="button"
              onClick={on_stay}
              className="
                min-w-[120px]
                rounded-xl
                bg-app-primary
                px-6
                py-2.5
                text-sm
                font-medium
                text-white
                transition
                hover:opacity-90
              "
            >
              {translations.btn_stay}
            </button>

            <button
              type="button"
              onClick={on_leave}
              className="
                min-w-[120px]
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
              "
            >
              {translations.btn_leave}
            </button>
          </div>
        </div>
      </div>
    );
  }
}

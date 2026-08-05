/*
 * File Name: confirm_dialog.tsx
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Confirmation dialog prompt before performing destructive actions such as deleting a clinic.
 */

"use client";

import { TriangleAlert } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type DeleteClinicModalProps = {
  is_open: boolean;
  on_close: () => void;
  on_delete: () => void;
};

export default function DeleteClinicModal({
  is_open,
  on_close,
  on_delete,
}: DeleteClinicModalProps) {
  const { translations } = useTranslation();

  if (false === is_open) {
    return null;
  } else {
    return (
      <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 px-4">
        <div className="w-full max-w-md rounded-2xl bg-app-surface p-8 shadow-xl border border-app-border">
          <div className="mb-5 flex justify-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-full bg-red-100 dark:bg-red-900/30">
              <TriangleAlert className="h-8 w-8 text-red-600 dark:text-red-400" />
            </div>
          </div>

          <h2 className="text-center text-2xl font-bold text-app-primary">
            {translations.modal_delete_title}
          </h2>

          <p className="mt-4 text-center text-app-text-secondary">
            {translations.modal_delete_desc}
          </p>

          <div className="mt-8 flex justify-center gap-4">
            <button
              type="button"
              onClick={on_delete}
              className="
                rounded-xl
                bg-red-600
                px-8
                py-2.5
                text-sm
                font-medium
                text-white
                transition
                hover:bg-red-700
              "
            >
              {translations.btn_confirm_delete}
            </button>

            <button
              type="button"
              onClick={on_close}
              className="
                rounded-xl
                border
                border-app-border
                bg-app-surface
                px-8
                py-2.5
                text-sm
                font-medium
                text-app-text-primary
                transition
                hover:bg-app-input_fill
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
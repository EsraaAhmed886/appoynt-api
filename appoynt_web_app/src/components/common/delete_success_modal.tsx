/*
 * File Name: delete_success_modal.tsx
 * Author: shimaa salah
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Notification popup confirming deletion of a clinic record.
 */

"use client";

import { useTranslation } from "@/context/language_context";

type DeleteSuccessModalProps = {
  is_open: boolean;
  on_close: () => void;
};

export default function DeleteSuccessModal({
  is_open,
  on_close,
}: DeleteSuccessModalProps) {
  const { translations } = useTranslation();

  if (false === is_open) {
    return null;
  } else {
    return (
      <div className="fixed inset-0 z-[70] flex items-center justify-center bg-black/50 px-4">
        <div className="w-full max-w-sm rounded-2xl border border-app-border bg-app-surface p-8 shadow-xl">
          <h2 className="text-center text-xl font-bold text-app-primary">
            {translations.modal_delete_success_title}
          </h2>

          <p className="mt-5 text-center text-base font-semibold text-app-text-primary">
            {translations.modal_delete_success_desc}
          </p>

          <div className="mt-8 flex justify-center">
            <button
              type="button"
              onClick={on_close}
              className="
                rounded-xl
                bg-app-primary
                px-8
                py-2.5
                text-sm
                font-medium
                text-white
                transition
                hover:opacity-90
              "
            >
              {translations.btn_done}
            </button>
          </div>
        </div>
      </div>
    );
  }
}
/*
 * File Name: success_modal.tsx
 * Author: shimaa salah
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: General success notification feedback popup.
 */

"use client";

import { CircleCheck } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type SuccessModalProps = {
  is_open: boolean;
  on_close: () => void;
};

export default function SuccessModal({ is_open, on_close }: SuccessModalProps) {
  const { translations } = useTranslation();

  if (false === is_open) {
    return null;
  } else {
    return (
      <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/20 px-4">
        <div className="w-full max-w-[400px] rounded-2xl border border-app-border bg-app-surface px-8 py-10 shadow-2xl">
          <div className="mb-6 flex justify-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-full bg-green-100 dark:bg-green-900/30">
              <CircleCheck className="h-8 w-8 text-green-600 dark:text-green-400" />
            </div>
          </div>

          <h2 className="text-center text-2xl font-bold text-app-primary">
            {translations.modal_add_success_title}
          </h2>

          <p className="mt-4 text-center text-base font-semibold leading-7 text-app-text-primary">
            {translations.modal_add_success_desc}
          </p>

          <div className="mt-8 flex justify-center">
            <button
              type="button"
              onClick={on_close}
              className="
                h-11
                w-28
                rounded-xl
                bg-app-primary
                text-base
                font-semibold
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

/*
 * File Name: add_clinic_button.tsx
 * Author: shimaa salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Primary CTA button trigger to open the multi-step Add Clinic modal interface.
 */

"use client";

import { Plus } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type AddClinicButtonProps = {
  on_click: () => void;
};

export default function AddClinicButton({ on_click }: AddClinicButtonProps) {
  const { translations } = useTranslation();

  return (
    <button
      type="button"
      onClick={on_click}
      className="
        inline-flex
        items-center
        justify-center
        gap-2
        rounded-xl
        bg-app-primary
        px-5
        py-2.5
        text-sm
        font-medium
        text-white
        shadow-sm
        transition-all
        hover:opacity-90
        focus:outline-none
        focus:ring-2
        focus:ring-app-primary
        focus:ring-offset-2
      "
    >
      <Plus size={18} />
      <span>{translations.clinic_add_button}</span>
    </button>
  );
}

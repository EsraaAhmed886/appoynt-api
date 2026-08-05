/*
 * File Name: status_filter.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 *   - @/hooks/use_click_outside
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Custom dropdown filter component for filtering clinic records by active status.
 */

"use client";

import { useRef, useState } from "react";
import { ChevronDown } from "lucide-react";
import useClickOutside from "@/hooks/use_click_outside";
import { useTranslation } from "@/context/language_context";

type StatusFilterProps = {
  value: string;
  on_change: (value: string) => void;
};

export default function StatusFilter({ value, on_change }: StatusFilterProps) {
  const [is_open, set_is_open] = useState(false);
  const dropdown_ref = useRef<HTMLDivElement>(null);
  const { translations } = useTranslation();

  useClickOutside(dropdown_ref, () => {
    set_is_open(false);
  });

  const status_options = [
    { key: "All", label: translations.clinic_status_all },
    { key: "Active", label: translations.clinic_status_active },
    { key: "Inactive", label: translations.clinic_status_inactive },
  ];

  const selected_option =
    status_options.find((item) => item.key === value) || status_options[0];

  return (
    <div ref={dropdown_ref} className="relative w-36 shrink-0">
      <button
        type="button"
        aria-haspopup="listbox"
        aria-expanded={is_open}
        onClick={() => set_is_open(!is_open)}
        className="
          flex
          h-11
          w-full
          items-center
          justify-between
          rounded-xl
          border
          border-app-border
          bg-app-surface
          px-4
          text-sm
          font-medium
          text-app-text-primary
          shadow-sm
          transition-all
          hover:border-app-primary
          focus-visible:ring-2
          focus-visible:ring-app-primary/20
        "
      >
        <span className="truncate">{selected_option.label}</span>

        <ChevronDown
          size={18}
          className={`shrink-0 transition-transform duration-200 ${
            is_open ? "rotate-180 text-app-primary" : ""
          }`}
        />
      </button>

      <div
        className={`
          absolute
          left-0
          right-0
          top-full
          z-50
          mt-1.5
          origin-top
          overflow-hidden
          rounded-xl
          border
          border-app-border
          bg-app-surface
          p-1
          shadow-xl
          transition-all
          duration-200
          ${is_open ? "visible scale-100 opacity-100" : "invisible scale-95 opacity-0 pointer-events-none"}
        `}
      >
        {status_options.map((option) => {
          const is_selected = option.key === value;

          return (
            <button
              key={option.key}
              type="button"
              onClick={() => {
                on_change(option.key);
                set_is_open(false);
              }}
              className={`
                block
                w-full
                rounded-lg
                px-3.5
                py-2.5
                text-start
                text-sm
                transition-colors
                duration-150
                ${
                  is_selected
                    ? "bg-app-primary text-white font-medium"
                    : "text-app-text-primary hover:bg-app-input_fill"
                }
              `}
            >
              {option.label}
            </button>
          );
        })}
      </div>
    </div>
  );
}

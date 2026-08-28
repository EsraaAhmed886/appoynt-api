/*
 * File Name: search_input.tsx
 * Author: shimaa salah
 * Date of Creation: 20/06/2026
 * Version Information: V1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [Shimaa Salah - 28/08/2026]
 * File Description: Reusable search input element with configurable localized placeholder and icon positioning.
 */

"use client";

import { Search } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type ClinicSearchProps = {
  search: string;
  on_search_change: (value: string) => void;
  placeholder?: string;
};

export default function ClinicSearch({
  search,
  on_search_change,
  placeholder,
}: ClinicSearchProps) {
  const { translations } = useTranslation();

  const activePlaceholder: string =
    placeholder || translations.clinic_search_placeholder;

  return (
    <div className="relative w-full sm:w-80">
      <Search
        className="absolute left-3 top-1/2 -translate-y-1/2 text-app-text-secondary rtl:right-3 rtl:left-auto"
        size={18}
      />

      <input
        type="text"
        value={search}
        placeholder={activePlaceholder}
        className="
          w-full
          rounded-xl
          border
          border-app-border
          bg-app-input_fill
          py-2.5
          pl-10
          pr-4
          rtl:pr-10
          rtl:pl-4
          text-sm
          text-app-text-primary
          shadow-sm
          placeholder:text-app-text-secondary
          focus:outline-none
          focus:ring-2
          focus:ring-app-primary/20
          focus:border-app-primary
          transition-all
        "
        onChange={(e) => on_search_change(e.target.value)}
      />
    </div>
  );
}
/**
 * File Name : filtered_empty_state.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Contextual empty state component shown when reviews exist but current rating filter returns zero matches, providing a Clear Filters button.
 */

"use client";

import React from "react";
import { FilterX } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type FilteredEmptyStateProps = {
  onClearFilters: () => void;
};

export default function FilteredEmptyState({
  onClearFilters,
}: FilteredEmptyStateProps) {
  const { translations } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center p-8 sm:p-12 text-center rounded-2xl border border-app-border bg-app-surface shadow-xs space-y-4">
      <div className="w-14 h-14 rounded-2xl bg-blue-50 dark:bg-blue-950/50 text-blue-600 dark:text-blue-400 flex items-center justify-center shadow-xs">
        <FilterX className="w-7 h-7" />
      </div>

      <div className="space-y-1 max-w-sm">
        <h3 className="text-base sm:text-lg font-bold text-app-text-primary">
          {translations.filtered_empty_title || "No Reviews Found"}
        </h3>
        <p className="text-xs sm:text-sm text-app-text-secondary">
          {translations.filtered_empty_desc ||
            "No reviews match the selected rating filter."}
        </p>
      </div>

      <button
        type="button"
        onClick={onClearFilters}
        className="px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs sm:text-sm font-semibold transition shadow-xs cursor-pointer"
      >
        {translations.btn_clear_filters || "Clear Filters"}
      </button>
    </div>
  );
}

/*
 * File Name: no_search_results_state.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Search zero-matches state displayed when active search or clinic filtering yields no matching receptionists, featuring a quick reset action.
 */

"use client";

import React from "react";
import { SearchX, RotateCcw } from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface NoSearchResultsStateProps {
  query?: string;
  onClear: () => void;
}

export default function NoSearchResultsState({ query, onClear }: NoSearchResultsStateProps) {
  const { translations } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center p-8 md:p-12 text-center bg-white dark:bg-[#0E1726] border-2 border-dashed border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs animate-in fade-in">
      <div className="p-4 bg-slate-100 dark:bg-slate-800 text-slate-500 dark:text-slate-400 rounded-3xl mb-4">
        <SearchX className="w-10 h-10" />
      </div>

      <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-2">
        {translations.no_search_results_title || "No Matching Receptionists"}
      </h3>

      <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 max-w-md mb-6 leading-relaxed">
        {query ? (
          <>
            {(translations.no_search_results_desc || "No receptionist accounts matched your search criteria for: ")}
            <span className="font-semibold text-slate-800 dark:text-slate-200"> &ldquo;{query}&rdquo;</span>
          </>
        ) : (
          translations.no_search_results_desc || "No receptionist accounts matched your search criteria."
        )}
      </p>

      <button
        type="button"
        onClick={onClear}
        className="inline-flex items-center gap-2 px-4 py-2 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl transition cursor-pointer"
      >
        <RotateCcw className="w-4 h-4" />
        <span>{translations.clear_search || "Clear Search"}</span>
      </button>
    </div>
  );
}

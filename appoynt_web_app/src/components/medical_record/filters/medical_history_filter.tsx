/*
 * File Name: medical_history_filter.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 *   - @/components/ui/custom_select
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Modern multi-facet filtering bar component with CustomSelect components, integrated search input, and responsive action controls for medical history records.
 */

"use client";

import React from "react";
import { Search, RotateCcw, Filter } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { CustomSelect } from "@/components/ui/custom_select";

export interface MedicalHistoryFilterValues {
  searchQuery: string;
  status: string;
  doctor: string;
}

interface MedicalHistoryFilterProps {
  filters: MedicalHistoryFilterValues;
  onFilterChange: (filters: MedicalHistoryFilterValues) => void;
  onReset: () => void;
  doctorOptions?: string[];
  className?: string;
}

export default function MedicalHistoryFilter({
  filters,
  onFilterChange,
  onReset,
  doctorOptions = [
    "Dr. Nada Khan",
    "Dr. Tarek Youssef",
    "Dr. Mona Fikry",
    "Dr. Karim Samy",
  ],
  className = "",
}: MedicalHistoryFilterProps) {
  const { translations } = useTranslation();

  return (
    <div
      className={`bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 md:p-6 shadow-xs space-y-4 ${className}`}
    >
      <div className="flex items-center gap-2 text-sm font-bold text-slate-800 dark:text-slate-200">
        <Filter className="w-4 h-4 text-blue-600 dark:text-blue-400" />
        <span>{translations.filter_record_status || "Filter Medical Records"}</span>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4 items-center">
        {/* Search Query Input */}
        <div className="relative">
          <input
            type="text"
            value={filters.searchQuery || ""}
            onChange={(e) =>
              onFilterChange({ ...filters, searchQuery: e.target.value })
            }
            placeholder={translations.search_icd10_placeholder || "Search diagnosis or code..."}
            className="w-full ps-10 pe-4 h-11 bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700/80 rounded-xl text-sm font-medium text-slate-800 dark:text-slate-200 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all"
          />
          <Search className="w-4 h-4 text-slate-400 absolute start-3.5 top-1/2 -translate-y-1/2" />
        </div>

        {/* Record Status CustomSelect */}
        <CustomSelect
          value={filters.status || "ALL"}
          onChange={(e) =>
            onFilterChange({ ...filters, status: e.target.value })
          }
        >
          <option value="ALL">{translations.filter_all_status || "All Statuses"}</option>
          <option value="FINALIZED">{translations.finalized || "Finalized"}</option>
          <option value="DRAFT">{translations.draft || "Draft"}</option>
        </CustomSelect>

        {/* Doctor CustomSelect */}
        <CustomSelect
          value={filters.doctor || "ALL"}
          onChange={(e) =>
            onFilterChange({ ...filters, doctor: e.target.value })
          }
        >
          <option value="ALL">{translations.filter_all_doctors || "All Attending Doctors"}</option>
          {doctorOptions.map((doc) => (
            <option key={doc} value={doc}>
              {doc}
            </option>
          ))}
        </CustomSelect>

        {/* Reset Filter Button */}
        <div>
          <button
            type="button"
            onClick={onReset}
            className="w-full h-11 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 font-semibold px-4 rounded-xl text-sm flex items-center justify-center gap-2 border border-slate-200 dark:border-slate-700 transition-colors cursor-pointer"
          >
            <RotateCcw className="w-4 h-4" />
            <span>{translations.reset_filters || "Reset Filters"}</span>
          </button>
        </div>
      </div>
    </div>
  );
}

/*
 * File Name: receptionist_filter_bar.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/receptionist_context
 *   - @/context/language_context
 *   - @/components/ui/custom_select_dropdown
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Smart filter toolbar featuring debounced search input, sorting options (Newest, Oldest, Name A-Z, Name Z-A), and multi-clinic selector with quick reset controls.
 */

"use client";

import React, { useState, useEffect, useMemo } from "react";
import { Search, X, Filter, RotateCcw } from "lucide-react";
import { useReceptionists } from "@/context/receptionist_context";
import { useTranslation } from "@/context/language_context";
import CustomSelectDropdown, { DropdownOption } from "@/components/ui/custom_select_dropdown";
import { ReceptionistSortOption, ReceptionistStatus } from "@/types/receptionist";

export default function ReceptionistFilterBar() {
  const {
    search,
    setSearch,
    sort,
    setSort,
    clinicFilter,
    setClinicFilter,
    statusFilter,
    setStatusFilter,
    clinics,
  } = useReceptionists();
  const { translations } = useTranslation();

  const [localSearch, setLocalSearch] = useState(search);

  // 300ms debounce on search input
  useEffect(() => {
    const handler = setTimeout(() => {
      if (localSearch !== search) {
        setSearch(localSearch);
      }
    }, 300);
    return () => clearTimeout(handler);
  }, [localSearch, search, setSearch]);

  // Sync if context search changes externally (e.g. clear search)
  useEffect(() => {
    setLocalSearch(search);
  }, [search]);

  // Status Filter Options
  const statusOptions: DropdownOption[] = useMemo(
    () => [
      {
        value: "ALL",
        label: translations.all_statuses || "All Statuses",
      },
      {
        value: "active",
        label: translations.status_active || "Active",
        dotColor: "bg-emerald-500",
      },
      {
        value: "inactive",
        label: translations.status_inactive || "Inactive",
        dotColor: "bg-slate-400",
      },
    ],
    [translations]
  );

  // Clinic Filter Options
  const clinicOptions: DropdownOption[] = useMemo(() => {
    const list: DropdownOption[] = [
      {
        value: "ALL",
        label: translations.all_clinics || "All Clinics",
      },
    ];
    for (const c of clinics) {
      list.push({
        value: c.id,
        label: c.name,
        subLabel: c.is_active ? undefined : (translations.inactive_clinic || "Inactive"),
      });
    }
    return list;
  }, [clinics, translations]);

  // Sort Options
  const sortOptions: DropdownOption[] = useMemo(
    () => [
      {
        value: "newest",
        label: translations.sort_newest || "Newest",
      },
      {
        value: "oldest",
        label: translations.sort_oldest || "Oldest",
      },
      {
        value: "name_asc",
        label: translations.sort_name_asc || "Name (A-Z)",
      },
      {
        value: "name_desc",
        label: translations.sort_name_desc || "Name (Z-A)",
      },
    ],
    [translations]
  );

  const handleReset = () => {
    setLocalSearch("");
    setSearch("");
    setClinicFilter("ALL");
    setStatusFilter("ALL");
    setSort("newest");
  };

  const isFiltered =
    search.trim().length > 0 ||
    clinicFilter !== "ALL" ||
    statusFilter !== "ALL" ||
    sort !== "newest";

  return (
    <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 md:p-5 shadow-xs space-y-4">
      <div className="flex items-center justify-between gap-3">
        <div className="flex items-center gap-2 text-xs font-bold text-slate-900 dark:text-white uppercase tracking-wider">
          <Filter className="w-4 h-4 text-blue-600 dark:text-blue-400" />
          <span>{translations.search_and_filters || "SEARCH & FILTERS"}</span>
        </div>

        {isFiltered && (
          <button
            type="button"
            onClick={handleReset}
            className="text-xs font-bold text-slate-500 hover:text-slate-900 dark:hover:text-white inline-flex items-center gap-1.5 cursor-pointer transition"
          >
            <RotateCcw className="w-3.5 h-3.5" />
            <span>{translations.reset || "Reset Filters"}</span>
          </button>
        )}
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3.5">
        {/* 1. Search Input */}
        <div>
          <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
            {translations.search || "Search"}
          </label>
          <div className="relative">
            <Search className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 pointer-events-none" />
            <input
              type="text"
              value={localSearch}
              onChange={(e) => setLocalSearch(e.target.value)}
              placeholder={translations.search_receptionist_placeholder || "Search by name, username, or phone..."}
              className="w-full ps-10 pe-10 h-11 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl text-xs md:text-sm font-medium text-slate-900 dark:text-slate-100 placeholder-slate-400 focus:outline-none focus:border-blue-500 transition"
            />
            {localSearch.length > 0 && (
              <button
                type="button"
                onClick={() => {
                  setLocalSearch("");
                  setSearch("");
                }}
                className="absolute end-3.5 top-1/2 -translate-y-1/2 p-0.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 transition cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            )}
          </div>
        </div>

        {/* 2. Assigned Clinics Selector */}
        <CustomSelectDropdown
          label={translations.assigned_clinics_label || "Assigned Clinics"}
          options={clinicOptions}
          value={clinicFilter}
          onChange={(val) => setClinicFilter(val)}
          searchable={clinics.length > 4}
        />

        {/* 3. Status Selector */}
        <CustomSelectDropdown
          label={translations.status_filter || translations.status_label || "Status"}
          options={statusOptions}
          value={statusFilter}
          onChange={(val) => setStatusFilter(val as "ALL" | ReceptionistStatus)}
          searchable={false}
        />

        {/* 4. Sort Selector */}
        <CustomSelectDropdown
          label={translations.sort_by || "Sort By"}
          options={sortOptions}
          value={sort}
          onChange={(val) => setSort(val as ReceptionistSortOption)}
          searchable={false}
        />
      </div>
    </div>
  );
}

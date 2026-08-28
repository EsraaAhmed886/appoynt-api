/*
 * File Name: pagination.tsx
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.2.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/hooks/use_click_outside
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 29/08/2026]
 * File Description: Shared accessible pagination bar providing record index summary, bidirectional page stepper controls, maximum 5 visible pages, and customizable page limit sizing (10, 25, 50) with animated dynamic dropdown.
 */

"use client";

import React, { useState, useRef } from "react";
import { ChevronLeft, ChevronRight, ChevronDown } from "lucide-react";
import useClickOutside from "@/hooks/use_click_outside";
import { useTranslation } from "@/context/language_context";

type PaginationProps = {
  current_page?: number;
  currentPage?: number;
  page?: number;
  total_pages?: number;
  totalPages?: number;
  total?: number;
  total_records?: number;
  totalRecords?: number;
  limit?: number;
  per_page?: number;
  perPage?: number;
  on_page_change?: (page: number) => void;
  onPageChange?: (page: number) => void;
  setPage?: (page: number) => void;
  on_limit_change?: (limit: number) => void;
  onLimitChange?: (limit: number) => void;
  setLimit?: (limit: number) => void;
};

export default function Pagination({
  current_page,
  currentPage,
  page: pageProp,
  total_pages,
  totalPages: totalPagesProp,
  total: totalProp,
  total_records,
  totalRecords,
  limit: limitProp,
  per_page,
  perPage,
  on_page_change,
  onPageChange,
  setPage,
  on_limit_change,
  onLimitChange,
  setLimit,
}: PaginationProps) {
  const { translations } = useTranslation();

  const page = current_page ?? currentPage ?? pageProp ?? 1;
  const totalPages = total_pages ?? totalPagesProp ?? 1;

  const initialLimit = limitProp ?? per_page ?? perPage ?? 10;
  const [internalLimit, setInternalLimit] = useState(initialLimit);
  const limit = limitProp ?? per_page ?? perPage ?? internalLimit;

  const [is_limit_open, set_is_limit_open] = useState(false);
  const limit_dropdown_ref = useRef<HTMLDivElement>(null);

  useClickOutside(limit_dropdown_ref, () => {
    set_is_limit_open(false);
  });

  const limit_options = Array.from(new Set([10, 25, 50, limit])).sort((a, b) => a - b);

  const total =
    totalProp ?? total_records ?? totalRecords ?? totalPages * limit;

  if (total === 0) {
    return null;
  }

  const startRecord = (page - 1) * limit + 1;
  const endRecord = Math.min(page * limit, total);

  const getPageNumbers = () => {
    const pages: number[] = [];
    const maxVisible = 5;
    let start = Math.max(1, page - 2);
    let end = Math.min(totalPages, start + maxVisible - 1);

    if (end - start + 1 < maxVisible) {
      start = Math.max(1, end - maxVisible + 1);
    }

    for (let i = start; i <= end; i++) {
      pages.push(i);
    }

    return pages;
  };

  const pageNumbers = getPageNumbers();

  const handlePageChange = (newPage: number) => {
    if (on_page_change) {
      on_page_change(newPage);
    }
    if (onPageChange) {
      onPageChange(newPage);
    }
    if (setPage) {
      setPage(newPage);
    }
  };

  const handleLimitChange = (newLimit: number) => {
    setInternalLimit(newLimit);
    if (on_limit_change) {
      on_limit_change(newLimit);
    }
    if (onLimitChange) {
      onLimitChange(newLimit);
    }
    if (setLimit) {
      setLimit(newLimit);
    }
  };

  return (
    <div className="flex flex-col sm:flex-row items-center justify-between gap-4 p-4 bg-slate-50 dark:bg-[#131E35] border-t-2 border-slate-200 dark:border-slate-800 text-xs font-medium rounded-b-2xl w-full">
      {/* Left: Records summary */}
      <span className="text-slate-600 dark:text-slate-400">
        {(
          translations.showing_records_count ||
          "Showing {from} to {to} of {total} records"
        )
          .replace("{from}", String(startRecord))
          .replace("{to}", String(endRecord))
          .replace("{total}", String(total))}
      </span>

      {/* Center: Pagination buttons */}
      <div className="flex items-center gap-1.5">
        <button
          type="button"
          onClick={() => handlePageChange(page - 1)}
          disabled={page <= 1}
          className="p-1.5 rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-[#0E1726] text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed transition cursor-pointer"
        >
          <ChevronLeft className="w-4 h-4 rtl:rotate-180" />
        </button>

        {pageNumbers.map((p) => (
          <button
            key={p}
            type="button"
            onClick={() => handlePageChange(p)}
            className={`min-w-[32px] h-8 px-2 rounded-lg font-bold transition cursor-pointer text-xs ${
              p === page
                ? "bg-blue-600 text-white shadow-xs"
                : "border border-slate-200 dark:border-slate-700 bg-white dark:bg-[#0E1726] text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
            }`}
          >
            {p}
          </button>
        ))}

        <button
          type="button"
          onClick={() => handlePageChange(page + 1)}
          disabled={page >= totalPages}
          className="p-1.5 rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-[#0E1726] text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 disabled:opacity-40 disabled:cursor-not-allowed transition cursor-pointer"
        >
          <ChevronRight className="w-4 h-4 rtl:rotate-180" />
        </button>
      </div>

      {/* Right: Page size selector */}
      <div className="flex items-center gap-2">
        <span className="text-slate-500 dark:text-slate-400 text-xs hidden md:inline">
          {translations.records_per_page || "Records per page"}:
        </span>

        <div ref={limit_dropdown_ref} className="relative inline-block text-start">
          <button
            type="button"
            aria-expanded={is_limit_open}
            onClick={() => set_is_limit_open((prev) => !prev)}
            className={`flex items-center justify-between gap-2 h-8 px-2.5 min-w-[64px] bg-white dark:bg-[#0E1726] border rounded-lg text-xs font-semibold text-slate-700 dark:text-slate-300 transition-all cursor-pointer ${
              is_limit_open
                ? "border-blue-500 ring-2 ring-blue-500/10"
                : "border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800"
            }`}
          >
            <span>{limit}</span>
            <ChevronDown
              className={`w-3.5 h-3.5 transition-transform duration-200 shrink-0 ${
                is_limit_open ? "rotate-180 text-blue-600 dark:text-blue-400" : "text-slate-400"
              }`}
            />
          </button>

          {is_limit_open ? (
            <div className="absolute bottom-full mb-1.5 end-0 z-50 min-w-full rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-[#0E1726] p-1 shadow-lg shadow-slate-200/50 dark:shadow-slate-950/60 ring-1 ring-black/5 animate-in fade-in zoom-in-95 duration-100">
              <div className="flex flex-col space-y-0.5">
                {limit_options.map((opt) => {
                  const is_selected = opt === limit;
                  return (
                    <button
                      key={opt}
                      type="button"
                      onClick={() => {
                        handleLimitChange(opt);
                        set_is_limit_open(false);
                      }}
                      className={`w-full flex items-center justify-center px-2.5 py-1.5 text-xs rounded-lg font-semibold transition-colors cursor-pointer ${
                        is_selected
                          ? "bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400"
                          : "text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
                      }`}
                    >
                      {opt}
                    </button>
                  );
                })}
              </div>
            </div>
          ) : null}
        </div>
      </div>
    </div>
  );
}
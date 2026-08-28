/*
 * File Name: pagination.tsx
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 28/08/2026]
 * File Description: Shared accessible pagination bar providing record index summary, bidirectional page stepper controls, maximum 5 visible pages, and customizable page limit sizing (10, 25, 50).
 */

"use client";

import React, { useState } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";
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

        <select
          value={limit}
          onChange={(e) => handleLimitChange(Number(e.target.value))}
          className="h-8 px-2.5 bg-white dark:bg-[#0E1726] border border-slate-200 dark:border-slate-700 rounded-lg text-xs font-semibold text-slate-700 dark:text-slate-300 focus:outline-none focus:border-blue-500 transition cursor-pointer"
        >
          <option value={10}>10</option>
          <option value={25}>25</option>
          <option value={50}>50</option>
        </select>
      </div>
    </div>
  );
}
/*
 * File Name: pagination.tsx
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Shared pagination controls component supporting snake_case and camelCase prop signatures.
 */

"use client";

import { ChevronLeft, ChevronRight } from "lucide-react";

type PaginationProps = {
  current_page?: number;
  currentPage?: number;
  total_pages?: number;
  totalPages?: number;
  on_page_change?: (page: number) => void;
  onPageChange?: (page: number) => void;
};

export default function Pagination({
  current_page,
  currentPage,
  total_pages,
  totalPages,
  on_page_change,
  onPageChange,
}: PaginationProps) {
  const active_page = current_page ?? currentPage ?? 1;
  const max_pages = total_pages ?? totalPages ?? 1;
  const change_handler = on_page_change ?? onPageChange ?? (() => {});

  const is_first_page = 1 === active_page;
  const is_last_page = max_pages === active_page;

  return (
    <div className="mt-6 flex items-center justify-center gap-3">
      <button
        type="button"
        disabled={is_first_page}
        onClick={() => {
          if (!is_first_page) {
            change_handler(active_page - 1);
          } else {
            // Disabled action
          }
        }}
        className="
          flex h-8 w-8 items-center justify-center
          rounded-full
          bg-gray-100
          text-gray-500
          transition
          hover:bg-gray-200
          dark:bg-slate-700
          dark:text-gray-300
          dark:hover:bg-slate-600
          disabled:cursor-not-allowed
          disabled:opacity-50
          rtl:rotate-180
        "
      >
        <ChevronLeft size={16} />
      </button>

      <div
        className="
          flex h-8 w-8 items-center justify-center
          rounded-full
          bg-blue-600
          text-sm
          font-semibold
          text-white
        "
      >
        {active_page}
      </div>

      <button
        type="button"
        disabled={is_last_page}
        onClick={() => {
          if (!is_last_page) {
            change_handler(active_page + 1);
          } else {
            // Disabled action
          }
        }}
        className="
          flex h-8 w-8 items-center justify-center
          rounded-full
          bg-gray-100
          text-gray-500
          transition
          hover:bg-gray-200
          dark:bg-slate-700
          dark:text-gray-300
          dark:hover:bg-slate-600
          disabled:cursor-not-allowed
          disabled:opacity-50
          rtl:rotate-180
        "
      >
        <ChevronRight size={16} />
      </button>
    </div>
  );
}
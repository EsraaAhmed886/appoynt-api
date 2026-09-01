/*
 * File Name: time_slots_panel.tsx
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.2.0
 * Dependencies: react, lucide-react, @/types/appointment, @/context/language_context
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Client component rendering time slots timeline grid, date navigation picker, status badges, and color legend with soft subtle Dark Mode theme colors.
 */

"use client";

import { ChevronLeft, ChevronRight, Calendar } from "lucide-react";
import { time_slot } from "@/types/appointment";
import { useTranslation } from "@/context/language_context";
import { formatLocalizedDate } from "@/lib/utils/date_utils";

type time_slots_panel_props = {
  selected_date: string;
  time_slots: time_slot[];
};

export default function time_slots_panel({
  selected_date,
  time_slots,
}: time_slots_panel_props) {
  const { translations, current_locale } = useTranslation();

  // Helper function to render slot card style based on status with soft Dark Mode support
  const get_slot_style = (status: time_slot["status"]) => {
    if ("in_consultation" === status) {
      return "border-blue-300 bg-blue-50 text-blue-800 dark:bg-blue-950/30 dark:text-blue-300 dark:border-blue-800/60";
    } else if ("booked" === status) {
      return "border-gray-200 bg-gray-50 text-gray-600 dark:bg-app-bg/60 dark:text-app-text-secondary dark:border-app-border/60";
    } else if ("break" === status) {
      return "border-rose-200 bg-rose-50 text-rose-700 dark:bg-rose-950/30 dark:text-rose-300 dark:border-rose-800/60";
    } else {
      return "border-emerald-300 bg-emerald-50/60 text-emerald-800 dark:bg-emerald-950/30 dark:text-emerald-300 dark:border-emerald-800/60";
    }
  };

  // Helper function to get localized status text label
  const get_slot_label = (status: time_slot["status"]) => {
    if ("in_consultation" === status) {
      return translations.in_consultation_badge;
    } else if ("booked" === status) {
      return translations.booked_badge;
    } else if ("break" === status) {
      return translations.break_badge;
    } else {
      return translations.available_badge;
    }
  };

  return (
    <div className="rounded-2xl bg-app-surface p-5 md:p-6 border border-app-border shadow-xs space-y-5">
      {/* Panel Header */}
      <h3 className="text-lg font-bold text-app-text-primary">
        {translations.time_slots_title}
      </h3>

      {/* Date Navigation Bar */}
      <div className="flex items-center justify-between p-2.5 rounded-xl border border-app-border bg-app-bg/50 text-xs">
        <button
          type="button"
          aria-label="Previous date"
          className="p-1 rounded-lg hover:bg-app-surface text-app-text-secondary transition rtl:rotate-180"
        >
          <ChevronLeft className="h-4 w-4" />
        </button>

        <div className="flex items-center gap-2 font-semibold text-app-text-primary">
          <Calendar className="h-3.5 w-3.5 text-app-primary" />
          <span>{formatLocalizedDate(selected_date, current_locale)}</span>
        </div>

        <button
          type="button"
          aria-label="Next date"
          className="p-1 rounded-lg hover:bg-app-surface text-app-text-secondary transition rtl:rotate-180"
        >
          <ChevronRight className="h-4 w-4" />
        </button>
      </div>

      {/* 2-Column Time Slots Grid */}
      <div className="grid grid-cols-2 gap-3">
        {time_slots.map((slot) => (
          <div
            key={slot.id}
            className={`
              flex flex-col items-center justify-center p-3 rounded-xl border text-center transition-all
              ${get_slot_style(slot.status)}
            `}
          >
            <span className="font-bold text-xs" dir="ltr">{slot.time}</span>
            <span className="text-[10px] font-medium opacity-80 mt-0.5">
              ({get_slot_label(slot.status)})
            </span>
          </div>
        ))}
      </div>

      {/* Legend at bottom */}
      <div className="pt-4 border-t border-app-border/40 grid grid-cols-2 gap-2 text-[11px] text-app-text-secondary">
        <div className="flex items-center gap-1.5">
          <span className="h-2 w-2 rounded-full bg-emerald-500" />
          <span>{translations.available_badge}</span>
        </div>

        <div className="flex items-center gap-1.5">
          <span className="h-2 w-2 rounded-full bg-blue-500" />
          <span>{translations.in_consultation_badge}</span>
        </div>

        <div className="flex items-center gap-1.5">
          <span className="h-2 w-2 rounded-full bg-gray-400" />
          <span>{translations.booked_badge}</span>
        </div>

        <div className="flex items-center gap-1.5">
          <span className="h-2 w-2 rounded-full bg-rose-500" />
          <span>{translations.break_badge}</span>
        </div>
      </div>
    </div>
  );
}

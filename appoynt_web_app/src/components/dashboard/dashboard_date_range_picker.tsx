/*
 * File Name: dashboard_date_range_picker.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, @/types/dashboard, @/context/dashboard_context, @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Date range filter controller with immediate preset switches and validated custom date range popover strictly enforcing 365-day and future-date guards (VR-01 to VR-08).
 */

"use client";

import React, { useState, useRef, useEffect } from "react";
import { Calendar, ChevronDown, Check, X, AlertCircle } from "lucide-react";
import { CustomDateRange, DateRangePreset } from "@/types/dashboard";
import { useDashboard } from "@/context/dashboard_context";
import { useTranslation } from "@/context/language_context";

interface PresetOption {
  key: DateRangePreset;
  label_key: string;
}

const PRESETS: PresetOption[] = [
  { key: "last_7_days", label_key: "date_last_7_days" },
  { key: "last_30_days", label_key: "date_last_30_days" },
  { key: "this_month", label_key: "date_this_month" },
  { key: "last_month", label_key: "date_last_month" },
  { key: "custom", label_key: "date_custom_range" },
];

export const DashboardDateRangePicker: React.FC = () => {
  const { date_range_preset, custom_date_range, set_date_range } = useDashboard();
  const { t } = useTranslation();

  const [is_open, set_is_open] = useState(false);
  const [is_custom_modal_open, set_is_custom_modal_open] = useState(false);

  // Custom date range draft states (YYYY-MM-DD)
  const today_str = new Date().toISOString().split("T")[0];
  const [start_date, set_start_date] = useState(custom_date_range?.from || today_str);
  const [end_date, set_end_date] = useState(custom_date_range?.to || today_str);
  const [validation_error, set_validation_error] = useState<string | null>(null);

  const dropdown_ref = useRef<HTMLDivElement>(null);

  // Close dropdown on outside click
  useEffect(() => {
    const handle_outside_click = (e: MouseEvent) => {
      if (dropdown_ref.current && !dropdown_ref.current.contains(e.target as Node)) {
        set_is_open(false);
      }
    };
    document.addEventListener("mousedown", handle_outside_click);
    return () => document.removeEventListener("mousedown", handle_outside_click);
  }, []);

  // Validation logic (VR-01 to VR-08)
  const validate_custom_range = (from: string, to: string): string | null => {
    if (!from || !to) {
      return "invalid_date_range";
    }

    const start = new Date(from);
    const end = new Date(to);
    const today = new Date(today_str);

    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
      return "invalid_date_range";
    }

    if (start > end) {
      return "date_order_error";
    }

    if (end > today) {
      return "date_future_error";
    }

    const diff_days = Math.floor((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24));
    if (diff_days > 365) {
      return "date_max_duration_error";
    }

    return null;
  };

  const handle_preset_select = (preset: DateRangePreset) => {
    if (preset === "custom") {
      set_is_open(false);
      set_is_custom_modal_open(true);
    } else {
      set_date_range(preset);
      set_is_open(false);
    }
  };

  const handle_apply_custom = () => {
    const err = validate_custom_range(start_date, end_date);
    if (err) {
      set_validation_error(err);
      return;
    }

    const custom: CustomDateRange = { from: start_date, to: end_date };
    set_date_range("custom", custom);
    set_is_custom_modal_open(false);
    set_validation_error(null);
  };

  const handle_start_change = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    set_start_date(val);
    set_validation_error(validate_custom_range(val, end_date));
  };

  const handle_end_change = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value;
    set_end_date(val);
    set_validation_error(validate_custom_range(start_date, val));
  };

  // Active label display
  const active_preset_obj = PRESETS.find((p) => p.key === date_range_preset);
  const active_label =
    date_range_preset === "custom" && custom_date_range
      ? `${custom_date_range.from} → ${custom_date_range.to}`
      : active_preset_obj
      ? /* @ts-expect-error dynamic key */
        t(active_preset_obj.label_key)
      : t("date_last_30_days");

  const is_custom_valid = validate_custom_range(start_date, end_date) === null;

  return (
    <div className="relative inline-block text-start" ref={dropdown_ref}>
      {/* Date Range Dropdown Trigger */}
      <button
        type="button"
        onClick={() => set_is_open(!is_open)}
        className="inline-flex items-center gap-2.5 px-3.5 py-2 text-xs sm:text-sm font-medium rounded-xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 hover:bg-gray-50 dark:hover:bg-gray-800/80 text-gray-700 dark:text-gray-200 shadow-xs transition-all cursor-pointer focus:outline-hidden focus:ring-2 focus:ring-blue-500/20"
      >
        <Calendar className="w-4 h-4 text-blue-600 dark:text-blue-400 shrink-0" />
        <span className="font-semibold truncate max-w-[140px] sm:max-w-[200px]">{active_label}</span>
        <ChevronDown className={`w-3.5 h-3.5 text-gray-400 transition-transform ${is_open ? "rotate-180" : ""}`} />
      </button>

      {/* Presets Menu */}
      {is_open ? (
        <div className="absolute end-0 mt-2 w-52 rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white dark:bg-gray-900 p-1.5 shadow-xl z-50 animate-in fade-in zoom-in-95 duration-100">
          {PRESETS.map((preset) => {
            const is_selected = date_range_preset === preset.key;
            return (
              <button
                key={preset.key}
                type="button"
                onClick={() => handle_preset_select(preset.key)}
                className={`w-full flex items-center justify-between px-3 py-2 text-xs sm:text-sm rounded-xl font-medium transition-colors cursor-pointer text-start ${
                  is_selected
                    ? "bg-blue-50 dark:bg-blue-950/50 text-blue-600 dark:text-blue-400 font-semibold"
                    : "text-gray-700 dark:text-gray-300 hover:bg-gray-100/70 dark:hover:bg-gray-800/70"
                }`}
              >
                {/* @ts-expect-error dynamic key */}
                <span>{t(preset.label_key)}</span>
                {is_selected ? <Check className="w-4 h-4 text-blue-600 dark:text-blue-400" /> : null}
              </button>
            );
          })}
        </div>
      ) : null}

      {/* Custom Range Popover Modal */}
      {is_custom_modal_open ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-xs animate-in fade-in">
          <div className="w-full max-w-md rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 p-6 shadow-2xl space-y-5 animate-in zoom-in-95">
            <div className="flex items-center justify-between border-b border-gray-100 dark:border-gray-800 pb-3">
              <div className="flex items-center gap-2">
                <Calendar className="w-5 h-5 text-blue-600 dark:text-blue-400" />
                <h3 className="text-base font-semibold text-gray-900 dark:text-white">
                  {t("custom_date_range_title")}
                </h3>
              </div>
              <button
                type="button"
                onClick={() => set_is_custom_modal_open(false)}
                className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 p-1 rounded-lg transition-colors cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-1.5">
                <label className="block text-xs font-semibold text-gray-600 dark:text-gray-300">
                  {t("start_date")}
                </label>
                <input
                  type="date"
                  max={today_str}
                  value={start_date}
                  onChange={handle_start_change}
                  className="w-full px-3 py-2 text-xs sm:text-sm rounded-xl border border-gray-200 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800 text-gray-900 dark:text-white focus:outline-hidden focus:ring-2 focus:ring-blue-500/20"
                />
              </div>

              <div className="space-y-1.5">
                <label className="block text-xs font-semibold text-gray-600 dark:text-gray-300">
                  {t("end_date")}
                </label>
                <input
                  type="date"
                  max={today_str}
                  value={end_date}
                  onChange={handle_end_change}
                  className="w-full px-3 py-2 text-xs sm:text-sm rounded-xl border border-gray-200 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800 text-gray-900 dark:text-white focus:outline-hidden focus:ring-2 focus:ring-blue-500/20"
                />
              </div>
            </div>

            {validation_error ? (
              <div className="flex items-center gap-2 p-3 rounded-xl bg-red-50 dark:bg-red-950/30 text-red-600 dark:text-red-400 text-xs font-medium border border-red-200/60 dark:border-red-900/40">
                <AlertCircle className="w-4 h-4 shrink-0" />
                {/* @ts-expect-error dynamic key */}
                <span>{t(validation_error) || t("invalid_date_range")}</span>
              </div>
            ) : null}

            <div className="flex items-center justify-end gap-2.5 pt-2">
              <button
                type="button"
                onClick={() => set_is_custom_modal_open(false)}
                className="px-4 py-2 text-xs sm:text-sm font-medium rounded-xl text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors cursor-pointer"
              >
                {t("close")}
              </button>
              <button
                type="button"
                onClick={handle_apply_custom}
                disabled={!is_custom_valid}
                className="px-5 py-2 text-xs sm:text-sm font-semibold rounded-xl text-white bg-blue-600 hover:bg-blue-700 active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed transition-all cursor-pointer shadow-xs"
              >
                {t("apply")}
              </button>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
};

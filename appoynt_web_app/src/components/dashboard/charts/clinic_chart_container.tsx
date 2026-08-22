/*
 * File Name: clinic_chart_container.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, @/types/dashboard, @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Reusable card container for clinic analytics charts with independent clinic dropdown filter, chart body slot, and metric summary footer (BR-40 to BR-53).
 */

"use client";

import React from "react";
import { Trophy } from "lucide-react";
import { ClinicOption } from "@/types/dashboard";
import { useTranslation } from "@/context/language_context";
import { DashboardDropdown, DropdownOption } from "@/components/common/dashboard_dropdown";

interface ClinicChartContainerProps {
  title_key: string;
  desc_key: string;
  icon: React.ReactNode;
  icon_bg_class: string;
  selected_clinic_id: string;
  on_clinic_change: (clinic_id: string) => void;
  clinics: ClinicOption[];
  total_label_key: string;
  total_value: string | number;
  top_clinics: string[];
  tied_count?: number;
  top_value_formatted?: string;
  children: React.ReactNode;
}

export const ClinicChartContainer: React.FC<ClinicChartContainerProps> = ({
  title_key,
  desc_key,
  icon,
  icon_bg_class,
  selected_clinic_id,
  on_clinic_change,
  clinics,
  total_label_key,
  total_value,
  top_clinics,
  tied_count,
  top_value_formatted,
  children,
}) => {
  const { t } = useTranslation();

  // Convert clinics list to dropdown options format
  const clinic_options: DropdownOption[] = [
    { value: "all", label: t("view_all_clinics") },
    ...clinics.map((c) => ({ value: c.id, label: c.name })),
  ];

  // Format top clinics text with tie-breaker rule (BR-50, BR-51)
  const render_top_clinic_text = () => {
    if (top_clinics.length === 0) {
      return "—";
    }

    if (top_clinics.length <= 3) {
      const names = top_clinics.join(", ");
      return top_value_formatted ? `${names} (${top_value_formatted})` : names;
    }

    // If > 3 tied clinics, show up to 3 + "+N tied clinics"
    const first_three = top_clinics.slice(0, 3).join(", ");
    const remaining = top_clinics.length - 3;
    const tied_text = t("tied_clinics").replace("{count}", remaining.toString());
    return `${first_three}, ${tied_text} ${top_value_formatted ? `(${top_value_formatted})` : ""}`;
  };

  return (
    <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 sm:p-6 shadow-xs hover:shadow-md transition-all flex flex-col justify-between space-y-5">
      {/* Top Header: Title + Independent Clinic Selector */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-gray-100 dark:border-gray-800/80 pb-4">
        <div className="flex items-center gap-3">
          <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 shadow-xs ${icon_bg_class}`}>
            {icon}
          </div>
          <div>
            <h2 className="text-base font-bold text-gray-900 dark:text-white">
              {/* @ts-expect-error dynamic key */}
              {t(title_key) || title_key}
            </h2>
            <p className="text-xs text-gray-500 dark:text-gray-400 font-medium">
              {/* @ts-expect-error dynamic key */}
              {t(desc_key) || desc_key}
            </p>
          </div>
        </div>

        {/* Independent Custom Clinic Selector Dropdown (BR-40, BR-43) */}
        <DashboardDropdown
          options={clinic_options}
          value={selected_clinic_id}
          onChange={on_clinic_change}
          width="w-48 sm:w-56"
        />
      </div>

      {/* Chart Canvas / Slot */}
      <div className="flex-1 min-h-[260px] flex flex-col justify-center">
        {children}
      </div>

      {/* Bottom Summary Strip (BR-49 to BR-53) */}
      <div className="pt-3 border-t border-gray-100 dark:border-gray-800/80 flex flex-col sm:flex-row sm:items-center justify-between gap-2 text-xs font-semibold">
        {/* Left: Total Aggregate */}
        <div className="text-gray-600 dark:text-gray-300 flex items-center gap-1.5">
          {/* @ts-expect-error dynamic key */}
          <span className="text-gray-400 dark:text-gray-500">{t(total_label_key)}:</span>
          <span className="font-bold text-gray-900 dark:text-white">{total_value}</span>
        </div>

        {/* Right: Top Clinic Badge */}
        {top_clinics.length > 0 ? (
          <div className="flex items-center gap-1.5 text-amber-700 dark:text-amber-400 bg-amber-50 dark:bg-amber-950/40 px-2.5 py-1 rounded-lg border border-amber-200/60 dark:border-amber-900/40 truncate max-w-full sm:max-w-[65%]">
            <Trophy className="w-3.5 h-3.5 shrink-0 text-amber-500" />
            <span className="text-amber-800 dark:text-amber-300 shrink-0 font-bold">
              {t("top_clinic")}:
            </span>
            <span className="truncate">{render_top_clinic_text()}</span>
          </div>
        ) : null}
      </div>
    </div>
  );
};

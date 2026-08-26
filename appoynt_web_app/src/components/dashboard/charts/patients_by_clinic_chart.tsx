/*
 * File Name: patients_by_clinic_chart.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, @/context/dashboard_context, @/context/language_context, @/components/dashboard/charts/clinic_chart_container, @/components/dashboard/states/dashboard_skeleton, @/components/dashboard/states/component_error_state, @/components/dashboard/states/empty_chart_state
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Renders the Patients by Clinic interactive bar chart with top-10 grouping, tie-breaking, and isolated retry error boundaries (BR-39 to BR-53).
 */

"use client";

import React, { useState } from "react";
import { Users } from "lucide-react";
import { useDashboard } from "@/context/dashboard_context";
import { useTranslation } from "@/context/language_context";
import { ClinicChartContainer } from "@/components/dashboard/charts/clinic_chart_container";
import { ChartSkeleton } from "@/components/dashboard/states/dashboard_skeleton";
import { ComponentErrorState } from "@/components/dashboard/states/component_error_state";
import { EmptyChartState } from "@/components/dashboard/states/empty_chart_state";

export const PatientsByClinicChart: React.FC = () => {
  const {
    patients_chart,
    patients_loading,
    patients_error,
    patients_clinic_id,
    set_patients_clinic_id,
    clinics_list,
    refresh_patients_chart,
  } = useDashboard();
  const { t } = useTranslation();

  const [hovered_index, set_hovered_index] = useState<number | null>(null);

  if (patients_loading) {
    return <ChartSkeleton />;
  } else if (patients_error || !patients_chart) {
    return (
      <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 shadow-xs">
        <ComponentErrorState
          message_key="error_loading_chart"
          on_retry={refresh_patients_chart}
          height="min-h-[300px]"
        />
      </div>
    );
  } else {
    // Chart data available
  }

  const { points, total, top_clinics, tied_count } = patients_chart;

  if (points.length === 0) {
    return (
      <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 shadow-xs">
        <EmptyChartState />
      </div>
    );
  } else {
    // Points non empty
  }

  // Calculate max value for relative bar heights
  const max_value = Math.max(...points.map((p) => p.value), 1);

  // Top clinic value formatting
  const max_val = Math.max(...points.map((p) => p.value), 0);
  const top_val_formatted = t("patients_count_label").replace("{count}", max_val.toLocaleString());

  return (
    <ClinicChartContainer
      title_key="patients_by_clinic"
      desc_key="patients_by_clinic_desc"
      icon={<Users className="w-5 h-5 text-blue-600 dark:text-blue-400" />}
      icon_bg_class="bg-blue-50 dark:bg-blue-950/60"
      selected_clinic_id={patients_clinic_id}
      on_clinic_change={set_patients_clinic_id}
      clinics={clinics_list}
      total_label_key="total_patients"
      total_value={total.toLocaleString()}
      top_clinics={top_clinics}
      tied_count={tied_count}
      top_value_formatted={top_val_formatted}
    >
      {/* SVG Bar Chart Visualization */}
      <div className="relative w-full h-[220px] pt-8 pb-6 flex items-end justify-between gap-1.5 sm:gap-3">
        {/* Horizontal Background Grid Guidelines */}
        <div className="absolute inset-0 flex flex-col justify-between pointer-events-none pb-6 pt-8">
          <div className="border-b border-gray-100 dark:border-gray-800/60 w-full" />
          <div className="border-b border-gray-100 dark:border-gray-800/60 w-full" />
          <div className="border-b border-gray-200 dark:border-gray-700 w-full" />
        </div>

        {/* Bars Container */}
        {points.map((point, index) => {
          const height_pct = Math.max((point.value / max_value) * 100, 4);
          const is_hovered = hovered_index === index;
          const is_others = point.clinic_id === "others";

          return (
            <div
              key={point.clinic_id}
              className="relative flex-1 h-full flex flex-col items-center justify-end group z-10"
              onMouseEnter={() => set_hovered_index(index)}
              onMouseLeave={() => set_hovered_index(null)}
            >
              {/* Tooltip */}
              {is_hovered ? (
                <div className="absolute -top-10 z-30 px-2.5 py-1 rounded-lg bg-gray-900 dark:bg-white text-white dark:text-gray-900 text-[11px] font-bold shadow-lg whitespace-nowrap animate-in fade-in zoom-in-95 pointer-events-none">
                  <span>{point.clinic_name}: </span>
                  <span className="text-blue-400 dark:text-blue-600 font-extrabold">
                    {point.value.toLocaleString()}
                  </span>
                </div>
              ) : null}

              {/* Bar Fill */}
              <div
                style={{ height: `${height_pct}%` }}
                className={`w-full max-w-[36px] rounded-t-lg transition-all duration-300 ease-out cursor-pointer ${
                  is_others
                    ? is_hovered
                      ? "bg-gray-500 dark:bg-gray-400"
                      : "bg-gray-400 dark:bg-gray-600"
                    : is_hovered
                    ? "bg-blue-700 dark:bg-blue-400 shadow-md shadow-blue-500/20"
                    : "bg-blue-600 dark:bg-blue-500"
                }`}
              />

              {/* Bottom Clinic Label */}
              <span
                className="mt-2 text-[10px] sm:text-[11px] font-medium text-gray-500 dark:text-gray-400 truncate max-w-full text-center block"
                title={point.clinic_name}
              >
                {point.clinic_name.length > 8
                  ? `${point.clinic_name.slice(0, 7)}...`
                  : point.clinic_name}
              </span>
            </div>
          );
        })}
      </div>
    </ClinicChartContainer>
  );
};

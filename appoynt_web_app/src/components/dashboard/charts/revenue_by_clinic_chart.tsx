/*
 * File Name: revenue_by_clinic_chart.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, @/context/dashboard_context, @/context/language_context, @/components/dashboard/charts/clinic_chart_container, @/components/dashboard/states/dashboard_skeleton, @/components/dashboard/states/component_error_state, @/components/dashboard/states/empty_chart_state
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Renders the Revenue by Clinic interactive bar chart supporting positive emerald bars, negative red refund bars, and independent clinic selection (BR-54 to BR-57).
 */

"use client";

import React, { useState } from "react";
import { Wallet } from "lucide-react";
import { useDashboard } from "@/context/dashboard_context";
import { useTranslation } from "@/context/language_context";
import { ClinicChartContainer } from "@/components/dashboard/charts/clinic_chart_container";
import { ChartSkeleton } from "@/components/dashboard/states/dashboard_skeleton";
import { ComponentErrorState } from "@/components/dashboard/states/component_error_state";
import { EmptyChartState } from "@/components/dashboard/states/empty_chart_state";

export const RevenueByClinicChart: React.FC = () => {
  const {
    revenue_chart,
    revenue_loading,
    revenue_error,
    revenue_clinic_id,
    set_revenue_clinic_id,
    clinics_list,
    refresh_revenue_chart,
  } = useDashboard();
  const { t } = useTranslation();

  const [hovered_index, set_hovered_index] = useState<number | null>(null);

  if (revenue_loading) {
    return <ChartSkeleton />;
  }

  if (revenue_error || !revenue_chart) {
    return (
      <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 shadow-xs">
        <ComponentErrorState
          message_key="error_loading_chart"
          on_retry={refresh_revenue_chart}
          height="min-h-[300px]"
        />
      </div>
    );
  }

  const { points, total, top_clinics, tied_count, currency = "EGP" } = revenue_chart;

  if (points.length === 0) {
    return (
      <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 shadow-xs">
        <EmptyChartState />
      </div>
    );
  }

  // Calculate positive max and negative min for dual-directional baseline
  const max_positive = Math.max(...points.map((p) => (p.value > 0 ? p.value : 0)), 1);
  const min_negative = Math.min(...points.map((p) => (p.value < 0 ? p.value : 0)), 0);
  const has_negative = min_negative < 0;

  // Baseline position percentage from bottom
  const total_span = max_positive - min_negative;
  const baseline_pct = has_negative ? (Math.abs(min_negative) / total_span) * 100 : 0;

  // Top clinic formatted text
  const max_val = Math.max(...points.map((p) => p.value), 0);
  const top_val_formatted = `${max_val.toLocaleString()} ${currency}`;

  return (
    <ClinicChartContainer
      title_key="revenue_by_clinic"
      desc_key="revenue_by_clinic_desc"
      icon={<Wallet className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />}
      icon_bg_class="bg-emerald-50 dark:bg-emerald-950/60"
      selected_clinic_id={revenue_clinic_id}
      on_clinic_change={set_revenue_clinic_id}
      clinics={clinics_list}
      total_label_key="total_revenue"
      total_value={`${total.toLocaleString()} ${currency}`}
      top_clinics={top_clinics}
      tied_count={tied_count}
      top_value_formatted={top_val_formatted}
    >
      {/* SVG Bar Chart Canvas with 0-Baseline */}
      <div className="relative w-full h-[220px] pt-8 pb-6 flex items-stretch justify-between gap-1.5 sm:gap-3">
        {/* Horizontal Baseline Guideline */}
        <div
          style={{ bottom: `${Math.max(baseline_pct, 12)}%` }}
          className="absolute inset-x-0 border-b-2 border-dashed border-gray-300 dark:border-gray-600 z-0 pointer-events-none"
        />

        {/* Bars Container */}
        {points.map((point, index) => {
          const is_negative = point.value < 0;
          const is_hovered = hovered_index === index;
          const is_others = point.clinic_id === "others";

          // Calculate height relative to total span
          const bar_height_pct = Math.max(
            (Math.abs(point.value) / (has_negative ? total_span : max_positive)) * 100,
            4
          );

          return (
            <div
              key={point.clinic_id}
              className="relative flex-1 h-full flex flex-col justify-end items-center group z-10"
              onMouseEnter={() => set_hovered_index(index)}
              onMouseLeave={() => set_hovered_index(null)}
            >
              {/* Tooltip */}
              {is_hovered ? (
                <div className="absolute -top-10 z-30 px-2.5 py-1 rounded-lg bg-gray-900 dark:bg-white text-white dark:text-gray-900 text-[11px] font-bold shadow-lg whitespace-nowrap animate-in fade-in zoom-in-95 pointer-events-none">
                  <span>{point.clinic_name}: </span>
                  <span
                    className={
                      is_negative
                        ? "text-red-400 dark:text-red-600 font-extrabold"
                        : "text-emerald-400 dark:text-emerald-600 font-extrabold"
                    }
                  >
                    {point.value.toLocaleString()} {currency}
                  </span>
                </div>
              ) : null}

              {/* Bar Fill */}
              <div className="relative w-full max-w-[36px] flex-1 flex flex-col justify-end items-center">
                <div
                  style={{ height: `${bar_height_pct}%` }}
                  className={`w-full rounded-t-lg transition-all duration-300 ease-out cursor-pointer ${
                    is_negative
                      ? is_hovered
                        ? "bg-red-700 dark:bg-red-400 shadow-md shadow-red-500/20"
                        : "bg-red-500 dark:bg-red-600"
                      : is_others
                      ? is_hovered
                        ? "bg-gray-500 dark:bg-gray-400"
                        : "bg-gray-400 dark:bg-gray-600"
                      : is_hovered
                      ? "bg-emerald-700 dark:bg-emerald-400 shadow-md shadow-emerald-500/20"
                      : "bg-emerald-600 dark:bg-emerald-500"
                  }`}
                />
              </div>

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

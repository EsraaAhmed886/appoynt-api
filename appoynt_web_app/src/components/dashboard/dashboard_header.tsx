/*
 * File Name: dashboard_header.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.1.0
 * Dependencies: react, @/context/dashboard_context, @/context/language_context, @/components/dashboard/dashboard_date_range_picker
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Top greeting and action strip with dynamic doctor salutation and responsive date range controller.
 */

"use client";

import React from "react";
import { useDashboard } from "@/context/dashboard_context";
import { useTranslation } from "@/context/language_context";
import { DashboardDateRangePicker } from "@/components/dashboard/dashboard_date_range_picker";

export const DashboardHeader: React.FC = () => {
  const { doctor_profile } = useDashboard();
  const { t } = useTranslation();

  const doctor_name = doctor_profile?.display_name || "Sara Hassan";
  const greeting_text = t("dashboard_greeting").replace("{name}", doctor_name);

  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 pb-2 border-b border-gray-200/60 dark:border-gray-800/80">
      {/* Left: Salutation & Subtitle */}
      <div className="space-y-1">
        <h1 className="text-xl sm:text-2xl lg:text-3xl font-bold tracking-tight text-gray-900 dark:text-white flex items-center gap-2">
          <span>{greeting_text}</span>
        </h1>
        <p className="text-xs sm:text-sm text-gray-500 dark:text-gray-400 font-medium">
          {t("dashboard_subtitle")}
        </p>
      </div>

      {/* Right: Date Range Selector ONLY */}
      <div className="flex items-center">
        <DashboardDateRangePicker />
      </div>
    </div>
  );
};


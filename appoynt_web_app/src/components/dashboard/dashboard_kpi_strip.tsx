/*
 * File Name: dashboard_kpi_strip.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, @/context/dashboard_context, @/components/dashboard/kpi_card_item, @/components/dashboard/states/dashboard_skeleton, @/components/dashboard/states/component_error_state
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Top metrics grid rendering 4 core clinical KPI cards with isolated skeleton loading and error fallback states.
 */

"use client";

import React from "react";
import { Calendar, Users, Clock, Wallet } from "lucide-react";
import { useDashboard } from "@/context/dashboard_context";
import { KpiCardItem } from "@/components/dashboard/kpi_card_item";
import { KpiCardSkeleton } from "@/components/dashboard/states/dashboard_skeleton";
import { ComponentErrorState } from "@/components/dashboard/states/component_error_state";

export const DashboardKpiStrip: React.FC = () => {
  const { stats, stats_loading, stats_error, refresh_stats } = useDashboard();

  if (stats_loading) {
    return (
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <KpiCardSkeleton />
        <KpiCardSkeleton />
        <KpiCardSkeleton />
        <KpiCardSkeleton />
      </div>
    );
  } else if (stats_error || !stats) {
    return (
      <ComponentErrorState
        message_key="error_loading_stats"
        on_retry={refresh_stats}
        height="min-h-[140px]"
      />
    );
  } else {
    // Stats loaded
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
      {/* Card 1: Today's Appointments */}
      <KpiCardItem
        title_key="todays_appointments"
        value={stats.today_appointments.count}
        icon={<Calendar className="w-6 h-6" />}
        icon_bg_class="bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400"
        comparison={stats.today_appointments.comparison}
      />

      {/* Card 2: Total Patients */}
      <KpiCardItem
        title_key="total_patients"
        value={stats.total_patients}
        icon={<Users className="w-6 h-6" />}
        icon_bg_class="bg-emerald-50 dark:bg-emerald-950/60 text-emerald-600 dark:text-emerald-400"
      />

      {/* Card 3: Pending Appointments */}
      <KpiCardItem
        title_key="pending_appointments"
        value={stats.pending_appointments}
        icon={<Clock className="w-6 h-6" />}
        icon_bg_class="bg-amber-50 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400"
      />

      {/* Card 4: Today's Revenue */}
      <KpiCardItem
        title_key="todays_revenue"
        value={stats.today_revenue.amount}
        currency={stats.today_revenue.currency}
        icon={<Wallet className="w-6 h-6" />}
        icon_bg_class="bg-purple-50 dark:bg-purple-950/60 text-purple-600 dark:text-purple-400"
        comparison={stats.today_revenue.comparison}
        is_negative_allowed={true}
      />
    </div>
  );
};

/*
 * File Name: doctor_dashboard_view.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.1.0
 * Dependencies: react, @/context/dashboard_context, @/components/dashboard/dashboard_header, @/components/dashboard/dashboard_kpi_strip, @/components/dashboard/widgets/live_queue_bar, @/components/dashboard/charts/patients_by_clinic_chart, @/components/dashboard/charts/revenue_by_clinic_chart, @/components/dashboard/widgets/recent_activity_widget, @/components/dashboard/widgets/patient_rating_widget, @/components/dashboard/widgets/quick_actions_widget
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Top-level Doctor Dashboard view composing the greeting header, KPI statistics strip, live waiting room queue bar, independent clinic charts, and bottom widgets into a unified responsive layout.
 */

"use client";

import React from "react";
import { useDashboard } from "@/context/dashboard_context";
import { DashboardHeader } from "@/components/dashboard/dashboard_header";
import { DashboardKpiStrip } from "@/components/dashboard/dashboard_kpi_strip";
import { LiveQueueBar } from "@/components/dashboard/widgets/live_queue_bar";
import { PatientsByClinicChart } from "@/components/dashboard/charts/patients_by_clinic_chart";
import { RevenueByClinicChart } from "@/components/dashboard/charts/revenue_by_clinic_chart";
import { RecentActivityWidget } from "@/components/dashboard/widgets/recent_activity_widget";
import { PatientRatingWidget } from "@/components/dashboard/widgets/patient_rating_widget";
import { QuickActionsWidget } from "@/components/dashboard/widgets/quick_actions_widget";

export const DoctorDashboardView: React.FC = () => {
  const { live_queue } = useDashboard();

  return (
    <div className="w-full space-y-6 animate-in fade-in duration-300">
      {/* 1. Header with Doctor Greeting & Date Range Controller */}
      <DashboardHeader />

      {/* 2. 4 KPI Statistics Cards Strip */}
      <DashboardKpiStrip />

      {/* 3. Live Waiting Room & Next-Up Consultation Queue Bar */}
      <LiveQueueBar
        current_patient={live_queue?.current_patient}
        total_waiting_count={live_queue?.total_waiting_count ?? 0}
        pending_lab_count={live_queue?.pending_lab_reviews_count ?? 0}
      />

      {/* 4. Independent Clinic Analytics Charts (Patients & Revenue) */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <PatientsByClinicChart />
        <RevenueByClinicChart />
      </div>

      {/* 5. 3-Column Bottom Widgets Strip (Recent Activity, Rating, Quick Actions) */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <RecentActivityWidget />
        <PatientRatingWidget />
        <QuickActionsWidget />
      </div>
    </div>
  );
};

export default DoctorDashboardView;

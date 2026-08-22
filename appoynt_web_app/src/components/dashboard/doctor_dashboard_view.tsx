/*
 * File Name: doctor_dashboard_view.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, @/components/dashboard/dashboard_header, @/components/dashboard/dashboard_kpi_strip, @/components/dashboard/charts/patients_by_clinic_chart, @/components/dashboard/charts/revenue_by_clinic_chart, @/components/dashboard/widgets/recent_activity_widget, @/components/dashboard/widgets/patient_rating_widget, @/components/dashboard/widgets/quick_actions_widget
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Top-level Doctor Dashboard view composing the greeting header, KPI statistics strip, independent clinic charts, and bottom widgets into a unified responsive layout.
 */

"use client";

import React from "react";
import { DashboardHeader } from "@/components/dashboard/dashboard_header";
import { DashboardKpiStrip } from "@/components/dashboard/dashboard_kpi_strip";
import { PatientsByClinicChart } from "@/components/dashboard/charts/patients_by_clinic_chart";
import { RevenueByClinicChart } from "@/components/dashboard/charts/revenue_by_clinic_chart";
import { RecentActivityWidget } from "@/components/dashboard/widgets/recent_activity_widget";
import { PatientRatingWidget } from "@/components/dashboard/widgets/patient_rating_widget";
import { QuickActionsWidget } from "@/components/dashboard/widgets/quick_actions_widget";

export const DoctorDashboardView: React.FC = () => {
  return (
    <div className="w-full space-y-6 animate-in fade-in duration-300">
      {/* 1. Header with Doctor Greeting, Unread Counter & Date Range Controller */}
      <DashboardHeader />

      {/* 2. 4 KPI Statistics Cards Strip */}
      <DashboardKpiStrip />

      {/* 3. Independent Clinic Analytics Charts (Patients & Revenue) */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <PatientsByClinicChart />
        <RevenueByClinicChart />
      </div>

      {/* 4. 3-Column Bottom Widgets Strip (Recent Activity, Rating, Quick Actions) */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <RecentActivityWidget />
        <PatientRatingWidget />
        <QuickActionsWidget />
      </div>
    </div>
  );
};

export default DoctorDashboardView;

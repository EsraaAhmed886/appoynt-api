/*
 * File Name: page.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: @/components/layout/dashboard_layout, @/context/dashboard_context, @/components/dashboard/doctor_dashboard_view
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Server page entry and client workspace wrapper for the Clinical Doctor Dashboard integrated into the persistent Appoynt dashboard layout.
 */

import DashboardLayout from "@/components/layout/dashboard_layout";
import { DashboardProvider } from "@/context/dashboard_context";
import DoctorDashboardView from "@/components/dashboard/doctor_dashboard_view";

export default function DashboardPage() {
  return (
    <DashboardLayout>
      <DashboardProvider>
        <div className="w-full min-h-screen px-4 sm:px-6 lg:px-8 py-6 space-y-6 max-w-[1600px] mx-auto">
          <DoctorDashboardView />
        </div>
      </DashboardProvider>
    </DashboardLayout>
  );
}

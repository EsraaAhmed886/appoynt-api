/*
 * File Name: page.tsx
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.0.0
 * Dependencies: @/components/layout/dashboard_layout, @/components/appointments/appointments_dashboard
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Next.js App Router Server Component entry page for Doctor Appointments Workspace. Wraps dashboard with persistent DashboardLayout.
 */

import DashboardLayout from "@/components/layout/dashboard_layout";
import AppointmentsDashboard from "@/components/appointments/appointments_dashboard";

export default function AppointmentsPage() {
  return (
    <DashboardLayout>
      <AppointmentsDashboard />
    </DashboardLayout>
  );
}

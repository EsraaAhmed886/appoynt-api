/**
File Name : page.tsx
Author : Shimaa Salah
Created Date : 28/08/2026
Version : v1.0.0
Dependencies :
  - @/components/layout/dashboard_layout
  - @/components/patients/patients_dashboard
Contributors : [Shimaa Salah]
Last Modified : Shimaa Salah - 28/08/2026
Description : Server Component entry route for Patient Management (/patients), delegating interactive state, table filtering, and dialogs to PatientsDashboard within DashboardLayout.
*/

import DashboardLayout from "@/components/layout/dashboard_layout";
import PatientsDashboard from "@/components/patients/patients_dashboard";

export default function PatientsPage() {
  return (
    <DashboardLayout>
      <PatientsDashboard />
    </DashboardLayout>
  );
}

/*
 * File Name: page.tsx
 * Author: shimaa salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.2.0
 * Dependencies:
 *   - @/components/layout/dashboard_layout
 *   - @/components/clinics/clinics_dashboard
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description:
 *   Server Component entry page for Clinics Management. Delegates interactive
 *   dashboard logic, modal state management, and filtering to Client Component.
 */

import DashboardLayout from "@/components/layout/dashboard_layout";
import ClinicsDashboard from "@/components/clinics/clinics_dashboard";

export default function ClinicsPage() {
  return (
    <DashboardLayout>
      <ClinicsDashboard />
    </DashboardLayout>
  );
}

/*
 * File Name: page.tsx
 * Author: shimaa salah
 * Date of Creation: 13/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, @/components/clinics/clinic_view_edit_page
 * Contributors: [shimaa salah]
 * Last Modified Date: [shimaa salah - 26/08/2026]
 * File Description: Server component route entry page for Clinic View/Edit Full Page.
 */

import { use } from "react";
import DashboardLayout from "@/components/layout/dashboard_layout";
import ClinicViewEditPage from "@/components/clinics/clinic_view_edit_page";

type ClinicEditPageProps = {
  params: Promise<{ id: string }> | { id: string };
};

export default function ClinicEditPage({ params }: ClinicEditPageProps) {
  const resolved_params = "then" in params ? use(params) : params;
  const clinic_id = parseInt(resolved_params.id, 10) || 1;

  return (
    <DashboardLayout>
      <ClinicViewEditPage clinic_id={clinic_id} />
    </DashboardLayout>
  );
}

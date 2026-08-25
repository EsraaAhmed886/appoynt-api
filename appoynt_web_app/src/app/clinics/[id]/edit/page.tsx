/**
 * File Name : page.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-13
 * Version : v1.0.0
 * Dependencies : react, @/components/clinics/clinic_view_edit_page
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Server component route entry page for Clinic View/Edit Full Page.
 */

import { use } from "react";
import ClinicViewEditPage from "@/components/clinics/clinic_view_edit_page";

type ClinicEditPageProps = {
  params: Promise<{ id: string }> | { id: string };
};

export default function ClinicEditPage({ params }: ClinicEditPageProps) {
  const resolved_params = "then" in params ? use(params) : params;
  const clinic_id = parseInt(resolved_params.id, 10) || 1;

  return <ClinicViewEditPage clinic_id={clinic_id} />;
}

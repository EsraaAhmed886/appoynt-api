"use client";

import { useState } from "react";
import ClinicHeader from "@/components/clinics/clinic_header";
import ClinicTable from "@/components/clinics/clinic_table";
import ClinicToolbar from "@/components/clinics/clinic_toolbar";
import AddClinicModal from "@/components/clinics/add_clinic_modal";

export default function ClinicsPage() {
  const [isAddClinicOpen, setIsAddClinicOpen] = useState(false);
  console.log("isAddClinicOpen:", isAddClinicOpen);
  return (
    <div className="p-6">
      <ClinicHeader />

      <div className="mt-8">
        <ClinicToolbar onAddClinic={() => setIsAddClinicOpen(true)} />
        <ClinicTable />
        <AddClinicModal
          isOpen={isAddClinicOpen}
          onClose={() => setIsAddClinicOpen(false)}
        />
      </div>
    </div>
  );
}

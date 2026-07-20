/*
 * File Name: page.tsx
 * Author: Shimaa Salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next
 *   - lucide-react
 *   - @/components/layout/dashboard_layout
 *   - @/components/clinics/*
 *   - @/services/clinic.service
 * Last Modified Date: [Shimaa Salah - 20/07/2026]
 * File Description:
 *   Clinics Management page for managing doctor clinics,
 *   including clinic listing, searching, sorting, adding,
 *   deleting clinics, pagination, and related modal states.
 */

"use client";

import { useEffect, useState } from "react";
import DashboardLayout from "@/components/layout/dashboard_layout";
import ClinicHeader from "@/components/clinics/clinic_header";
import ClinicTable from "@/components/clinics/clinic_table";
import ClinicToolbar from "@/components/clinics/clinic_toolbar";
import AddClinicModal from "@/components/clinics/add_clinic_modal";
import DeleteClinicModal from "@/components/clinics/delete_clinic_modal";
import DeleteSuccessModal from "@/components/clinics/delete_success_modal";
import EmptyState from "@/components/clinics/empty_state";
import ErrorState from "@/components/clinics/error_state";
import LoadingState from "@/components/clinics/loading_state";
import Pagination from "@/components/clinics/pagination";
import {
  getClinics,
  saveClinics,
  initializeClinics,
} from "@/services/clinic.service";

export default function ClinicsPage() {
  const [isAddClinicOpen, setIsAddClinicOpen] = useState(false);
  const [isDeleteOpen, setIsDeleteOpen] = useState(false);
  const [isDeleteSuccessOpen, setIsDeleteSuccessOpen] = useState(false);

  const [isLoading, setIsLoading] = useState(true);

  const [selectedClinicId, setSelectedClinicId] = useState<number | null>(null);

  const [clinics, setClinics] = useState(() => getClinics());
  const [search, setSearch] = useState("");
  const [sortOrder, setSortOrder] = useState("default");
  const [currentPage, setCurrentPage] = useState(1);
  const [clinicsPerPage, setClinicsPerPage] = useState(12);

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 100);

    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    initializeClinics();
  }, []);

  useEffect(() => {
    const updateRowsPerPage = () => {
      if (window.innerWidth < 640) {
        setClinicsPerPage(6);
      } else if (window.innerWidth < 1024) {
        setClinicsPerPage(9);
      } else {
        setClinicsPerPage(12);
      }
    };

    updateRowsPerPage();

    window.addEventListener("resize", updateRowsPerPage);

    return () => {
      window.removeEventListener("resize", updateRowsPerPage);
    };
  }, []);

  useEffect(() => {
    setCurrentPage(1);
  }, [search, sortOrder]);

  const handleAddClinic = (newClinic: (typeof clinics)[number]) => {
    setClinics((prev) => {
      const updatedClinics = [...prev, newClinic];

      saveClinics(updatedClinics);

      return updatedClinics;
    });
  };

  const handleDeleteClinic = (clinicId: number) => {
    setClinics((prev) => {
      const updatedClinics = prev.filter((clinic) => clinic.id !== clinicId);

      saveClinics(updatedClinics);

      return updatedClinics;
    });
  };

  const filteredClinics = clinics.filter((clinic) =>
    clinic.name.toLowerCase().includes(search.toLowerCase()),
  );

  let sortedClinics = [...filteredClinics];

  if (sortOrder === "asc") {
    sortedClinics.sort((a, b) => a.name.localeCompare(b.name));
  } else if (sortOrder === "desc") {
    sortedClinics.sort((a, b) => b.name.localeCompare(a.name));
  } else if (sortOrder === "newest") {
    sortedClinics.sort((a, b) => b.id - a.id);
  } else if (sortOrder === "oldest") {
    sortedClinics.sort((a, b) => a.id - b.id);
  } else if (sortOrder === "status") {
    sortedClinics.sort((a, b) => a.status.localeCompare(b.status));
  }

  const totalPages = Math.ceil(sortedClinics.length / clinicsPerPage);

  const startIndex = (currentPage - 1) * clinicsPerPage;
  const endIndex = startIndex + clinicsPerPage;

  const currentClinics = sortedClinics.slice(startIndex, endIndex);

  const handleOpenDeleteModal = (clinicId: number) => {
    setSelectedClinicId(clinicId);
    setIsDeleteOpen(true);
  };

  return (
    <DashboardLayout>
      <div className="overflow-x-hidden p-4 sm:p-5 lg:p-6">
        <ClinicHeader />

        <div className="mt-6 lg:mt-8">
          <ClinicToolbar
            onAddClinic={() => setIsAddClinicOpen(true)}
            search={search}
            onSearchChange={setSearch}
            sortOrder={sortOrder}
            onSortChange={setSortOrder}
          />

          {isLoading ? (
            <LoadingState />
          ) : clinics.length === 0 ? (
            <EmptyState />
          ) : filteredClinics.length > 0 ? (
            <ClinicTable
              clinics={currentClinics}
              onDeleteClinic={handleOpenDeleteModal}
            />
          ) : (
            <ErrorState />
          )}

          {totalPages > 1 && (
            <Pagination
              currentPage={currentPage}
              totalPages={totalPages}
              onPageChange={setCurrentPage}
            />
          )}

          <AddClinicModal
            isOpen={isAddClinicOpen}
            onClose={() => setIsAddClinicOpen(false)}
            onAddClinic={handleAddClinic}
          />

          <DeleteClinicModal
            isOpen={isDeleteOpen}
            onClose={() => {
              setIsDeleteOpen(false);
              setSelectedClinicId(null);
            }}
            onDelete={() => {
              if (selectedClinicId !== null) {
                handleDeleteClinic(selectedClinicId);
              }

              setIsDeleteOpen(false);
              setSelectedClinicId(null);

              setIsDeleteSuccessOpen(true);
            }}
          />

          <DeleteSuccessModal
            isOpen={isDeleteSuccessOpen}
            onClose={() => setIsDeleteSuccessOpen(false)}
          />
        </div>
      </div>
    </DashboardLayout>
  );
}
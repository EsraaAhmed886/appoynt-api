/*
 * File Name: page.tsx
 * Author: Shimaa Salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.1
 * Dependencies:
 *   - react
 *   - next
 *   - lucide-react
 *   - @/components/layout/dashboard_layout
 *   - @/components/clinics/*
 *   - @/services/clinic.service
 * Last Modified Date: [Shimaa Salah - 28/07/2026]
 * File Description:
 *   Clinics Management page for managing doctor clinics,
 *   including clinic listing, searching, sorting, adding,
 *   deleting clinics, pagination, and related modal states.
 */

"use client";

import { useEffect, useState } from "react";
import DashboardLayout from "@/components/layout/dashboard_layout";
import ClinicTable from "@/components/clinics/clinic_table";
import ClinicToolbar from "@/components/clinics/clinic_toolbar";
import AddClinicModal from "@/components/clinics/add_clinic_modal";
import DeleteClinicModal from "@/components/common/confirm_dialog";
import DeleteSuccessModal from "@/components/common/delete_success_modal";
import EmptyState from "@/components/common/empty_state";
import ErrorState from "@/components/common/error_state";
import LoadingState from "@/components/common/loading_state";
import Pagination from "@/components/common/pagination";
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

  const [clinics, setClinics] = useState<ReturnType<typeof getClinics>>([]);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("All");
  const [sortOrder, setSortOrder] = useState("default");
  const [currentPage, setCurrentPage] = useState(1);
  const [clinicsPerPage, setClinicsPerPage] = useState(12);

  useEffect(() => {
    initializeClinics();
    setClinics(getClinics());

    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 100);

    return () => clearTimeout(timer);
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

  const filteredClinics = clinics.filter((clinic) => {
    const searchValue = search.trim().toLowerCase();
    const matchesSearch =
      searchValue === "" || clinic.name.toLowerCase().startsWith(searchValue);

    const matchesStatus =
      statusFilter === "All" || clinic.status === statusFilter;

    return matchesSearch && matchesStatus;
  });

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
      <div className=" px-4 sm:px-5 lg:px-6">
        <div className="mt-0">
          <ClinicToolbar
            onAddClinic={() => setIsAddClinicOpen(true)}
            search={search}
            onSearchChange={setSearch}
            statusFilter={statusFilter}
            onStatusFilterChange={setStatusFilter}
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

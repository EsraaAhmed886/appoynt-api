/**

File Name : patients_dashboard.tsx
Author : Shimaa Salah
Created Date : 28/08/2026
Version : v1.0.0
Dependencies :
  - react
  - next/navigation
  - lucide-react
  - @/context/language_context
  - @/hooks/use_patients
  - @/hooks/use_click_outside
  - @/types/patient
  - @/constants/patient_constants
  - @/components/common/dashboard_dropdown
  - @/components/common/pagination
  - @/components/common/search_input
  - @/components/common/loading_state
  - @/components/common/empty_state
  - @/components/common/error_state
  - @/components/patients/patients_table

Contributors : [Shimaa Salah]
Last Modified : Shimaa Salah - 28/08/2026

Description : Interactive patient management dashboard component providing prefix search, patient-specific no-results feedback, reusable DashboardDropdown and ClinicSearch, dynamic pagination, and export capabilities.

*/

"use client";

import React, { useState, useRef } from "react";
import { useRouter } from "next/navigation";
import {
  Download,
  Sparkles,
  AlertTriangle,
  FileSpreadsheet,
} from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { usePatients } from "@/hooks/use_patients";
import { useClickOutside } from "@/hooks/use_click_outside";
import {
  Patient,
  SortField,
  SortOrder,
  ExportFormat,
} from "@/types/patient";
import {
  GENDER_OPTIONS,
  SORT_OPTIONS,
  EXPORT_FORMAT_OPTIONS,
} from "@/constants/patient_constants";
import DashboardDropdown, { DropdownOption } from "@/components/common/dashboard_dropdown";
import Pagination from "@/components/common/pagination";
import ClinicSearch from "@/components/common/search_input";
import LoadingState from "@/components/common/loading_state";
import EmptyState from "@/components/common/empty_state";
import ErrorState from "@/components/common/error_state";
import PatientsTable from "@/components/patients/patients_table";

export default function PatientsDashboard() {
  const router = useRouter();
  const { translations } = useTranslation();

  const {
    patients,
    totalRecords,
    totalPages,
    currentPage,
    pageSize,
    search,
    filters,
    sortField,
    sortOrder,
    uiState,
    errorMessage,
    isExporting,
    handleSearchChange,
    handleFilterChange,
    handleSortChange,
    handlePageChange,
    handlePageSizeChange,
    handleExport,
  } = usePatients();

  const [isExportDropdownOpen, setIsExportDropdownOpen] = useState<boolean>(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const exportDropdownRef = useRef<HTMLDivElement | null>(null);

  // Close Export dropdown menu automatically when user clicks anywhere outside
  useClickOutside(exportDropdownRef, () => {
    if (isExportDropdownOpen) {
      setIsExportDropdownOpen(false);
    } else {
      // Export dropdown is already closed
    }
  });

  const showToast = (message: string) => {
    setToastMessage(message);
    setTimeout(() => {
      setToastMessage(null);
    }, 3500);
  };

  const onExportClick = async (format: ExportFormat) => {
    setIsExportDropdownOpen(false);
    const result = await handleExport(format);
    if (result.success) {
      showToast(translations.toast_export_success);
    } else {
      showToast(result.error || translations.toast_export_no_data);
    }
  };

  const onViewProfile = (patient: Patient) => {
    showToast(`Viewing profile for ${patient.name}`);
  };

  const onViewMedicalRecord = (patient: Patient) => {
    router.push("/medical-record");
  };

  // Convert GENDER_OPTIONS into DropdownOption array for shared DashboardDropdown
  const genderDropdownOptions: DropdownOption[] = GENDER_OPTIONS.map((opt) => ({
    value: opt.value,
    label: (translations[opt.labelKey as keyof typeof translations] as string) || opt.value,
  }));

  // Convert SORT_OPTIONS into DropdownOption array for shared DashboardDropdown
  const sortDropdownOptions: DropdownOption[] = SORT_OPTIONS.map((opt) => ({
    value: `${opt.field}-${opt.order}`,
    label: (translations[opt.labelKey as keyof typeof translations] as string) || opt.labelKey,
  }));

  return (
    <div className="flex flex-col space-y-6 w-full pb-10">
      {/* Toast Alert Banner */}
      {toastMessage ? (
        <div className="fixed top-20 ltr:right-6 rtl:left-6 z-50 flex items-center gap-2 rounded-xl bg-slate-900 text-white px-4 py-3 text-xs font-semibold shadow-2xl dark:bg-slate-100 dark:text-slate-900 transition-all">
          <Sparkles className="h-4 w-4 text-blue-400 dark:text-blue-600" />
          <span>{toastMessage}</span>
        </div>
      ) : null}

      {/* Header Controls Toolbar */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-3 w-full">
        {/* Left Side Controls: Search Input, Gender Filter Select, Sort Dropdown */}
        <div className="flex flex-wrap items-center gap-2.5 flex-1 min-w-0">
          {/* Reusable ClinicSearch with Page-Specific Translated Placeholder */}
          <ClinicSearch
            search={search}
            on_search_change={handleSearchChange}
            placeholder={translations.search_patient_placeholder}
          />

          {/* Reusable Shared DashboardDropdown for Filter with Smooth Arrow Rotation */}
          <DashboardDropdown
            options={genderDropdownOptions}
            value={filters.gender || "All"}
            onChange={(val) => handleFilterChange("gender", val)}
            width="w-36 sm:w-44"
          />

          {/* Reusable Shared DashboardDropdown for Sort with Smooth Arrow Rotation */}
          <DashboardDropdown
            options={sortDropdownOptions}
            value={`${sortField}-${sortOrder}`}
            onChange={(val) => {
              const [field, order] = val.split("-") as [SortField, SortOrder];
              handleSortChange(field, order);
            }}
            width="w-48 sm:w-56"
          />
        </div>

        {/* Right Side: Export Action with Outside-Click Container */}
        <div ref={exportDropdownRef} className="relative shrink-0">
          <button
            type="button"
            onClick={() => setIsExportDropdownOpen(!isExportDropdownOpen)}
            disabled={isExporting}
            className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-blue-600 text-xs font-semibold text-white hover:bg-blue-700 disabled:opacity-50 shadow-xs transition cursor-pointer"
          >
            <Download className="h-4 w-4" />
            <span>{translations.btn_export}</span>
          </button>

          {isExportDropdownOpen ? (
            <div className="absolute z-40 mt-2 w-48 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-[#0E1726] p-1.5 shadow-xl space-y-1 ltr:right-0 rtl:left-0">
              {EXPORT_FORMAT_OPTIONS.map((option) => (
                <button
                  key={option.format}
                  type="button"
                  onClick={() => onExportClick(option.format)}
                  className="flex w-full items-center gap-2.5 rounded-xl px-3 py-2 text-xs font-medium text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition cursor-pointer"
                >
                  <FileSpreadsheet className="h-4 w-4 text-blue-500" />
                  <span>
                    {translations[option.labelKey as keyof typeof translations] || option.format}
                  </span>
                </button>
              ))}
            </div>
          ) : null}
        </div>
      </div>

      {/* Content View Routing based on UIState */}
      {uiState === "LOADING" ? (
        <LoadingState variant="table" rows={6} />
      ) : uiState === "NO_ASSIGNED_PATIENTS" ? (
        <EmptyState />
      ) : uiState === "NO_SEARCH_RESULTS" ? (
        <div className="flex flex-col items-center justify-center p-12 bg-white dark:bg-[#0E1726] rounded-2xl border border-slate-200 dark:border-slate-800 text-center">
          <ErrorState description={translations.no_patients_found_desc} />
        </div>
      ) : uiState === "ERROR" ? (
        <div className="flex flex-col items-center justify-center p-12 bg-white dark:bg-[#0E1726] rounded-2xl border border-slate-200 dark:border-slate-800 text-center space-y-3">
          <AlertTriangle className="h-10 w-10 text-rose-500" />
          <h3 className="text-base font-bold text-slate-900 dark:text-slate-100">
            {translations.error_title}
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400">{errorMessage}</p>
        </div>
      ) : (
        /* Patient Data Table & Dynamic Pagination Container */
        <div className="space-y-4">
          <PatientsTable
            patients={patients}
            totalRecords={totalRecords}
            onViewProfile={onViewProfile}
            onViewMedicalRecord={onViewMedicalRecord}
          />

          <Pagination
            currentPage={currentPage}
            totalPages={totalPages}
            totalRecords={totalRecords}
            limit={pageSize}
            onPageChange={handlePageChange}
            onLimitChange={handlePageSizeChange}
          />
        </div>
      )}
    </div>
  );
}

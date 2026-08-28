/**

File Name : use_patients.ts
Author : Shimaa Salah
Created Date : 28/08/2026
Version : v1.0.0
Dependencies :
  - react
  - @/types/patient
  - @/constants/patient_constants
  - @/services/patient.service

Contributors : [Shimaa Salah]
Last Modified : Shimaa Salah - 28/08/2026
Description : Custom React hook managing reactive patient data state, debounced server-side search, filtering, sorting, pagination clamping, follow-up scheduling, and file export operations.

*/

import { useState, useEffect, useCallback, useRef } from "react";
import {
  Patient,
  PatientFilters,
  SortField,
  SortOrder,
  ExportFormat,
  CreateFollowUpPayload,
} from "@/types/patient";
import {
  MIN_SEARCH_LENGTH,
  DEBOUNCE_DELAY_MS,
  DEFAULT_PAGE_SIZE,
} from "@/constants/patient_constants";
import { patientService } from "@/services/patient.service";

export type UIState =
  | "LOADING"
  | "SUCCESS"
  | "NO_ASSIGNED_PATIENTS"
  | "NO_SEARCH_RESULTS"
  | "ERROR"
  | "UNAUTHORIZED"
  | "PERMISSION_DENIED";

export function usePatients() {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [totalRecords, setTotalRecords] = useState<number>(0);
  const [totalPages, setTotalPages] = useState<number>(1);
  const [currentPage, setCurrentPage] = useState<number>(1);
  const [pageSize, setPageSize] = useState<number>(DEFAULT_PAGE_SIZE);

  const [search, setSearch] = useState<string>("");
  const [debouncedSearch, setDebouncedSearch] = useState<string>("");

  const [filters, setFilters] = useState<PatientFilters>({
    gender: "All",
    status: "All",
    followUpStatus: "All",
  });

  const [sortField, setSortField] = useState<SortField>("lastVisitDate");
  const [sortOrder, setSortOrder] = useState<SortOrder>("desc");

  const [uiState, setUiState] = useState<UIState>("LOADING");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [isExporting, setIsExporting] = useState<boolean>(false);
  const [isSchedulingFollowUp, setIsSchedulingFollowUp] =
    useState<boolean>(false);

  const debounceTimerRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current);
    } else {
      // Timer reference clean
    }

    debounceTimerRef.current = setTimeout(() => {
      if (search.trim().length === 0 || search.trim().length >= MIN_SEARCH_LENGTH) {
        setDebouncedSearch(search.trim());
        setCurrentPage(1);
      } else {
        // Search query length below 2 characters
      }
    }, DEBOUNCE_DELAY_MS);

    return () => {
      if (debounceTimerRef.current) {
        clearTimeout(debounceTimerRef.current);
      } else {
        // No active timer cleanup
      }
    };
  }, [search]);

  const fetchPatients = useCallback(async () => {
    setUiState("LOADING");
    setErrorMessage(null);

    try {
      const response = await patientService.getPatients({
        search: debouncedSearch,
        filters: filters,
        sortField: sortField,
        sortOrder: sortOrder,
        page: currentPage,
        pageSize: pageSize,
      });

      setPatients(response.patients);
      setTotalRecords(response.totalRecords);
      setTotalPages(response.totalPages);

      if (response.currentPage !== currentPage) {
        setCurrentPage(response.currentPage);
      } else {
        // Current page is already in sync with response
      }

      if (response.totalRecords === 0) {
        if (debouncedSearch.length > 0 || hasActiveFilters(filters)) {
          setUiState("NO_SEARCH_RESULTS");
        } else {
          setUiState("NO_ASSIGNED_PATIENTS");
        }
      } else {
        setUiState("SUCCESS");
      }
    } catch (error: unknown) {
      setUiState("ERROR");
      if (error instanceof Error) {
        setErrorMessage(error.message);
      } else {
        setErrorMessage("An unexpected error occurred while fetching patients.");
      }
    }
  }, [debouncedSearch, filters, sortField, sortOrder, currentPage, pageSize]);

  useEffect(() => {
    fetchPatients();
  }, [fetchPatients]);

  const handleSearchChange = (value: string) => {
    setSearch(value);
  };

  const handleFilterChange = (key: keyof PatientFilters, value: string) => {
    setFilters((prev) => ({
      ...prev,
      [key]: value,
    }));
    setCurrentPage(1);
  };

  const handleClearFilters = () => {
    setFilters({
      gender: "All",
      status: "All",
      followUpStatus: "All",
    });
    setSearch("");
    setDebouncedSearch("");
    setCurrentPage(1);
  };

  const handleSortChange = (field: SortField, order: SortOrder) => {
    setSortField(field);
    setSortOrder(order);
    setCurrentPage(1);
  };

  const handlePageChange = (newPage: number) => {
    if (newPage >= 1 && newPage <= totalPages) {
      setCurrentPage(newPage);
    } else {
      // Requested page out of range
    }
  };

  const handlePageSizeChange = (newSize: number) => {
    setPageSize(newSize);
    setCurrentPage(1);
  };

  const handleScheduleFollowUp = async (payload: CreateFollowUpPayload) => {
    setIsSchedulingFollowUp(true);
    try {
      await patientService.createFollowUp(payload);
      await fetchPatients();
      setIsSchedulingFollowUp(false);
      return { success: true };
    } catch (error: unknown) {
      setIsSchedulingFollowUp(false);
      const message: string =
        error instanceof Error ? error.message : "Failed to schedule follow-up.";
      return { success: false, error: message };
    }
  };

  const handleExport = async (format: ExportFormat) => {
    setIsExporting(true);
    try {
      const result = await patientService.exportPatients({
        search: debouncedSearch,
        filters: filters,
        sortField: sortField,
        sortOrder: sortOrder,
        format: format,
      });

      const anchorElement = document.createElement("a");
      anchorElement.href = result.blobUrl;
      anchorElement.download = result.filename;
      document.body.appendChild(anchorElement);
      anchorElement.click();
      document.body.removeChild(anchorElement);

      setIsExporting(false);
      return { success: true };
    } catch (error: unknown) {
      setIsExporting(false);
      const message: string =
        error instanceof Error ? error.message : "Failed to export data.";
      return { success: false, error: message };
    }
  };

  return {
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
    isSchedulingFollowUp,
    handleSearchChange,
    handleFilterChange,
    handleClearFilters,
    handleSortChange,
    handlePageChange,
    handlePageSizeChange,
    handleScheduleFollowUp,
    handleExport,
  };
}

function hasActiveFilters(filters: PatientFilters): boolean {
  const isGenderActive: boolean = filters.gender !== undefined && filters.gender !== "All";
  const isStatusActive: boolean = filters.status !== undefined && filters.status !== "All";
  const isFollowUpActive: boolean =
    filters.followUpStatus !== undefined && filters.followUpStatus !== "All";

  if (isGenderActive || isStatusActive || isFollowUpActive) {
    return true;
  } else {
    return false;
  }
}

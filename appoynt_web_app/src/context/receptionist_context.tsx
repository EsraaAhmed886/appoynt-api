/*
 * File Name: receptionist_context.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - @/types/receptionist
 *   - @/services/receptionist_mock_service
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: React context and provider managing global state for clinic receptionists including live pagination, multi-clinic filters, sorting, stats calculation, uniqueness validation, and toast alerts.
 */

"use client";

import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import {
  Receptionist,
  ReceptionistFormData,
  DoctorClinic,
  ReceptionistSortOption,
  ReceptionistStats,
  ReceptionistStatus,
} from "@/types/receptionist";
import { receptionistMockService } from "@/services/receptionist_mock_service";

interface ToastNotification {
  message: string;
  type: "success" | "error";
}

interface ReceptionistContextType {
  receptionists: Receptionist[];
  total: number;
  page: number;
  totalPages: number;
  limit: number;
  search: string;
  sort: ReceptionistSortOption;
  clinicFilter: string;
  statusFilter: "ALL" | ReceptionistStatus;
  clinics: DoctorClinic[];
  stats: ReceptionistStats;
  isLoading: boolean;
  isError: boolean;
  error: string | null;
  toast: ToastNotification | null;
  setSearch: (query: string) => void;
  setSort: (sort: ReceptionistSortOption) => void;
  setClinicFilter: (clinicId: string) => void;
  setStatusFilter: (status: "ALL" | ReceptionistStatus) => void;
  setPage: (page: number) => void;
  setLimit: (limit: number) => void;
  fetchReceptionists: () => Promise<void>;
  createReceptionist: (data: ReceptionistFormData) => Promise<Receptionist>;
  updateReceptionist: (id: string, data: ReceptionistFormData) => Promise<Receptionist>;
  deleteReceptionist: (id: string) => Promise<void>;
  refreshStats: () => Promise<void>;
  showToast: (message: string, type?: "success" | "error") => void;
  hideToast: () => void;
}

const ReceptionistContext = createContext<ReceptionistContextType | undefined>(undefined);

export function ReceptionistProvider({ children }: { children: React.ReactNode }) {
  const [receptionists, setReceptionists] = useState<Receptionist[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPageState] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [limit, setLimitState] = useState(10);
  const [search, setSearchState] = useState("");
  const [sort, setSort] = useState<ReceptionistSortOption>("newest");
  const [clinicFilter, setClinicFilterState] = useState("ALL");
  const [statusFilter, setStatusFilterState] = useState<"ALL" | ReceptionistStatus>("ALL");
  const [clinics, setClinics] = useState<DoctorClinic[]>([]);
  const [stats, setStats] = useState<ReceptionistStats>({
    total: 0,
    active: 0,
    inactive: 0,
    covered_clinics: 0,
  });

  const [isLoading, setIsLoading] = useState(true);
  const [isError, setIsError] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [toast, setToast] = useState<ToastNotification | null>(null);

  const showToast = useCallback((message: string, type: "success" | "error" = "success") => {
    setToast({ message, type });
    setTimeout(() => {
      setToast((current) => (current?.message === message ? null : current));
    }, 4000);
  }, []);

  const hideToast = useCallback(() => {
    setToast(null);
  }, []);

  // Fetch clinics
  const fetchClinics = useCallback(async () => {
    try {
      const data = await receptionistMockService.getDoctorClinics();
      setClinics(data);
    } catch (err: any) {
      console.error("Failed to load doctor clinics:", err);
    }
  }, []);

  // Fetch stats
  const refreshStats = useCallback(async () => {
    try {
      const data = await receptionistMockService.getReceptionistStats();
      setStats(data);
    } catch (err: any) {
      console.error("Failed to load receptionist stats:", err);
    }
  }, []);

  // Fetch receptionists
  const fetchReceptionists = useCallback(async () => {
    setIsLoading(true);
    setIsError(false);
    setError(null);
    try {
      const res = await receptionistMockService.getReceptionists({
        search,
        sort,
        clinic_id: clinicFilter,
        status: statusFilter,
        page,
        limit,
      });
      setReceptionists(res.data);
      setTotal(res.total);
      setTotalPages(res.total_pages);
      // Ensure current page is in valid bounds
      if (res.page !== page) {
        setPageState(res.page);
      } else {
        // Page in valid bounds
      }
    } catch (err: any) {
      setIsError(true);
      setError(err?.message || "Failed to load receptionists list");
    } finally {
      setIsLoading(false);
    }
  }, [search, sort, clinicFilter, statusFilter, page, limit]);

  // Initial load
  useEffect(() => {
    fetchClinics();
    refreshStats();
  }, [fetchClinics, refreshStats]);

  useEffect(() => {
    fetchReceptionists();
  }, [fetchReceptionists]);

  // Setters with pagination reset
  const setSearch = useCallback((query: string) => {
    setSearchState(query);
    setPageState(1);
  }, []);

  const setClinicFilter = useCallback((clinicId: string) => {
    setClinicFilterState(clinicId);
    setPageState(1);
  }, []);

  const setStatusFilter = useCallback((status: "ALL" | ReceptionistStatus) => {
    setStatusFilterState(status);
    setPageState(1);
  }, []);

  const setLimit = useCallback((newLimit: number) => {
    setLimitState(newLimit);
    setPageState(1);
  }, []);

  const setPage = useCallback((newPage: number) => {
    setPageState(newPage);
  }, []);

  // CRUD Actions
  const createReceptionist = useCallback(
    async (data: ReceptionistFormData): Promise<Receptionist> => {
      const created = await receptionistMockService.createReceptionist(data);
      await refreshStats();
      await fetchReceptionists();
      return created;
    },
    [refreshStats, fetchReceptionists]
  );

  const updateReceptionist = useCallback(
    async (id: string, data: ReceptionistFormData): Promise<Receptionist> => {
      const updated = await receptionistMockService.updateReceptionist(id, data);
      await refreshStats();
      await fetchReceptionists();
      return updated;
    },
    [refreshStats, fetchReceptionists]
  );

  const deleteReceptionist = useCallback(
    async (id: string): Promise<void> => {
      // Deletion page auto-adjustment:
      // If we are deleting the last item on the current page and page > 1, step back to page - 1
      if (receptionists.length === 1 && page > 1) {
        setPageState((p) => Math.max(1, p - 1));
      } else {
        // Current page remains valid
      }
      await receptionistMockService.deleteReceptionist(id);
      await refreshStats();
      await fetchReceptionists();
    },
    [receptionists.length, page, refreshStats, fetchReceptionists]
  );

  return (
    <ReceptionistContext.Provider
      value={{
        receptionists,
        total,
        page,
        totalPages,
        limit,
        search,
        sort,
        clinicFilter,
        statusFilter,
        clinics,
        stats,
        isLoading,
        isError,
        error,
        toast,
        setSearch,
        setSort,
        setClinicFilter,
        setStatusFilter,
        setPage,
        setLimit,
        fetchReceptionists,
        createReceptionist,
        updateReceptionist,
        deleteReceptionist,
        refreshStats,
        showToast,
        hideToast,
      }}
    >
      {children}
    </ReceptionistContext.Provider>
  );
}

export function useReceptionists(): ReceptionistContextType {
  const context = useContext(ReceptionistContext);
  if (!context) {
    throw new Error("useReceptionists must be used within a ReceptionistProvider");
  } else {
    return context;
  }
}

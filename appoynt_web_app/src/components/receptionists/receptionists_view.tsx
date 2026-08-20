/*
 * File Name: receptionists_view.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - next/link
 *   - lucide-react
 *   - @/types/receptionist
 *   - @/context/receptionist_context
 *   - @/context/language_context
 *   - @/components/receptionists/receptionist_stats_strip
 *   - @/components/receptionists/receptionist_filter_bar
 *   - @/components/receptionists/receptionist_table
 *   - @/components/receptionists/states/no_clinics_state
 *   - @/components/receptionists/states/empty_receptionists_state
 *   - @/components/receptionists/states/no_search_results_state
 *   - @/components/receptionists/states/receptionist_error_state
 *   - @/components/receptionists/states/receptionist_table_skeleton
 *   - @/components/receptionists/modals/add_receptionist_modal
 *   - @/components/receptionists/modals/edit_receptionist_modal
 *   - @/components/receptionists/modals/delete_receptionist_modal
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Top-level clinic receptionists workspace view combining header breadcrumbs, KPI statistics strip, smart filter controls, responsive tables, modal orchestration, and accessible state fallbacks.
 */

"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  ChevronRight,
  Plus,
  Users,
  CheckCircle2,
  AlertCircle,
  X,
  Building2,
} from "lucide-react";
import { Receptionist } from "@/types/receptionist";
import { useReceptionists } from "@/context/receptionist_context";
import { useTranslation } from "@/context/language_context";
import ReceptionistStatsStrip from "@/components/receptionists/receptionist_stats_strip";
import ReceptionistFilterBar from "@/components/receptionists/receptionist_filter_bar";
import ReceptionistTable from "@/components/receptionists/receptionist_table";
import NoClinicsState from "@/components/receptionists/states/no_clinics_state";
import EmptyReceptionistsState from "@/components/receptionists/states/empty_receptionists_state";
import NoSearchResultsState from "@/components/receptionists/states/no_search_results_state";
import ReceptionistErrorState from "@/components/receptionists/states/receptionist_error_state";
import ReceptionistTableSkeleton from "@/components/receptionists/states/receptionist_table_skeleton";
import AddReceptionistModal from "@/components/receptionists/modals/add_receptionist_modal";
import EditReceptionistModal from "@/components/receptionists/modals/edit_receptionist_modal";
import DeleteReceptionistModal from "@/components/receptionists/modals/delete_receptionist_modal";

export default function ReceptionistsView() {
  const {
    receptionists,
    total,
    search,
    setSearch,
    clinicFilter,
    setClinicFilter,
    clinics,
    isLoading,
    isError,
    error,
    toast,
    hideToast,
    fetchReceptionists,
  } = useReceptionists();
  const { translations } = useTranslation();

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [selectedForEdit, setSelectedForEdit] = useState<Receptionist | null>(null);
  const [selectedForDelete, setSelectedForDelete] = useState<Receptionist | null>(null);

  const hasNoClinics = clinics.length === 0;

  return (
    <div className="w-full space-y-6 animate-in fade-in duration-200 text-start pb-12">
      {/* Toast Notification Alert */}
      {toast && (
        <div
          className={`fixed bottom-6 end-6 z-50 flex items-center gap-3 px-4 py-3 rounded-2xl shadow-2xl border-2 animate-in slide-in-from-bottom duration-200 ${
            toast.type === "success"
              ? "bg-emerald-50 dark:bg-emerald-950 border-emerald-300 dark:border-emerald-800 text-emerald-900 dark:text-emerald-100"
              : "bg-red-50 dark:bg-red-950 border-red-300 dark:border-red-800 text-red-900 dark:text-red-100"
          }`}
        >
          {toast.type === "success" ? (
            <CheckCircle2 className="w-5 h-5 text-emerald-600 dark:text-emerald-400 shrink-0" />
          ) : (
            <AlertCircle className="w-5 h-5 text-red-600 dark:text-red-400 shrink-0" />
          )}
          <span className="text-xs md:text-sm font-bold">{toast.message}</span>
          <button
            type="button"
            onClick={hideToast}
            className="p-1 hover:opacity-75 transition cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* 1. Page Header & Actions */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          {/* Breadcrumb */}
          <nav className="flex items-center gap-1.5 text-xs font-semibold text-slate-500 dark:text-slate-400 mb-2">
            <Link
              href="/clinics"
              className="hover:text-slate-900 dark:hover:text-white transition"
            >
              {translations.clinics || "Clinics"}
            </Link>
            <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400" />
            <span className="text-blue-600 dark:text-blue-400 font-bold">
              {translations.receptionists || "Receptionists"}
            </span>
          </nav>

          <h1 className="text-xl md:text-2xl font-extrabold text-slate-900 dark:text-white tracking-tight">
            {translations.receptionists_management || "Receptionists Management"}
          </h1>
          <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1 max-w-2xl">
            {translations.receptionists_subtitle ||
              "Manage receptionist accounts, multi-clinic assignments, and appointment booking credentials."}
          </p>
        </div>

        {/* Add Receptionist Button */}
        <div>
          <button
            type="button"
            disabled={hasNoClinics}
            onClick={() => setIsAddModalOpen(true)}
            title={
              hasNoClinics
                ? (translations.no_clinics_desc || "You must create at least one clinic before adding receptionist accounts.")
                : undefined
            }
            className="inline-flex items-center gap-2 px-5 py-2.5 bg-blue-600 hover:bg-blue-700 disabled:bg-slate-300 dark:disabled:bg-slate-800 disabled:text-slate-500 disabled:cursor-not-allowed text-white text-xs md:text-sm font-bold rounded-xl shadow-md transition cursor-pointer shrink-0"
          >
            <Plus className="w-4 h-4" />
            <span>{translations.add_receptionist || "Add Receptionist"}</span>
          </button>
        </div>
      </div>

      {/* 2. Top KPI Stats Strip */}
      <ReceptionistStatsStrip />

      {/* 3. Main Body & Viewport States */}
      {isLoading ? (
        <div className="space-y-4">
          <ReceptionistFilterBar />
          <ReceptionistTableSkeleton />
        </div>
      ) : isError ? (
        <ReceptionistErrorState message={error} onRetry={fetchReceptionists} />
      ) : hasNoClinics ? (
        <NoClinicsState />
      ) : total === 0 && search.trim().length === 0 && clinicFilter === "ALL" ? (
        <EmptyReceptionistsState onAddClick={() => setIsAddModalOpen(true)} />
      ) : total === 0 && (search.trim().length > 0 || clinicFilter !== "ALL") ? (
        <div className="space-y-4">
          <ReceptionistFilterBar />
          <NoSearchResultsState
            query={search}
            onClear={() => {
              setSearch("");
              setClinicFilter("ALL");
            }}
          />
        </div>
      ) : (
        <div className="space-y-4">
          <ReceptionistFilterBar />
          <ReceptionistTable
            onEdit={(rec) => setSelectedForEdit(rec)}
            onDelete={(rec) => setSelectedForDelete(rec)}
          />
        </div>
      )}

      {/* Add Receptionist Modal */}
      <AddReceptionistModal
        isOpen={isAddModalOpen}
        onClose={() => setIsAddModalOpen(false)}
      />

      {/* Edit Receptionist Modal */}
      <EditReceptionistModal
        receptionist={selectedForEdit}
        isOpen={Boolean(selectedForEdit)}
        onClose={() => setSelectedForEdit(null)}
      />

      {/* Delete Receptionist Modal */}
      <DeleteReceptionistModal
        receptionist={selectedForDelete}
        isOpen={Boolean(selectedForDelete)}
        onClose={() => setSelectedForDelete(null)}
      />
    </div>
  );
}

/*
 * File Name: medical_history_tab.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/hooks/use_medical_record
 *   - @/components/medical_record/filters/medical_history_filter
 *   - @/components/medical_record/tables/medical_history_table
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Tab 2 Patient Medical History management component providing metric count cards, modern multi-facet filtering bar, and refined historical records table with strict text wrapping bounds.
 */

"use client";

import React from "react";
import { History } from "lucide-react";
import { useMedicalHistoryQuery } from "@/hooks/use_medical_record";
import MedicalHistoryFilter from "@/components/medical_record/filters/medical_history_filter";
import MedicalHistoryTable from "@/components/medical_record/tables/medical_history_table";
import { useTranslation } from "@/context/language_context";

interface MedicalHistoryTabProps {
  patientId: string;
  onViewRecordDetail: (recordId: string) => void;
}

export default function MedicalHistoryTab({
  patientId,
  onViewRecordDetail,
}: MedicalHistoryTabProps) {
  const { translations } = useTranslation();
  const {
    historyItems,
    total,
    totalPages,
    page,
    setPage,
    filters,
    setFilters,
    isLoading,
  } = useMedicalHistoryQuery(patientId, 1);

  const handleResetFilters = () => {
    setFilters({
      searchQuery: "",
      status: "ALL",
      doctor: "ALL",
    });
    setPage(1);
  };

  const latestRecord = historyItems.length > 0 ? historyItems[0] : null;

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      {/* Top 2 Metric Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 md:gap-6">
        {/* Card 1: Total Records Metric */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 md:p-6 shadow-xs flex items-center gap-4 md:gap-5">
          <div className="p-3.5 md:p-4 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-2xl shrink-0">
            <History className="w-6 h-6 md:w-7 md:h-7" />
          </div>
          <div className="text-start">
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
              {translations.total_records || "Total Records"}
            </p>
            <p className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white mt-1">
              {total}
            </p>
          </div>
        </div>

        {/* Card 2: Latest Record Preview */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 md:p-6 shadow-xs flex items-center justify-between gap-4">
          <div className="space-y-1 overflow-hidden text-start">
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
              {translations.latest_record || "Latest Recorded Visit"}
            </p>
            <p className="text-sm md:text-base font-bold text-slate-900 dark:text-white truncate">
              {latestRecord ? latestRecord.primaryDiagnosisName : (translations.no_history_found || "No Medical Records Found")}
            </p>
            <p className="text-xs text-slate-500 dark:text-slate-400 truncate">
              {latestRecord
                ? `${translations.visit_date || "Visit Date"}: ${latestRecord.visitDate} • ${latestRecord.doctorName}`
                : "—"}
            </p>
          </div>
          {latestRecord && (
            <button
              type="button"
              onClick={() => onViewRecordDetail(latestRecord.recordId)}
              className="px-4 py-2.5 text-xs font-bold text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-950/60 hover:bg-blue-100 dark:hover:bg-blue-900/40 rounded-xl transition shrink-0 border border-blue-200/80 dark:border-blue-800/60 cursor-pointer"
            >
              {translations.view_latest || "View Latest"}
            </button>
          )}
        </div>
      </div>

      {/* Modern Filter Bar */}
      <MedicalHistoryFilter
        filters={{
          searchQuery: filters.searchQuery || "",
          status: filters.status || "ALL",
          doctor: filters.doctor || "ALL",
        }}
        onFilterChange={(newFilters) => {
          setFilters(newFilters);
          setPage(1);
        }}
        onReset={handleResetFilters}
      />

      {/* Paginated Medical History Table */}
      <MedicalHistoryTable
        items={historyItems}
        isLoading={isLoading}
        onViewRecordDetail={onViewRecordDetail}
        onResetFilters={handleResetFilters}
        page={page}
        totalPages={totalPages}
        total={total}
        onPageChange={(newPage) => setPage(newPage)}
      />
    </div>
  );
}

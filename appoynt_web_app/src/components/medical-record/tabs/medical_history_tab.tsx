/*
 * File Name: medical_history_tab.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/hooks/use_medical_record
 *   - @/components/ui/custom_select_dropdown
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Comprehensive Patient Medical History tab component featuring audit metrics, multi-facet filter bar (date range, status, doctor, type), paginated historical records table with whitespace-nowrap dates, and empty state.
 */

"use client";

import React, { useState, useMemo } from "react";
import {
  History,
  Calendar,
  Search,
  Filter,
  RotateCcw,
  Eye,
  FolderOpen,
  ChevronLeft,
  ChevronRight,
  FileCheck,
  User,
  CheckCircle2,
  Clock,
  ArrowRight,
} from "lucide-react";
import { useMedicalHistoryQuery } from "@/hooks/use_medical_record";
import CustomSelectDropdown, { DropdownOption } from "@/components/ui/custom_select_dropdown";
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
  const [dateRange, setDateRange] = useState("");
  const [recordType, setRecordType] = useState("ALL");

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
    setDateRange("");
    setRecordType("ALL");
    setPage(1);
  };

  const statusOptions: DropdownOption[] = [
    { value: "ALL", label: translations.filter_all_status || "All Record Statuses" },
    { value: "FINALIZED", label: translations.finalized || "Finalized" },
    { value: "FINALIZED_WITH_AMENDMENTS", label: translations.finalized_with_amendments || "Finalized with Amendments" },
    { value: "DRAFT", label: translations.draft || "Draft" },
  ];

  const doctorOptions: DropdownOption[] = [
    { value: "ALL", label: translations.filter_all_doctors || "All Attending Doctors" },
    { value: "Dr. Nada Khan", label: "Dr. Nada Khan" },
    { value: "Dr. Tarek Youssef", label: "Dr. Tarek Youssef" },
    { value: "Dr. Mona Fikry", label: "Dr. Mona Fikry" },
    { value: "Dr. Karim Samy", label: "Dr. Karim Samy" },
  ];

  const recordTypeOptions: DropdownOption[] = [
    { value: "ALL", label: "All Record Types" },
    { value: "CONSULTATION", label: "General Consultation" },
    { value: "CARDIOLOGY", label: "Cardiology Review" },
    { value: "FOLLOW_UP", label: "Routine Follow-up" },
  ];

  const latestRecord = historyItems.length > 0 ? historyItems[0] : null;

  return (
    <div className="space-y-6 animate-in fade-in duration-200 text-start">
      {/* 1. Top Stat Cards Row */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-5">
        {/* Card 1: Total Records Count */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs flex items-center gap-4">
          <div className="p-3.5 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-2xl border border-blue-200 dark:border-blue-800 shrink-0">
            <History className="w-7 h-7" />
          </div>
          <div>
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
              {translations.total_records || "Total Medical Records"}
            </p>
            <div className="flex items-baseline gap-2 mt-1">
              <span className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white">
                {total}
              </span>
              <span className="text-xs text-emerald-600 dark:text-emerald-400 font-bold">
                • {translations.finalized_records_label || "Finalized Records"}
              </span>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs flex items-center justify-between gap-4">
          <div className="space-y-1 min-w-0">
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
              {translations.latest_record || "Latest Finalized Record"}
            </p>
            <h4 className="text-sm md:text-base font-bold text-slate-900 dark:text-white truncate">
              {latestRecord ? latestRecord.primaryDiagnosisTitle : (translations.no_history_found || "No History Records Found")}
            </h4>
            <p className="text-xs text-slate-500 dark:text-slate-400 truncate">
              {latestRecord
                ? `${latestRecord.visitDate} • ${latestRecord.doctorName}`
                : "—"}
            </p>
          </div>

          {latestRecord && (
            <button
              type="button"
              onClick={() => onViewRecordDetail(latestRecord.recordId)}
              className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-xs transition flex items-center gap-1.5 shrink-0 cursor-pointer"
            >
              <span>{translations.view_latest || "View"}</span>
              <ArrowRight className="w-3.5 h-3.5 rtl:rotate-180" />
            </button>
          )}
        </div>
      </div>

      {/* 2. Comprehensive Multi-Facet Filter Bar */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 text-xs font-bold text-slate-900 dark:text-white uppercase tracking-wider">
            <Filter className="w-4 h-4 text-blue-600 dark:text-blue-400" />
            <span>{translations.filter_record_status || "Filter Medical History"}</span>
          </div>

          <button
            type="button"
            onClick={handleResetFilters}
            className="text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-slate-200 inline-flex items-center gap-1 cursor-pointer transition"
          >
            <RotateCcw className="w-3.5 h-3.5" />
            <span>{translations.reset || "Reset Filters"}</span>
          </button>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3.5">
          <div className="relative">
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
              {translations.search || "Search Diagnosis"}
            </label>
            <div className="relative">
              <Search className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input
                type="text"
                value={filters.searchQuery || ""}
                onChange={(e) =>
                  setFilters({ ...filters, searchQuery: e.target.value })
                }
                placeholder={translations.search_diagnosis_placeholder || "Search diagnosis code or name..."}
                className="w-full ps-10 pe-4 h-11 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 placeholder-slate-400 focus:outline-none focus:border-blue-500 transition"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
              {translations.date || "Date Range"}
            </label>
            <div className="relative">
              <Calendar className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400 pointer-events-none" />
              <input
                type="date"
                value={dateRange}
                onChange={(e) => setDateRange(e.target.value)}
                className="w-full ps-10 pe-4 h-11 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500 transition cursor-pointer"
              />
            </div>
          </div>

          <CustomSelectDropdown
            label={translations.filter_record_status || "Record Status"}
            options={statusOptions}
            value={filters.status || "ALL"}
            onChange={(val) => setFilters({ ...filters, status: val })}
            searchable={false}
          />

          <CustomSelectDropdown
            label={translations.doctor || "Attending Doctor"}
            options={doctorOptions}
            value={filters.doctor || "ALL"}
            onChange={(val) => setFilters({ ...filters, doctor: val })}
            searchable={false}
          />
        </div>
      </div>

      {/* 3. Paginated Records Table */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs overflow-hidden">
        {historyItems.length > 0 ? (
          <div>
            <div className="overflow-x-auto">
              <table className="w-full text-xs text-slate-700 dark:text-slate-200 text-start">
                <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 uppercase text-[11px] font-bold text-slate-500 dark:text-slate-400">
                  <tr>
                    <th className="py-3 px-4 font-bold">{translations.col_date || "Date & Time"}</th>
                    <th className="py-3 px-4 font-bold">{translations.col_diagnosis || "Primary Diagnosis"}</th>
                    <th className="py-3 px-4 font-bold">{translations.col_doctor || "Attending Doctor"}</th>
                    <th className="py-3 px-4 font-bold">{translations.status || "Status"}</th>
                    <th className="py-3 px-4 font-bold text-end">{translations.col_actions || "Actions"}</th>
                  </tr>
                </thead>
                <tbody className="divide-y-2 divide-slate-100 dark:divide-slate-800/80">
                  {historyItems.map((item) => (
                    <tr
                      key={item.recordId}
                      className="hover:bg-slate-50 dark:hover:bg-[#131E35] transition"
                    >
                      <td className="py-3.5 px-4 font-mono font-medium text-slate-900 dark:text-white">
                        {item.visitDate}
                      </td>
                      <td className="py-3.5 px-4">
                        <div className="flex items-center gap-2">
                          <span className="font-mono text-[11px] font-bold text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-950/60 px-2 py-0.5 rounded border border-blue-200 dark:border-blue-800">
                            {item.primaryDiagnosisCode}
                          </span>
                          <span className="font-bold text-slate-900 dark:text-white truncate">
                            {item.primaryDiagnosisTitle}
                          </span>
                        </div>
                      </td>
                      <td className="py-3.5 px-4 font-medium text-slate-700 dark:text-slate-300">
                        {item.doctorName}
                      </td>
                      <td className="py-3.5 px-4">
                        {item.status === "Finalized" ? (
                          <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
                            <CheckCircle2 className="w-3.5 h-3.5" />
                            <span>{translations.finalized || "Finalized"}</span>
                          </span>
                        ) : (
                          <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-50 dark:bg-amber-950/60 text-amber-700 dark:text-amber-300 border border-amber-200 dark:border-amber-800">
                            <Clock className="w-3.5 h-3.5" />
                            <span>{translations.draft || "Draft"}</span>
                          </span>
                        )}
                      </td>
                      <td className="py-3.5 px-4 text-end">
                        <button
                          type="button"
                          onClick={() => onViewRecordDetail(item.recordId)}
                          className="px-3 py-1.5 text-xs font-bold text-blue-600 dark:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-950/60 rounded-lg transition inline-flex items-center gap-1 cursor-pointer"
                        >
                          <Eye className="w-3.5 h-3.5" />
                          <span>{translations.view || "View Record"}</span>
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="flex items-center justify-between p-4 bg-slate-50 dark:bg-[#131E35] border-t-2 border-slate-200 dark:border-slate-800 text-xs font-medium">
              <span className="text-slate-500 dark:text-slate-400">
                {(translations.showing_records_count || "Showing {from} to {to} of {total} records")
                  .replace("{from}", String(((page - 1) * 10) + 1))
                  .replace("{to}", String(Math.min(page * 10, total)))
                  .replace("{total}", String(total))}
              </span>

              <div className="flex items-center gap-2">
                <button
                  type="button"
                  disabled={page <= 1}
                  onClick={() => setPage(page - 1)}
                  className="p-2 border-2 border-slate-200 dark:border-slate-700 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 disabled:opacity-40 transition cursor-pointer"
                >
                  <ChevronLeft className="w-4 h-4 rtl:rotate-180" />
                </button>
                <span className="px-3 py-1 text-xs font-bold text-slate-800 dark:text-slate-200">
                  {(translations.page_indicator || "Page {current} of {total}")
                    .replace("{current}", String(page))
                    .replace("{total}", String(Math.max(1, totalPages)))}
                </span>
                <button
                  type="button"
                  disabled={page >= totalPages}
                  onClick={() => setPage(page + 1)}
                  className="p-2 border-2 border-slate-200 dark:border-slate-700 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 disabled:opacity-40 transition cursor-pointer"
                >
                  <ChevronRight className="w-4 h-4 rtl:rotate-180" />
                </button>
              </div>
            </div>
          </div>
        ) : (
          <div className="p-16 text-center space-y-3">
            <div className="w-14 h-14 bg-slate-100 dark:bg-slate-800 text-slate-400 rounded-full flex items-center justify-center mx-auto">
              <FolderOpen className="w-7 h-7" />
            </div>
            <h3 className="text-sm font-bold text-slate-900 dark:text-white">
              {translations.no_history_found || "No Medical Records Found"}
            </h3>
            <p className="text-xs text-slate-500 dark:text-slate-400 max-w-sm mx-auto">
              {translations.no_history_desc || "No previous encounters matched the specified filters. Try adjusting your query or date range."}
            </p>
            <button
              type="button"
              onClick={handleResetFilters}
              className="px-4 py-2 text-xs font-bold text-blue-600 dark:text-blue-400 hover:underline cursor-pointer"
            >
              {translations.reset_filters || translations.reset || "Clear all filters"}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

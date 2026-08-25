/*
 * File Name: medical_history_table.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/components/medical_record/badges/record_status_badge
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Production historical medical consultation table component with strict whitespace-nowrap date/status constraints, interactive view triggers, and pagination navigation.
 */

"use client";

import React from "react";
import { Eye, FileText, ChevronLeft, ChevronRight } from "lucide-react";
import { MedicalHistoryItem } from "@/types/medical_record";
import RecordStatusBadge from "@/components/medical_record/badges/record_status_badge";
import { useTranslation } from "@/context/language_context";

interface MedicalHistoryTableProps {
  items: MedicalHistoryItem[];
  isLoading?: boolean;
  onViewRecordDetail: (recordId: string) => void;
  onResetFilters?: () => void;
  page?: number;
  totalPages?: number;
  total?: number;
  onPageChange?: (newPage: number) => void;
  className?: string;
}

export default function MedicalHistoryTable({
  items,
  isLoading = false,
  onViewRecordDetail,
  onResetFilters,
  page = 1,
  totalPages = 1,
  total = 0,
  onPageChange,
  className = "",
}: MedicalHistoryTableProps) {
  const { translations } = useTranslation();

  return (
    <div
      className={`bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl overflow-hidden shadow-xs ${className}`}
    >
      {isLoading ? (
        <div className="p-12 text-center text-xs text-slate-400">
          <div className="w-8 h-8 border-3 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-2" />
          <span>Loading records...</span>
        </div>
      ) : items.length === 0 ? (
        /* Empty State */
        <div className="p-12 text-center space-y-3">
          <div className="w-16 h-16 mx-auto bg-slate-100 dark:bg-slate-800 rounded-full flex items-center justify-center text-slate-400">
            <FileText className="w-8 h-8" />
          </div>
          <div className="space-y-1">
            <h3 className="text-base font-bold text-slate-900 dark:text-white">
              {translations.no_history_found || "No Medical Records Found"}
            </h3>
            <p className="text-sm text-slate-500 dark:text-slate-400 max-w-sm mx-auto">
              {translations.no_history_desc || "No archived consultations match the active filter criteria."}
            </p>
          </div>
          {onResetFilters && (
            <button
              type="button"
              onClick={onResetFilters}
              className="px-5 py-2.5 text-xs font-bold text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-950/60 hover:bg-blue-100 dark:hover:bg-blue-900/40 rounded-xl border border-blue-200/80 dark:border-blue-800/60 transition cursor-pointer"
            >
              {translations.reset_filters || "Reset Filters"}
            </button>
          )}
        </div>
      ) : (
        <div>
          {/* Table Element */}
          <div className="overflow-x-auto">
            <table className="w-full text-start">
              <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 py-3.5 px-6 text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                <tr>
                  <th className="py-3.5 px-6 text-start min-w-[120px] whitespace-nowrap">
                    {translations.visit_date || "Visit Date"}
                  </th>
                  <th className="py-3.5 px-6 text-start min-w-[200px]">
                    {translations.primary_diagnosis || "Primary Diagnosis (ICD-10)"}
                  </th>
                  <th className="py-3.5 px-6 text-start min-w-[150px]">
                    {translations.doctor || "Doctor"}
                  </th>
                  <th className="py-3.5 px-6 text-start min-w-[140px]">
                    {translations.nav_clinics || "Clinic"}
                  </th>
                  <th className="py-3.5 px-6 text-start min-w-[190px] whitespace-nowrap">
                    {translations.filter_record_status || "Record Status"}
                  </th>
                  <th className="py-3.5 px-6 text-center w-16 whitespace-nowrap">
                    {translations.actions || "Actions"}
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y-2 divide-slate-100 dark:divide-slate-800">
                {items.map((item) => (
                  <tr
                    key={item.recordId}
                    className="hover:bg-slate-50/80 dark:hover:bg-slate-800/40 text-slate-800 dark:text-slate-200 text-sm font-medium transition-colors"
                  >
                    {/* Visit Date: strict nowrap with dark/light styling */}
                    <td className="py-4 px-6 min-w-[120px] whitespace-nowrap font-medium text-sm text-slate-900 dark:text-slate-100">
                      {item.visitDate}
                    </td>

                    {/* Primary Diagnosis */}
                    <td className="py-4 px-6 min-w-[200px]">
                      <div className="flex items-center gap-2.5">
                        <span className="font-mono font-bold text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-950/60 px-2.5 py-1 rounded-md text-xs border border-blue-200/80 dark:border-blue-800/60 shrink-0">
                          {item.primaryDiagnosisCode}
                        </span>
                        <span className="font-bold text-slate-900 dark:text-white text-sm truncate">
                          {item.primaryDiagnosisName}
                        </span>
                      </div>
                    </td>

                    {/* Doctor Name */}
                    <td className="py-4 px-6 min-w-[150px] text-slate-700 dark:text-slate-300 text-sm">
                      {item.doctorName}
                    </td>

                    {/* Clinic Name */}
                    <td className="py-4 px-6 min-w-[140px] text-slate-600 dark:text-slate-400 text-sm">
                      {item.clinicName || "General Care"}
                    </td>

                    {/* Status Badge: explicit min-w-[190px] whitespace-nowrap */}
                    <td className="py-4 px-6 min-w-[190px] whitespace-nowrap">
                      <RecordStatusBadge
                        status={item.status || "FINALIZED"}
                        hasAmendments={item.hasAmendments}
                      />
                    </td>

                    {/* Action View Button */}
                    <td className="py-4 px-6 text-center w-16">
                      <button
                        type="button"
                        onClick={() => onViewRecordDetail(item.recordId)}
                        className="p-2 rounded-lg border border-slate-200 dark:border-slate-700 hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-500 hover:text-slate-900 dark:hover:text-white transition-colors cursor-pointer inline-flex items-center justify-center"
                        title={translations.view_medical_record || "View Record"}
                      >
                        <Eye className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* Pagination Controls */}
          {onPageChange && (
            <div className="flex items-center justify-between px-6 py-3.5 border-t-2 border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-[#131E35] text-xs">
              <span className="text-slate-600 dark:text-slate-300 font-bold">
                {translations.step_progress
                  ? translations.step_progress
                      .replace("{current}", String(page))
                      .replace("{total}", String(totalPages))
                  : `Page ${page} of ${totalPages}`} ({total})
              </span>

              <div className="flex items-center gap-2">
                <button
                  type="button"
                  disabled={page <= 1}
                  onClick={() => onPageChange(page - 1)}
                  className="px-3.5 py-1.5 bg-white dark:bg-[#0E1726] border border-slate-200 dark:border-slate-700 rounded-xl text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 disabled:opacity-40 transition flex items-center gap-1 font-bold text-xs cursor-pointer"
                >
                  <ChevronLeft className="w-3.5 h-3.5 rtl:rotate-180" />
                  <span>{translations.back || "Previous"}</span>
                </button>
                <button
                  type="button"
                  disabled={page >= totalPages}
                  onClick={() => onPageChange(page + 1)}
                  className="px-3.5 py-1.5 bg-white dark:bg-[#0E1726] border border-slate-200 dark:border-slate-700 rounded-xl text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 disabled:opacity-40 transition flex items-center gap-1 font-bold text-xs cursor-pointer"
                >
                  <span>{translations.next || "Next"}</span>
                  <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180" />
                </button>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

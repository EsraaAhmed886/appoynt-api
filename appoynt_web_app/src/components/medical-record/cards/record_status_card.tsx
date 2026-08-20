/*
 * File Name: record_status_card.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Dedicated Record Status Card component handling 4 distinct visual states: Not Started, Draft (with segmented progress bar), Finalized, and Finalized with Amendments with high-contrast dynamic action triggers.
 */

"use client";

import React from "react";
import {
  Sparkles,
  ArrowRight,
  Eye,
  CheckCircle2,
  Clock,
  FileEdit,
  History,
} from "lucide-react";
import { MedicalRecord } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

interface RecordStatusCardProps {
  record: MedicalRecord;
  onStartConsultation: () => void;
  onContinueConsultation: (step: 1 | 2 | 3) => void;
  onViewFinalizedRecord: () => void;
}

export default function RecordStatusCard({
  record,
  onStartConsultation,
  onContinueConsultation,
  onViewFinalizedRecord,
}: RecordStatusCardProps) {
  const { translations } = useTranslation();

  const isDraft = "DRAFT" === record.status;
  const isNotStarted = "NOT_STARTED" === record.status;
  const isFinalized = "FINALIZED" === record.status;
  const isAmended = "FINALIZED_WITH_AMENDMENTS" === record.displayState;

  const currentStep = (record.currentStep || 1) as 1 | 2 | 3;

  return (
    <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 shadow-xs rounded-2xl p-4 md:p-5 h-full flex flex-col justify-between space-y-4">
      <div className="space-y-3.5">
        {/* Header Strip */}
        <div className="flex items-center justify-between">
          <span className="text-xs font-bold text-slate-700 dark:text-slate-200 uppercase tracking-wider">
            {translations.filter_record_status || "Record Status"}
          </span>

          {/* Status Badge */}
          {isNotStarted && (
            <span className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold px-3 py-1 rounded-full text-[11px] border border-slate-200 dark:border-slate-700 whitespace-nowrap">
              {translations.not_started || "Not Started"}
            </span>
          )}

          {isDraft && (
            <span className="bg-amber-100 dark:bg-amber-950/60 text-amber-800 dark:text-amber-300 font-bold px-3 py-1 rounded-full text-[11px] border border-amber-300 dark:border-amber-700/60 animate-pulse whitespace-nowrap">
              {translations.draft || "Draft"} (Step {currentStep} of 3)
            </span>
          )}

          {isFinalized && (
            <span
              className={`px-3 py-1 rounded-full text-[11px] font-bold whitespace-nowrap ${
                isAmended
                  ? "bg-purple-100 dark:bg-purple-950/60 text-purple-800 dark:text-purple-300 border border-purple-200 dark:border-purple-800"
                  : "bg-emerald-100 dark:bg-emerald-950/60 text-emerald-800 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800"
              }`}
            >
              {isAmended
                ? translations.finalized_with_amendments || "Finalized with Amendments"
                : `✓ ${translations.finalized || "Finalized"}`}
            </span>
          )}
        </div>

        {/* State Information Content Box */}
        <div className="bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-slate-700/70 rounded-xl p-3 md:p-3.5 space-y-2 text-start">
          {isNotStarted && (
            <div className="space-y-1">
              <p className="font-bold text-sm text-slate-900 dark:text-white">
                {translations.consultation_not_started || "Consultation Not Started"}
              </p>
              <p className="text-slate-500 dark:text-slate-400 text-xs leading-relaxed">
                {translations.create_record_hint || "Begin recording clinical diagnoses, medication regimens, and test orders for this consultation."}
              </p>
            </div>
          )}

          {isDraft && (
            <div className="space-y-2.5">
              <div className="flex items-center justify-between text-xs">
                <span className="font-semibold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
                  <Clock className="w-3.5 h-3.5 text-amber-500" />
                  <span>
                    Last saved: {record.lastSavedAtUtc ? new Date(record.lastSavedAtUtc).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : "Just now"}
                  </span>
                </span>
                <span className="font-bold text-amber-600 dark:text-amber-400">
                  {Math.round((currentStep / 3) * 100)}%
                </span>
              </div>

              {/* Segmented Progress Bar */}
              <div className="grid grid-cols-3 gap-1.5">
                {[1, 2, 3].map((stepNum) => (
                  <div
                    key={stepNum}
                    className={`h-2 rounded-full transition-all ${
                      stepNum <= currentStep
                        ? "bg-amber-500 dark:bg-amber-400"
                        : "bg-slate-200 dark:bg-slate-700"
                    }`}
                  />
                ))}
              </div>
            </div>
          )}

          {isFinalized && (
            <div className="space-y-1.5 text-xs">
              <div className="flex items-center gap-1.5 font-bold text-emerald-600 dark:text-emerald-400">
                <CheckCircle2 className="w-4 h-4" />
                <span>{translations.finalized || "Record Finalized & Signed"}</span>
              </div>
              <p className="text-slate-500 dark:text-slate-400">
                {translations.doctor || "Attending"}: <strong className="text-slate-800 dark:text-slate-200">{record.doctorName || "Dr. Nada Khan"}</strong>
              </p>
              <p className="text-slate-400 dark:text-slate-500 text-[11px]">
                {record.finalizedAtUtc ? new Date(record.finalizedAtUtc).toLocaleString() : "2026-08-18"}
              </p>
              {isAmended && record.amendmentNotes && (
                <p className="text-purple-600 dark:text-purple-400 italic pt-1 border-t border-purple-200/50 dark:border-purple-900/50">
                  &ldquo;{record.amendmentNotes}&rdquo;
                </p>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Dynamic Action Buttons */}
      <div className="pt-2">
        {isNotStarted && (
          <button
            type="button"
            onClick={onStartConsultation}
            className="w-full py-2.5 px-4 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md transition flex items-center justify-center gap-2 cursor-pointer"
          >
            <Sparkles className="w-4 h-4" />
            <span>{translations.create_medical_record || "Create Medical Record"}</span>
          </button>
        )}

        {isDraft && (
          <button
            type="button"
            onClick={() => onContinueConsultation(currentStep)}
            className="w-full py-2.5 px-4 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md transition flex items-center justify-center gap-2 cursor-pointer tracking-wider uppercase"
          >
            <FileEdit className="w-4 h-4" />
            <span>{translations.continue_medical_record || "Continue Medical Record"}</span>
            <ArrowRight className="w-4 h-4 rtl:rotate-180" />
          </button>
        )}

        {isFinalized && (
          <div className="space-y-2">
            <button
              type="button"
              onClick={onViewFinalizedRecord}
              className="w-full py-2.5 px-4 text-xs font-bold text-blue-700 dark:text-blue-300 bg-blue-50 dark:bg-blue-950/60 hover:bg-blue-100 dark:hover:bg-blue-900/60 border border-blue-200 dark:border-blue-800 rounded-xl transition flex items-center justify-center gap-2 cursor-pointer"
            >
              <Eye className="w-4 h-4" />
              <span>{translations.view_medical_record || "View Medical Record"}</span>
            </button>
            {isAmended && (
              <button
                type="button"
                onClick={onViewFinalizedRecord}
                className="text-[11px] font-semibold text-purple-600 dark:text-purple-400 hover:underline flex items-center justify-center gap-1 w-full cursor-pointer"
              >
                <History className="w-3.5 h-3.5" />
                <span>Amendments History</span>
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

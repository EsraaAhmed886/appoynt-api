/*
 * File Name: medical_record_header.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - next/navigation
 *   - lucide-react
 *   - @/context/medical_record_context
 *   - @/context/language_context
 *   - @/types/medical_record
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Top-level Medical Record Header component with localized breadcrumb navigation, title, and strictly two top-level primary navigation tabs (Patient Summary, Medical History).
 */

"use client";

import React from "react";
import { useRouter } from "next/navigation";
import { ChevronRight, User, History } from "lucide-react";
import { PatientSummary, MedicalRecord } from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { useTranslation } from "@/context/language_context";

interface MedicalRecordHeaderProps {
  patient: PatientSummary | null;
  record: MedicalRecord;
}

export default function MedicalRecordHeader({
  patient,
  record,
}: MedicalRecordHeaderProps) {
  const router = useRouter();
  const { activeTab, setActiveTab } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  return (
    <div className="space-y-3">
      {/* 1. Breadcrumbs */}
      <nav
        aria-label="Breadcrumb"
        className="flex items-center gap-1.5 text-xs font-medium text-slate-500 dark:text-slate-400"
      >
        <button
          type="button"
          onClick={() => router.push("/clinics")}
          className="hover:text-blue-600 dark:hover:text-blue-400 transition cursor-pointer"
        >
          {translations.nav_clinics || "Clinics"}
        </button>
        <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400 dark:text-slate-600" />
        <button
          type="button"
          onClick={() => {
            setActiveTab("summary");
            router.push("/medical-record");
          }}
          className="hover:text-blue-600 dark:hover:text-blue-400 transition cursor-pointer"
        >
          {translations.medical_record}
        </button>
        <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400 dark:text-slate-600" />
        <span className="text-slate-900 dark:text-white font-semibold">
          {patient ? patient.fullName : record.appointmentId}
        </span>
      </nav>

      {/* 2. Page Title */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white tracking-tight">
          {translations.medical_record}
        </h1>
      </div>

      {/* 3. Standardized Top 2 Tabs Bar */}
      <div className="border-b-2 border-slate-200 dark:border-slate-800 flex items-center gap-6 overflow-x-auto">
        {/* Tab 1: Patient Summary */}
        <button
          type="button"
          onClick={() => setActiveTab("summary")}
          className={`flex items-center gap-2 py-3 px-1 text-sm font-semibold border-b-2 transition shrink-0 cursor-pointer ${
            "summary" === activeTab || "consultation" === activeTab
              ? "border-blue-600 text-blue-600 dark:text-blue-400"
              : "border-transparent text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200 font-medium"
          }`}
        >
          <User className="w-4 h-4" />
          <span>{translations.patient_summary}</span>
        </button>

        {/* Tab 2: Medical History */}
        <button
          type="button"
          onClick={() => setActiveTab("history")}
          className={`flex items-center gap-2 py-3 px-1 text-sm font-semibold border-b-2 transition shrink-0 cursor-pointer ${
            "history" === activeTab
              ? "border-blue-600 text-blue-600 dark:text-blue-400"
              : "border-transparent text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200 font-medium"
          }`}
        >
          <History className="w-4 h-4" />
          <span>{translations.medical_history}</span>
        </button>
      </div>
    </div>
  );
}

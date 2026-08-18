/*
 * File Name: medical_record_layout.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - next/navigation
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/components/layout/sidebar
 *   - @/components/layout/header
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Compact, high-density clinical EHR layout shell for Medical Record dashboard with tightened spacing, compact margins, and Layer 0 canvas styling.
 */

"use client";

import React, { ReactNode, useState } from "react";
import { useRouter } from "next/navigation";
import {
  User,
  History,
  Stethoscope,
  ChevronRight,
} from "lucide-react";
import { PatientSummary, MedicalRecord } from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import Sidebar from "@/components/layout/sidebar";
import LayoutHeader from "@/components/layout/header";
import { useTranslation } from "@/context/language_context";

interface MedicalRecordLayoutProps {
  patient: PatientSummary | null;
  record: MedicalRecord;
  children: ReactNode;
}

export default function MedicalRecordLayout({
  patient,
  record,
  children,
}: MedicalRecordLayoutProps) {
  const router = useRouter();
  const [is_collapsed, set_is_collapsed] = useState(false);
  const [is_mobile_sidebar_open, set_is_mobile_sidebar_open] = useState(false);

  const { activeTab, setActiveTab } = useMedicalRecordWorkflow();
  const { current_locale, translations } = useTranslation();
  const isRtl = "ar" === current_locale;

  return (
    <div
      dir={isRtl ? "rtl" : "ltr"}
      className="flex min-h-screen bg-[#F1F5F9] dark:bg-[#070D1E] font-sans text-slate-900 dark:text-slate-100 transition-colors"
    >
      {/* Desktop Sidebar */}
      <Sidebar
        className="hidden lg:flex"
        isCollapsed={is_collapsed}
        onToggle={() => set_is_collapsed(!is_collapsed)}
      />

      {/* Mobile Sidebar Backdrop */}
      {is_mobile_sidebar_open ? (
        <div
          className="fixed inset-0 z-40 bg-black/50 lg:hidden"
          onClick={() => set_is_mobile_sidebar_open(false)}
        />
      ) : null}

      {/* Mobile Sidebar Drawer */}
      <div
        className={`
          fixed inset-y-0 start-0 z-50 lg:hidden
          transform transition-transform duration-300 ease-in-out
          ${is_mobile_sidebar_open ? "translate-x-0" : "-translate-x-full"}
        `}
      >
        <Sidebar
          isCollapsed={false}
          onToggle={() => set_is_mobile_sidebar_open(false)}
        />
      </div>

      {/* Main Content Canvas */}
      <div className="flex-1 flex flex-col min-w-0">
        {/* Global Standard Header */}
        <div className="sticky top-0 z-30 w-full bg-white dark:bg-[#0E1726] border-b-2 border-slate-200/80 dark:border-slate-800/80 shadow-xs">
          <LayoutHeader on_menu_click={() => set_is_mobile_sidebar_open(true)} />
        </div>

        {/* Medical Record Main Scroll Area - Compact EHR Padding */}
        <main className="flex-1 max-w-[1600px] w-full mx-auto p-4 sm:p-5 md:p-6 space-y-4">
          {/* 1. Breadcrumbs */}
          <nav className="flex items-center gap-1.5 text-xs font-medium text-slate-500 dark:text-slate-400 mb-1">
            <button
              type="button"
              onClick={() => router.push("/clinics")}
              className="hover:text-blue-600 dark:hover:text-blue-400 transition"
            >
              {translations.nav_clinics || "Clinics"}
            </button>
            <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400 dark:text-slate-600" />
            <button
              type="button"
              onClick={() => router.push("/medical-records")}
              className="hover:text-blue-600 dark:hover:text-blue-400 transition"
            >
              {translations.medical_record}
            </button>
            <ChevronRight className="w-3.5 h-3.5 rtl:rotate-180 text-slate-400 dark:text-slate-600" />
            <span className="text-slate-900 dark:text-white font-semibold">
              {patient ? patient.fullName : record.appointmentId}
            </span>
          </nav>

          {/* 2. Compact Page Title */}
          <div className="flex items-center justify-between mb-2">
            <h1 className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white tracking-tight">
              {translations.medical_record}
            </h1>
          </div>

          {/* 3. Navigation Tabs Bar */}
          <div className="border-b-2 border-slate-200 dark:border-slate-800 flex items-center gap-6 overflow-x-auto mb-4">
            {/* Tab 1: Patient Summary */}
            <button
              type="button"
              onClick={() => setActiveTab("summary")}
              className={`flex items-center gap-2 py-2.5 px-1 text-sm font-semibold border-b-2 transition shrink-0 ${
                "summary" === activeTab
                  ? "border-blue-600 text-blue-600 dark:text-blue-400"
                  : "border-transparent text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200 font-medium"
              }`}
            >
              <User className="w-4 h-4" />
              {translations.patient_summary}
            </button>

            {/* Tab 2: Clinical Consultation (Active when in draft or explicitly editing) */}
            {("DRAFT" === record.status || "consultation" === activeTab) && (
              <button
                type="button"
                onClick={() => setActiveTab("consultation")}
                className={`flex items-center gap-2 py-2.5 px-1 text-sm font-semibold border-b-2 transition shrink-0 ${
                  "consultation" === activeTab
                    ? "border-blue-600 text-blue-600 dark:text-blue-400"
                    : "border-transparent text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200 font-medium"
                }`}
              >
                <Stethoscope className="w-4 h-4" />
                {translations.medical_record}
                {"DRAFT" === record.status && (
                  <span className="w-2 h-2 rounded-full bg-amber-500 animate-pulse" />
                )}
              </button>
            )}

            {/* Tab 3: Medical History */}
            <button
              type="button"
              onClick={() => setActiveTab("history")}
              className={`flex items-center gap-2 py-2.5 px-1 text-sm font-semibold border-b-2 transition shrink-0 ${
                "history" === activeTab
                  ? "border-blue-600 text-blue-600 dark:text-blue-400"
                  : "border-transparent text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200 font-medium"
              }`}
            >
              <History className="w-4 h-4" />
              {translations.medical_history}
            </button>
          </div>

          {/* 4. Tab Viewport Content */}
          <div className="min-h-[450px]">{children}</div>
        </main>
      </div>
    </div>
  );
}

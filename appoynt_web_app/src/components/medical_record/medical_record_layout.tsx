/*
 * File Name: medical_record_layout.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - next/navigation
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/components/layout/sidebar
 *   - @/components/layout/header
 *   - @/components/medical-record/medical_record_header
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Compact, high-density clinical EHR layout shell for Medical Record dashboard with standardized 2-tab navigation header, RTL support, and Layer 0 canvas styling.
 */

"use client";

import React, { ReactNode, useState } from "react";
import { PatientSummary, MedicalRecord } from "@/types/medical_record";
import Sidebar from "@/components/layout/sidebar";
import LayoutHeader from "@/components/layout/header";
import MedicalRecordHeader from "@/components/medical-record/medical_record_header";
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
  const [is_collapsed, set_is_collapsed] = useState(false);
  const [is_mobile_sidebar_open, set_is_mobile_sidebar_open] = useState(false);

  const { current_locale } = useTranslation();
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
          <MedicalRecordHeader patient={patient} record={record} />
          {/* Tab Viewport Content */}
          <div className="min-h-[450px]">{children}</div>
        </main>
      </div>
    </div>
  );
}

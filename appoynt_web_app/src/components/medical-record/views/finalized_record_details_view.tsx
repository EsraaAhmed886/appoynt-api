/*
 * File Name: finalized_record_details_view.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Read-only finalized consultation details view for signed EHR records featuring top navigation, PDF export trigger, metadata strip, formatted diagnoses/regimens/tests, and compliance locking banner.
 */

"use client";

import React, { useState } from "react";
import {
  FileCheck,
  Download,
  Stethoscope,
  Pill,
  FlaskConical,
  Paperclip,
  Lock,
  Calendar,
  ArrowLeft,
  FileText,
  User,
  CheckCircle2,
} from "lucide-react";
import { MedicalRecord, PatientSummary } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

interface FinalizedRecordDetailsViewProps {
  record: MedicalRecord;
  patient?: PatientSummary;
  onBack?: () => void;
  onBackToSummary?: () => void;
  onBackToWorkflow?: () => void;
  onDownloadPdf?: () => void;
}

export default function FinalizedRecordDetailsView({
  record,
  patient,
  onBack,
  onBackToSummary,
  onBackToWorkflow,
  onDownloadPdf,
}: FinalizedRecordDetailsViewProps) {
  const { translations } = useTranslation();
  const [isGeneratingPdf, setIsGeneratingPdf] = useState(false);
  const backHandler = onBack || onBackToSummary || onBackToWorkflow;

  const handleDownload = () => {
    if (onDownloadPdf) {
      onDownloadPdf();
      return;
    }
    setIsGeneratingPdf(true);
    setTimeout(() => {
      setIsGeneratingPdf(false);
      alert(`Exporting official clinical PDF record: ${record.recordId}`);
    }, 800);
  };

  const isAmended = "FINALIZED_WITH_AMENDMENTS" === record.displayState;

  return (
    <div className="space-y-6 animate-in fade-in duration-200 text-start">
      {/* 1. Top Navigation & Action Strip */}
      <div className="flex flex-wrap items-center justify-between gap-4">
        {backHandler ? (
          <button
            type="button"
            onClick={backHandler}
            className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700/80 bg-white dark:bg-[#131E35] text-slate-700 dark:text-slate-200 text-sm font-semibold hover:bg-slate-50 dark:hover:bg-slate-800 hover:border-slate-300 dark:hover:border-slate-600 shadow-2xs transition-all cursor-pointer group"
          >
            <ArrowLeft className="w-4 h-4 text-slate-500 dark:text-slate-400 group-hover:text-slate-900 dark:group-hover:text-white group-hover:-translate-x-0.5 transition-transform rtl:rotate-180 rtl:group-hover:translate-x-0.5" />
            <span>{translations.back_to_summary || translations.btn_back || "Back to Patient Summary"}</span>
          </button>
        ) : (
          <div />
        )}

        <button
          type="button"
          disabled={isGeneratingPdf}
          onClick={handleDownload}
          className="px-4 py-2 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer"
        >
          <Download className="w-4 h-4" />
          <span>{isGeneratingPdf ? "Generating PDF..." : (translations.download_pdf || "Download PDF Record")}</span>
        </button>
      </div>

      {/* 2. Top Finalized Banner */}
      <div className="p-5 bg-emerald-50/90 dark:bg-emerald-950/30 border-2 border-emerald-300 dark:border-emerald-800 rounded-2xl flex flex-col sm:flex-row sm:items-center justify-between gap-4 shadow-xs">
        <div className="flex items-center gap-3.5">
          <div className="p-3 bg-emerald-600 text-white rounded-2xl shadow-xs shrink-0">
            <FileCheck className="w-6 h-6" />
          </div>
          <div className="space-y-0.5">
            <div className="flex items-center gap-2">
              <h2 className="text-base font-bold text-emerald-950 dark:text-emerald-100">
                {isAmended ? (translations.finalized_with_amendments || "Finalized with Amendments") : (translations.finalized || "Finalized Medical Record")}
              </h2>
              <span className="px-2 py-0.5 text-[11px] font-mono font-bold bg-emerald-200 dark:bg-emerald-900 text-emerald-900 dark:text-emerald-100 rounded-md">
                {record.recordId}
              </span>
            </div>
            <p className="text-xs text-emerald-800 dark:text-emerald-300">
              Signed & authenticated by {record.doctorName || "Dr. Nada Khan"} • Verified on {record.finalizedAtUtc ? new Date(record.finalizedAtUtc).toLocaleString() : "2026-08-18"}
            </p>
          </div>
        </div>

        <span className="px-3 py-1 bg-emerald-100 dark:bg-emerald-900/60 text-emerald-800 dark:text-emerald-300 font-bold text-xs rounded-full border border-emerald-300 dark:border-emerald-700 whitespace-nowrap self-start sm:self-auto">
          ✓ Certified Signed
        </span>
      </div>

      {/* 3. Metadata Strip */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3.5">
        <div className="p-3.5 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs">
          <p className="text-[11px] font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">
            {translations.date || "Consultation Date"}
          </p>
          <p className="text-xs md:text-sm font-bold text-slate-900 dark:text-white mt-1">
            {record.consultationDate || "2026-08-18"}
          </p>
        </div>

        <div className="p-3.5 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs">
          <p className="text-[11px] font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">
            {translations.doctor || "Attending Physician"}
          </p>
          <p className="text-xs md:text-sm font-bold text-slate-900 dark:text-white mt-1 truncate">
            {record.doctorName || "Dr. Nada Khan"}
          </p>
        </div>

        <div className="p-3.5 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs">
          <p className="text-[11px] font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">
            {translations.medrec_outcome_title || "Clinical Outcome"}
          </p>
          <p className="text-xs md:text-sm font-bold text-slate-900 dark:text-white mt-1 truncate">
            {record.clinicalOutcome ? record.clinicalOutcome.replace(/_/g, " ") : "Follow Up In 1 Month"}
          </p>
        </div>

        <div className="p-3.5 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs">
          <p className="text-[11px] font-semibold text-slate-400 dark:text-slate-500 uppercase tracking-wider">
            {translations.appointment || "Appointment ID"}
          </p>
          <p className="text-xs md:text-sm font-mono font-bold text-slate-900 dark:text-white mt-1">
            {record.appointmentId}
          </p>
        </div>
      </div>

      {/* 4. Section 1: Diagnoses & Clinical Notes */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4">
        <div className="flex items-center gap-2 pb-2 border-b-2 border-slate-100 dark:border-slate-800">
          <Stethoscope className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          <h3 className="text-sm md:text-base font-bold text-slate-900 dark:text-white">
            {translations.diagnoses_title || "Clinical Diagnoses & Findings"}
          </h3>
        </div>

        {/* Primary Diagnosis */}
        <div className="space-y-2">
          <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
            {translations.primary_diagnosis || "Primary Diagnosis"}
          </p>
          {record.primaryDiagnosis ? (
            <div className="p-3 bg-blue-50/70 dark:bg-blue-950/40 border-2 border-blue-200 dark:border-blue-800 rounded-xl flex items-center gap-3">
              <span className="font-mono text-xs font-bold text-blue-700 dark:text-blue-300 bg-blue-100 dark:bg-blue-900 px-2 py-0.5 rounded">
                {record.primaryDiagnosis.code}
              </span>
              <span className="text-xs md:text-sm font-bold text-slate-900 dark:text-white">
                {record.primaryDiagnosis.title}
              </span>
            </div>
          ) : (
            <p className="text-xs text-slate-400">No primary diagnosis recorded.</p>
          )}
        </div>

        {/* Secondary Diagnoses */}
        {(record.secondaryDiagnoses || []).length > 0 && (
          <div className="space-y-2 pt-1">
            <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
              {translations.secondary_diagnoses || "Secondary Diagnoses"}
            </p>
            <div className="flex flex-wrap gap-2">
              {record.secondaryDiagnoses!.map((sec) => (
                <div
                  key={sec.code}
                  className="p-2.5 bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-xl flex items-center gap-2 text-xs font-medium"
                >
                  <span className="font-mono font-bold text-slate-700 dark:text-slate-300 bg-slate-200 dark:bg-slate-800 px-1.5 py-0.5 rounded text-[11px]">
                    {sec.code}
                  </span>
                  <span>{sec.title}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Clinical Notes Body */}
        <div className="space-y-2 pt-2">
          <p className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">
            {translations.clinical_notes || "Clinical Notes"}
          </p>
          <div className="p-4 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-slate-700 rounded-xl text-xs md:text-sm text-slate-800 dark:text-slate-200 whitespace-pre-wrap leading-relaxed">
            {record.clinicalNotes || "No notes recorded."}
          </div>
        </div>
      </div>

      {/* 5. Section 2: Prescribed Medications */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4">
        <div className="flex items-center gap-2 pb-2 border-b-2 border-slate-100 dark:border-slate-800">
          <Pill className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          <h3 className="text-sm md:text-base font-bold text-slate-900 dark:text-white">
            {translations.medications_and_prescriptions || "Prescribed Medications & Pharmacy Orders"}
          </h3>
        </div>

        {(record.medications || []).length > 0 ? (
          <div className="overflow-x-auto border-2 border-slate-200 dark:border-slate-800 rounded-xl">
            <table className="w-full text-xs text-slate-700 dark:text-slate-200 text-start">
              <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 uppercase text-[11px] font-bold text-slate-500 dark:text-slate-400">
                <tr>
                  <th className="py-3 px-4 text-start">{translations.medication_name || "Medication"}</th>
                  <th className="py-3 px-4 text-start">{translations.dosage || "Dosage"}</th>
                  <th className="py-3 px-4 text-start">{translations.frequency || "Frequency"}</th>
                  <th className="py-3 px-4 text-start">{translations.duration || "Duration"}</th>
                  <th className="py-3 px-4 text-start">{translations.route || "Route"}</th>
                  <th className="py-3 px-4 text-start">{translations.instructions || "Instructions"}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
                {record.medications!.map((med) => (
                  <tr key={med.id}>
                    <td className="py-3 px-4 font-bold text-slate-900 dark:text-white">{med.medicationName}</td>
                    <td className="py-3 px-4 whitespace-nowrap">{med.dosageAmount} {med.dosageUnit}</td>
                    <td className="py-3 px-4 whitespace-nowrap">{med.frequency}</td>
                    <td className="py-3 px-4 whitespace-nowrap">{med.isOngoing ? "Ongoing" : `${med.durationValue} ${med.durationUnit}`}</td>
                    <td className="py-3 px-4 whitespace-nowrap">{med.route}</td>
                    <td className="py-3 px-4 italic text-slate-500 dark:text-slate-400">{med.instructions || "—"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <p className="text-xs text-slate-400">No medications prescribed during this encounter.</p>
        )}
      </div>

      {/* 6. Section 3: Diagnostic Tests & Attachments */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4">
        <div className="flex items-center gap-2 pb-2 border-b-2 border-slate-100 dark:border-slate-800">
          <FlaskConical className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          <h3 className="text-sm md:text-base font-bold text-slate-900 dark:text-white">
            {translations.diagnostic_tests || "Diagnostic Tests Ordered"}
          </h3>
        </div>

        {(record.testsOrdered || []).length > 0 ? (
          <div className="overflow-x-auto border-2 border-slate-200 dark:border-slate-800 rounded-xl">
            <table className="w-full text-xs text-slate-700 dark:text-slate-200 text-start">
              <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 uppercase text-[11px] font-bold text-slate-500 dark:text-slate-400">
                <tr>
                  <th className="py-3 px-4 text-start">{translations.test_name || "Test Name"}</th>
                  <th className="py-3 px-4 text-start">{translations.type || "Category"}</th>
                  <th className="py-3 px-4 text-start">{translations.priority || "Priority"}</th>
                  <th className="py-3 px-4 text-start">{translations.status || "Status"}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
                {record.testsOrdered!.map((test) => (
                  <tr key={test.id}>
                    <td className="py-3 px-4 font-bold text-slate-900 dark:text-white">{test.testName}</td>
                    <td className="py-3 px-4">{test.type}</td>
                    <td className="py-3 px-4">{test.priority}</td>
                    <td className="py-3 px-4">{test.status || "Ordered"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <p className="text-xs text-slate-400">No laboratory or diagnostic tests ordered.</p>
        )}
      </div>

      {/* 7. Bottom Locked Banner */}
      <div className="p-4 bg-slate-100 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700/80 rounded-2xl flex items-center justify-center gap-2 text-xs font-bold text-slate-600 dark:text-slate-300">
        <Lock className="w-4 h-4 text-slate-500" />
        <span>🔒 This is a finalized record and cannot be edited.</span>
      </div>
    </div>
  );
}

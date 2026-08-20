/*
 * File Name: patient_summary_tab.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.3.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/components/medical-record/cards/record_status_card
 *   - @/components/medical-record/banners/clinical_alerts_banner
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Top-level Patient Summary dashboard tab component orchestrating the top 3-card demographic & status grid, unified symmetrical clinical alerts banner, and continuity of care prior visit table.
 */

"use client";

import React, { useState } from "react";
import Image from "next/image";
import {
  User,
  Calendar,
  Clock,
  Building2,
  Eye,
  ExternalLink,
  Phone,
  Mail,
  Droplet,
  MoreVertical,
  Activity,
} from "lucide-react";
import {
  PatientSummary,
  MedicalRecord,
  MedicalHistoryItem,
} from "@/types/medical_record";
import RecordStatusCard from "@/components/medical-record/cards/record_status_card";
import ClinicalAlertsBanner from "@/components/medical-record/banners/clinical_alerts_banner";
import { useTranslation } from "@/context/language_context";

interface PatientSummaryTabProps {
  patient: PatientSummary;
  record: MedicalRecord;
  priorVisits: MedicalHistoryItem[];
  isLoading?: boolean;
  isError?: boolean;
  onRetry?: () => void;
  onStartConsultation: () => void;
  onContinueConsultation: (step: 1 | 2 | 3) => void;
  onViewFinalizedRecord: () => void;
  onSelectPriorVisit?: (visit: MedicalHistoryItem) => void;
}

export default function PatientSummaryTab({
  patient,
  record,
  priorVisits,
  isLoading = false,
  isError = false,
  onRetry,
  onStartConsultation,
  onContinueConsultation,
  onViewFinalizedRecord,
  onSelectPriorVisit,
}: PatientSummaryTabProps) {
  const { translations } = useTranslation();
  const [menuOpen, setMenuOpen] = useState(false);
  const last3Visits = priorVisits ? priorVisits.slice(0, 3) : [];

  const formatGender = (g: string) => {
    if ("Male" === g || "ذكر" === g) return translations.male || "Male";
    if ("Female" === g || "أنثى" === g) return translations.female || "Female";
    return g;
  };

  if (isLoading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
          <div className="h-64 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
          <div className="h-64 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
          <div className="h-64 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
        </div>
        <div className="h-24 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
        <div className="h-48 bg-slate-200 dark:bg-slate-800 rounded-2xl" />
      </div>
    );
  }

  return (
    <div className="space-y-4 animate-in fade-in duration-200">
      {/* 1. Top 3-Card Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 md:gap-5 items-stretch">
        {/* Card 1: Patient Demographic Profile */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 shadow-xs rounded-2xl p-4 md:p-5 h-full flex flex-col justify-between space-y-4 text-start">
          <div className="space-y-3.5">
            <div className="flex items-center justify-between">
              <span className="px-3 py-1 text-[11px] font-extrabold uppercase tracking-wider bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 rounded-full border border-emerald-300 dark:border-emerald-700 whitespace-nowrap">
                {translations.patient_selected || "PATIENT SELECTED"}
              </span>
              <div className="relative">
                <button
                  type="button"
                  onClick={() => setMenuOpen(!menuOpen)}
                  className="p-1 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg transition cursor-pointer"
                >
                  <MoreVertical className="w-4 h-4" />
                </button>
                {menuOpen && (
                  <div className="absolute end-0 top-full mt-1 w-36 bg-white dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl shadow-lg p-1 z-30">
                    <button
                      type="button"
                      onClick={() => {
                        setMenuOpen(false);
                        alert(`Patient ID: ${patient.patientId}`);
                      }}
                      className="w-full text-start px-2.5 py-1.5 text-xs text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition"
                    >
                      Copy Patient ID
                    </button>
                  </div>
                )}
              </div>
            </div>

            <div className="flex items-center gap-3.5">
              <div className="relative h-14 w-14 md:h-16 md:w-16 overflow-hidden rounded-2xl ring-2 ring-slate-100 dark:ring-slate-800 shrink-0">
                <Image
                  src={patient.avatarUrl || "/images/profile_icon.jpeg"}
                  alt={patient.fullName}
                  width={64}
                  height={64}
                  className="h-full w-full object-cover"
                />
              </div>
              <div className="overflow-hidden space-y-0.5 min-w-0">
                <h2 className="text-lg md:text-xl font-bold text-slate-900 dark:text-white truncate">
                  {patient.fullName}
                </h2>
                <div className="flex items-center gap-2 text-xs font-medium text-slate-600 dark:text-slate-300">
                  <span className="font-mono text-[11px] bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-md font-bold text-slate-700 dark:text-slate-300">
                    {patient.patientId}
                  </span>
                  <span>•</span>
                  <span>
                    {patient.calculatedAge} {translations.years || "yrs"} • {formatGender(patient.gender)}
                  </span>
                </div>
                {patient.bloodType && (
                  <div className="flex items-center gap-1 text-xs font-bold text-rose-600 dark:text-rose-400 pt-0.5">
                    <Droplet className="w-3.5 h-3.5" />
                    <span>{patient.bloodType}</span>
                  </div>
                )}
              </div>
            </div>

            {/* Layer 2: Demographic Contact Info Box */}
            <div className="bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-slate-700/70 rounded-xl p-3 space-y-1.5 text-xs text-slate-700 dark:text-slate-200 font-medium">
              {patient.phone && (
                <p className="flex items-center gap-2.5">
                  <Phone className="w-3.5 h-3.5 text-slate-400 dark:text-slate-500 shrink-0" />
                  <span>{patient.phone}</span>
                </p>
              )}
              {patient.email && (
                <p className="flex items-center gap-2.5 truncate">
                  <Mail className="w-3.5 h-3.5 text-slate-400 dark:text-slate-500 shrink-0" />
                  <span className="truncate">{patient.email}</span>
                </p>
              )}
            </div>
          </div>

          <button
            type="button"
            onClick={() => alert(`Navigating to full electronic chart for ${patient.fullName}`)}
            className="text-xs font-bold text-blue-600 dark:text-blue-400 hover:underline inline-flex items-center gap-1.5 self-start pt-1 cursor-pointer"
          >
            <User className="w-3.5 h-3.5" />
            <span>{translations.view_full_profile || "View Full Profile"}</span>
            <ExternalLink className="w-3 h-3" />
          </button>
        </div>

        {/* Card 2: Appointment Consultation Details */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 shadow-xs rounded-2xl p-4 md:p-5 h-full flex flex-col justify-between space-y-4 text-start">
          <div className="space-y-3.5">
            <div className="flex items-center justify-between">
              <span className="px-3 py-1 text-[11px] font-extrabold uppercase tracking-wider bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 rounded-full border border-blue-200 dark:border-blue-800 whitespace-nowrap">
                {translations.appointment_information || "Appointment Info"}
              </span>
              <span className="text-xs font-mono font-bold text-slate-500 dark:text-slate-400">
                {record.appointmentId}
              </span>
            </div>

            <div className="space-y-2 text-xs text-slate-600 dark:text-slate-300 font-medium">
              <div className="flex items-center gap-2.5">
                <Calendar className="w-4 h-4 text-blue-500 shrink-0" />
                <span>
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.date || "Date"}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white">{record.consultationDate || "2026-08-18"}</strong>
                </span>
              </div>
              <div className="flex items-center gap-2.5">
                <Clock className="w-4 h-4 text-blue-500 shrink-0" />
                <span>
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.time || "Time"}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white">10:00 AM - 10:30 AM</strong>
                </span>
              </div>
              <div className="flex items-center gap-2.5">
                <Building2 className="w-4 h-4 text-blue-500 shrink-0" />
                <span className="truncate">
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.nav_clinics || "Clinic"}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white">{record.clinicName || "Main Cardiology Clinic"}</strong>
                </span>
              </div>
            </div>

            {/* Layer 2: Clinical Outcome */}
            <div className="bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-slate-700/70 rounded-xl p-3 space-y-0.5">
              <p className="font-bold text-[10px] uppercase tracking-wider text-blue-600 dark:text-blue-400">
                {translations.clinical_outcome || translations.medrec_outcome_title || "Clinical Outcome"}
              </p>
              <p className="text-xs md:text-sm font-bold text-slate-900 dark:text-white">
                {record.clinicalOutcome ? record.clinicalOutcome.replace(/_/g, " ") : "Follow Up In 1 Month"}
              </p>
            </div>
          </div>

          <p className="text-xs font-medium text-slate-500 dark:text-slate-400 pt-1">
            {translations.doctor || "Doctor"}: <strong className="text-slate-900 dark:text-white">{record.doctorName || "Dr. Nada Khan"}</strong>
          </p>
        </div>

        {/* Card 3: Record Status Card */}
        <RecordStatusCard
          record={record}
          onStartConsultation={onStartConsultation}
          onContinueConsultation={onContinueConsultation}
          onViewFinalizedRecord={onViewFinalizedRecord}
        />
      </div>

      {/* 2. Clinical Safety Section: Allergies & Chronic Conditions */}
      <ClinicalAlertsBanner
        allergies={patient.activeAllergies || []}
        conditions={patient.chronicConditions || []}
        isLoading={isLoading}
        isError={isError}
        onRetry={onRetry}
      />

      {/* 3. Continuity of Care Table: Prior 3 Visits */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs p-4 md:p-5 space-y-3.5 text-start">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Activity className="w-4 h-4 text-blue-600 dark:text-blue-400" />
            <h3 className="text-sm md:text-base font-bold text-slate-900 dark:text-white">
              {translations.continuity_title || translations.continuity_of_care || "Continuity of Care (Last 3 Encounters)"}
            </h3>
          </div>
          <span className="text-xs text-slate-500 dark:text-slate-400 font-medium">
            {translations.continuity_sub || `Showing last ${last3Visits.length} recorded consultations`}
          </span>
        </div>

        <div className="overflow-x-auto border-2 border-slate-200/80 dark:border-slate-800 rounded-xl">
          <table className="w-full text-xs text-slate-700 dark:text-slate-200 text-start">
            <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 uppercase text-[11px] font-bold text-slate-500 dark:text-slate-400">
              <tr>
                <th className="py-3 px-4 text-start whitespace-nowrap">{translations.col_date || translations.date || "Visit Date"}</th>
                <th className="py-3 px-4 text-start">{translations.col_diagnosis || translations.primary_diagnosis || "Primary Diagnosis"}</th>
                <th className="py-3 px-4 text-start">{translations.col_doctor || translations.doctor || "Attending Doctor"}</th>
                <th className="py-3 px-4 text-end">{translations.col_actions || translations.actions || "Actions"}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
              {last3Visits.length > 0 ? (
                last3Visits.map((visit) => (
                  <tr
                    key={visit.recordId}
                    className="hover:bg-slate-50/80 dark:hover:bg-[#131E35]/60 transition"
                  >
                    <td className="py-3 px-4 whitespace-nowrap font-bold text-slate-900 dark:text-white">
                      {visit.visitDate}
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-2">
                        <span className="px-2 py-0.5 rounded-md bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 font-mono text-[11px] font-bold">
                          {visit.primaryDiagnosisCode}
                        </span>
                        <span className="truncate max-w-xs">{visit.primaryDiagnosisTitle}</span>
                      </div>
                    </td>
                    <td className="py-3 px-4 text-slate-600 dark:text-slate-300">
                      {visit.doctorName}
                    </td>
                    <td className="py-3 px-4 text-end">
                      <button
                        type="button"
                        onClick={() => onSelectPriorVisit && onSelectPriorVisit(visit)}
                        className="p-1.5 text-blue-600 dark:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-950/50 rounded-lg transition inline-flex items-center gap-1 cursor-pointer font-bold"
                      >
                        <Eye className="w-4 h-4" />
                        <span>{translations.view_record || translations.view_medical_record || "View"}</span>
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan={4} className="py-8 text-center text-slate-400 dark:text-slate-500">
                    {translations.no_history_found || "No previous consultation records on file"}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

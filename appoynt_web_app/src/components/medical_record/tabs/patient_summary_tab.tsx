/*
 * File Name: patient_summary_tab.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Compact, high-density clinical Patient Summary component with tightened margins, balanced card padding (p-4 md:p-5), compact dual-column clinical alerts banner, and streamlined continuity of care table.
 */

"use client";

import React from "react";
import Image from "next/image";
import {
  User,
  Calendar,
  Clock,
  Building2,
  FileCheck,
  AlertTriangle,
  ShieldCheck,
  Eye,
  ArrowRight,
  ExternalLink,
  Phone,
  Mail,
  Droplet,
  Sparkles,
  Activity,
  HeartPulse,
  ShieldAlert,
} from "lucide-react";
import {
  PatientSummary,
  MedicalRecord,
  MedicalHistoryItem,
} from "@/types/medical_record";
import RecordStatusBadge from "@/components/medical_record/badges/record_status_badge";
import { useTranslation } from "@/context/language_context";

interface PatientSummaryTabProps {
  patient: PatientSummary;
  record: MedicalRecord;
  priorVisits: MedicalHistoryItem[];
  onStartConsultation: () => void;
  onContinueConsultation: (step: 1 | 2 | 3) => void;
  onViewFinalizedRecord: () => void;
  onSelectPriorVisit?: (visit: MedicalHistoryItem) => void;
}

export default function PatientSummaryTab({
  patient,
  record,
  priorVisits,
  onStartConsultation,
  onContinueConsultation,
  onViewFinalizedRecord,
  onSelectPriorVisit,
}: PatientSummaryTabProps) {
  const { translations } = useTranslation();
  const last3Visits = priorVisits.slice(0, 3);
  const allergies = patient.activeAllergies || [];
  const chronicConditions = patient.chronicConditions || [];

  const formatSeverity = (sev: string) => {
    if ("SEVERE" === sev) return translations.severity_severe;
    if ("MODERATE" === sev) return translations.severity_moderate;
    return translations.severity_mild;
  };

  const formatGender = (g: string) => {
    if ("Male" === g || "ذكر" === g) return translations.male;
    if ("Female" === g || "أنثى" === g) return translations.female;
    return g;
  };

  const getStepProgressText = (step: number) => {
    return translations.step_progress
      .replace("{current}", String(step))
      .replace("{total}", "3");
  };

  const getLastSavedText = () => {
    const timeStr = record.lastSavedAtUtc
      ? new Date(record.lastSavedAtUtc).toLocaleTimeString()
      : "—";
    const docStr = record.doctorName || "Dr. Nada Khan";
    return translations.last_saved_by
      .replace("{time}", timeStr)
      .replace("{doctor}", docStr);
  };

  return (
    <div className="space-y-4 animate-in fade-in duration-300">
      {/* 1. Compact Equal-Height Top 3-Card Row */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 md:gap-5 items-stretch mb-4">
        {/* Card 1: Patient Demographic Profile */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-2 dark:border-slate-700/90 shadow-xs dark:shadow-none rounded-2xl p-4 md:p-5 h-full flex flex-col justify-between space-y-4">
          <div className="space-y-3.5">
            <div className="flex items-center justify-between">
              <span className="px-3 py-1 text-[11px] font-extrabold uppercase tracking-wider bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 rounded-full border border-blue-200/80 dark:border-blue-800/60">
                {translations.patient_selected}
              </span>
              <span className="text-xs font-mono font-bold text-slate-500 dark:text-slate-400">
                {patient.patientId}
              </span>
            </div>

            <div className="flex items-center gap-3.5">
              <div className="relative h-14 w-14 md:h-16 md:w-16 overflow-hidden rounded-xl ring-2 ring-slate-100 dark:ring-slate-800 shrink-0">
                <Image
                  src={patient.avatarUrl || "/images/profile_icon.jpeg"}
                  alt={patient.fullName}
                  width={64}
                  height={64}
                  className="h-full w-full object-cover"
                />
              </div>
              <div className="overflow-hidden text-start space-y-0.5">
                <h2 className="text-lg md:text-xl font-bold text-slate-900 dark:text-white truncate">
                  {patient.fullName}
                </h2>
                <p className="text-xs font-medium text-slate-600 dark:text-slate-300">
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.age}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white">{patient.calculatedAge} {translations.years}</strong> •{" "}
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.gender}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white">{formatGender(patient.gender)}</strong>
                </p>
                {patient.bloodType && (
                  <div className="flex items-center gap-1 text-xs font-bold text-rose-600 dark:text-rose-400 pt-0.5">
                    <Droplet className="w-3.5 h-3.5" /> {patient.bloodType}
                  </div>
                )}
              </div>
            </div>

            {/* Layer 2: Demographic Contact Info Box */}
            <div className="bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-2 dark:border-slate-700/70 rounded-xl p-3 md:p-3.5 space-y-1.5 text-xs text-slate-700 dark:text-slate-200 font-medium mt-2.5">
              {patient.phone && (
                <p className="flex items-center gap-2.5">
                  <Phone className="w-3.5 h-3.5 text-slate-400 dark:text-slate-500 shrink-0" /> {patient.phone}
                </p>
              )}
              {patient.email && (
                <p className="flex items-center gap-2.5 truncate">
                  <Mail className="w-3.5 h-3.5 text-slate-400 dark:text-slate-500 shrink-0" /> {patient.email}
                </p>
              )}
            </div>
          </div>

          <button
            type="button"
            onClick={() => alert(`Profile of ${patient.fullName}`)}
            className="text-xs font-bold text-blue-600 dark:text-blue-400 hover:underline inline-flex items-center gap-1.5 self-start pt-1"
          >
            <User className="w-3.5 h-3.5" />
            {translations.view_full_profile}
            <ExternalLink className="w-3 h-3" />
          </button>
        </div>

        {/* Card 2: Appointment Consultation Details */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-2 dark:border-slate-700/90 shadow-xs dark:shadow-none rounded-2xl p-4 md:p-5 h-full flex flex-col justify-between space-y-4">
          <div className="space-y-3.5">
            <div className="flex items-center justify-between">
              <span className="px-3 py-1 text-[11px] font-extrabold uppercase tracking-wider bg-slate-100 dark:bg-[#131E35] text-slate-700 dark:text-slate-300 rounded-full border border-slate-200/60 dark:border-slate-700/50">
                {translations.appointment_information}
              </span>
              <span className="text-xs font-mono font-bold text-slate-500 dark:text-slate-400">
                {record.appointmentId}
              </span>
            </div>

            <div className="space-y-2 text-xs text-slate-600 dark:text-slate-300 font-medium">
              <div className="flex items-center gap-2.5">
                <Calendar className="w-3.5 h-3.5 text-blue-500 shrink-0" />
                <span>
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.date}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white text-xs">{record.consultationDate || "2026-08-18"}</strong>
                </span>
              </div>
              <div className="flex items-center gap-2.5">
                <Clock className="w-3.5 h-3.5 text-blue-500 shrink-0" />
                <span>
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.time}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white text-xs">10:00 AM - 10:30 AM</strong>
                </span>
              </div>
              <div className="flex items-center gap-2.5">
                <Building2 className="w-3.5 h-3.5 text-blue-500 shrink-0" />
                <span className="truncate">
                  <span className="font-semibold text-slate-500 dark:text-slate-400">{translations.nav_clinics || "Clinic"}:</span>{" "}
                  <strong className="text-slate-900 dark:text-white text-xs">{record.clinicName || "Main Cardiology Clinic"}</strong>
                </span>
              </div>
            </div>

            {/* Layer 2: Clinical Outcome Box */}
            <div className="bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-2 dark:border-slate-700/70 rounded-xl p-3 md:p-3.5 space-y-0.5 mt-2.5">
              <p className="font-bold text-[10px] uppercase tracking-wider text-blue-600 dark:text-blue-400">
                {translations.medrec_outcome_title}
              </p>
              <p className="text-sm font-bold text-slate-900 dark:text-white">
                {record.clinicalOutcome.replace(/_/g, " ")}
              </p>
            </div>
          </div>

          <p className="text-xs font-medium text-slate-500 dark:text-slate-400 pt-1">
            {translations.doctor}: <strong className="text-slate-900 dark:text-white">{record.doctorName || "Dr. Nada Khan"}</strong>
          </p>
        </div>

        {/* Card 3: Medical Record State & Dynamic CTAs */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-2 dark:border-slate-700/90 shadow-xs dark:shadow-none rounded-2xl p-4 md:p-5 h-full flex flex-col justify-between space-y-4">
          <div className="space-y-3.5">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-slate-700 dark:text-slate-200 uppercase tracking-wider">
                {translations.filter_record_status}
              </span>

              {/* Status Badge */}
              {"NOT_STARTED" === record.status && (
                <span className="bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold px-3 py-1 rounded-full text-[11px] border border-slate-200 dark:border-slate-700">
                  {translations.not_started}
                </span>
              )}

              {"DRAFT" === record.status && (
                <span className="bg-amber-100 dark:bg-amber-950/60 text-amber-800 dark:text-amber-300 font-bold px-3 py-1 rounded-full text-[11px] border border-amber-200 dark:border-amber-800 animate-pulse">
                  {translations.draft} ({getStepProgressText(record.currentStep)})
                </span>
              )}

              {"FINALIZED" === record.status && (
                <span
                  className={`px-3 py-1 rounded-full text-[11px] font-bold ${
                    "FINALIZED_WITH_AMENDMENTS" === record.displayState
                      ? "bg-purple-100 dark:bg-purple-950/60 text-purple-800 dark:text-purple-300 border border-purple-200 dark:border-purple-800"
                      : "bg-emerald-100 dark:bg-emerald-950/60 text-emerald-800 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800"
                  }`}
                >
                  {"FINALIZED_WITH_AMENDMENTS" === record.displayState
                    ? translations.finalized_with_amendments
                    : translations.finalized}
                </span>
              )}
            </div>

            {/* Description / Progress info in Layer 2 Box */}
            <div className="bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-2 dark:border-slate-700/70 rounded-xl p-3 md:p-3.5 space-y-1.5 text-xs text-slate-600 dark:text-slate-300 mt-2.5">
              {"NOT_STARTED" === record.status && (
                <div className="space-y-1">
                  <p className="font-bold text-sm text-slate-900 dark:text-white">
                    {translations.consultation_not_started}
                  </p>
                  <p className="text-slate-500 dark:text-slate-400 leading-relaxed text-xs">
                    {translations.create_record_hint}
                  </p>
                </div>
              )}

              {"DRAFT" === record.status && (
                <div className="space-y-2">
                  <p className="text-xs font-medium">{getLastSavedText()}</p>
                  <div className="w-full bg-slate-200 dark:bg-slate-800 rounded-full h-2">
                    <div
                      className="bg-amber-500 h-2 rounded-full transition-all"
                      style={{
                        width: `${(record.currentStep / 3) * 100}%`,
                      }}
                    />
                  </div>
                </div>
              )}

              {"FINALIZED" === record.status && (
                <div className="space-y-1">
                  <p className="text-emerald-600 dark:text-emerald-400 font-bold text-sm">
                    ✓ {translations.finalized}
                  </p>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    {translations.last_updated.replace("{time}", record.finalizedAtUtc || "2026-08-18")}
                  </p>
                  {record.amendmentNotes && (
                    <p className="text-xs text-purple-600 dark:text-purple-400 italic">
                      {record.amendmentNotes}
                    </p>
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Action CTAs */}
          <div>
            {"NOT_STARTED" === record.status && (
              <button
                type="button"
                onClick={onStartConsultation}
                className="w-full py-2.5 md:py-3 px-4 text-sm font-semibold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-xs transition flex items-center justify-center gap-2 cursor-pointer mt-3"
              >
                <Sparkles className="w-4 h-4" />
                {translations.create_medical_record}
              </button>
            )}

            {"DRAFT" === record.status && (
              <button
                type="button"
                onClick={() => onContinueConsultation(record.currentStep)}
                className="w-full py-2.5 md:py-3 px-4 text-sm font-semibold text-white bg-amber-600 hover:bg-amber-700 rounded-xl shadow-xs transition flex items-center justify-center gap-2 cursor-pointer mt-3"
              >
                <ArrowRight className="w-4 h-4 rtl:rotate-180" />
                {translations.continue_medical_record} ({getStepProgressText(record.currentStep)})
              </button>
            )}

            {"FINALIZED" === record.status && (
              <button
                type="button"
                onClick={onViewFinalizedRecord}
                className="w-full py-2.5 md:py-3 px-4 text-sm font-semibold text-white bg-emerald-600 hover:bg-emerald-700 rounded-xl shadow-xs transition flex items-center justify-center gap-2 cursor-pointer mt-3"
              >
                <FileCheck className="w-4 h-4" />
                {translations.view_medical_record}
              </button>
            )}
          </div>
        </div>
      </div>

      {/* 2. Compact Allergies & Chronic Conditions Clinical Banner */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-2 dark:border-slate-700/80 rounded-2xl p-4 md:p-5 shadow-xs mb-4 space-y-3.5">
        <div className="flex items-center justify-between border-b border-slate-100 dark:border-slate-800/80 pb-2.5">
          <div className="flex items-center gap-2.5">
            <div className="p-2 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-lg">
              <HeartPulse className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
                {translations.allergies_and_conditions}
              </h3>
              <p className="text-[11px] text-slate-500 dark:text-slate-400">
                {translations.patient_selected} • {patient.fullName}
              </p>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          {/* Section 1: Drug & Food Allergies */}
          <div className="bg-rose-50/70 dark:bg-rose-950/20 border border-rose-200/90 dark:border-rose-900/50 rounded-xl p-3.5 space-y-2.5 flex flex-col justify-between">
            <div className="space-y-2.5">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 font-bold text-sm text-rose-900 dark:text-rose-200">
                  <ShieldAlert className="w-4 h-4 text-rose-600 dark:text-rose-400" />
                  <span>{translations.allergies}</span>
                </div>
                <span className="px-2.5 py-0.5 text-xs font-bold bg-rose-100 dark:bg-rose-900/60 text-rose-800 dark:text-rose-200 rounded-full border border-rose-200 dark:border-rose-800">
                  {allergies.length}
                </span>
              </div>

              {allergies.length > 0 ? (
                <div className="flex flex-wrap gap-2">
                  {allergies.map((alg, index) => (
                    <div
                      key={index}
                      className="inline-flex items-start gap-2 bg-white dark:bg-[#1C1418] border-2 border-rose-200/90 dark:border-rose-800/80 rounded-lg px-3 py-1.5 text-xs font-semibold shadow-2xs text-rose-950 dark:text-rose-100"
                    >
                      <span className="w-2 h-2 rounded-full bg-rose-500 shrink-0 mt-1" />
                      <div>
                        <p className="font-bold">{alg.name}</p>
                        <p className="text-[11px] font-medium text-rose-700 dark:text-rose-300">
                          {formatSeverity(alg.severity)}
                          {alg.reaction ? ` • ${alg.reaction}` : ""}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="flex items-center gap-2 p-2.5 bg-white/80 dark:bg-[#1C1418]/60 border border-rose-200 dark:border-rose-800/50 rounded-lg text-emerald-700 dark:text-emerald-300 text-xs font-bold">
                  <ShieldCheck className="w-3.5 h-3.5 text-emerald-600 dark:text-emerald-400" />
                  {translations.no_known_allergies}
                </div>
              )}
            </div>
          </div>

          {/* Section 2: Chronic Medical Conditions */}
          <div className="bg-sky-50/70 dark:bg-sky-950/20 border border-sky-200/90 dark:border-sky-900/50 rounded-xl p-3.5 space-y-2.5 flex flex-col justify-between">
            <div className="space-y-2.5">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 font-bold text-sm text-sky-900 dark:text-sky-200">
                  <Activity className="w-4 h-4 text-sky-600 dark:text-sky-400" />
                  <span>{translations.chronic_conditions}</span>
                </div>
                <span className="px-2.5 py-0.5 text-xs font-bold bg-sky-100 dark:bg-sky-900/60 text-sky-800 dark:text-sky-200 rounded-full border border-sky-200 dark:border-sky-800">
                  {chronicConditions.length}
                </span>
              </div>

              {chronicConditions.length > 0 ? (
                <div className="flex flex-wrap gap-2">
                  {chronicConditions.map((cond) => (
                    <div
                      key={cond.id}
                      className="inline-flex items-start gap-2 bg-white dark:bg-[#111F35] border-2 border-sky-200/90 dark:border-sky-800/80 rounded-lg px-3 py-1.5 text-xs font-semibold shadow-2xs text-sky-950 dark:text-sky-100"
                    >
                      <span className="w-2 h-2 rounded-full bg-sky-500 shrink-0 mt-1" />
                      <div>
                        <div className="flex items-center gap-1.5">
                          <span className="font-bold">{cond.name}</span>
                          {cond.icd10Code && (
                            <span className="px-1 py-0.2 text-[9px] font-mono font-bold bg-sky-100 dark:bg-sky-900/60 text-sky-800 dark:text-sky-300 rounded">
                              {cond.icd10Code}
                            </span>
                          )}
                        </div>
                        <p className="text-[11px] font-medium text-sky-700 dark:text-sky-300 mt-0.5">
                          {cond.status === "CONTROLLED" ? translations.controlled : translations.active}
                          {cond.diagnosedYear ? ` • ${translations.diagnosed_in} ${cond.diagnosedYear}` : ""}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="flex items-center gap-2 p-2.5 bg-white/80 dark:bg-[#111F35]/60 border border-sky-200 dark:border-sky-800/50 rounded-lg text-sky-700 dark:text-sky-300 text-xs font-semibold">
                  <ShieldCheck className="w-3.5 h-3.5 text-sky-600 dark:text-sky-400" />
                  {translations.no_chronic_conditions}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* 3. Compact Last 3 Visits (Continuity of Care) Table */}
      <div className="border-2 border-slate-200 dark:border-2 dark:border-slate-700/90 rounded-2xl overflow-hidden shadow-xs bg-white dark:bg-[#0E1726]">
        <div className="p-4 md:p-5 border-b-2 border-slate-200 dark:border-slate-700 flex items-center justify-between">
          <div className="text-start">
            <h3 className="text-lg md:text-xl font-bold text-slate-900 dark:text-white">
              {translations.last_3_visits}
            </h3>
            <p className="text-xs font-semibold text-slate-500 dark:text-slate-400">
              {translations.patient_summary} • {last3Visits.length}
            </p>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-start">
            <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 py-3.5 px-6 text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              <tr>
                <th className="py-3.5 px-6 text-start min-w-[120px] whitespace-nowrap">{translations.visit_date}</th>
                <th className="py-3.5 px-6 text-start min-w-[200px]">{translations.primary_diagnosis}</th>
                <th className="py-3.5 px-6 text-start min-w-[150px]">{translations.doctor}</th>
                <th className="py-3.5 px-6 text-start min-w-[140px]">{translations.nav_clinics || "Clinic"}</th>
                <th className="py-3.5 px-6 text-start min-w-[190px] whitespace-nowrap">{translations.filter_record_status}</th>
                <th className="py-3.5 px-6 text-center w-16 whitespace-nowrap">{translations.actions}</th>
              </tr>
            </thead>
            <tbody className="divide-y-2 divide-slate-100 dark:divide-slate-800">
              {last3Visits.map((visit) => (
                <tr
                  key={visit.recordId}
                  className="hover:bg-slate-50/80 dark:hover:bg-slate-800/40 text-slate-800 dark:text-slate-200 text-sm font-medium transition-colors"
                >
                  <td className="py-4 px-6 min-w-[120px] whitespace-nowrap font-medium text-sm text-slate-900 dark:text-slate-100">
                    {visit.visitDate}
                  </td>
                  <td className="py-4 px-6 min-w-[200px]">
                    <div className="flex items-center gap-2.5">
                      <span className="font-mono font-bold text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-950/60 px-2.5 py-1 rounded-md text-xs border border-blue-200/80 dark:border-blue-800/60 shrink-0">
                        {visit.primaryDiagnosisCode}
                      </span>
                      <span className="font-bold text-slate-900 dark:text-white text-sm truncate">
                        {visit.primaryDiagnosisName}
                      </span>
                    </div>
                  </td>
                  <td className="py-4 px-6 min-w-[150px] text-slate-700 dark:text-slate-300 text-sm">
                    {visit.doctorName}
                  </td>
                  <td className="py-4 px-6 min-w-[140px] text-slate-600 dark:text-slate-400 text-sm">
                    {visit.clinicName || "General Care"}
                  </td>
                  <td className="py-4 px-6 min-w-[190px] whitespace-nowrap">
                    <RecordStatusBadge
                      status={visit.status}
                      hasAmendments={visit.hasAmendments}
                    />
                  </td>
                  <td className="py-4 px-6 text-center w-16">
                    <button
                      type="button"
                      onClick={() =>
                        onSelectPriorVisit
                          ? onSelectPriorVisit(visit)
                          : alert(`Viewing details for Record: ${visit.recordId}`)
                      }
                      className="p-2 rounded-lg border border-slate-200 dark:border-slate-700 hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-500 hover:text-slate-900 dark:hover:text-white transition-colors cursor-pointer inline-flex items-center justify-center"
                      title={translations.view}
                    >
                      <Eye className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

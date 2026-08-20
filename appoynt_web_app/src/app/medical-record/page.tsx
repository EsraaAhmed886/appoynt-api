/*
 * File Name: page.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - next/navigation
 *   - lucide-react
 *   - @/context/medical_record_context
 *   - @/hooks/use_medical_record
 *   - @/components/medical_record/medical_record_layout
 *   - @/components/medical_record/medical_record_stepper
 *   - @/components/medical-record/tabs/patient_summary_tab
 *   - @/components/medical-record/tabs/medical_history_tab
 *   - @/components/medical-record/steps/step1_diagnoses
 *   - @/components/medical-record/steps/step2_medications
 *   - @/components/medical-record/steps/step3_tests
 *   - @/components/medical-record/views/finalized_record_details_view
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Canonical production Medical Record Dashboard (/medical-record) managing top-level 2-tab navigation (Patient Summary, Medical History), dedicated 3-step full-width consultation workflow, and read-only finalized views.
 */

"use client";

import React, { useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import {
  AlertCircle,
  Sparkles,
  ArrowLeft,
} from "lucide-react";
import {
  MedicalRecordWorkflowProvider,
  useMedicalRecordWorkflow,
} from "@/context/medical_record_context";
import {
  useMedicalRecordQuery,
  useMedicalHistoryQuery,
} from "@/hooks/use_medical_record";
import MedicalRecordLayout from "@/components/medical_record/medical_record_layout";
import MedicalRecordStepper from "@/components/medical_record/medical_record_stepper";
import PatientSummaryTab from "@/components/medical-record/tabs/patient_summary_tab";
import MedicalHistoryTab from "@/components/medical-record/tabs/medical_history_tab";
import Step1Diagnoses from "@/components/medical-record/steps/step1_diagnoses";
import Step2Medications from "@/components/medical-record/steps/step2_medications";
import Step3Tests from "@/components/medical-record/steps/step3_tests";
import FinalizedRecordDetailsView from "@/components/medical-record/views/finalized_record_details_view";
import { MedicalRecord, PatientSummary, MedicalHistoryItem } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

function ConsultationWorkflowContainer({
  onExitConsultation,
  onViewFinalized,
}: {
  onExitConsultation: () => void;
  onViewFinalized: () => void;
}) {
  const { record, currentStep, startConsultation } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  if ("FINALIZED" === record.status) {
    onViewFinalized();
    return null;
  }

  if ("NOT_STARTED" === record.status) {
    return (
      <div className="flex flex-col items-center justify-center p-12 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 text-center space-y-4 shadow-xs">
        <div className="w-16 h-16 bg-blue-50 dark:bg-blue-950/60 rounded-full flex items-center justify-center text-blue-600 dark:text-blue-400">
          <Sparkles className="w-8 h-8" />
        </div>
        <div className="space-y-1 max-w-sm">
          <h2 className="text-base font-bold text-slate-900 dark:text-slate-100">
            {translations.consultation_not_started}
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {translations.create_record_hint}
          </p>
        </div>
        <div className="flex items-center gap-3">
          <button
            type="button"
            onClick={onExitConsultation}
            className="px-4 py-2.5 text-xs font-semibold text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition cursor-pointer"
          >
            ← {translations.btn_back || "Back to Summary"}
          </button>
          <button
            type="button"
            onClick={startConsultation}
            className="px-6 py-2.5 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer"
          >
            <Sparkles className="w-4 h-4" />
            {translations.create_medical_record}
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {/* Return to summary bar */}
      <div className="flex items-center justify-between pb-1">
        <button
          type="button"
          onClick={onExitConsultation}
          className="text-xs font-semibold text-slate-600 dark:text-slate-400 hover:text-blue-600 dark:hover:text-blue-400 inline-flex items-center gap-1.5 cursor-pointer transition"
        >
          <ArrowLeft className="w-3.5 h-3.5 rtl:rotate-180" />
          <span>{translations.btn_back || "Back to Patient Summary"}</span>
        </button>
        <span className="text-xs font-medium text-slate-400 dark:text-slate-500">
          {translations.appointment || "Appointment"}: {record.appointmentId}
        </span>
      </div>

      {/* Scaled 3-Step Breadcrumb Progress Stepper */}
      <MedicalRecordStepper />

      {/* Step Viewport */}
      <div>
        {1 === currentStep && <Step1Diagnoses />}
        {2 === currentStep && <Step2Medications />}
        {3 === currentStep && <Step3Tests />}
      </div>
    </div>
  );
}

function MedicalRecordSinglePageInner() {
  const searchParams = useSearchParams();
  const appointmentId = searchParams.get("appointmentId") || "apt-101";

  const [viewingFinalizedId, setViewingFinalizedId] = useState<string | null>(null);

  const {
    record: initialRecord,
    patient,
    isLoading,
    isError,
    errorMessage,
    setRecord,
  } = useMedicalRecordQuery(appointmentId);

  const { historyItems } = useMedicalHistoryQuery(
    patient?.patientId || "PAT-88219",
    1
  );

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[#F1F5F9] dark:bg-[#070D1E] text-slate-900 dark:text-slate-100">
        <div className="text-center space-y-3">
          <div className="w-10 h-10 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto" />
          <p className="text-xs font-semibold text-slate-500">
            Loading Medical Record Consultation...
          </p>
        </div>
      </div>
    );
  }

  if (isError || !initialRecord) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-[#F1F5F9] dark:bg-[#070D1E] text-slate-900 dark:text-slate-100 p-4">
        <div className="max-w-md bg-white dark:bg-[#0E1726] p-6 rounded-2xl border-2 border-rose-200 dark:border-rose-800 text-center space-y-3">
          <AlertCircle className="w-10 h-10 text-rose-500 mx-auto" />
          <h2 className="text-base font-bold text-rose-900 dark:text-rose-200">
            Unable to Load Medical Record
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {errorMessage || "The requested consultation session was not found."}
          </p>
        </div>
      </div>
    );
  }

  return (
    <MedicalRecordWorkflowProvider
      initialRecord={initialRecord}
      patient={patient}
      onRecordUpdated={(updated: MedicalRecord) => setRecord(updated)}
    >
      <SinglePageWorkflowConsumer
        patient={patient}
        priorVisits={historyItems}
        viewingFinalizedId={viewingFinalizedId}
        setViewingFinalizedId={setViewingFinalizedId}
      />
    </MedicalRecordWorkflowProvider>
  );
}

function SinglePageWorkflowConsumer({
  patient,
  priorVisits,
  viewingFinalizedId,
  setViewingFinalizedId,
}: {
  patient: PatientSummary | null;
  priorVisits: MedicalHistoryItem[];
  viewingFinalizedId: string | null;
  setViewingFinalizedId: (id: string | null) => void;
}) {
  const { record, activeTab, setActiveTab, setCurrentStep, startConsultation } =
    useMedicalRecordWorkflow();

  const fallbackPatient: PatientSummary = patient || {
    patientId: record.patientId,
    fullName: "Sarah Jenkins",
    calculatedAge: 38,
    gender: "Female",
    dateOfBirth: "1988-04-12",
    activeAllergies: [],
  };

  return (
    <MedicalRecordLayout patient={fallbackPatient} record={record}>
      {viewingFinalizedId ? (
        <div className="space-y-4">
          <FinalizedRecordDetailsView
            record={record}
            onBack={() => setViewingFinalizedId(null)}
          />
        </div>
      ) : "consultation" === activeTab ? (
        "FINALIZED" === record.status ? (
          <FinalizedRecordDetailsView
            record={record}
            onBack={() => setActiveTab("summary")}
          />
        ) : (
          <ConsultationWorkflowContainer
            onExitConsultation={() => setActiveTab("summary")}
            onViewFinalized={() => setViewingFinalizedId(record.recordId)}
          />
        )
      ) : "history" === activeTab ? (
        <MedicalHistoryTab
          patientId={patient?.patientId || record.patientId}
          onViewRecordDetail={(recordId) => setViewingFinalizedId(recordId)}
        />
      ) : (
        <PatientSummaryTab
          patient={fallbackPatient}
          record={record}
          priorVisits={priorVisits}
          onStartConsultation={() => {
            startConsultation();
            setActiveTab("consultation");
          }}
          onContinueConsultation={(step) => {
            setCurrentStep(step);
            setActiveTab("consultation");
          }}
          onViewFinalizedRecord={() => setViewingFinalizedId(record.recordId)}
          onSelectPriorVisit={(visit) => setViewingFinalizedId(visit.recordId)}
        />
      )}
    </MedicalRecordLayout>
  );
}

export default function MedicalRecordSinglePage() {
  return (
    <Suspense
      fallback={
        <div className="flex min-h-screen items-center justify-center bg-[#F1F5F9] dark:bg-[#070D1E] text-slate-900 dark:text-slate-100">
          <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      }
    >
      <MedicalRecordSinglePageInner />
    </Suspense>
  );
}

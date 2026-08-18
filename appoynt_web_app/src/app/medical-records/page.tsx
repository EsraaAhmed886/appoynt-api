/*
 * File Name: page.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - next/navigation
 *   - lucide-react
 *   - @/context/medical_record_context
 *   - @/hooks/use_medical_record
 *   - @/components/medical_record/medical_record_layout
 *   - @/components/medical_record/medical_record_stepper
 *   - @/components/medical_record/tabs/patient_summary_tab
 *   - @/components/medical_record/tabs/medical_history_tab
 *   - @/components/medical_record/steps/step1_diagnoses
 *   - @/components/medical_record/steps/step2_medications
 *   - @/components/medical_record/steps/step3_tests
 *   - @/components/medical_record/views/finalized_record_details_view
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Clean production Medical Record Dashboard (/medical-records) defaulting to Not Started state and driving natural consultation lifecycle transitions with scaled workflow Stepper.
 */

"use client";

import React, { useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";
import {
  AlertCircle,
  Sparkles,
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
import PatientSummaryTab from "@/components/medical_record/tabs/patient_summary_tab";
import MedicalHistoryTab from "@/components/medical_record/tabs/medical_history_tab";
import Step1Diagnoses from "@/components/medical_record/steps/step1_diagnoses";
import Step2Medications from "@/components/medical_record/steps/step2_medications";
import Step3Tests from "@/components/medical_record/steps/step3_tests";
import FinalizedRecordDetailsView from "@/components/medical_record/views/finalized_record_details_view";
import { MedicalRecord } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

function ConsultationStepperContent({
  onViewFinalized,
}: {
  onViewFinalized: () => void;
}) {
  const { record, currentStep, startConsultation } =
    useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  if ("FINALIZED" === record.status) {
    onViewFinalized();
    return null;
  }

  if ("NOT_STARTED" === record.status) {
    return (
      <div className="flex flex-col items-center justify-center p-12 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 text-center space-y-4 shadow-xs">
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
        <button
          type="button"
          onClick={startConsultation}
          className="px-6 py-2.5 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer"
        >
          <Sparkles className="w-4 h-4" />
          {translations.create_medical_record}
        </button>
      </div>
    );
  }

  return (
    <div className="space-y-4">
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
      <div className="flex min-h-screen items-center justify-center bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100">
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
      <div className="flex min-h-screen items-center justify-center bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 p-4">
        <div className="max-w-md bg-white dark:bg-slate-900 p-6 rounded-2xl border border-red-200 dark:border-red-800 text-center space-y-3">
          <AlertCircle className="w-10 h-10 text-red-500 mx-auto" />
          <h2 className="text-base font-bold text-red-900 dark:text-red-200">
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
  patient: any;
  priorVisits: any[];
  viewingFinalizedId: string | null;
  setViewingFinalizedId: (id: string | null) => void;
}) {
  const { record, activeTab, setActiveTab, setCurrentStep, startConsultation } =
    useMedicalRecordWorkflow();

  return (
    <MedicalRecordLayout patient={patient} record={record}>
      {viewingFinalizedId ? (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <button
              type="button"
              onClick={() => setViewingFinalizedId(null)}
              className="text-xs font-semibold text-blue-600 dark:text-blue-400 hover:underline inline-flex items-center gap-1 cursor-pointer"
            >
              ← Back to Overview
            </button>
            <span className="text-xs font-mono text-slate-400">
              Viewing Record: {viewingFinalizedId}
            </span>
          </div>
          <FinalizedRecordDetailsView record={record} />
        </div>
      ) : "summary" === activeTab ? (
        <PatientSummaryTab
          patient={
            patient || {
              patientId: record.patientId,
              fullName: "Sarah Jenkins",
              calculatedAge: 38,
              gender: "Female",
              dateOfBirth: "1988-04-12",
              activeAllergies: [],
            }
          }
          record={record}
          priorVisits={priorVisits}
          onStartConsultation={startConsultation}
          onContinueConsultation={(step) => {
            setCurrentStep(step);
            setActiveTab("consultation");
          }}
          onViewFinalizedRecord={() => setViewingFinalizedId(record.recordId)}
          onSelectPriorVisit={(visit) => setViewingFinalizedId(visit.recordId)}
        />
      ) : "consultation" === activeTab ? (
        "FINALIZED" === record.status ? (
          <FinalizedRecordDetailsView record={record} />
        ) : (
          <ConsultationStepperContent
            onViewFinalized={() => setViewingFinalizedId(record.recordId)}
          />
        )
      ) : (
        <MedicalHistoryTab
          patientId={patient?.patientId || record.patientId}
          onViewRecordDetail={(recordId) => setViewingFinalizedId(recordId)}
        />
      )}
    </MedicalRecordLayout>
  );
}

export default function MedicalRecordSinglePage() {
  return (
    <Suspense
      fallback={
        <div className="flex min-h-screen items-center justify-center bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100">
          <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
        </div>
      }
    >
      <MedicalRecordSinglePageInner />
    </Suspense>
  );
}

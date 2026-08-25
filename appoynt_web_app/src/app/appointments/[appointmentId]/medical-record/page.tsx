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
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Master Next.js dynamic App Router entry point (/appointments/[appointmentId]/medical-record) orchestrating layout shells, scaled clinical workflow steppers, patient summaries, and history tabs driven naturally by doctor actions with zero mock UI bars.
 */

"use client";

import React, { useState, use } from "react";
import { useRouter } from "next/navigation";
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
import PatientSummaryTab from "@/components/medical_record/tabs/patient_summary_tab";
import MedicalHistoryTab from "@/components/medical_record/tabs/medical_history_tab";
import Step1Diagnoses from "@/components/medical_record/steps/step1_diagnoses";
import Step2Medications from "@/components/medical_record/steps/step2_medications";
import Step3Tests from "@/components/medical_record/steps/step3_tests";
import FinalizedRecordDetailsView from "@/components/medical_record/views/finalized_record_details_view";
import { MedicalRecord } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

interface PageProps {
  params: Promise<{
    appointmentId: string;
  }>;
}

/**
 * Inner consultation stepper content consuming workflow context
 */
function ClinicalConsultationContent({
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
  } else {
    // No action needed
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
  } else {
    // No action needed
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

export default function MedicalRecordPage({ params }: PageProps) {
  const resolvedParams = use(params);
  const appointmentId = resolvedParams.appointmentId;
  const router = useRouter();
  const { translations } = useTranslation();

  const [viewingFinalizedId, setViewingFinalizedId] = useState<string | null>(
    null
  );

  const {
    record: initialRecord,
    patient: patientSummary,
    isLoading,
    isError,
    errorMessage,
    setRecord,
  } = useMedicalRecordQuery(appointmentId);

  const { historyItems } = useMedicalHistoryQuery(
    patientSummary?.patientId || "PAT-88219",
    1
  );

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100">
        <div className="text-center space-y-3">
          <div className="w-10 h-10 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto" />
          <p className="text-xs font-semibold text-slate-500">
            Loading Medical Record Dashboard...
          </p>
        </div>
      </div>
    );
  } else {
    // No action needed
  }

  if (isError || !initialRecord) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-slate-50 dark:bg-slate-950 text-slate-900 dark:text-slate-100 p-4">
        <div className="max-w-md bg-white dark:bg-slate-900 p-6 rounded-2xl border border-red-200 dark:border-red-800 text-center space-y-3">
          <AlertCircle className="w-10 h-10 text-red-500 mx-auto" />
          <h2 className="text-base font-bold text-red-900 dark:text-red-200">
            Failed to Load Medical Record
          </h2>
          <p className="text-xs text-slate-500 dark:text-slate-400">
            {errorMessage || "Unable to retrieve consultation details for this appointment ID."}
          </p>
          <button
            type="button"
            onClick={() => router.push("/clinics")}
            className="px-4 py-2 text-xs font-semibold text-white bg-blue-600 hover:bg-blue-700 rounded-xl transition cursor-pointer"
          >
            Return to Clinics
          </button>
        </div>
      </div>
    );
  } else {
    // No action needed
  }

  return (
    <MedicalRecordWorkflowProvider
      initialRecord={initialRecord}
      patient={patientSummary}
      onRecordUpdated={(updated: MedicalRecord) => setRecord(updated)}
    >
      <WorkflowPageConsumer
        patientSummary={patientSummary}
        historyItems={historyItems}
        viewingFinalizedId={viewingFinalizedId}
        setViewingFinalizedId={setViewingFinalizedId}
      />
    </MedicalRecordWorkflowProvider>
  );
}

function WorkflowPageConsumer({
  patientSummary,
  historyItems,
  viewingFinalizedId,
  setViewingFinalizedId,
}: {
  patientSummary: any;
  historyItems: any[];
  viewingFinalizedId: string | null;
  setViewingFinalizedId: (id: string | null) => void;
}) {
  const {
    record: medicalRecord,
    activeTab,
    setActiveTab,
    setCurrentStep,
    startConsultation,
  } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  return (
    <MedicalRecordLayout
      patient={patientSummary}
      record={medicalRecord}
    >
      {viewingFinalizedId ? (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <button
              type="button"
              onClick={() => setViewingFinalizedId(null)}
              className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700/80 bg-white dark:bg-[#131E35] text-slate-700 dark:text-slate-200 text-sm font-semibold hover:bg-slate-50 dark:hover:bg-slate-800 hover:border-slate-300 dark:hover:border-slate-600 shadow-2xs transition-all cursor-pointer group"
            >
              <ArrowLeft className="w-4 h-4 text-slate-500 dark:text-slate-400 group-hover:text-slate-900 dark:group-hover:text-white group-hover:-translate-x-0.5 transition-transform rtl:rotate-180 rtl:group-hover:translate-x-0.5" />
              <span>{translations.back_to_summary || translations.btn_back || "Back to Patient Summary"}</span>
            </button>
            <span className="text-xs font-mono text-slate-400">
              Viewing Record: {viewingFinalizedId}
            </span>
          </div>
          <FinalizedRecordDetailsView
            record={medicalRecord}
            patient={patientSummary}
            onBackToSummary={() => setViewingFinalizedId(null)}
          />
        </div>
      ) : "summary" === activeTab ? (
        <PatientSummaryTab
          patient={
            patientSummary || {
              patientId: medicalRecord.patientId,
              fullName: "Sarah Jenkins",
              calculatedAge: 38,
              gender: "Female",
              dateOfBirth: "1988-04-12",
              activeAllergies: [],
            }
          }
          record={medicalRecord}
          priorVisits={historyItems}
          onStartConsultation={startConsultation}
          onContinueConsultation={(step) => {
            setCurrentStep(step);
            setActiveTab("consultation");
          }}
          onViewFinalizedRecord={() => setViewingFinalizedId(medicalRecord.recordId)}
          onSelectPriorVisit={(visit) => setViewingFinalizedId(visit.recordId)}
        />
      ) : "consultation" === activeTab ? (
        "FINALIZED" === medicalRecord.status ? (
          <FinalizedRecordDetailsView
            record={medicalRecord}
            patient={patientSummary}
          />
        ) : (
          <ClinicalConsultationContent
            onViewFinalized={() => setViewingFinalizedId(medicalRecord.recordId)}
          />
        )
      ) : (
        <MedicalHistoryTab
          patientId={patientSummary?.patientId || medicalRecord.patientId}
          onViewRecordDetail={(recordId) => setViewingFinalizedId(recordId)}
        />
      )}
    </MedicalRecordLayout>
  );
}

/*
 * File Name: medical_record_context.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - @/types/medical_record
 *   - @/services/medical_record_service
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Context and state management orchestrator for medical record clinical consultation workflows, handling step transitions, background debounce autosaving, and finalizing mutations.
 */

"use client";

import React, {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  useRef,
  ReactNode,
} from "react";
import {
  MedicalRecord,
  PatientSummary,
  ClinicalOutcome,
  DiagnosisItem,
  MedicationItem,
  TestOrderItem,
  AttachmentItem,
} from "@/types/medical_record";
import { MedicalRecordService } from "@/services/medical_record_service";

interface MedicalRecordWorkflowContextType {
  record: MedicalRecord;
  patient: PatientSummary | null;
  activeTab: "summary" | "consultation" | "history";
  setActiveTab: (tab: "summary" | "consultation" | "history") => void;
  currentStep: 1 | 2 | 3;
  startConsultation: () => void;
  setCurrentStep: (step: 1 | 2 | 3) => void;
  setClinicalOutcome: (outcome: ClinicalOutcome) => void;
  setPrimaryDiagnosis: (diagnosis: DiagnosisItem | null) => void;
  addSecondaryDiagnosis: (diagnosis: DiagnosisItem) => void;
  removeSecondaryDiagnosis: (code: string) => void;
  setClinicalNotes: (notes: string) => void;
  addMedication: (medication: MedicationItem) => void;
  updateMedication: (medication: MedicationItem) => void;
  removeMedication: (id: string) => void;
  setPrescriptionInstructions: (instructions: string) => void;
  addTestOrder: (test: TestOrderItem) => void;
  removeTestOrder: (id: string) => void;
  addAttachment: (attachment: AttachmentItem) => void;
  removeAttachment: (id: string) => void;
  saveDraftNow: () => Promise<MedicalRecord | null>;
  finalizeRecordNow: () => Promise<MedicalRecord | null>;
  discardDraftNow: () => void;
  isSaving: boolean;
  saveStatus: "IDLE" | "SAVING" | "SAVED" | "ERROR";
  hasUnsavedChanges: boolean;
}

const MedicalRecordWorkflowContext = createContext<
  MedicalRecordWorkflowContextType | undefined
>(undefined);

export function MedicalRecordWorkflowProvider({
  initialRecord,
  patient,
  children,
  onRecordUpdated,
}: {
  initialRecord: MedicalRecord;
  patient: PatientSummary | null;
  children: ReactNode;
  onRecordUpdated?: (updated: MedicalRecord) => void;
}) {
  const [record, setRecord] = useState<MedicalRecord>(initialRecord);
  const [activeTab, setActiveTab] = useState<"summary" | "consultation" | "history">("summary");
  const [isSaving, setIsSaving] = useState(false);
  const [saveStatus, setSaveStatus] = useState<"IDLE" | "SAVING" | "SAVED" | "ERROR">("IDLE");
  const [hasUnsavedChanges, setHasUnsavedChanges] = useState(false);

  const autoSaveTimerRef = useRef<NodeJS.Timeout | null>(null);
  const recordRef = useRef<MedicalRecord>(record);
  recordRef.current = record;

  useEffect(() => {
    setRecord(initialRecord);
    setHasUnsavedChanges(false);
  }, [initialRecord]);

  const markChanged = () => {
    setHasUnsavedChanges(true);
    setSaveStatus("IDLE");

    if (autoSaveTimerRef.current) {
      clearTimeout(autoSaveTimerRef.current);
    }

    if ("FINALIZED" !== recordRef.current.status) {
      autoSaveTimerRef.current = setTimeout(async () => {
        try {
          setSaveStatus("SAVING");
          await MedicalRecordService.autoSaveDraft(
            recordRef.current.appointmentId,
            recordRef.current
          );
          setSaveStatus("SAVED");
          setHasUnsavedChanges(false);
        } catch {
          setSaveStatus("ERROR");
        }
      }, 5000);
    }
  };

  useEffect(() => {
    return () => {
      if (autoSaveTimerRef.current) {
        clearTimeout(autoSaveTimerRef.current);
      }
    };
  }, []);

  const startConsultation = useCallback(() => {
    setRecord((prev) => ({
      ...prev,
      status: "DRAFT",
      currentStep: 1,
      displayState: "DRAFT_STEP_1",
    }));
    setActiveTab("consultation");
    markChanged();
  }, []);

  const setCurrentStep = useCallback((step: 1 | 2 | 3) => {
    setRecord((prev) => ({
      ...prev,
      currentStep: step,
      displayState:
        1 === step
          ? "DRAFT_STEP_1"
          : 2 === step
          ? "DRAFT_STEP_2"
          : "DRAFT_STEP_3",
    }));
    setActiveTab("consultation");
    markChanged();
  }, []);

  const setClinicalOutcome = useCallback((outcome: ClinicalOutcome) => {
    setRecord((prev) => ({
      ...prev,
      clinicalOutcome: outcome,
      status: "DRAFT",
    }));
    markChanged();
  }, []);

  const setPrimaryDiagnosis = useCallback((diagnosis: DiagnosisItem | null) => {
    setRecord((prev) => ({
      ...prev,
      primaryDiagnosis: diagnosis,
      status: "DRAFT",
    }));
    markChanged();
  }, []);

  const addSecondaryDiagnosis = useCallback((diagnosis: DiagnosisItem) => {
    setRecord((prev) => {
      if (prev.secondaryDiagnoses.some((d) => d.code === diagnosis.code)) {
        return prev;
      }
      if (prev.secondaryDiagnoses.length >= 10) return prev;
      return {
        ...prev,
        secondaryDiagnoses: [...prev.secondaryDiagnoses, diagnosis],
        status: "DRAFT",
      };
    });
    markChanged();
  }, []);

  const removeSecondaryDiagnosis = useCallback((code: string) => {
    setRecord((prev) => ({
      ...prev,
      secondaryDiagnoses: prev.secondaryDiagnoses.filter((d) => d.code !== code),
    }));
    markChanged();
  }, []);

  const setClinicalNotes = useCallback((notes: string) => {
    setRecord((prev) => ({
      ...prev,
      clinicalNotes: notes,
      status: "DRAFT",
    }));
    markChanged();
  }, []);

  const addMedication = useCallback((medication: MedicationItem) => {
    setRecord((prev) => ({
      ...prev,
      medications: [...prev.medications, medication],
      status: "DRAFT",
    }));
    markChanged();
  }, []);

  const updateMedication = useCallback((medication: MedicationItem) => {
    setRecord((prev) => ({
      ...prev,
      medications: prev.medications.map((m) =>
        m.id === medication.id ? medication : m
      ),
      status: "DRAFT",
    }));
    markChanged();
  }, []);

  const removeMedication = useCallback((id: string) => {
    setRecord((prev) => ({
      ...prev,
      medications: prev.medications.filter((m) => m.id !== id),
    }));
    markChanged();
  }, []);

  const setPrescriptionInstructions = useCallback((instructions: string) => {
    setRecord((prev) => ({
      ...prev,
      prescriptionInstructions: instructions,
    }));
    markChanged();
  }, []);

  const addTestOrder = useCallback((test: TestOrderItem) => {
    setRecord((prev) => ({
      ...prev,
      testsOrdered: [...prev.testsOrdered, test],
      status: "DRAFT",
    }));
    markChanged();
  }, []);

  const removeTestOrder = useCallback((id: string) => {
    setRecord((prev) => ({
      ...prev,
      testsOrdered: prev.testsOrdered.filter((t) => t.id !== id),
    }));
    markChanged();
  }, []);

  const addAttachment = useCallback((attachment: AttachmentItem) => {
    setRecord((prev) => ({
      ...prev,
      attachments: [...(prev.attachments || []), attachment],
      status: "DRAFT",
    }));
    markChanged();
  }, []);

  const removeAttachment = useCallback((id: string) => {
    setRecord((prev) => ({
      ...prev,
      attachments: (prev.attachments || []).filter((a) => a.id !== id),
    }));
    markChanged();
  }, []);

  const saveDraftNow = useCallback(async (): Promise<MedicalRecord | null> => {
    setIsSaving(true);
    setSaveStatus("SAVING");
    try {
      if (autoSaveTimerRef.current) clearTimeout(autoSaveTimerRef.current);
      const updated = await MedicalRecordService.saveDraft(
        recordRef.current.appointmentId,
        {
          ...recordRef.current,
          status: "DRAFT",
        }
      );
      setRecord(updated);
      setSaveStatus("SAVED");
      setHasUnsavedChanges(false);
      if (onRecordUpdated) onRecordUpdated(updated);
      return updated;
    } catch {
      setSaveStatus("ERROR");
      return null;
    } finally {
      setIsSaving(false);
    }
  }, [onRecordUpdated]);

  const finalizeRecordNow = useCallback(async (): Promise<MedicalRecord | null> => {
    setIsSaving(true);
    try {
      if (autoSaveTimerRef.current) clearTimeout(autoSaveTimerRef.current);
      const finalized = await MedicalRecordService.finalizeRecord(
        recordRef.current.appointmentId,
        {
          ...recordRef.current,
          status: "FINALIZED",
          isLocked: true,
          displayState: "FINALIZED_CLEAN",
        }
      );
      setRecord(finalized);
      setHasUnsavedChanges(false);
      setActiveTab("summary");
      if (onRecordUpdated) onRecordUpdated(finalized);
      return finalized;
    } catch {
      return null;
    } finally {
      setIsSaving(false);
    }
  }, [onRecordUpdated]);

  const discardDraftNow = useCallback(() => {
    setRecord(initialRecord);
    setHasUnsavedChanges(false);
    setActiveTab("summary");
  }, [initialRecord]);

  return (
    <MedicalRecordWorkflowContext.Provider
      value={{
        record,
        patient,
        activeTab,
        setActiveTab,
        currentStep: record.currentStep,
        startConsultation,
        setCurrentStep,
        setClinicalOutcome,
        setPrimaryDiagnosis,
        addSecondaryDiagnosis,
        removeSecondaryDiagnosis,
        setClinicalNotes,
        addMedication,
        updateMedication,
        removeMedication,
        setPrescriptionInstructions,
        addTestOrder,
        removeTestOrder,
        addAttachment,
        removeAttachment,
        saveDraftNow,
        finalizeRecordNow,
        discardDraftNow,
        isSaving,
        saveStatus,
        hasUnsavedChanges,
      }}
    >
      {children}
    </MedicalRecordWorkflowContext.Provider>
  );
}

export function useMedicalRecordWorkflow() {
  const context = useContext(MedicalRecordWorkflowContext);
  if (!context) {
    throw new Error(
      "useMedicalRecordWorkflow must be used within a MedicalRecordWorkflowProvider"
    );
  }
  return context;
}

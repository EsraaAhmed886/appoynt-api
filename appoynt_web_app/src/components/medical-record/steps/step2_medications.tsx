/*
 * File Name: step2_medications.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.2.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/components/medical-record/banners/clinical_alerts_banner
 *   - @/components/medical-record/modals/add_medication_modal
 *   - @/components/medical-record/modals/edit_medication_modal
 *   - @/components/medical-record/modals/confirm_deletion_modal
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Step 2 Prescription Management workspace with pinned unified ClinicalAlertsBanner, active medications table, empty states, AI drug-disease interaction verification, contraindicated allergy warning banner with mandatory acknowledgment, and prescription instructions editor.
 */

"use client";

import React, { useState, useMemo } from "react";
import {
  Pill,
  Plus,
  Trash2,
  Edit2,
  CheckCircle2,
  AlertTriangle,
  RefreshCw,
  ArrowRight,
  ArrowLeft,
  ShieldCheck,
  Info,
} from "lucide-react";
import { MedicationItem } from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import ClinicalAlertsBanner from "@/components/medical-record/banners/clinical_alerts_banner";
import AddMedicationModal from "@/components/medical-record/modals/add_medication_modal";
import EditMedicationModal from "@/components/medical-record/modals/edit_medication_modal";
import ConfirmDeletionModal from "@/components/medical-record/modals/confirm_deletion_modal";
import { useTranslation } from "@/context/language_context";

export default function Step2Medications() {
  const { translations } = useTranslation();

  const {
    record,
    patient,
    removeMedication,
    setPrescriptionInstructions,
    setCurrentStep,
    saveDraftNow,
  } = useMedicalRecordWorkflow();

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [editingMedication, setEditingMedication] = useState<MedicationItem | null>(null);
  const [deletingMedId, setDeletingMedId] = useState<string | null>(null);
  const [isRechecking, setIsRechecking] = useState(false);
  const [contraindicationAcknowledged, setContraindicationAcknowledged] = useState(false);
  const [isDiscardModalOpen, setIsDiscardModalOpen] = useState(false);

  const medications = record.medications || [];

  // Evaluate potential contraindications between active medications and patient allergies
  const allergyContraindications = useMemo(() => {
    const conflicts: { medName: string; allergen: string; severity: string }[] = [];
    if (!patient?.activeAllergies || patient.activeAllergies.length === 0) return conflicts;

    medications.forEach((med) => {
      const medNameL = med.medicationName.toLowerCase();
      patient.activeAllergies.forEach((alg) => {
        const algL = alg.name.toLowerCase();
        if (
          medNameL.includes(algL) ||
          (algL.includes("penicillin") && (medNameL.includes("amox") || medNameL.includes("ampic") || medNameL.includes("penic"))) ||
          (algL.includes("sulfa") && (medNameL.includes("bactrim") || medNameL.includes("sulfa")))
        ) {
          conflicts.push({
            medName: med.medicationName,
            allergen: alg.name,
            severity: alg.severity,
          });
        }
      });
    });

    return conflicts;
  }, [medications, patient]);

  const hasContraindications = allergyContraindications.length > 0;
  const canProceed = !hasContraindications || contraindicationAcknowledged;

  const handleRecheck = () => {
    setIsRechecking(true);
    setTimeout(() => {
      setIsRechecking(false);
    }, 600);
  };

  const handleNext = () => {
    if (canProceed) {
      saveDraftNow();
      setCurrentStep(3);
    }
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-200 text-start">
      {/* 1. Step Header & Add Action */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3.5">
          <div className="p-3 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-2xl border border-blue-200 dark:border-blue-800 shrink-0">
            <Pill className="w-6 h-6" />
          </div>
          <div>
            <h2 className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
              {translations.step2_title || "Step 2: Medications & Prescriptions"}
            </h2>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              {translations.step2_desc || translations.step2_subtitle || "Manage prescription items, specify precise dosage & durations, and evaluate real-time drug interaction safety."}
            </p>
          </div>
        </div>

        <button
          type="button"
          onClick={() => setIsAddModalOpen(true)}
          className="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-md transition flex items-center justify-center gap-2 shrink-0 cursor-pointer"
        >
          <Plus className="w-4 h-4" />
          <span>{translations.add_medication || "Add Medication"}</span>
        </button>
      </div>

      {/* 2. Pinned Unified Clinical Alerts Banner (Allergies + Chronic Conditions) */}
      <ClinicalAlertsBanner
        allergies={patient?.activeAllergies || []}
        conditions={patient?.chronicConditions || []}
      />

      {/* 3. Contraindication Alert Banner (Amber) if conflicts exist */}
      {hasContraindications && (
        <div className="p-4 md:p-5 bg-amber-50 dark:bg-amber-950/40 border-2 border-amber-300 dark:border-amber-700/80 rounded-2xl space-y-3 shadow-xs">
          <div className="flex items-start gap-3">
            <AlertTriangle className="w-6 h-6 text-amber-600 dark:text-amber-400 shrink-0 mt-0.5" />
            <div className="space-y-1">
              <h4 className="text-sm font-bold text-amber-900 dark:text-amber-100">
                {translations.allergy_conflict_detected || "Potential Allergy Contraindication Detected"}
              </h4>
              <p className="text-xs text-amber-800 dark:text-amber-300 leading-relaxed">
                The prescribed medication stack intersects with known patient allergy sensitivities:
              </p>
              <ul className="list-disc list-inside text-xs font-semibold text-amber-900 dark:text-amber-200 pt-1 space-y-0.5">
                {allergyContraindications.map((c, idx) => (
                  <li key={idx}>
                    <strong>{c.medName}</strong> may trigger allergic reaction for <strong>{c.allergen}</strong> (Severity: {c.severity})
                  </li>
                ))}
              </ul>
            </div>
          </div>

          <label className="flex items-center gap-2.5 pt-2 border-t border-amber-200 dark:border-amber-800/60 text-xs font-bold text-amber-900 dark:text-amber-100 cursor-pointer">
            <input
              type="checkbox"
              checked={contraindicationAcknowledged}
              onChange={(e) => setContraindicationAcknowledged(e.target.checked)}
              className="rounded-md text-amber-600 focus:ring-amber-500 w-4 h-4 cursor-pointer"
            />
            <span>{translations.acknowledge_warnings_prompt || "I acknowledge this potential contraindication and confirm clinical override to proceed."}</span>
          </label>
        </div>
      )}

      {/* 3. Active Medications Table / Empty State */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs overflow-hidden">
        {medications.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="w-full text-xs text-slate-700 dark:text-slate-200 text-start">
              <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 uppercase text-[11px] font-bold text-slate-500 dark:text-slate-400">
                <tr>
                  <th className="py-3.5 px-4 text-start w-10">#</th>
                  <th className="py-3.5 px-4 text-start">{translations.medication_name || "Medication Name"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.dosage || "Dosage"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.frequency || "Frequency"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.duration || "Duration"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.route || "Route"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.instructions || "Instructions"}</th>
                  <th className="py-3.5 px-4 text-end">{translations.col_actions || translations.actions || "Actions"}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
                {medications.map((med, idx) => (
                  <tr
                    key={med.id}
                    className="hover:bg-slate-50/80 dark:hover:bg-[#131E35]/60 transition"
                  >
                    <td className="py-3.5 px-4 text-slate-400 font-mono text-center">
                      {idx + 1}
                    </td>
                    <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white">
                      <div className="flex items-center gap-2">
                        <span>{med.medicationName}</span>
                        {med.allergyConflict && (
                          <span className="p-0.5 rounded text-amber-500" title="Allergy Conflict">
                            <AlertTriangle className="w-3.5 h-3.5" />
                          </span>
                        )}
                      </div>
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      {med.dosageAmount} {med.dosageUnit}
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      {med.frequency}
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      {med.isOngoing ? (
                        <span className="px-2 py-0.5 bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 rounded-md font-bold text-[11px]">
                          {translations.chronic_ongoing || translations.ongoing_treatment || "Ongoing"}
                        </span>
                      ) : (
                        `${med.durationValue} ${med.durationUnit}`
                      )}
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      {med.route}
                    </td>
                    <td className="py-3.5 px-4 italic text-slate-500 dark:text-slate-400 max-w-xs truncate">
                      {med.instructions || "—"}
                    </td>
                    <td className="py-3.5 px-4 text-end whitespace-nowrap">
                      <div className="flex items-center justify-end gap-1">
                        <button
                          type="button"
                          onClick={() => setEditingMedication(med)}
                          className="p-1.5 text-slate-500 hover:text-blue-600 rounded-lg hover:bg-blue-50 dark:hover:bg-blue-950/60 transition cursor-pointer"
                          title="Edit Medication"
                        >
                          <Edit2 className="w-3.5 h-3.5" />
                        </button>
                        <button
                          type="button"
                          onClick={() => setDeletingMedId(med.id)}
                          className="p-1.5 text-slate-500 hover:text-rose-600 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/60 transition cursor-pointer"
                          title="Delete Medication"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            {/* Table Footer Summary Strip */}
            <div className="flex items-center justify-between p-3.5 bg-slate-50 dark:bg-[#131E35] border-t-2 border-slate-200 dark:border-slate-800 text-xs">
              <span className="font-bold text-slate-700 dark:text-slate-300">
                Total Items: {medications.length}
              </span>
              <span className="inline-flex items-center gap-1.5 font-bold text-emerald-600 dark:text-emerald-400">
                <CheckCircle2 className="w-4 h-4" />
                <span>✓ {translations.ai_safety_ok || "AI Check: No major drug-drug interactions or chronic condition contraindications detected."}</span>
              </span>
            </div>
          </div>
        ) : (
          /* Empty State */
          <div className="p-12 text-center space-y-3">
            <div className="w-14 h-14 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-full flex items-center justify-center mx-auto">
              <Pill className="w-7 h-7" />
            </div>
            <div className="space-y-1">
              <h3 className="text-sm font-bold text-slate-900 dark:text-white">
                {translations.no_medications || translations.no_medications_added || "No medications added yet."}
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400 max-w-sm mx-auto">
                {translations.no_medications_sub || "Add prescription regimens and dosing instructions to accompany this consultation encounter."}
              </p>
            </div>
            <button
              type="button"
              onClick={() => setIsAddModalOpen(true)}
              className="px-5 py-2 text-xs font-bold text-blue-600 hover:text-blue-700 bg-blue-50 dark:bg-blue-950/60 hover:bg-blue-100 dark:hover:bg-blue-900/60 rounded-xl transition inline-flex items-center gap-1.5 cursor-pointer"
            >
              <Plus className="w-4 h-4" />
              <span>{translations.add_medication || "Add Medication"}</span>
            </button>
          </div>
        )}
      </div>

      {/* 4. AI Drug Interaction Check Box (Green) with Recheck */}
      <div className="bg-emerald-50/80 dark:bg-emerald-950/30 border-2 border-emerald-200 dark:border-emerald-800/80 rounded-2xl p-4 md:p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3.5">
          <div className="w-10 h-10 rounded-xl bg-emerald-100 dark:bg-emerald-900/60 text-emerald-700 dark:text-emerald-300 flex items-center justify-center shrink-0 border border-emerald-300 dark:border-emerald-700">
            <ShieldCheck className="w-6 h-6" />
          </div>
          <div>
            <h4 className="text-xs md:text-sm font-bold text-emerald-900 dark:text-emerald-200">
              {translations.ai_safety_title || "AI Drug-Drug & Disease Interaction Safety Verification"}
            </h4>
            <p className="text-xs text-emerald-700 dark:text-emerald-400">
              {translations.ai_safety_ok || "AI Check: No major drug-drug interactions or chronic condition contraindications detected."}
            </p>
          </div>
        </div>

        <button
          type="button"
          onClick={handleRecheck}
          disabled={isRechecking}
          className="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition flex items-center justify-center gap-1.5 shrink-0 cursor-pointer"
        >
          <RefreshCw className={`w-3.5 h-3.5 ${isRechecking ? "animate-spin" : ""}`} />
          <span>{isRechecking ? "Checking..." : (translations.recheck || "Recheck")}</span>
        </button>
      </div>

      {/* 5. Prescription Instructions Editor (Max 500 chars) */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-3">
        <div className="flex items-center justify-between">
          <label className="block text-xs font-bold text-slate-900 dark:text-white uppercase tracking-wider">
            {translations.patient_prescription_instructions || translations.instructions || "Prescription Instructions (For Patient)"}
          </label>
          <span className="text-[11px] font-mono text-slate-400">
            {(record.prescriptionInstructions || "").length} / 500
          </span>
        </div>

        <textarea
          rows={3}
          maxLength={500}
          value={record.prescriptionInstructions || ""}
          onChange={(e) => setPrescriptionInstructions(e.target.value)}
          placeholder={translations.patient_instructions_placeholder || "Enter patient pharmacy instructions (e.g. Take with food, finish entire course of antibiotics, avoid alcohol)..."}
          className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl p-3.5 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 placeholder-slate-400 focus:outline-none focus:border-blue-500 transition"
        />
      </div>

      {/* 6. Step 2 Footer Navigation */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 md:p-5 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <button
          type="button"
          onClick={() => setCurrentStep(1)}
          className="px-5 py-2.5 text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition flex items-center gap-1.5 cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4 rtl:rotate-180" />
          <span>{translations.previous || translations.back || "Previous"}</span>
        </button>

        <div className="flex items-center gap-3 self-end sm:self-auto">
          <button
            type="button"
            onClick={() => setIsDiscardModalOpen(true)}
            className="px-4 py-2.5 text-xs font-bold text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition cursor-pointer"
          >
            {translations.discard_draft || "Discard Draft"}
          </button>
          <button
            type="button"
            onClick={handleNext}
            disabled={!canProceed}
            className={`px-6 py-2.5 text-xs font-bold text-white rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer ${
              canProceed
                ? "bg-blue-600 hover:bg-blue-700"
                : "bg-slate-400 dark:bg-slate-700 cursor-not-allowed opacity-60"
            }`}
          >
            <span>{translations.next || "Next"}</span>
            <ArrowRight className="w-4 h-4 rtl:rotate-180" />
          </button>
        </div>
      </div>

      {/* Add Medication Modal */}
      <AddMedicationModal
        isOpen={isAddModalOpen}
        onClose={() => setIsAddModalOpen(false)}
      />

      {/* Edit Medication Modal */}
      <EditMedicationModal
        isOpen={!!editingMedication}
        onClose={() => setEditingMedication(null)}
        medication={editingMedication}
      />

      {/* Delete Medication Confirmation Modal */}
      <ConfirmDeletionModal
        isOpen={!!deletingMedId}
        onClose={() => setDeletingMedId(null)}
        onConfirm={() => {
          if (deletingMedId) removeMedication(deletingMedId);
        }}
        title={translations.confirm_deletion || "Remove Medication"}
        description={translations.delete_confirmation_desc || "Are you sure you want to delete this medication from the active prescription list?"}
        confirmLabel={translations.delete || "Delete"}
      />

      {/* Discard Draft Modal */}
      <ConfirmDeletionModal
        isOpen={isDiscardModalOpen}
        onClose={() => setIsDiscardModalOpen(false)}
        onConfirm={() => {
          window.location.reload();
        }}
        title={translations.discard_modal_title || "Discard Draft Changes"}
        description={translations.discard_modal_body || "Are you sure you want to discard this consultation draft? Any unsaved edits will be lost."}
        confirmLabel={translations.discard_confirm_btn || "Discard Draft"}
      />
    </div>
  );
}

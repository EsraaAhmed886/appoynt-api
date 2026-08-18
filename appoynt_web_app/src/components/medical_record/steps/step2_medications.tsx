/*
 * File Name: step2_medications.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/components/medical_record/modals/add_medication_modal
 *   - @/components/medical_record/modals/confirm_deletion_modal
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Step 2 Medications & Prescriptions component with automated drug interaction checks, dosage formulary selection, scaled typography, and tightened EHR spacing.
 */

"use client";

import React, { useState } from "react";
import {
  Pill,
  Plus,
  Edit2,
  Trash2,
  AlertTriangle,
  Sparkles,
  ArrowRight,
  ArrowLeft,
  Save,
  ShieldCheck,
  RefreshCw,
} from "lucide-react";
import {
  MedicationItem,
  DrugInteractionCheckResult,
} from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { medicalRecordService } from "@/services/medical_record_service";
import AddMedicationModal from "@/components/medical_record/modals/add_medication_modal";
import ConfirmDeletionModal from "@/components/medical_record/modals/confirm_deletion_modal";
import { useTranslation } from "@/context/language_context";

export default function Step2Medications() {
  const { translations } = useTranslation();
  const {
    record,
    patient,
    removeMedication,
    setCurrentStep,
    saveDraftNow,
    isSaving,
  } = useMedicalRecordWorkflow();

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [editingMedication, setEditingMedication] =
    useState<MedicationItem | null>(null);
  const [deletingMedId, setDeletingMedId] = useState<string | null>(null);

  const [interactionResult, setInteractionResult] =
    useState<DrugInteractionCheckResult | null>(null);
  const [isCheckingInteractions, setIsCheckingInteractions] = useState(false);
  const [saveBanner, setSaveBanner] = useState<string | null>(null);

  const runInteractionCheck = async () => {
    if (record.medications.length === 0) {
      setInteractionResult(null);
      return;
    }
    setIsCheckingInteractions(true);
    try {
      const activeAllergies = patient?.activeAllergies || [];
      const result = await medicalRecordService.checkDrugInteractions(
        record.medications,
        activeAllergies
      );
      setInteractionResult(result);
    } catch {
      // Ignore check errors gracefully in UI
    } finally {
      setIsCheckingInteractions(false);
    }
  };

  const handleOpenAddModal = () => {
    setEditingMedication(null);
    setIsAddModalOpen(true);
  };

  const handleOpenEditModal = (med: MedicationItem) => {
    setEditingMedication(med);
    setIsAddModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsAddModalOpen(false);
    setEditingMedication(null);
    setTimeout(runInteractionCheck, 100);
  };

  const handleManualSave = async () => {
    const res = await saveDraftNow();
    if (res) {
      setSaveBanner(translations.save_draft);
      setTimeout(() => setSaveBanner(null), 3000);
    }
  };

  return (
    <div className="space-y-4 animate-in fade-in duration-300 text-slate-900 dark:text-slate-100">
      {/* Toast Save Feedback Banner */}
      {saveBanner && (
        <div className="flex items-center gap-2 p-3 bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-300 dark:border-emerald-700/60 rounded-xl text-emerald-900 dark:text-emerald-200 text-xs md:text-sm font-semibold animate-in slide-in-from-top-1">
          <ShieldCheck className="w-4 h-4 text-emerald-600 dark:text-emerald-400 shrink-0" />
          {saveBanner}
        </div>
      )}

      {/* Header and Add Action */}
      <div className="flex flex-wrap items-center justify-between gap-3 mb-2">
        <div className="text-start">
          <h2 className="text-base md:text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2">
            <Pill className="w-5 h-5 text-blue-600 dark:text-blue-400" />
            {translations.medications_and_prescriptions}
          </h2>
          <p className="text-xs md:text-sm font-medium text-slate-500 dark:text-slate-400">
            {translations.active_medications} ({record.medications.length})
          </p>
        </div>

        <button
          type="button"
          onClick={handleOpenAddModal}
          className="px-4 py-2 text-xs md:text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-xs transition flex items-center gap-2 cursor-pointer"
        >
          <Plus className="w-4 h-4" />
          {translations.add_medication}
        </button>
      </div>

      {/* Patient Allergies Quick Warning Bar */}
      {patient?.activeAllergies && patient.activeAllergies.length > 0 && (
        <div className="flex items-center gap-2.5 p-3 bg-rose-50 dark:bg-rose-950/30 border border-rose-200 dark:border-rose-900/50 rounded-xl text-xs md:text-sm text-rose-900 dark:text-rose-200 text-start">
          <AlertTriangle className="w-4 h-4 text-rose-600 shrink-0" />
          <span className="font-medium">
            <strong>{translations.allergy_alert}:</strong>{" "}
            {patient.activeAllergies.map((a) => a.name).join(", ")}
          </span>
        </div>
      )}

      {/* AI Drug Interaction Check Banner */}
      <div>
        {interactionResult && (
          <div
            className={`flex items-start justify-between gap-3 p-3.5 rounded-xl border-2 text-xs md:text-sm shadow-xs transition ${
              interactionResult.hasInteraction
                ? "bg-rose-50/90 dark:bg-rose-950/40 border-rose-300 dark:border-rose-800 text-rose-900 dark:text-rose-200"
                : "bg-emerald-50/90 dark:bg-emerald-950/40 border-emerald-300 dark:border-emerald-800 text-emerald-900 dark:text-emerald-200"
            }`}
          >
            <div className="flex items-start gap-3">
              <div
                className={`p-2 rounded-lg shrink-0 ${
                  interactionResult.hasInteraction
                    ? "bg-rose-100 dark:bg-rose-900/60 text-rose-600 dark:text-rose-300"
                    : "bg-emerald-100 dark:bg-emerald-900/60 text-emerald-600 dark:text-emerald-300"
                }`}
              >
                <Sparkles className="w-4 h-4" />
              </div>
              <div className="space-y-1 text-start">
                <div className="flex items-center gap-2">
                  <p className="font-bold text-sm md:text-base">
                    {translations.ai_drug_check}
                  </p>
                  <span
                    className={`px-2 py-0.5 text-[10px] font-bold uppercase rounded-md ${
                      interactionResult.hasInteraction
                        ? "bg-rose-200 dark:bg-rose-900 text-rose-800 dark:text-rose-200"
                        : "bg-emerald-200 dark:bg-emerald-900 text-emerald-800 dark:text-emerald-200"
                    }`}
                  >
                    {interactionResult.hasInteraction
                      ? `${interactionResult.severity || "Risk"}`
                      : "Clear"}
                  </span>
                </div>
                <p className="leading-relaxed text-xs md:text-sm">
                  {interactionResult.message}
                </p>

                {/* Specific drug-drug interactions */}
                {interactionResult.interactions && (
                  <div className="mt-2 space-y-1.5 pt-2 border-t border-rose-200 dark:border-rose-800/60">
                    {interactionResult.interactions.map((intx, idx) => (
                      <div
                        key={idx}
                        className="p-2 bg-white/80 dark:bg-[#1C1418] rounded-lg border border-rose-200 dark:border-rose-900/60 text-rose-900 dark:text-rose-200 text-xs"
                      >
                        <span className="font-bold">
                          {intx.drug1} + {intx.drug2} ({intx.severity}):
                        </span>{" "}
                        <span className="text-slate-700 dark:text-slate-300">
                          {intx.description}
                        </span>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>

            <button
              type="button"
              disabled={isCheckingInteractions}
              onClick={runInteractionCheck}
              className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold bg-white dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-700 transition shrink-0 cursor-pointer"
            >
              <RefreshCw
                className={`w-3.5 h-3.5 ${
                  isCheckingInteractions ? "animate-spin" : ""
                }`}
              />
              {translations.recheck}
            </button>
          </div>
        )}
      </div>

      {/* Active Medications Table or Empty State */}
      <div className="bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs overflow-hidden">
        {record.medications.length === 0 ? (
          /* Empty State */
          <div className="flex flex-col items-center justify-center p-6 md:p-8 text-center space-y-2.5">
            <div className="w-12 h-12 bg-blue-50 dark:bg-blue-950/60 rounded-full flex items-center justify-center text-blue-500 dark:text-blue-400">
              <Pill className="w-6 h-6" />
            </div>
            <div className="space-y-0.5 max-w-sm">
              <h3 className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
                {translations.no_medications_yet}
              </h3>
              <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400">
                {translations.no_medications_desc}
              </p>
            </div>
            <button
              type="button"
              onClick={handleOpenAddModal}
              className="px-4 py-2 text-xs md:text-sm font-bold text-blue-600 bg-blue-50 dark:bg-blue-950/60 hover:bg-blue-100 dark:hover:bg-blue-900/40 rounded-xl transition cursor-pointer"
            >
              {translations.add_medication}
            </button>
          </div>
        ) : (
          /* Medications Table */
          <div className="overflow-x-auto">
            <table className="w-full text-start">
              <thead className="bg-slate-100/90 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-700 py-2.5 px-4 md:px-5 text-xs font-bold uppercase tracking-wider text-slate-700 dark:text-slate-200">
                <tr>
                  <th className="py-2.5 px-4 md:px-5 text-start">{translations.medication_name}</th>
                  <th className="py-2.5 px-4 md:px-5 text-start">{translations.dosage}</th>
                  <th className="py-2.5 px-4 md:px-5 text-start">{translations.frequency}</th>
                  <th className="py-2.5 px-4 md:px-5 text-start">{translations.duration}</th>
                  <th className="py-2.5 px-4 md:px-5 text-start">{translations.route}</th>
                  <th className="py-2.5 px-4 md:px-5 text-start">{translations.instructions}</th>
                  <th className="py-2.5 px-4 md:px-5 text-end">{translations.actions}</th>
                </tr>
              </thead>
              <tbody className="divide-y-2 divide-slate-100 dark:divide-slate-700/60">
                {record.medications.map((med) => (
                  <tr
                    key={med.id}
                    className="hover:bg-slate-50 dark:hover:bg-slate-800/40 text-slate-800 dark:text-slate-200 text-xs md:text-sm font-medium transition-colors"
                  >
                    <td className="py-2.5 px-4 md:px-5 font-bold text-slate-900 dark:text-white text-xs md:text-sm">
                      {med.medicationName}
                    </td>
                    <td className="py-2.5 px-4 md:px-5">
                      {med.dosageAmount} {med.dosageUnit}
                    </td>
                    <td className="py-2.5 px-4 md:px-5">{med.frequency}</td>
                    <td className="py-2.5 px-4 md:px-5">
                      {med.isOngoing
                        ? "Continuous"
                        : `${med.durationValue} ${med.durationUnit}`}
                    </td>
                    <td className="py-2.5 px-4 md:px-5">{med.route}</td>
                    <td className="py-2.5 px-4 md:px-5 text-slate-500 dark:text-slate-400 max-w-[200px] truncate">
                      {med.instructions || "—"}
                    </td>
                    <td className="py-2.5 px-4 md:px-5 text-end">
                      <div className="flex items-center justify-end gap-1.5">
                        <button
                          type="button"
                          onClick={() => handleOpenEditModal(med)}
                          className="p-1.5 text-slate-500 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition"
                          title="Edit"
                        >
                          <Edit2 className="w-4 h-4" />
                        </button>
                        <button
                          type="button"
                          onClick={() => setDeletingMedId(med.id)}
                          className="p-1.5 text-slate-500 hover:text-red-600 rounded-lg hover:bg-red-50 dark:hover:bg-red-950/40 transition"
                          title="Delete"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Bottom Sticky Action Controls */}
      <div className="flex flex-wrap items-center justify-between gap-3 pt-3 mt-3 border-t border-slate-200 dark:border-slate-800">
        <div className="flex items-center gap-2.5">
          <button
            type="button"
            onClick={() => setCurrentStep(1)}
            className="px-5 py-2.5 text-sm md:text-base font-semibold text-slate-700 dark:text-slate-300 bg-white dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 rounded-xl shadow-xs transition flex items-center gap-2 cursor-pointer"
          >
            <ArrowLeft className="w-4 h-4 rtl:rotate-180" />
            {translations.back}
          </button>

          <button
            type="button"
            disabled={isSaving}
            onClick={handleManualSave}
            className="px-5 py-2.5 text-sm md:text-base font-semibold text-slate-700 dark:text-slate-300 bg-white dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 rounded-xl shadow-xs transition flex items-center gap-2 cursor-pointer"
          >
            <Save className="w-4 h-4 text-slate-500" />
            {isSaving ? translations.medrec_btn_saving_draft : translations.save_draft}
          </button>
        </div>

        <button
          type="button"
          onClick={() => setCurrentStep(3)}
          className="px-6 py-2.5 text-sm md:text-base font-bold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer"
        >
          {translations.tests_and_attachments}
          <ArrowRight className="w-4 h-4 rtl:rotate-180" />
        </button>
      </div>

      {/* Add / Edit Medication Modal */}
      <AddMedicationModal
        isOpen={isAddModalOpen}
        onClose={handleCloseModal}
        medicationToEdit={editingMedication}
      />

      {/* Delete Confirmation Modal */}
      <ConfirmDeletionModal
        isOpen={Boolean(deletingMedId)}
        onClose={() => setDeletingMedId(null)}
        onConfirm={() => {
          if (deletingMedId) removeMedication(deletingMedId);
        }}
        title={translations.confirm_deletion_title}
        description={translations.confirm_deletion_desc}
        confirmLabel={translations.delete}
        cancelLabel={translations.cancel}
        variant="danger"
      />
    </div>
  );
}

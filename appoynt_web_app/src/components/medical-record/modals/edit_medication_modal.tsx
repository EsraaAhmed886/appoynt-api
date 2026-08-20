/*
 * File Name: edit_medication_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/context/language_context
 *   - @/components/ui/custom_select_dropdown
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Accessible modal dialog for editing existing prescription medications with quick clinical reference bar, pre-filled form fields, dosage/duration adjustments, and update dispatch.
 */

"use client";

import React, { useState, useEffect } from "react";
import { X, Edit3, AlertTriangle, ShieldAlert, Activity } from "lucide-react";
import { MedicationItem } from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { useTranslation } from "@/context/language_context";
import CustomSelectDropdown, { DropdownOption } from "@/components/ui/custom_select_dropdown";

interface EditMedicationModalProps {
  isOpen: boolean;
  onClose: () => void;
  medication: MedicationItem | null;
}

export default function EditMedicationModal({
  isOpen,
  onClose,
  medication,
}: EditMedicationModalProps) {
  const { updateMedication, patient } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  const [medName, setMedName] = useState("");
  const [dosageAmount, setDosageAmount] = useState<string>("500");
  const [dosageUnit, setDosageUnit] = useState<MedicationItem["dosageUnit"]>("mg");
  const [frequency, setFrequency] = useState<MedicationItem["frequency"]>("Once daily");
  const [isOngoing, setIsOngoing] = useState(false);
  const [durationValue, setDurationValue] = useState<string>("7");
  const [durationUnit, setDurationUnit] = useState<MedicationItem["durationUnit"]>("Days");
  const [route, setRoute] = useState<MedicationItem["route"]>("Oral");
  const [instructions, setInstructions] = useState("");
  const [formErrors, setFormErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (medication) {
      setMedName(medication.medicationName);
      setDosageAmount(String(medication.dosageAmount));
      setDosageUnit(medication.dosageUnit);
      setFrequency(medication.frequency);
      setIsOngoing(medication.isOngoing);
      setDurationValue(String(medication.durationValue || 7));
      setDurationUnit(medication.durationUnit || "Days");
      setRoute(medication.route);
      setInstructions(medication.instructions || "");
      setFormErrors({});
    }
  }, [medication, isOpen]);

  const handleUpdate = (e: React.FormEvent) => {
    e.preventDefault();
    if (!medication) return;

    const errors: Record<string, string> = {};
    if (!medName.trim()) {
      errors.medName = translations.medication_name || "Medication name is required";
    }
    const numDosage = Number(dosageAmount);
    if (isNaN(numDosage) || numDosage <= 0) {
      errors.dosageAmount = translations.dosage || "Valid dosage is required";
    }
    if (!isOngoing) {
      const numDur = Number(durationValue);
      if (isNaN(numDur) || numDur <= 0) {
        errors.durationValue = translations.duration || "Valid duration is required";
      }
    }

    if (Object.keys(errors).length > 0) {
      setFormErrors(errors);
      return;
    }

    const updated: MedicationItem = {
      ...medication,
      medicationName: medName.trim(),
      dosageAmount: Math.floor(Number(dosageAmount)),
      dosageUnit: dosageUnit,
      frequency: frequency,
      isOngoing: isOngoing,
      durationValue: isOngoing ? undefined : Math.floor(Number(durationValue)),
      durationUnit: isOngoing ? undefined : durationUnit,
      route: route,
      instructions: instructions.trim() || undefined,
      isIncomplete: false,
    };

    updateMedication(updated);
    onClose();
  };

  if (!isOpen || !medication) return null;

  const frequencyOptions: DropdownOption[] = [
    { value: "Once daily", label: translations.freq_once_daily || "Once daily" },
    { value: "Twice daily", label: translations.freq_twice_daily || "Twice daily (q12h)" },
    { value: "Three times daily", label: translations.freq_three_daily || "Three times daily (q8h)" },
    { value: "Four times daily", label: translations.freq_four_daily || "Four times daily (q6h)" },
    { value: "Every 4 hours", label: translations.freq_every_4h || "Every 4 hours" },
    { value: "As Needed", label: translations.freq_as_needed || "As Needed (PRN)" },
    { value: "At Bedtime", label: translations.freq_at_bedtime || "At Bedtime (QHS)" },
  ];

  const dosageUnitOptions: DropdownOption[] = [
    { value: "mg", label: "mg" },
    { value: "mcg", label: "mcg" },
    { value: "g", label: "g" },
    { value: "mL", label: "mL" },
    { value: "tablets", label: "tablets" },
    { value: "capsules", label: "capsules" },
    { value: "puffs", label: "puffs" },
    { value: "drops", label: "drops" },
    { value: "IU", label: "IU" },
  ];

  const durationUnitOptions: DropdownOption[] = [
    { value: "Days", label: translations.dur_days || "Days" },
    { value: "Weeks", label: translations.dur_weeks || "Weeks" },
    { value: "Months", label: translations.dur_months || "Months" },
  ];

  const routeOptions: DropdownOption[] = [
    { value: "Oral", label: translations.route_oral || "Oral (PO)" },
    { value: "Sublingual", label: translations.route_sublingual || "Sublingual (SL)" },
    { value: "Intravenous", label: translations.route_iv || "Intravenous (IV)" },
    { value: "Intramuscular", label: translations.route_im || "Intramuscular (IM)" },
    { value: "Subcutaneous", label: translations.route_sc || "Subcutaneous (SC)" },
    { value: "Topical", label: translations.route_topical || "Topical" },
    { value: "Inhalation", label: "Inhalation" },
  ];

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-200 text-slate-900 dark:text-slate-100">
      <div
        className="relative w-full max-w-xl bg-white dark:bg-[#0E1726] rounded-2xl shadow-2xl border-2 border-slate-200 dark:border-slate-800 overflow-hidden flex flex-col max-h-[92vh]"
        role="dialog"
        aria-modal="true"
      >
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-3 border-b-2 border-slate-200 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35] shrink-0">
          <div className="flex items-center gap-2.5">
            <div className="p-2 bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-xl">
              <Edit3 className="w-4 h-4" />
            </div>
            <div className="text-start">
              <h2 className="text-base font-bold text-slate-900 dark:text-white leading-tight">
                {translations.edit_medication || "Edit Medication"}
              </h2>
              <p className="text-[11px] text-slate-500 dark:text-slate-400">
                {medication.medicationName}
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            aria-label="Close dialog"
            className="p-1.5 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 transition cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Body */}
        <form id="edit-medication-form" onSubmit={handleUpdate} className="flex-1 overflow-y-auto px-5 py-3.5 space-y-3 text-start">
          {/* Ultra-Compact Clinical Safety Context Strip */}
          <div className="bg-slate-50/80 dark:bg-slate-900/40 border border-slate-200/90 dark:border-slate-800 rounded-xl p-2.5 flex flex-col gap-1.5 text-xs">
            {/* Row 1 — Allergies (Rose/Red Condensed) */}
            <div className="flex items-center gap-1.5 flex-wrap">
              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-red-100 dark:bg-red-950/60 text-red-700 dark:text-red-300 font-semibold text-[11px] shrink-0">
                <ShieldAlert className="w-3 h-3" />
                <span>{translations.allergies_label || "Allergies"}</span>
              </span>
              {patient?.activeAllergies && patient.activeAllergies.length > 0 ? (
                patient.activeAllergies.map((a) => (
                  <span
                    key={a.id || a.name}
                    className="px-2 py-0.5 rounded-md bg-white dark:bg-slate-800 border border-red-200/80 dark:border-red-900/40 text-red-800 dark:text-red-200 font-medium text-[11px]"
                  >
                    {a.name} ({a.severity})
                  </span>
                ))
              ) : (
                <span className="px-2 py-0.5 rounded-md bg-white dark:bg-slate-800 border border-emerald-200 dark:border-emerald-800/60 text-emerald-700 dark:text-emerald-300 font-medium text-[11px]">
                  {translations.no_allergies || "No Known Drug Allergies"}
                </span>
              )}
            </div>

            {/* Row 2 — Chronic Conditions (Blue/Indigo Condensed) */}
            <div className="flex items-center gap-1.5 flex-wrap">
              <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-blue-100 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 font-semibold text-[11px] shrink-0">
                <Activity className="w-3 h-3" />
                <span>{translations.conditions_label || "Conditions"}</span>
              </span>
              {patient?.chronicConditions && patient.chronicConditions.length > 0 ? (
                patient.chronicConditions.map((condition) => {
                  const icd = condition.icd10_code || condition.icd10Code;
                  return (
                    <span
                      key={condition.id || condition.name}
                      className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-200 text-[11px] font-medium"
                    >
                      {icd && (
                        <span className="font-mono text-blue-600 dark:text-blue-400 text-[10px] font-bold">
                          ({icd})
                        </span>
                      )}
                      <span>{condition.name}</span>
                    </span>
                  );
                })
              ) : (
                <span className="px-2 py-0.5 rounded-md bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-500 dark:text-slate-400 text-[11px]">
                  {translations.no_chronic_conditions || "No Recorded Chronic Conditions"}
                </span>
              )}
            </div>
          </div>

          {medication.allergyConflict && (
            <div className="flex items-start gap-2.5 p-2.5 bg-amber-50 dark:bg-amber-950/40 border border-amber-300 dark:border-amber-700/60 rounded-xl text-amber-900 dark:text-amber-200 text-xs">
              <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
              <div>
                <p className="font-bold">
                  {translations.allergy_conflict_detected || "Allergy Conflict"}: {medication.allergyConflict.allergen} ({medication.allergyConflict.severity})
                </p>
              </div>
            </div>
          )}

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
              {translations.medication_name || "Medication Name"} <span className="text-rose-500">*</span>
            </label>
            <input
              type="text"
              value={medName}
              onChange={(e) => setMedName(e.target.value)}
              className="w-full bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-xl px-3 py-2 h-10 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
            />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
                {translations.dosage || "Dosage"} <span className="text-rose-500">*</span>
              </label>
              <input
                type="number"
                min="1"
                value={dosageAmount}
                onChange={(e) => setDosageAmount(e.target.value)}
                className="w-full bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-xl px-3 py-2 h-10 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
              />
            </div>
            <div>
              <CustomSelectDropdown
                label={translations.unit || "Unit"}
                options={dosageUnitOptions}
                value={dosageUnit}
                onChange={(val) => setDosageUnit(val as MedicationItem["dosageUnit"])}
                searchable={false}
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <CustomSelectDropdown
              label={translations.frequency || "Frequency"}
              required
              options={frequencyOptions}
              value={frequency}
              onChange={(val) => setFrequency(val as MedicationItem["frequency"])}
              searchable={false}
            />

            <CustomSelectDropdown
              label={translations.route || "Route"}
              options={routeOptions}
              value={route}
              onChange={(val) => setRoute(val as MedicationItem["route"])}
              searchable={false}
            />
          </div>

          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
                {translations.duration || "Treatment Duration"} {!isOngoing && <span className="text-rose-500">*</span>}
              </label>
              <label className="flex items-center gap-1.5 text-xs font-medium text-slate-600 dark:text-slate-300 cursor-pointer">
                <input
                  type="checkbox"
                  checked={isOngoing}
                  onChange={(e) => setIsOngoing(e.target.checked)}
                  className="rounded text-blue-600 focus:ring-blue-500 w-3.5 h-3.5 cursor-pointer"
                />
                <span>{translations.chronic_ongoing || translations.ongoing_treatment || "Chronic / Ongoing"}</span>
              </label>
            </div>

            {!isOngoing && (
              <div className="grid grid-cols-2 gap-3">
                <input
                  type="number"
                  min="1"
                  value={durationValue}
                  onChange={(e) => setDurationValue(e.target.value)}
                  className="w-full bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-xl px-3 py-2 h-10 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
                />
                <CustomSelectDropdown
                  options={durationUnitOptions}
                  value={durationUnit || "Days"}
                  onChange={(val) => setDurationUnit(val as MedicationItem["durationUnit"])}
                  searchable={false}
                />
              </div>
            )}
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1">
              {translations.instructions || "Instructions"}
            </label>
            <textarea
              rows={2}
              value={instructions}
              onChange={(e) => setInstructions(e.target.value)}
              placeholder={translations.instructions_placeholder || "e.g. Take with meals and a full glass of water..."}
              className="w-full bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-xl p-2.5 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500 min-h-[55px]"
            />
          </div>
        </form>

        {/* Pinned Footer */}
        <div className="flex items-center justify-end gap-2.5 px-5 py-3 border-t-2 border-slate-200 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35] shrink-0">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition cursor-pointer"
          >
            {translations.cancel || "Cancel"}
          </button>
          <button
            type="submit"
            form="edit-medication-form"
            className="px-5 py-2 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md transition cursor-pointer"
          >
            {translations.update_medication || "Update Medication"}
          </button>
        </div>
      </div>
    </div>
  );
}

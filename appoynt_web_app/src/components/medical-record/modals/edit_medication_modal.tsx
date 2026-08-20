/*
 * File Name: edit_medication_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/context/language_context
 *   - @/components/ui/custom_select_dropdown
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Accessible modal dialog for editing existing prescription medications with pre-filled form fields, dosage/duration adjustments, and update dispatch.
 */

"use client";

import React, { useState, useEffect } from "react";
import { X, Edit3, AlertTriangle } from "lucide-react";
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
  const { updateMedication } = useMedicalRecordWorkflow();
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
    { value: "Once daily", label: "Once daily" },
    { value: "Twice daily", label: "Twice daily (q12h)" },
    { value: "Three times daily", label: "Three times daily (q8h)" },
    { value: "Four times daily", label: "Four times daily (q6h)" },
    { value: "Every 4 hours", label: "Every 4 hours" },
    { value: "As Needed", label: "As Needed (PRN)" },
    { value: "At Bedtime", label: "At Bedtime (QHS)" },
  ];

  const durationUnitOptions: DropdownOption[] = [
    { value: "Days", label: "Days" },
    { value: "Weeks", label: "Weeks" },
    { value: "Months", label: "Months" },
  ];

  const routeOptions: DropdownOption[] = [
    { value: "Oral", label: "Oral (PO)" },
    { value: "Sublingual", label: "Sublingual (SL)" },
    { value: "Intravenous", label: "Intravenous (IV)" },
    { value: "Intramuscular", label: "Intramuscular (IM)" },
    { value: "Subcutaneous", label: "Subcutaneous (SC)" },
    { value: "Topical", label: "Topical" },
    { value: "Inhalation", label: "Inhalation" },
  ];

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-200 text-slate-900 dark:text-slate-100">
      <div
        className="relative w-full max-w-xl bg-white dark:bg-[#0E1726] rounded-2xl shadow-2xl border-2 border-slate-200 dark:border-slate-800 overflow-hidden flex flex-col max-h-[90vh]"
        role="dialog"
        aria-modal="true"
      >
        <div className="flex items-center justify-between px-6 py-4 border-b-2 border-slate-200 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35]">
          <div className="flex items-center gap-3">
            <div className="p-2.5 bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-xl">
              <Edit3 className="w-5 h-5" />
            </div>
            <div className="text-start">
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                {translations.edit_medication || "Edit Medication Details"}
              </h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">
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
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleUpdate} className="flex-1 overflow-y-auto p-6 space-y-5 text-start">
          {medication.allergyConflict && (
            <div className="flex items-start gap-3 p-3.5 bg-amber-50 dark:bg-amber-950/40 border-2 border-amber-300 dark:border-amber-700/60 rounded-xl text-amber-900 dark:text-amber-200 text-xs">
              <AlertTriangle className="w-5 h-5 text-amber-600 shrink-0 mt-0.5" />
              <div>
                <p className="font-bold">
                  Allergy Conflict: {medication.allergyConflict.allergen} ({medication.allergyConflict.severity})
                </p>
              </div>
            </div>
          )}

          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
              {translations.medication_name || "Medication Name"} <span className="text-rose-500">*</span>
            </label>
            <input
              type="text"
              value={medName}
              onChange={(e) => setMedName(e.target.value)}
              className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
                {translations.dosage || "Dosage"} <span className="text-rose-500">*</span>
              </label>
              <input
                type="number"
                min="1"
                value={dosageAmount}
                onChange={(e) => setDosageAmount(e.target.value)}
                className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
              />
            </div>
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
                {translations.unit || "Unit"}
              </label>
              <select
                value={dosageUnit}
                onChange={(e) => setDosageUnit(e.target.value as MedicationItem["dosageUnit"])}
                className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500 cursor-pointer"
              >
                <option value="mg">mg</option>
                <option value="mcg">mcg</option>
                <option value="g">g</option>
                <option value="mL">mL</option>
                <option value="tablets">tablets</option>
                <option value="capsules">capsules</option>
                <option value="puffs">puffs</option>
                <option value="drops">drops</option>
                <option value="IU">IU</option>
              </select>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <CustomSelectDropdown
              label={translations.frequency || "Frequency"}
              required
              options={frequencyOptions}
              value={frequency}
              onChange={(val) => setFrequency(val as MedicationItem["frequency"])}
              searchable={false}
            />

            <CustomSelectDropdown
              label={translations.route || "Administration Route"}
              options={routeOptions}
              value={route}
              onChange={(val) => setRoute(val as MedicationItem["route"])}
              searchable={false}
            />
          </div>

          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <label className="text-xs font-semibold text-slate-700 dark:text-slate-300">
                {translations.duration || "Treatment Duration"} {!isOngoing && <span className="text-rose-500">*</span>}
              </label>
              <label className="flex items-center gap-2 text-xs font-medium text-slate-600 dark:text-slate-300 cursor-pointer">
                <input
                  type="checkbox"
                  checked={isOngoing}
                  onChange={(e) => setIsOngoing(e.target.checked)}
                  className="rounded-md text-blue-600 focus:ring-blue-500 w-4 h-4 cursor-pointer"
                />
                <span>{translations.ongoing_treatment || "Chronic / Ongoing"}</span>
              </label>
            </div>

            {!isOngoing && (
              <div className="grid grid-cols-2 gap-4">
                <input
                  type="number"
                  min="1"
                  value={durationValue}
                  onChange={(e) => setDurationValue(e.target.value)}
                  className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
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
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
              {translations.instructions || "Patient Instructions (Optional)"}
            </label>
            <textarea
              rows={3}
              value={instructions}
              onChange={(e) => setInstructions(e.target.value)}
              className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl p-3 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
            />
          </div>

          <div className="flex items-center justify-end gap-3 pt-4 border-t-2 border-slate-200 dark:border-slate-800">
            <button
              type="button"
              onClick={onClose}
              className="px-5 py-2.5 text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition cursor-pointer"
            >
              {translations.cancel || "Cancel"}
            </button>
            <button
              type="submit"
              className="px-6 py-2.5 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md transition cursor-pointer"
            >
              {translations.update_medication || "Update Medication"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

/*
 * File Name: add_medication_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/services/medical_record_service
 *   - @/context/medical_record_context
 *   - @/context/language_context
 *   - @/components/ui/custom_select_dropdown
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Accessible modal dialog for adding prescription medications with CustomSelectDropdown components, catalog search, dosage/frequency/duration controls, contraindication alerts, and semantic light/dark styling.
 */

"use client";

import React, { useState, useEffect, useId } from "react";
import {
  X,
  Pill,
  AlertTriangle,
  Clock,
  Calendar,
} from "lucide-react";
import {
  MedicationItem,
  MedicationCatalogItem,
} from "@/types/medical_record";
import { MedicalRecordService } from "@/services/medical_record_service";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { useTranslation } from "@/context/language_context";
import CustomSelectDropdown, { DropdownOption } from "@/components/ui/custom_select_dropdown";

interface AddMedicationModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function AddMedicationModal({
  isOpen,
  onClose,
}: AddMedicationModalProps) {
  const { addMedication, patient } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  const [searchQuery, setSearchQuery] = useState("");
  const [catalogItems, setCatalogItems] = useState<MedicationCatalogItem[]>([]);
  const [selectedMedName, setSelectedMedName] = useState("");
  const [dosageAmount, setDosageAmount] = useState<string>("500");
  const [dosageUnit, setDosageUnit] = useState<MedicationItem["dosageUnit"]>("mg");
  const [frequency, setFrequency] = useState<MedicationItem["frequency"]>("Once daily");
  const [isOngoing, setIsOngoing] = useState(false);
  const [durationValue, setDurationValue] = useState<string>("7");
  const [durationUnit, setDurationUnit] = useState<MedicationItem["durationUnit"]>("Days");
  const [route, setRoute] = useState<MedicationItem["route"]>("Oral");
  const [instructions, setInstructions] = useState("");
  const [allergyWarning, setAllergyWarning] = useState<{
    allergen: string;
    severity: string;
  } | null>(null);
  const [formErrors, setFormErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    let active = true;
    const fetchCatalog = async () => {
      const res = await MedicalRecordService.searchMedications(searchQuery);
      if (active) setCatalogItems(res);
    };
    fetchCatalog();
    return () => {
      active = false;
    };
  }, [searchQuery]);

  useEffect(() => {
    if (isOpen) {
      setSelectedMedName("");
      setSearchQuery("");
      setDosageAmount("500");
      setDosageUnit("mg");
      setFrequency("Once daily");
      setIsOngoing(false);
      setDurationValue("7");
      setDurationUnit("Days");
      setRoute("Oral");
      setInstructions("");
      setAllergyWarning(null);
      setFormErrors({});
    }
  }, [isOpen]);

  const handleSelectMedication = (val: string) => {
    setSelectedMedName(val);
    const item = catalogItems.find((c) => c.name === val);
    if (item) {
      setDosageUnit(item.defaultUnit);
      if (item.commonDosages.length > 0) {
        setDosageAmount(String(item.commonDosages[0]));
      }

      if (patient?.activeAllergies) {
        const match = patient.activeAllergies.find((alg) => {
          const medL = item.name.toLowerCase();
          const tagL = (item.allergenTag || "").toLowerCase();
          const algL = alg.name.toLowerCase();
          return (
            medL.includes(algL) ||
            (tagL && algL.includes(tagL)) ||
            (algL.includes("penicillin") && (tagL.includes("penicillin") || medL.includes("amox") || medL.includes("ampic")))
          );
        });
        if (match) {
          setAllergyWarning({
            allergen: match.name,
            severity: match.severity,
          });
        } else {
          setAllergyWarning(null);
        }
      }
    }
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    const errors: Record<string, string> = {};

    const medName = selectedMedName.trim();
    if (!medName) {
      errors.medicationName = translations.medication_name || "Medication name is required";
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

    if ("As Needed" === frequency && !instructions.trim()) {
      errors.instructions = translations.instructions || "Instructions are required for As Needed medications";
    }

    if (Object.keys(errors).length > 0) {
      setFormErrors(errors);
      return;
    }

    const medicationData: MedicationItem = {
      id: `med-${Date.now()}`,
      medicationName: medName,
      dosageAmount: Math.floor(Number(dosageAmount)),
      dosageUnit: dosageUnit,
      frequency: frequency,
      isOngoing: isOngoing,
      durationValue: isOngoing ? undefined : Math.floor(Number(durationValue)),
      durationUnit: isOngoing ? undefined : durationUnit,
      route: route,
      instructions: instructions.trim() || undefined,
      isIncomplete: false,
      allergyConflict: allergyWarning || undefined,
    };

    addMedication(medicationData);
    onClose();
  };

  if (!isOpen) return null;

  const medOptions: DropdownOption[] = catalogItems.map((cat) => ({
    value: cat.name,
    label: cat.name,
    subLabel: `${cat.category} • Default: ${cat.commonDosages.join("/")} ${cat.defaultUnit}`,
  }));

  const frequencyOptions: DropdownOption[] = [
    { value: "Once daily", label: "Once daily" },
    { value: "Twice daily", label: "Twice daily (q12h)" },
    { value: "Three times daily", label: "Three times daily (q8h)" },
    { value: "Four times daily", label: "Four times daily (q6h)" },
    { value: "Every 4 hours", label: "Every 4 hours" },
    { value: "As Needed", label: "As Needed (PRN)" },
    { value: "At Bedtime", label: "At Bedtime (QHS)" },
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
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b-2 border-slate-200 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35] shrink-0">
          <div className="flex items-center gap-3">
            <div className="p-2.5 bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-xl">
              <Pill className="w-5 h-5" />
            </div>
            <div className="text-start">
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                {translations.add_medication || "Add Medication Details"}
              </h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {translations.medications_and_prescriptions || "Medication & Prescriptions"}
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

        {/* Body */}
        <form id="add-medication-form" onSubmit={handleSave} className="flex-1 overflow-y-auto p-6 space-y-5 text-start pb-28">
          {/* Allergy Warning */}
          {allergyWarning && (
            <div className="flex items-start gap-3 p-3.5 bg-amber-50 dark:bg-amber-950/40 border-2 border-amber-300 dark:border-amber-700/60 rounded-xl text-amber-900 dark:text-amber-200 text-xs animate-in slide-in-from-top-1">
              <AlertTriangle className="w-5 h-5 text-amber-600 dark:text-amber-400 shrink-0 mt-0.5" />
              <div className="flex-1">
                <p className="font-bold">
                  {translations.allergy_alert || "Allergy Alert"}: {allergyWarning.allergen} ({allergyWarning.severity})
                </p>
                <p className="mt-0.5 text-amber-800 dark:text-amber-300">
                  {translations.allergy_conflict_detected || "Patient has a documented sensitivity to this medication class. Clinical acknowledgment required."}
                </p>
              </div>
            </div>
          )}

          {/* 1. Medication Name Custom Dropdown */}
          <CustomSelectDropdown
            label={translations.medication_name || "Medication Name"}
            required
            options={medOptions}
            value={selectedMedName}
            onChange={handleSelectMedication}
            placeholder="Search or select medication..."
            searchPlaceholder="Type to search medication formulary..."
            error={formErrors.medicationName}
            bottomActionText="+ Add Custom Medication Name"
            onBottomAction={() => {
              const customName = prompt("Enter custom medication name:");
              if (customName && customName.trim()) {
                handleSelectMedication(customName.trim());
              }
            }}
          />

          {/* 2. Dosage & Unit */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
                {translations.dosage || "Dosage"} <span className="text-rose-500">*</span>
              </label>
              <input
                type="number"
                min="1"
                step="any"
                value={dosageAmount}
                onChange={(e) => setDosageAmount(e.target.value)}
                placeholder="500"
                className={`w-full bg-slate-50 dark:bg-[#131E35] border-2 ${
                  formErrors.dosageAmount
                    ? "border-rose-500"
                    : "border-slate-200 dark:border-slate-700 focus:border-blue-500"
                } rounded-xl px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none transition`}
              />
              {formErrors.dosageAmount && (
                <p className="text-xs text-rose-500 mt-1">{formErrors.dosageAmount}</p>
              )}
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

          {/* 3. Frequency & Route */}
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

          {/* 4. Duration & Ongoing Checkbox */}
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
                <div>
                  <input
                    type="number"
                    min="1"
                    value={durationValue}
                    onChange={(e) => setDurationValue(e.target.value)}
                    placeholder="7"
                    className={`w-full bg-slate-50 dark:bg-[#131E35] border-2 ${
                      formErrors.durationValue
                        ? "border-rose-500"
                        : "border-slate-200 dark:border-slate-700 focus:border-blue-500"
                    } rounded-xl px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none transition`}
                  />
                  {formErrors.durationValue && (
                    <p className="text-xs text-rose-500 mt-1">{formErrors.durationValue}</p>
                  )}
                </div>

                <div>
                  <CustomSelectDropdown
                    options={durationUnitOptions}
                    value={durationUnit || "Days"}
                    onChange={(val) => setDurationUnit(val as MedicationItem["durationUnit"])}
                    searchable={false}
                  />
                </div>
              </div>
            )}
          </div>

          {/* 5. Instructions */}
          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
              {translations.instructions || "Patient Instructions (Optional)"}
            </label>
            <textarea
              rows={3}
              value={instructions}
              onChange={(e) => setInstructions(e.target.value)}
              placeholder="e.g. Take with meals and a full glass of water..."
              className={`w-full bg-slate-50 dark:bg-[#131E35] border-2 ${
                formErrors.instructions
                  ? "border-rose-500"
                  : "border-slate-200 dark:border-slate-700 focus:border-blue-500"
              } rounded-xl p-3 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none transition`}
            />
            {formErrors.instructions && (
              <p className="text-xs text-rose-500 mt-1">{formErrors.instructions}</p>
            )}
          </div>
        </form>

        {/* Pinned Footer */}
        <div className="flex items-center justify-end gap-3 px-6 py-4 border-t-2 border-slate-200 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35] shrink-0">
          <button
            type="button"
            onClick={onClose}
            className="px-5 py-2.5 text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition cursor-pointer"
          >
            {translations.cancel || "Cancel"}
          </button>
          <button
            type="submit"
            form="add-medication-form"
            className="px-6 py-2.5 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md transition cursor-pointer"
          >
            {translations.add_to_record || "Add to Record"}
          </button>
        </div>
      </div>
    </div>
  );
}

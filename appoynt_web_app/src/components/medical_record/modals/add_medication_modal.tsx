/*
 * File Name: add_medication_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/services/medical_record_service
 *   - @/context/medical_record_context
 *   - @/context/language_context
 *   - @/components/ui/custom_select
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Accessible modal dialog for adding or editing prescription medications with CustomSelect components, aligned form inputs, catalog autocomplete, dosage/duration controls, real-time allergy conflict alerts, and semantic light/dark styling.
 */

"use client";

import React, { useState, useEffect, useId } from "react";
import {
  X,
  Pill,
  AlertTriangle,
  Search,
  CheckCircle,
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
import { CustomSelect } from "@/components/ui/custom_select";

interface AddMedicationModalProps {
  isOpen: boolean;
  onClose: () => void;
  medicationToEdit?: MedicationItem | null;
}

export default function AddMedicationModal({
  isOpen,
  onClose,
  medicationToEdit,
}: AddMedicationModalProps) {
  const { addMedication, updateMedication, patient } =
    useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  const [searchQuery, setSearchQuery] = useState("");
  const [searchResults, setSearchResults] = useState<MedicationCatalogItem[]>([]);
  const [selectedMedName, setSelectedMedName] = useState("");
  const [dosageAmount, setDosageAmount] = useState<number | string>(500);
  const [dosageUnit, setDosageUnit] = useState<MedicationItem["dosageUnit"]>("mg");
  const [frequency, setFrequency] =
    useState<MedicationItem["frequency"]>("Once daily");
  const [isOngoing, setIsOngoing] = useState(false);
  const [durationValue, setDurationValue] = useState<number | string>(7);
  const [durationUnit, setDurationUnit] =
    useState<MedicationItem["durationUnit"]>("Days");
  const [route, setRoute] = useState<MedicationItem["route"]>("Oral");
  const [instructions, setInstructions] = useState("");
  const [allergyWarning, setAllergyWarning] = useState<{
    allergen: string;
    severity: string;
  } | null>(null);
  const [formErrors, setFormErrors] = useState<Record<string, string>>({});

  const searchInputId = useId();

  useEffect(() => {
    if (medicationToEdit) {
      setSelectedMedName(medicationToEdit.medicationName);
      setSearchQuery(medicationToEdit.medicationName);
      setDosageAmount(medicationToEdit.dosageAmount);
      setDosageUnit(medicationToEdit.dosageUnit);
      setFrequency(medicationToEdit.frequency);
      setIsOngoing(medicationToEdit.isOngoing);
      setDurationValue(medicationToEdit.durationValue || 7);
      setDurationUnit(medicationToEdit.durationUnit || "Days");
      setRoute(medicationToEdit.route);
      setInstructions(medicationToEdit.instructions || "");
      setAllergyWarning(medicationToEdit.allergyConflict || null);
    } else {
      setSelectedMedName("");
      setSearchQuery("");
      setDosageAmount(500);
      setDosageUnit("mg");
      setFrequency("Once daily");
      setIsOngoing(false);
      setDurationValue(7);
      setDurationUnit("Days");
      setRoute("Oral");
      setInstructions("");
      setAllergyWarning(null);
    }
    setFormErrors({});
  }, [medicationToEdit, isOpen]);

  useEffect(() => {
    let active = true;
    const fetchCatalog = async () => {
      if (searchQuery.trim().length > 0) {
        const res = await MedicalRecordService.searchMedications(searchQuery);
        if (active) setSearchResults(res);
      } else {
        if (active) setSearchResults([]);
      }
    };
    fetchCatalog();
    return () => {
      active = false;
    };
  }, [searchQuery]);

  const handleSelectCatalogItem = (item: MedicationCatalogItem) => {
    setSelectedMedName(item.name);
    setSearchQuery(item.name);
    setSearchResults([]);
    setDosageUnit(item.defaultUnit);
    if (item.commonDosages.length > 0) {
      setDosageAmount(Number(item.commonDosages[0]) || 500);
    }

    if (patient?.activeAllergies) {
      const match = patient.activeAllergies.find((alg) => {
        const medL = item.name.toLowerCase();
        const tagL = (item.allergenTag || "").toLowerCase();
        const algL = alg.name.toLowerCase();
        return (
          medL.includes(algL) ||
          (tagL && algL.includes(tagL)) ||
          (algL.includes("penicillin") && tagL.includes("penicillin"))
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
  };

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    const errors: Record<string, string> = {};

    const medName = selectedMedName.trim() || searchQuery.trim();
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
      id: medicationToEdit ? medicationToEdit.id : `med-${Date.now()}`,
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

    if (medicationToEdit) {
      updateMedication(medicationData);
    } else {
      addMedication(medicationData);
    }

    onClose();
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-200 text-slate-900 dark:text-slate-100">
      <div
        className="relative w-full max-w-xl bg-white dark:bg-[#0E1726] rounded-2xl shadow-2xl border-2 border-slate-200 dark:border-slate-800 overflow-hidden flex flex-col max-h-[90vh]"
        role="dialog"
        aria-modal="true"
      >
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b-2 border-slate-200 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35]">
          <div className="flex items-center gap-3">
            <div className="p-2.5 bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-xl">
              <Pill className="w-5 h-5" />
            </div>
            <div className="text-start">
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                {medicationToEdit ? (translations.edit_medication || "Edit Medication") : (translations.add_medication || "Add Medication")}
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
        <form onSubmit={handleSave} className="flex-1 overflow-y-auto p-6 space-y-5 text-start">
          {/* Allergy Warning */}
          {allergyWarning && (
            <div className="flex items-start gap-3 p-3.5 bg-amber-50 dark:bg-amber-950/40 border border-amber-300 dark:border-amber-700/60 rounded-xl text-amber-900 dark:text-amber-200 text-xs animate-in slide-in-from-top-1">
              <AlertTriangle className="w-5 h-5 text-amber-600 dark:text-amber-400 shrink-0 mt-0.5" />
              <div className="flex-1">
                <p className="font-bold">
                  {translations.allergy_alert || "Allergy Alert"}: {allergyWarning.allergen} ({allergyWarning.severity})
                </p>
                <p className="mt-0.5 text-amber-800 dark:text-amber-300">
                  {translations.allergy_conflict_warning
                    ? translations.allergy_conflict_warning
                        .replace("{medication}", selectedMedName || searchQuery)
                        .replace("{allergen}", allergyWarning.allergen)
                    : `Warning: ${selectedMedName || searchQuery} conflicts with known allergy ${allergyWarning.allergen}`}
                </p>
              </div>
            </div>
          )}

          {/* Search Input */}
          <div className="relative space-y-1.5">
            <label
              htmlFor={searchInputId}
              className="block text-xs font-semibold text-slate-700 dark:text-slate-300"
            >
              <span className="flex items-center justify-between">
                <span>{translations.medication_name || "Medication Name"} <span className="text-red-500 ms-0.5">*</span></span>
                {selectedMedName && (
                  <span className="text-emerald-600 dark:text-emerald-400 text-xs font-normal flex items-center gap-1">
                    <CheckCircle className="w-3.5 h-3.5" /> {translations.valid_icd10_selected || "Selected"}
                  </span>
                )}
              </span>
            </label>
            <div className="relative">
              <input
                id={searchInputId}
                type="text"
                value={searchQuery}
                onChange={(e) => {
                  setSearchQuery(e.target.value);
                  setSelectedMedName(e.target.value);
                }}
                placeholder="e.g. Amoxicillin, Lisinopril, Metformin..."
                className={`w-full ps-9 pe-4 h-11 bg-slate-50 dark:bg-[#131E35] border ${
                  formErrors.medicationName
                    ? "border-red-500 dark:border-red-500 focus:ring-red-500/20 focus:border-red-500"
                    : "border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600 focus:ring-blue-500/20 focus:border-blue-500"
                } rounded-xl text-sm font-medium text-slate-800 dark:text-slate-100 placeholder:text-slate-400 focus:outline-none focus:ring-2 transition-all`}
              />
              <Search className="w-4 h-4 text-slate-400 absolute start-3 top-1/2 -translate-y-1/2" />
            </div>

            {/* Dropdown */}
            {searchResults.length > 0 && (
              <div className="absolute top-full start-0 end-0 mt-1 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-xl shadow-xl z-20 max-h-48 overflow-y-auto divide-y divide-slate-100 dark:divide-slate-800">
                {searchResults.map((item) => (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => handleSelectCatalogItem(item)}
                    className="w-full text-start px-4 py-2.5 text-xs hover:bg-blue-50 dark:hover:bg-blue-900/30 flex items-center justify-between transition cursor-pointer"
                  >
                    <div>
                      <p className="font-semibold text-slate-900 dark:text-slate-100">
                        {item.name}
                      </p>
                      <p className="text-slate-500 dark:text-slate-400 text-[11px]">
                        {item.category} • Default: {item.defaultUnit}
                      </p>
                    </div>
                    {item.allergenTag && (
                      <span className="px-2 py-0.5 text-[10px] font-semibold bg-amber-100 dark:bg-amber-900/40 text-amber-700 dark:text-amber-300 rounded-md">
                        {item.allergenTag}
                      </span>
                    )}
                  </button>
                ))}
              </div>
            )}
            {formErrors.medicationName && (
              <p className="text-xs text-red-500">{formErrors.medicationName}</p>
            )}
          </div>

          {/* Dosage & Unit Grid (Symmetrical Heights) */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
                {translations.dosage || "Dosage"} <span className="text-red-500 ms-0.5">*</span>
              </label>
              <input
                type="number"
                min="1"
                max="10000"
                value={dosageAmount}
                onChange={(e) => setDosageAmount(e.target.value)}
                className={`w-full px-4 h-11 bg-slate-50 dark:bg-[#131E35] border ${
                  formErrors.dosageAmount
                    ? "border-red-500 dark:border-red-500 focus:ring-red-500/20 focus:border-red-500"
                    : "border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600 focus:ring-blue-500/20 focus:border-blue-500"
                } rounded-xl text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 transition-all`}
              />
              {formErrors.dosageAmount && (
                <p className="text-xs text-red-500">{formErrors.dosageAmount}</p>
              )}
            </div>

            <CustomSelect
              label={`${translations.dosage || "Dosage"} Unit`}
              required
              value={dosageUnit}
              onChange={(e) =>
                setDosageUnit(e.target.value as MedicationItem["dosageUnit"])
              }
            >
              <option value="mg">mg (milligrams)</option>
              <option value="mL">mL (milliliters)</option>
              <option value="tablet">tablet(s)</option>
              <option value="capsule">capsule(s)</option>
              <option value="drops">drop(s)</option>
              <option value="puff">puff(s)</option>
              <option value="patch">patch</option>
              <option value="IU">IU (International Units)</option>
            </CustomSelect>
          </div>

          {/* Frequency & Route Grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <CustomSelect
              label={translations.frequency || "Frequency"}
              required
              icon={Clock}
              value={frequency}
              onChange={(e) =>
                setFrequency(e.target.value as MedicationItem["frequency"])
              }
            >
              <option value="Once daily">Once daily</option>
              <option value="Twice daily">Twice daily</option>
              <option value="Three times daily">Three times daily</option>
              <option value="Four times daily">Four times daily</option>
              <option value="Every 8 hours">Every 8 hours</option>
              <option value="Every 12 hours">Every 12 hours</option>
              <option value="With meals">With meals</option>
              <option value="Before bed">Before bed</option>
              <option value="As Needed">As Needed (PRN)</option>
            </CustomSelect>

            <CustomSelect
              label={translations.route || "Route of Administration"}
              required
              value={route}
              onChange={(e) =>
                setRoute(e.target.value as MedicationItem["route"])
              }
            >
              <option value="Oral">Oral</option>
              <option value="Topical">Topical</option>
              <option value="Inhalation">Inhalation</option>
              <option value="Intravenous">Intravenous</option>
              <option value="Intramuscular">Intramuscular</option>
              <option value="Subcutaneous">Subcutaneous</option>
              <option value="Ophthalmic">Ophthalmic (Eye)</option>
              <option value="Otic">Otic (Ear)</option>
            </CustomSelect>
          </div>

          {/* Duration vs Ongoing */}
          <div className="p-4 bg-slate-50 dark:bg-[#131E35] rounded-xl border border-slate-200 dark:border-slate-700 space-y-3">
            <div className="flex items-center justify-between">
              <label className="text-xs font-semibold text-slate-700 dark:text-slate-300 flex items-center gap-1.5">
                <Calendar className="w-3.5 h-3.5 text-blue-500" />
                <span>{translations.duration || "Duration"}</span>
              </label>
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={isOngoing}
                  onChange={(e) => setIsOngoing(e.target.checked)}
                  className="rounded border-slate-300 text-blue-600 focus:ring-blue-500 cursor-pointer"
                />
                <span className="text-xs font-semibold text-slate-700 dark:text-slate-300">
                  Continuous / Ongoing
                </span>
              </label>
            </div>

            {!isOngoing ? (
              <div className="grid grid-cols-2 gap-3 animate-in fade-in duration-150">
                <input
                  type="number"
                  min="1"
                  max="365"
                  value={durationValue}
                  onChange={(e) => setDurationValue(e.target.value)}
                  placeholder="Number"
                  className="w-full px-4 h-11 bg-white dark:bg-[#0E1726] border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500"
                />
                <CustomSelect
                  value={durationUnit}
                  onChange={(e) =>
                    setDurationUnit(
                      e.target.value as MedicationItem["durationUnit"]
                    )
                  }
                  selectClassName="bg-white dark:bg-[#0E1726]"
                >
                  <option value="Days">Days</option>
                  <option value="Weeks">Weeks</option>
                  <option value="Months">Months</option>
                  <option value="Years">Years</option>
                </CustomSelect>
              </div>
            ) : (
              <p className="text-xs text-slate-500 dark:text-slate-400 italic">
                {translations.prescription_instructions_patient || "Continuous medication without a preset expiration."}
              </p>
            )}
            {formErrors.durationValue && (
              <p className="text-xs text-red-500">{formErrors.durationValue}</p>
            )}
          </div>

          {/* Instructions */}
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
              <span className="flex items-center justify-between">
                <span>{translations.instructions || "Patient Instructions"}</span>
                <span className="text-[11px] text-slate-400">Max 1000 chars</span>
              </span>
            </label>
            <textarea
              rows={2}
              maxLength={1000}
              value={instructions}
              onChange={(e) => setInstructions(e.target.value)}
              placeholder="e.g. Take 1 tablet with full glass of water after food."
              className={`w-full p-3 bg-slate-50 dark:bg-[#131E35] border ${
                formErrors.instructions
                  ? "border-red-500 dark:border-red-500 focus:ring-red-500/20 focus:border-red-500"
                  : "border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600 focus:ring-blue-500/20 focus:border-blue-500"
              } rounded-xl text-sm font-medium text-slate-800 dark:text-slate-100 placeholder:text-slate-400 focus:outline-none focus:ring-2 transition-all`}
            />
            {formErrors.instructions && (
              <p className="text-xs text-red-500">{formErrors.instructions}</p>
            )}
          </div>

          {/* Footer Actions */}
          <div className="flex items-center justify-end gap-3 pt-4 border-t-2 border-slate-200 dark:border-slate-800">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-sm font-semibold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition cursor-pointer"
            >
              {translations.cancel || "Cancel"}
            </button>
            <button
              type="submit"
              className="px-5 py-2 text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-sm transition flex items-center gap-1.5 cursor-pointer"
            >
              <Pill className="w-4 h-4" />
              {medicationToEdit
                ? (translations.edit_medication || "Save Changes")
                : (translations.add_medication || "Add Medication")}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

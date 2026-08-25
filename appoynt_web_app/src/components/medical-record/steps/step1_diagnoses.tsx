/*
 * File Name: step1_diagnoses.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.2.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/services/medical_record_service
 *   - @/components/medical-record/editor/clinical_notes_editor
 *   - @/components/medical-record/modals/confirm_deletion_modal
 *   - @/components/ui/custom_select_dropdown
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Step 1 Clinical Consultation presentation component providing dual-column ICD-10 diagnosis search, custom styled clinical outcome assessment dropdown, duplicate validation, ICD-10 detail cards, rich text clinical notes editor, autosave footer, and discard/next workflow navigation.
 */

"use client";

import React, { useState, useEffect } from "react";
import {
  Stethoscope,
  CheckCircle2,
  AlertCircle,
  Search,
  Plus,
  Trash2,
  ExternalLink,
  ArrowRight,
  Save,
  X,
  FileCheck,
} from "lucide-react";
import {
  Icd10CatalogItem,
  DiagnosisItem,
} from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { MedicalRecordService } from "@/services/medical_record_service";
import ClinicalNotesEditor from "@/components/medical-record/editor/clinical_notes_editor";
import ConfirmDeletionModal from "@/components/medical-record/modals/confirm_deletion_modal";
import CustomSelectDropdown, { DropdownOption } from "@/components/ui/custom_select_dropdown";
import { useTranslation } from "@/context/language_context";

export default function Step1Diagnoses() {
  const { translations } = useTranslation();

  const {
    record,
    setClinicalOutcome,
    setPrimaryDiagnosis,
    addSecondaryDiagnosis,
    removeSecondaryDiagnosis,
    setClinicalNotes,
    setCurrentStep,
    saveDraftNow,
    isSaving,
  } = useMedicalRecordWorkflow();

  const [primarySearch, setPrimarySearch] = useState("");
  const [primaryResults, setPrimaryResults] = useState<Icd10CatalogItem[]>([]);
  const [secondarySearch, setSecondarySearch] = useState("");
  const [secondaryResults, setSecondaryResults] = useState<Icd10CatalogItem[]>([]);
  const [selectedDetailsItem, setSelectedDetailsItem] = useState<Icd10CatalogItem | null>(null);

  const [validationErrors, setValidationErrors] = useState<Record<string, string>>({});
  const [saveBanner, setSaveBanner] = useState<string | null>(null);
  const [isDiscardModalOpen, setIsDiscardModalOpen] = useState(false);

  useEffect(() => {
    let active = true;
    const search = async () => {
      if (primarySearch.trim().length >= 1) {
        const res = await MedicalRecordService.searchIcd10Catalog(primarySearch);
        if (active) {
          setPrimaryResults(res);
        } else {
          // No action needed
        }
      } else {
        if (active) {
          setPrimaryResults([]);
        } else {
          // No action needed
        }
      }
    };
    search();
    return () => {
      active = false;
    };
  }, [primarySearch]);

  useEffect(() => {
    let active = true;
    const search = async () => {
      if (secondarySearch.trim().length >= 1) {
        const res = await MedicalRecordService.searchIcd10Catalog(secondarySearch);
        if (active) {
          setSecondaryResults(res);
        } else {
          // No action needed
        }
      } else {
        if (active) {
          setSecondaryResults([]);
        } else {
          // No action needed
        }
      }
    };
    search();
    return () => {
      active = false;
    };
  }, [secondarySearch]);

  const handleSelectPrimary = (item: Icd10CatalogItem) => {
    const diag: DiagnosisItem = {
      code: item.code,
      title: item.title,
      category: item.category,
      isPrimary: true,
      description: item.description,
    };
    setPrimaryDiagnosis(diag);
    setPrimarySearch("");
    setPrimaryResults([]);
    setValidationErrors((prev) => {
      const copy = { ...prev };
      delete copy.primaryDiagnosis;
      return copy;
    });
  };

  const handleSelectSecondary = (item: Icd10CatalogItem) => {
    if (record.primaryDiagnosis?.code === item.code) {
      setValidationErrors((prev) => ({
        ...prev,
        secondaryDiagnosis: "Secondary diagnosis must be different from primary",
      }));
      return;
    } else {
      // Different from primary diagnosis
    }

    if (record.secondaryDiagnoses?.some((d) => d.code === item.code)) {
      setValidationErrors((prev) => ({
        ...prev,
        secondaryDiagnosis: "This secondary diagnosis is already added",
      }));
      return;
    } else {
      // Not yet added
    }

    const diag: DiagnosisItem = {
      code: item.code,
      title: item.title,
      category: item.category,
      isPrimary: false,
      description: item.description,
    };
    addSecondaryDiagnosis(diag);
    setSecondarySearch("");
    setSecondaryResults([]);
    setValidationErrors((prev) => {
      const copy = { ...prev };
      delete copy.secondaryDiagnosis;
      return copy;
    });
  };

  const validateStep1 = (): boolean => {
    const errors: Record<string, string> = {};

    if (!record.primaryDiagnosis || !record.primaryDiagnosis.code) {
      errors.primaryDiagnosis = translations.primary_diagnosis_required || "Primary diagnosis is required";
    } else {
      // Primary diagnosis valid
    }

    const notesLength = (record.clinicalNotes || "").replace(/\s+/g, "").length;
    if (notesLength < 10) {
      errors.clinicalNotes = translations.min_notes_error || "Please enter detailed notes (at least 10 characters)";
    } else {
      // Clinical notes valid
    }

    setValidationErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleNext = () => {
    if (validateStep1()) {
      saveDraftNow();
      setCurrentStep(2);
    } else {
      // Validation failed
    }
  };

  const handleManualSave = async () => {
    await saveDraftNow();
    setSaveBanner(translations.draft_saved || "Draft successfully saved");
    setTimeout(() => setSaveBanner(null), 3000);
  };

  const isPrimarySelected = !!record.primaryDiagnosis?.code;
  const notesLength = (record.clinicalNotes || "").replace(/\s+/g, "").length;
  const isNotesValid = notesLength >= 10;
  const canProceed = isPrimarySelected && isNotesValid;

  const outcomeOptions: DropdownOption[] = [
    {
      value: "DISCHARGED",
      label: translations.outcome_discharged || "Discharged / Resolved",
      dotColor: "bg-emerald-500",
    },
    {
      value: "FOLLOW_UP_REQUIRED",
      label: translations.outcome_follow_up || "Follow-up Required",
      dotColor: "bg-amber-500",
    },
    {
      value: "REFERRED_TO_SPECIALIST",
      label: translations.outcome_specialist || "Referred to Specialist",
      dotColor: "bg-purple-500",
    },
    {
      value: "ADMITTED_TO_HOSPITAL",
      label: translations.outcome_hospital || "Admitted to Hospital",
      dotColor: "bg-rose-500",
    },
  ];

  return (
    <div className="space-y-6 text-start">
      {/* 1. Header Banner */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs">
        <div className="flex items-center gap-3">
          <div className="p-3 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-xl">
            <Stethoscope className="w-6 h-6" />
          </div>
          <div>
            <h2 className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
              {translations.step1_title || "Step 1: Diagnoses & Clinical Notes"}
            </h2>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              {translations.step1_desc || translations.step1_subtitle || "Identify standardized ICD-10 diagnostic classifications and document thorough clinical findings."}
            </p>
          </div>
        </div>

        {/* Clinical Outcome Selector */}
        <div className="flex items-center gap-2.5">
          <label className="text-xs font-semibold text-slate-600 dark:text-slate-300 whitespace-nowrap">
            {translations.clinical_outcome || translations.medrec_outcome_title || "Outcome"}:
          </label>
          <div className="w-56">
            <CustomSelectDropdown
              options={outcomeOptions}
              value={record.clinicalOutcome || "FOLLOW_UP_REQUIRED"}
              onChange={(val) => setClinicalOutcome(val as any)}
              searchable={false}
              triggerClassName="h-9 px-3 py-1.5 text-xs font-semibold rounded-xl bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 text-slate-800 dark:text-slate-100 shadow-2xs"
            />
          </div>
        </div>
      </div>

      {/* 2. Dual Diagnosis 2-Column Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
        {/* Left Column: Primary Diagnosis */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4">
          <div className="flex items-center justify-between">
            <label className="block text-xs font-bold text-slate-900 dark:text-white uppercase tracking-wider">
              {translations.primary_diagnosis || "Primary Diagnosis"} <span className="text-rose-500">*</span>
            </label>
            {isPrimarySelected ? (
              <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-950/60 px-2.5 py-0.5 rounded-full border border-emerald-300 dark:border-emerald-700">
                <CheckCircle2 className="w-3.5 h-3.5" />
                <span>✓ {translations.valid_icd10 || "Valid ICD-10 code selected"}</span>
              </span>
            ) : (
              <span className="text-[11px] text-rose-500 font-semibold">
                {translations.required_badge || "Required"}
              </span>
            )}
          </div>

          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input
              type="text"
              value={primarySearch}
              onChange={(e) => setPrimarySearch(e.target.value)}
              placeholder={translations.search_icd10_placeholder || "Search ICD-10 by code or keyword (e.g., I10, Hypertension)..."}
              className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl ps-10 pe-4 py-2.5 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 placeholder-slate-400 focus:outline-none focus:border-blue-500 transition"
            />

            {/* Results Dropdown */}
            {primaryResults.length > 0 && (
              <div className="absolute start-0 top-full mt-1.5 w-full bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-700 rounded-xl shadow-xl p-1.5 z-30 max-h-56 overflow-y-auto space-y-1">
                {primaryResults.map((item) => (
                  <button
                    key={item.code}
                    type="button"
                    onClick={() => handleSelectPrimary(item)}
                    className="w-full text-start p-2.5 hover:bg-blue-50 dark:hover:bg-blue-950/60 rounded-lg transition flex items-center justify-between cursor-pointer"
                  >
                    <div className="min-w-0 pe-2">
                      <div className="flex items-center gap-2">
                        <span className="font-mono text-xs font-bold text-blue-600 dark:text-blue-400 bg-blue-100 dark:bg-blue-900/60 px-2 py-0.5 rounded">
                          {item.code}
                        </span>
                        <span className="text-xs font-bold text-slate-900 dark:text-white truncate">
                          {item.title}
                        </span>
                      </div>
                      <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5">
                        {item.category}
                      </p>
                    </div>
                    <Plus className="w-4 h-4 text-blue-600 shrink-0" />
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Active Primary Diagnosis Card */}
          {record.primaryDiagnosis && record.primaryDiagnosis.code ? (
            <div className="p-4 bg-blue-50/70 dark:bg-blue-950/40 border-2 border-blue-200 dark:border-blue-800/80 rounded-xl space-y-2">
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-2">
                  <span className="font-mono text-xs font-extrabold bg-blue-600 text-white px-2.5 py-1 rounded-lg">
                    {record.primaryDiagnosis.code}
                  </span>
                  <h4 className="text-xs font-bold text-slate-900 dark:text-white truncate">
                    {record.primaryDiagnosis.title || record.primaryDiagnosis.name || "Primary Diagnosis"}
                  </h4>
                </div>
              </div>
              <p className="text-xs text-slate-600 dark:text-slate-300">
                {record.primaryDiagnosis.description || `Category: ${record.primaryDiagnosis.category || "Clinical Diagnosis"}`}
              </p>
              <button
                type="button"
                onClick={() => {
                  setSelectedDetailsItem({
                    code: record.primaryDiagnosis!.code,
                    title: record.primaryDiagnosis!.title || record.primaryDiagnosis!.name || "Primary Diagnosis",
                    category: record.primaryDiagnosis!.category || "General",
                    description: record.primaryDiagnosis!.description || "Primary clinical diagnosis code recorded.",
                  });
                }}
                className="text-xs font-bold text-blue-600 dark:text-blue-400 hover:underline inline-flex items-center gap-1 pt-1 cursor-pointer"
              >
                <span>{translations.view_icd10_details || "View ICD-10 Details"}</span>
                <ExternalLink className="w-3 h-3" />
              </button>
            </div>
          ) : (
            <div className="p-6 border-2 border-dashed border-slate-200 dark:border-slate-800 rounded-xl text-center text-xs text-slate-400 dark:text-slate-500">
              {translations.search_icd10_placeholder || "Search the ICD-10 catalog above to bind primary condition."}
            </div>
          )}

          {validationErrors.primaryDiagnosis && (
            <p className="text-xs text-rose-500 font-semibold flex items-center gap-1">
              <AlertCircle className="w-3.5 h-3.5" />
              <span>{validationErrors.primaryDiagnosis}</span>
            </p>
          )}
        </div>

        {/* Right Column: Secondary Diagnosis (Optional) */}
        <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4">
          <div className="flex items-center justify-between">
            <label className="block text-xs font-bold text-slate-900 dark:text-white uppercase tracking-wider">
              {translations.secondary_diagnoses || translations.secondary_diagnosis || "Secondary Diagnoses (Optional)"}
            </label>
            <span className="text-[11px] text-slate-400 font-medium">
              {(translations.added_count || "Added {count}").replace("{count}", String((record.secondaryDiagnoses || []).length))}
            </span>
          </div>

          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
            <input
              type="text"
              value={secondarySearch}
              onChange={(e) => setSecondarySearch(e.target.value)}
              placeholder={translations.search_icd10_placeholder || "Search additional comorbidities..."}
              className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl ps-10 pe-4 py-2.5 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 placeholder-slate-400 focus:outline-none focus:border-blue-500 transition"
            />

            {/* Results Dropdown */}
            {secondaryResults.length > 0 && (
              <div className="absolute start-0 top-full mt-1.5 w-full bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-700 rounded-xl shadow-xl p-1.5 z-30 max-h-56 overflow-y-auto space-y-1">
                {secondaryResults.map((item) => (
                  <button
                    key={item.code}
                    type="button"
                    onClick={() => handleSelectSecondary(item)}
                    className="w-full text-start p-2.5 hover:bg-slate-100 dark:hover:bg-[#131E35] rounded-lg transition flex items-center justify-between cursor-pointer"
                  >
                    <div className="min-w-0 pe-2">
                      <div className="flex items-center gap-2">
                        <span className="font-mono text-xs font-bold text-slate-700 dark:text-slate-300 bg-slate-200 dark:bg-slate-800 px-2 py-0.5 rounded">
                          {item.code}
                        </span>
                        <span className="text-xs font-bold text-slate-900 dark:text-white truncate">
                          {item.title}
                        </span>
                      </div>
                      <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5">
                        {item.category}
                      </p>
                    </div>
                    <Plus className="w-4 h-4 text-blue-600 shrink-0" />
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Secondary Diagnoses Chips / Cards */}
          <div className="space-y-2 max-h-48 overflow-y-auto">
            {(record.secondaryDiagnoses || []).length > 0 ? (
              record.secondaryDiagnoses!.map((sec) => (
                <div
                  key={sec.code}
                  className="p-3 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl flex items-center justify-between gap-3"
                >
                  <div className="flex items-center gap-2.5 min-w-0">
                    <span className="font-mono text-xs font-bold text-slate-800 dark:text-slate-200 bg-slate-200 dark:bg-slate-800 px-2 py-0.5 rounded">
                      {sec.code}
                    </span>
                    <span className="text-xs font-bold text-slate-900 dark:text-white truncate">
                      {sec.title || sec.name || "Secondary Diagnosis"}
                    </span>
                  </div>
                  <button
                    type="button"
                    onClick={() => removeSecondaryDiagnosis(sec.code)}
                    className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/50 transition cursor-pointer"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                </div>
              ))
            ) : (
              <div className="p-6 border-2 border-dashed border-slate-200 dark:border-slate-800 rounded-xl text-center text-xs text-slate-400 dark:text-slate-500">
                {translations.no_secondary_diagnoses || "No secondary diagnoses added. Optional for recording comorbidities."}
              </div>
            )}
          </div>

          {validationErrors.secondaryDiagnosis && (
            <p className="text-xs text-rose-500 font-semibold flex items-center gap-1">
              <AlertCircle className="w-3.5 h-3.5" />
              <span>{validationErrors.secondaryDiagnosis}</span>
            </p>
          )}
        </div>
      </div>

      {/* 3. Clinical Notes Rich Text Area */}
      <ClinicalNotesEditor
        value={record.clinicalNotes || ""}
        onChange={(val) => {
          setClinicalNotes(val);
          if (val.replace(/\s+/g, "").length >= 10) {
            setValidationErrors((prev) => {
              const copy = { ...prev };
              delete copy.clinicalNotes;
              return copy;
            });
          } else {
            // No action needed
          }
        }}
        error={validationErrors.clinicalNotes}
      />

      {/* 4. ICD-10 Details Modal */}
      {selectedDetailsItem && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in">
          <div className="bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 p-6 max-w-md w-full space-y-4 shadow-2xl">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="font-mono text-sm font-extrabold bg-blue-600 text-white px-2.5 py-1 rounded-lg">
                  {selectedDetailsItem.code}
                </span>
                <span className="text-xs font-bold text-slate-500 dark:text-slate-400">
                  {selectedDetailsItem.category}
                </span>
              </div>
              <button
                type="button"
                onClick={() => setSelectedDetailsItem(null)}
                className="p-1 text-slate-400 hover:text-slate-600 rounded-lg"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            <h3 className="text-base font-bold text-slate-900 dark:text-white">
              {selectedDetailsItem.title}
            </h3>
            <p className="text-xs text-slate-600 dark:text-slate-300 leading-relaxed">
              {selectedDetailsItem.description || "Standardized diagnostic code recognized internationally under WHO ICD-10 guidelines."}
            </p>
            <div className="pt-2 border-t border-slate-200 dark:border-slate-800 flex justify-end">
              <button
                type="button"
                onClick={() => setSelectedDetailsItem(null)}
                className="px-4 py-2 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 text-xs font-bold rounded-xl cursor-pointer"
              >
                {translations.cancel || "Close"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* 5. Step 1 Footer Action Bar */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 md:p-5 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        {/* Left: Autosave Status */}
        <div className="flex items-center gap-2.5 text-xs text-slate-500 dark:text-slate-400">
          <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
          <span>
            {saveBanner ||
              (record.lastSavedAtUtc
                ? (translations.draft_autosaved || "Draft autosaved • Last saved {time}").replace("{time}", new Date(record.lastSavedAtUtc).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }))
                : (translations.draft_autosave_active || "Draft autosave active"))}
          </span>
          <button
            type="button"
            onClick={handleManualSave}
            disabled={isSaving}
            className="ms-2 px-2.5 py-1 text-[11px] font-bold text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg transition inline-flex items-center gap-1 cursor-pointer"
          >
            <Save className="w-3 h-3" />
            <span>{isSaving ? (translations.medrec_autosave_saving || "Saving...") : (translations.save_now || "Save Now")}</span>
          </button>
        </div>

        {/* Right: Actions */}
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
            <span>{translations.btn_next || "Next: Medications"}</span>
            <ArrowRight className="w-4 h-4 rtl:rotate-180" />
          </button>
        </div>
      </div>

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

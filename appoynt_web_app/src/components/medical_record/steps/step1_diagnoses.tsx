/*
 * File Name: step1_diagnoses.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/services/medical_record_service
 *   - @/lib/validators/medical_record_validator
 *   - @/components/medical_record/editor/clinical_notes_editor
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Step 1 Clinical Consultation presentation component providing ICD-10 search, clinical outcome selector, notes editor with scaled typography and tightened EHR spacing.
 */

"use client";

import React, { useState, useEffect, useId } from "react";
import {
  Stethoscope,
  CheckCircle,
  Clock,
  ShieldCheck,
  Search,
  Plus,
  Trash2,
  ExternalLink,
  ArrowRight,
  Save,
  X,
} from "lucide-react";
import {
  Icd10CatalogItem,
  DiagnosisItem,
} from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { medicalRecordService } from "@/services/medical_record_service";
import { Step1DiagnosisSchema } from "@/lib/validators/medical_record_validator";
import ClinicalNotesEditor from "@/components/medical_record/editor/clinical_notes_editor";
import { useTranslation } from "@/context/language_context";

export default function Step1Diagnoses() {
  const primarySearchId = useId();
  const secondarySearchId = useId();
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
  const [selectedDetailsItem, setSelectedDetailsItem] =
    useState<Icd10CatalogItem | null>(null);

  const [validationErrors, setValidationErrors] = useState<
    Record<string, string>
  >({});
  const [saveBanner, setSaveBanner] = useState<string | null>(null);

  useEffect(() => {
    let active = true;
    const search = async () => {
      if (primarySearch.trim().length >= 1) {
        const res = await medicalRecordService.searchIcd10Catalog(primarySearch);
        if (active) setPrimaryResults(res);
      } else {
        if (active) setPrimaryResults([]);
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
        const res = await medicalRecordService.searchIcd10Catalog(secondarySearch);
        if (active) setSecondaryResults(res);
      } else {
        if (active) setSecondaryResults([]);
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
      name: item.name,
      category: item.category,
      description: item.description,
      isPrimary: true,
    };
    setPrimaryDiagnosis(diag);
    setPrimarySearch(item.name);
    setPrimaryResults([]);
    setValidationErrors((prev) => {
      const next = { ...prev };
      delete next.primaryDiagnosis;
      return next;
    });
  };

  const handleClearPrimary = () => {
    setPrimaryDiagnosis(null);
    setPrimarySearch("");
    setPrimaryResults([]);
  };

  const handleSelectSecondary = (item: Icd10CatalogItem) => {
    if (record.secondaryDiagnoses.length >= 10) return;
    if (record.primaryDiagnosis?.code === item.code) return;
    if (record.secondaryDiagnoses.some((d) => d.code === item.code)) return;

    const diag: DiagnosisItem = {
      code: item.code,
      name: item.name,
      category: item.category,
      description: item.description,
    };
    addSecondaryDiagnosis(diag);
    setSecondarySearch("");
    setSecondaryResults([]);
  };

  const handleManualSave = async () => {
    const res = await saveDraftNow();
    if (res) {
      setSaveBanner(translations.save_draft || "Draft saved");
      setTimeout(() => setSaveBanner(null), 3000);
    }
  };

  const handleProceed = () => {
    const result = Step1DiagnosisSchema.safeParse({
      clinicalOutcome: record.clinicalOutcome,
      primaryDiagnosis: record.primaryDiagnosis,
      secondaryDiagnoses: record.secondaryDiagnoses,
      clinicalNotes: record.clinicalNotes,
    });

    if (!result.success) {
      const errMap: Record<string, string> = {};
      result.error.issues.forEach((issue: any) => {
        const pathKey = issue.path.join(".");
        errMap[pathKey] = issue.message;
      });
      setValidationErrors(errMap);
      return;
    }

    setValidationErrors({});
    setCurrentStep(2);
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

      {/* 1. Clinical Outcome Selection */}
      <div className="p-4 md:p-5 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs space-y-3">
        <div className="text-start">
          <h2 className="text-base md:text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2">
            <Stethoscope className="w-5 h-5 text-blue-600 dark:text-blue-400 shrink-0" />
            {translations.medrec_outcome_title}
          </h2>
          <p className="text-xs md:text-sm font-medium text-slate-500 dark:text-slate-400 mt-0.5">
            {translations.diagnoses_and_notes || translations.medrec_step1_title}
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 mb-3 gap-3 md:gap-4">
          {/* Confirmed Diagnosis */}
          <button
            type="button"
            onClick={() => setClinicalOutcome("CONFIRMED_DIAGNOSIS")}
            className={`p-3.5 md:p-4 rounded-xl border-2 text-start transition-all flex items-start gap-3 cursor-pointer ${
              "CONFIRMED_DIAGNOSIS" === record.clinicalOutcome
                ? "bg-blue-50/90 dark:bg-blue-950/50 border-blue-600 dark:border-blue-500 shadow-xs"
                : "bg-white dark:bg-[#0E1726] border-slate-200 dark:border-slate-800 hover:border-slate-300 dark:hover:border-slate-700"
            }`}
          >
            <div
              className={`p-2 rounded-lg shrink-0 ${
                "CONFIRMED_DIAGNOSIS" === record.clinicalOutcome
                  ? "bg-blue-600 text-white"
                  : "bg-slate-100 dark:bg-slate-800 text-slate-500"
              }`}
            >
              <CheckCircle className="w-5 h-5" />
            </div>
            <div>
              <p className="text-base md:text-lg font-bold text-slate-800 dark:text-slate-100">
                {translations.medrec_outcome_confirmed}
              </p>
              <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1 leading-relaxed">
                {translations.medrec_outcome_confirmed_desc}
              </p>
            </div>
          </button>

          {/* No Illness Detected */}
          <button
            type="button"
            onClick={() => {
              setClinicalOutcome("NO_ILLNESS_DETECTED");
              setPrimaryDiagnosis(null);
            }}
            className={`p-3.5 md:p-4 rounded-xl border-2 text-start transition-all flex items-start gap-3 cursor-pointer ${
              "NO_ILLNESS_DETECTED" === record.clinicalOutcome
                ? "bg-emerald-50/90 dark:bg-emerald-950/50 border-emerald-600 dark:border-emerald-500 shadow-xs"
                : "bg-white dark:bg-[#0E1726] border-slate-200 dark:border-slate-800 hover:border-slate-300 dark:hover:border-slate-700"
            }`}
          >
            <div
              className={`p-2 rounded-lg shrink-0 ${
                "NO_ILLNESS_DETECTED" === record.clinicalOutcome
                  ? "bg-emerald-600 text-white"
                  : "bg-slate-100 dark:bg-slate-800 text-slate-500"
              }`}
            >
              <ShieldCheck className="w-5 h-5" />
            </div>
            <div>
              <p className="text-base md:text-lg font-bold text-slate-800 dark:text-slate-100">
                {translations.medrec_outcome_no_illness}
              </p>
              <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1 leading-relaxed">
                {translations.medrec_outcome_no_illness_desc}
              </p>
            </div>
          </button>

          {/* Diagnosis Pending */}
          <button
            type="button"
            onClick={() => setClinicalOutcome("DIAGNOSIS_PENDING")}
            className={`p-3.5 md:p-4 rounded-xl border-2 text-start transition-all flex items-start gap-3 cursor-pointer ${
              "DIAGNOSIS_PENDING" === record.clinicalOutcome
                ? "bg-amber-50/90 dark:bg-amber-950/50 border-amber-600 dark:border-amber-500 shadow-xs"
                : "bg-white dark:bg-[#0E1726] border-slate-200 dark:border-slate-800 hover:border-slate-300 dark:hover:border-slate-700"
            }`}
          >
            <div
              className={`p-2 rounded-lg shrink-0 ${
                "DIAGNOSIS_PENDING" === record.clinicalOutcome
                  ? "bg-amber-600 text-white"
                  : "bg-slate-100 dark:bg-slate-800 text-slate-500"
              }`}
            >
              <Clock className="w-5 h-5" />
            </div>
            <div>
              <p className="text-base md:text-lg font-bold text-slate-800 dark:text-slate-100">
                {translations.medrec_outcome_pending}
              </p>
              <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-1 leading-relaxed">
                {translations.medrec_outcome_pending_desc}
              </p>
            </div>
          </button>
        </div>
      </div>

      {/* 2. ICD-10 Diagnostics Section */}
      {"NO_ILLNESS_DETECTED" !== record.clinicalOutcome && (
        <div className="p-4 md:p-5 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs space-y-3">
          {/* Primary Diagnosis */}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <label
                htmlFor={primarySearchId}
                className="text-sm md:text-base font-semibold text-slate-800 dark:text-slate-100 flex items-center gap-1.5"
              >
                <span>{translations.medrec_primary_diagnosis || "Primary Diagnosis (ICD-10)"}</span>
                {"CONFIRMED_DIAGNOSIS" === record.clinicalOutcome && (
                  <span className="text-red-500 font-bold">*</span>
                )}
              </label>
              {record.primaryDiagnosis && (
                <button
                  type="button"
                  onClick={() =>
                    setSelectedDetailsItem({
                      code: record.primaryDiagnosis?.code || "",
                      name: record.primaryDiagnosis?.name || "",
                      category: record.primaryDiagnosis?.category || "General",
                      description: record.primaryDiagnosis?.description,
                    })
                  }
                  className="text-xs md:text-sm text-blue-600 dark:text-blue-400 hover:underline inline-flex items-center gap-1 font-semibold cursor-pointer"
                >
                  <ExternalLink className="w-3.5 h-3.5" />
                  {translations.view_icd10_details || "View ICD-10 Details"}
                </button>
              )}
            </div>

            {record.primaryDiagnosis ? (
              /* Selected Primary Diagnosis Pill */
              <div className="flex items-center justify-between p-3 bg-blue-50/90 dark:bg-blue-950/40 border-2 border-blue-200 dark:border-blue-800 rounded-xl">
                <div className="flex items-center gap-3">
                  <span className="px-2.5 py-1 text-xs font-mono font-bold bg-blue-600 text-white rounded-lg">
                    {record.primaryDiagnosis.code}
                  </span>
                  <div className="text-start">
                    <p className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
                      {record.primaryDiagnosis.name}
                    </p>
                    {record.primaryDiagnosis.category && (
                      <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-0.5">
                        {record.primaryDiagnosis.category}
                      </p>
                    )}
                  </div>
                </div>
                <button
                  type="button"
                  onClick={handleClearPrimary}
                  className="p-1.5 text-slate-400 hover:text-red-600 transition rounded-lg cursor-pointer"
                  title="Remove"
                >
                  <X className="w-4 h-4" />
                </button>
              </div>
            ) : (
              /* Autocomplete Search Input */
              <div className="relative">
                <div className="relative">
                  <input
                    id={primarySearchId}
                    type="text"
                    value={primarySearch}
                    onChange={(e) => setPrimarySearch(e.target.value)}
                    placeholder={translations.search_icd10_placeholder || "Search ICD-10 diagnosis catalogue by name or code..."}
                    className="w-full ps-10 pe-4 py-2.5 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-slate-700/70 rounded-xl text-sm md:text-base font-medium text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500"
                  />
                  <Search className="w-4 h-4 text-slate-400 absolute start-3 top-3" />
                </div>

                {primaryResults.length > 0 && (
                  <div className="absolute top-full start-0 end-0 mt-1 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-xl shadow-xl z-20 max-h-56 overflow-y-auto divide-y divide-slate-100 dark:divide-slate-800">
                    {primaryResults.map((item) => (
                      <button
                        key={item.code}
                        type="button"
                        onClick={() => handleSelectPrimary(item)}
                        className="w-full text-start p-3 hover:bg-blue-50 dark:hover:bg-blue-950/40 flex items-center justify-between text-xs md:text-sm transition cursor-pointer"
                      >
                        <div className="space-y-0.5">
                          <div className="flex items-center gap-2">
                            <span className="font-mono font-bold text-xs text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/50 px-2 py-0.5 rounded">
                              {item.code}
                            </span>
                            <span className="font-bold text-slate-900 dark:text-white text-sm md:text-base">
                              {item.name}
                            </span>
                          </div>
                          {item.description && (
                            <p className="text-slate-500 dark:text-slate-400 line-clamp-1 text-xs">
                              {item.description}
                            </p>
                          )}
                        </div>
                        <Plus className="w-4 h-4 text-blue-600 shrink-0" />
                      </button>
                    ))}
                  </div>
                )}
              </div>
            )}

            {validationErrors.primaryDiagnosis && (
              <p className="text-xs md:text-sm text-red-500 font-semibold mt-1">
                {translations.primary_diagnosis_required || "Primary diagnosis is required."}
              </p>
            )}
          </div>

          {/* Secondary Diagnoses */}
          <div className="space-y-2 pt-2.5 border-t border-slate-100 dark:border-slate-800/80">
            <div className="flex items-center justify-between">
              <label
                htmlFor={secondarySearchId}
                className="text-sm md:text-base font-semibold text-slate-800 dark:text-slate-100"
              >
                {translations.medrec_secondary_diagnoses || "Secondary Diagnoses & Comorbidities (Optional)"}
              </label>
              <span className="text-xs md:text-sm text-slate-400 font-semibold">
                {record.secondaryDiagnoses.length}/10
              </span>
            </div>

            {/* Selected Secondary Tags */}
            {record.secondaryDiagnoses.length > 0 && (
              <div className="flex flex-wrap gap-2 pb-0.5">
                {record.secondaryDiagnoses.map((diag) => (
                  <span
                    key={diag.code}
                    className="inline-flex items-center gap-2 px-3 py-1 bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-xl text-xs md:text-sm font-semibold text-slate-800 dark:text-slate-200 shadow-2xs"
                  >
                    <span className="font-mono font-bold text-xs text-blue-600 dark:text-blue-400">
                      {diag.code}
                    </span>
                    <span>{diag.name}</span>
                    <button
                      type="button"
                      onClick={() => removeSecondaryDiagnosis(diag.code)}
                      className="text-slate-400 hover:text-red-500 transition cursor-pointer"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                    </button>
                  </span>
                ))}
              </div>
            )}

            {/* Secondary Search Autocomplete */}
            {record.secondaryDiagnoses.length < 10 && (
              <div className="relative">
                <div className="relative">
                  <input
                    id={secondarySearchId}
                    type="text"
                    value={secondarySearch}
                    onChange={(e) => setSecondarySearch(e.target.value)}
                    placeholder={translations.search_icd10_placeholder || "Search ICD-10 diagnosis catalogue by name or code..."}
                    className="w-full ps-10 pe-4 py-2.5 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200/80 dark:border-slate-700/70 rounded-xl text-sm md:text-base font-medium text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500"
                  />
                  <Search className="w-4 h-4 text-slate-400 absolute start-3 top-3" />
                </div>

                {secondaryResults.length > 0 && (
                  <div className="absolute top-full start-0 end-0 mt-1 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-xl shadow-xl z-20 max-h-48 overflow-y-auto divide-y divide-slate-100 dark:divide-slate-800">
                    {secondaryResults.map((item) => {
                      const isSelected =
                        record.secondaryDiagnoses.some(
                          (d) => d.code === item.code
                        ) || record.primaryDiagnosis?.code === item.code;

                      return (
                        <button
                          key={item.code}
                          type="button"
                          disabled={isSelected}
                          onClick={() => handleSelectSecondary(item)}
                          className="w-full text-start p-3 hover:bg-blue-50 dark:hover:bg-blue-950/40 flex items-center justify-between text-xs md:text-sm transition disabled:opacity-40 cursor-pointer"
                        >
                          <div className="space-y-0.5">
                            <div className="flex items-center gap-2">
                              <span className="font-mono font-bold text-xs text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/50 px-2 py-0.5 rounded">
                                {item.code}
                              </span>
                              <span className="font-bold text-slate-900 dark:text-white text-sm md:text-base">
                                {item.name}
                              </span>
                            </div>
                          </div>
                          {isSelected ? (
                            <span className="text-xs font-bold text-slate-400">
                              {translations.valid_icd10_selected || "Selected"}
                            </span>
                          ) : (
                            <Plus className="w-4 h-4 text-blue-600" />
                          )}
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      )}

      {/* 3. Clinical Notes & Observations */}
      <div className="p-4 md:p-5 bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs">
        <ClinicalNotesEditor
          value={record.clinicalNotes}
          onChange={setClinicalNotes}
          error={validationErrors.clinicalNotes ? (translations.notes_too_short_error || "Clinical notes must be at least 10 characters.") : undefined}
        />
      </div>

      {/* Bottom Sticky Action Controls */}
      <div className="flex flex-wrap items-center justify-between gap-3 pt-3 mt-3 border-t border-slate-200 dark:border-slate-800">
        <button
          type="button"
          disabled={isSaving}
          onClick={handleManualSave}
          className="px-5 py-2.5 text-sm md:text-base font-semibold text-slate-700 dark:text-slate-300 bg-white dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 rounded-xl shadow-xs transition flex items-center gap-2 cursor-pointer"
        >
          <Save className="w-4 h-4 text-slate-500" />
          {isSaving ? (translations.medrec_btn_saving_draft || "Saving Draft...") : (translations.save_draft || "Save Draft")}
        </button>

        <button
          type="button"
          onClick={handleProceed}
          className="px-6 py-2.5 text-sm md:text-base font-bold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer"
        >
          {translations.medications_and_prescriptions || translations.medrec_btn_continue_meds || "Continue to Medications"}
          <ArrowRight className="w-4 h-4 rtl:rotate-180" />
        </button>
      </div>

      {/* ICD-10 Details Modal */}
      {selectedDetailsItem && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
          <div className="w-full max-w-md bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 p-5 space-y-3 text-slate-900 dark:text-slate-100 text-start">
            <div className="flex items-center justify-between">
              <span className="px-2.5 py-1 text-xs font-mono font-bold bg-blue-100 dark:bg-blue-900/50 text-blue-700 dark:text-blue-300 rounded-lg">
                {selectedDetailsItem.code}
              </span>
              <button
                type="button"
                onClick={() => setSelectedDetailsItem(null)}
                className="p-1 text-slate-400 hover:text-slate-600 rounded-lg cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            <div>
              <h3 className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
                {selectedDetailsItem.name}
              </h3>
              <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 mt-0.5">
                {selectedDetailsItem.category}
              </p>
            </div>
            <p className="text-xs md:text-sm text-slate-600 dark:text-slate-300 leading-relaxed bg-slate-50 dark:bg-[#131E35] p-3 rounded-xl border border-slate-100 dark:border-slate-800">
              {selectedDetailsItem.description ||
                translations.valid_icd10_selected ||
                "Standard ICD-10 catalog item entry."}
            </p>
            <div className="text-end pt-1">
              <button
                type="button"
                onClick={() => setSelectedDetailsItem(null)}
                className="px-5 py-2 text-sm md:text-base font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl cursor-pointer"
              >
                {translations.btn_done || "Done"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

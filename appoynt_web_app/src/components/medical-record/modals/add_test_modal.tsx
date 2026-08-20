/*
 * File Name: add_test_modal.tsx
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
 * File Description: Accessible modal dialog for ordering diagnostic laboratory and radiology tests with test catalog search, category filter, priority radio triage pills (Routine, Urgent, STAT), and instructions.
 */

"use client";

import React, { useState, useEffect } from "react";
import {
  X,
  FlaskConical,
  Search,
  CheckCircle2,
  Clock,
  Zap,
} from "lucide-react";
import {
  TestOrderItem,
  TestCatalogItem,
  TestPriority,
} from "@/types/medical_record";
import { MedicalRecordService } from "@/services/medical_record_service";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { useTranslation } from "@/context/language_context";
import CustomSelectDropdown, { DropdownOption } from "@/components/ui/custom_select_dropdown";

interface AddTestModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const CATEGORY_OPTIONS: DropdownOption[] = [
  { value: "All", label: "All Categories" },
  { value: "Laboratory", label: "Laboratory (Blood & Urine)" },
  { value: "Radiology", label: "Radiology & Imaging" },
  { value: "Cardiology", label: "Cardiology Diagnostics" },
  { value: "Pathology", label: "Pathology & Biopsy" },
];

export default function AddTestModal({
  isOpen,
  onClose,
}: AddTestModalProps) {
  const { addTestOrder } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  const categoryOptions: DropdownOption[] = [
    { value: "All", label: translations.all_categories || "All Categories" },
    { value: "Laboratory", label: translations.cat_lab || "Laboratory (Blood & Urine)" },
    { value: "Radiology", label: translations.cat_radiology || "Radiology & Imaging" },
    { value: "Cardiology", label: translations.cat_cardiology || "Cardiology Diagnostics" },
    { value: "Pathology", label: translations.cat_pathology || "Pathology & Biopsy" },
  ];

  const [selectedCategory, setSelectedCategory] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [testResults, setTestResults] = useState<TestCatalogItem[]>([]);
  const [selectedTest, setSelectedTest] = useState<TestCatalogItem | null>(null);
  const [priority, setPriority] = useState<TestPriority>("Routine");
  const [clinicalNotes, setClinicalNotes] = useState("");
  const [formError, setFormError] = useState("");

  useEffect(() => {
    let active = true;
    const fetchTests = async () => {
      const results = await MedicalRecordService.searchTestCatalog(
        searchQuery,
        selectedCategory
      );
      if (active) setTestResults(results);
    };
    fetchTests();
    return () => {
      active = false;
    };
  }, [searchQuery, selectedCategory]);

  useEffect(() => {
    if (isOpen) {
      setSelectedCategory("All");
      setSearchQuery("");
      setSelectedTest(null);
      setPriority("Routine");
      setClinicalNotes("");
      setFormError("");
    }
  }, [isOpen]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedTest) {
      setFormError(translations.no_tests_ordered || "Please select a diagnostic test from the catalog");
      return;
    }

    const newTest: TestOrderItem = {
      id: `test-${Date.now()}`,
      testCatalogId: selectedTest.id,
      testName: selectedTest.name,
      type: selectedTest.category,
      priority: priority,
      orderedAtUtc: new Date().toISOString(),
      status: "Ordered",
      clinicalNotes: clinicalNotes.trim() || undefined,
      requiresFast: selectedTest.fastingRequired || false,
    };

    addTestOrder(newTest);
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
        <div className="flex items-center justify-between px-6 py-4 border-b-2 border-slate-200 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35] shrink-0">
          <div className="flex items-center gap-3">
            <div className="p-2.5 bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-xl">
              <FlaskConical className="w-5 h-5" />
            </div>
            <div className="text-start">
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                {translations.add_new_test || "Order Diagnostic Test"}
              </h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {translations.diagnostic_tests || "Laboratory, Radiology & Special Diagnostics"}
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

        {/* Form Body */}
        <form id="add-test-form" onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-6 space-y-5 text-start pb-28">
          {formError && (
            <div className="p-3 bg-rose-50 dark:bg-rose-950/40 border-2 border-rose-300 dark:border-rose-800 rounded-xl text-xs font-semibold text-rose-700 dark:text-rose-300">
              {formError}
            </div>
          )}

          {/* 1. Category Filter */}
          <CustomSelectDropdown
            label={translations.filter_record_type || "Test Category"}
            options={categoryOptions}
            value={selectedCategory}
            onChange={(val) => setSelectedCategory(val)}
            searchable={false}
          />

          {/* 2. Test Search & Selection */}
          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
              {translations.search_tests || "Search Diagnostic Catalog"} <span className="text-rose-500">*</span>
            </label>
            <div className="relative">
              <Search className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder={translations.search_tests || "Search by test name, code, or department..."}
                className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl ps-10 pe-4 py-2.5 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
              />
            </div>

            {/* Test Results list */}
            <div className="max-h-48 overflow-y-auto border-2 border-slate-200 dark:border-slate-800 rounded-xl p-1.5 space-y-1 bg-slate-50/50 dark:bg-[#0B132B]/50">
              {testResults.length > 0 ? (
                testResults.map((test) => {
                  const isSelected = selectedTest?.id === test.id;
                  return (
                    <div
                      key={test.id}
                      onClick={() => {
                        setSelectedTest(test);
                        setFormError("");
                      }}
                      className={`p-3 rounded-xl border-2 transition cursor-pointer flex items-center justify-between ${
                        isSelected
                          ? "border-blue-600 bg-blue-50/80 dark:bg-blue-950/60 dark:border-blue-500"
                          : "border-slate-200/80 dark:border-slate-800 bg-white dark:bg-[#0E1726] hover:border-slate-300 dark:hover:border-slate-700"
                      }`}
                    >
                      <div className="space-y-0.5 min-w-0 pe-2">
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-xs md:text-sm text-slate-900 dark:text-white truncate">
                            {test.name}
                          </span>
                          <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300">
                            {test.category}
                          </span>
                        </div>
                        <p className="text-[11px] text-slate-500 dark:text-slate-400">
                          {test.code} • {(translations.turnaround_time || "Turnaround: {time}").replace("{time}", test.typicalTurnaround || "")} {test.fastingRequired ? "• Fasting Required" : ""}
                        </p>
                      </div>
                      {isSelected && (
                        <CheckCircle2 className="w-5 h-5 text-blue-600 dark:text-blue-400 shrink-0" />
                      )}
                    </div>
                  );
                })
              ) : (
                <div className="p-4 text-center text-xs text-slate-400 dark:text-slate-500">
                  {translations.no_tests_found || "No matching diagnostic tests found in catalog"}
                </div>
              )}
            </div>
          </div>

          {/* 3. Priority Radio Pills (Routine, Urgent, STAT) */}
          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
              {translations.priority || "Order Clinical Priority"} <span className="text-rose-500">*</span>
            </label>
            <div className="grid grid-cols-3 gap-3">
              {(
                [
                  {
                    value: "Routine",
                    label: translations.priority_routine || "Routine",
                    desc: translations.priority_standard_queue || "Standard queue",
                    icon: Clock,
                    color: "border-slate-300 text-slate-700 dark:text-slate-200",
                    activeBg: "border-blue-600 bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300",
                  },
                  {
                    value: "Urgent",
                    label: translations.priority_urgent || "Urgent",
                    desc: translations.priority_within_4h || "Within 4 hours",
                    icon: Zap,
                    color: "border-amber-300 text-amber-700 dark:text-amber-200",
                    activeBg: "border-amber-500 bg-amber-50 dark:bg-amber-950/60 text-amber-800 dark:text-amber-300",
                  },
                  {
                    value: "STAT",
                    label: translations.priority_stat || "STAT",
                    desc: translations.priority_immediate || "Immediate",
                    icon: Zap,
                    color: "border-rose-300 text-rose-700 dark:text-rose-200",
                    activeBg: "border-rose-600 bg-rose-50 dark:bg-rose-950/60 text-rose-800 dark:text-rose-300",
                  },
                ] as const
              ).map((p) => {
                const isSelected = priority === p.value;
                const Icon = p.icon;
                return (
                  <button
                    key={p.value}
                    type="button"
                    onClick={() => setPriority(p.value)}
                    className={`p-3 rounded-xl border-2 flex flex-col items-center justify-center text-center transition cursor-pointer ${
                      isSelected
                        ? p.activeBg
                        : "border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-[#131E35] hover:border-slate-300"
                    }`}
                  >
                    <div className="flex items-center gap-1.5 font-bold text-xs">
                      <div
                        className={`w-3.5 h-3.5 rounded-full border-2 flex items-center justify-center ${
                          isSelected
                            ? "border-current"
                            : "border-slate-400 dark:border-slate-600"
                        }`}
                      >
                        {isSelected && <div className="w-1.5 h-1.5 rounded-full bg-current" />}
                      </div>
                      <Icon className="w-3.5 h-3.5" />
                      <span>{p.label}</span>
                    </div>
                    <span className="text-[10px] text-slate-500 dark:text-slate-400 mt-0.5">
                      {p.desc}
                    </span>
                  </button>
                );
              })}
            </div>
          </div>

          {/* 4. Instructions / Clinical Rationale */}
          <div>
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300 mb-1.5">
              {translations.instructions || "Clinical Rationale & Special Instructions"}
            </label>
            <textarea
              rows={3}
              value={clinicalNotes}
              onChange={(e) => setClinicalNotes(e.target.value)}
              placeholder={translations.test_instructions_placeholder || "e.g. Evaluate elevated transaminases, patient fasting for 12 hours..."}
              className="w-full bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl p-3 text-xs md:text-sm font-medium text-slate-800 dark:text-slate-100 focus:outline-none focus:border-blue-500"
            />
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
            form="add-test-form"
            className="px-6 py-2.5 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl shadow-md transition cursor-pointer"
          >
            {translations.order_test || "Order Test"}
          </button>
        </div>
      </div>
    </div>
  );
}

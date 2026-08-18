/*
 * File Name: add_new_test_modal.tsx
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
 * File Description: Accessible modal dialog for ordering diagnostic laboratory and radiology tests with catalog search, priority triage cards, modern input styling, and semantic light/dark theme contrast.
 */

"use client";

import React, { useState, useEffect, useId } from "react";
import {
  X,
  FlaskConical,
  Search,
  CheckCircle2,
  AlertCircle,
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

interface AddNewTestModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const CATEGORIES = [
  "All",
  "Laboratory",
  "Radiology",
  "Cardiology",
  "Pathology",
];

export default function AddNewTestModal({
  isOpen,
  onClose,
}: AddNewTestModalProps) {
  const { addTestOrder } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  const [selectedCategory, setSelectedCategory] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [testResults, setTestResults] = useState<TestCatalogItem[]>([]);
  const [selectedTest, setSelectedTest] = useState<TestCatalogItem | null>(null);
  const [priority, setPriority] = useState<TestPriority>("Routine");
  const [clinicalNotes, setClinicalNotes] = useState("");
  const [formError, setFormError] = useState("");

  const searchInputId = useId();

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

    const testItem: TestOrderItem = {
      id: `test-order-${Date.now()}`,
      testCatalogId: selectedTest.id,
      testName: selectedTest.name,
      type: selectedTest.commonType,
      priority: priority,
      status: "Ordered",
      orderedOn: new Date().toISOString().split("T")[0],
      clinicalNotes: clinicalNotes.trim() || undefined,
    };

    addTestOrder(testItem);
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
            <div className="p-2.5 bg-indigo-100 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 rounded-xl">
              <FlaskConical className="w-5 h-5" />
            </div>
            <div className="text-start">
              <h2 className="text-lg font-bold text-slate-900 dark:text-white">
                {translations.add_test || "Order Diagnostic Test"}
              </h2>
              <p className="text-xs text-slate-500 dark:text-slate-400">
                {translations.tests_and_attachments || "Tests & Attachments"}
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
        <form onSubmit={handleSubmit} className="flex-1 overflow-y-auto p-6 space-y-5 text-start">
          {/* Category Tabs */}
          <div className="flex flex-wrap gap-1.5 p-1 bg-slate-100 dark:bg-[#131E35] rounded-xl border border-slate-200 dark:border-slate-700/60">
            {CATEGORIES.map((cat) => (
              <button
                key={cat}
                type="button"
                onClick={() => setSelectedCategory(cat)}
                className={`px-3.5 py-1.5 text-xs font-semibold rounded-lg transition cursor-pointer ${
                  selectedCategory === cat
                    ? "bg-white dark:bg-[#0E1726] text-blue-600 dark:text-blue-400 shadow-xs"
                    : "text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-200"
                }`}
              >
                {cat}
              </button>
            ))}
          </div>

          {/* Test Search Input */}
          <div className="space-y-1.5">
            <label
              htmlFor={searchInputId}
              className="block text-xs font-semibold text-slate-700 dark:text-slate-300"
            >
              {translations.test_name || "Test Catalog Name"} <span className="text-red-500 ms-0.5">*</span>
            </label>
            <div className="relative">
              <input
                id={searchInputId}
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="e.g. Complete Blood Count, Lipid Panel, Chest X-Ray..."
                className="w-full ps-9 pe-4 h-11 bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600 focus:ring-blue-500/20 focus:border-blue-500 rounded-xl text-sm font-medium text-slate-800 dark:text-slate-100 placeholder:text-slate-400 focus:outline-none focus:ring-2 transition-all"
              />
              <Search className="w-4 h-4 text-slate-400 absolute start-3 top-1/2 -translate-y-1/2" />
            </div>
          </div>

          {/* Catalogue List */}
          <div className="space-y-1.5">
            <span className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
              {translations.test_type || "Available Diagnostic Orders"} <span className="text-red-500 ms-0.5">*</span>
            </span>
            <div className="max-h-44 overflow-y-auto space-y-1.5 border-2 border-slate-200 dark:border-slate-800 rounded-xl p-2 bg-slate-50/50 dark:bg-[#131E35]/40">
              {testResults.length === 0 ? (
                <div className="p-4 text-center text-xs text-slate-500 dark:text-slate-400">
                  {translations.no_tests_ordered || "No diagnostic tests match query"}
                </div>
              ) : (
                testResults.map((item) => {
                  const isSelected = selectedTest?.id === item.id;
                  return (
                    <button
                      key={item.id}
                      type="button"
                      onClick={() => {
                        setSelectedTest(item);
                        setFormError("");
                      }}
                      className={`w-full text-start px-3.5 py-2.5 rounded-xl text-xs transition flex items-center justify-between border cursor-pointer ${
                        isSelected
                          ? "bg-blue-50 dark:bg-blue-950/50 border-blue-400 dark:border-blue-700 text-blue-900 dark:text-blue-200 shadow-2xs"
                          : "bg-white dark:bg-[#0E1726] border-slate-200 dark:border-slate-800 hover:border-slate-300 dark:hover:border-slate-700 text-slate-800 dark:text-slate-200"
                      }`}
                    >
                      <div>
                        <p className="font-semibold">{item.name}</p>
                        <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5">
                          {item.category} • {item.commonType}
                        </p>
                      </div>
                      {isSelected && (
                        <CheckCircle2 className="w-4 h-4 text-blue-600 dark:text-blue-400 shrink-0" />
                      )}
                    </button>
                  );
                })
              )}
            </div>
            {formError && (
              <p className="text-xs text-red-500 flex items-center gap-1">
                <AlertCircle className="w-3.5 h-3.5" />
                {formError}
              </p>
            )}
          </div>

          {/* Priority Triage Radio Cards */}
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
              {translations.priority || "Triage Priority"} <span className="text-red-500 ms-0.5">*</span>
            </label>
            <div className="grid grid-cols-3 gap-2.5">
              {/* Routine */}
              <button
                type="button"
                onClick={() => setPriority("Routine")}
                className={`p-3 rounded-xl border-2 text-center transition flex flex-col items-center gap-1 cursor-pointer ${
                  "Routine" === priority
                    ? "bg-blue-50 dark:bg-blue-950/40 border-blue-500 dark:border-blue-600 text-blue-900 dark:text-blue-200 ring-2 ring-blue-500/20"
                    : "bg-white dark:bg-[#0E1726] border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800"
                }`}
              >
                <Clock className="w-4 h-4 text-blue-500" />
                <span className="text-xs font-bold">{translations.priority_routine || "Routine"}</span>
              </button>

              {/* Urgent */}
              <button
                type="button"
                onClick={() => setPriority("Urgent")}
                className={`p-3 rounded-xl border-2 text-center transition flex flex-col items-center gap-1 cursor-pointer ${
                  "Urgent" === priority
                    ? "bg-amber-50 dark:bg-amber-950/40 border-amber-500 dark:border-amber-600 text-amber-900 dark:text-amber-200 ring-2 ring-amber-500/20"
                    : "bg-white dark:bg-[#0E1726] border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800"
                }`}
              >
                <AlertCircle className="w-4 h-4 text-amber-500" />
                <span className="text-xs font-bold">{translations.priority_urgent || "Urgent"}</span>
              </button>

              {/* STAT */}
              <button
                type="button"
                onClick={() => setPriority("STAT")}
                className={`p-3 rounded-xl border-2 text-center transition flex flex-col items-center gap-1 cursor-pointer ${
                  "STAT" === priority
                    ? "bg-red-50 dark:bg-red-950/40 border-red-500 dark:border-red-600 text-red-900 dark:text-red-200 ring-2 ring-red-500/20"
                    : "bg-white dark:bg-[#0E1726] border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800"
                }`}
              >
                <Zap className="w-4 h-4 text-red-500" />
                <span className="text-xs font-bold">{translations.priority_stat || "STAT / Emergency"}</span>
              </button>
            </div>
          </div>

          {/* Clinical Instructions / Notes */}
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
              <span className="flex items-center justify-between">
                <span>{translations.clinical_notes || "Clinical Instructions"}</span>
                <span className="text-[11px] text-slate-400">Optional</span>
              </span>
            </label>
            <textarea
              rows={2}
              maxLength={1000}
              value={clinicalNotes}
              onChange={(e) => setClinicalNotes(e.target.value)}
              placeholder="e.g. Fasting sample required, evaluate electrolyte imbalance prior to titration..."
              className="w-full p-3 bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600 rounded-xl text-sm font-medium text-slate-800 dark:text-slate-100 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            />
          </div>

          {/* Footer */}
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
              <FlaskConical className="w-4 h-4" />
              {translations.add_test || "Add Test Order"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

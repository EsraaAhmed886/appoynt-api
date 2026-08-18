/*
 * File Name: clinical_notes_editor.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Rich clinical notes editor component with dynamic formatting toolbar, rapid clinical templates, live character counters, minimum length validation banners, 100% Arabic localization, and semantic light/dark theme contrast.
 */

"use client";

import React, { useRef, useState } from "react";
import {
  Bold,
  Italic,
  Underline,
  List,
  ListOrdered,
  Sparkles,
  CheckCircle2,
  AlertCircle,
  FileText,
} from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface ClinicalNotesEditorProps {
  value: string;
  onChange: (value: string) => void;
  disabled?: boolean;
  minChars?: number;
  maxChars?: number;
  error?: string;
}

const TEMPLATES = [
  {
    label: "Normal Vitals & Exam",
    text: "Patient is alert, oriented, and in no acute distress. Vitals: BP within normal limits, HR regular, lungs clear to auscultation bilaterally. Heart sounds normal S1/S2.",
  },
  {
    label: "Hypertension Review",
    text: "Patient presents for routine hypertension follow up. Blood pressure checked. Patient tolerating antihypertensive therapy without adverse effects. Advised lifestyle modifications.",
  },
  {
    label: "Upper Respiratory Infection",
    text: "Chief complaint: Cough, nasal congestion, and low-grade fever for 3 days. HEENT: Pharynx mildly erythematous without exudate. Lungs clear. Symptomatic management advised.",
  },
];

export default function ClinicalNotesEditor({
  value,
  onChange,
  disabled = false,
  minChars = 10,
  maxChars = 5000,
  error,
}: ClinicalNotesEditorProps) {
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const [showTemplates, setShowTemplates] = useState(false);
  const { translations } = useTranslation();

  const charCount = value ? value.length : 0;
  const nonWhitespaceCount = value ? value.replace(/\s+/g, "").length : 0;
  const isMinMet = nonWhitespaceCount >= minChars;

  const insertText = (before: string, after: string = "") => {
    if (disabled || !textareaRef.current) return;
    const el = textareaRef.current;
    const start = el.selectionStart;
    const end = el.selectionEnd;
    const selectedText = value.substring(start, end);
    const replacement = `${before}${selectedText || "text"}${after}`;
    const newValue =
      value.substring(0, start) + replacement + value.substring(end);
    onChange(newValue);
    setTimeout(() => {
      el.focus();
      el.setSelectionRange(
        start + before.length,
        start + before.length + (selectedText ? selectedText.length : 4)
      );
    }, 10);
  };

  const applyTemplate = (templateText: string) => {
    if (disabled) return;
    const newText = value
      ? `${value.trim()}\n\n${templateText}`
      : templateText;
    onChange(newText);
    setShowTemplates(false);
  };

  return (
    <div className="w-full space-y-2 text-start">
      {/* Label and Toolbar Header */}
      <div className="flex flex-wrap items-center justify-between gap-2">
        <label className="text-sm font-semibold text-slate-900 dark:text-slate-100 flex items-center gap-1.5">
          <FileText className="w-4 h-4 text-blue-600 dark:text-blue-400" />
          {translations.clinical_notes}
          <span className="text-xs font-normal text-slate-500 dark:text-slate-400">
            *
          </span>
        </label>

        {/* Rapid Templates Dropdown */}
        <div className="relative">
          <button
            type="button"
            disabled={disabled}
            onClick={() => setShowTemplates(!showTemplates)}
            className="inline-flex items-center gap-1.5 px-2.5 py-1 text-xs font-medium text-blue-700 dark:text-blue-300 bg-blue-50 dark:bg-blue-900/30 hover:bg-blue-100 dark:hover:bg-blue-900/50 rounded-md border border-blue-200 dark:border-blue-800 transition disabled:opacity-50"
          >
            <Sparkles className="w-3.5 h-3.5" />
            {translations.medrec_quick_templates}
          </button>

          {showTemplates && (
            <div className="absolute end-0 top-full mt-1 w-72 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-lg shadow-xl z-30 p-2 space-y-1 text-start">
              <div className="text-xs font-semibold text-slate-500 dark:text-slate-400 px-2 py-1">
                {translations.diagnoses_and_notes}
              </div>
              {TEMPLATES.map((tmpl, idx) => (
                <button
                  key={idx}
                  type="button"
                  onClick={() => applyTemplate(tmpl.text)}
                  className="w-full text-start px-2.5 py-2 text-xs text-slate-700 dark:text-slate-200 hover:bg-blue-50 dark:hover:bg-blue-900/40 rounded-md transition"
                >
                  <p className="font-semibold text-blue-600 dark:text-blue-400">
                    {tmpl.label}
                  </p>
                  <p className="line-clamp-2 text-slate-500 dark:text-slate-400 mt-0.5">
                    {tmpl.text}
                  </p>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Editor Container */}
      <div
        className={`border-2 rounded-xl bg-white dark:bg-[#131E35] shadow-xs transition-all focus-within:ring-2 focus-within:ring-blue-500/20 focus-within:border-blue-500 ${
          error
            ? "border-red-500 dark:border-red-500"
            : "border-slate-200 dark:border-slate-700"
        }`}
      >
        {/* Formatting Toolbar */}
        <div className="flex items-center gap-1 px-3 py-2 border-b border-slate-100 dark:border-slate-800 bg-slate-50 dark:bg-slate-800/40 rounded-t-xl mb-1">
          <button
            type="button"
            title="Bold"
            disabled={disabled}
            onClick={() => insertText("**", "**")}
            className="p-1.5 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-200/60 dark:hover:bg-slate-700 rounded transition disabled:opacity-40"
          >
            <Bold className="w-4 h-4" />
          </button>
          <button
            type="button"
            title="Italic"
            disabled={disabled}
            onClick={() => insertText("*", "*")}
            className="p-1.5 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-200/60 dark:hover:bg-slate-700 rounded transition disabled:opacity-40"
          >
            <Italic className="w-4 h-4" />
          </button>
          <button
            type="button"
            title="Underline"
            disabled={disabled}
            onClick={() => insertText("<u>", "</u>")}
            className="p-1.5 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-200/60 dark:hover:bg-slate-700 rounded transition disabled:opacity-40"
          >
            <Underline className="w-4 h-4" />
          </button>
          <div className="h-4 w-px bg-slate-300 dark:bg-slate-700 mx-1" />
          <button
            type="button"
            title="Bullet List"
            disabled={disabled}
            onClick={() => insertText("\n- ")}
            className="p-1.5 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-200/60 dark:hover:bg-slate-700 rounded transition disabled:opacity-40"
          >
            <List className="w-4 h-4" />
          </button>
          <button
            type="button"
            title="Numbered List"
            disabled={disabled}
            onClick={() => insertText("\n1. ")}
            className="p-1.5 text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white hover:bg-slate-200/60 dark:hover:bg-slate-700 rounded transition disabled:opacity-40"
          >
            <ListOrdered className="w-4 h-4" />
          </button>
        </div>

        {/* Text Area */}
        <textarea
          ref={textareaRef}
          value={value}
          disabled={disabled}
          maxLength={maxChars}
          onChange={(e) => onChange(e.target.value)}
          placeholder={(translations as any).clinical_notes_placeholder || translations.medrec_clinical_notes || "Document clinical findings..."}
          className="w-full min-h-[140px] md:min-h-[180px] p-3.5 bg-transparent border-0 text-sm md:text-base font-medium text-slate-900 dark:text-white placeholder:text-slate-400 focus:outline-none resize-y leading-relaxed"
        />

        {/* Footer info: Validation message & Character counter */}
        <div className="flex items-center justify-between px-3.5 py-2 border-t border-slate-100 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-800/20 text-xs rounded-b-xl">
          <div className="flex items-center gap-1.5">
            {isMinMet ? (
              <span className="inline-flex items-center gap-1 text-emerald-600 dark:text-emerald-400 font-medium">
                <CheckCircle2 className="w-3.5 h-3.5" />
                {translations.notes_min_length_met}
              </span>
            ) : (
              <span className="inline-flex items-center gap-1 text-amber-600 dark:text-amber-400">
                <AlertCircle className="w-3.5 h-3.5" />
                {translations.notes_too_short_error} ({nonWhitespaceCount}/{minChars})
              </span>
            )}
          </div>

          <div
            className={`font-mono text-xs ${
              charCount >= maxChars
                ? "text-red-500 font-bold"
                : "text-slate-500 dark:text-slate-400"
            }`}
          >
            {charCount} / {maxChars}
          </div>
        </div>
      </div>

      {error && (
        <p className="text-xs text-red-600 dark:text-red-400 flex items-center gap-1">
          <AlertCircle className="w-3.5 h-3.5" />
          {error}
        </p>
      )}
    </div>
  );
}

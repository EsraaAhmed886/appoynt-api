/*
 * File Name: clinical_notes_editor.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Clinical notes rich text area editor with comprehensive formatting toolbar (Undo, Redo, Bold, Italic, Underline, Lists, Alignments, Link, Attachment), templates, character counter (max 5000), and live 10-character validation strip.
 */

"use client";

import React, { useRef, useState } from "react";
import {
  Bold,
  Italic,
  Underline,
  List,
  ListOrdered,
  AlignLeft,
  AlignCenter,
  AlignRight,
  Link as LinkIcon,
  Paperclip,
  RotateCcw,
  RotateCw,
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

const CLINICAL_TEMPLATES = [
  {
    label: "Normal Vitals & Physical Exam",
    text: "Physical Exam:\n- General: Well-developed, well-nourished, alert and oriented x3, in no acute distress.\n- HEENT: Normocephalic, atraumatic. Pupils equal, round, and reactive to light.\n- Cardiovascular: Regular rate and rhythm. Normal S1/S2. No murmurs, gallops, or rubs.\n- Pulmonary: Clear to auscultation bilaterally. No wheezes, rales, or rhonchi.\n- Abdomen: Soft, non-tender, non-distended. Normal bowel sounds present.",
  },
  {
    label: "Hypertension Routine Follow-up",
    text: "Subjective: Patient presents for routine monitoring of essential hypertension. Denies headache, chest pain, dizziness, or visual changes.\nAssessment: Essential primary hypertension, stable on current regimen.\nPlan: Continue current dosage. Recheck BP in 3 months with routine BMP.",
  },
  {
    label: "Upper Respiratory Infection (URI)",
    text: "Chief Complaint: 3-day history of rhinorrhea, mild non-productive cough, and low-grade fever.\nExam: Oropharynx mildly erythematous without tonsillar exudate. Tympanic membranes clear.\nPlan: Supportive care, rest, adequate hydration, saline nasal spray, and OTC antipyretics PRN.",
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
  const [history, setHistory] = useState<string[]>([value]);
  const [historyIndex, setHistoryIndex] = useState(0);
  const [showTemplates, setShowTemplates] = useState(false);
  const { translations } = useTranslation();

  const charCount = value ? value.length : 0;
  const nonWhitespaceCount = value ? value.replace(/\s+/g, "").length : 0;
  const isMinMet = nonWhitespaceCount >= minChars;

  const updateValueWithHistory = (newValue: string) => {
    const truncatedHistory = history.slice(0, historyIndex + 1);
    setHistory([...truncatedHistory, newValue]);
    setHistoryIndex(truncatedHistory.length);
    onChange(newValue);
  };

  const handleUndo = () => {
    if (historyIndex > 0) {
      const prev = history[historyIndex - 1];
      setHistoryIndex(historyIndex - 1);
      onChange(prev);
    }
  };

  const handleRedo = () => {
    if (historyIndex < history.length - 1) {
      const next = history[historyIndex + 1];
      setHistoryIndex(historyIndex + 1);
      onChange(next);
    }
  };

  const insertFormatting = (before: string, after: string = "") => {
    if (disabled || !textareaRef.current) return;
    const el = textareaRef.current;
    const start = el.selectionStart;
    const end = el.selectionEnd;
    const selectedText = value.substring(start, end);
    const replacement = `${before}${selectedText || "text"}${after}`;
    const newValue = value.substring(0, start) + replacement + value.substring(end);
    updateValueWithHistory(newValue);

    setTimeout(() => {
      el.focus({ preventScroll: true });
      el.setSelectionRange(
        start + before.length,
        start + before.length + (selectedText ? selectedText.length : 4)
      );
    }, 10);
  };

  const handleInsertLink = () => {
    const url = prompt("Enter URL link:", "https://");
    if (url) {
      insertFormatting(`[`, `](${url})`);
    }
  };

  const applyTemplate = (templateText: string) => {
    if (disabled) return;
    const newText = value ? `${value.trim()}\n\n${templateText}` : templateText;
    updateValueWithHistory(newText);
    setShowTemplates(false);
  };

  return (
    <div className="w-full space-y-2 text-start">
      <div className="flex items-center justify-between">
        <label className="block text-xs font-semibold text-slate-700 dark:text-slate-300">
          {translations.clinical_notes || "Clinical Notes & Consultation Findings"} <span className="text-rose-500">*</span>
        </label>
        <div className="relative">
          <button
            type="button"
            disabled={disabled}
            onClick={() => setShowTemplates(!showTemplates)}
            className="text-[11px] font-bold text-blue-600 dark:text-blue-400 hover:text-blue-700 flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-blue-50 dark:bg-blue-950/60 hover:bg-blue-100 dark:hover:bg-blue-900/60 transition cursor-pointer"
          >
            <Sparkles className="w-3.5 h-3.5" />
            <span>{translations.insert_template || "Insert Clinical Template"}</span>
          </button>

          {showTemplates && (
            <div className="absolute end-0 top-full mt-1.5 w-72 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-700 rounded-xl shadow-xl p-2 z-30 space-y-1">
              <div className="text-[10px] font-bold text-slate-400 dark:text-slate-500 uppercase px-2 py-1">
                Select Template
              </div>
              {CLINICAL_TEMPLATES.map((tmpl, idx) => (
                <button
                  key={idx}
                  type="button"
                  onClick={() => applyTemplate(tmpl.text)}
                  className="w-full text-start p-2 rounded-lg text-xs font-medium text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-[#131E35] transition cursor-pointer"
                >
                  <p className="font-bold">{tmpl.label}</p>
                  <p className="text-[11px] text-slate-500 truncate">{tmpl.text.replace(/\n/g, " ")}</p>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Editor Surface */}
      <div
        className={`w-full rounded-2xl border-2 transition overflow-hidden bg-white dark:bg-[#0E1726] shadow-xs ${
          error
            ? "border-rose-500 dark:border-rose-500"
            : isMinMet
            ? "border-slate-200 dark:border-slate-800 focus-within:border-blue-500 dark:focus-within:border-blue-500"
            : "border-slate-200 dark:border-slate-800 focus-within:border-blue-500"
        }`}
      >
        {/* Formatting Toolbar */}
        <div className="flex flex-wrap items-center justify-between gap-1 p-2 bg-slate-50/80 dark:bg-[#131E35] border-b border-slate-200 dark:border-slate-800 text-slate-700 dark:text-slate-300">
          <div className="flex flex-wrap items-center gap-0.5">
            {/* Undo / Redo */}
            <button
              type="button"
              disabled={disabled || historyIndex <= 0}
              onClick={handleUndo}
              title="Undo"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 disabled:opacity-30 transition cursor-pointer"
            >
              <RotateCcw className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={disabled || historyIndex >= history.length - 1}
              onClick={handleRedo}
              title="Redo"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 disabled:opacity-30 transition cursor-pointer"
            >
              <RotateCw className="w-3.5 h-3.5" />
            </button>

            <span className="h-4 w-px bg-slate-300 dark:bg-slate-700 mx-1" />

            {/* Inline Formatting */}
            <button
              type="button"
              disabled={disabled}
              onClick={() => insertFormatting("**", "**")}
              title="Bold (**text**)"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <Bold className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={disabled}
              onClick={() => insertFormatting("*", "*")}
              title="Italic (*text*)"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <Italic className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={disabled}
              onClick={() => insertFormatting("<u>", "</u>")}
              title="Underline"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <Underline className="w-3.5 h-3.5" />
            </button>

            <span className="h-4 w-px bg-slate-300 dark:bg-slate-700 mx-1" />

            {/* Lists */}
            <button
              type="button"
              disabled={disabled}
              onClick={() => insertFormatting("\n- ", "")}
              title="Bulleted List"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <List className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={disabled}
              onClick={() => insertFormatting("\n1. ", "")}
              title="Numbered List"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <ListOrdered className="w-3.5 h-3.5" />
            </button>

            <span className="h-4 w-px bg-slate-300 dark:bg-slate-700 mx-1" />

            {/* Alignments */}
            <button
              type="button"
              disabled={disabled}
              onClick={() => {}}
              title="Align Left"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <AlignLeft className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={disabled}
              onClick={() => {}}
              title="Align Center"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <AlignCenter className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={disabled}
              onClick={() => {}}
              title="Align Right"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <AlignRight className="w-3.5 h-3.5" />
            </button>

            <span className="h-4 w-px bg-slate-300 dark:bg-slate-700 mx-1" />

            {/* Link & Attachment */}
            <button
              type="button"
              disabled={disabled}
              onClick={handleInsertLink}
              title="Insert Link"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <LinkIcon className="w-3.5 h-3.5" />
            </button>
            <button
              type="button"
              disabled={disabled}
              onClick={() => alert("Attachments can also be added in Step 3 (Tests & Attachments).")}
              title="Attach File"
              className="p-1.5 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <Paperclip className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>

        {/* Textarea Area */}
        <textarea
          ref={textareaRef}
          disabled={disabled}
          value={value}
          onChange={(e) => updateValueWithHistory(e.target.value)}
          maxLength={maxChars}
          rows={7}
          placeholder={translations.clinical_notes_placeholder || "Record history of present illness, physical examination observations, clinical impression, and management strategy..."}
          className="w-full p-4 bg-transparent text-xs md:text-sm font-normal text-slate-800 dark:text-slate-100 placeholder-slate-400 focus:outline-none resize-y leading-relaxed font-sans"
        />

        {/* Bottom Strip */}
        <div className="flex items-center justify-between px-4 py-2.5 bg-slate-50/80 dark:bg-[#131E35]/60 border-t border-slate-200 dark:border-slate-800 text-xs">
          <div>
            {isMinMet ? (
              <span className="inline-flex items-center gap-1.5 text-emerald-600 dark:text-emerald-400 font-bold">
                <CheckCircle2 className="w-3.5 h-3.5" />
                <span>{translations.notes_min_met || "✓ Minimum length requirement met (10 characters)"}</span>
              </span>
            ) : (
              <span className="inline-flex items-center gap-1.5 text-rose-600 dark:text-rose-400 font-semibold">
                <AlertCircle className="w-3.5 h-3.5" />
                <span>{translations.notes_min_error || translations.min_notes_error || "Please enter detailed notes (at least 10 characters)"}</span>
              </span>
            )}
          </div>

          <span className="text-[11px] font-mono text-slate-500 dark:text-slate-400">
            {(translations.chars_count || "Characters: {current} / {max}").replace("{current}", String(charCount)).replace("{max}", String(maxChars))}
          </span>
        </div>
      </div>

      {error && <p className="text-xs text-rose-500 font-medium">{error}</p>}
    </div>
  );
}

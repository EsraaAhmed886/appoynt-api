/*
 * File Name: step3_tests.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/components/medical-record/modals/add_test_modal
 *   - @/components/medical-record/modals/confirm_deletion_modal
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Step 3 Diagnostic Tests & Clinical Attachments workspace with test orders table, status triage pills, empty states, PDF/image file upload drag-and-drop zone (Max 10 MB), and final consultation locking execution.
 */

"use client";

import React, { useState, useRef } from "react";
import {
  FlaskConical,
  Plus,
  Trash2,
  UploadCloud,
  FileText,
  Image as ImageIcon,
  CheckCircle2,
  Clock,
  Zap,
  ArrowLeft,
  Lock,
  X,
  Paperclip,
} from "lucide-react";
import { TestOrderItem } from "@/types/medical_record";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import AddTestModal from "@/components/medical-record/modals/add_test_modal";
import ConfirmDeletionModal from "@/components/medical-record/modals/confirm_deletion_modal";
import { useTranslation } from "@/context/language_context";

interface UploadedFileItem {
  id: string;
  name: string;
  size: number;
  type: string;
  uploadedAt: string;
}

export default function Step3Tests() {
  const { translations } = useTranslation();

  const {
    record,
    removeTestOrder,
    setCurrentStep,
    finalizeRecordNow,
    isSaving: isFinalizing,
  } = useMedicalRecordWorkflow();

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [deletingTestId, setDeletingTestId] = useState<string | null>(null);
  const [isFinalizeModalOpen, setIsFinalizeModalOpen] = useState(false);
  const [isDiscardModalOpen, setIsDiscardModalOpen] = useState(false);
  const [isDragging, setIsDragging] = useState(false);

  const fileInputRef = useRef<HTMLInputElement>(null);
  const [uploadedFiles, setUploadedFiles] = useState<UploadedFileItem[]>([
    {
      id: "att-1",
      name: "Patient_ECG_Lead_II_Tracing.pdf",
      size: 1420000,
      type: "application/pdf",
      uploadedAt: "2026-08-18 10:14 AM",
    },
  ]);

  const tests = record.testsOrdered || [];

  const handleFiles = (fileList: FileList | null) => {
    if (!fileList || fileList.length === 0) return;
    const maxSizeBytes = 10 * 1024 * 1024; // 10 MB

    const newItems: UploadedFileItem[] = [];
    for (let i = 0; i < fileList.length; i++) {
      const file = fileList[i];
      if (file.size > maxSizeBytes) {
        alert(`File "${file.name}" exceeds the 10 MB size limit.`);
        continue;
      }
      newItems.push({
        id: `att-${Date.now()}-${i}`,
        name: file.name,
        size: file.size,
        type: file.type,
        uploadedAt: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      });
    }

    setUploadedFiles((prev) => [...prev, ...newItems]);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    handleFiles(e.dataTransfer.files);
  };

  const removeFile = (id: string) => {
    setUploadedFiles((prev) => prev.filter((f) => f.id !== id));
  };

  const formatFileSize = (bytes: number) => {
    if (bytes >= 1048576) {
      return (bytes / 1048576).toFixed(1) + " MB";
    }
    return (bytes / 1024).toFixed(0) + " KB";
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-200 text-start">
      {/* 1. Step Header */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3.5">
          <div className="p-3 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-2xl border border-blue-200 dark:border-blue-800 shrink-0">
            <FlaskConical className="w-6 h-6" />
          </div>
          <div>
            <h2 className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
              {translations.step3_title || "Step 3: Diagnostic Tests & Attachments"}
            </h2>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              {translations.step3_desc || translations.step3_subtitle || "Order laboratory diagnostics, upload supporting medical images or clinical PDF attachments, and finalize record."}
            </p>
          </div>
        </div>

        <button
          type="button"
          onClick={() => setIsAddModalOpen(true)}
          className="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-md transition flex items-center justify-center gap-2 shrink-0 cursor-pointer"
        >
          <Plus className="w-4 h-4" />
          <span>{translations.order_test || translations.add_new_test || "Order Diagnostic Test"}</span>
        </button>
      </div>

      {/* 2. Diagnostic Tests Table / Empty State */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs overflow-hidden">
        {tests.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="w-full text-xs text-slate-700 dark:text-slate-200 text-start">
              <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 uppercase text-[11px] font-bold text-slate-500 dark:text-slate-400">
                <tr>
                  <th className="py-3.5 px-4 text-start w-10">#</th>
                  <th className="py-3.5 px-4 text-start">{translations.test_name || "Diagnostic Test"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.type || "Category"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.priority || "Priority"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.status || "Status"}</th>
                  <th className="py-3.5 px-4 text-start">{translations.date || "Ordered Date"}</th>
                  <th className="py-3.5 px-4 text-end">{translations.col_actions || translations.actions || "Actions"}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
                {tests.map((test, idx) => (
                  <tr
                    key={test.id}
                    className="hover:bg-slate-50/80 dark:hover:bg-[#131E35]/60 transition"
                  >
                    <td className="py-3.5 px-4 text-slate-400 font-mono text-center">
                      {idx + 1}
                    </td>
                    <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white">
                      <div>
                        <span>{test.testName}</span>
                        {test.clinicalNotes && (
                          <p className="text-[11px] text-slate-500 font-normal italic truncate max-w-xs">
                            {test.clinicalNotes}
                          </p>
                        )}
                      </div>
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      <span className="px-2 py-0.5 rounded-md bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold text-[11px]">
                        {test.type}
                      </span>
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      <span
                        className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[11px] font-bold ${
                          "STAT" === test.priority
                            ? "bg-rose-100 dark:bg-rose-950/60 text-rose-800 dark:text-rose-300 border border-rose-300 dark:border-rose-700"
                            : "Urgent" === test.priority
                            ? "bg-amber-100 dark:bg-amber-950/60 text-amber-800 dark:text-amber-300 border border-amber-300 dark:border-amber-700"
                            : "bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800"
                        }`}
                      >
                        {"STAT" === test.priority || "Urgent" === test.priority ? (
                          <Zap className="w-3 h-3" />
                        ) : (
                          <Clock className="w-3 h-3" />
                        )}
                        <span>{test.priority}</span>
                      </span>
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap">
                      <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-blue-100 dark:bg-blue-900/60 text-blue-800 dark:text-blue-200 border border-blue-300 dark:border-blue-700">
                        {test.status || "Ordered"}
                      </span>
                    </td>
                    <td className="py-3.5 px-4 whitespace-nowrap text-slate-500 dark:text-slate-400">
                      {test.orderedAtUtc ? new Date(test.orderedAtUtc).toLocaleDateString() : "2026-08-18"}
                    </td>
                    <td className="py-3.5 px-4 text-end whitespace-nowrap">
                      <button
                        type="button"
                        onClick={() => setDeletingTestId(test.id)}
                        className="p-1.5 text-slate-500 hover:text-rose-600 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/60 transition cursor-pointer"
                        title="Delete Test Order"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          /* Empty State */
          <div className="p-12 text-center space-y-3">
            <div className="w-14 h-14 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-full flex items-center justify-center mx-auto">
              <FlaskConical className="w-7 h-7" />
            </div>
            <div className="space-y-1">
              <h3 className="text-sm font-bold text-slate-900 dark:text-white">
                {translations.no_tests || translations.no_tests_ordered || "No Tests Ordered Yet"}
              </h3>
              <p className="text-xs text-slate-500 dark:text-slate-400 max-w-sm mx-auto">
                {translations.no_tests_sub || "Order laboratory or radiological workups to support the clinical management plan."}
              </p>
            </div>
            <button
              type="button"
              onClick={() => setIsAddModalOpen(true)}
              className="px-5 py-2 text-xs font-bold text-blue-600 hover:text-blue-700 bg-blue-50 dark:bg-blue-950/60 hover:bg-blue-100 dark:hover:bg-blue-900/60 rounded-xl transition inline-flex items-center gap-1.5 cursor-pointer"
            >
              <Plus className="w-4 h-4" />
              <span>{translations.order_test || translations.add_new_test || "Order Diagnostic Test"}</span>
            </button>
          </div>
        )}
      </div>

      {/* 3. Drag-and-Drop Zone & Uploaded Files */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs space-y-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Paperclip className="w-4 h-4 text-blue-600 dark:text-blue-400" />
            <h3 className="text-sm md:text-base font-bold text-slate-900 dark:text-white">
              {translations.attachments_title || "Supporting Attachments & Diagnostic Images"}
            </h3>
          </div>
          <span className="text-xs text-slate-400">
            {translations.attachments_sub || "PDF, JPG, PNG (Max 10 MB per file)"}
          </span>
        </div>

        {/* Drag and Drop Container */}
        <div
          onDragOver={(e) => {
            e.preventDefault();
            setIsDragging(true);
          }}
          onDragLeave={() => setIsDragging(false)}
          onDrop={handleDrop}
          onClick={() => fileInputRef.current?.click()}
          className={`border-2 border-dashed rounded-2xl p-6 text-center transition cursor-pointer ${
            isDragging
              ? "border-blue-600 bg-blue-50/70 dark:bg-blue-950/50"
              : "border-slate-300 dark:border-slate-700 bg-slate-50/60 dark:bg-[#131E35]/40 hover:border-blue-400"
          }`}
        >
          <input
            ref={fileInputRef}
            type="file"
            multiple
            accept=".pdf,.jpg,.jpeg,.png"
            onChange={(e) => handleFiles(e.target.files)}
            className="hidden"
          />
          <div className="space-y-2">
            <div className="w-12 h-12 bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-full flex items-center justify-center mx-auto">
              <UploadCloud className="w-6 h-6" />
            </div>
            <p className="text-xs md:text-sm font-bold text-slate-800 dark:text-slate-200">
              {translations.drag_drop_title || "Drag & drop diagnostic reports or"}{" "}
              <span className="text-blue-600 dark:text-blue-400 underline">
                {translations.browse_files || "browse files"}
              </span>
            </p>
            <p className="text-[11px] text-slate-400">
              {translations.drag_drop_sub || "Upload lab results, ultrasound captures, radiology films, or ECG telemetry strips."}
            </p>
          </div>
        </div>

        {/* Uploaded Files Cards List */}
        {uploadedFiles.length > 0 && (
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
            {uploadedFiles.map((file) => {
              const isPdf = file.name.endsWith(".pdf");
              return (
                <div
                  key={file.id}
                  className="p-3 bg-slate-50 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-700 rounded-xl flex items-center justify-between gap-3"
                >
                  <div className="flex items-center gap-3 min-w-0">
                    <div className="p-2 rounded-lg bg-blue-100 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 shrink-0">
                      {isPdf ? <FileText className="w-5 h-5" /> : <ImageIcon className="w-5 h-5" />}
                    </div>
                    <div className="min-w-0">
                      <p className="text-xs font-bold text-slate-900 dark:text-white truncate">
                        {file.name}
                      </p>
                      <p className="text-[11px] text-slate-400">
                        {formatFileSize(file.size)} • {file.uploadedAt}
                      </p>
                    </div>
                  </div>

                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      removeFile(file.id);
                    }}
                    className="p-1.5 text-slate-400 hover:text-rose-600 rounded-lg hover:bg-rose-50 dark:hover:bg-rose-950/50 transition cursor-pointer"
                  >
                    <X className="w-4 h-4" />
                  </button>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* 4. Step 3 Footer Navigation with Finalize Locking */}
      <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 md:p-5 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <button
          type="button"
          onClick={() => setCurrentStep(2)}
          className="px-5 py-2.5 text-xs font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition flex items-center gap-1.5 cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4 rtl:rotate-180" />
          <span>{translations.previous || translations.back || "Previous"}</span>
        </button>

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
            onClick={() => setIsFinalizeModalOpen(true)}
            disabled={isFinalizing}
            className="px-6 py-2.5 text-xs font-bold text-white bg-emerald-600 hover:bg-emerald-700 rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer"
          >
            <Lock className="w-4 h-4" />
            <span>{isFinalizing ? "Finalizing & Signing..." : (translations.finalize_sign || translations.finalize_consultation || "Finalize & Sign Medical Record")}</span>
          </button>
        </div>
      </div>

      {/* Add Test Modal */}
      <AddTestModal
        isOpen={isAddModalOpen}
        onClose={() => setIsAddModalOpen(false)}
      />

      {/* Delete Test Confirmation Modal */}
      <ConfirmDeletionModal
        isOpen={!!deletingTestId}
        onClose={() => setDeletingTestId(null)}
        onConfirm={() => {
          if (deletingTestId) removeTestOrder(deletingTestId);
        }}
        title={translations.confirm_deletion || "Remove Diagnostic Test"}
        description={translations.delete_confirmation_desc || "Are you sure you want to cancel this diagnostic test order from the consultation record?"}
        confirmLabel={translations.delete || "Remove Test"}
      />

      {/* Finalize Locking Confirmation Modal */}
      <ConfirmDeletionModal
        isOpen={isFinalizeModalOpen}
        onClose={() => setIsFinalizeModalOpen(false)}
        onConfirm={async () => {
          await finalizeRecordNow();
        }}
        title={translations.finalize_consultation || "Finalize & Lock Medical Record"}
        description={translations.finalize_modal_body || "Are you sure you want to finalize and sign this medical record? Once finalized, the consultation will be locked against direct modification in compliance with clinical audit standards."}
        confirmLabel={translations.finalize_sign || "Finalize & Sign Record"}
        cancelLabel={translations.keep_in_draft || "Keep in Draft"}
        variant="primary"
      />

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

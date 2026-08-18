/*
 * File Name: step3_tests.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/medical_record_context
 *   - @/components/medical_record/modals/add_new_test_modal
 *   - @/components/medical_record/modals/confirm_deletion_modal
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Step 3 Tests Orders & Attachments presentation component with diagnostic menu, file drop zone, finalization security checks, scaled typography, and tightened EHR spacing.
 */

"use client";

import React, { useState } from "react";
import {
  FlaskConical,
  Paperclip,
  Plus,
  Trash2,
  Lock,
  ArrowLeft,
  CheckCircle,
  Save,
  Clock,
  Zap,
  Upload,
  File,
  ShieldCheck,
} from "lucide-react";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import AddNewTestModal from "@/components/medical_record/modals/add_new_test_modal";
import ConfirmDeletionModal from "@/components/medical_record/modals/confirm_deletion_modal";
import { useTranslation } from "@/context/language_context";

export default function Step3Tests() {
  const { translations } = useTranslation();
  const {
    record,
    removeTestOrder,
    addAttachment,
    removeAttachment,
    setCurrentStep,
    saveDraftNow,
    finalizeRecordNow,
    isSaving,
  } = useMedicalRecordWorkflow();

  const [isTestModalOpen, setIsTestModalOpen] = useState(false);
  const [deletingTestId, setDeletingTestId] = useState<string | null>(null);
  const [deletingAttId, setDeletingAttId] = useState<string | null>(null);
  const [isFinalizeModalOpen, setIsFinalizeModalOpen] = useState(false);
  const [saveBanner, setSaveBanner] = useState<string | null>(null);

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      addAttachment({
        id: `att-${Date.now()}-${i}`,
        fileName: file.name,
        fileSize: file.size,
        fileType: file.type,
        uploadedAt: new Date().toLocaleDateString("en-US", {
          month: "short",
          day: "numeric",
          year: "numeric",
        }),
        fileUrl: "#",
      });
    }
  };

  const handleManualSave = async () => {
    const res = await saveDraftNow();
    if (res) {
      setSaveBanner(translations.save_draft);
      setTimeout(() => setSaveBanner(null), 3000);
    }
  };

  const handleTriggerFinalize = () => {
    setIsFinalizeModalOpen(true);
  };

  const handleConfirmFinalize = async () => {
    await finalizeRecordNow();
    setIsFinalizeModalOpen(false);
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

      {/* 1. Diagnostic Tests Section */}
      <div className="space-y-2">
        <div className="flex flex-wrap items-center justify-between gap-3 mb-2">
          <div className="text-start">
            <h2 className="text-base md:text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2">
              <FlaskConical className="w-5 h-5 text-blue-600 dark:text-blue-400" />
              {translations.tests_ordered}
            </h2>
            <p className="text-xs md:text-sm font-medium text-slate-500 dark:text-slate-400">
              {translations.tests_ordered} ({record.testsOrdered.length})
            </p>
          </div>

          <button
            type="button"
            onClick={() => setIsTestModalOpen(true)}
            className="px-4 py-2 text-xs md:text-sm font-bold text-white bg-blue-600 hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-500 rounded-xl shadow-xs transition flex items-center gap-2 cursor-pointer"
          >
            <Plus className="w-4 h-4" />
            {translations.add_test}
          </button>
        </div>

        {/* Tests Table or Empty */}
        <div className="bg-white dark:bg-[#0E1726] rounded-2xl border-2 border-slate-200 dark:border-slate-800 shadow-xs overflow-hidden">
          {record.testsOrdered.length === 0 ? (
            <div className="p-6 md:p-8 text-center space-y-2">
              <FlaskConical className="w-8 h-8 text-slate-400 mx-auto" />
              <p className="text-base md:text-lg font-bold text-slate-700 dark:text-slate-300">
                {translations.no_tests_ordered}
              </p>
              <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400">
                {translations.no_tests_desc}
              </p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-start">
                <thead className="bg-slate-100/90 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-700 py-2.5 px-4 md:px-5 text-xs font-bold uppercase tracking-wider text-slate-700 dark:text-slate-200">
                  <tr>
                    <th className="py-2.5 px-4 md:px-5 text-start">{translations.test_name}</th>
                    <th className="py-2.5 px-4 md:px-5 text-start">{translations.test_type}</th>
                    <th className="py-2.5 px-4 md:px-5 text-start">{translations.priority}</th>
                    <th className="py-2.5 px-4 md:px-5 text-start">{translations.filter_record_status}</th>
                    <th className="py-2.5 px-4 md:px-5 text-start">{translations.clinical_notes}</th>
                    <th className="py-2.5 px-4 md:px-5 text-end">{translations.actions}</th>
                  </tr>
                </thead>
                <tbody className="divide-y-2 divide-slate-100 dark:divide-slate-700/60">
                  {record.testsOrdered.map((test) => (
                    <tr
                      key={test.id}
                      className="hover:bg-slate-50 dark:hover:bg-slate-800/40 text-slate-800 dark:text-slate-200 text-xs md:text-sm font-medium transition-colors"
                    >
                      <td className="py-2.5 px-4 md:px-5 font-bold text-slate-900 dark:text-white text-xs md:text-sm">
                        {test.testName}
                      </td>
                      <td className="py-2.5 px-4 md:px-5 text-slate-600 dark:text-slate-300">
                        {test.type}
                      </td>
                      <td className="py-2.5 px-4 md:px-5">
                        <span
                          className={`inline-flex items-center gap-1 px-2 py-0.5 text-xs font-bold rounded-lg ${
                            "STAT" === test.priority
                              ? "bg-red-100 dark:bg-red-950/60 text-red-700 dark:text-red-300 border border-red-300"
                              : "Urgent" === test.priority
                              ? "bg-amber-100 dark:bg-amber-950/60 text-amber-700 dark:text-amber-300 border border-amber-300"
                              : "bg-blue-100 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 border border-blue-300"
                          }`}
                        >
                          {"STAT" === test.priority ? (
                            <Zap className="w-3 h-3" />
                          ) : (
                            <Clock className="w-3 h-3" />
                          )}
                          {"STAT" === test.priority
                            ? translations.priority_stat
                            : "Urgent" === test.priority
                            ? translations.priority_urgent
                            : translations.priority_routine}
                        </span>
                      </td>
                      <td className="py-2.5 px-4 md:px-5">
                        <span className="px-2 py-0.5 text-xs font-semibold bg-slate-100 dark:bg-[#131E35] text-slate-700 dark:text-slate-300 rounded-md border border-slate-200 dark:border-slate-700">
                          {test.status}
                        </span>
                      </td>
                      <td className="py-2.5 px-4 md:px-5 text-slate-500 dark:text-slate-400 max-w-[200px] truncate">
                        {test.clinicalNotes || "—"}
                      </td>
                      <td className="py-2.5 px-4 md:px-5 text-end">
                        <button
                          type="button"
                          onClick={() => setDeletingTestId(test.id)}
                          className="p-1.5 text-slate-500 hover:text-red-600 rounded-lg hover:bg-red-50 dark:hover:bg-red-950/40 transition"
                          title="Delete"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>

      {/* 2. Attachments Drag & Drop Section */}
      <div className="space-y-2 pt-2 border-t border-slate-200 dark:border-slate-800/80">
        <div className="text-start mb-2">
          <h2 className="text-base md:text-lg font-bold text-slate-900 dark:text-white flex items-center gap-2">
            <Paperclip className="w-5 h-5 text-blue-600 dark:text-blue-400" />
            {translations.attachments}
          </h2>
          <p className="text-xs md:text-sm font-medium text-slate-500 dark:text-slate-400">
            {translations.attachments} ({record.attachments.length})
          </p>
        </div>

        {/* Upload Drop Zone */}
        <label
          htmlFor="file-upload-input"
          className="border-2 border-dashed border-slate-300 dark:border-slate-700 hover:border-blue-500 dark:hover:border-blue-400 bg-white dark:bg-[#0E1726] hover:bg-blue-50/20 dark:hover:bg-blue-950/20 rounded-2xl p-4 md:p-5 text-center cursor-pointer transition space-y-2 block"
        >
          <input
            id="file-upload-input"
            type="file"
            multiple
            onChange={handleFileUpload}
            className="hidden"
            accept=".pdf,.jpg,.jpeg,.png,.dcm"
          />
          <div className="w-10 h-10 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-full flex items-center justify-center mx-auto">
            <Upload className="w-5 h-5" />
          </div>
          <div className="space-y-0.5">
            <p className="text-sm md:text-base font-bold text-slate-900 dark:text-white">
              {translations.drag_drop_upload}
            </p>
            <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400">
              {translations.supported_formats_hint}
            </p>
          </div>
        </label>

        {/* Attached Files List */}
        {record.attachments.length > 0 && (
          <div className="space-y-2 pt-1">
            {record.attachments.map((att) => (
              <div
                key={att.id}
                className="flex items-center justify-between p-3 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-xl shadow-xs"
              >
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-slate-100 dark:bg-slate-800 rounded-lg text-slate-600 dark:text-slate-300">
                    <File className="w-4 h-4" />
                  </div>
                  <div className="text-start">
                    <p className="text-xs md:text-sm font-bold text-slate-900 dark:text-white">
                      {att.fileName}
                    </p>
                    <p className="text-xs text-slate-400">
                      {Math.round(att.fileSize / 1024)} KB •{" "}
                      {att.uploadedAt}
                    </p>
                  </div>
                </div>

                <button
                  type="button"
                  onClick={() => setDeletingAttId(att.id)}
                  className="p-1.5 text-slate-400 hover:text-red-600 rounded-lg hover:bg-red-50 dark:hover:bg-red-950/40 transition"
                  title="Remove attachment"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* 3. Finalization Security Assurance Callout */}
      <div className="p-4 md:p-5 bg-blue-50/80 dark:bg-[#131E35] border-2 border-blue-200/80 dark:border-blue-900/60 rounded-2xl space-y-3 shadow-xs">
        <div className="flex items-start gap-3 text-start">
          <div className="p-2 bg-blue-600 text-white rounded-xl shrink-0 shadow-xs">
            <Lock className="w-5 h-5" />
          </div>
          <div>
            <h3 className="text-base md:text-lg font-bold text-slate-900 dark:text-white">
              {translations.finalize_record}
            </h3>
            <p className="text-xs md:text-sm text-slate-600 dark:text-slate-400 mt-0.5 leading-relaxed">
              {translations.finalized_locked_notice}
            </p>
          </div>
        </div>

        <div className="flex flex-wrap items-center justify-between gap-3 pt-2.5 border-t border-blue-200/60 dark:border-blue-900/40">
          <div className="flex items-center gap-2.5">
            <button
              type="button"
              onClick={() => setCurrentStep(2)}
              className="px-5 py-2.5 text-sm md:text-base font-semibold text-slate-700 dark:text-slate-300 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 rounded-xl shadow-xs transition flex items-center gap-2 cursor-pointer"
            >
              <ArrowLeft className="w-4 h-4 rtl:rotate-180" />
              {translations.back}
            </button>

            <button
              type="button"
              disabled={isSaving}
              onClick={handleManualSave}
              className="px-5 py-2.5 text-sm md:text-base font-semibold text-slate-700 dark:text-slate-300 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700 rounded-xl shadow-xs transition flex items-center gap-2 cursor-pointer"
            >
              <Save className="w-4 h-4 text-slate-500" />
              {isSaving ? translations.medrec_btn_saving_draft : translations.save_draft}
            </button>
          </div>

          <button
            type="button"
            disabled={isSaving}
            onClick={handleTriggerFinalize}
            className="px-6 py-2.5 text-sm md:text-base font-bold text-white bg-emerald-600 hover:bg-emerald-700 dark:bg-emerald-600 dark:hover:bg-emerald-500 rounded-xl shadow-md transition flex items-center gap-2 cursor-pointer"
          >
            <CheckCircle className="w-4 h-4" />
            {translations.finalize_record}
          </button>
        </div>
      </div>

      {/* Add Test Modal */}
      <AddNewTestModal
        isOpen={isTestModalOpen}
        onClose={() => setIsTestModalOpen(false)}
      />

      {/* Delete Test Modal */}
      <ConfirmDeletionModal
        isOpen={Boolean(deletingTestId)}
        onClose={() => setDeletingTestId(null)}
        onConfirm={() => {
          if (deletingTestId) removeTestOrder(deletingTestId);
        }}
        title={translations.confirm_deletion_title}
        description={translations.confirm_deletion_desc}
        confirmLabel={translations.delete}
        cancelLabel={translations.cancel}
        variant="danger"
      />

      {/* Delete Attachment Modal */}
      <ConfirmDeletionModal
        isOpen={Boolean(deletingAttId)}
        onClose={() => setDeletingAttId(null)}
        onConfirm={() => {
          if (deletingAttId) removeAttachment(deletingAttId);
        }}
        title={translations.confirm_deletion_title}
        description={translations.confirm_deletion_desc}
        confirmLabel={translations.delete}
        cancelLabel={translations.cancel}
        variant="danger"
      />

      {/* Finalize Confirmation Dialog */}
      <ConfirmDeletionModal
        isOpen={isFinalizeModalOpen}
        onClose={() => setIsFinalizeModalOpen(false)}
        onConfirm={handleConfirmFinalize}
        title={translations.finalize_record}
        description={translations.confirm_deletion_desc}
        confirmLabel={translations.finalize_record}
        cancelLabel={translations.cancel}
        variant="primary"
        isLoading={isSaving}
      />
    </div>
  );
}

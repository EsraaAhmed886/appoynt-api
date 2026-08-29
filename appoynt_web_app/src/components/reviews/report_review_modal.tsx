/**
 * File Name : report_review_modal.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/types/review, @/constants/review_constants
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Accessible modal dialog for reporting an inappropriate or abusive review, providing radio reason options, optional details input, and duplicate submission guards.
 */

"use client";

import React, { useState, useEffect, useRef } from "react";
import { X, Flag, Loader2 } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { Review, ReportReason } from "@/types/review";
import { REVIEW_REPORT_REASON_VALUES } from "@/constants/review_constants";

type ReportReviewModalProps = {
  review: Review;
  isSubmitting: boolean;
  onClose: () => void;
  onSubmit: (reason: ReportReason, details?: string) => void;
};

export default function ReportReviewModal({
  review,
  isSubmitting,
  onClose,
  onSubmit,
}: ReportReviewModalProps) {
  const { translations } = useTranslation();

  const [selectedReason, setSelectedReason] = useState<ReportReason>("inappropriate_language");
  const [details, setDetails] = useState<string>("");
  const modalRef = useRef<HTMLDivElement>(null);

  // Close modal when pressing the Escape key
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if ("Escape" === event.key && !isSubmitting) {
        onClose();
      } else {
        // Ignored
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isSubmitting, onClose]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!isSubmitting && selectedReason) {
      onSubmit(selectedReason, details);
    } else {
      // Submitting or no reason selected
    }
  };

  const getReasonLabel = (reason: ReportReason): string => {
    if ("inappropriate_language" === reason) {
      return translations.report_reason_inappropriate || "Inappropriate / Offensive content";
    } else if ("abusive_content" === reason) {
      return translations.report_reason_abusive || "Spam / Irrelevant";
    } else if ("false_information" === reason) {
      return translations.report_reason_false_info || "Contains false information";
    } else {
      return translations.report_reason_other || "Other";
    }
  };

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="report-modal-title"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-xs animate-in fade-in duration-150"
    >
      <div
        ref={modalRef}
        className="w-full max-w-lg rounded-2xl bg-white dark:bg-[#0E1726] border border-slate-200 dark:border-slate-800 shadow-2xl overflow-hidden animate-in zoom-in-95 duration-150"
      >
        {/* Header Bar */}
        <div className="flex items-center justify-between px-6 py-4 bg-blue-600 text-white">
          <div className="flex items-center gap-2">
            <Flag className="w-5 h-5" />
            <h3 id="report-modal-title" className="text-base font-bold">
              {translations.modal_report_title || "Report Review"}
            </h3>
          </div>

          <button
            type="button"
            onClick={onClose}
            disabled={isSubmitting}
            aria-label="Close"
            className="p-1 rounded-lg hover:bg-blue-700 transition cursor-pointer disabled:opacity-50"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-5">
          <div className="space-y-3">
            <p className="text-xs sm:text-sm font-bold text-app-text-primary">
              {translations.modal_report_prompt || "Why are you reporting this review?"}
            </p>

            <div className="space-y-2.5">
              {REVIEW_REPORT_REASON_VALUES.map((reason) => {
                const isSelected = selectedReason === reason;
                return (
                  <label
                    key={reason}
                    className={`flex items-center gap-3 p-3 rounded-xl border transition cursor-pointer ${
                      isSelected
                        ? "border-blue-600 bg-blue-50/50 dark:bg-blue-950/30 text-blue-900 dark:text-blue-100"
                        : "border-slate-200 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/40 text-app-text-primary"
                    }`}
                  >
                    <input
                      type="radio"
                      name="report_reason"
                      value={reason}
                      checked={isSelected}
                      disabled={isSubmitting}
                      onChange={() => setSelectedReason(reason)}
                      className="w-4 h-4 text-blue-600 focus:ring-blue-500 border-slate-300 dark:border-slate-700"
                    />
                    <span className="text-xs sm:text-sm font-medium">
                      {getReasonLabel(reason)}
                    </span>
                  </label>
                );
              })}
            </div>
          </div>

          {/* Optional Details Textarea */}
          <div className="space-y-1.5">
            <textarea
              rows={3}
              value={details}
              disabled={isSubmitting}
              maxLength={500}
              placeholder={translations.report_details_placeholder || "Additional details (optional)..."}
              onChange={(e) => setDetails(e.target.value)}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-[#131D31] text-xs sm:text-sm text-app-text-primary placeholder:text-app-text-secondary focus:outline-none focus:border-blue-600 focus:ring-2 focus:ring-blue-500/10 transition resize-none"
            />
          </div>

          {/* Action Buttons */}
          <div className="flex items-center justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              disabled={isSubmitting}
              className="px-5 py-2.5 rounded-xl border border-slate-200 dark:border-slate-700 text-xs sm:text-sm font-semibold text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition cursor-pointer disabled:opacity-50"
            >
              {translations.btn_cancel || "Cancel"}
            </button>

            <button
              type="submit"
              disabled={isSubmitting || !selectedReason}
              className="inline-flex items-center gap-1.5 px-6 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs sm:text-sm font-semibold transition shadow-xs cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {isSubmitting ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin" />
                  <span>{translations.btn_submitting || "Submitting..."}</span>
                </>
              ) : (
                <>
                  <Flag className="w-4 h-4" />
                  <span>{translations.btn_submit_report || "Submit Report"}</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

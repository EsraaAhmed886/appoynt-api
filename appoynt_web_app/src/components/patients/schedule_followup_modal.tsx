/**

File Name : schedule_followup_modal.tsx
Author : Shimaa Salah
Created Date : 28/08/2026
Version : v1.0.0
Dependencies :
  - react
  - lucide-react
  - @/context/language_context
  - @/types/patient

Contributors : [Shimaa Salah]
Last Modified : Shimaa Salah - 28/08/2026
Description : Accessible modal dialog for scheduling a patient follow-up appointment with date/time validation and conflict prevention.

*/

"use client";

import React, { useState } from "react";
import { X, Calendar, Clock, AlertCircle } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { Patient, CreateFollowUpPayload } from "@/types/patient";

type ScheduleFollowUpModalProps = {
  patient: Patient | null;
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (
    payload: CreateFollowUpPayload,
  ) => Promise<{ success: boolean; error?: string }>;
};

export default function ScheduleFollowUpModal({
  patient,
  isOpen,
  onClose,
  onSubmit,
}: ScheduleFollowUpModalProps) {
  const { translations } = useTranslation();

  const [appointmentDate, setAppointmentDate] = useState<string>("");
  const [appointmentTime, setAppointmentTime] = useState<string>("");
  const [notes, setNotes] = useState<string>("");

  const [validationError, setValidationError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  if (!isOpen || !patient) {
    return null;
  } else {
    // Modal active state
  }

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    setValidationError(null);

    if (!appointmentDate) {
      setValidationError(translations.val_date_future_required);
      return;
    } else {
      // Date string present
    }

    if (!appointmentTime) {
      setValidationError(translations.val_time_required);
      return;
    } else {
      // Time string present
    }

    const selectedDateTime: Date = new Date(
      `${appointmentDate}T${appointmentTime}`,
    );
    const now: Date = new Date();

    if (selectedDateTime.getTime() <= now.getTime()) {
      setValidationError(translations.val_date_future_required);
      return;
    } else {
      // Validation criteria met
    }

    setIsSubmitting(true);
    const result = await onSubmit({
      patientId: patient.id,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      notes: notes,
    });
    setIsSubmitting(false);

    if (result.success) {
      setAppointmentDate("");
      setAppointmentTime("");
      setNotes("");
      onClose();
    } else {
      setValidationError(result.error || translations.toast_followup_failed);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
      <div className="relative w-full max-w-lg overflow-hidden rounded-2xl border border-app-border bg-app-surface shadow-2xl transition-all">
        {/* Header */}
        <div className="flex items-center justify-between border-b border-app-border/40 px-6 py-4">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-app-primary/10 text-app-primary">
              <Calendar className="h-5 w-5" />
            </div>
            <div>
              <h2 className="text-lg font-bold text-app-text-primary">
                {translations.modal_followup_title}
              </h2>
              <p className="text-xs text-app-text-secondary">
                {patient.name} ({patient.patientId})
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            aria-label="Close modal"
            className="rounded-lg p-1.5 text-app-text-secondary hover:bg-app-input_fill hover:text-app-text-primary transition"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        {/* Form Controls */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {validationError ? (
            <div className="flex items-center gap-2 rounded-xl border border-rose-200 bg-rose-50 p-3 text-xs font-medium text-rose-800 dark:border-rose-900/50 dark:bg-rose-950/40 dark:text-rose-300">
              <AlertCircle className="h-4 w-4 shrink-0 text-rose-600 dark:text-rose-400" />
              <span>{validationError}</span>
            </div>
          ) : null}

          <div>
            <label className="block text-xs font-semibold text-app-text-primary mb-1">
              {translations.lbl_followup_date} *
            </label>
            <input
              type="date"
              value={appointmentDate}
              min={new Date().toISOString().split("T")[0]}
              onChange={(event) => setAppointmentDate(event.target.value)}
              className="w-full rounded-xl border border-app-border bg-app-input_fill px-3.5 py-2.5 text-sm text-app-text-primary focus:border-app-primary focus:outline-none focus:ring-2 focus:ring-app-primary/20 transition"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-app-text-primary mb-1">
              {translations.lbl_followup_time} *
            </label>
            <input
              type="time"
              value={appointmentTime}
              onChange={(event) => setAppointmentTime(event.target.value)}
              className="w-full rounded-xl border border-app-border bg-app-input_fill px-3.5 py-2.5 text-sm text-app-text-primary focus:border-app-primary focus:outline-none focus:ring-2 focus:ring-app-primary/20 transition"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-app-text-primary mb-1">
              {translations.lbl_followup_notes}
            </label>
            <textarea
              rows={3}
              value={notes}
              placeholder={translations.ph_followup_notes}
              onChange={(event) => setNotes(event.target.value)}
              className="w-full rounded-xl border border-app-border bg-app-input_fill px-3.5 py-2.5 text-sm text-app-text-primary placeholder:text-app-text-secondary focus:border-app-primary focus:outline-none focus:ring-2 focus:ring-app-primary/20 transition"
            />
          </div>

          {/* Action Triggers */}
          <div className="flex items-center justify-end gap-3 pt-4 border-t border-app-border/40">
            <button
              type="button"
              onClick={onClose}
              className="rounded-xl border border-app-border px-4 py-2 text-xs font-semibold text-app-text-primary hover:bg-app-input_fill transition"
            >
              {translations.btn_cancel}
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              className="flex items-center gap-2 rounded-xl bg-blue-600 px-5 py-2 text-xs font-semibold text-white hover:bg-blue-700 disabled:opacity-50 shadow-sm transition cursor-pointer"
            >
              {isSubmitting ? (
                <div className="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
              ) : (
                <Clock className="h-4 w-4" />
              )}
              <span>{translations.action_schedule_followup}</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

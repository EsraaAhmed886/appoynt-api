/*
 * File Name: active_consultation_card.tsx
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.3.0
 * Dependencies: react, lucide-react, @/types/appointment, @/hooks/use_consultation_timer, @/context/language_context
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Client component rendering active consultation patient info, persistent timer, quick snapshot snapshot, and action buttons with 10-min minimum consultation time rules.
 */

"use client";

import { useState } from "react";
import Image from "next/image";
import {
  Phone,
  Clock,
  CheckCircle2,
  FileText,
  Pill,
  UserX,
  ExternalLink,
} from "lucide-react";
import { active_consultation } from "@/types/appointment";
import { use_consultation_timer } from "@/hooks/use_consultation_timer";
import { useTranslation } from "@/context/language_context";

type active_consultation_card_props = {
  consultation: active_consultation | null;
  on_end_click: () => void;
};

export default function active_consultation_card({
  consultation,
  on_end_click,
}: active_consultation_card_props) {
  const { translations } = useTranslation();
  const [image_error, set_image_error] = useState<boolean>(false);

  const timer_data = use_consultation_timer(consultation?.started_at);

  // Render Empty State when no active consultation exists
  if (null === consultation) {
    return (
      <div className="flex flex-col items-center justify-center p-8 md:p-12 rounded-2xl bg-app-surface border border-dashed border-app-border text-center shadow-xs min-h-[300px]">
        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 mb-4">
          <UserX className="h-8 w-8 text-app-text-secondary" />
        </div>
        <h3 className="text-xl font-bold text-app-text-primary">
          {translations.no_active_consultation_title}
        </h3>
        <p className="mt-2 text-sm text-app-text-secondary max-w-sm">
          {translations.no_active_consultation_desc}
        </p>
      </div>
    );
  } else {
    const { patient } = consultation;
    const summary = patient.summary;

    const chronic_diseases = summary?.chronic_diseases ?? [];
    const allergies = summary?.allergies ?? [];
    const last_visit = summary?.last_visit_date ?? translations.label_not_available;

    const visit_type_label =
      "follow_up" === patient.visit_type
        ? translations.visit_type_follow_up
        : translations.visit_type_new;

    // Minimum consultation time calculations (10 minutes / 600 seconds)
    const slot_duration_mins = patient.visit_duration_mins ?? 30;
    const max_duration_seconds = slot_duration_mins * 60;
    const min_duration_seconds = Math.min(600, max_duration_seconds);
    const is_end_disabled = timer_data.elapsed_seconds < min_duration_seconds;

    return (
      <div className="rounded-2xl bg-app-surface p-5 md:p-6 border border-app-border shadow-xs space-y-6">
        {/* Header Title and Status Badge */}
        <div className="flex items-center justify-between border-b border-app-border/40 pb-4">
          <div className="flex items-center gap-3">
            <h2 className="text-lg font-bold text-app-text-primary">
              {translations.current_patient_title}
            </h2>
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800 dark:bg-emerald-950/60 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
              <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
              {translations.in_consultation_badge}
            </span>
          </div>
        </div>

        {/* Card Main Info Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
          {/* Patient Details Sub-column (Left) */}
          <div className="lg:col-span-7 flex flex-col sm:flex-row items-start gap-4">
            {/* Patient Avatar Image */}
            <div className="relative h-16 w-16 rounded-full overflow-hidden bg-gray-100 dark:bg-gray-800 flex-shrink-0 border border-app-border">
              {patient.profile_image_url && false === image_error ? (
                <Image
                  src={patient.profile_image_url}
                  alt={patient.full_name}
                  fill
                  className="object-cover"
                  onError={() => set_image_error(true)}
                />
              ) : (
                <div className="flex h-full w-full items-center justify-center text-xl font-bold text-app-primary bg-blue-50 dark:bg-blue-950/40">
                  {patient.full_name.charAt(0)}
                </div>
              )}
            </div>

            {/* Patient Metadata (Name remains EXACTLY as provided) */}
            <div className="space-y-3 flex-1">
              <div>
                <h3 className="text-xl font-bold text-app-text-primary">
                  {patient.full_name}
                </h3>
                <p className="text-xs text-app-text-secondary mt-0.5">
                  {visit_type_label} • {slot_duration_mins} {translations.label_min}
                </p>
              </div>

              <div className="flex flex-wrap items-center gap-4 text-xs text-app-text-secondary">
                <div className="flex items-center gap-1.5">
                  <Phone className="h-3.5 w-3.5 text-app-text-secondary" />
                  <span dir="ltr">{patient.phone_number ?? translations.label_not_available}</span>
                </div>

                <div className="flex items-center gap-1.5">
                  <span className="text-[11px] font-medium text-app-text-secondary uppercase">
                    {translations.label_visit_type}:
                  </span>
                  <span className="px-2 py-0.5 rounded text-[11px] font-semibold bg-blue-100 text-blue-800 dark:bg-blue-950/60 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
                    {visit_type_label}
                  </span>
                </div>
              </div>

              {/* Timing Specifications */}
              <div className="grid grid-cols-3 gap-2 pt-3 text-xs border-t border-app-border/40">
                <div>
                  <span className="block text-[11px] text-app-text-secondary">
                    {translations.expected_time_label}
                  </span>
                  <span className="font-semibold text-app-text-primary" dir="ltr">
                    {consultation.expected_time}
                  </span>
                </div>

                <div>
                  <span className="block text-[11px] text-app-text-secondary">
                    {translations.actual_time_label}
                  </span>
                  <span className="font-semibold text-emerald-600 dark:text-emerald-400" dir="ltr">
                    {consultation.actual_time}
                  </span>
                </div>

                <div>
                  <span className="block text-[11px] text-app-text-secondary">
                    {translations.duration_label}
                  </span>
                  <div className="flex items-center gap-1.5 font-bold text-app-text-primary">
                    <Clock className="h-3.5 w-3.5 text-app-primary flex-shrink-0" />
                    <span dir="ltr" className="inline-block font-mono tracking-wider text-xs">
                      {timer_data.formatted_time}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Quick Snapshot Card Sub-column (Right Box) */}
          <div className="lg:col-span-5 p-4 rounded-xl bg-app-bg/60 border border-app-border/60 space-y-3 dark:bg-app-bg/40">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-app-text-secondary uppercase tracking-wider">
                {translations.quick_snapshot_title}
              </span>
            </div>

            <div className="space-y-2 text-xs">
              <div className="flex items-center justify-between gap-2">
                <span className="text-app-text-secondary">
                  {translations.chronic_disease_label}
                </span>
                <div className="flex flex-wrap gap-1">
                  {chronic_diseases.length > 0 ? (
                    chronic_diseases.map((disease, idx) => (
                      <span
                        key={idx}
                        className="px-2 py-0.5 rounded-full text-[11px] font-medium bg-blue-100 text-blue-800 dark:bg-blue-950/60 dark:text-blue-300 border border-blue-200 dark:border-blue-800"
                      >
                        {disease}
                      </span>
                    ))
                  ) : (
                    <span className="text-app-text-secondary">{translations.label_not_available}</span>
                  )}
                </div>
              </div>

              <div className="flex items-center justify-between gap-2">
                <span className="text-app-text-secondary">
                  {translations.allergies_label}
                </span>
                <div className="flex flex-wrap gap-1">
                  {allergies.length > 0 ? (
                    allergies.map((allergy, idx) => (
                      <span
                        key={idx}
                        className="px-2 py-0.5 rounded-full text-[11px] font-medium bg-rose-100 text-rose-800 dark:bg-rose-950/60 dark:text-rose-300 border border-rose-200 dark:border-rose-800"
                      >
                        {allergy}
                      </span>
                    ))
                  ) : (
                    <span className="text-app-text-secondary">{translations.label_not_available}</span>
                  )}
                </div>
              </div>

              <div className="flex items-center justify-between pt-1.5 border-t border-app-border/30">
                <span className="text-app-text-secondary">
                  {translations.last_visit_label}
                </span>
                <span className="font-medium text-app-text-primary">
                  {last_visit}
                </span>
              </div>
            </div>

            <button
              type="button"
              className="w-full mt-2 flex items-center justify-center gap-1.5 px-3 py-2 rounded-lg border border-app-border bg-app-surface text-xs font-medium text-app-primary hover:bg-app-input_fill transition shadow-2xs"
            >
              <ExternalLink className="h-3.5 w-3.5" />
              {translations.btn_view_full_record}
            </button>
          </div>
        </div>

        {/* Action Buttons Row */}
        <div className="flex flex-wrap items-center gap-3 pt-4 border-t border-app-border/40">
          <div className="flex flex-col gap-1">
            <button
              type="button"
              onClick={on_end_click}
              disabled={is_end_disabled}
              title={is_end_disabled ? translations.lbl_min_consultation_time_help : undefined}
              className={`
                flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl bg-app-primary text-white text-sm font-semibold transition shadow-xs
                ${is_end_disabled ? "opacity-50 cursor-not-allowed" : "hover:opacity-90"}
              `}
            >
              <CheckCircle2 className="h-4 w-4" />
              {translations.btn_end_consultation}
            </button>
            {is_end_disabled ? (
              <span className="text-[11px] text-app-text-secondary font-medium">
                {translations.lbl_min_consultation_time_help}
              </span>
            ) : null}
          </div>

          <button
            type="button"
            className="flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl border border-app-border bg-app-surface text-app-text-primary text-sm font-semibold hover:bg-app-input_fill transition"
          >
            <FileText className="h-4 w-4 text-app-text-secondary" />
            {translations.btn_add_note}
          </button>

          <button
            type="button"
            className="flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl border border-app-border bg-app-surface text-app-text-primary text-sm font-semibold hover:bg-app-input_fill transition"
          >
            <Pill className="h-4 w-4 text-app-text-secondary" />
            {translations.btn_prescription}
          </button>
        </div>
      </div>
    );
  }
}

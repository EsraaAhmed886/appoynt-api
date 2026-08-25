/**
 * File Name : booking_settings_section.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/components/clinics/custom_select, @/components/clinics/clinic_form_constants
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Section 5 component for displaying and configuring appointment duration and maximum advance booking settings matching reference design.
 */

"use client";

import { Edit2, Clock, CalendarDays } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import CustomSelect from "../custom_select";
import { DURATION_OPTIONS, ADVANCE_BOOKING_OPTIONS } from "../clinic_form_constants";

type BookingSettingsSectionProps = {
  is_edit_mode: boolean;
  is_card_dirty?: boolean;
  appointment_duration: string;
  max_advance_booking: string;
  set_appointment_duration: (val: string) => void;
  set_max_advance_booking: (val: string) => void;
  on_mark_dirty: () => void;
  on_toggle_edit: () => void;
  on_cancel?: () => void;
  on_save?: () => void;
};

export default function BookingSettingsSection({
  is_edit_mode,
  is_card_dirty = false,
  appointment_duration,
  max_advance_booking,
  set_appointment_duration,
  set_max_advance_booking,
  on_mark_dirty,
  on_toggle_edit,
  on_cancel,
  on_save,
}: BookingSettingsSectionProps) {
  const { translations } = useTranslation();

  return (
    <div className="rounded-2xl border border-app-border bg-app-surface p-6 shadow-sm space-y-6">
      {/* Section Header */}
      <div className="flex items-center justify-between border-b border-app-border pb-4">
        <h2 className="text-xl font-bold text-app-text-primary">
          {translations.lbl_section_booking}
        </h2>

        {is_edit_mode ? (
          <div className="flex items-center gap-2">
            {is_card_dirty ? (
              <button
                type="button"
                onClick={on_save}
                className="rounded-lg bg-app-primary px-3.5 py-1.5 text-xs font-semibold text-white shadow-sm hover:opacity-90 transition-all"
              >
                {translations.btn_save_changes}
              </button>
            ) : null}
            <button
              type="button"
              onClick={on_cancel || on_toggle_edit}
              className="rounded-lg border border-app-border bg-app-surface px-3 py-1.5 text-xs font-semibold text-app-text-primary hover:bg-app-input_fill transition-all"
            >
              {translations.btn_cancel}
            </button>
          </div>
        ) : (
          <button
            type="button"
            onClick={on_toggle_edit}
            className="flex items-center gap-1.5 rounded-lg border border-app-border bg-app-surface px-3 py-1.5 text-xs font-semibold text-app-primary hover:bg-app-input_fill transition-all"
          >
            <Edit2 size={14} />
            <span>{translations.lbl_edit_section}</span>
          </button>
        )}
      </div>

      {/* Section Body */}
      {!is_edit_mode ? (
        /* READ-ONLY VIEW MODE matching reference image */
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
          {/* Duration */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
              <Clock size={20} />
            </div>
            <div>
              <p className="text-xs font-medium text-app-text-secondary">
                {translations.lbl_appointment_duration}
              </p>
              <p className="text-base font-bold text-app-text-primary mt-0.5">
                {appointment_duration || "—"}
              </p>
              <p className="mt-1 text-xs text-app-text-secondary opacity-80">
                {translations.lbl_appointment_duration_help}
              </p>
            </div>
          </div>

          {/* Max Advance Booking */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
              <CalendarDays size={20} />
            </div>
            <div>
              <p className="text-xs font-medium text-app-text-secondary">
                {translations.lbl_max_advance_booking}
              </p>
              <p className="text-base font-bold text-app-text-primary mt-0.5">
                {max_advance_booking || "—"}
              </p>
              <p className="mt-1 text-xs text-app-text-secondary opacity-80">
                {translations.lbl_max_advance_booking_help}
              </p>
            </div>
          </div>
        </div>
      ) : (
        /* EDIT FORM MODE */
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 pt-2">
          {/* Duration */}
          <div className="flex flex-col">
            <CustomSelect
              label={translations.lbl_appointment_duration}
              placeholder={translations.ph_select_duration}
              value={appointment_duration}
              options={DURATION_OPTIONS}
              on_change={(val) => {
                set_appointment_duration(val);
                on_mark_dirty();
              }}
            />
            <p className="mt-1.5 text-xs text-app-text-secondary">
              {translations.lbl_appointment_duration_help}
            </p>
          </div>

          {/* Advance Booking Limit */}
          <div className="flex flex-col">
            <CustomSelect
              label={translations.lbl_max_advance_booking}
              placeholder={translations.ph_select_advance_booking}
              value={max_advance_booking}
              options={ADVANCE_BOOKING_OPTIONS}
              on_change={(val) => {
                set_max_advance_booking(val);
                on_mark_dirty();
              }}
            />
            <p className="mt-1.5 text-xs text-app-text-secondary">
              {translations.lbl_max_advance_booking_help}
            </p>
          </div>
        </div>
      )}
    </div>
  );
}

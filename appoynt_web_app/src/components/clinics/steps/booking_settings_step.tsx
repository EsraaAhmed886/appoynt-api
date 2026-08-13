/*
 * File Name: booking_settings_step.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/context/language_context
 *   - @/components/clinics/custom_select
 *   - @/components/clinics/clinic_form_constants
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 13/08/2026]
 * File Description: Step 5 form view establishing appointment time slot length and advance booking window.
 */

"use client";

import CustomSelect from "../custom_select";
import { useTranslation } from "@/context/language_context";
import {
  DURATION_OPTIONS,
  ADVANCE_BOOKING_OPTIONS,
} from "../clinic_form_constants";

type BookingSettingsStepProps = {
  appointmentDuration: string;
  setAppointmentDuration: (val: string) => void;
  maxAdvanceBooking: string;
  setMaxAdvanceBooking: (val: string) => void;
  onMarkDirty: () => void;
};

export default function BookingSettingsStep({
  appointmentDuration,
  setAppointmentDuration,
  maxAdvanceBooking,
  setMaxAdvanceBooking,
  onMarkDirty,
}: BookingSettingsStepProps) {
  const { translations } = useTranslation();

  return (
    <div className="space-y-6">
      <div>
        <h3 className="text-lg font-semibold text-app-text-primary">
          {translations.modal_step_5}
        </h3>
        <p className="text-sm text-app-text-secondary">
          {translations.lbl_booking_settings_desc}
        </p>
      </div>

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2">
        {/* Appointment Duration */}
        <div className="flex flex-col">
          <CustomSelect
            label={translations.lbl_appointment_duration}
            placeholder={translations.ph_select_duration}
            value={appointmentDuration}
            options={DURATION_OPTIONS}
            on_change={(val) => {
              setAppointmentDuration(val);
              onMarkDirty();
            }}
          />
          <p className="mt-1.5 text-xs text-app-text-secondary">
            {translations.lbl_appointment_duration_help}
          </p>
        </div>

        {/* Maximum Advance Booking */}
        <div className="flex flex-col">
          <CustomSelect
            label={translations.lbl_max_advance_booking}
            placeholder={translations.ph_select_advance_booking}
            value={maxAdvanceBooking}
            options={ADVANCE_BOOKING_OPTIONS}
            on_change={(val) => {
              setMaxAdvanceBooking(val);
              onMarkDirty();
            }}
          />
          <p className="mt-1.5 text-xs text-app-text-secondary">
            {translations.lbl_max_advance_booking_help}
          </p>
        </div>
      </div>
    </div>
  );
}

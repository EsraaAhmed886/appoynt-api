import { Info } from "lucide-react";
import {
  LABEL_CLASS,
  INPUT_CLASS,
  DURATION_OPTIONS,
  ADVANCE_BOOKING_OPTIONS,
} from "../clinic_form_constants";
import { ChevronDown } from "lucide-react";

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
  return (
    <div className="space-y-6">
      <div>
        <h3 className="text-lg font-semibold text-app-text-primary">
          Booking Settings
        </h3>
        <p className="text-sm text-app-text-secondary">
          Set appointment duration and maximum advance booking period.
        </p>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        {/* Appointment Duration */}
        <div>
          <label className={LABEL_CLASS}>
            Appointment Duration <span className="text-red-500">*</span>
          </label>
          <select
            value={appointmentDuration}
            onChange={(e) => {
              setAppointmentDuration(e.target.value);
              onMarkDirty();
            }}
            className={`${INPUT_CLASS} mt-1`}
          >
            {DURATION_OPTIONS.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
          <div className="pointer-events-none absolute inset-y-0 right-0 ltr:right-0 rtl:left-0 rtl:right-auto flex items-center px-3 text-app-text-secondary">
            <ChevronDown size={18} />
          </div>
          <p className="mt-1 text-xs text-app-text-secondary">
            Select how long each appointment will be.
          </p>
        </div>

        {/* Maximum Advance Booking */}
        <div>
          <label className={LABEL_CLASS}>
            Maximum Advance Booking <span className="text-red-500">*</span>
          </label>
          <select
            value={maxAdvanceBooking}
            onChange={(e) => {
              setMaxAdvanceBooking(e.target.value);
              onMarkDirty();
            }}
            className={`${INPUT_CLASS} mt-1`}
          >
            {ADVANCE_BOOKING_OPTIONS.map((option) => (
              <option key={option} value={option}>
                {option}
              </option>
            ))}
          </select>
          <p className="mt-1 text-xs text-app-text-secondary">
            Select how far in advance patients can book.
          </p>
        </div>
      </div>
    </div>
  );
}

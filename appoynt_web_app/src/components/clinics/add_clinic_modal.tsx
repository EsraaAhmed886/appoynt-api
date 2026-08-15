/*
 * File Name: add_clinic_modal.tsx
 * Author: shimaa salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 *   - @/types/clinic
 *   - @/services/clinic.service
 *   - @/lib/validators/clinic_validator
 *   - @/components/clinics/*
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Multi-step modal component for adding a new clinic record with step navigation locks and centralized validation.
 */

"use client";

import { useEffect, useState } from "react";
import { X, Check } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import {
  Clinic,
  ClinicFormState,
  WorkingScheduleItem,
  BreakTimeItem,
  ReceptionistItem,
} from "@/types/clinic";
import SuccessModal from "@/components/common/success_modal";
import UnsavedChangesModal from "@/components/common/unsaved_changes_modal";
import ClinicInformationStep from "./steps/clinic_information_step";
import WorkingScheduleStep from "./steps/working_schedule_step";
import BreakTimesStep from "./steps/break_times_step";
import ReceptionistsStep from "./steps/receptionists_step";
import BookingSettingsStep from "./steps/booking_settings_step";

import { get_doctor_occupied_working_days } from "@/services/clinic.service";
import { CITIES_BY_GOVERNORATE, PHONE_REGEX } from "./clinic_form_constants";
import {
  validate_clinic_name,
  validate_phone,
  validate_governorate,
  validate_city,
  validate_address,
  validate_consultation_fee,
  is_step_valid,
} from "@/lib/validators/clinic_validator";

type AddClinicModalProps = {
  is_open: boolean;
  existing_clinics?: Clinic[];
  editing_clinic_id?: number | null;
  doctor_id?: string | number;
  on_close: () => void;
  on_add_clinic: (clinic: Clinic) => void;
};

const initial_form_state: ClinicFormState = {
  current_step: 1,
  doctor_id: "doc_1",
  clinic_name: "",
  clinic_name_error: "",
  phone: "",
  phone_error: "",
  governorate: "",
  governorate_error: "",
  city: "",
  city_error: "",
  address: "",
  address_error: "",
  consultation_fee: "",
  consultation_fee_error: "",
  working_days: [],
  working_days_error: "",
  status: "Active",
  schedule_list: [],
  break_list: [],
  assigned_receptionists: [],
  appointment_duration: "30 Minutes",
  max_advance_booking: "30 Days",
  is_dirty: false,
  is_success_open: false,
  is_unsaved_modal_open: false,
};

export default function AddClinicModal({
  is_open,
  existing_clinics = [],
  editing_clinic_id = null,
  doctor_id = "doc_1",
  on_close,
  on_add_clinic,
}: AddClinicModalProps) {
  const { translations } = useTranslation();
  const [form_state, set_form_state] = useState<ClinicFormState>({
    ...initial_form_state,
    doctor_id: doctor_id,
  });

  const doctor_occupied_days = get_doctor_occupied_working_days(
    form_state.doctor_id || doctor_id,
    editing_clinic_id,
  );

  const steps_labels = [
    translations.modal_step_1,
    translations.modal_step_2,
    translations.modal_step_3,
    translations.modal_step_4,
    translations.modal_step_5,
  ];

  useEffect(() => {
    if (is_open) {
      reset_form();
    } else {
      // Closed state
    }
  }, [is_open]);

  useEffect(() => {
    const handle_before_unload = (event: BeforeUnloadEvent) => {
      if (form_state.is_dirty) {
        event.preventDefault();
        event.returnValue = "";
      } else {
        // No action needed
      }
    };

    if (is_open && form_state.is_dirty) {
      window.addEventListener("beforeunload", handle_before_unload);
    }

    return () => {
      window.removeEventListener("beforeunload", handle_before_unload);
    };
  }, [is_open, form_state.is_dirty]);

  const update_field = <K extends keyof ClinicFormState>(
    field: K,
    value: ClinicFormState[K],
  ) => {
    set_form_state((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const reset_form = () => {
    set_form_state({
      ...initial_form_state,
      doctor_id: doctor_id,
    });
  };

  const mark_as_dirty = () => {
    if (!form_state.is_dirty) {
      update_field("is_dirty", true);
    } else {
      // Already dirty
    }
  };

  const validate_current_step_fields = (): boolean => {
    const step = form_state.current_step;

    if (1 === step) {
      const name_err = validate_clinic_name(form_state.clinic_name);
      const phone_err = validate_phone(
        form_state.phone,
        existing_clinics,
        editing_clinic_id,
      );
      const gov_err = validate_governorate(form_state.governorate);
      const city_err = validate_city(form_state.city);
      const address_err = validate_address(form_state.address);
      const fee_err = validate_consultation_fee(form_state.consultation_fee);

      update_field("clinic_name_error", name_err || "");
      update_field("phone_error", phone_err || "");
      update_field("governorate_error", gov_err || "");
      update_field("city_error", city_err || "");
      update_field("address_error", address_err || "");
      update_field("consultation_fee_error", fee_err || "");

      return (
        null === name_err &&
        null === phone_err &&
        null === gov_err &&
        null === city_err &&
        null === address_err &&
        null === fee_err
      );
    } else if (2 === step) {
      if (0 === form_state.schedule_list.length) {
        update_field("working_days_error", "msg_no_working_days");
        return false;
      } else {
        update_field("working_days_error", "");
        return true;
      }
    } else {
      return true;
    }
  };

  const next_step = () => {
    const is_valid = validate_current_step_fields();

    if (!is_valid) {
      return;
    } else {
      if (form_state.current_step < 5) {
        update_field("current_step", form_state.current_step + 1);
      } else {
        // At final step
      }
    }
  };

  const previous_step = () => {
    if (form_state.current_step > 1) {
      update_field("current_step", form_state.current_step - 1);
    } else {
      // At first step
    }
  };

  const handle_close = () => {
    if (form_state.is_dirty) {
      update_field("is_unsaved_modal_open", true);
    } else {
      reset_form();
      on_close();
    }
  };

  const handle_save = () => {
    const is_step1_ok = validate_current_step_fields();
    if (!is_step1_ok) {
      update_field("current_step", 1);
      return;
    } else if (0 === form_state.schedule_list.length) {
      update_field("current_step", 2);
      return;
    } else {
      const is_step3_ok = is_step_valid(
        3,
        form_state,
        existing_clinics,
        editing_clinic_id,
        doctor_occupied_days,
      );

      if (!is_step3_ok) {
        update_field("current_step", 3);
        return;
      } else {
        const fee_text = `${form_state.consultation_fee} EGP`;
        const schedule_text = form_state.schedule_list
          .map((s) => s.day)
          .join(", ");

        const new_clinic: Clinic = {
          id: Date.now(),
          doctor_id: form_state.doctor_id || doctor_id,
          name: form_state.clinic_name,
          location: `${form_state.city}, ${form_state.governorate}`,
          phone: form_state.phone,
          consultation_fee: fee_text,
          consultationFee: fee_text,
          working_days: schedule_text || "Sat - Wed",
          workingDays: schedule_text || "Sat - Wed",
          status: form_state.status,
          schedule_list: form_state.schedule_list,
          break_list: form_state.break_list,
          assigned_receptionists: form_state.assigned_receptionists,
          appointment_duration: form_state.appointment_duration,
          max_advance_booking: form_state.max_advance_booking,
        };

        on_add_clinic(new_clinic);
        set_form_state((prev) => ({
          ...prev,
          is_dirty: false,
          is_success_open: true,
        }));
      }
    }
  };

  const available_cities = form_state.governorate
    ? CITIES_BY_GOVERNORATE[form_state.governorate] || []
    : [];

  const clinic_form_props = {
    clinicName: form_state.clinic_name,
    clinicNameError: form_state.clinic_name_error,
    phone: form_state.phone,
    phoneError: form_state.phone_error,
    governorate: form_state.governorate,
    governorateError: form_state.governorate_error,
    city: form_state.city,
    cityError: form_state.city_error,
    address: form_state.address,
    addressError: form_state.address_error,
    consultationFee: form_state.consultation_fee,
    consultationFeeError: form_state.consultation_fee_error,
    workingDays: form_state.working_days,
    workingDaysError: form_state.working_days_error,
    status: form_state.status,
    availableCities: available_cities,
  };

  const clinic_actions_props = {
    setClinicName: (val: string) => update_field("clinic_name", val),
    setClinicNameError: (val: string) => update_field("clinic_name_error", val),
    setPhone: (val: string) => update_field("phone", val),
    setPhoneError: (val: string) => update_field("phone_error", val),
    setGovernorate: (val: string) => update_field("governorate", val),
    setGovernorateError: (val: string) =>
      update_field("governorate_error", val),
    setCity: (val: string) => update_field("city", val),
    setCityError: (val: string) => update_field("city_error", val),
    setAddress: (val: string) => update_field("address", val),
    setAddressError: (val: string) => update_field("address_error", val),
    setConsultationFee: (val: string) => update_field("consultation_fee", val),
    setConsultationFeeError: (val: string) =>
      update_field("consultation_fee_error", val),
    setStatus: (val: string) => update_field("status", val),
    markAsDirty: mark_as_dirty,
    getInputBorderClass: (has_error: boolean) =>
      has_error
        ? "border-red-500 ring-2 ring-red-200"
        : "border-app-border focus:border-app-primary focus:ring-2 focus:ring-app-primary/20",
  };

  const current_step_is_valid = is_step_valid(
    form_state.current_step,
    form_state,
    existing_clinics,
    editing_clinic_id,
    doctor_occupied_days,
  );

  if (false === is_open) {
    return null;
  } else {
    return (
      <>
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4"
          onClick={handle_close}
        >
          <div
            className="max-h-[90vh] w-full max-w-[640px] overflow-y-auto rounded-2xl bg-app-surface text-app-text-primary p-6 shadow-2xl transition-colors border border-app-border"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Header */}
            <div className="flex items-center justify-between pb-6 border-b border-app-border mb-6">
              <h2 className="text-xl font-bold text-app-text-primary">
                {translations.modal_add_clinic_title}
              </h2>

              <button
                type="button"
                onClick={handle_close}
                aria-label="Close"
                className="rounded-full p-1.5 text-app-text-secondary hover:bg-app-input_fill hover:text-app-text-primary transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            {/* Stepper */}
            <div className="mb-10 flex items-center justify-between px-2">
              {steps_labels.map((step_name, index) => {
                const step_number = index + 1;
                const is_active = form_state.current_step === step_number;
                const is_completed = form_state.current_step > step_number;

                return (
                  <div
                    key={step_name}
                    className="flex flex-1 items-center last:flex-none"
                  >
                    <div className="flex flex-col items-center relative">
                      <div
                        className={`
                          flex h-8 w-8 shrink-0 items-center justify-center rounded-full text-xs font-semibold transition-all
                          ${
                            is_completed
                              ? "bg-emerald-600 text-white"
                              : is_active
                                ? "bg-app-primary text-white"
                                : "border border-app-border bg-app-surface text-app-text-secondary"
                          }
                        `}
                      >
                        {is_completed ? (
                          <Check size={16} strokeWidth={2.5} />
                        ) : (
                          step_number
                        )}
                      </div>

                      <span
                        className={`
                          hidden sm:block absolute top-9 whitespace-nowrap text-[11px] font-medium transition-colors
                          ${
                            is_active
                              ? "font-bold text-app-primary"
                              : is_completed
                                ? "text-app-text-primary"
                                : "text-app-text-secondary opacity-70"
                          }
                        `}
                      >
                        {step_name}
                      </span>
                    </div>

                    {index < steps_labels.length - 1 && (
                      <div className="mx-2.5 h-[1px] flex-1 bg-app-border" />
                    )}
                  </div>
                );
              })}
            </div>

            <form
              className="space-y-4 pt-4"
              onSubmit={(e) => {
                e.preventDefault();
                if (5 === form_state.current_step) {
                  handle_save();
                } else {
                  next_step();
                }
              }}
            >
              {/* Step 1 */}
              {1 === form_state.current_step && (
                <ClinicInformationStep
                  form={clinic_form_props}
                  actions={clinic_actions_props}
                  existingClinics={existing_clinics}
                  editingClinicId={editing_clinic_id}
                />
              )}

              {/* Step 2 */}
              {2 === form_state.current_step && (
                <WorkingScheduleStep
                  scheduleList={form_state.schedule_list}
                  doctorOccupiedDays={doctor_occupied_days}
                  onAddSchedule={(item) => {
                    update_field("schedule_list", [
                      ...form_state.schedule_list,
                      item,
                    ]);
                    update_field("working_days_error", "");
                    mark_as_dirty();
                  }}
                  onEditSchedule={(index, updated_item) => {
                    const next_list = form_state.schedule_list.map((it, i) =>
                      i === index ? updated_item : it,
                    );
                    update_field("schedule_list", next_list);
                    mark_as_dirty();
                  }}
                  onDeleteSchedule={(index) => {
                    const target_item = form_state.schedule_list[index];
                    const deleted_day = target_item ? target_item.day : "";
                    const next_schedules = form_state.schedule_list.filter(
                      (_, i) => i !== index,
                    );
                    const next_breaks = form_state.break_list.filter(
                      (b) => b.day !== deleted_day,
                    );
                    update_field("schedule_list", next_schedules);
                    update_field("break_list", next_breaks);
                    mark_as_dirty();
                  }}
                />
              )}

              {/* Step 3 */}
              {3 === form_state.current_step && (
                <BreakTimesStep
                  breakList={form_state.break_list}
                  availableWorkingDays={form_state.schedule_list.map(
                    (s) => s.day,
                  )}
                  scheduleList={form_state.schedule_list}
                  onAddBreak={(item) => {
                    update_field("break_list", [
                      ...form_state.break_list,
                      item,
                    ]);
                    mark_as_dirty();
                  }}
                  onEditBreak={(index, updated_item) => {
                    const next_list = form_state.break_list.map((it, i) =>
                      i === index ? updated_item : it,
                    );
                    update_field("break_list", next_list);
                    mark_as_dirty();
                  }}
                  onDeleteBreak={(index) => {
                    const next_list = form_state.break_list.filter(
                      (_, i) => i !== index,
                    );
                    update_field("break_list", next_list);
                    mark_as_dirty();
                  }}
                />
              )}

              {/* Step 4 */}
              {4 === form_state.current_step && (
                <ReceptionistsStep
                  assignedReceptionists={form_state.assigned_receptionists}
                  onUpdateAssigned={(new_list) => {
                    update_field("assigned_receptionists", new_list);
                    mark_as_dirty();
                  }}
                />
              )}

              {/* Step 5 */}
              {5 === form_state.current_step && (
                <BookingSettingsStep
                  appointmentDuration={form_state.appointment_duration}
                  setAppointmentDuration={(val) => {
                    update_field("appointment_duration", val);
                    mark_as_dirty();
                  }}
                  maxAdvanceBooking={form_state.max_advance_booking}
                  setMaxAdvanceBooking={(val) => {
                    update_field("max_advance_booking", val);
                    mark_as_dirty();
                  }}
                  onMarkDirty={mark_as_dirty}
                />
              )}

              {/* Footer Controls */}
              <div className="mt-8 flex items-center justify-between border-t border-app-border pt-5">
                <div>
                  {form_state.current_step > 1 && (
                    <button
                      type="button"
                      onClick={previous_step}
                      className="rounded-xl border border-app-border bg-app-surface px-5 py-2 text-sm font-medium text-app-text-primary hover:border-app-primary/50 hover:text-app-primary transition-all"
                    >
                      {translations.btn_back}
                    </button>
                  )}
                </div>

                <div className="flex items-center gap-3">
                  <button
                    type="button"
                    onClick={handle_close}
                    className="rounded-xl border border-app-border bg-app-surface px-5 py-2 text-sm font-medium text-app-text-primary hover:border-app-primary/50 hover:text-app-primary transition-all"
                  >
                    {translations.btn_cancel}
                  </button>

                  <button
                    type="submit"
                    disabled={!current_step_is_valid}
                    className="rounded-xl bg-app-primary px-6 py-2 text-sm font-medium text-white shadow-md hover:opacity-90 transition-all disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:opacity-50"
                  >
                    {5 === form_state.current_step
                      ? translations.btn_save_changes
                      : translations.btn_next}
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>

        <UnsavedChangesModal
          is_open={form_state.is_unsaved_modal_open}
          on_stay={() => update_field("is_unsaved_modal_open", false)}
          on_leave={() => {
            update_field("is_unsaved_modal_open", false);
            reset_form();
            on_close();
          }}
        />

        <SuccessModal
          is_open={form_state.is_success_open}
          on_close={() => {
            update_field("is_success_open", false);
            reset_form();
            on_close();
          }}
        />
      </>
    );
  }
}

/**
 * File Name : use_clinic_form.ts
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, @/types/clinic, @/services/clinic.service, @/lib/validators/clinic_validator
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-09-01
 * Description : Custom hook encapsulating clinic form state, read-only/edit mode, dirty tracking, validation, optimistic locking, and save/cancel actions.
 */

"use client";

import { useEffect, useState, useCallback } from "react";
import {
  Clinic,
  WorkingScheduleItem,
  BreakTimeItem,
  ReceptionistItem,
} from "@/types/clinic";
import {
  get_clinic_by_id,
  update_clinic,
  get_clinics,
  get_doctor_occupied_working_days,
  get_doctor_other_clinic_schedules,
  get_doctor_existing_schedules,
} from "@/services/clinic.service";
import { do_time_intervals_overlap } from "@/lib/utils/time_utils";
import {
  validate_clinic_name,
  validate_phone,
  validate_governorate,
  validate_city,
  validate_address,
  validate_consultation_fee,
  validate_working_schedule,
  validate_assigned_receptionists,
} from "@/lib/validators/clinic_validator";

export function use_clinic_form(clinic_id: number) {
  const [is_loaded, set_is_loaded] = useState(false);
  const [is_edit_mode, set_is_edit_mode] = useState(false);
  const [is_dirty, set_is_dirty] = useState(false);
  const [is_saving, set_is_saving] = useState(false);

  const [is_unsaved_modal_open, set_is_unsaved_modal_open] = useState(false);
  const [is_conflict_modal_open, set_is_conflict_modal_open] = useState(false);
  const [is_success_modal_open, set_is_success_modal_open] = useState(false);

  const [original_clinic, set_original_clinic] = useState<Clinic | null>(null);

  // Form Fields - Strictly initialized to empty without hardcoded fallback values
  const [doctor_id, set_doctor_id] = useState<string | number>("doc_1");
  const [clinic_name, set_clinic_name] = useState("");
  const [clinic_name_error, set_clinic_name_error] = useState("");
  const [phone, set_phone] = useState("");
  const [phone_error, set_phone_error] = useState("");
  const [governorate, set_governorate] = useState("");
  const [governorate_error, set_governorate_error] = useState("");
  const [city, set_city] = useState("");
  const [city_error, set_city_error] = useState("");
  const [address, set_address] = useState("");
  const [address_error, set_address_error] = useState("");
  const [consultation_fee, set_consultation_fee] = useState("");
  const [consultation_fee_error, set_consultation_fee_error] = useState("");
  const [status, set_status] = useState("Active");

  const [schedule_list, set_schedule_list] = useState<WorkingScheduleItem[]>([]);
  const [schedule_error, set_schedule_error] = useState("");
  const [break_list, set_break_list] = useState<BreakTimeItem[]>([]);
  const [assigned_receptionists, set_assigned_receptionists] = useState<ReceptionistItem[]>([]);
  const [receptionists_error, set_receptionists_error] = useState("");
  const [appointment_duration, set_appointment_duration] = useState("");
  const [max_advance_booking, set_max_advance_booking] = useState("");

  // Independent Card Editing States
  const [is_editing_info, set_is_editing_info] = useState(false);
  const [is_editing_schedule, set_is_editing_schedule] = useState(false);
  const [is_editing_breaks, set_is_editing_breaks] = useState(false);
  const [is_editing_receptionists, set_is_editing_receptionists] = useState(false);
  const [is_editing_booking, set_is_editing_booking] = useState(false);

  // Load clinic entity by ID on mount
  useEffect(() => {
    const existing = get_clinic_by_id(clinic_id);
    if (existing) {
      set_original_clinic(existing);
      populate_from_entity(existing);
    } else {
      // Clear fields if clinic not found
      reset_empty_form();
    }
    set_is_loaded(true);
  }, [clinic_id]);

  const reset_empty_form = () => {
    set_clinic_name("");
    set_phone("");
    set_governorate("");
    set_city("");
    set_address("");
    set_consultation_fee("");
    set_status("Active");
    set_schedule_list([]);
    set_break_list([]);
    set_assigned_receptionists([]);
    set_appointment_duration("");
    set_max_advance_booking("");
    set_is_dirty(false);
    set_is_editing_info(false);
    set_is_editing_schedule(false);
    set_is_editing_breaks(false);
    set_is_editing_receptionists(false);
    set_is_editing_booking(false);
  };

  // Population helper: strictly set stored data or empty values without fallback defaults
  const populate_from_entity = (entity: Clinic) => {
    set_doctor_id(entity.doctor_id || "doc_1");
    set_clinic_name(entity.name || "");
    set_phone(entity.phone || "");

    if (entity.location) {
      const parts = entity.location.split(",").map((s) => s.trim());
      if (parts.length >= 3) {
        set_governorate(parts[0]);
        set_city(parts[1]);
        set_address(entity.address || parts.slice(2).join(", "));
      } else if (parts.length === 2) {
        set_governorate(parts[0]);
        set_city(parts[1]);
        set_address(entity.address || "");
      } else {
        set_governorate("");
        set_city("");
        set_address(entity.address || entity.location);
      }
    } else {
      set_governorate("");
      set_city("");
      set_address(entity.address || "");
    }

    const fee_val = (entity.consultation_fee || entity.consultationFee || "").replace(
      /\D/g,
      "",
    );
    set_consultation_fee(fee_val);
    set_status(entity.status || "Active");

    set_schedule_list(entity.schedule_list || []);
    set_break_list(entity.break_list || []);
    set_assigned_receptionists(entity.assigned_receptionists || []);
    set_appointment_duration(entity.appointment_duration || "");
    set_max_advance_booking(entity.max_advance_booking || "");

    set_is_dirty(false);
  };

  // Check if any card is dirty
  const is_any_card_editing =
    is_editing_info ||
    is_editing_schedule ||
    is_editing_breaks ||
    is_editing_receptionists ||
    is_editing_booking;

  // Browser reload/navigation warning when dirty
  useEffect(() => {
    const handle_before_unload = (e: BeforeUnloadEvent) => {
      if (is_dirty || is_any_card_editing) {
        e.preventDefault();
        e.returnValue = "";
      } else {
        // No action needed
      }
    };
    if (is_dirty || is_any_card_editing) {
      window.addEventListener("beforeunload", handle_before_unload);
    } else {
      // No action needed
    }
    return () => {
      window.removeEventListener("beforeunload", handle_before_unload);
    };
  }, [is_dirty, is_any_card_editing]);

  const mark_as_dirty = useCallback(() => {
    if (!is_dirty) {
      set_is_dirty(true);
    } else {
      // No action needed
    }
  }, [is_dirty]);

  // Card specific edit mode toggles
  const toggle_edit_info = useCallback(() => {
    set_is_editing_info((prev) => !prev);
  }, []);

  const toggle_edit_schedule = useCallback(() => {
    set_is_editing_schedule((prev) => !prev);
  }, []);

  const toggle_edit_breaks = useCallback(() => {
    set_is_editing_breaks((prev) => !prev);
  }, []);

  const toggle_edit_receptionists = useCallback(() => {
    set_is_editing_receptionists((prev) => !prev);
  }, []);

  const toggle_edit_booking = useCallback(() => {
    set_is_editing_booking((prev) => !prev);
  }, []);

  // Card specific cancel handlers (reverts ONLY that card's values)
  const cancel_info = useCallback(() => {
    if (original_clinic) {
      set_clinic_name(original_clinic.name || "");
      set_phone(original_clinic.phone || "");

      if (original_clinic.location) {
        const parts = original_clinic.location.split(",").map((s) => s.trim());
        if (parts.length >= 3) {
          set_governorate(parts[0]);
          set_city(parts[1]);
          set_address(parts.slice(2).join(", "));
        } else if (parts.length === 2) {
          set_governorate(parts[0]);
          set_city(parts[1]);
          set_address("");
        } else {
          set_governorate("");
          set_city("");
          set_address(original_clinic.location);
        }
      } else {
        set_governorate("");
        set_city("");
        set_address("");
      }

      const fee_val = (
        original_clinic.consultation_fee ||
        original_clinic.consultationFee ||
        ""
      ).replace(/\D/g, "");
      set_consultation_fee(fee_val);
      set_status(original_clinic.status || "Active");
    } else {
      // No action needed
    }
    set_clinic_name_error("");
    set_phone_error("");
    set_governorate_error("");
    set_city_error("");
    set_address_error("");
    set_consultation_fee_error("");
    set_is_editing_info(false);
  }, [original_clinic]);

  const cancel_schedule = useCallback(() => {
    if (original_clinic) {
      set_schedule_list(original_clinic.schedule_list || []);
    } else {
      // No action needed
    }
    set_schedule_error("");
    set_is_editing_schedule(false);
  }, [original_clinic]);

  const cancel_breaks = useCallback(() => {
    if (original_clinic) {
      set_break_list(original_clinic.break_list || []);
    } else {
      // No action needed
    }
    set_is_editing_breaks(false);
  }, [original_clinic]);

  const cancel_receptionists = useCallback(() => {
    if (original_clinic) {
      set_assigned_receptionists(original_clinic.assigned_receptionists || []);
    } else {
      // No action needed
    }
    set_receptionists_error("");
    set_is_editing_receptionists(false);
  }, [original_clinic]);

  const cancel_booking = useCallback(() => {
    if (original_clinic) {
      set_appointment_duration(original_clinic.appointment_duration || "");
      set_max_advance_booking(original_clinic.max_advance_booking || "");
    } else {
      // No action needed
    }
    set_is_editing_booking(false);
  }, [original_clinic]);

  const handle_cancel = useCallback(() => {
    if (is_dirty || is_any_card_editing) {
      set_is_unsaved_modal_open(true);
    } else {
      set_is_edit_mode(false);
    }
  }, [is_dirty, is_any_card_editing]);

  const confirm_discard_changes = useCallback(() => {
    if (original_clinic) {
      populate_from_entity(original_clinic);
    } else {
      // No action needed
    }
    set_is_dirty(false);
    set_is_edit_mode(false);
    set_is_editing_info(false);
    set_is_editing_schedule(false);
    set_is_editing_breaks(false);
    set_is_editing_receptionists(false);
    set_is_editing_booking(false);
    set_is_unsaved_modal_open(false);
  }, [original_clinic]);

  const validate_info_fields = useCallback((): boolean => {
    const existing_clinics = get_clinics();
    const err_name = validate_clinic_name(clinic_name);
    const err_phone = validate_phone(phone, existing_clinics, clinic_id);
    const err_gov = validate_governorate(governorate);
    const err_city = validate_city(city);
    const err_address = validate_address(address);
    const err_fee = validate_consultation_fee(consultation_fee);

    set_clinic_name_error(err_name || "");
    set_phone_error(err_phone || "");
    set_governorate_error(err_gov || "");
    set_city_error(err_city || "");
    set_address_error(err_address || "");
    set_consultation_fee_error(err_fee || "");

    return (
      null === err_name &&
      null === err_phone &&
      null === err_gov &&
      null === err_city &&
      null === err_address &&
      null === err_fee
    );
  }, [clinic_name, phone, governorate, city, address, consultation_fee, clinic_id]);

  const build_current_clinic_entity = useCallback((): Clinic => {
    const fee_text = consultation_fee ? `${consultation_fee} EGP` : "";
    const loc_text = [governorate, city, address].filter(Boolean).join(", ");
    const schedule_text = schedule_list.map((s) => s.day).join(", ");
    return {
      id: clinic_id,
      doctor_id: doctor_id,
      name: clinic_name,
      location: loc_text,
      address: address,
      phone: phone,
      consultation_fee: fee_text,
      consultationFee: fee_text,
      working_days: schedule_text,
      workingDays: schedule_text,
      status: status,
      schedule_list: schedule_list,
      break_list: break_list,
      assigned_receptionists: assigned_receptionists,
      appointment_duration: appointment_duration,
      max_advance_booking: max_advance_booking,
    };
  }, [
    clinic_id,
    doctor_id,
    clinic_name,
    governorate,
    city,
    address,
    phone,
    consultation_fee,
    status,
    schedule_list,
    break_list,
    assigned_receptionists,
    appointment_duration,
    max_advance_booking,
  ]);

  // Save Info Card
  const save_info_card = useCallback(() => {
    const is_valid = validate_info_fields();
    if (!is_valid) {
      return false;
    } else {
      // No action needed
    }
    const updated_entity = build_current_clinic_entity();
    update_clinic(updated_entity);
    set_original_clinic(updated_entity);
    set_is_editing_info(false);
    set_is_dirty(false);
    set_is_success_modal_open(true);
    return true;
  }, [validate_info_fields, build_current_clinic_entity]);

  // Save Schedule Card
  const save_schedule_card = useCallback(() => {
    const err_schedule = validate_working_schedule(schedule_list);
    if (err_schedule) {
      set_schedule_error(err_schedule);
      return false;
    } else {
      set_schedule_error("");
    }

    const other_schedules = get_doctor_other_clinic_schedules(doctor_id, clinic_id);
    const has_conflict = schedule_list.some((s) => {
      return other_schedules.some((other) => {
        if (other.day === s.day) {
          return do_time_intervals_overlap(s.startTime, s.endTime, other.startTime, other.endTime);
        } else {
          return false;
        }
      });
    });

    if (has_conflict) {
      return false;
    } else {
      // No conflict detected, proceed to save
    }

    const updated_entity = build_current_clinic_entity();
    update_clinic(updated_entity);
    set_original_clinic(updated_entity);
    set_is_editing_schedule(false);
    set_is_dirty(false);
    set_is_success_modal_open(true);
    return true;
  }, [build_current_clinic_entity, doctor_id, clinic_id, schedule_list]);

  // Save Breaks Card
  const save_breaks_card = useCallback(() => {
    const updated_entity = build_current_clinic_entity();
    update_clinic(updated_entity);
    set_original_clinic(updated_entity);
    set_is_editing_breaks(false);
    set_is_dirty(false);
    set_is_success_modal_open(true);
  }, [build_current_clinic_entity]);

  // Save Receptionists Card
  const save_receptionists_card = useCallback(() => {
    const err_receptionists = validate_assigned_receptionists(assigned_receptionists);
    if (err_receptionists) {
      set_receptionists_error(err_receptionists);
      return false;
    } else {
      set_receptionists_error("");
    }

    const updated_entity = build_current_clinic_entity();
    update_clinic(updated_entity);
    set_original_clinic(updated_entity);
    set_is_editing_receptionists(false);
    set_is_dirty(false);
    set_is_success_modal_open(true);
    return true;
  }, [build_current_clinic_entity, assigned_receptionists]);

  // Save Booking Card
  const save_booking_card = useCallback(() => {
    const updated_entity = build_current_clinic_entity();
    update_clinic(updated_entity);
    set_original_clinic(updated_entity);
    set_is_editing_booking(false);
    set_is_dirty(false);
    set_is_success_modal_open(true);
  }, [build_current_clinic_entity]);

  const execute_save = useCallback(() => {
    set_is_saving(true);

    const updated_entity = build_current_clinic_entity();
    update_clinic(updated_entity);
    set_original_clinic(updated_entity);
    set_is_saving(false);
    set_is_dirty(false);
    set_is_edit_mode(false);
    set_is_success_modal_open(true);
  }, [
    clinic_id,
    doctor_id,
    clinic_name,
    governorate,
    city,
    address,
    phone,
    consultation_fee,
    status,
    schedule_list,
    break_list,
    assigned_receptionists,
    appointment_duration,
    max_advance_booking,
  ]);

  const handle_save = useCallback(() => {
    const is_valid = validate_info_fields();
    if (!is_valid) {
      return;
    } else {
      // No action needed
    }

    const err_schedule = validate_working_schedule(schedule_list);
    if (err_schedule) {
      set_schedule_error(err_schedule);
      return;
    } else {
      set_schedule_error("");
    }

    const err_receptionists = validate_assigned_receptionists(assigned_receptionists);
    if (err_receptionists) {
      set_receptionists_error(err_receptionists);
      return;
    } else {
      set_receptionists_error("");
    }

    // Check if schedule changes impact existing appointments (trigger conflict dialog)
    const schedule_changed =
      JSON.stringify(original_clinic?.schedule_list || []) !==
      JSON.stringify(schedule_list);

    if (schedule_changed && (original_clinic?.schedule_list?.length || 0) > 0) {
      set_is_conflict_modal_open(true);
    } else {
      execute_save();
    }
  }, [validate_info_fields, original_clinic, schedule_list, execute_save]);

  const doctor_occupied_days = get_doctor_occupied_working_days(
    doctor_id,
    clinic_id,
  );

  const doctor_other_schedules = get_doctor_other_clinic_schedules(
    doctor_id,
    clinic_id,
  );

  // Card-specific Dirty Checks against original saved values
  const orig_info_location_parts = original_clinic?.location
    ? original_clinic.location.split(",").map((s) => s.trim())
    : [];
  const orig_gov =
    orig_info_location_parts.length >= 3
      ? orig_info_location_parts[0]
      : orig_info_location_parts.length === 2
      ? orig_info_location_parts[0]
      : "";
  const orig_city =
    orig_info_location_parts.length >= 3
      ? orig_info_location_parts[1]
      : orig_info_location_parts.length === 2
      ? orig_info_location_parts[1]
      : "";
  const orig_address =
    orig_info_location_parts.length >= 3
      ? orig_info_location_parts.slice(2).join(", ")
      : orig_info_location_parts.length === 1
      ? original_clinic?.location || ""
      : "";
  const orig_fee = (
    original_clinic?.consultation_fee ||
    original_clinic?.consultationFee ||
    ""
  ).replace(/\D/g, "");

  const is_info_dirty =
    (original_clinic?.name || "") !== clinic_name ||
    (original_clinic?.phone || "") !== phone ||
    orig_gov !== governorate ||
    orig_city !== city ||
    orig_address !== address ||
    orig_fee !== consultation_fee ||
    (original_clinic?.status || "Active") !== status;

  const is_schedule_dirty =
    JSON.stringify(original_clinic?.schedule_list || []) !==
    JSON.stringify(schedule_list);

  const is_breaks_dirty =
    JSON.stringify(original_clinic?.break_list || []) !==
    JSON.stringify(break_list);

  const is_receptionists_dirty =
    JSON.stringify(original_clinic?.assigned_receptionists || []) !==
    JSON.stringify(assigned_receptionists);

  const is_booking_dirty =
    (original_clinic?.appointment_duration || "") !== appointment_duration ||
    (original_clinic?.max_advance_booking || "") !== max_advance_booking;

  const is_any_card_dirty =
    is_info_dirty ||
    is_schedule_dirty ||
    is_breaks_dirty ||
    is_receptionists_dirty ||
    is_booking_dirty;

  return {
    is_loaded,
    is_edit_mode,
    is_dirty: is_any_card_dirty,
    is_saving,
    is_unsaved_modal_open,
    is_conflict_modal_open,
    is_success_modal_open,
    doctor_occupied_days,
    doctor_other_schedules,
    doctor_existing_schedules: doctor_other_schedules,
    // Independent Card Editing States
    is_editing_info,
    is_editing_schedule,
    is_editing_breaks,
    is_editing_receptionists,
    is_editing_booking,
    // Independent Card Dirty Booleans
    is_info_dirty,
    is_schedule_dirty,
    is_breaks_dirty,
    is_receptionists_dirty,
    is_booking_dirty,
    // Form fields
    form: {
      clinicName: clinic_name,
      clinicNameError: clinic_name_error,
      phone: phone,
      phoneError: phone_error,
      governorate: governorate,
      governorateError: governorate_error,
      city: city,
      cityError: city_error,
      address: address,
      addressError: address_error,
      consultationFee: consultation_fee,
      consultationFeeError: consultation_fee_error,
      status: status,
      scheduleList: schedule_list,
      scheduleError: schedule_error,
      breakList: break_list,
      assignedReceptionists: assigned_receptionists,
      receptionistsError: receptionists_error,
      appointmentDuration: appointment_duration,
      maxAdvanceBooking: max_advance_booking,
    },
    // Action handlers
    actions: {
      toggleEditMode: toggle_edit_info,
      toggleEditInfo: toggle_edit_info,
      toggleEditSchedule: toggle_edit_schedule,
      toggleEditBreaks: toggle_edit_breaks,
      toggleEditReceptionists: toggle_edit_receptionists,
      toggleEditBooking: toggle_edit_booking,
      cancelInfo: cancel_info,
      cancelSchedule: cancel_schedule,
      cancelBreaks: cancel_breaks,
      cancelReceptionists: cancel_receptionists,
      cancelBooking: cancel_booking,
      saveInfoCard: save_info_card,
      saveScheduleCard: save_schedule_card,
      saveBreaksCard: save_breaks_card,
      saveReceptionistsCard: save_receptionists_card,
      saveBookingCard: save_booking_card,
      markAsDirty: mark_as_dirty,
      setClinicName: set_clinic_name,
      setClinicNameError: set_clinic_name_error,
      setPhone: set_phone,
      setPhoneError: set_phone_error,
      setGovernorate: set_governorate,
      setGovernorateError: set_governorate_error,
      setCity: set_city,
      setCityError: set_city_error,
      setAddress: set_address,
      setAddressError: set_address_error,
      setConsultationFee: set_consultation_fee,
      setConsultationFeeError: set_consultation_fee_error,
      setStatus: set_status,
      setScheduleList: (list: WorkingScheduleItem[]) => {
        set_schedule_list(list);
        mark_as_dirty();
      },
      setBreakList: (list: BreakTimeItem[]) => {
        set_break_list(list);
        mark_as_dirty();
      },
      setAssignedReceptionists: (list: ReceptionistItem[]) => {
        set_assigned_receptionists(list);
        if (list.length > 0) {
          set_receptionists_error("");
        } else {
          // No action needed
        }
        mark_as_dirty();
      },
      setAppointmentDuration: (val: string) => {
        set_appointment_duration(val);
        mark_as_dirty();
      },
      setMaxAdvanceBooking: (val: string) => {
        set_max_advance_booking(val);
        mark_as_dirty();
      },
      addSchedule: (item: WorkingScheduleItem) => {
        set_schedule_list((prev) => [...prev, item]);
        set_schedule_error("");
        mark_as_dirty();
      },
      editSchedule: (index: number, item: WorkingScheduleItem) => {
        set_schedule_list((prev) => prev.map((it, i) => (i === index ? item : it)));
        mark_as_dirty();
      },
      deleteSchedule: (index: number) => {
        const target = schedule_list[index];
        const deleted_day = target ? target.day : "";
        set_schedule_list((prev) => prev.filter((_, i) => i !== index));
        // Auto-cleanup orphan break times
        if (deleted_day) {
          set_break_list((prev) => prev.filter((b) => b.day !== deleted_day));
        } else {
          // No action needed
        }
        mark_as_dirty();
      },
      addBreak: (item: BreakTimeItem) => {
        set_break_list((prev) => [...prev, item]);
        mark_as_dirty();
      },
      editBreak: (index: number, item: BreakTimeItem) => {
        set_break_list((prev) => prev.map((it, i) => (i === index ? item : it)));
        mark_as_dirty();
      },
      deleteBreak: (index: number) => {
        set_break_list((prev) => prev.filter((_, i) => i !== index));
        mark_as_dirty();
      },
      handleSave: handle_save,
      handleCancel: handle_cancel,
      confirmDiscardChanges: confirm_discard_changes,
      executeSave: execute_save,
      openUnsavedModal: () => set_is_unsaved_modal_open(true),
      closeUnsavedModal: () => set_is_unsaved_modal_open(false),
      closeConflictModal: () => set_is_conflict_modal_open(false),
      closeSuccessModal: () => set_is_success_modal_open(false),
    },
  };
}

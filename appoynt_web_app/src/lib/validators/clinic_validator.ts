/**
 * File Name: clinic_validator.ts
 * Author: shimaa salah
 * Created Date: 05/07/2026
 * Version: v1.3.0
 * Dependencies:
 *   - @/types/clinic
 *   - @/lib/utils/time_utils
 *   - @/lib/utils/phone_utils
 * Contributors: shimaa salah
 * Last Modified: shimaa salah - 01/09/2026
 * Description: Pure validation engine returning localization keys for dynamic language resolution in UI components.
 */

import { Clinic, WorkingScheduleItem, BreakTimeItem, ReceptionistItem } from "@/types/clinic";
import { get_clinics } from "@/services/clinic.service";
import {
  parse_time_to_minutes,
  is_start_before_end,
  is_same_time,
  is_interval_within_bounds,
  do_time_intervals_overlap,
} from "@/lib/utils/time_utils";
import {
  is_phone_number_duplicate,
} from "@/lib/utils/phone_utils";

export const CONSULTATION_FEE_MAX = 100000;

/**
 * Validates clinic name string.
 * Returns translation key string or null if valid.
 */
export function validate_clinic_name(name: string): string | null {
  const trimmed = name.trim();
  if ("" === trimmed) {
    return "val_clinic_name_req";
  } else if (trimmed.length < 2) {
    return "val_clinic_name_min";
  } else if (trimmed.length > 50) {
    return "val_clinic_name_max";
  } else {
    return null;
  }
}

/**
 * Validates Egyptian mobile phone number (exactly 11 digits starting with 010, 011, 012, 015)
 * and verifies duplicate phone uniqueness across clinics.
 * Returns translation key string or null if valid.
 */
export function validate_phone(
  phone: string,
  existing_clinics: Clinic[] = [],
  current_clinic_id?: number | null,
  is_typing: boolean = false
): string | null {
  // Empty check
  if ("" === phone || "" === phone.trim()) {
    return is_typing ? null : "val_phone_req";
  } else {
    // No action needed
  }

  // 1. Explicit invalid character checks (immediately flag spaces, letters, special characters/dashes)
  if (/\s/.test(phone)) {
    return "val_phone_spaces";
  } else {
    // No action needed
  }
  if (/[a-zA-Z]/.test(phone)) {
    return "val_phone_letters";
  } else {
    // No action needed
  }
  if (/[-–—]/.test(phone) || /[^\d]/.test(phone)) {
    return "val_phone_special_chars";
  } else {
    // No action needed
  }

  const trimmed = phone.trim();

  // 2. Length limit check (> 11 digits)
  if (trimmed.length > 11) {
    return "val_phone_too_long";
  } else {
    // No action needed
  }

  // 3. Prefix validation for Egyptian mobile numbers
  if (trimmed.length >= 1 && !trimmed.startsWith("0")) {
    return "val_phone_invalid_prefix";
  } else {
    // No action needed
  }
  if (trimmed.length >= 2 && !trimmed.startsWith("01")) {
    return "val_phone_invalid_prefix";
  } else {
    // No action needed
  }
  if (trimmed.length >= 3 && !/01[0125]/.test(trimmed.slice(0, 3))) {
    return "val_phone_invalid_prefix";
  } else {
    // No action needed
  }

  // 4. Incomplete number check (< 11 digits)
  if (trimmed.length < 11) {
    // While typing, let user continue typing without premature error
    if (is_typing) {
      return null;
    } else {
      // On blur or submit, incomplete number is invalid
      return "val_phone_invalid";
    }
  } else {
    // No action needed
  }

  // 5. Complete 11 digits regex check
  const egyptian_mobile_regex = /^01[0125][0-9]{8}$/;
  if (!egyptian_mobile_regex.test(trimmed)) {
    return "val_phone_invalid";
  } else {
    // No action needed
  }

  // 6. Duplicate check across clinics
  const target_clinics =
    existing_clinics.length > 0 ? existing_clinics : get_clinics();
  if (is_phone_number_duplicate(trimmed, target_clinics, current_clinic_id)) {
    return "val_phone_duplicate";
  } else {
    // No action needed
  }

  return null;
}

/**
 * Validates governorate selection.
 * Returns translation key string or null if valid.
 */
export function validate_governorate(gov: string): string | null {
  if ("" === gov.trim()) {
    return "val_governorate_req";
  } else {
    return null;
  }
}

/**
 * Validates city selection.
 * Returns translation key string or null if valid.
 */
export function validate_city(city: string): string | null {
  if ("" === city.trim()) {
    return "val_city_req";
  } else {
    return null;
  }
}

/**
 * Validates street address string.
 * Returns translation key string or null if valid.
 */
export function validate_address(address: string): string | null {
  const trimmed = address.trim();
  if ("" === trimmed) {
    return "val_address_req";
  } else if (trimmed.length < 2) {
    return "val_address_min";
  } else {
    return null;
  }
}

/**
 * Validates consultation fee numeric input with single source of truth max cap.
 * Returns translation key string or null if valid.
 */
export function validate_consultation_fee(fee: string): string | null {
  const trimmed = fee.trim();
  const num = Number(trimmed);
  if ("" === trimmed) {
    return "val_fee_req";
  } else if (isNaN(num) || num <= 0) {
    return "val_fee_positive";
  } else if (num > CONSULTATION_FEE_MAX) {
    return "val_fee_max";
  } else {
    return null;
  }
}

/**
 * Checks if a proposed schedule item [day, start_time, end_time] overlaps with
 * any existing schedule of the same doctor in other clinics.
 *
 * Conflict rule:
 * Overlap exists IF on the SAME day:
 * start_time < other.endTime AND end_time > other.startTime
 * (Back-to-back schedules e.g. 1-5 and 5-8 are ALLOWED).
 */
export function has_schedule_overlap(
  day: string,
  start_time: string,
  end_time: string,
  other_schedules: WorkingScheduleItem[] = []
): boolean {
  if (!day || !start_time || !end_time || !other_schedules || 0 === other_schedules.length) {
    return false;
  } else {
    const start_mins = parse_time_to_minutes(start_time);
    const end_mins = parse_time_to_minutes(end_time);

    if (start_mins < 0 || end_mins < 0 || start_mins >= end_mins) {
      return false;
    } else {
      return other_schedules.some((other) => {
        if (other.day !== day) {
          return false;
        } else {
          const other_start = parse_time_to_minutes(other.startTime);
          const other_end = parse_time_to_minutes(other.endTime);

          if (other_start < 0 || other_end < 0 || other_start >= other_end) {
            return false;
          } else {
            // Overlap occurs strictly if: start_mins < other_end && end_mins > other_start
            return start_mins < other_end && end_mins > other_start;
          }
        }
      });
    }
  }
}

/**
 * Real-time validation for Working Schedule item.
 * Supports checking occupied day strings or schedule items for time overlap against other clinics.
 * Returns object mapping field to translation error key, or null if valid.
 */
export function validate_working_schedule_item(
  day: string,
  start_time: string,
  end_time: string,
  existing_schedules: WorkingScheduleItem[],
  editing_index: number | null = null,
  doctor_occupied_days_or_schedules: (string | WorkingScheduleItem)[] = []
): { day_error?: string; start_error?: string; end_error?: string } | null {
  const errors: { day_error?: string; start_error?: string; end_error?: string } = {};

  if ("" === day.trim()) {
    errors.day_error = "val_day_req";
  } else {
    // Valid day
  }

  // Duplicate check inside same clinic form
  const duplicate_exists = existing_schedules.some((s, idx) => {
    if (null !== editing_index && idx === editing_index) {
      return false;
    } else {
      return s.day === day;
    }
  });

  if (duplicate_exists) {
    errors.day_error = "val_day_duplicate";
  } else {
    // No action needed
  }

  if ("" === start_time.trim()) {
    errors.start_error = "val_start_time_req";
  } else {
    // No action needed
  }

  if ("" === end_time.trim()) {
    errors.end_error = "val_end_time_req";
  } else {
    // No action needed
  }

  if ("" !== start_time.trim() && "" !== end_time.trim()) {
    if (is_same_time(start_time, end_time)) {
      errors.end_error = "val_same_time";
    } else if (!is_start_before_end(start_time, end_time)) {
      errors.start_error = "val_start_after_end";
      errors.end_error = "val_end_before_start";
    } else {
      // Check for overlap or conflict with other clinics
      for (const item of doctor_occupied_days_or_schedules) {
        if (typeof item === "string") {
          if (item === day) {
            errors.day_error = "val_day_occupied";
            break;
          } else {
            // No action needed
          }
        } else if (item && item.day === day) {
          if (do_time_intervals_overlap(start_time, end_time, item.startTime, item.endTime)) {
            errors.day_error = "val_schedule_conflict";
            errors.start_error = "val_schedule_conflict";
            errors.end_error = "val_schedule_conflict";
            break;
          } else {
            // No action needed
          }
        } else {
          // No action needed
        }
      }
    }
  } else {
    // No action needed
  }

  if (Object.keys(errors).length > 0) {
    return errors;
  } else {
    return null;
  }
}

/**
 * Validates full working schedule array for a clinic.
 * Requires at least one working schedule entry.
 * Returns translation key "msg_no_working_days" if empty, or null if valid.
 */
export function validate_working_schedule(
  schedule_list: WorkingScheduleItem[] = []
): string | null {
  if (!schedule_list || schedule_list.length === 0) {
    return "msg_no_working_days";
  } else {
    // No action needed
  }
  return null;
}

/**
 * Validates assigned receptionists list for a clinic.
 * Requires at least one assigned receptionist.
 * Returns translation key "val_receptionist_req" if empty, or null if valid.
 */
export function validate_assigned_receptionists(
  receptionists: ReceptionistItem[] = []
): string | null {
  if (!receptionists || receptionists.length === 0) {
    return "val_receptionist_req";
  } else {
    // No action needed
  }
  return null;
}

/**
 * Real-time validation for Break Time item including break-vs-break overlap checks.
 * Returns object mapping field to translation error key, or null if valid.
 */
export function validate_break_time_item(
  day: string,
  break_start: string,
  break_end: string,
  schedule_list: WorkingScheduleItem[],
  existing_breaks: BreakTimeItem[] = [],
  editing_index: number | null = null
): { day_error?: string; start_error?: string; end_error?: string } | null {
  const errors: { day_error?: string; start_error?: string; end_error?: string } = {};

  if ("" === day.trim()) {
    errors.day_error = "val_day_req";
  } else {
    // Day provided
  }

  if ("" === break_start.trim()) {
    errors.start_error = "val_break_start_req";
  } else {
    // Start time provided
  }

  if ("" === break_end.trim()) {
    errors.end_error = "val_break_end_req";
  } else {
    // End time provided
  }

  if ("" !== break_start.trim() && "" !== break_end.trim()) {
    if (is_same_time(break_start, break_end)) {
      errors.end_error = "val_same_time";
    } else if (!is_start_before_end(break_start, break_end)) {
      errors.start_error = "val_start_after_end";
      errors.end_error = "val_end_before_start";
    } else {
      if ("" !== day.trim()) {
        const matching_schedule = schedule_list.find((s) => s.day === day);
        if (!matching_schedule) {
          errors.day_error = "val_no_schedule_for_day";
        } else {
          const is_within = is_interval_within_bounds(
            break_start,
            break_end,
            matching_schedule.startTime,
            matching_schedule.endTime
          );

          if (!is_within) {
            errors.start_error = "val_break_outside_hours";
            errors.end_error = "val_break_outside_hours";
          } else {
            // Check overlap with other breaks on the same day
            const start_mins = parse_time_to_minutes(break_start);
            const end_mins = parse_time_to_minutes(break_end);

            const has_overlap = existing_breaks.some((other_break, idx) => {
              if (null !== editing_index && idx === editing_index) {
                return false;
              } else if (other_break.day !== day) {
                return false;
              } else {
                const other_start = parse_time_to_minutes(other_break.breakStart);
                const other_end = parse_time_to_minutes(other_break.breakEnd);

                // Overlap occurs if start < other_end AND end > other_start
                return start_mins < other_end && end_mins > other_start;
              }
            });

            if (has_overlap) {
              errors.start_error = "val_break_overlap";
              errors.end_error = "val_break_overlap";
            } else {
              // Valid break
            }
          }
        }
      } else {
        // Day missing
      }
    }
  } else {
    // Times incomplete
  }

  if (Object.keys(errors).length > 0) {
    return errors;
  } else {
    return null;
  }
}

/**
 * Checks whether the current step is completely valid.
 */
export function is_step_valid(
  step: number,
  form_state: {
    clinic_name: string;
    phone: string;
    governorate: string;
    city: string;
    address: string;
    consultation_fee: string;
    schedule_list: WorkingScheduleItem[];
    break_list: BreakTimeItem[];
    assigned_receptionists?: ReceptionistItem[];
    appointment_duration?: string;
    max_advance_booking?: string;
  },
  existing_clinics: Clinic[] = [],
  current_clinic_id?: number | null,
  doctor_occupied_days_or_schedules: (string | WorkingScheduleItem)[] = [],
  doctor_other_schedules: WorkingScheduleItem[] = []
): boolean {
  if (1 === step) {
    const err_name = validate_clinic_name(form_state.clinic_name);
    const err_phone = validate_phone(form_state.phone, existing_clinics, current_clinic_id);
    const err_gov = validate_governorate(form_state.governorate);
    const err_city = validate_city(form_state.city);
    const err_address = validate_address(form_state.address);
    const err_fee = validate_consultation_fee(form_state.consultation_fee);

    return (
      null === err_name &&
      null === err_phone &&
      null === err_gov &&
      null === err_city &&
      null === err_address &&
      null === err_fee
    );
  } else if (2 === step) {
    if (0 === form_state.schedule_list.length) {
      return false;
    } else {
      const all_schedules = [
        ...doctor_occupied_days_or_schedules,
        ...doctor_other_schedules,
      ];
      if (all_schedules.length > 0) {
        return form_state.schedule_list.every((s) => {
          return !all_schedules.some((other) => {
            if (typeof other === "string") {
              return other === s.day;
            } else if (other && other.day === s.day) {
              return do_time_intervals_overlap(s.startTime, s.endTime, other.startTime, other.endTime);
            } else {
              return false;
            }
          });
        });
      } else {
        return true;
      }
    }
  } else if (3 === step) {
    // Step 3 (Break Times) is OPTIONAL: an empty break_list is valid.
    // If breaks exist, all entries must be valid.
    if (!form_state.break_list || 0 === form_state.break_list.length) {
      return true;
    } else {
      return form_state.break_list.every((b, idx) => {
        const err = validate_break_time_item(
          b.day,
          b.breakStart,
          b.breakEnd,
          form_state.schedule_list,
          form_state.break_list,
          idx
        );
        return null === err;
      });
    }
  } else if (4 === step) {
    // Step 4 (Receptionists) is REQUIRED: at least one receptionist must be assigned.
    return (form_state.assigned_receptionists?.length || 0) > 0;
  } else if (5 === step) {
    // Step 5 (Booking Settings) is REQUIRED: duration and advance booking must be selected.
    return (
      Boolean(form_state.appointment_duration?.trim()) &&
      Boolean(form_state.max_advance_booking?.trim())
    );
  } else {
    return true;
  }
}

/**
 * File Name: clinic_validator.ts
 * Author: shimaa salah
 * Created Date: 05/07/2026
 * Version: v1.2.0
 * Dependencies:
 *   - @/types/clinic
 *   - @/lib/utils/time_utils
 *   - @/lib/utils/phone_utils
 * Contributors: shimaa salah
 * Last Modified: shimaa salah - 13/08/2026
 * Description: Pure validation engine returning localization keys for dynamic language resolution in UI components.
 */

import { Clinic, WorkingScheduleItem, BreakTimeItem } from "@/types/clinic";
import { get_clinics } from "@/services/clinic.service";
import {
  parse_time_to_minutes,
  is_start_before_end,
  is_same_time,
  is_interval_within_bounds,
  do_time_intervals_overlap,
} from "@/lib/utils/time_utils";
import {
  normalize_phone_number,
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
  current_clinic_id?: number | null
): string | null {
  const trimmed = phone.trim();

  if ("" === trimmed) {
    return "val_phone_req";
  } else {
    const normalized = normalize_phone_number(trimmed);
    const egyptian_mobile_regex = /^01[0125][0-9]{8}$/;

    if (!egyptian_mobile_regex.test(normalized)) {
      return "val_phone_invalid";
    } else {
      const target_clinics =
        existing_clinics.length > 0 ? existing_clinics : get_clinics();
      if (is_phone_number_duplicate(trimmed, target_clinics, current_clinic_id)) {
        return "val_phone_duplicate";
      } else {
        return null;
      }
    }
  }
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
  }

  if ("" === start_time.trim()) {
    errors.start_error = "val_start_time_req";
  }

  if ("" === end_time.trim()) {
    errors.end_error = "val_end_time_req";
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
          }
        } else if (item && item.day === day) {
          if (do_time_intervals_overlap(start_time, end_time, item.startTime, item.endTime)) {
            errors.day_error = "val_schedule_conflict";
            errors.start_error = "val_schedule_conflict";
            errors.end_error = "val_schedule_conflict";
            break;
          }
        }
      }
    }
  }

  if (Object.keys(errors).length > 0) {
    return errors;
  } else {
    return null;
  }
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
  },
  existing_clinics: Clinic[] = [],
  current_clinic_id?: number | null,
  doctor_occupied_days: string[] = [],
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
      if (doctor_other_schedules.length > 0) {
        return form_state.schedule_list.every((s) => {
          return !doctor_other_schedules.some((other) => {
            if (other.day === s.day) {
              return do_time_intervals_overlap(s.startTime, s.endTime, other.startTime, other.endTime);
            }
            return false;
          });
        });
      } else {
        return form_state.schedule_list.every(
          (s) => !doctor_occupied_days.includes(s.day)
        );
      }
    }
  } else if (3 === step) {
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
  } else {
    return true;
  }
}

/**
 * File Name: clinic_validator.ts
 * Author: shimaa salah
 * Created Date: 05/07/2026
 * Version: v1.0.0
 * Dependencies:
 *   - @/types/clinic
 *   - @/lib/utils/time_utils
 * Contributors: shimaa salah
 * Last Modified: shimaa salah - 05/08/2026
 * Description: Centralized validation engine providing pure validation rules with Arabic user feedback messages.
 */

import { WorkingScheduleItem, BreakTimeItem } from "@/types/clinic";
import {
  parse_time_to_minutes,
  is_start_before_end,
  is_same_time,
  is_interval_within_bounds,
} from "@/lib/utils/time_utils";

/**
 * Validates clinic name string.
 */
export function validate_clinic_name(name: string): string | null {
  const trimmed = name.trim();
  if ("" === trimmed) {
    return "اسم العيادة مطلوب";
  } else if (trimmed.length < 2) {
    return "يجب أن يكون اسم العيادة حرفين على الأقل";
  } else if (trimmed.length > 50) {
    return "يجب ألا يتجاوز اسم العيادة 50 حرفاً";
  } else {
    return null;
  }
}

/**
 * Validates 11-digit phone number.
 */
export function validate_phone(phone: string): string | null {
  const trimmed = phone.trim();
  const phone_regex = /^01[0125][0-9]{8}$/;
  if ("" === trimmed) {
    return "رقم الهاتف مطلوب ويجب أن يكون 11 رقماً صحيحاً";
  } else if (!phone_regex.test(trimmed) && !/^\d{10,11}$/.test(trimmed)) {
    return "يرجى إدخال رقم هاتف صحيح مكون من 11 رقماً (مثال: 01012345678)";
  } else {
    return null;
  }
}

/**
 * Validates governorate selection.
 */
export function validate_governorate(gov: string): string | null {
  if ("" === gov.trim()) {
    return "المحافظة مطلوبة";
  } else {
    return null;
  }
}

/**
 * Validates city selection.
 */
export function validate_city(city: string): string | null {
  if ("" === city.trim()) {
    return "المدينة مطلوبة";
  } else {
    return null;
  }
}

/**
 * Validates street address string.
 */
export function validate_address(address: string): string | null {
  const trimmed = address.trim();
  if ("" === trimmed) {
    return "العنوان التفصيلي مطلوب";
  } else if (trimmed.length < 2) {
    return "يجب أن يكون العنوان حرفين على الأقل";
  } else {
    return null;
  }
}

/**
 * Validates consultation fee numeric input.
 */
export function validate_consultation_fee(fee: string): string | null {
  const trimmed = fee.trim();
  const num = Number(trimmed);
  if ("" === trimmed) {
    return "سعر الكشف مطلوب ويجب أن يكون رقماً موجباً";
  } else if (isNaN(num) || num <= 0) {
    return "سعر الكشف يجب أن يكون رقماً موجباً";
  } else {
    return null;
  }
}

/**
 * Real-time validation for Working Schedule item.
 */
export function validate_working_schedule_item(
  day: string,
  start_time: string,
  end_time: string,
  existing_schedules: WorkingScheduleItem[],
  editing_index: number | null = null
): { day_error?: string; start_error?: string; end_error?: string } | null {
  const errors: { day_error?: string; start_error?: string; end_error?: string } = {};

  if ("" === day.trim()) {
    errors.day_error = "يوم العمل مطلوب";
  } else {
    // Valid day input
  }

  // Duplicate check
  const duplicate_exists = existing_schedules.some((s, idx) => {
    if (null !== editing_index && idx === editing_index) {
      return false;
    } else {
      return s.day === day;
    }
  });

  if (duplicate_exists) {
    errors.day_error = "تمت إضافة جدول لهذا اليوم بالفعل";
  } else {
    // Unique day
  }

  if ("" === start_time.trim()) {
    errors.start_error = "وقت البداية مطلوب";
  } else {
    // Start time provided
  }

  if ("" === end_time.trim()) {
    errors.end_error = "وقت النهاية مطلوب";
  } else {
    // End time provided
  }

  if ("" !== start_time.trim() && "" !== end_time.trim()) {
    if (is_same_time(start_time, end_time)) {
      errors.end_error = "وقت النهاية لا يمكن أن يساوي وقت البداية";
    } else if (!is_start_before_end(start_time, end_time)) {
      errors.start_error = "وقت البداية يجب أن يكون قبل وقت النهاية";
      errors.end_error = "وقت النهاية يجب أن يكون بعد وقت البداية";
    } else {
      // Valid range
    }
  } else {
    // Incomplete times
  }

  if (Object.keys(errors).length > 0) {
    return errors;
  } else {
    return null;
  }
}

/**
 * Real-time validation for Break Time item.
 */
export function validate_break_time_item(
  day: string,
  break_start: string,
  break_end: string,
  schedule_list: WorkingScheduleItem[]
): { day_error?: string; start_error?: string; end_error?: string } | null {
  const errors: { day_error?: string; start_error?: string; end_error?: string } = {};

  if ("" === day.trim()) {
    errors.day_error = "يوم العمل مطلوب";
  } else {
    // Day provided
  }

  if ("" === break_start.trim()) {
    errors.start_error = "وقت بداية الاستراحة مطلوب";
  } else {
    // Start time provided
  }

  if ("" === break_end.trim()) {
    errors.end_error = "وقت نهاية الاستراحة مطلوب";
  } else {
    // End time provided
  }

  if ("" !== break_start.trim() && "" !== break_end.trim()) {
    if (is_same_time(break_start, break_end)) {
      errors.end_error = "وقت نهاية الاستراحة لا يمكن أن يساوي وقت البداية";
    } else if (!is_start_before_end(break_start, break_end)) {
      errors.start_error = "وقت بداية الاستراحة يجب أن يكون قبل وقت النهاية";
      errors.end_error = "وقت نهاية الاستراحة يجب أن يكون بعد وقت البداية";
    } else {
      if ("" !== day.trim()) {
        const matching_schedule = schedule_list.find((s) => s.day === day);
        if (!matching_schedule) {
          errors.day_error = "لا يوجد جدول عمل محدد لهذا اليوم";
        } else {
          const is_within = is_interval_within_bounds(
            break_start,
            break_end,
            matching_schedule.startTime,
            matching_schedule.endTime
          );

          if (!is_within) {
            const err_msg = `أوقات الاستراحة يجب أن تكون ضمن ساعات العمل (${matching_schedule.startTime} - ${matching_schedule.endTime})`;
            errors.start_error = err_msg;
            errors.end_error = err_msg;
          } else {
            // Valid break
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
  }
): boolean {
  if (1 === step) {
    const err_name = validate_clinic_name(form_state.clinic_name);
    const err_phone = validate_phone(form_state.phone);
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
    return form_state.schedule_list.length > 0;
  } else if (3 === step) {
    return form_state.break_list.every((b) => {
      const err = validate_break_time_item(b.day, b.breakStart, b.breakEnd, form_state.schedule_list);
      return null === err;
    });
  } else {
    return true;
  }
}

/**
 * File Name : clinic.service.ts
 * Author : shimaa salah
 * Created Date : 2026-07-20
 * Version : v1.1.0
 * Dependencies : @/data/clinics, @/types/clinic
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 29/08/2026
 * Description : LocalStorage state persistence and data access service for managing clinic entities.
 */

import { clinics as initial_clinics } from "@/data/clinics";
import { Clinic, WorkingScheduleItem } from "@/types/clinic";

export type { Clinic, WorkingScheduleItem };

const storage_key = "clinics";

// 1. Read clinics list from LocalStorage or return default seed list
export function get_clinics(): Clinic[] {
  if ("undefined" === typeof window) {
    return initial_clinics as Clinic[];
  } else {
    try {
      const stored_clinics = localStorage.getItem(storage_key);
      if (null !== stored_clinics) {
        return JSON.parse(stored_clinics) as Clinic[];
      } else {
        return initial_clinics as Clinic[];
      }
    } catch (storage_error) {
      console.error("Error reading clinics from localStorage:", storage_error);
      return initial_clinics as Clinic[];
    }
  }
}

// 2. Read single clinic entity by numerical ID
export function get_clinic_by_id(clinic_id: number): Clinic | undefined {
  const current_clinics = get_clinics();
  return current_clinics.find((clinic) => Number(clinic.id) === Number(clinic_id));
}

// 3. Save complete list of clinics to LocalStorage
export function save_clinics(clinics: Clinic[]): void {
  if ("undefined" === typeof window) {
    return;
  } else {
    try {
      localStorage.setItem(storage_key, JSON.stringify(clinics));
    } catch (storage_error) {
      console.error("Error saving clinics to localStorage:", storage_error);
    }
  }
}

// 4. Initialize seed data into LocalStorage if empty
export function initialize_clinics(): void {
  if ("undefined" === typeof window) {
    return;
  } else {
    const stored_clinics = localStorage.getItem(storage_key);
    if (null === stored_clinics) {
      save_clinics(initial_clinics as Clinic[]);
    } else {
      // Data already initialized
    }
  }
}

// 5. Add a new clinic to LocalStorage persistent store and return updated list
export function add_clinic(new_clinic: Clinic): Clinic[] {
  const current_clinics = get_clinics();
  const updated_clinics = [...current_clinics, new_clinic];
  save_clinics(updated_clinics);
  return updated_clinics;
}

// 6. Update existing clinic record in LocalStorage persistent store
export function update_clinic(updated_clinic: Clinic): Clinic[] {
  const current_clinics = get_clinics();
  const updated_clinics = current_clinics.map((clinic) => {
    if (Number(clinic.id) === Number(updated_clinic.id)) {
      return { ...clinic, ...updated_clinic };
    } else {
      return clinic;
    }
  });
  save_clinics(updated_clinics);
  return updated_clinics;
}

// 7. Delete a clinic from LocalStorage persistent store by ID and return updated list
export function delete_clinic(clinic_id: number): Clinic[] {
  const current_clinics = get_clinics();
  const updated_clinics = current_clinics.filter(
    (clinic) => Number(clinic.id) !== Number(clinic_id),
  );
  save_clinics(updated_clinics);
  return updated_clinics;
}

// 8. Calculate all occupied working days for a specific doctor across all existing clinics
export function get_doctor_occupied_working_days(
  doctor_id: string | number,
  exclude_clinic_id?: number | null,
): string[] {
  const all_clinics = get_clinics();
  const occupied_days_set = new Set<string>();

  all_clinics.forEach((clinic) => {
    // Match doctor_id (defaulting to "doc_1" if undefined) and ignore exclude_clinic_id when editing
    const current_doc = clinic.doctor_id ?? "doc_1";
    if (String(current_doc) === String(doctor_id)) {
      if (
        null !== exclude_clinic_id &&
        undefined !== exclude_clinic_id &&
        clinic.id === exclude_clinic_id
      ) {
        // Exclude current clinic being edited
      } else {
        const days_str = clinic.working_days || clinic.workingDays || "";

        if (days_str) {
          const days_array = days_str.split(",").map((d) => d.trim());

          days_array.forEach((day_name) => {
            if (day_name) {
              occupied_days_set.add(day_name);
            } else {
              // No action needed
            }
          });
        } else {
          // No action needed
        }
      }
    } else {
      // Different doctor
    }
  });

  return Array.from(occupied_days_set);
}

// 9. Retrieve all working schedule items across other clinics for a specific doctor (excluding current clinic being edited)
export function get_doctor_other_clinic_schedules(
  doctor_id: string | number,
  exclude_clinic_id?: number | null,
  clinics_override?: Clinic[],
): WorkingScheduleItem[] {
  const all_clinics =
    clinics_override && clinics_override.length > 0
      ? clinics_override
      : get_clinics();
  const schedules: WorkingScheduleItem[] = [];

  all_clinics.forEach((clinic) => {
    const current_doc = clinic.doctor_id ?? "doc_1";
    if (String(current_doc) === String(doctor_id)) {
      if (
        null !== exclude_clinic_id &&
        undefined !== exclude_clinic_id &&
        Number(clinic.id) === Number(exclude_clinic_id)
      ) {
        // Exclude current clinic being edited
      } else {
        if (clinic.schedule_list && Array.isArray(clinic.schedule_list)) {
          clinic.schedule_list.forEach((item) => {
            if (item && item.day && item.startTime && item.endTime) {
              schedules.push(item);
            } else {
              // No action needed
            }
          });
        } else {
          // No action needed
        }
      }
    } else {
      // No action needed
    }
  });

  return schedules;
}

export const get_doctor_existing_schedules = get_doctor_other_clinic_schedules;

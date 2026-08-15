/*
 * File Name: clinic.service.ts
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - @/data/clinics
 *   - @/types/clinic
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 13/08/2026]
 * File Description: LocalStorage state persistence and data access service for managing clinic entities.
 */

import { clinics as initial_clinics } from "@/data/clinics";
import { Clinic } from "@/types/clinic";

export type { Clinic };

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

// 2. Save complete list of clinics to LocalStorage
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

// 3. Initialize seed data into LocalStorage if empty
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

// 4. Add a new clinic to LocalStorage persistent store and return updated list
export function add_clinic(new_clinic: Clinic): Clinic[] {
  const current_clinics = get_clinics();
  const updated_clinics = [...current_clinics, new_clinic];
  save_clinics(updated_clinics);
  return updated_clinics;
}

// 5. Delete a clinic from LocalStorage persistent store by ID and return updated list
export function delete_clinic(clinic_id: number): Clinic[] {
  const current_clinics = get_clinics();
  const updated_clinics = current_clinics.filter(
    (clinic) => clinic.id !== clinic_id,
  );
  save_clinics(updated_clinics);
  return updated_clinics;
}

// 6. Calculate all occupied working days for a specific doctor across all existing clinics
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
    }
  });

  return Array.from(occupied_days_set);
}

/*
 * File Name: clinic.service.ts
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - @/data/clinics
 *   - @/types/clinic
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
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
/*
 * File Name: phone_utils.ts
 * Author: shimaa salah
 * Date of Creation: 13/08/2026
 * Version Information: V1.1.0
 * Dependencies:
 *   - @/types/clinic
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 13/08/2026]
 * File Description: Pure utility functions for phone normalization and duplicate phone verification.
 */

import { Clinic } from "@/types/clinic";

/**
 * Normalizes an Egyptian phone number by stripping formatting characters
 * (spaces, hyphens, parentheses, plus sign) and standardizing country code prefixes (+20, 0020, 20).
 * Examples:
 *   "01012345678"     -> "01012345678"
 *   "010-1234-5678"   -> "01012345678"
 *   "+201012345678"   -> "01012345678"
 *   "00201012345678"  -> "01012345678"
 *   "0101234567"      -> "0101234567" (NO padding/alteration of invalid length)
 */
export function normalize_phone_number(phone: string): string {
  if (!phone) {
    return "";
  } else {
    // Strip all non-numeric digits
    let digits = phone.replace(/\D/g, "");

    // Strip Egyptian international prefixes ONLY when valid 11-digit local mobile number is produced (starts with 01)
    if (digits.startsWith("00201") && digits.length === 15) {
      digits = digits.slice(4);
    } else if (digits.startsWith("201") && digits.length === 13) {
      digits = digits.slice(2);
    } else {
      // Preserved exact digit sequence without alteration or padding
    }

    return digits;
  }
}

/**
 * Checks if a phone number already exists among registered clinics.
 * Ignores current_clinic_id when editing an existing clinic.
 */
export function is_phone_number_duplicate(
  phone: string,
  existing_clinics: Clinic[],
  current_clinic_id?: number | null
): boolean {
  const normalized_target = normalize_phone_number(phone);
  if (!normalized_target) {
    return false;
  } else {
    return existing_clinics.some((clinic) => {
      if (null !== current_clinic_id && undefined !== current_clinic_id && clinic.id === current_clinic_id) {
        return false;
      } else {
        const normalized_existing = normalize_phone_number(clinic.phone);
        return normalized_existing === normalized_target;
      }
    });
  }
}

/*
 * File Name: clinic_form_constants.ts
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Constant values, validation regexes, and UI class definitions for clinic form components.
 */

export const WORKING_DAYS = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];

export const GOVERNORATES = ["Cairo", "Giza", "Alexandria"];

export const CITIES_BY_GOVERNORATE: Record<string, string[]> = {
  Cairo: ["Nasr City", "Heliopolis", "Maadi", "New Cairo", "Shoubra"],
  Giza: ["Dokki", "Mohandessin", "6th October", "Sheikh Zayed", "Haram"],
  Alexandria: ["Smouha", "Stanley", "Miami", "Sidi Gaber", "Gleem"],
};

export const PHONE_REGEX = /^01[0125][0-9]{8}$/;

export const DURATION_OPTIONS = [
  "15 Minutes",
  "20 Minutes",
  "30 Minutes",
  "45 Minutes",
  "60 Minutes",
];

export const ADVANCE_BOOKING_OPTIONS = [
  "7 Days",
  "14 Days",
  "30 Days",
  "60 Days",
  "90 Days",
];

export const LABEL_CLASS =
  "mb-2 text-sm font-semibold text-app-text-primary md:text-base lg:text-lg";

export const INPUT_CLASS =
  "w-full rounded-xl border border-app-border bg-app-input_fill px-4 py-2.5 text-app-text-primary placeholder:text-app-text-secondary outline-none transition-all focus:border-app-primary focus:ring-2 focus:ring-app-primary/20";

export const ERROR_CLASS = "mt-1 text-xs text-red-500 font-medium";

export const DAY_BUTTON_CLASS =
  "rounded-xl border border-app-border bg-app-input_fill text-app-text-primary px-4 py-2.5 transition-all hover:border-app-primary/50";

export const BUTTON_CLASS =
  "h-10 rounded-md font-medium text-sm md:text-base lg:text-lg transition-colors";

export const INFO_ALERT_CLASS =
  "flex items-center gap-3 rounded-xl border border-blue-500/20 bg-blue-500/10 p-4 text-sm text-blue-600 dark:text-blue-400";

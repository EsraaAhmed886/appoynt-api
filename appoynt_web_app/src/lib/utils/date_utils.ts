/**
 * File Name : date_utils.ts
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : None
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Reusable date and time formatting utilities with bilingual (English / Arabic) and UTC normalization support.
 */

/**
 * Formats an ISO 8601 UTC date string into a user-friendly display date and time string.
 * Example output (en): "25 May 2025, 10:30 AM"
 * Example output (ar): "25 مايو 2025، 10:30 ص"
 */
export function formatReviewDate(
  isoString: string,
  locale: "en" | "ar" = "en"
): string {
  if (!isoString) {
    return "";
  } else {
    try {
      const date = new Date(isoString);

      if (isNaN(date.getTime())) {
        return isoString;
      } else {
        const localeString = "ar" === locale ? "ar-EG" : "en-US";

        const formattedDate = date.toLocaleDateString(localeString, {
          day: "numeric",
          month: "short",
          year: "numeric",
          timeZone: "UTC",
        });

        const formattedTime = date.toLocaleTimeString(localeString, {
          hour: "2-digit",
          minute: "2-digit",
          hour12: true,
          timeZone: "UTC",
        });

        if ("ar" === locale) {
          return `${formattedDate}، ${formattedTime}`;
        } else {
          return `${formattedDate}, ${formattedTime}`;
        }
      }
    } catch {
      return isoString;
    }
  }
}

/**
 * Formats a date string (ISO, RFC, or human readable e.g. "May 21, 2024") into a localized date string.
 * Example output (en): "May 21, 2024"
 * Example output (ar): "21 مايو 2024"
 */
export function formatLocalizedDate(
  dateInput?: string | Date | null,
  locale: "en" | "ar" = "en"
): string {
  if (!dateInput) {
    return "";
  } else {
    try {
      const date = typeof dateInput === "string" ? new Date(dateInput) : dateInput;

      if (isNaN(date.getTime())) {
        return typeof dateInput === "string" ? dateInput : "";
      } else {
        if ("ar" === locale) {
          return date.toLocaleDateString("ar-EG", {
            day: "numeric",
            month: "short",
            year: "numeric",
            numberingSystem: "latn",
          });
        } else {
          return date.toLocaleDateString("en-US", {
            month: "short",
            day: "numeric",
            year: "numeric",
          });
        }
      }
    } catch {
      return typeof dateInput === "string" ? dateInput : "";
    }
  }
}


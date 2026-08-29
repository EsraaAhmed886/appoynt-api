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

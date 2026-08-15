/*
 * File Name: validators.ts
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Security and utility validation functions for verifying safe internal URLs against open redirect vulnerabilities and sanitizing user search input queries.
 */

/**
 * Validates whether a URL is a safe internal relative path (e.g., '/appointments/123').
 * Prevents Open Redirect security vulnerabilities.
 */
export function isSafeInternalUrl(url?: string): boolean {
  if (!url || typeof url !== "string") {
    return false;
  } else {
    const trimmed = url.trim();

    // Must start with '/' but not '//' (protocol-relative external URL) or 'javascript:' / 'data:'
    if (!trimmed.startsWith("/")) {
      return false;
    } else if (trimmed.startsWith("//")) {
      return false;
    } else if (trimmed.toLowerCase().startsWith("/javascript:")) {
      return false;
    } else {
      return true;
    }
  }
}

/**
 * Sanitizes and caps search query strings to prevent XSS / performance bottlenecks.
 */
export function sanitizeSearchQuery(
  query: string,
  maxLength: number = 100,
): string {
  if (!query) {
    return "";
  } else {
    // Strip control characters and trim
    const cleaned = query.replace(/[\u0000-\u001F\u007F-\u009F]/g, "");

    return cleaned.slice(0, maxLength);
  }
}

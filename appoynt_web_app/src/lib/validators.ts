/**
 * Validates whether a URL is a safe internal relative path (e.g., '/appointments/123').
 * Prevents Open Redirect security vulnerabilities.
 */
export function isSafeInternalUrl(url?: string): boolean {
  if (!url || typeof url !== "string") return false;
  const trimmed = url.trim();

  // Must start with '/' but not '//' (protocol-relative external URL) or 'javascript:' / 'data:'
  if (!trimmed.startsWith("/")) return false;
  if (trimmed.startsWith("//")) return false;
  if (trimmed.toLowerCase().startsWith("/javascript:")) return false;

  return true;
}

/**
 * Sanitizes and caps search query strings to prevent XSS / performance bottlenecks.
 */
export function sanitizeSearchQuery(query: string, maxLength: number = 100): string {
  if (!query) return "";
  // Strip control characters and trim
  const cleaned = query.replace(/[\u0000-\u001F\u007F-\u009F]/g, "");
  return cleaned.slice(0, maxLength);
}

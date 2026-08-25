/*
 * File Name: record_status_badge.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Reusable medical record status badge component with explicit whitespace-nowrap styling preventing word breaks for amended and finalized states across light and dark themes.
 */

"use client";

import React from "react";
import { useTranslation } from "@/context/language_context";

interface RecordStatusBadgeProps {
  status: "FINALIZED" | "DRAFT" | "NOT_STARTED" | string;
  hasAmendments?: boolean;
  stepProgressText?: string;
  className?: string;
}

export default function RecordStatusBadge({
  status,
  hasAmendments = false,
  stepProgressText,
  className = "",
}: RecordStatusBadgeProps) {
  const { translations } = useTranslation();

  if (hasAmendments || "FINALIZED_WITH_AMENDMENTS" === status) {
    return (
      <span
        className={`inline-flex items-center justify-center whitespace-nowrap px-3 py-1 text-xs font-semibold rounded-full bg-purple-50 text-purple-700 border border-purple-200 dark:bg-purple-950/40 dark:text-purple-300 dark:border-purple-800 ${className}`}
      >
        {translations.finalized_with_amendments || "Finalized with Amendments"}
      </span>
    );
  } else if ("FINALIZED" === status) {
    return (
      <span
        className={`inline-flex items-center justify-center whitespace-nowrap px-3 py-1 text-xs font-semibold rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200 dark:bg-emerald-950/40 dark:text-emerald-300 dark:border-emerald-800 ${className}`}
      >
        {translations.finalized || "Finalized"}
      </span>
    );
  } else if ("DRAFT" === status) {
    return (
      <span
        className={`inline-flex items-center justify-center whitespace-nowrap px-3 py-1 text-xs font-semibold rounded-full bg-amber-50 text-amber-700 border border-amber-200 dark:bg-amber-950/40 dark:text-amber-300 dark:border-amber-800 ${className}`}
      >
        {translations.draft || "Draft"}
        {stepProgressText ? ` (${stepProgressText})` : ""}
      </span>
    );
  } else {
    return (
      <span
        className={`inline-flex items-center justify-center whitespace-nowrap px-3 py-1 text-xs font-semibold rounded-full bg-slate-100 text-slate-700 border border-slate-200 dark:bg-slate-800 dark:text-slate-300 dark:border-slate-700 ${className}`}
      >
        {translations.not_started || "Not Started"}
      </span>
    );
  }
}

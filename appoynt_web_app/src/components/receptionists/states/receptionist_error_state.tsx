/*
 * File Name: receptionist_error_state.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Error boundary and network failure presentation state with explicit diagnostic message and retry action.
 */

"use client";

import React from "react";
import { AlertCircle, RotateCcw } from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface ReceptionistErrorStateProps {
  message?: string | null;
  onRetry: () => void;
}

export default function ReceptionistErrorState({ message, onRetry }: ReceptionistErrorStateProps) {
  const { translations } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center p-8 md:p-12 text-center bg-white dark:bg-[#0E1726] border-2 border-red-200 dark:border-red-950 rounded-2xl shadow-xs animate-in fade-in">
      <div className="p-4 bg-red-50 dark:bg-red-950/60 text-red-600 dark:text-red-400 rounded-3xl mb-4 border border-red-200 dark:border-red-800">
        <AlertCircle className="w-10 h-10" />
      </div>

      <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-2">
        {translations.error_title || "Failed to Load Receptionists"}
      </h3>

      <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 max-w-md mb-6 leading-relaxed">
        {message || "An unexpected error occurred while communicating with the server. Please try again."}
      </p>

      <button
        type="button"
        onClick={onRetry}
        className="inline-flex items-center gap-2 px-5 py-2.5 bg-red-600 hover:bg-red-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md transition cursor-pointer"
      >
        <RotateCcw className="w-4 h-4" />
        <span>{translations.retry || "Retry"}</span>
      </button>
    </div>
  );
}

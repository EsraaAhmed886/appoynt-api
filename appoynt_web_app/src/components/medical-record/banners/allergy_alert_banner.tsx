/*
 * File Name: allergy_alert_banner.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Clinical Allergy Alert Banner rendering safe emerald status watermark or high-alert soft red warning banner with severity pills and error retry capabilities.
 */

"use client";

import React from "react";
import {
  ShieldCheck,
  ShieldAlert,
  AlertCircle,
  RefreshCw,
  Info,
} from "lucide-react";
import { AllergyItem } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

interface AllergyAlertBannerProps {
  allergies?: AllergyItem[];
  isLoading?: boolean;
  isError?: boolean;
  onRetry?: () => void;
}

export default function AllergyAlertBanner({
  allergies = [],
  isLoading = false,
  isError = false,
  onRetry,
}: AllergyAlertBannerProps) {
  const { translations } = useTranslation();

  if (isLoading) {
    return (
      <div className="w-full bg-slate-100 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 animate-pulse flex items-center gap-3">
        <div className="w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-700 shrink-0" />
        <div className="space-y-2 flex-1">
          <div className="h-3.5 bg-slate-200 dark:bg-slate-700 rounded-md w-1/4" />
          <div className="h-3 bg-slate-200 dark:bg-slate-700 rounded-md w-1/2" />
        </div>
      </div>
    );
  }

  if (isError) {
    return (
      <div className="w-full bg-rose-50 dark:bg-rose-950/40 border-2 border-rose-200 dark:border-rose-800 rounded-2xl p-4 flex items-center justify-between gap-4 text-start">
        <div className="flex items-center gap-3">
          <AlertCircle className="w-6 h-6 text-rose-600 dark:text-rose-400 shrink-0" />
          <div>
            <p className="text-xs font-bold text-rose-900 dark:text-rose-200">
              Unable to load patient allergy information
            </p>
            <p className="text-[11px] text-rose-700 dark:text-rose-300">
              An error occurred while communicating with the EHR allergy service.
            </p>
          </div>
        </div>
        {onRetry && (
          <button
            type="button"
            onClick={onRetry}
            className="px-3 py-1.5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold rounded-xl transition flex items-center gap-1.5 shrink-0 cursor-pointer shadow-xs"
          >
            <RefreshCw className="w-3.5 h-3.5" />
            <span>Retry</span>
          </button>
        )}
      </div>
    );
  }

  const hasAllergies = allergies && allergies.length > 0;

  if (!hasAllergies) {
    return (
      <div className="relative overflow-hidden w-full bg-emerald-50/80 dark:bg-emerald-950/30 border-2 border-emerald-200 dark:border-emerald-800/80 rounded-2xl p-4 md:p-5 flex items-center justify-between text-start transition">
        {/* Background Watermark Icon */}
        <ShieldCheck className="absolute -end-4 -bottom-4 w-32 h-32 text-emerald-500/10 dark:text-emerald-400/5 pointer-events-none" />

        <div className="flex items-center gap-3.5 z-10">
          <div className="w-10 h-10 rounded-xl bg-emerald-100 dark:bg-emerald-900/60 text-emerald-700 dark:text-emerald-300 flex items-center justify-center shrink-0 border border-emerald-300 dark:border-emerald-700">
            <ShieldCheck className="w-6 h-6" />
          </div>
          <div>
            <h4 className="text-sm font-bold text-emerald-900 dark:text-emerald-200">
              {translations.no_known_allergies || "No Known Drug or Environmental Allergies"}
            </h4>
            <p className="text-xs text-emerald-700 dark:text-emerald-400">
              Patient profile verified with zero active contraindication alerts recorded.
            </p>
          </div>
        </div>

        <span className="hidden sm:inline-flex items-center gap-1 px-3 py-1 bg-emerald-100 dark:bg-emerald-900/60 text-emerald-800 dark:text-emerald-300 font-bold text-[11px] rounded-full border border-emerald-300 dark:border-emerald-700 whitespace-nowrap z-10">
          ✓ Verified Clear
        </span>
      </div>
    );
  }

  return (
    <div className="relative overflow-hidden w-full bg-rose-50/90 dark:bg-rose-950/40 border-2 border-rose-300 dark:border-rose-800 rounded-2xl p-4 md:p-5 text-start space-y-3 shadow-xs">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-rose-100 dark:bg-rose-900/60 text-rose-700 dark:text-rose-300 flex items-center justify-center shrink-0 border border-rose-300 dark:border-rose-700">
            <ShieldAlert className="w-6 h-6 animate-pulse" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h4 className="text-sm font-bold text-rose-900 dark:text-rose-100">
                {translations.active_allergies || "Critical Clinical Allergy Alert"}
              </h4>
              <span className="px-2 py-0.5 bg-rose-200 dark:bg-rose-900 text-rose-800 dark:text-rose-200 text-[11px] font-extrabold rounded-full">
                {allergies.length}
              </span>
            </div>
            <p className="text-xs text-rose-700 dark:text-rose-300">
              Exercise extreme caution during prescribing and diagnostic administration.
            </p>
          </div>
        </div>
      </div>

      {/* Severity Pills List */}
      <div className="flex flex-wrap items-center gap-2 pt-1">
        {allergies.map((alg) => {
          const isSevere = "SEVERE" === alg.severity;
          const isModerate = "MODERATE" === alg.severity;
          return (
            <span
              key={alg.id || alg.name}
              className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-xl text-xs font-bold border ${
                isSevere
                  ? "bg-rose-100 dark:bg-rose-900/80 text-rose-800 dark:text-rose-200 border-rose-300 dark:border-rose-700"
                  : isModerate
                  ? "bg-amber-100 dark:bg-amber-900/80 text-amber-800 dark:text-amber-200 border-amber-300 dark:border-amber-700"
                  : "bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-200 border-slate-300 dark:border-slate-700"
              }`}
            >
              <Info className="w-3.5 h-3.5 shrink-0" />
              <span>{alg.name}:</span>
              <span className="uppercase text-[10px] tracking-wider font-extrabold underline">
                {alg.severity}
              </span>
            </span>
          );
        })}
      </div>
    </div>
  );
}

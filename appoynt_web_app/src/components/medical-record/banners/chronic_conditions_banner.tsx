/*
 * File Name: chronic_conditions_banner.tsx
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
 * File Description: Clinical Chronic Conditions Banner rendering active chronic morbidities with ICD-10 coding, status badges (Active, Managed, Controlled), diagnosis dates, and safe empty state watermark.
 */

"use client";

import React from "react";
import {
  Activity,
  HeartPulse,
  AlertCircle,
  RefreshCw,
  Calendar,
  CheckCircle2,
} from "lucide-react";
import { ChronicCondition } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

interface ChronicConditionsBannerProps {
  conditions?: ChronicCondition[];
  isLoading?: boolean;
  isError?: boolean;
  onRetry?: () => void;
}

export default function ChronicConditionsBanner({
  conditions = [],
  isLoading = false,
  isError = false,
  onRetry,
}: ChronicConditionsBannerProps) {
  const { translations } = useTranslation();

  if (isLoading) {
    return (
      <div className="w-full h-full bg-slate-100 dark:bg-[#131E35] border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 md:p-5 animate-pulse flex flex-col justify-between space-y-3">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-slate-200 dark:bg-slate-700 shrink-0" />
          <div className="space-y-2 flex-1">
            <div className="h-4 bg-slate-200 dark:bg-slate-700 rounded-md w-1/3" />
            <div className="h-3 bg-slate-200 dark:bg-slate-700 rounded-md w-1/2" />
          </div>
        </div>
        <div className="flex gap-2">
          <div className="h-8 bg-slate-200 dark:bg-slate-700 rounded-xl w-28" />
          <div className="h-8 bg-slate-200 dark:bg-slate-700 rounded-xl w-36" />
        </div>
      </div>
    );
  }

  if (isError) {
    return (
      <div className="w-full h-full bg-amber-50 dark:bg-amber-950/40 border-2 border-amber-200 dark:border-amber-800 rounded-2xl p-4 md:p-5 flex items-center justify-between gap-4 text-start">
        <div className="flex items-center gap-3">
          <AlertCircle className="w-6 h-6 text-amber-600 dark:text-amber-400 shrink-0" />
          <div>
            <p className="text-xs font-bold text-amber-900 dark:text-amber-200">
              {translations.unable_to_load_chronic_conditions || "Unable to load patient chronic conditions"}
            </p>
            <p className="text-[11px] text-amber-700 dark:text-amber-300">
              An error occurred while retrieving clinical morbidity records.
            </p>
          </div>
        </div>
        {onRetry && (
          <button
            type="button"
            onClick={onRetry}
            className="px-3 py-1.5 bg-amber-600 hover:bg-amber-700 text-white text-xs font-bold rounded-xl transition flex items-center gap-1.5 shrink-0 cursor-pointer shadow-xs"
          >
            <RefreshCw className="w-3.5 h-3.5" />
            <span>{translations.retry || "Retry"}</span>
          </button>
        )}
      </div>
    );
  }

  const hasConditions = conditions && conditions.length > 0;

  if (!hasConditions) {
    return (
      <div className="relative overflow-hidden w-full h-full bg-slate-50/90 dark:bg-[#131E35]/80 border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 md:p-5 flex items-center justify-between text-start transition shadow-xs">
        {/* Background Watermark Icon */}
        <HeartPulse className="absolute -end-4 -bottom-4 w-32 h-32 text-slate-400/10 dark:text-slate-500/5 pointer-events-none" />

        <div className="flex items-center gap-3.5 z-10">
          <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 flex items-center justify-center shrink-0 border border-slate-300 dark:border-slate-700">
            <HeartPulse className="w-6 h-6" />
          </div>
          <div>
            <h4 className="text-sm font-bold text-slate-900 dark:text-slate-100">
              {translations.no_chronic_conditions || "No Chronic Conditions Recorded"}
            </h4>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              {translations.no_chronic_conditions_desc || "Patient has zero active chronic morbidities documented on profile."}
            </p>
          </div>
        </div>

        <span className="hidden sm:inline-flex items-center gap-1 px-3 py-1 bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold text-[11px] rounded-full border border-slate-300 dark:border-slate-700 whitespace-nowrap z-10">
          <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500" />
          <span>{translations.controlled || "Clear"}</span>
        </span>
      </div>
    );
  }

  const getStatusBadge = (status?: string) => {
    const s = (status || "").toLowerCase();
    if ("active" === s) {
      return {
        label: translations.active || "Active",
        classes: "bg-amber-100 dark:bg-amber-900/80 text-amber-800 dark:text-amber-200 border-amber-300 dark:border-amber-700",
        dot: "bg-amber-500 animate-ping",
      };
    }
    if ("managed" === s) {
      return {
        label: translations.managed || "Managed",
        classes: "bg-sky-100 dark:bg-sky-900/80 text-sky-800 dark:text-sky-200 border-sky-300 dark:border-sky-700",
        dot: "bg-sky-500",
      };
    }
    // Default / controlled
    return {
      label: translations.controlled || "Controlled",
      classes: "bg-emerald-100 dark:bg-emerald-900/80 text-emerald-800 dark:text-emerald-200 border-emerald-300 dark:border-emerald-700",
      dot: "bg-emerald-500",
    };
  };

  return (
    <div className="relative overflow-hidden w-full h-full bg-slate-50/90 dark:bg-[#131E35]/90 border-2 border-slate-200 dark:border-slate-800 rounded-2xl p-4 md:p-5 text-start space-y-3 shadow-xs flex flex-col justify-between">
      {/* Header Info */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-blue-100 dark:bg-blue-900/60 text-blue-700 dark:text-blue-300 flex items-center justify-center shrink-0 border border-blue-300 dark:border-blue-700">
            <Activity className="w-6 h-6" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h4 className="text-sm font-bold text-slate-900 dark:text-white">
                {translations.active_chronic_conditions || translations.chronic_conditions || "Active Chronic Conditions"}
              </h4>
              <span className="px-2 py-0.5 bg-blue-100 dark:bg-blue-900/80 text-blue-800 dark:text-blue-200 text-[11px] font-extrabold rounded-full border border-blue-200 dark:border-blue-800">
                {conditions.length}
              </span>
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              {translations.chronic_conditions_hint || "Documented long-term health morbidities and management plans."}
            </p>
          </div>
        </div>
      </div>

      {/* Conditions Chip Badges */}
      <div className="flex flex-wrap items-center gap-2 pt-1">
        {conditions.map((item) => {
          const badge = getStatusBadge(item.status);
          const icdCode = item.icd10_code || item.icd10Code;
          const diagDate = item.diagnosed_date || item.diagnosedYear;

          return (
            <div
              key={item.id || item.name}
              className="inline-flex items-center gap-2 px-3 py-1.5 rounded-xl text-xs font-semibold bg-white dark:bg-[#0E1726] border-2 border-slate-200/90 dark:border-slate-800 shadow-2xs hover:border-slate-300 dark:hover:border-slate-700 transition"
            >
              {icdCode && (
                <span className="px-1.5 py-0.5 rounded-md bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 font-mono text-[10px] font-bold border border-blue-200 dark:border-blue-800">
                  {icdCode}
                </span>
              )}
              <span className="font-bold text-slate-900 dark:text-slate-100">{item.name}</span>

              {diagDate && (
                <span className="inline-flex items-center gap-1 text-[11px] text-slate-400 dark:text-slate-500">
                  <Calendar className="w-3 h-3" />
                  <span>{diagDate}</span>
                </span>
              )}

              <span
                className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[10px] font-extrabold uppercase tracking-wider border ${badge.classes}`}
              >
                <span className={`w-1.5 h-1.5 rounded-full ${badge.dot}`} />
                <span>{badge.label}</span>
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

/*
 * File Name: clinical_alerts_banner.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/medical_record
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Unified, visually balanced clinical safety alerts banner presenting critical allergy warnings and active chronic conditions side-by-side with equal height grid alignment, compact clinical chips, and dark/light mode tokens.
 */

"use client";

import React from "react";
import {
  ShieldAlert,
  ShieldCheck,
  AlertCircle,
  Activity,
  HeartPulse,
  Info,
  RefreshCw,
  CheckCircle2,
} from "lucide-react";
import { AllergyItem, ChronicCondition } from "@/types/medical_record";
import { useTranslation } from "@/context/language_context";

interface ClinicalAlertsBannerProps {
  allergies?: AllergyItem[];
  conditions?: ChronicCondition[];
  isLoading?: boolean;
  isError?: boolean;
  onRetry?: () => void;
}

export default function ClinicalAlertsBanner({
  allergies = [],
  conditions = [],
  isLoading = false,
  isError = false,
  onRetry,
}: ClinicalAlertsBannerProps) {
  const { translations } = useTranslation();

  if (isLoading) {
    return (
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 w-full items-stretch animate-pulse">
        <div className="rounded-2xl border-2 border-slate-200 dark:border-slate-800 bg-slate-100 dark:bg-[#131E35] p-4.5 h-36 flex flex-col justify-between" />
        <div className="rounded-2xl border-2 border-slate-200 dark:border-slate-800 bg-slate-100 dark:bg-[#131E35] p-4.5 h-36 flex flex-col justify-between" />
      </div>
    );
  } else {
    // No action needed
  }

  if (isError) {
    return (
      <div className="w-full bg-amber-50 dark:bg-amber-950/40 border-2 border-amber-200 dark:border-amber-800 rounded-2xl p-4 md:p-5 flex items-center justify-between gap-4 text-start">
        <div className="flex items-center gap-3">
          <AlertCircle className="w-6 h-6 text-amber-600 dark:text-amber-400 shrink-0" />
          <div>
            <p className="text-xs font-bold text-amber-900 dark:text-amber-200">
              {translations.unable_to_load_allergies || "Unable to load patient clinical safety records"}
            </p>
            <p className="text-[11px] text-amber-700 dark:text-amber-300">
              An error occurred while retrieving clinical alert and morbidity profiles.
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
  } else {
    // No action needed
  }

  const hasAllergies = allergies && allergies.length > 0;
  const hasConditions = conditions && conditions.length > 0;

  const getConditionStatusStyle = (status?: string) => {
    const s = (status || "").toLowerCase();
    if ("active" === s) {
      return {
        label: translations.status_active || translations.active || "Active",
        dotColor: "bg-amber-500",
        badgeColor: "text-amber-700 dark:text-amber-400 font-bold",
      };
    } else if ("managed" === s) {
      return {
        label: translations.status_managed || translations.managed || "Managed",
        dotColor: "bg-sky-500",
        badgeColor: "text-sky-700 dark:text-sky-400 font-bold",
      };
    } else {
      return {
        label: translations.status_controlled || translations.controlled || "Controlled",
        dotColor: "bg-emerald-500",
        badgeColor: "text-emerald-700 dark:text-emerald-400 font-bold",
      };
    }
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 w-full items-stretch text-start">
      {/* 1. Left Card — Critical Allergy Alert (Red/Rose) */}
      {hasAllergies ? (
        <div className="rounded-2xl border border-red-200/80 dark:border-red-900/40 bg-red-50/60 dark:bg-red-950/20 p-4.5 flex flex-col justify-between relative overflow-hidden h-full shadow-xs space-y-3">
          {/* Subtle Trailing Corner Watermark Icon */}
          <ShieldAlert className="absolute -end-3 -bottom-3 w-28 h-28 text-red-500/10 dark:text-red-400/5 pointer-events-none" />

          {/* Header */}
          <div className="flex items-center gap-3 z-10">
            <div className="w-10 h-10 rounded-xl bg-red-100 dark:bg-red-900/60 text-red-700 dark:text-red-300 flex items-center justify-center shrink-0 border border-red-300/80 dark:border-red-700/80 shadow-2xs">
              <ShieldAlert className="w-5 h-5 animate-pulse" />
            </div>
            <div className="overflow-hidden min-w-0 flex-1">
              <div className="flex items-center gap-2">
                <h4 className="text-sm font-bold text-red-950 dark:text-red-100 truncate">
                  {translations.critical_allergy_alert || translations.active_allergies || "Critical Clinical Allergy Alert"}
                </h4>
                <span className="px-2 py-0.5 bg-red-200/80 dark:bg-red-900/80 text-red-800 dark:text-red-200 text-[11px] font-extrabold rounded-full border border-red-300 dark:border-red-700 shrink-0">
                  {allergies.length}
                </span>
              </div>
              <p className="text-xs text-red-700/90 dark:text-red-300/90 truncate">
                {translations.allergy_alert_sub || "Exercise extreme caution during prescribing and diagnostic administration."}
              </p>
            </div>
          </div>

          {/* Badges Flex-Wrap Row */}
          <div className="flex flex-wrap items-center gap-2 pt-0.5 z-10">
            {allergies.map((alg) => {
              const isSevere = "SEVERE" === alg.severity?.toUpperCase();
              const isModerate = "MODERATE" === alg.severity?.toUpperCase();
              return (
                <div
                  key={alg.id || alg.name}
                  className="inline-flex items-center gap-2 px-3 py-1.5 rounded-xl border border-red-300/80 dark:border-red-800 bg-white dark:bg-[#131E35] text-xs font-medium text-red-950 dark:text-red-200 shadow-2xs hover:border-red-400 dark:hover:border-red-700 transition"
                >
                  <Info className="w-3.5 h-3.5 text-red-500 shrink-0" />
                  <span className="font-bold text-slate-900 dark:text-white">{alg.name}</span>
                  <span
                    className={`uppercase text-[10px] tracking-wider font-extrabold px-1.5 py-0.5 rounded-md border ${
                      isSevere
                        ? "bg-red-100 dark:bg-red-900/70 text-red-700 dark:text-red-300 border-red-200 dark:border-red-800"
                        : isModerate
                        ? "bg-amber-100 dark:bg-amber-900/70 text-amber-800 dark:text-amber-200 border-amber-200 dark:border-amber-800"
                        : "bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-700"
                    }`}
                  >
                    {isSevere
                      ? translations.severity_severe || "Severe"
                      : isModerate
                      ? translations.severity_moderate || "Moderate"
                      : translations.severity_mild || "Mild"}
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      ) : (
        /* Empty Allergy State */
        <div className="rounded-2xl border border-emerald-200/80 dark:border-emerald-900/40 bg-emerald-50/60 dark:bg-emerald-950/20 p-4.5 flex flex-col justify-between relative overflow-hidden h-full shadow-xs space-y-3">
          <ShieldCheck className="absolute -end-3 -bottom-3 w-28 h-28 text-emerald-500/10 dark:text-emerald-400/5 pointer-events-none" />
          <div className="flex items-center justify-between z-10">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-emerald-100 dark:bg-emerald-900/60 text-emerald-700 dark:text-emerald-300 flex items-center justify-center shrink-0 border border-emerald-300/80 dark:border-emerald-700/80">
                <ShieldCheck className="w-5 h-5" />
              </div>
              <div>
                <h4 className="text-sm font-bold text-emerald-950 dark:text-emerald-100">
                  {translations.no_allergies || translations.no_known_allergies || "No Known Drug Allergies"}
                </h4>
                <p className="text-xs text-emerald-700/90 dark:text-emerald-400">
                  Zero active contraindication alerts recorded for this patient.
                </p>
              </div>
            </div>
            <span className="hidden sm:inline-flex items-center gap-1 px-2.5 py-1 bg-emerald-100 dark:bg-emerald-900/60 text-emerald-800 dark:text-emerald-300 font-bold text-[11px] rounded-full border border-emerald-300 dark:border-emerald-700 whitespace-nowrap">
              ✓ {translations.status_controlled || "Clear"}
            </span>
          </div>
        </div>
      )}

      {/* 2. Right Card — Active Chronic Conditions (Indigo/Blue/Slate) */}
      {hasConditions ? (
        <div className="rounded-2xl border border-blue-200/80 dark:border-blue-900/40 bg-blue-50/50 dark:bg-blue-950/20 p-4.5 flex flex-col justify-between relative overflow-hidden h-full shadow-xs space-y-3">
          {/* Subtle Trailing Corner Watermark Icon */}
          <HeartPulse className="absolute -end-3 -bottom-3 w-28 h-28 text-blue-500/10 dark:text-blue-400/5 pointer-events-none" />

          {/* Header */}
          <div className="flex items-center gap-3 z-10">
            <div className="w-10 h-10 rounded-xl bg-blue-100 dark:bg-blue-900/60 text-blue-700 dark:text-blue-300 flex items-center justify-center shrink-0 border border-blue-300/80 dark:border-blue-700/80 shadow-2xs">
              <Activity className="w-5 h-5" />
            </div>
            <div className="overflow-hidden min-w-0 flex-1">
              <div className="flex items-center gap-2">
                <h4 className="text-sm font-bold text-slate-900 dark:text-white truncate">
                  {translations.active_chronic_conditions || translations.chronic_conditions || "Active Chronic Conditions"}
                </h4>
                <span className="px-2 py-0.5 bg-blue-100 dark:bg-blue-900/80 text-blue-800 dark:text-blue-200 text-[11px] font-extrabold rounded-full border border-blue-200 dark:border-blue-800 shrink-0">
                  {conditions.length}
                </span>
              </div>
              <p className="text-xs text-slate-600 dark:text-slate-400 truncate">
                {translations.chronic_conditions_sub || "Documented long-term comorbidities requiring drug-disease contraindication checks."}
              </p>
            </div>
          </div>

          {/* Compact Chips Row */}
          <div className="flex flex-wrap items-center gap-2 pt-0.5 z-10">
            {conditions.map((item) => {
              const statusStyle = getConditionStatusStyle(item.status);
              const icdCode = item.icd10_code || item.icd10Code;

              return (
                <div
                  key={item.id || item.name}
                  className="inline-flex items-center gap-2 px-3 py-1.5 rounded-xl border border-blue-200 dark:border-blue-800/80 bg-white dark:bg-[#131E35] text-xs font-medium text-slate-800 dark:text-slate-100 shadow-2xs hover:border-blue-300 dark:hover:border-blue-700 transition"
                >
                  {icdCode && (
                    <span className="px-1.5 py-0.5 rounded bg-blue-100 dark:bg-blue-900/50 text-blue-700 dark:text-blue-300 font-mono text-[11px] font-bold border border-blue-200 dark:border-blue-800">
                      {icdCode}
                    </span>
                  )}
                  <span className="font-bold text-slate-900 dark:text-slate-100">{item.name}</span>
                  <span className={`inline-flex items-center gap-1 text-[11px] ${statusStyle.badgeColor}`}>
                    <span className={`w-1.5 h-1.5 rounded-full ${statusStyle.dotColor}`} />
                    <span>{statusStyle.label}</span>
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      ) : (
        /* Empty Conditions State */
        <div className="rounded-2xl border border-slate-200/80 dark:border-slate-800 bg-slate-50/80 dark:bg-[#131E35]/60 p-4.5 flex flex-col justify-between relative overflow-hidden h-full shadow-xs space-y-3">
          <HeartPulse className="absolute -end-3 -bottom-3 w-28 h-28 text-slate-400/10 dark:text-slate-500/5 pointer-events-none" />
          <div className="flex items-center justify-between z-10">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 flex items-center justify-center shrink-0 border border-slate-300 dark:border-slate-700">
                <HeartPulse className="w-5 h-5" />
              </div>
              <div>
                <h4 className="text-sm font-bold text-slate-900 dark:text-slate-100">
                  {translations.no_chronic_conditions || "No Recorded Chronic Conditions"}
                </h4>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  {translations.no_chronic_conditions_desc || "Patient has zero active chronic morbidities documented on profile."}
                </p>
              </div>
            </div>
            <span className="hidden sm:inline-flex items-center gap-1 px-2.5 py-1 bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-bold text-[11px] rounded-full border border-slate-300 dark:border-slate-700 whitespace-nowrap">
              <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500" />
              <span>{translations.status_controlled || "Clear"}</span>
            </span>
          </div>
        </div>
      )}
    </div>
  );
}

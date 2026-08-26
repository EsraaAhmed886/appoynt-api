/*
 * File Name: live_queue_bar.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, next/navigation, lucide-react, @/types/dashboard, @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Live Waiting Room & Next-Up Consultation Queue strip rendering patient queue details, wait timer, live consultation action CTA, and pending lab alerts.
 */

"use client";

import React from "react";
import { useRouter } from "next/navigation";
import { UserCheck, Clock, ArrowRight, Activity, FileText, ChevronRight, Check } from "lucide-react";
import { QueuePatient } from "@/types/dashboard";
import { useTranslation } from "@/context/language_context";

export interface LiveQueueBarProps {
  current_patient?: QueuePatient | null;
  total_waiting_count?: number;
  pending_lab_count?: number;
  on_start_consultation?: (patient_id: string) => void;
  on_view_queue?: () => void;
  on_view_pending_labs?: () => void;
}

export const LiveQueueBar: React.FC<LiveQueueBarProps> = ({
  current_patient,
  total_waiting_count = 0,
  pending_lab_count = 0,
  on_start_consultation,
  on_view_queue,
  on_view_pending_labs,
}) => {
  const { t } = useTranslation();
  const router = useRouter();

  const handle_start_consultation = () => {
    if (current_patient) {
      if (on_start_consultation) {
        on_start_consultation(current_patient.id);
      } else {
        router.push(`/medical-records?patient_id=${current_patient.id}`);
      }
    } else {
      // No active patient in queue
    }
  };

  const handle_view_queue = () => {
    if (on_view_queue) {
      on_view_queue();
    } else {
      router.push("/appointments");
    }
  };

  const handle_view_pending_labs = () => {
    if (on_view_pending_labs) {
      on_view_pending_labs();
    } else {
      router.push("/medical-records");
    }
  };

  // Empty Waiting Room State
  if (!current_patient && total_waiting_count === 0) {
    return (
      <div className="w-full bg-slate-50/80 dark:bg-slate-900/60 border border-slate-200/80 dark:border-slate-800 rounded-2xl p-4 flex items-center justify-between shadow-2xs">
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-xl bg-emerald-50 dark:bg-emerald-950/40 text-emerald-600 dark:text-emerald-400 flex items-center justify-center font-bold">
            <Check className="w-4 h-4" />
          </div>
          <div>
            <p className="text-sm font-semibold text-slate-900 dark:text-white">
              {t("queue_empty")}
            </p>
            <p className="text-xs text-slate-500 dark:text-slate-400">
              {t("queue_empty_desc")}
            </p>
          </div>
        </div>
      </div>
    );
  } else {
    // Patients present in queue
  }

  const waiting_time_text = t("waiting_time").replace(
    "{minutes}",
    (current_patient?.waiting_minutes ?? 0).toString()
  );

  const in_queue_text = t("in_queue_count").replace(
    "{count}",
    total_waiting_count.toString()
  );

  const pending_labs_text = t("labs_pending").replace(
    "{count}",
    pending_lab_count.toString()
  );

  return (
    <div className="w-full bg-gradient-to-r from-blue-50/80 via-indigo-50/40 to-white dark:from-slate-900 dark:via-slate-900 dark:to-slate-800/80 border border-blue-100/90 dark:border-slate-800 rounded-2xl p-4 sm:p-4.5 shadow-xs transition-all">
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        {/* Left: Live Indicator & Patient Info */}
        <div className="flex items-center gap-3.5">
          {/* Live Pulsing Avatar/Badge */}
          <div className="relative shrink-0">
            <div className="w-11 h-11 rounded-xl bg-blue-600 text-white font-bold flex items-center justify-center text-sm shadow-md shadow-blue-500/20">
              {current_patient?.token_number || "NEXT"}
            </div>
            <span className="absolute -top-1 -end-1 flex h-3 w-3">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75" />
              <span className="relative inline-flex rounded-full h-3 w-3 bg-emerald-500" />
            </span>
          </div>

          <div className="space-y-0.5 text-start">
            <div className="flex items-center gap-2 flex-wrap">
              <span className="text-[11px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md bg-blue-100 dark:bg-blue-950/80 text-blue-700 dark:text-blue-300">
                {t("next_in_queue")}
              </span>
              {current_patient?.clinic_name ? (
                <span className="text-xs text-slate-500 dark:text-slate-400">
                  • {current_patient.clinic_name}
                </span>
              ) : null}
            </div>
            <h4 className="text-base font-bold text-slate-900 dark:text-white flex items-center gap-2">
              <span>{current_patient?.patient_name}</span>
              {current_patient?.appointment_time ? (
                <span className="text-xs font-normal text-slate-500 dark:text-slate-400">
                  ({current_patient.appointment_time})
                </span>
              ) : null}
            </h4>
          </div>
        </div>

        {/* Middle: Waiting Time & Alert Pills */}
        <div className="flex items-center gap-2 sm:gap-3 flex-wrap">
          {/* Wait Duration */}
          <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-white/80 dark:bg-slate-800 border border-slate-200/70 dark:border-slate-700 text-xs font-medium text-slate-700 dark:text-slate-300 shadow-2xs">
            <Clock className="w-3.5 h-3.5 text-amber-500" />
            <span>{waiting_time_text}</span>
          </div>

          {/* Total in Queue Pill */}
          <button
            type="button"
            onClick={handle_view_queue}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-white/80 dark:bg-slate-800 border border-slate-200/70 dark:border-slate-700 hover:border-blue-300 dark:hover:border-blue-700 text-xs font-medium text-slate-700 dark:text-slate-300 transition-colors cursor-pointer shadow-2xs"
          >
            <UserCheck className="w-3.5 h-3.5 text-blue-600 dark:text-blue-400" />
            <span>{in_queue_text}</span>
            <ChevronRight className="w-3 h-3 text-slate-400 rtl:rotate-180" />
          </button>

          {/* Pending Lab Results Pill */}
          {pending_lab_count > 0 ? (
            <button
              type="button"
              onClick={handle_view_pending_labs}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 dark:bg-amber-950/40 border border-amber-200 dark:border-amber-900/60 hover:bg-amber-100/70 text-xs font-semibold text-amber-800 dark:text-amber-300 transition-colors cursor-pointer shadow-2xs"
            >
              <FileText className="w-3.5 h-3.5 text-amber-600 dark:text-amber-400" />
              <span>{pending_labs_text}</span>
            </button>
          ) : null}
        </div>

        {/* Right: Consultation Action Button */}
        <div className="flex items-center gap-2 shrink-0">
          <button
            type="button"
            onClick={handle_start_consultation}
            className="w-full sm:w-auto inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white text-xs sm:text-sm font-semibold shadow-md shadow-blue-600/20 transition-all hover:scale-[1.01] cursor-pointer"
          >
            <Activity className="w-4 h-4" />
            <span>{t("start_consultation")}</span>
            <ArrowRight className="w-4 h-4 rtl:rotate-180" />
          </button>
        </div>
      </div>
    </div>
  );
};

export default LiveQueueBar;

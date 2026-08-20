/*
 * File Name: receptionist_stats_strip.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/receptionist_context
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Top KPI metrics strip rendering real-time statistics for total receptionists, active accounts, inactive accounts, and covered clinic locations.
 */

"use client";

import React from "react";
import { Users, UserCheck, UserX, Building2 } from "lucide-react";
import { useReceptionists } from "@/context/receptionist_context";
import { useTranslation } from "@/context/language_context";

export default function ReceptionistStatsStrip() {
  const { stats, isLoading } = useReceptionists();
  const { translations } = useTranslation();

  const cards = [
    {
      id: "total",
      label: translations.total_receptionists || "Total Receptionists",
      value: stats.total,
      icon: Users,
      color: "blue",
      bgClass: "bg-blue-50 dark:bg-blue-950/40 border-blue-200 dark:border-blue-800 text-blue-600 dark:text-blue-400",
      indicator: null,
    },
    {
      id: "active",
      label: translations.active_receptionists || "Active Accounts",
      value: stats.active,
      icon: UserCheck,
      color: "emerald",
      bgClass: "bg-emerald-50 dark:bg-emerald-950/40 border-emerald-200 dark:border-emerald-800 text-emerald-600 dark:text-emerald-400",
    },
    {
      id: "inactive",
      label: translations.inactive_receptionists || "Inactive Accounts",
      value: stats.inactive,
      icon: UserX,
      color: "slate",
      bgClass: "bg-slate-100 dark:bg-slate-800 border-slate-200 dark:border-slate-700 text-slate-600 dark:text-slate-400",
    },
    {
      id: "covered_clinics",
      label: translations.covered_clinics || "Covered Clinics",
      value: stats.covered_clinics,
      icon: Building2,
      color: "indigo",
      bgClass: "bg-indigo-50 dark:bg-indigo-950/40 border-indigo-200 dark:border-indigo-800 text-indigo-600 dark:text-indigo-400",
    },
  ];

  return (
    <div className="w-full grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      {cards.map((card) => {
        const Icon = card.icon;
        return (
          <div
            key={card.id}
            className="p-4 md:p-5 bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs transition hover:border-slate-300 dark:hover:border-slate-700"
          >
            <div className="flex items-center justify-between gap-2 mb-3">
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider truncate">
                {card.label}
              </span>
              <div className={`p-2.5 rounded-xl border ${card.bgClass}`}>
                <Icon className="w-4 h-4" />
              </div>
            </div>

            <div className="flex items-baseline gap-2">
              {isLoading ? (
                <div className="h-8 w-12 bg-slate-200 dark:bg-slate-700 rounded animate-pulse" />
              ) : (
                <span className="text-2xl md:text-3xl font-extrabold text-slate-900 dark:text-white">
                  {card.value}
                </span>
              )}
            </div>
          </div>
        );
      })}
    </div>
  );
}

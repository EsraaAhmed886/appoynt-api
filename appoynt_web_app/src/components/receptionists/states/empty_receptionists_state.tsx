/*
 * File Name: empty_receptionists_state.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Empty state presentation rendered when no receptionist accounts exist in the clinic system, providing an onboarding prompt to create the first receptionist.
 */

"use client";

import React from "react";
import { Users, Plus } from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface EmptyReceptionistsStateProps {
  onAddClick: () => void;
}

export default function EmptyReceptionistsState({ onAddClick }: EmptyReceptionistsStateProps) {
  const { translations } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center p-8 md:p-12 text-center bg-white dark:bg-[#0E1726] border-2 border-dashed border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs animate-in fade-in">
      <div className="p-4 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-3xl mb-4 border border-blue-200 dark:border-blue-800">
        <Users className="w-10 h-10" />
      </div>

      <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-2">
        {translations.no_receptionists_title || "No Receptionists Found"}
      </h3>

      <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 max-w-md mb-6 leading-relaxed">
        {translations.no_receptionists_desc || "Get started by creating your first clinic receptionist account."}
      </p>

      <button
        type="button"
        onClick={onAddClick}
        className="inline-flex items-center gap-2 px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md transition cursor-pointer"
      >
        <Plus className="w-4 h-4" />
        <span>{translations.add_receptionist || "Add Receptionist"}</span>
      </button>
    </div>
  );
}

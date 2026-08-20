/*
 * File Name: no_clinics_state.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - next/link
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Guard fallback state rendered when a physician has zero registered clinics, explaining the prerequisite and providing a call-to-action to create a clinic first.
 */

"use client";

import React from "react";
import Link from "next/link";
import { Building2, Plus, AlertCircle } from "lucide-react";
import { useTranslation } from "@/context/language_context";

export default function NoClinicsState() {
  const { translations } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center p-8 md:p-12 text-center bg-white dark:bg-[#0E1726] border-2 border-dashed border-amber-200 dark:border-amber-900/50 rounded-2xl shadow-xs animate-in fade-in">
      <div className="p-4 bg-amber-50 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400 rounded-3xl mb-4 border border-amber-200 dark:border-amber-800">
        <Building2 className="w-10 h-10" />
      </div>

      <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-2">
        {translations.no_clinics_title || "No Clinics Available"}
      </h3>

      <p className="text-xs md:text-sm text-slate-500 dark:text-slate-400 max-w-md mb-6 leading-relaxed">
        {translations.no_clinics_desc || "You must create at least one clinic before adding receptionist accounts."}
      </p>

      <Link
        href="/clinics"
        className="inline-flex items-center gap-2 px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md transition cursor-pointer"
      >
        <Plus className="w-4 h-4" />
        <span>{translations.create_clinic_cta || "Create Clinic First"}</span>
      </Link>
    </div>
  );
}

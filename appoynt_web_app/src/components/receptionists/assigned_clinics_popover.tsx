/*
 * File Name: assigned_clinics_popover.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/receptionist
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Popover card and modal popup listing all assigned clinic locations for a receptionist with real-time active/inactive status badges.
 */

"use client";

import React, { useEffect, useRef } from "react";
import { Building2, X, AlertTriangle, CheckCircle2 } from "lucide-react";
import { AssignedClinic } from "@/types/receptionist";
import { useTranslation } from "@/context/language_context";

interface AssignedClinicsPopoverProps {
  clinics: AssignedClinic[];
  receptionistName: string;
  isOpen: boolean;
  onClose: () => void;
}

export default function AssignedClinicsPopover({
  clinics,
  receptionistName,
  isOpen,
  onClose,
}: AssignedClinicsPopoverProps) {
  const { translations } = useTranslation();
  const modalRef = useRef<HTMLDivElement>(null);

  // Close on ESC
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        onClose();
      } else {
        // No action needed
      }
    };
    if (isOpen) {
      window.addEventListener("keydown", handleKeyDown);
    } else {
      // Modal closed
    }
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, onClose]);

  if (!isOpen) {
    return null;
  } else {
    // Render popover
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/60 backdrop-blur-xs animate-in fade-in duration-150">
      <div
        ref={modalRef}
        className="w-full max-w-md bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-2xl p-5 space-y-4 animate-in zoom-in-95 duration-150"
      >
        <div className="flex items-center justify-between pb-3 border-b-2 border-slate-100 dark:border-slate-800">
          <div className="flex items-center gap-2.5">
            <div className="p-2 bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 rounded-xl border border-indigo-200 dark:border-indigo-800">
              <Building2 className="w-5 h-5" />
            </div>
            <div>
              <h4 className="text-sm font-bold text-slate-900 dark:text-white">
                {translations.col_assigned_clinics || "Assigned Clinics"}
              </h4>
              <p className="text-xs text-slate-500 dark:text-slate-400 truncate max-w-[220px]">
                {receptionistName}
              </p>
            </div>
          </div>

          <button
            type="button"
            onClick={onClose}
            className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 transition cursor-pointer"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="max-h-64 overflow-y-auto space-y-2 pe-1">
          {clinics.map((clinic) => (
            <div
              key={clinic.id}
              className={`p-3 rounded-xl border flex items-center justify-between gap-3 ${
                clinic.is_active
                  ? "bg-slate-50 dark:bg-[#131E35] border-slate-200 dark:border-slate-700 text-slate-900 dark:text-slate-100"
                  : "bg-amber-50/70 dark:bg-amber-950/30 border-amber-200 dark:border-amber-900/60 text-amber-900 dark:text-amber-200"
              }`}
            >
              <div className="flex items-center gap-2.5 min-w-0">
                <Building2 className={`w-4 h-4 shrink-0 ${clinic.is_active ? "text-indigo-500" : "text-amber-500"}`} />
                <span className="text-xs md:text-sm font-bold truncate">
                  {clinic.name}
                </span>
              </div>

              {clinic.is_active ? (
                <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[11px] font-bold bg-emerald-100 dark:bg-emerald-950/80 text-emerald-700 dark:text-emerald-300 shrink-0">
                  <CheckCircle2 className="w-3 h-3" />
                  <span>{translations.status_active || "Active"}</span>
                </span>
              ) : (
                <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md text-[11px] font-bold bg-amber-100 dark:bg-amber-900/80 text-amber-800 dark:text-amber-300 shrink-0">
                  <AlertTriangle className="w-3 h-3" />
                  <span>{translations.inactive_clinic || "Inactive Clinic"}</span>
                </span>
              )}
            </div>
          ))}
        </div>

        <div className="pt-2 flex justify-end">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs font-bold rounded-xl transition cursor-pointer"
          >
            {translations.close || "Close"}
          </button>
        </div>
      </div>
    </div>
  );
}

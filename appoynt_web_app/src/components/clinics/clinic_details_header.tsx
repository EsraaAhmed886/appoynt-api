/**
 * File Name : clinic_details_header.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.1.0
 * Dependencies : react, next/link, @/context/language_context
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Header banner component displaying back link, clinic name, active status badge, and clinic code.
 */

"use client";

import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { useTranslation } from "@/context/language_context";

type ClinicDetailsHeaderProps = {
  clinic_name: string;
  status: string;
  clinic_code?: string;
};

export default function ClinicDetailsHeader({
  clinic_name,
  status,
  clinic_code = "CLN-001",
}: ClinicDetailsHeaderProps) {
  const { translations } = useTranslation();
  const is_active = "Active" === status;

  return (
    <div className="mb-6 space-y-4">
      {/* Back to Clinics Link */}
      <div>
        <Link
          href="/clinics"
          className="inline-flex items-center gap-2 text-sm font-semibold text-app-primary hover:underline transition-all"
        >
          <ArrowLeft size={16} className="rtl:rotate-180" />
          <span>{translations.lbl_back_to_clinics}</span>
        </Link>
      </div>

      {/* Main Header Container */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div className="space-y-1">
          {/* Clinic Name + Active Status Badge */}
          <div className="flex flex-wrap items-center gap-3">
            <h1 className="text-2xl font-bold text-app-text-primary sm:text-3xl">
              {clinic_name || "—"}
            </h1>

            <span
              className={`inline-flex items-center rounded-md px-2.5 py-0.5 text-xs font-semibold ${
                is_active
                  ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-400"
                  : "bg-red-100 text-red-700 dark:bg-red-950/40 dark:text-red-400"
              }`}
            >
              {is_active
                ? translations.clinic_status_active
                : translations.clinic_status_inactive}
            </span>
          </div>

          {/* Clinic Code */}
          <p className="text-xs font-medium text-app-text-secondary sm:text-sm">
            {translations.lbl_clinic_code}: {clinic_code}
          </p>
        </div>
      </div>
    </div>
  );
}


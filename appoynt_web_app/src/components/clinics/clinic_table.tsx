/*
 * File Name: clinic_table.tsx
 * Author: shimaa salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 *   - @/types/clinic
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Reusable localized table component displaying clinic list rows with delete action.
 */

"use client";

import { Trash2 } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { Clinic } from "@/types/clinic";

type ClinicTableProps = {
  clinics: Clinic[];
  on_delete_clinic: (clinic_id: number) => void;
};

export default function ClinicTable({
  clinics,
  on_delete_clinic,
}: ClinicTableProps) {
  const { translations } = useTranslation();

  return (
    <div className="mt-6 overflow-x-auto rounded-xl border border-app-border bg-app-surface shadow-sm">
      <table className="min-w-[900px] w-full border-collapse">
        <thead className="border-b border-app-border bg-app-input_fill">
          <tr className="text-start text-sm text-app-text-secondary">
            <th className="px-4 py-3.5 text-start font-semibold text-sm lg:px-6 lg:py-4">
              {translations.th_clinic_name}
            </th>
            <th className="px-4 py-3.5 text-start font-semibold text-sm lg:px-6 lg:py-4">
              {translations.th_location}
            </th>
            <th className="px-4 py-3.5 text-start font-semibold text-sm lg:px-6 lg:py-4">
              {translations.th_phone}
            </th>
            <th className="px-4 py-3.5 text-start font-semibold text-sm lg:px-6 lg:py-4">
              {translations.th_consultation_fee}
            </th>
            <th className="px-4 py-3.5 text-start font-semibold text-sm lg:px-6 lg:py-4">
              {translations.th_working_days}
            </th>
            <th className="px-4 py-3.5 text-start font-semibold text-sm lg:px-6 lg:py-4">
              {translations.th_status}
            </th>
            <th className="px-4 py-3.5 text-center font-semibold text-sm lg:px-6 lg:py-4">
              {translations.th_actions}
            </th>
          </tr>
        </thead>

        <tbody className="divide-y divide-app-border">
          {clinics.map((clinic) => {
            const fee_value =
              clinic.consultation_fee || clinic.consultationFee || "—";
            const days_value =
              clinic.working_days || clinic.workingDays || "—";
            const is_active = "Active" === clinic.status;

            return (
              <tr
                key={clinic.id}
                className="border-t border-app-border text-app-text-primary transition-colors hover:bg-app-input_fill/60"
              >
                <td className="px-4 py-3.5 text-start text-sm font-semibold lg:px-6 lg:py-4">
                  {clinic.name}
                </td>

                <td className="px-4 py-3.5 text-start text-sm lg:px-6 lg:py-4">
                  {clinic.location}
                </td>

                <td className="px-4 py-3.5 text-start text-sm lg:px-6 lg:py-4">
                  {clinic.phone}
                </td>

                <td className="px-4 py-3.5 text-start text-sm font-medium lg:px-6 lg:py-4">
                  {fee_value}
                </td>

                <td className="px-4 py-3.5 text-start text-sm lg:px-6 lg:py-4">
                  {days_value}
                </td>

                <td className="px-4 py-3.5 text-start text-sm lg:px-6 lg:py-4">
                  <span
                    className={`inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold ${
                      is_active
                        ? "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400"
                        : "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400"
                    }`}
                  >
                    {is_active
                      ? translations.clinic_status_active
                      : translations.clinic_status_inactive}
                  </span>
                </td>

                <td className="px-4 py-3.5 text-sm lg:px-6 lg:py-4">
                  <div className="flex items-center justify-center">
                    <button
                      type="button"
                      onClick={() => on_delete_clinic(clinic.id)}
                      aria-label="Delete Clinic"
                      className="rounded-lg p-1.5 text-red-500 transition hover:bg-red-500/10 hover:text-red-600 hover:scale-105"
                    >
                      <Trash2 className="h-4.5 w-4.5" />
                    </button>
                  </div>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
/*
 * File Name: appointment_queue_list.tsx
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.5.0
 * Dependencies: react, lucide-react, @/types/appointment, @/context/language_context
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 31/08/2026]
 * Description: Client component rendering queued patients table, localized waiting status badges, estimated wait times, and exact empty queue state with no Actions column.
 */

"use client";

import { Users } from "lucide-react";
import { queue_item } from "@/types/appointment";
import { useTranslation } from "@/context/language_context";

type appointment_queue_list_props = {
  queue: queue_item[];
};

export default function appointment_queue_list({
  queue,
}: appointment_queue_list_props) {
  const { translations } = useTranslation();

  // Helper function to render status badges with full localization & Dark Mode support
  const render_status_badge = (status: queue_item["status"]) => {
    if ("in_consultation" === status) {
      return (
        <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800 dark:bg-emerald-950/60 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
          {translations.in_consultation_badge}
        </span>
      );
    } else if ("checked_in" === status) {
      return (
        <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-800 dark:bg-blue-950/60 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
          {translations.checked_in_badge}
        </span>
      );
    } else if ("waiting" === status) {
      return (
        <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 dark:bg-amber-950/60 dark:text-amber-300 border border-amber-200 dark:border-amber-800">
          {translations.waiting_badge}
        </span>
      );
    } else {
      return (
        <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-rose-100 text-rose-800 dark:bg-rose-950/60 dark:text-rose-300 border border-rose-200 dark:border-rose-800">
          {translations.not_arrived_badge}
        </span>
      );
    }
  };

  return (
    <div className="rounded-2xl bg-app-surface p-5 md:p-6 border border-app-border shadow-xs space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-bold text-app-text-primary flex items-center gap-2">
          {translations.queue_title}
          <span className="text-sm font-normal text-app-text-secondary">
            ({translations.patients_count_label.includes("{count}") ? translations.patients_count_label.replace("{count}", String(queue.length)) : `${queue.length} ${translations.patients_count_label}`})
          </span>
        </h3>
      </div>

      {/* Queue Table or Empty State */}
      {0 === queue.length ? (
        <div className="flex flex-col items-center justify-center p-8 md:p-12 text-center min-h-[260px] border border-transparent rounded-xl">
          <div className="flex h-16 w-16 items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800/80 mb-4">
            <Users className="h-8 w-8 text-app-text-secondary opacity-60" />
          </div>
          <h4 className="text-base font-bold text-app-text-primary">
            {translations.no_queue_patients_title}
          </h4>
          <p className="mt-1.5 text-xs text-app-text-secondary">
            {translations.no_queue_patients_desc}
          </p>

          <button
            type="button"
            disabled
            className="mt-6 px-5 py-2.5 rounded-xl border border-app-border/80 bg-app-bg/50 text-xs font-semibold text-app-primary opacity-60 cursor-not-allowed"
          >
            {translations.btn_view_all_queue}
          </button>
        </div>
      ) : (
        <>
          <div className="w-full overflow-x-auto">
            <table className="w-full text-left rtl:text-right text-xs">
              <thead>
                <tr className="border-b border-app-border/50 text-app-text-secondary font-semibold uppercase tracking-wider">
                  <th className="py-3 px-3">{translations.col_patient}</th>
                  <th className="py-3 px-3">{translations.col_type}</th>
                  <th className="py-3 px-3">{translations.col_status}</th>
                  <th className="py-3 px-3">{translations.col_eta}</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-app-border/30">
                {queue.map((item) => {
                  const visit_label =
                    "follow_up" === item.visit_type
                      ? translations.visit_type_follow_up
                      : translations.visit_type_new;

                  const gender_label =
                    "male" === item.patient.gender
                      ? translations.label_male
                      : translations.label_female;

                  return (
                    <tr
                      key={item.id}
                      className="hover:bg-app-bg/50 dark:hover:bg-app-bg/30 transition-colors group"
                    >
                      {/* Patient Name & Details (Patient Name remains EXACTLY as provided) */}
                      <td className="py-3.5 px-3">
                        <div className="flex items-center gap-3">
                          <div className="h-9 w-9 rounded-full bg-app-primary/10 text-app-primary flex items-center justify-center font-bold text-xs flex-shrink-0">
                            {item.patient.full_name.charAt(0)}
                          </div>
                          <div>
                            <span className="font-bold text-app-text-primary block text-sm">
                              {item.patient.full_name}
                            </span>
                            <span className="text-[11px] text-app-text-secondary">
                              {item.patient.age ?? 30} {translations.label_years},{" "}
                              {gender_label}
                            </span>
                          </div>
                        </div>
                      </td>

                      {/* Visit Type Badge */}
                      <td className="py-3.5 px-3">
                        <span className="px-2.5 py-0.5 rounded text-[11px] font-semibold bg-blue-100 text-blue-800 dark:bg-blue-950/60 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
                          {visit_label}
                        </span>
                      </td>

                      {/* Status Badge */}
                      <td className="py-3.5 px-3">
                        {render_status_badge(item.status)}
                      </td>

                      {/* ETA */}
                      <td className="py-3.5 px-3">
                        {item.estimated_wait_mins ? (
                          <span className="font-semibold text-emerald-600 dark:text-emerald-400">
                            {item.estimated_wait_mins} {translations.label_min}
                          </span>
                        ) : (
                          <span className="text-app-text-secondary">—</span>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          {/* View All Queue Button (Visible strictly when queue contains 6 or more patients) */}
          {queue.length >= 6 ? (
            <div className="pt-2 text-center border-t border-app-border/30">
              <button
                type="button"
                className="text-xs font-semibold text-app-primary hover:underline cursor-pointer"
              >
                {translations.btn_view_all_queue} &darr;
              </button>
            </div>
          ) : null}
        </>
      )}
    </div>
  );
}

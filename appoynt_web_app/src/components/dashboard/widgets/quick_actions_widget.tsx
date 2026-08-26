/*
 * File Name: quick_actions_widget.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.1.0
 * Dependencies: react, lucide-react, next/link, @/context/dashboard_context, @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Bottom widget rendering 3 permission-guarded quick action shortcut cards with compact top-aligned spacing for rapid clinic operations (BR-69).
 */

"use client";

import React from "react";
import Link from "next/link";
import { CalendarPlus, UserPlus, Building2, Zap, ArrowRight } from "lucide-react";
import { useDashboard } from "@/context/dashboard_context";
import { useTranslation } from "@/context/language_context";

export const QuickActionsWidget: React.FC = () => {
  const { can_add_appointment, can_add_receptionist, can_add_clinic } = useDashboard();
  const { t } = useTranslation();

  const actions = [
    {
      id: "add_appointment",
      title_key: "add_appointment",
      desc: "Schedule a new clinical consultation",
      href: "/appointments",
      icon: <CalendarPlus className="w-5 h-5 text-blue-600 dark:text-blue-400" />,
      bg_color:
        "bg-blue-50/60 dark:bg-blue-950/20 hover:bg-blue-50 dark:hover:bg-blue-950/40 border-blue-100 dark:border-blue-900/40",
      icon_container: "bg-blue-100 dark:bg-blue-900/60 text-blue-600 dark:text-blue-400",
      hover_text: "group-hover:text-blue-600 dark:group-hover:text-blue-400",
      visible: can_add_appointment,
    },
    {
      id: "add_receptionist",
      title_key: "add_receptionist",
      desc: "Provision front-desk staff access",
      href: "/clinics/receptionists",
      icon: <UserPlus className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />,
      bg_color:
        "bg-emerald-50/60 dark:bg-emerald-950/20 hover:bg-emerald-50 dark:hover:bg-emerald-950/40 border-emerald-100 dark:border-emerald-900/40",
      icon_container: "bg-emerald-100 dark:bg-emerald-900/60 text-emerald-600 dark:text-emerald-400",
      hover_text: "group-hover:text-emerald-600 dark:group-hover:text-emerald-400",
      visible: can_add_receptionist,
    },
    {
      id: "add_clinic",
      title_key: "add_clinic",
      desc: "Register a new branch or medical facility",
      href: "/clinics",
      icon: <Building2 className="w-5 h-5 text-purple-600 dark:text-purple-400" />,
      bg_color:
        "bg-purple-50/60 dark:bg-purple-950/20 hover:bg-purple-50 dark:hover:bg-purple-950/40 border-purple-100 dark:border-purple-900/40",
      icon_container: "bg-purple-100 dark:bg-purple-900/60 text-purple-600 dark:text-purple-400",
      hover_text: "group-hover:text-purple-600 dark:group-hover:text-purple-400",
      visible: can_add_clinic,
    },
  ].filter((a) => a.visible);

  return (
    <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 sm:p-6 shadow-xs hover:shadow-md transition-all flex flex-col justify-start h-full">
      {/* Widget Header */}
      <div className="flex items-center justify-between border-b border-gray-100 dark:border-gray-800/80 pb-3 mb-4">
        <div className="flex items-center gap-2">
          <Zap className="w-5 h-5 text-purple-600 dark:text-purple-400" />
          <h3 className="text-base font-bold text-gray-900 dark:text-white">
            {t("quick_actions")}
          </h3>
        </div>
      </div>

      {/* Action Buttons List: Compact Gap */}
      <div className="flex flex-col gap-3">
        {actions.map((action) => (
          <Link
            key={action.id}
            href={action.href}
            className={`group flex items-center justify-between p-3.5 rounded-xl border transition-all duration-200 cursor-pointer ${action.bg_color}`}
          >
            <div className="flex items-center gap-3">
              <div
                className={`w-9 h-9 rounded-lg flex items-center justify-center shrink-0 shadow-2xs ${action.icon_container}`}
              >
                {action.icon}
              </div>
              <div className="text-start">
                <p
                  className={`text-xs sm:text-sm font-bold text-gray-900 dark:text-white transition-colors ${action.hover_text}`}
                >
                  {/* @ts-expect-error dynamic key */}
                  {t(action.title_key)}
                </p>
                <p className="text-[10px] sm:text-[11px] text-gray-500 dark:text-gray-400">
                  {action.desc}
                </p>
              </div>
            </div>
            <ArrowRight className="w-4 h-4 text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white group-hover:translate-x-0.5 rtl:group-hover:-translate-x-0.5 transition-all" />
          </Link>
        ))}
      </div>
    </div>
  );
};

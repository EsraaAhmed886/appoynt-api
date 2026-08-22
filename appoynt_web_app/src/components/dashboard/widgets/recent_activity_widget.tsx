/*
 * File Name: recent_activity_widget.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, next/link, @/types/dashboard, @/context/dashboard_context, @/context/language_context, @/components/dashboard/states/dashboard_skeleton, @/components/dashboard/states/component_error_state
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Bottom widget rendering exactly 5 recent clinical events in reverse chronological order with categorized badge icons and relative timestamps (VR-23, AC-20).
 */

"use client";

import React from "react";
import Link from "next/link";
import {
  Calendar,
  CreditCard,
  CheckCircle,
  XCircle,
  UserPlus,
  FileText,
  Star,
  Activity,
  ArrowRight,
} from "lucide-react";
import { ActivityCategory } from "@/types/dashboard";
import { useDashboard } from "@/context/dashboard_context";
import { useTranslation } from "@/context/language_context";
import { WidgetSkeleton } from "@/components/dashboard/states/dashboard_skeleton";
import { ComponentErrorState } from "@/components/dashboard/states/component_error_state";

export const RecentActivityWidget: React.FC = () => {
  const { activities, activities_loading, activities_error, refresh_activities } = useDashboard();
  const { t, current_locale } = useTranslation();

  if (activities_loading) {
    return <WidgetSkeleton />;
  }

  if (activities_error) {
    return (
      <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 shadow-xs">
        <ComponentErrorState
          message_key="error_loading_activity"
          on_retry={refresh_activities}
          height="min-h-[260px]"
        />
      </div>
    );
  }

  // Format relative or concise timestamp
  const format_time = (iso_str: string) => {
    try {
      const date = new Date(iso_str);
      return date.toLocaleTimeString(current_locale === "ar" ? "ar-EG" : "en-US", {
        hour: "2-digit",
        minute: "2-digit",
        hour12: true,
      });
    } catch {
      return "—";
    }
  };

  // Map category to color and icon
  const get_category_config = (category: ActivityCategory) => {
    switch (category) {
      case "appointment_created":
      case "appointment_confirmed":
        return {
          icon: <Calendar className="w-4 h-4 text-emerald-600 dark:text-emerald-400" />,
          bg: "bg-emerald-50 dark:bg-emerald-950/60",
        };
      case "appointment_completed":
        return {
          icon: <CheckCircle className="w-4 h-4 text-blue-600 dark:text-blue-400" />,
          bg: "bg-blue-50 dark:bg-blue-950/60",
        };
      case "appointment_cancelled":
        return {
          icon: <XCircle className="w-4 h-4 text-red-600 dark:text-red-400" />,
          bg: "bg-red-50 dark:bg-red-950/60",
        };
      case "payment_recorded":
        return {
          icon: <CreditCard className="w-4 h-4 text-teal-600 dark:text-teal-400" />,
          bg: "bg-teal-50 dark:bg-teal-950/60",
        };
      case "patient_registered":
        return {
          icon: <UserPlus className="w-4 h-4 text-purple-600 dark:text-purple-400" />,
          bg: "bg-purple-50 dark:bg-purple-950/60",
        };
      case "record_updated":
        return {
          icon: <FileText className="w-4 h-4 text-amber-600 dark:text-amber-400" />,
          bg: "bg-amber-50 dark:bg-amber-950/60",
        };
      case "rating_received":
        return {
          icon: <Star className="w-4 h-4 text-amber-500 fill-amber-400" />,
          bg: "bg-amber-50 dark:bg-amber-950/60",
        };
      default:
        return {
          icon: <Activity className="w-4 h-4 text-gray-600 dark:text-gray-400" />,
          bg: "bg-gray-100 dark:bg-gray-800",
        };
    }
  };

  // Ensure exactly max 5 events (AC-20)
  const display_activities = activities.slice(0, 5);

  return (
    <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 sm:p-6 shadow-xs hover:shadow-md transition-all flex flex-col justify-between space-y-4">
      {/* Header: Title + View All Link */}
      <div className="flex items-center justify-between border-b border-gray-100 dark:border-gray-800/80 pb-3">
        <div className="flex items-center gap-2">
          <Activity className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          <h3 className="text-base font-bold text-gray-900 dark:text-white">
            {t("recent_activity")}
          </h3>
        </div>
        <Link
          href="/notifications"
          className="text-xs font-semibold text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 flex items-center gap-1 transition-colors"
        >
          <span>{t("view_all")}</span>
          <ArrowRight className="w-3 h-3" />
        </Link>
      </div>

      {/* Body: Events List */}
      {display_activities.length === 0 ? (
        <div className="flex flex-col items-center justify-center p-8 text-center min-h-[200px]">
          <Activity className="w-8 h-8 text-gray-300 dark:text-gray-600 mb-2" />
          <p className="text-xs font-medium text-gray-500 dark:text-gray-400">
            {t("no_recent_activity")}
          </p>
        </div>
      ) : (
        <div className="flex flex-col justify-start gap-2.5">
          {display_activities.map((item) => {
            const config = get_category_config(item.category);
            return (
              <div
                key={item.id}
                className="flex items-start gap-3 p-2 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
              >
                <div
                  className={`w-8 h-8 rounded-lg flex items-center justify-center shrink-0 shadow-2xs ${config.bg}`}
                >
                  {config.icon}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-xs font-medium text-gray-800 dark:text-gray-200 line-clamp-2 leading-relaxed">
                    {item.description}
                  </p>
                  <span className="text-[10px] text-gray-400 dark:text-gray-500 font-medium">
                    {format_time(item.occurred_at)}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};

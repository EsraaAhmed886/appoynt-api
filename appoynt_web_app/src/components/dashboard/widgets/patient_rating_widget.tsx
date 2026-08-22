/*
 * File Name: patient_rating_widget.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, next/link, @/context/dashboard_context, @/context/language_context, @/components/dashboard/states/dashboard_skeleton, @/components/dashboard/states/component_error_state
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Displays aggregate doctor rating, 5-to-1 star distribution bars, and strict empty-state guard suppressing 0.0/empty stars for new doctors (BR-67, AC-22).
 */

"use client";

import React from "react";
import Link from "next/link";
import { Star, MessageSquare, ArrowRight } from "lucide-react";
import { useDashboard } from "@/context/dashboard_context";
import { useTranslation } from "@/context/language_context";
import { WidgetSkeleton } from "@/components/dashboard/states/dashboard_skeleton";
import { ComponentErrorState } from "@/components/dashboard/states/component_error_state";

export const PatientRatingWidget: React.FC = () => {
  const { rating, rating_loading, rating_error, refresh_rating } = useDashboard();
  const { t } = useTranslation();

  if (rating_loading) {
    return <WidgetSkeleton />;
  }

  if (rating_error) {
    return (
      <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 shadow-xs">
        <ComponentErrorState
          message_key="error_loading_rating"
          on_retry={refresh_rating}
          height="min-h-[260px]"
        />
      </div>
    );
  }

  const has_ratings =
    rating &&
    rating.total_reviews > 0 &&
    rating.aggregate_rating !== null &&
    rating.aggregate_rating > 0;

  return (
    <div className="rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 sm:p-6 shadow-xs hover:shadow-md transition-all flex flex-col justify-between space-y-4">
      {/* Header: Title + View All Link */}
      <div className="flex items-center justify-between border-b border-gray-100 dark:border-gray-800/80 pb-3">
        <div className="flex items-center gap-2">
          <Star className="w-5 h-5 text-amber-500 fill-amber-400" />
          <h3 className="text-base font-bold text-gray-900 dark:text-white">
            {t("patient_rating")}
          </h3>
        </div>
        <Link
          href="/reviews"
          className="text-xs font-semibold text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 flex items-center gap-1 transition-colors"
        >
          <span>{t("view_all")}</span>
          <ArrowRight className="w-3 h-3" />
        </Link>
      </div>

      {/* Body: Ratings vs Empty State Guard (BR-67 / AC-22) */}
      {!has_ratings ? (
        <div className="flex-1 flex flex-col items-center justify-center p-6 text-center rounded-xl bg-gray-50/60 dark:bg-gray-800/30 border border-gray-100 dark:border-gray-800">
          <div className="w-12 h-12 rounded-2xl bg-amber-50 dark:bg-amber-950/40 text-amber-600 dark:text-amber-400 flex items-center justify-center mb-3 shadow-2xs">
            <MessageSquare className="w-6 h-6" />
          </div>
          <p className="text-xs sm:text-sm font-semibold text-gray-700 dark:text-gray-200">
            {t("no_rating_available")}
          </p>
        </div>
      ) : (
        <div className="flex-1 flex flex-col justify-between space-y-4">
          {/* Top Score Summary */}
          <div className="flex items-center gap-4">
            <div className="text-center px-4 py-2 rounded-xl bg-amber-50/70 dark:bg-amber-950/40 border border-amber-200/60 dark:border-amber-900/40">
              <span className="text-3xl font-extrabold text-amber-700 dark:text-amber-300 block">
                {rating.aggregate_rating?.toFixed(1)}
              </span>
              <div className="flex items-center justify-center gap-0.5 mt-0.5">
                {[1, 2, 3, 4, 5].map((s) => (
                  <Star
                    key={s}
                    className={`w-3 h-3 ${
                      s <= Math.round(rating.aggregate_rating || 0)
                        ? "text-amber-500 fill-amber-400"
                        : "text-gray-300 dark:text-gray-600"
                    }`}
                  />
                ))}
              </div>
            </div>

            <div className="space-y-0.5">
              <p className="text-xs font-bold text-gray-900 dark:text-white">
                {t("reviews_count").replace("{count}", rating.total_reviews.toString())}
              </p>
              <p className="text-[11px] text-gray-500 dark:text-gray-400">
                Verified Patient Consultations
              </p>
            </div>
          </div>

          {/* 5-to-1 Star Distribution Progress Bars */}
          <div className="space-y-1.5 pt-1">
            {[5, 4, 3, 2, 1].map((star_num) => {
              const item = rating.distribution.find((d) => d.stars === star_num) || {
                stars: star_num,
                count: 0,
                percentage: 0,
              };

              return (
                <div key={star_num} className="flex items-center gap-2 text-xs">
                  <span className="w-5 text-[11px] font-bold text-gray-600 dark:text-gray-400 shrink-0 text-start">
                    {star_num}★
                  </span>
                  <div className="flex-1 h-2 rounded-full bg-gray-100 dark:bg-gray-800 overflow-hidden">
                    <div
                      style={{ width: `${item.percentage}%` }}
                      className="h-full rounded-full bg-amber-500 transition-all duration-500"
                    />
                  </div>
                  <span className="w-8 text-[10px] text-gray-400 dark:text-gray-500 text-end font-medium">
                    {item.count}
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
};

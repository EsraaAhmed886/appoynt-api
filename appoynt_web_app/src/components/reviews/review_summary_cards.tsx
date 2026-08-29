/**
 * File Name : review_summary_cards.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/types/review
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Top statistics grid rendering Overall Rating score, 5-to-1 Star Distribution progress bars, Average Rating metric, and Total Reviews count.
 */

"use client";

import React from "react";
import { Star, MessageSquare } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { ReviewSummary } from "@/types/review";

type ReviewSummaryCardsProps = {
  summary: ReviewSummary;
};

export default function ReviewSummaryCards({ summary }: ReviewSummaryCardsProps) {
  const { translations } = useTranslation();

  const hasRatings = summary.totalReviews > 0 && null !== summary.averageRating;
  const formattedScore = hasRatings && null !== summary.averageRating
    ? summary.averageRating.toFixed(1)
    : translations.summary_no_ratings_yet;

  const roundedScore = hasRatings && null !== summary.averageRating
    ? Math.round(summary.averageRating)
    : 0;

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-12 gap-4 sm:gap-6 w-full">
      {/* ── 1. Overall Rating Card (Cols 1-4) ── */}
      <div className="lg:col-span-4 rounded-2xl border border-app-border bg-app-surface p-6 shadow-xs flex flex-col items-center justify-center text-center space-y-3">
        <div className="flex items-center gap-1.5 text-blue-600 dark:text-blue-400 font-semibold text-sm">
          <Star className="w-4 h-4 fill-blue-600 dark:fill-blue-400" />
          <span>{translations.summary_overall_rating}</span>
        </div>

        <div className="text-4xl sm:text-5xl font-black tracking-tight text-app-text-primary">
          {formattedScore}
        </div>

        {hasRatings ? (
          <div className="flex items-center justify-center gap-1">
            {[1, 2, 3, 4, 5].map((starNum) => (
              <Star
                key={starNum}
                className={`w-5 h-5 ${
                  starNum <= roundedScore
                    ? "text-amber-400 fill-amber-400"
                    : "text-slate-300 dark:text-slate-700"
                }`}
              />
            ))}
          </div>
        ) : null}

        <p className="text-xs sm:text-sm font-medium text-app-text-secondary">
          {hasRatings
            ? (translations.summary_reviews_count || "({count} reviews)").replace(
                "{count}",
                String(summary.totalReviews)
              )
            : translations.summary_no_ratings_yet}
        </p>
      </div>

      {/* ── 2. Rating Distribution Breakdown Card (Cols 5-8) ── */}
      <div className="lg:col-span-4 rounded-2xl border border-app-border bg-app-surface p-6 shadow-xs flex flex-col justify-between space-y-3">
        <h3 className="text-sm font-bold text-app-text-primary">
          {translations.summary_rating_distribution}
        </h3>

        <div className="space-y-2">
          {summary.distribution.map((item) => (
            <div key={item.stars} className="flex items-center gap-2 text-xs">
              <span className="w-4 text-xs font-semibold text-app-text-secondary text-start shrink-0">
                {item.stars}
              </span>
              <Star className="w-3.5 h-3.5 text-slate-400 shrink-0" />

              <div className="flex-1 h-2 rounded-full bg-slate-100 dark:bg-slate-800 overflow-hidden">
                <div
                  style={{ width: `${item.percentage}%` }}
                  className="h-full rounded-full bg-blue-600 dark:bg-blue-500 transition-all duration-300"
                />
              </div>

              <span className="w-14 text-end text-[11px] font-medium text-app-text-secondary shrink-0">
                {item.count} ({item.percentage}%)
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* ── 3. Key Metrics Stack (Cols 9-12) ── */}
      <div className="lg:col-span-4 flex flex-col gap-4 sm:gap-6 justify-between">
        {/* Average Rating KPI */}
        <div className="flex-1 rounded-2xl border border-app-border bg-app-surface p-5 shadow-xs flex items-center justify-between">
          <div className="flex items-center gap-2 text-blue-600 dark:text-blue-400">
            <Star className="w-5 h-5" />
            <span className="text-sm font-bold">{translations.summary_average_rating}</span>
          </div>

          <div className="flex items-center gap-1">
            <span className="text-2xl sm:text-3xl font-black text-app-text-primary">
              {hasRatings && null !== summary.averageRating
                ? summary.averageRating.toFixed(1)
                : "-"}
            </span>
            {hasRatings ? (
              <Star className="w-5 h-5 text-amber-400 fill-amber-400" />
            ) : null}
          </div>
        </div>

        {/* Total Reviews KPI */}
        <div className="flex-1 rounded-2xl border border-app-border bg-app-surface p-5 shadow-xs flex items-center justify-between">
          <div className="flex items-center gap-2 text-app-text-secondary">
            <MessageSquare className="w-5 h-5" />
            <span className="text-sm font-bold text-app-text-primary">
              {translations.summary_total_reviews}
            </span>
          </div>

          <span className="text-2xl sm:text-3xl font-black text-app-text-primary">
            {summary.totalReviews}
          </span>
        </div>
      </div>
    </div>
  );
}

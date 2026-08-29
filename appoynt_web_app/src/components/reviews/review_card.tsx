/**
 * File Name : review_card.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/types/review, @/lib/utils/date_utils
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Individual patient review card displaying patient avatar initials, name, appointment ID, star rating, plain-text comment, formatted date, and report action button.
 */

"use client";

import React from "react";
import { Star, Flag, Check } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { Review } from "@/types/review";
import { formatReviewDate } from "@/lib/utils/date_utils";

type ReviewCardProps = {
  review: Review;
  isReported: boolean;
  onReport: (review: Review) => void;
};

// Generates two-letter initials from patient name
function getInitials(name: string): string {
  if (!name) {
    return "P";
  } else {
    const parts = name.trim().split(/\s+/);
    if (1 === parts.length) {
      return (parts[0]?.substring(0, 2) || "P").toUpperCase();
    } else {
      const firstInitial = parts[0]?.charAt(0) || "";
      const lastInitial = parts[parts.length - 1]?.charAt(0) || "";
      return (firstInitial + lastInitial).toUpperCase();
    }
  }
}

// Generates consistent soft background color token for patient avatars
function getAvatarBgColor(name: string): string {
  const colorPalette = [
    "bg-blue-100 text-blue-700 dark:bg-blue-900/40 dark:text-blue-300",
    "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-300",
    "bg-purple-100 text-purple-700 dark:bg-purple-900/40 dark:text-purple-300",
    "bg-amber-100 text-amber-700 dark:bg-amber-900/40 dark:text-amber-300",
    "bg-rose-100 text-rose-700 dark:bg-rose-900/40 dark:text-rose-300",
  ];

  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash);
  }

  const index = Math.abs(hash) % colorPalette.length;
  return colorPalette[index] || colorPalette[0]!;
}

export default function ReviewCard({
  review,
  isReported,
  onReport,
}: ReviewCardProps) {
  const { translations, current_locale } = useTranslation();

  const trimmedComment = review.comment ? review.comment.trim() : null;
  const hasComment = null !== trimmedComment && "" !== trimmedComment;
  const formattedDate = formatReviewDate(review.createdAt, current_locale);
  const initials = getInitials(review.patientName);
  const avatarClass = getAvatarBgColor(review.patientName);

  return (
    <div className="rounded-2xl border border-app-border bg-app-surface p-5 sm:p-6 shadow-xs hover:border-slate-300 dark:hover:border-slate-700 transition-all duration-200">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 pb-3 border-b border-app-border/50">
        {/* Patient Profile & Meta */}
        <div className="flex items-center gap-3">
          <div
            className={`w-11 h-11 rounded-full flex items-center justify-center font-bold text-sm shrink-0 ${avatarClass}`}
          >
            {initials}
          </div>

          <div className="space-y-0.5">
            <div className="flex items-center gap-2 flex-wrap">
              <h4 className="text-sm sm:text-base font-bold text-app-text-primary">
                {review.patientName}
              </h4>

              {review.appointmentId ? (
                <span className="text-[11px] font-medium text-app-text-secondary bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-md">
                  {translations.appointment_id_prefix || "Appointment ID: #"}
                  {review.appointmentId.replace(/^APT-/, "")}
                </span>
              ) : null}
            </div>

            {/* Star Rating Icons */}
            <div className="flex items-center gap-0.5">
              {[1, 2, 3, 4, 5].map((starNum) => (
                <Star
                  key={starNum}
                  className={`w-4 h-4 ${
                    starNum <= review.rating
                      ? "text-amber-400 fill-amber-400"
                      : "text-slate-200 dark:text-slate-700"
                  }`}
                />
              ))}
            </div>
          </div>
        </div>

        {/* Date & Report Action Controls */}
        <div className="flex items-center gap-3 sm:gap-4 self-end sm:self-center">
          <span className="text-xs font-medium text-app-text-secondary">
            {formattedDate}
          </span>

          {isReported ? (
            <button
              type="button"
              disabled
              className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold bg-slate-100 dark:bg-slate-800 text-slate-400 dark:text-slate-500 cursor-not-allowed border border-slate-200 dark:border-slate-700"
            >
              <Check className="w-3.5 h-3.5" />
              <span>{translations.action_reported || "Reported"}</span>
            </button>
          ) : (
            <button
              type="button"
              onClick={() => onReport(review)}
              className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold text-slate-600 dark:text-slate-300 hover:text-blue-600 dark:hover:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-950/40 border border-slate-200 dark:border-slate-700 transition cursor-pointer"
            >
              <Flag className="w-3.5 h-3.5" />
              <span>{translations.action_report || "Report"}</span>
            </button>
          )}
        </div>
      </div>

      {/* Plain Text Comment Body */}
      {hasComment ? (
        <div className="pt-3">
          <p className="text-xs sm:text-sm leading-relaxed text-app-text-primary whitespace-pre-wrap">
            {trimmedComment}
          </p>
        </div>
      ) : null}
    </div>
  );
}

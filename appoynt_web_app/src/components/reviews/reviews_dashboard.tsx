/**
 * File Name : reviews_dashboard.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : react, @/context/language_context, @/hooks/use_reviews, @/components/reviews/review_summary_cards, @/components/reviews/review_card, @/components/reviews/filtered_empty_state, @/components/reviews/report_review_modal, @/components/common/dashboard_dropdown, @/components/common/pagination, @/components/common/loading_state, @/components/common/empty_state, @/components/common/error_state
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Master Doctor Reviews Dashboard UI composition component rendering summary metrics, rating filter & sorting toolbar, review list, server-side pagination, and report dialogs.
 */

"use client";

import React, { useState } from "react";
import { useTranslation } from "@/context/language_context";
import { useReviews } from "@/hooks/use_reviews";
import { ReviewRatingFilter, ReviewSort, ReportReason } from "@/types/review";
import ReviewSummaryCards from "@/components/reviews/review_summary_cards";
import ReviewCard from "@/components/reviews/review_card";
import FilteredEmptyState from "@/components/reviews/filtered_empty_state";
import ReportReviewModal from "@/components/reviews/report_review_modal";
import DashboardDropdown, { DropdownOption } from "@/components/common/dashboard_dropdown";
import Pagination from "@/components/common/pagination";
import LoadingState from "@/components/common/loading_state";
import EmptyState from "@/components/common/empty_state";
import ErrorState from "@/components/common/error_state";

export default function ReviewsDashboard() {
  const { translations } = useTranslation();

  const {
    reviews,
    totalCount,
    totalPages,
    page,
    pageSize,
    sort,
    ratingFilter,
    summary,
    uiState,
    errorMessage,
    selectedReviewForReport,
    isSubmittingReport,
    reportedReviewIds,
    handleRatingFilterChange,
    handleSortChange,
    handlePageChange,
    handlePageSizeChange,
    handleClearFilters,
    handleRetry,
    handleOpenReportModal,
    handleCloseReportModal,
    handleSubmitReport,
  } = useReviews();

  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Rating Filter dropdown options
  const ratingFilterOptions: DropdownOption[] = [
    { value: "all", label: translations.filter_all_ratings || "All Ratings" },
    { value: "5", label: translations.filter_5_stars || "5 Stars" },
    { value: "4", label: translations.filter_4_stars || "4 Stars" },
    { value: "3", label: translations.filter_3_stars || "3 Stars" },
    { value: "2", label: translations.filter_2_stars || "2 Stars" },
    { value: "1", label: translations.filter_1_star || "1 Star" },
  ];

  // Sorting dropdown options
  const sortOptions: DropdownOption[] = [
    { value: "newest", label: translations.review_sort_newest || translations.sort_newest || "Newest First" },
    { value: "highest_rating", label: translations.sort_highest_rating || "Highest Rating" },
    { value: "lowest_rating", label: translations.sort_lowest_rating || "Lowest Rating" },
  ];

  const onReportSubmit = async (reason: ReportReason, details?: string) => {
    const result = await handleSubmitReport(reason, details);
    if (result.success) {
      setToastMessage(translations.report_success_toast || "Review reported successfully");
    } else {
      setToastMessage(result.message || translations.report_error_toast || "Failed to submit report");
    }
    setTimeout(() => {
      setToastMessage(null);
    }, 4000);
  };

  return (
    <div className="space-y-6 sm:space-y-8 p-4 sm:p-6 lg:p-8 max-w-7xl mx-auto">
      {/* ── Summary Statistics Grid ── */}
      <ReviewSummaryCards summary={summary} />

      {/* ── Filter & Sort Toolbar ── */}
      <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 sm:gap-4 p-2 sm:p-3 rounded-2xl bg-app-surface border border-app-border shadow-xs">
        <div className="w-full sm:w-auto">
          <DashboardDropdown
            options={ratingFilterOptions}
            value={ratingFilter}
            onChange={(val) => handleRatingFilterChange(val as ReviewRatingFilter)}
            placeholder={translations.filter_all_ratings || "All Ratings"}
            width="w-full sm:w-48"
          />
        </div>

        <div className="w-full sm:w-auto flex justify-end">
          <DashboardDropdown
            options={sortOptions}
            value={sort}
            onChange={(val) => handleSortChange(val as ReviewSort)}
            placeholder={translations.review_sort_newest || translations.sort_newest || "Newest First"}
            width="w-full sm:w-48"
          />
        </div>
      </div>

      {/* ── Non-destructive Toast / Error Feedback (Latest Valid Context) ── */}
      {toastMessage ? (
        <div className="p-3.5 rounded-xl bg-blue-50 dark:bg-blue-950/60 border border-blue-200 dark:border-blue-800 text-blue-900 dark:text-blue-200 text-xs sm:text-sm font-semibold flex items-center justify-between animate-in fade-in duration-150">
          <span>{toastMessage}</span>
          <button
            type="button"
            onClick={() => setToastMessage(null)}
            className="text-xs underline hover:opacity-80"
          >
            {translations.close || "Close"}
          </button>
        </div>
      ) : null}

      {errorMessage && "ERROR" !== uiState ? (
        <div className="p-3.5 rounded-xl bg-amber-50 dark:bg-amber-950/60 border border-amber-200 dark:border-amber-800 text-amber-900 dark:text-amber-200 text-xs sm:text-sm font-semibold">
          {errorMessage}
        </div>
      ) : null}

      {/* ── Main Reviews Content Section ── */}
      {"INITIAL_LOADING" === uiState ? (
        <div className="space-y-4">
          <LoadingState variant="list" rows={5} />
        </div>
      ) : "ERROR" === uiState ? (
        <div className="flex flex-col items-center justify-center p-8 rounded-2xl border border-app-border bg-app-surface space-y-4">
          <ErrorState />
          <button
            type="button"
            onClick={handleRetry}
            className="px-6 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs sm:text-sm font-semibold transition cursor-pointer"
          >
            {translations.btn_retry || "Retry"}
          </button>
        </div>
      ) : "TOTAL_EMPTY" === uiState ? (
        <div className="rounded-2xl border border-app-border bg-app-surface p-8">
          <EmptyState />
        </div>
      ) : "FILTERED_EMPTY" === uiState ? (
        <FilteredEmptyState onClearFilters={handleClearFilters} />
      ) : (
        <div className="space-y-4">
          {/* Reviews Card List */}
          <div className="space-y-3 sm:space-y-4">
            {reviews.map((review) => (
              <ReviewCard
                key={review.id}
                review={review}
                isReported={review.isReported || reportedReviewIds.has(review.id)}
                onReport={handleOpenReportModal}
              />
            ))}
          </div>

          {/* Server-Side Pagination Bar */}
          {totalPages > 1 ? (
            <div className="pt-2">
              <Pagination
                currentPage={page}
                totalPages={totalPages}
                onPageChange={handlePageChange}
              />
            </div>
          ) : null}
        </div>
      )}

      {/* ── Report Review Dialog Modal ── */}
      {selectedReviewForReport ? (
        <ReportReviewModal
          review={selectedReviewForReport}
          isSubmitting={isSubmittingReport}
          onClose={handleCloseReportModal}
          onSubmit={onReportSubmit}
        />
      ) : null}
    </div>
  );
}

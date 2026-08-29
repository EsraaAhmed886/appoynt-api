/**
 * File Name : use_reviews.ts
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : react, next/navigation, @/types/review, @/constants/review_constants, @/services/review.service
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Custom React ViewModel hook managing Doctor Reviews reactive state, URL query synchronization, sorting, filtering, server-side pagination clamping, Latest Valid Context error handling, and moderation reporting.
 */

import { useState, useEffect, useCallback, useRef, useTransition } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import {
  Review,
  ReviewSummary,
  ReviewSort,
  ReviewRatingFilter,
  ReportReason,
} from "@/types/review";
import {
  DEFAULT_REVIEW_PAGE_SIZE,
  REVIEW_SORT_VALUES,
  REVIEW_RATING_FILTER_VALUES,
} from "@/constants/review_constants";
import { reviewService } from "@/services/review.service";

export type UIState =
  | "INITIAL_LOADING"
  | "SUCCESS"
  | "FILTERED_EMPTY"
  | "TOTAL_EMPTY"
  | "ERROR";

export function useReviews() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [, startTransition] = useTransition();

  // ── 1. Read Initial Parameters from URL or Defaults ──
  const initialPage = parseInt(searchParams.get("page") || "1", 10);
  const initialSort = (searchParams.get("sort") as ReviewSort) || "newest";
  const initialRating = (searchParams.get("rating") as ReviewRatingFilter) || "all";

  const safeSort: ReviewSort = REVIEW_SORT_VALUES.includes(initialSort)
    ? initialSort
    : "newest";

  const safeRating: ReviewRatingFilter = REVIEW_RATING_FILTER_VALUES.includes(initialRating)
    ? initialRating
    : "all";

  const [page, setPageState] = useState<number>(isNaN(initialPage) || initialPage < 1 ? 1 : initialPage);
  const [pageSize, setPageSizeState] = useState<number>(DEFAULT_REVIEW_PAGE_SIZE);
  const [sort, setSortState] = useState<ReviewSort>(safeSort);
  const [ratingFilter, setRatingFilterState] = useState<ReviewRatingFilter>(safeRating);

  // ── 2. Data & State Containers ──
  const [reviews, setReviews] = useState<Review[]>([]);
  const [totalCount, setTotalCount] = useState<number>(0);
  const [totalPages, setTotalPages] = useState<number>(1);
  const [summary, setSummary] = useState<ReviewSummary>({
    averageRating: null,
    totalReviews: 0,
    distribution: [
      { stars: 5, count: 0, percentage: 0 },
      { stars: 4, count: 0, percentage: 0 },
      { stars: 3, count: 0, percentage: 0 },
      { stars: 2, count: 0, percentage: 0 },
      { stars: 1, count: 0, percentage: 0 },
    ],
  });

  const [uiState, setUiState] = useState<UIState>("INITIAL_LOADING");
  const [isRefreshing, setIsRefreshing] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // Report Modal Workflow State
  const [selectedReviewForReport, setSelectedReviewForReport] = useState<Review | null>(null);
  const [isSubmittingReport, setIsSubmittingReport] = useState<boolean>(false);
  const [reportedReviewIds, setReportedReviewIds] = useState<Set<string>>(new Set());

  // Track whether initial fetch has completed to preserve "Latest Valid Context"
  const isInitialLoadedRef = useRef<boolean>(false);

  // ── 3. Synchronize State to URL Query Parameters ──
  const updateUrlParams = useCallback(
    (newPage: number, newSort: ReviewSort, newRating: ReviewRatingFilter) => {
      startTransition(() => {
        const params = new URLSearchParams();

        if (newPage > 1) {
          params.set("page", String(newPage));
        } else {
          // Default page 1 can be omitted or explicit
        }

        if ("newest" !== newSort) {
          params.set("sort", newSort);
        } else {
          // Default sort can be omitted
        }

        if ("all" !== newRating) {
          params.set("rating", newRating);
        } else {
          // Default rating filter can be omitted
        }

        const queryString = params.toString();
        const targetUrl = queryString ? `/reviews?${queryString}` : "/reviews";
        router.replace(targetUrl, { scroll: false });
      });
    },
    [router]
  );

  // ── 4. Data Fetching Layer with Latest Valid Context ──
  const fetchReviews = useCallback(async () => {
    if (!isInitialLoadedRef.current) {
      setUiState("INITIAL_LOADING");
    } else {
      setIsRefreshing(true);
    }
    setErrorMessage(null);

    try {
      const response = await reviewService.getReviews({
        page: page,
        pageSize: pageSize,
        sort: sort,
        rating: ratingFilter,
      });

      setReviews(response.items);
      setTotalCount(response.totalCount);
      setTotalPages(response.totalPages);
      setSummary(response.summary);

      // Clamp current page if backend total pages changed
      if (response.page !== page) {
        setPageState(response.page);
      } else {
        // Page in sync
      }

      isInitialLoadedRef.current = true;
      setIsRefreshing(false);

      if (response.summary.totalReviews === 0) {
        setUiState("TOTAL_EMPTY");
      } else if (response.totalCount === 0 && "all" !== ratingFilter) {
        setUiState("FILTERED_EMPTY");
      } else {
        setUiState("SUCCESS");
      }
    } catch (error: unknown) {
      setIsRefreshing(false);
      const message =
        error instanceof Error ? error.message : "Failed to load doctor reviews.";

      if (!isInitialLoadedRef.current) {
        // Initial load failed -> show Retry ErrorState
        setUiState("ERROR");
        setErrorMessage(message);
      } else {
        // Subsequent request failed -> retain Latest Valid Context and surface non-destructive error
        setErrorMessage(message);
      }
    }
  }, [page, pageSize, sort, ratingFilter]);

  useEffect(() => {
    fetchReviews();
  }, [fetchReviews]);

  // ── 5. User Interaction Handlers ──
  const handleRatingFilterChange = (newRating: ReviewRatingFilter) => {
    setRatingFilterState(newRating);
    setPageState(1);
    updateUrlParams(1, sort, newRating);
  };

  const handleSortChange = (newSort: ReviewSort) => {
    setSortState(newSort);
    setPageState(1);
    updateUrlParams(1, newSort, ratingFilter);
  };

  const handlePageChange = (newPage: number) => {
    if (newPage >= 1 && newPage <= totalPages && newPage !== page) {
      setPageState(newPage);
      updateUrlParams(newPage, sort, ratingFilter);
    } else {
      // Out of bounds or redundant page click
    }
  };

  const handlePageSizeChange = (newPageSize: number) => {
    setPageSizeState(newPageSize);
    setPageState(1);
    updateUrlParams(1, sort, ratingFilter);
  };

  const handleClearFilters = () => {
    setRatingFilterState("all");
    setPageState(1);
    updateUrlParams(1, sort, "all");
  };

  const handleRetry = () => {
    fetchReviews();
  };

  // ── 6. Report Review Dialog Handlers ──
  const handleOpenReportModal = (review: Review) => {
    setSelectedReviewForReport(review);
  };

  const handleCloseReportModal = () => {
    if (!isSubmittingReport) {
      setSelectedReviewForReport(null);
    } else {
      // Cannot close while submitting
    }
  };

  const handleSubmitReport = async (reason: ReportReason, details?: string) => {
    if (!selectedReviewForReport) {
      return { success: false, message: "No review selected for reporting." };
    } else {
      setIsSubmittingReport(true);
      try {
        const response = await reviewService.submitReport({
          reviewId: selectedReviewForReport.id,
          reason: reason,
          details: details?.trim() || undefined,
        });

        if (response.success) {
          setReportedReviewIds((prev) => new Set([...prev, selectedReviewForReport.id]));
          setSelectedReviewForReport(null);
        } else {
          // Submission rejected
        }

        setIsSubmittingReport(false);
        return response;
      } catch (err: unknown) {
        setIsSubmittingReport(false);
        return {
          success: false,
          message: err instanceof Error ? err.message : "Failed to submit report.",
        };
      }
    }
  };

  return {
    reviews,
    totalCount,
    totalPages,
    page,
    pageSize,
    sort,
    ratingFilter,
    summary,
    uiState,
    isRefreshing,
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
  };
}

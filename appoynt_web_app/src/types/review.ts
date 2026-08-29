/**
 * File Name : review.ts
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : None
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : TypeScript domain interfaces and API payload contracts for Doctor Reviews, ratings distribution summary, sorting, filtering, server-side pagination, and reporting.
 */

/**
 * Valid integer star ratings between 1 and 5.
 */
export type ReviewRating = 1 | 2 | 3 | 4 | 5;

/**
 * Supported review sort strategies.
 */
export type ReviewSort = "newest" | "highest_rating" | "lowest_rating";

/**
 * Supported rating filter criteria.
 */
export type ReviewRatingFilter = "all" | "1" | "2" | "3" | "4" | "5";

/**
 * Supported review moderation report reasons.
 */
export type ReportReason =
  | "inappropriate_language"
  | "abusive_content"
  | "false_information"
  | "other";

/**
 * Core Patient Review entity belonging to an authenticated Doctor.
 */
export interface Review {
  id: string;
  doctorId: string;
  patientName: string;
  appointmentId?: string;
  rating: ReviewRating;
  comment?: string | null;
  createdAt: string; // ISO 8601 UTC timestamp
  isReported: boolean;
}

/**
 * Rating distribution bucket for a specific star count (1 to 5).
 */
export interface RatingDistribution {
  stars: ReviewRating;
  count: number;
  percentage: number;
}

/**
 * Aggregate rating metrics computed across all active reviews for a Doctor.
 */
export interface ReviewSummary {
  averageRating: number | null; // null when total active reviews is 0 ("No ratings yet")
  totalReviews: number;
  distribution: RatingDistribution[];
}

/**
 * Server-side pagination parameters.
 */
export interface PaginationParams {
  page: number;
  pageSize: number;
}

/**
 * Query parameters for fetching paginated and filtered doctor reviews.
 */
export interface GetReviewsParams {
  doctorId?: string;
  rating?: ReviewRatingFilter;
  sort?: ReviewSort;
  page?: number;
  pageSize?: number;
}

/**
 * Standard server response for paginated review queries.
 */
export interface ReviewsResponse {
  items: Review[];
  page: number;
  pageSize: number;
  totalCount: number;
  totalPages: number;
  summary: ReviewSummary;
}

/**
 * Payload sent when reporting an inappropriate or abusive review.
 */
export interface SubmitReportPayload {
  reviewId: string;
  reason: ReportReason;
  details?: string;
}

/**
 * Response returned after submitting a review report.
 */
export interface ReportResponse {
  success: boolean;
  message?: string;
}

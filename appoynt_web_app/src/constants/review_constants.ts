/**
 * File Name : review_constants.ts
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : None
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Non-translatable domain constants, pagination constraints, sort keys, filter values, and report categories for Doctor Reviews.
 */

import {
  ReviewSort,
  ReviewRatingFilter,
  ReportReason,
} from "@/types/review";

/**
 * Default number of reviews per page for server-side pagination.
 */
export const DEFAULT_REVIEW_PAGE_SIZE = 10;

/**
 * Maximum allowed page size for server-side pagination.
 */
export const MAX_REVIEW_PAGE_SIZE = 50;

/**
 * Supported page limit options available in the pagination selector.
 */
export const REVIEW_PAGE_SIZE_OPTIONS: readonly number[] = [10, 25, 50];

/**
 * Supported sorting strategy identifiers.
 */
export const REVIEW_SORT_VALUES: readonly ReviewSort[] = [
  "newest",
  "highest_rating",
  "lowest_rating",
];

/**
 * Supported rating filter identifiers.
 */
export const REVIEW_RATING_FILTER_VALUES: readonly ReviewRatingFilter[] = [
  "all",
  "5",
  "4",
  "3",
  "2",
  "1",
];

/**
 * Supported review moderation report reasons.
 */
export const REVIEW_REPORT_REASON_VALUES: readonly ReportReason[] = [
  "inappropriate_language",
  "abusive_content",
  "false_information",
  "other",
];

/**
 * Maximum allowed character length for review comments.
 */
export const MAX_COMMENT_LENGTH = 1000;

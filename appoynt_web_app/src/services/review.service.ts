/**
 * File Name : review.service.ts
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : @/types/review, @/constants/review_constants
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Service layer handling doctor reviews API communication, summary calculations, sorting, filtering, server-side pagination, and moderation reporting.
 */

import {
  Review,
  ReviewRating,
  ReviewSummary,
  GetReviewsParams,
  ReviewsResponse,
  SubmitReportPayload,
  ReportResponse,
  RatingDistribution,
} from "@/types/review";
import {
  DEFAULT_REVIEW_PAGE_SIZE,
  MAX_REVIEW_PAGE_SIZE,
} from "@/constants/review_constants";

// Seeded initial mock dataset reflecting realistic doctor reviews (matching visual mockup: 128 total reviews, 4.6 avg)
const INITIAL_MOCK_REVIEWS: Review[] = [
  {
    id: "REV-001",
    doctorId: "DOC-CURRENT",
    patientName: "Sarah Ali",
    appointmentId: "APT-000123",
    rating: 5,
    comment: "Very professional and friendly doctor.",
    createdAt: "2025-05-25T10:30:00Z",
    isReported: false,
  },
  {
    id: "REV-002",
    doctorId: "DOC-CURRENT",
    patientName: "Omar Hassan",
    appointmentId: "APT-000456",
    rating: 4,
    comment: "Great experience and helpful advice.",
    createdAt: "2025-05-24T16:15:00Z",
    isReported: false,
  },
  {
    id: "REV-003",
    doctorId: "DOC-CURRENT",
    patientName: "Nour El Sayed",
    appointmentId: "APT-000789",
    rating: 5,
    comment: "Excellent communication and treatment.",
    createdAt: "2025-05-23T11:00:00Z",
    isReported: false,
  },
  {
    id: "REV-004",
    doctorId: "DOC-CURRENT",
    patientName: "Ahmed Mostafa",
    appointmentId: "APT-000912",
    rating: 5,
    comment: "Accurate diagnosis and very patient in explaining the treatment plan.",
    createdAt: "2025-05-22T09:15:00Z",
    isReported: false,
  },
  {
    id: "REV-005",
    doctorId: "DOC-CURRENT",
    patientName: "Mona Ibrahim",
    appointmentId: "APT-001045",
    rating: 4,
    comment: "The clinic was very organized and the consultation was thorough.",
    createdAt: "2025-05-21T14:45:00Z",
    isReported: false,
  },
  {
    id: "REV-006",
    doctorId: "DOC-CURRENT",
    patientName: "Karim Mahmoud",
    appointmentId: "APT-001180",
    rating: 3,
    comment: "Good doctor but waiting time was a bit longer than expected.",
    createdAt: "2025-05-20T17:20:00Z",
    isReported: false,
  },
  {
    id: "REV-007",
    doctorId: "DOC-CURRENT",
    patientName: "Laila Youssef",
    appointmentId: "APT-001290",
    rating: 5,
    comment: "Highly recommended! Very caring and attentive.",
    createdAt: "2025-05-19T10:00:00Z",
    isReported: false,
  },
  {
    id: "REV-008",
    doctorId: "DOC-CURRENT",
    patientName: "Hassan Tarek",
    appointmentId: "APT-001350",
    rating: 5,
    comment: null, // Test case: review without comment
    createdAt: "2025-05-18T12:30:00Z",
    isReported: false,
  },
  {
    id: "REV-009",
    doctorId: "DOC-CURRENT",
    patientName: "Salma Fathy",
    appointmentId: "APT-001420",
    rating: 2,
    comment: "Felt the consultation was a bit rushed today.",
    createdAt: "2025-05-17T15:10:00Z",
    isReported: false,
  },
  {
    id: "REV-010",
    doctorId: "DOC-CURRENT",
    patientName: "Tamer Nabil",
    appointmentId: "APT-001505",
    rating: 5,
    comment: "Top notch healthcare service as always.",
    createdAt: "2025-05-16T11:45:00Z",
    isReported: false,
  },
  {
    id: "REV-011",
    doctorId: "DOC-CURRENT",
    patientName: "Rania Adel",
    appointmentId: "APT-001610",
    rating: 4,
    comment: "Helpful follow-up and good prescription explanation.",
    createdAt: "2025-05-15T09:30:00Z",
    isReported: false,
  },
  {
    id: "REV-012",
    doctorId: "DOC-CURRENT",
    patientName: "Khaled Samy",
    appointmentId: "APT-001720",
    rating: 1,
    comment: "Appointment started 45 minutes late.",
    createdAt: "2025-05-14T13:00:00Z",
    isReported: false,
  },
];

// Helper to generate additional simulated records to match 128 total reviews distribution
function generateSimulatedReviews(): Review[] {
  const reviews: Review[] = [...INITIAL_MOCK_REVIEWS];
  const countNeeded = 128 - reviews.length;

  // Distribution target: ~72 5-stars (56%), ~34 4-stars (27%), ~12 3-stars (9%), ~6 2-stars (5%), ~4 1-star (3%)
  const ratingPool: ReviewRating[] = [
    ...Array(66).fill(5),
    ...Array(31).fill(4),
    ...Array(11).fill(3),
    ...Array(5).fill(2),
    ...Array(3).fill(1),
  ];

  const sampleNames = [
    "Dina Magdy", "Youssef Sherif", "Farida Walid", "Amr Ezzat", "Heba Gamal",
    "Mohamed Helmy", "Nadine Khaled", "Ziad Hatem", "Yasmin Samir", "Sherif Badr"
  ];

  for (let i = 0; i < countNeeded; i++) {
    const rating = ratingPool[i % ratingPool.length] || 5;
    const nameIndex = i % sampleNames.length;
    const day = 13 - Math.floor(i / 10);
    const dayStr = day > 0 ? (day < 10 ? `0${day}` : `${day}`) : "01";
    const dateStr = `2025-05-${dayStr}T10:00:00Z`;

    reviews.push({
      id: `REV-${(i + 13).toString().padStart(3, "0")}`,
      doctorId: "DOC-CURRENT",
      patientName: sampleNames[nameIndex] || `Patient ${i + 13}`,
      appointmentId: `APT-${(1800 + i).toString().padStart(6, "0")}`,
      rating: rating,
      comment: i % 4 === 0 ? null : `Consultation feedback and experience review ${i + 13}.`,
      createdAt: dateStr,
      isReported: false,
    });
  }

  return reviews;
}

class ReviewService {
  private reviewsStore: Review[] = generateSimulatedReviews();
  private reportedReviewsSet: Set<string> = new Set<string>();

  /**
   * Computes aggregate summary across ALL active reviews for the authenticated doctor.
   * Summary calculation is strictly independent of active list filters.
   */
  private calculateSummary(allDoctorReviews: Review[]): ReviewSummary {
    const totalReviews = allDoctorReviews.length;

    if (totalReviews === 0) {
      return {
        averageRating: null,
        totalReviews: 0,
        distribution: [
          { stars: 5, count: 0, percentage: 0 },
          { stars: 4, count: 0, percentage: 0 },
          { stars: 3, count: 0, percentage: 0 },
          { stars: 2, count: 0, percentage: 0 },
          { stars: 1, count: 0, percentage: 0 },
        ],
      };
    } else {
      const ratingCounts: Record<ReviewRating, number> = {
        5: 0,
        4: 0,
        3: 0,
        2: 0,
        1: 0,
      };

      let sum = 0;
      for (const rev of allDoctorReviews) {
        ratingCounts[rev.rating] = (ratingCounts[rev.rating] || 0) + 1;
        sum += rev.rating;
      }

      const rawAverage = sum / totalReviews;
      const averageRating = Math.round(rawAverage * 10) / 10;

      const distribution: RatingDistribution[] = ([5, 4, 3, 2, 1] as ReviewRating[]).map(
        (stars) => {
          const count = ratingCounts[stars] || 0;
          const percentage = Math.round((count / totalReviews) * 100);
          return {
            stars,
            count,
            percentage,
          };
        }
      );

      return {
        averageRating,
        totalReviews,
        distribution,
      };
    }
  }

  /**
   * Fetches paginated, sorted, and filtered reviews for the doctor.
   */
  public async getReviews(params: GetReviewsParams = {}): Promise<ReviewsResponse> {
    // Artificial slight network latency simulation
    await new Promise((resolve) => setTimeout(resolve, 200));

    const allDoctorReviews = this.reviewsStore.map((rev) => ({
      ...rev,
      isReported: this.reportedReviewsSet.has(rev.id) || rev.isReported,
    }));

    // 1. Calculate Summary on ALL reviews before filtering
    const summary = this.calculateSummary(allDoctorReviews);

    // 2. Apply Rating Filter
    let filtered = [...allDoctorReviews];
    if (params.rating && "all" !== params.rating) {
      const targetRating = parseInt(params.rating, 10) as ReviewRating;
      filtered = filtered.filter((rev) => rev.rating === targetRating);
    } else {
      // "all" or undefined: no rating filter
    }

    // 3. Apply Sorting
    const sortStrategy = params.sort || "newest";
    filtered.sort((a, b) => {
      if ("highest_rating" === sortStrategy) {
        if (b.rating !== a.rating) {
          return b.rating - a.rating; // Rating DESC
        } else {
          return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(); // CreatedAt DESC
        }
      } else if ("lowest_rating" === sortStrategy) {
        if (a.rating !== b.rating) {
          return a.rating - b.rating; // Rating ASC
        } else {
          return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(); // CreatedAt DESC
        }
      } else {
        // "newest" (default) -> CreatedAt DESC, id DESC
        const timeDiff = new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
        if (0 !== timeDiff) {
          return timeDiff;
        } else {
          return b.id.localeCompare(a.id);
        }
      }
    });

    // 4. Apply Server-Side Pagination
    const totalCount = filtered.length;
    const rawPageSize = params.pageSize || DEFAULT_REVIEW_PAGE_SIZE;
    const pageSize = Math.min(Math.max(1, rawPageSize), MAX_REVIEW_PAGE_SIZE);
    const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
    const requestedPage = params.page || 1;
    const currentPage = Math.min(Math.max(1, requestedPage), totalPages);

    const startIndex = (currentPage - 1) * pageSize;
    const pageItems = filtered.slice(startIndex, startIndex + pageSize);

    return {
      items: pageItems,
      page: currentPage,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      summary: summary,
    };
  }

  /**
   * Submits a review report for moderation.
   */
  public async submitReport(payload: SubmitReportPayload): Promise<ReportResponse> {
    await new Promise((resolve) => setTimeout(resolve, 300));

    if (!payload.reviewId || !payload.reason) {
      return {
        success: false,
        message: "Missing required report parameters.",
      };
    } else if (this.reportedReviewsSet.has(payload.reviewId)) {
      return {
        success: false,
        message: "You have already reported this review.",
      };
    } else {
      this.reportedReviewsSet.add(payload.reviewId);
      return {
        success: true,
        message: "Review reported successfully.",
      };
    }
  }
}

export const reviewService = new ReviewService();

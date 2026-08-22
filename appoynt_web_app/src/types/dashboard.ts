/*
 * File Name: dashboard.ts
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Defines strongly-typed TypeScript domain entities, metrics interfaces, chart points, and query options for the Doctor Dashboard workspace.
 */

export type DateRangePreset =
  | "last_7_days"
  | "last_30_days"
  | "this_month"
  | "last_month"
  | "custom";

export interface CustomDateRange {
  from: string; // YYYY-MM-DD
  to: string; // YYYY-MM-DD
}

export interface ComparisonData {
  change_pct?: number; // e.g., +20.0 or -14.0
  previous_value: number;
  is_zero_previous: boolean; // "Increased from 0 yesterday" (BR-27)
  is_no_change: boolean; // "No change" (BR-26)
}

export interface DashboardStats {
  today_appointments: {
    count: number;
    comparison?: ComparisonData;
  };
  total_patients: number;
  pending_appointments: number;
  today_revenue: {
    amount: number;
    currency: string;
    comparison?: ComparisonData;
  };
}

export interface ClinicChartPoint {
  clinic_id: string;
  clinic_name: string;
  value: number;
  currency?: string;
}

export interface ClinicChartData {
  points: ClinicChartPoint[];
  total: number;
  currency?: string;
  top_clinics: string[]; // Supports multiple tied clinic names (BR-50, BR-51)
  tied_count?: number;
}

export type ActivityCategory =
  | "appointment_created"
  | "appointment_confirmed"
  | "appointment_completed"
  | "appointment_cancelled"
  | "record_updated"
  | "payment_recorded"
  | "rating_received"
  | "patient_registered";

export interface RecentActivityItem {
  id: string;
  category: ActivityCategory;
  description: string; // Plain text <= 160 chars (VR-23)
  occurred_at: string; // ISO 8601 timestamp
  patient_name?: string;
  amount?: string;
  stars?: number;
}

export interface RatingStarDistribution {
  stars: number;
  count: number;
  percentage: number;
}

export interface PatientRatingData {
  aggregate_rating: number | null; // null when 0 reviews (BR-67)
  total_reviews: number;
  distribution: RatingStarDistribution[];
}

export interface DoctorProfileSummary {
  id: string;
  full_name: string;
  display_name: string;
  specialty: string;
  profile_image_url?: string;
  unread_notifications_count: number;
}

export interface ClinicOption {
  id: string;
  name: string;
  is_active?: boolean;
}

export interface DashboardPermissions {
  can_add_appointment: boolean;
  can_add_receptionist: boolean;
  can_add_clinic: boolean;
}

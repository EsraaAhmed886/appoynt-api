/*
 * File Name: dashboard_mock_service.ts
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: @/types/dashboard
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Provides asynchronous clinical mock data services with realistic latencies, date range aggregations, top-10 grouping, tie-breaking, and negative revenue calculations.
 */

import {
  ClinicChartData,
  ClinicChartPoint,
  ClinicOption,
  ComparisonData,
  CustomDateRange,
  DashboardStats,
  DateRangePreset,
  DoctorProfileSummary,
  PatientRatingData,
  RecentActivityItem,
} from "@/types/dashboard";

// Master list of mock clinics for doctor
const MASTER_CLINICS: ClinicOption[] = [
  { id: "clinic_1", name: "Al-Safwa Specialist Clinic", is_active: true },
  { id: "clinic_2", name: "New Cairo Heart & Vascular Center", is_active: true },
  { id: "clinic_3", name: "Zayed Medical Plaza", is_active: true },
  { id: "clinic_4", name: "Maadi Health Oasis", is_active: true },
  { id: "clinic_5", name: "Alexandria Coastal Medicare", is_active: true },
  { id: "clinic_6", name: "Heliopolis Medical Care", is_active: true },
  { id: "clinic_7", name: "Nasr City Elite Health", is_active: true },
  { id: "clinic_8", name: "Dokki Clinical Suites", is_active: true },
  { id: "clinic_9", name: "6th of October Wellness Center", is_active: true },
  { id: "clinic_10", name: "Giza Central Polyclinic", is_active: true },
  { id: "clinic_11", name: "Shorouk Specialized Hub", is_active: true },
  { id: "clinic_12", name: "Tagamoa Family Clinic", is_active: true },
];

// Helper to simulate asynchronous latency (200-300ms)
const simulate_latency = async (ms = 220): Promise<void> => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

// Multipliers based on date preset for dynamic chart data variation
const PRESET_MULTIPLIERS: Record<DateRangePreset, { patient_factor: number; revenue_factor: number }> = {
  last_7_days: { patient_factor: 0.3, revenue_factor: 0.28 },
  last_30_days: { patient_factor: 1.0, revenue_factor: 1.0 },
  this_month: { patient_factor: 0.85, revenue_factor: 0.88 },
  last_month: { patient_factor: 0.95, revenue_factor: 0.92 },
  custom: { patient_factor: 0.65, revenue_factor: 0.62 },
};

/**
 * Calculates previous-day percentage change and status flags
 * Strictly adhering to BR-24, BR-25, BR-26, BR-27
 */
export function calculate_comparison(today_val: number, yesterday_val: number): ComparisonData {
  if (yesterday_val === 0 && today_val > 0) {
    return {
      previous_value: yesterday_val,
      is_zero_previous: true,
      is_no_change: false,
    };
  }

  if (today_val === yesterday_val) {
    return {
      change_pct: 0.0,
      previous_value: yesterday_val,
      is_zero_previous: false,
      is_no_change: true,
    };
  }

  if (yesterday_val === 0 && today_val === 0) {
    return {
      change_pct: 0.0,
      previous_value: 0,
      is_zero_previous: false,
      is_no_change: true,
    };
  }

  const raw_pct = ((today_val - yesterday_val) / yesterday_val) * 100;
  const rounded_pct = Math.round(raw_pct * 10) / 10;

  return {
    change_pct: rounded_pct,
    previous_value: yesterday_val,
    is_zero_previous: false,
    is_no_change: false,
  };
}

/**
 * Groups and sorts clinic chart points
 * - If > 10 clinics in "All", retains top 10 and groups remainder into "Others" (BR-52)
 * - Identifies top clinics supporting tie-breaks (BR-50, BR-51)
 */
export function process_chart_points(
  raw_points: ClinicChartPoint[],
  currency?: string
): ClinicChartData {
  if (raw_points.length === 0) {
    return {
      points: [],
      total: 0,
      currency,
      top_clinics: [],
    };
  }

  const total = raw_points.reduce((acc, pt) => acc + pt.value, 0);

  // Find max value
  const max_val = Math.max(...raw_points.map((pt) => pt.value));
  const top_matching = raw_points.filter((pt) => pt.value === max_val && pt.value > 0);
  const top_clinics = top_matching.map((pt) => pt.clinic_name);
  const tied_count = top_clinics.length > 1 ? top_clinics.length : undefined;

  let points: ClinicChartPoint[];

  if (raw_points.length > 10) {
    // Sort descending by value
    const sorted = [...raw_points].sort((a, b) => b.value - a.value);
    const top_10 = sorted.slice(0, 10);
    const others = sorted.slice(10);
    const others_sum = others.reduce((acc, pt) => acc + pt.value, 0);

    points = [
      ...top_10,
      {
        clinic_id: "others",
        clinic_name: "Others",
        value: others_sum,
        currency,
      },
    ];
  } else {
    points = raw_points;
  }

  return {
    points,
    total,
    currency,
    top_clinics,
    tied_count,
  };
}

/**
 * Progressive Mock Service API
 */
export const DashboardMockService = {
  /**
   * Retrieves 4 Statistics Cards metrics with previous-day comparisons
   */
  async getDashboardStats(): Promise<DashboardStats> {
    await simulate_latency(200);

    const today_appts = 18;
    const yesterday_appts = 15;
    const today_rev = 4850;
    const yesterday_rev = 4100;

    return {
      today_appointments: {
        count: today_appts,
        comparison: calculate_comparison(today_appts, yesterday_appts),
      },
      total_patients: 370,
      pending_appointments: 5,
      today_revenue: {
        amount: today_rev,
        currency: "EGP",
        comparison: calculate_comparison(today_rev, yesterday_rev),
      },
    };
  },

  /**
   * Retrieves list of clinics belonging to doctor
   */
  async getDoctorClinicsList(): Promise<ClinicOption[]> {
    await simulate_latency(150);
    return [...MASTER_CLINICS];
  },

  /**
   * Retrieves Patients by Clinic chart dataset
   */
  async getPatientsByClinic(
    range: DateRangePreset = "last_30_days",
    custom_range?: CustomDateRange,
    clinic_id?: string
  ): Promise<ClinicChartData> {
    await simulate_latency(250);

    const multiplier = PRESET_MULTIPLIERS[range]?.patient_factor ?? 1.0;

    // Base mock patient values for each clinic
    const base_values: Record<string, number> = {
      clinic_1: 120,
      clinic_2: 85,
      clinic_3: 65,
      clinic_4: 45,
      clinic_5: 35,
      clinic_6: 28,
      clinic_7: 24,
      clinic_8: 20,
      clinic_9: 16,
      clinic_10: 12,
      clinic_11: 10,
      clinic_12: 8,
    };

    let raw_points: ClinicChartPoint[];

    if (clinic_id && clinic_id !== "all") {
      const clinic = MASTER_CLINICS.find((c) => c.id === clinic_id);
      const val = Math.round((base_values[clinic_id] || 40) * multiplier);
      raw_points = clinic
        ? [{ clinic_id: clinic.id, clinic_name: clinic.name, value: val }]
        : [];
    } else {
      raw_points = MASTER_CLINICS.map((clinic) => ({
        clinic_id: clinic.id,
        clinic_name: clinic.name,
        value: Math.round((base_values[clinic.id] || 30) * multiplier),
      }));
    }

    return process_chart_points(raw_points);
  },

  /**
   * Retrieves Revenue by Clinic chart dataset
   * Supports negative net values if refunds exceed receipts (BR-54 to BR-57)
   */
  async getRevenueByClinic(
    range: DateRangePreset = "last_30_days",
    custom_range?: CustomDateRange,
    clinic_id?: string
  ): Promise<ClinicChartData> {
    await simulate_latency(250);

    const multiplier = PRESET_MULTIPLIERS[range]?.revenue_factor ?? 1.0;

    // Base mock revenue values in EGP (includes a soft negative clinic for refunds test)
    const base_values: Record<string, number> = {
      clinic_1: 42000,
      clinic_2: 29500,
      clinic_3: 22000,
      clinic_4: 15400,
      clinic_5: 11800,
      clinic_6: 9200,
      clinic_7: 7800,
      clinic_8: 6500,
      clinic_9: 5200,
      clinic_10: -650, // Realized negative refund adjustment
      clinic_11: 1800,
      clinic_12: 1200,
    };

    let raw_points: ClinicChartPoint[];

    if (clinic_id && clinic_id !== "all") {
      const clinic = MASTER_CLINICS.find((c) => c.id === clinic_id);
      const val = Math.round((base_values[clinic_id] || 12000) * multiplier);
      raw_points = clinic
        ? [
            {
              clinic_id: clinic.id,
              clinic_name: clinic.name,
              value: val,
              currency: "EGP",
            },
          ]
        : [];
    } else {
      raw_points = MASTER_CLINICS.map((clinic) => ({
        clinic_id: clinic.id,
        clinic_name: clinic.name,
        value: Math.round((base_values[clinic.id] || 8000) * multiplier),
        currency: "EGP",
      }));
    }

    return process_chart_points(raw_points, "EGP");
  },

  /**
   * Retrieves exactly latest 5 recent activity events in reverse chronological order
   */
  async getRecentActivities(): Promise<RecentActivityItem[]> {
    await simulate_latency(200);

    const now = Date.now();
    return [
      {
        id: "act_1",
        category: "appointment_created",
        description: "New appointment booked for Ahmed Youssef (Cardiology Follow-up)",
        occurred_at: new Date(now - 12 * 60 * 1000).toISOString(),
        patient_name: "Ahmed Youssef",
      },
      {
        id: "act_2",
        category: "payment_recorded",
        description: "Payment of 550 EGP received for Consultation Fee",
        occurred_at: new Date(now - 45 * 60 * 1000).toISOString(),
        amount: "550 EGP",
      },
      {
        id: "act_3",
        category: "appointment_completed",
        description: "Consultation completed for Mona Mahmoud with diagnosis logged",
        occurred_at: new Date(now - 2 * 60 * 60 * 1000).toISOString(),
        patient_name: "Mona Mahmoud",
      },
      {
        id: "act_4",
        category: "rating_received",
        description: "New 5-star clinical review received from Tarek Mansour",
        occurred_at: new Date(now - 4 * 60 * 60 * 1000).toISOString(),
        stars: 5,
      },
      {
        id: "act_5",
        category: "appointment_cancelled",
        description: "Appointment cancelled by Omar Sherif due to personal emergency",
        occurred_at: new Date(now - 7 * 60 * 60 * 1000).toISOString(),
        patient_name: "Omar Sherif",
      },
    ];
  },

  /**
   * Retrieves aggregate patient rating and star breakdown
   * Supports empty state guard (BR-67)
   */
  async getPatientRating(empty_state = false): Promise<PatientRatingData> {
    await simulate_latency(200);

    if (empty_state) {
      return {
        aggregate_rating: null,
        total_reviews: 0,
        distribution: [],
      };
    }

    return {
      aggregate_rating: 4.8,
      total_reviews: 128,
      distribution: [
        { stars: 5, count: 98, percentage: 76.5 },
        { stars: 4, count: 20, percentage: 15.6 },
        { stars: 3, count: 6, percentage: 4.7 },
        { stars: 2, count: 3, percentage: 2.3 },
        { stars: 1, count: 1, percentage: 0.9 },
      ],
    };
  },

  /**
   * Retrieves Doctor Profile Summary
   */
  async getDoctorProfileSummary(): Promise<DoctorProfileSummary> {
    await simulate_latency(150);

    return {
      id: "doc_101",
      full_name: "Dr. Sara Hassan",
      display_name: "Sara Hassan",
      specialty: "Senior Consultant Cardiologist",
      profile_image_url: "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=300",
      unread_notifications_count: 3,
    };
  },
};

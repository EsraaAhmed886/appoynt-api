/*
 * File Name: dashboard_context.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, @/types/dashboard, @/services/dashboard_mock_service
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Unified React Context provider for doctor dashboard state, independent chart filters, race-condition mitigation tokens, and RBAC CTA controls (AC-01 to AC-25).
 */

"use client";

import React, { createContext, useContext, useEffect, useRef, useState, useCallback } from "react";
import {
  ClinicChartData,
  ClinicOption,
  CustomDateRange,
  DashboardStats,
  DateRangePreset,
  DoctorProfileSummary,
  LiveQueueSummary,
  PatientRatingData,
  RecentActivityItem,
} from "@/types/dashboard";
import { DashboardMockService } from "@/services/dashboard_mock_service";

interface DashboardContextType {
  // Doctor Profile
  doctor_profile: DoctorProfileSummary | null;

  // Filter States
  date_range_preset: DateRangePreset;
  custom_date_range?: CustomDateRange;
  set_date_range: (preset: DateRangePreset, custom?: CustomDateRange) => void;

  // Clinic Options
  clinics_list: ClinicOption[];
  clinics_loading: boolean;

  // 4 KPI Statistics Cards
  stats: DashboardStats | null;
  stats_loading: boolean;
  stats_error: string | null;
  refresh_stats: () => Promise<void>;

  // Live Waiting Room Queue
  live_queue: LiveQueueSummary | null;
  live_queue_loading: boolean;
  refresh_live_queue: () => Promise<void>;

  // Patients by Clinic Chart
  patients_clinic_id: string;
  set_patients_clinic_id: (clinic_id: string) => void;
  patients_chart: ClinicChartData | null;
  patients_loading: boolean;
  patients_error: string | null;
  refresh_patients_chart: () => Promise<void>;

  // Revenue by Clinic Chart
  revenue_clinic_id: string;
  set_revenue_clinic_id: (clinic_id: string) => void;
  revenue_chart: ClinicChartData | null;
  revenue_loading: boolean;
  revenue_error: string | null;
  refresh_revenue_chart: () => Promise<void>;

  // Recent Activity
  activities: RecentActivityItem[];
  activities_loading: boolean;
  activities_error: string | null;
  refresh_activities: () => Promise<void>;

  // Patient Rating
  rating: PatientRatingData | null;
  rating_loading: boolean;
  rating_error: string | null;
  refresh_rating: () => Promise<void>;

  // Permission Flags
  can_add_appointment: boolean;
  can_add_receptionist: boolean;
  can_add_clinic: boolean;
}

const DashboardContext = createContext<DashboardContextType | undefined>(undefined);

export const DashboardProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  // Doctor Profile State
  const [doctor_profile, set_doctor_profile] = useState<DoctorProfileSummary | null>(null);

  // Global Date Range State (Affects ONLY Patients and Revenue charts per BR-22, BR-36)
  const [date_range_preset, set_date_range_preset] = useState<DateRangePreset>("last_30_days");
  const [custom_date_range, set_custom_date_range] = useState<CustomDateRange | undefined>(undefined);

  // Clinic Options List
  const [clinics_list, set_clinics_list] = useState<ClinicOption[]>([]);
  const [clinics_loading, set_clinics_loading] = useState(true);

  // KPI Stats State
  const [stats, set_stats] = useState<DashboardStats | null>(null);
  const [stats_loading, set_stats_loading] = useState(true);
  const [stats_error, set_stats_error] = useState<string | null>(null);

  // Live Waiting Room Queue State
  const [live_queue, set_live_queue] = useState<LiveQueueSummary | null>(null);
  const [live_queue_loading, set_live_queue_loading] = useState(true);

  // Patients Chart State
  const [patients_clinic_id, set_patients_clinic_id_state] = useState<string>("all");
  const [patients_chart, set_patients_chart] = useState<ClinicChartData | null>(null);
  const [patients_loading, set_patients_loading] = useState(true);
  const [patients_error, set_patients_error] = useState<string | null>(null);

  // Revenue Chart State
  const [revenue_clinic_id, set_revenue_clinic_id_state] = useState<string>("all");
  const [revenue_chart, set_revenue_chart] = useState<ClinicChartData | null>(null);
  const [revenue_loading, set_revenue_loading] = useState(true);
  const [revenue_error, set_revenue_error] = useState<string | null>(null);

  // Recent Activity State
  const [activities, set_activities] = useState<RecentActivityItem[]>([]);
  const [activities_loading, set_activities_loading] = useState(true);
  const [activities_error, set_activities_error] = useState<string | null>(null);

  // Rating State
  const [rating, set_rating] = useState<PatientRatingData | null>(null);
  const [rating_loading, set_rating_loading] = useState(true);
  const [rating_error, set_rating_error] = useState<string | null>(null);

  // Permissions (Can be extended with Redux/Auth in production)
  const can_add_appointment = true;
  const can_add_receptionist = true;
  const can_add_clinic = true;

  // Race condition token references (BR-75)
  const patients_req_token = useRef(0);
  const revenue_req_token = useRef(0);

  // 1. Fetch Doctor Profile & Clinics on Mount
  useEffect(() => {
    let mounted = true;
    const fetch_initial_meta = async () => {
      try {
        const [profile, clinics] = await Promise.all([
          DashboardMockService.getDoctorProfileSummary(),
          DashboardMockService.getDoctorClinicsList(),
        ]);
        if (mounted) {
          set_doctor_profile(profile);
          set_clinics_list(clinics);
          set_clinics_loading(false);
        } else {
          // Component unmounted
        }
      } catch (err) {
        if (mounted) {
          set_clinics_loading(false);
        } else {
          // Component unmounted
        }
      }
    };
    fetch_initial_meta();
    return () => {
      mounted = false;
    };
  }, []);

  // 2. Fetch KPI Statistics (Independent of Date Range per BR-22)
  const refresh_stats = useCallback(async () => {
    set_stats_loading(true);
    set_stats_error(null);
    try {
      const data = await DashboardMockService.getDashboardStats();
      set_stats(data);
    } catch (err) {
      set_stats_error("error_loading_stats");
    } finally {
      set_stats_loading(false);
    }
  }, []);

  useEffect(() => {
    refresh_stats();
  }, [refresh_stats]);

  // 3. Fetch Patients Chart (Protected with race-condition token)
  const refresh_patients_chart = useCallback(async () => {
    const current_token = ++patients_req_token.current;
    set_patients_loading(true);
    set_patients_error(null);
    try {
      const data = await DashboardMockService.getPatientsByClinic(
        date_range_preset,
        custom_date_range,
        patients_clinic_id
      );
      if (current_token === patients_req_token.current) {
        set_patients_chart(data);
      } else {
        // Outdated request response discarded
      }
    } catch (err) {
      if (current_token === patients_req_token.current) {
        set_patients_error("error_loading_chart");
      } else {
        // Outdated request response discarded
      }
    } finally {
      if (current_token === patients_req_token.current) {
        set_patients_loading(false);
      } else {
        // Outdated request response discarded
      }
    }
  }, [date_range_preset, custom_date_range, patients_clinic_id]);

  useEffect(() => {
    refresh_patients_chart();
  }, [refresh_patients_chart]);

  // 4. Fetch Revenue Chart (Protected with race-condition token)
  const refresh_revenue_chart = useCallback(async () => {
    const current_token = ++revenue_req_token.current;
    set_revenue_loading(true);
    set_revenue_error(null);
    try {
      const data = await DashboardMockService.getRevenueByClinic(
        date_range_preset,
        custom_date_range,
        revenue_clinic_id
      );
      if (current_token === revenue_req_token.current) {
        set_revenue_chart(data);
      } else {
        // Outdated request response discarded
      }
    } catch (err) {
      if (current_token === revenue_req_token.current) {
        set_revenue_error("error_loading_chart");
      } else {
        // Outdated request response discarded
      }
    } finally {
      if (current_token === revenue_req_token.current) {
        set_revenue_loading(false);
      } else {
        // Outdated request response discarded
      }
    }
  }, [date_range_preset, custom_date_range, revenue_clinic_id]);

  useEffect(() => {
    refresh_revenue_chart();
  }, [refresh_revenue_chart]);

  // 5. Fetch Recent Activities (Independent of Date Range)
  const refresh_activities = useCallback(async () => {
    set_activities_loading(true);
    set_activities_error(null);
    try {
      const data = await DashboardMockService.getRecentActivities();
      set_activities(data);
    } catch (err) {
      set_activities_error("error_loading_activity");
    } finally {
      set_activities_loading(false);
    }
  }, []);

  useEffect(() => {
    refresh_activities();
  }, [refresh_activities]);

  // 6. Fetch Patient Ratings (Independent of Date Range)
  const refresh_rating = useCallback(async () => {
    set_rating_loading(true);
    set_rating_error(null);
    try {
      const data = await DashboardMockService.getPatientRating();
      set_rating(data);
    } catch (err) {
      set_rating_error("error_loading_rating");
    } finally {
      set_rating_loading(false);
    }
  }, []);

  useEffect(() => {
    refresh_rating();
  }, [refresh_rating]);

  // 7. Fetch Live Queue Summary
  const refresh_live_queue = useCallback(async () => {
    set_live_queue_loading(true);
    try {
      const data = await DashboardMockService.getLiveQueueSummary();
      set_live_queue(data);
    } catch {
      set_live_queue(null);
    } finally {
      set_live_queue_loading(false);
    }
  }, []);

  useEffect(() => {
    refresh_live_queue();
  }, [refresh_live_queue]);

  // Date Range Update Handler
  const set_date_range = (preset: DateRangePreset, custom?: CustomDateRange) => {
    set_date_range_preset(preset);
    set_custom_date_range(custom);
  };

  // Independent Clinic Filter Setters (BR-40, BR-43)
  const set_patients_clinic_id = (clinic_id: string) => {
    set_patients_clinic_id_state(clinic_id);
  };

  const set_revenue_clinic_id = (clinic_id: string) => {
    set_revenue_clinic_id_state(clinic_id);
  };

  return (
    <DashboardContext.Provider
      value={{
        doctor_profile,
        date_range_preset,
        custom_date_range,
        set_date_range,
        clinics_list,
        clinics_loading,
        stats,
        stats_loading,
        stats_error,
        refresh_stats,
        live_queue,
        live_queue_loading,
        refresh_live_queue,
        patients_clinic_id,
        set_patients_clinic_id,
        patients_chart,
        patients_loading,
        patients_error,
        refresh_patients_chart,
        revenue_clinic_id,
        set_revenue_clinic_id,
        revenue_chart,
        revenue_loading,
        revenue_error,
        refresh_revenue_chart,
        activities,
        activities_loading,
        activities_error,
        refresh_activities,
        rating,
        rating_loading,
        rating_error,
        refresh_rating,
        can_add_appointment,
        can_add_receptionist,
        can_add_clinic,
      }}
    >
      {children}
    </DashboardContext.Provider>
  );
};

export const useDashboard = (): DashboardContextType => {
  const context = useContext(DashboardContext);
  if (!context) {
    throw new Error("useDashboard must be used within a DashboardProvider");
  } else {
    return context;
  }
};

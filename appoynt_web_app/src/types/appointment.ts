/*
 * File Name: appointment.ts
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.0.0
 * Dependencies: None
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 18/08/2026]
 * Description: TypeScript interfaces and type definitions for appointment status, patient quick summary, active consultation, queue items, and time slots.
 */

// Appointment and consultation statuses
export type appointment_status =
  | "available"
  | "booked"
  | "in_consultation"
  | "completed"
  | "blocked"
  | "break";

// Queue item statuses
export type queue_status =
  | "in_consultation"
  | "checked_in"
  | "waiting"
  | "not_arrived";

// Patient quick summary model (Quick Snapshot)
export interface patient_quick_summary {
  chronic_diseases?: string[];
  allergies?: string[];
  last_visit_date?: string;
}

// Basic patient profile information
export interface patient_info {
  id: string;
  full_name: string;
  age?: number;
  gender?: "male" | "female";
  phone_number?: string;
  profile_image_url?: string;
  visit_type?: "follow_up" | "new";
  visit_duration_mins?: number;
  summary?: patient_quick_summary;
}

// Currently active consultation details
export interface active_consultation {
  consultation_id: string;
  appointment_id: string;
  patient: patient_info;
  started_at: string; // ISO string format (e.g. 2026-08-18T10:20:00Z)
  expected_time: string; // e.g. "10:15 AM"
  actual_time: string;   // e.g. "10:20 AM"
  status: appointment_status;
}

// Queue list item model
export interface queue_item {
  id: string;
  appointment_id: string;
  patient: patient_info;
  scheduled_time: string;
  visit_type: "new" | "follow_up";
  status: queue_status;
  estimated_wait_mins?: number;
}

// Individual time slot model
export interface time_slot {
  id: string;
  time: string; // e.g. "09:00 AM"
  status: appointment_status;
  patient_name?: string;
}

// Overall appointments page data payload
export interface appointments_data_response {
  selected_date: string;
  active_consultation: active_consultation | null;
  queue: queue_item[];
  time_slots: time_slot[];
}

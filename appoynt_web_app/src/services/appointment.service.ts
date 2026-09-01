/*
 * File Name: appointment.service.ts
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.1.0
 * Dependencies: @/types/appointment, @/data/mock_appointments_data
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 01/09/2026]
 * Description: Service layer abstracting appointment data fetching and automated consultation queue transition.
 */

import { initial_appointments_data } from "@/data/mock_appointments_data";
import { appointments_data_response, active_consultation } from "@/types/appointment";

const storage_key = "appoynt_appointments_data";

let memory_data: appointments_data_response = JSON.parse(JSON.stringify(initial_appointments_data));

// Helper function to read appointments state from LocalStorage or memory
function get_stored_data(): appointments_data_response {
  if ("undefined" === typeof window) {
    return memory_data;
  } else {
    try {
      const raw_data = localStorage.getItem(storage_key);
      if (null !== raw_data) {
        return JSON.parse(raw_data) as appointments_data_response;
      } else {
        // Persist initial seed data with start timestamp into LocalStorage on first access
        save_stored_data(initial_appointments_data);
        return initial_appointments_data;
      }
    } catch (storage_error) {
      console.warn("Failed to read appointments from localStorage:", storage_error);
      return memory_data;
    }
  }
}

// Helper function to persist updated state locally for testing
function save_stored_data(data: appointments_data_response): void {
  memory_data = data;
  if ("undefined" === typeof window) {
    return;
  } else {
    try {
      localStorage.setItem(storage_key, JSON.stringify(data));
    } catch (storage_error) {
      console.warn("Failed to save appointments to localStorage:", storage_error);
    }
  }
}

/**
 * Appointment Service (Data Abstraction Layer)
 * UI components only call these async methods.
 * When real API is ready, replace internal logic with axios.get/post calls.
 */
export const appointment_service = {
  // Fetch today's appointments dashboard data
  get_appointments_by_date: async (date?: string): Promise<appointments_data_response> => {
    // Simulate async network latency (300ms)
    await new Promise((resolve) => setTimeout(resolve, 300));
    const current_data = get_stored_data();
    if (date) {
      return { ...current_data, selected_date: date };
    } else {
      return current_data;
    }
  },

  // End active consultation without automatically starting the next patient
  end_consultation: async (consultation_id: string): Promise<{ success: boolean; data: appointments_data_response }> => {
    // Simulate async network latency (400ms)
    await new Promise((resolve) => setTimeout(resolve, 400));
    const current_data = get_stored_data();

    if (null !== current_data.active_consultation && consultation_id === current_data.active_consultation.consultation_id) {
      const active_appointment_id = current_data.active_consultation.appointment_id;

      // 1. Remove currently completed patient from waiting queue
      const remaining_queue = current_data.queue.filter(
        (item) => item.appointment_id !== active_appointment_id
      );

      // 2. Update time slots grid statuses: mark previous active slot as completed
      const updated_slots = current_data.time_slots.map((slot) => {
        if ("in_consultation" === slot.status) {
          return { ...slot, status: "completed" as const };
        } else {
          return slot;
        }
      });

      // 3. Keep active_consultation as null until doctor explicitly clicks Start Consultation
      const updated_data: appointments_data_response = {
        ...current_data,
        active_consultation: null,
        queue: remaining_queue,
        time_slots: updated_slots,
      };

      save_stored_data(updated_data);
      return { success: true, data: updated_data };
    } else {
      return { success: true, data: current_data };
    }
  },

  // Explicitly start consultation for a queued patient upon doctor action
  start_consultation: async (patient_queue_id: string): Promise<{ success: boolean; data: appointments_data_response }> => {
    // Simulate async network latency (300ms)
    await new Promise((resolve) => setTimeout(resolve, 300));
    const current_data = get_stored_data();

    // Guard: Cannot start a new consultation if one is already active
    if (null !== current_data.active_consultation) {
      return { success: false, data: current_data };
    } else {
      // No action needed
    }

    // Find the next eligible patient in queue
    const next_eligible_item = current_data.queue.find(
      (item) => "in_consultation" !== item.status
    );

    if (undefined === next_eligible_item) {
      return { success: false, data: current_data };
    } else {
      // No action needed
    }

    // Guard: Cannot start consultation for a patient who is not currently next in queue
    if (
      next_eligible_item.id !== patient_queue_id &&
      next_eligible_item.appointment_id !== patient_queue_id
    ) {
      return { success: false, data: current_data };
    } else {
      // No action needed
    }

    const target_item = next_eligible_item;

    // 1. Construct new active consultation object with freshly initialized started_at timestamp
    const new_active_consultation: active_consultation = {
      consultation_id: `cons_${target_item.id}`,
      appointment_id: target_item.appointment_id,
      patient: {
        ...target_item.patient,
        phone_number: target_item.patient.phone_number ?? "0102 345 6789",
        visit_duration_mins: target_item.patient.visit_duration_mins ?? 15,
        summary: target_item.patient.summary ?? {
          chronic_diseases: ["Hypertension"],
          allergies: ["Penicillin"],
          last_visit_date: "May 10, 2024",
        },
      },
      started_at: new Date().toISOString(), // Start timer fresh from 00:00:00 for the newly started patient
      expected_time: target_item.scheduled_time,
      actual_time: target_item.scheduled_time,
      status: "in_consultation",
    };

    // 2. Update status of the activated patient in queue
    const updated_queue = current_data.queue.map((item) => {
      if (item.id === target_item.id) {
        return {
          ...item,
          status: "in_consultation" as const,
          estimated_wait_mins: undefined,
        };
      } else {
        return item;
      }
    });

    // 3. Update time slots grid statuses
    const updated_slots = current_data.time_slots.map((slot) => {
      if (slot.time === target_item.scheduled_time || (slot.patient_name && slot.patient_name === target_item.patient.full_name)) {
        return { ...slot, status: "in_consultation" as const, patient_name: target_item.patient.full_name };
      } else {
        return slot;
      }
    });

    const updated_data: appointments_data_response = {
      ...current_data,
      active_consultation: new_active_consultation,
      queue: updated_queue,
      time_slots: updated_slots,
    };

    save_stored_data(updated_data);
    return { success: true, data: updated_data };
  },

  // Reset local state to initial mock data (for testing purposes)
  reset_to_mock_data: async (): Promise<appointments_data_response> => {
    memory_data = JSON.parse(JSON.stringify(initial_appointments_data));
    if ("undefined" !== typeof window) {
      localStorage.removeItem(storage_key);
    } else {
      // Server-side context
    }
    return memory_data;
  },
};

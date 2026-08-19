/*
 * File Name: appointment.service.ts
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.1.0
 * Dependencies: @/types/appointment, @/data/mock_appointments_data
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 18/08/2026]
 * Description: Service layer abstracting appointment data fetching and actions with persistent consultation_start_time timestamp preservation.
 */

import { initial_appointments_data } from "@/data/mock_appointments_data";
import { appointments_data_response } from "@/types/appointment";

const storage_key = "appoynt_appointments_data";

// Helper function to read appointments state from LocalStorage or seed data
function get_stored_data(): appointments_data_response {
  if ("undefined" === typeof window) {
    return initial_appointments_data;
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
      return initial_appointments_data;
    }
  }
}

// Helper function to persist updated state locally for testing
function save_stored_data(data: appointments_data_response): void {
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

  // End currently active consultation
  end_consultation: async (consultation_id: string): Promise<{ success: boolean; data: appointments_data_response }> => {
    // Simulate async network latency (400ms)
    await new Promise((resolve) => setTimeout(resolve, 400));
    const current_data = get_stored_data();

    if (null !== current_data.active_consultation && consultation_id === current_data.active_consultation.consultation_id) {
      const active_appointment_id = current_data.active_consultation.appointment_id;

      // Filter out completed consultation patient from active queue
      const updated_queue = current_data.queue.filter(
        (item) => item.appointment_id !== active_appointment_id
      );

      // Update time slot status to completed
      const updated_slots = current_data.time_slots.map((slot) => {
        if ("in_consultation" === slot.status) {
          return { ...slot, status: "completed" as const };
        } else {
          return slot;
        }
      });

      const updated_data: appointments_data_response = {
        ...current_data,
        active_consultation: null,
        queue: updated_queue,
        time_slots: updated_slots,
      };

      save_stored_data(updated_data);
      return { success: true, data: updated_data };
    } else {
      return { success: true, data: current_data };
    }
  },

  // Reset local state to initial mock data (for testing purposes)
  reset_to_mock_data: async (): Promise<appointments_data_response> => {
    if ("undefined" !== typeof window) {
      localStorage.removeItem(storage_key);
    } else {
      // Server-side context
    }
    return initial_appointments_data;
  },
};

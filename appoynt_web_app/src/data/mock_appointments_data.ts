/*
 * File Name: mock_appointments_data.ts
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.1.0
 * Dependencies: @/types/appointment
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Seed mock dataset for daily appointments, active patient consultation, waiting queue, and time slots matching the UI design specs.
 */

import { appointments_data_response } from "@/types/appointment";

export const initial_appointments_data: appointments_data_response = {
  selected_date: "May 21, 2024",

  // No active consultation initially on load/initialization
  active_consultation: null,

  // Waiting queue list with complete patient profiles
  queue: [
    {
      id: "q_1",
      appointment_id: "app_101",
      patient: {
        id: "PAT-9823",
        full_name: "Mohamed Ali",
        age: 26,
        gender: "male",
        phone_number: "0102 345 6789",
        visit_type: "follow_up",
        visit_duration_mins: 15,
        summary: {
          chronic_diseases: ["Hypertension"],
          allergies: ["Penicillin"],
          last_visit_date: "Apr 10, 2024",
        },
      },
      scheduled_time: "10:15 AM",
      visit_type: "follow_up",
      status: "checked_in",
      estimated_wait_mins: 0,
    },
    {
      id: "q_2",
      appointment_id: "app_102",
      patient: {
        id: "PAT-4192",
        full_name: "Sara Hossam",
        age: 32,
        gender: "female",
        phone_number: "0111 892 3456",
        visit_type: "new",
        visit_duration_mins: 20,
        summary: {
          chronic_diseases: ["Diabetes Type 2"],
          allergies: ["Latex"],
          last_visit_date: "May 02, 2024",
        },
      },
      scheduled_time: "10:30 AM",
      visit_type: "new",
      status: "checked_in",
      estimated_wait_mins: 5,
    },
    {
      id: "q_3",
      appointment_id: "app_103",
      patient: {
        id: "PAT-3381",
        full_name: "Omar Khaled",
        age: 45,
        gender: "male",
        phone_number: "0122 743 9182",
        visit_type: "follow_up",
        visit_duration_mins: 15,
        summary: {
          chronic_diseases: ["Asthma"],
          allergies: ["Aspirin"],
          last_visit_date: "Mar 15, 2024",
        },
      },
      scheduled_time: "11:00 AM",
      visit_type: "follow_up",
      status: "waiting",
      estimated_wait_mins: 10,
    },
    {
      id: "q_4",
      appointment_id: "app_104",
      patient: {
        id: "PAT-7720",
        full_name: "Nourhan Saad",
        age: 23,
        gender: "female",
        phone_number: "0100 564 1239",
        visit_type: "new",
        visit_duration_mins: 15,
        summary: {
          chronic_diseases: ["Anemia"],
          allergies: ["None"],
          last_visit_date: "Apr 28, 2024",
        },
      },
      scheduled_time: "11:30 AM",
      visit_type: "new",
      status: "not_arrived",
      estimated_wait_mins: 20,
    },
  ],

  // Time slots grid matching the right panel in wireframe
  time_slots: [
    { id: "ts_1", time: "09:00 AM", status: "booked", patient_name: "Mohamed Ali" },
    { id: "ts_2", time: "09:30 AM", status: "booked", patient_name: "Tarek Ahmed" },
    { id: "ts_3", time: "10:00 AM", status: "booked", patient_name: "Mona Hassan" },
    { id: "ts_4", time: "10:30 AM", status: "available" },
    { id: "ts_5", time: "11:00 AM", status: "available" },
    { id: "ts_6", time: "11:30 AM", status: "available" },
    { id: "ts_7", time: "12:00 PM", status: "break" },
    { id: "ts_8", time: "12:30 PM", status: "break" },
    { id: "ts_9", time: "01:00 PM", status: "available" },
    { id: "ts_10", time: "01:30 PM", status: "available" },
  ],
};

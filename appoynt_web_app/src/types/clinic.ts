/*
 * File Name: clinic.ts
 * Author: shimaa salah
 * Date of Creation: 05/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Centralized domain type declarations for Clinic entities, form states, schedule items, break items, and validation errors.
 */

export type Clinic = {
  id: number;
  name: string;
  location: string;
  phone: string;
  consultation_fee?: string;
  consultationFee?: string;
  working_days?: string;
  workingDays?: string;
  status: string;
};

export type WorkingScheduleItem = {
  day: string;
  startTime: string;
  endTime: string;
};

export type BreakTimeItem = {
  day: string;
  breakStart: string;
  breakEnd: string;
};

export type ReceptionistItem = {
  id: string;
  name: string;
  phone: string;
  status: string;
  initials: string;
};

export type ClinicFormState = {
  current_step: number;
  clinic_name: string;
  clinic_name_error: string;
  phone: string;
  phone_error: string;
  governorate: string;
  governorate_error: string;
  city: string;
  city_error: string;
  address: string;
  address_error: string;
  consultation_fee: string;
  consultation_fee_error: string;
  working_days: string[];
  working_days_error: string;
  status: string;
  schedule_list: WorkingScheduleItem[];
  break_list: BreakTimeItem[];
  assigned_receptionists: ReceptionistItem[];
  appointment_duration: string;
  max_advance_booking: string;
  is_dirty: boolean;
  is_success_open: boolean;
  is_unsaved_modal_open: boolean;
};

export type ClinicValidationErrors = {
  clinic_name?: string;
  phone?: string;
  governorate?: string;
  city?: string;
  address?: string;
  consultation_fee?: string;
};

/*
 * File Name: receptionist.ts
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: TypeScript domain definitions and interfaces for clinic receptionists management, clinic assignments, query filters, and validation schemas.
 */

export type ReceptionistStatus = "active" | "inactive";
export type ReceptionistSortOption = "newest" | "oldest" | "name_asc" | "name_desc";

export interface AssignedClinic {
  id: string;
  name: string;
  is_active: boolean; // Marks deleted/deactivated clinics
}

export interface Receptionist {
  id: string;
  full_name: string;
  username: string; // System-wide unique (case-insensitive)
  phone_number: string; // Egyptian format: 01XXXXXXXXX (unique)
  assigned_clinics: AssignedClinic[];
  status: ReceptionistStatus;
  created_at: string; // ISO 8601 UTC
}

export interface ReceptionistFormData {
  full_name: string;
  username: string;
  phone_number: string;
  password?: string; // Mandatory on creation, optional on edit
  clinic_ids: string[];
  status: ReceptionistStatus;
}

export interface DoctorClinic {
  id: string;
  name: string;
  address?: string;
  is_active: boolean;
}

export interface ReceptionistQueryParams {
  search?: string;
  sort?: ReceptionistSortOption;
  clinic_id?: string;
  status?: "ALL" | ReceptionistStatus;
  page: number;
  limit: number;
}

export interface ReceptionistListResponse {
  data: Receptionist[];
  total: number;
  page: number;
  limit: number;
  total_pages: number;
}

export interface ReceptionistStats {
  total: number;
  active: number;
  inactive: number;
  covered_clinics: number;
}

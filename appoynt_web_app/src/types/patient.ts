/**

File Name : patient.ts

Author : Shimaa Salah

Created Date : 28/08/2026

Version : v1.0.0

Dependencies : None

Contributors : [Shimaa Salah]

Last Modified : Shimaa Salah - 28/08/2026

Description : Defines core domain interfaces, status types, AI priority enums, query filter payloads, and API response structures for Patient Management.

*/

export type PatientStatus =
  | "Active"
  | "In Consultation"
  | "Follow-up Required"
  | "Inactive"
  | "Archived";

export type AiPriority = "Low" | "Medium" | "High" | "Unavailable";

export type Gender = "Male" | "Female";

export type FollowUpStatus = "None" | "Scheduled" | "Overdue" | "Completed";

export type ExportFormat = "pdf" | "excel" | "csv";

export type SortField = "name" | "gender" | "lastVisitDate";

export type SortOrder = "asc" | "desc";

export interface Patient {
  id: string;
  patientId: string;
  name: string;
  avatarUrl?: string;
  phone: string;
  age: number;
  gender: Gender;
  lastVisitDate: string;
  status: PatientStatus;
  aiPriority?: AiPriority;
  aiExplanation?: string;
  followUpStatus: FollowUpStatus;
  urgentAttention?: boolean;
  assignedDoctorId: string;
}

export interface PatientFilters {
  gender?: Gender | "All";
  status?: PatientStatus | "All";
  followUpStatus?: FollowUpStatus | "All";
}

export interface PatientQueryParams {
  search?: string;
  filters?: PatientFilters;
  sortField?: SortField;
  sortOrder?: SortOrder;
  page?: number;
  pageSize?: number;
}

export interface PatientListResponse {
  patients: Patient[];
  totalRecords: number;
  currentPage: number;
  totalPages: number;
  pageSize: number;
}

export interface CreateFollowUpPayload {
  patientId: string;
  appointmentDate: string;
  appointmentTime: string;
  notes?: string;
}

export interface FollowUpResponse {
  success: boolean;
  appointmentId: string;
  message: string;
}

export interface ExportPatientsPayload {
  search?: string;
  filters?: PatientFilters;
  sortField?: SortField;
  sortOrder?: SortOrder;
  format: ExportFormat;
}

/**

File Name : patient_constants.ts
Author : Shimaa Salah
Created Date : 28/08/2026
Version : v1.0.0
Dependencies : @/types/patient
Contributors : [Shimaa Salah]
Last Modified : Shimaa Salah - 28/08/2026
Description : Defines centralized business rules, pagination defaults, search thresholds, styling badge mappings, and filter/sort options for Patient Management.

*/

import {
  PatientStatus,
  Gender,
  FollowUpStatus,
  ExportFormat,
  SortField,
  SortOrder,
} from "@/types/patient";

export const MIN_SEARCH_LENGTH: number = 2;

export const DEBOUNCE_DELAY_MS: number = 150;

export const DEFAULT_PAGE_SIZE: number = 10;

export const MAX_SIMULATED_RECORDS: number = 10000;

export const PATIENT_STATUS_OPTIONS: Array<{
  value: PatientStatus | "All";
  labelKey: string;
}> = [
  { value: "All", labelKey: "filter_all_statuses" },
  { value: "Active", labelKey: "patient_status_active" },
  { value: "In Consultation", labelKey: "status_in_consultation" },
  { value: "Follow-up Required", labelKey: "status_follow_up_required" },
  { value: "Inactive", labelKey: "patient_status_inactive" },
  { value: "Archived", labelKey: "status_archived" },
];

export const GENDER_OPTIONS: Array<{
  value: Gender | "All";
  labelKey: string;
}> = [
  { value: "All", labelKey: "filter_all_genders" },
  { value: "Male", labelKey: "gender_male" },
  { value: "Female", labelKey: "gender_female" },
];

export const FOLLOWUP_STATUS_OPTIONS: Array<{
  value: FollowUpStatus | "All";
  labelKey: string;
}> = [
  { value: "All", labelKey: "filter_all_followups" },
  { value: "None", labelKey: "filter_all_followups" },
  { value: "Scheduled", labelKey: "visit_type_follow_up" },
  { value: "Overdue", labelKey: "status_follow_up_required" },
  { value: "Completed", labelKey: "completed_badge" },
];

export const SORT_OPTIONS: Array<{
  field: SortField;
  order: SortOrder;
  labelKey: string;
}> = [
  {
    field: "lastVisitDate",
    order: "desc",
    labelKey: "sort_last_visit_desc",
  },
  {
    field: "lastVisitDate",
    order: "asc",
    labelKey: "sort_last_visit_asc",
  },
  {
    field: "name",
    order: "asc",
    labelKey: "patient_sort_name_asc",
  },
  {
    field: "name",
    order: "desc",
    labelKey: "patient_sort_name_desc",
  },
];

export const EXPORT_FORMAT_OPTIONS: Array<{
  format: ExportFormat;
  labelKey: string;
}> = [
  { format: "pdf", labelKey: "export_pdf" },
  { format: "excel", labelKey: "export_excel" },
  { format: "csv", labelKey: "export_csv" },
];

export const PATIENT_STATUS_BADGES: Record<PatientStatus, string> = {
  Active:
    "bg-emerald-100 text-emerald-800 dark:bg-emerald-950/60 dark:text-emerald-300 border-emerald-200 dark:border-emerald-800",
  "In Consultation":
    "bg-blue-100 text-blue-800 dark:bg-blue-950/60 dark:text-blue-300 border-blue-200 dark:border-blue-800",
  "Follow-up Required":
    "bg-amber-100 text-amber-800 dark:bg-amber-950/60 dark:text-amber-300 border-amber-200 dark:border-amber-800",
  Inactive:
    "bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300 border-slate-200 dark:border-slate-700",
  Archived:
    "bg-purple-100 text-purple-800 dark:bg-purple-950/60 dark:text-purple-300 border-purple-200 dark:border-purple-800",
};

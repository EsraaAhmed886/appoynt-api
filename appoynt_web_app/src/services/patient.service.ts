/**

File Name : patient.service.ts

Author : Shimaa Salah

Created Date : 28/08/2026

Version : v1.2.0

Dependencies :
  - @/types/patient
  - @/constants/patient_constants

Contributors : [Shimaa Salah]

Last Modified : Shimaa Salah - 28/08/2026

Description : Patient API service layer abstraction managing patient queries with prefix search matching, follow-up scheduling, export generation, and clinical security validation.

*/

import {
  Patient,
  PatientQueryParams,
  PatientListResponse,
  CreateFollowUpPayload,
  FollowUpResponse,
  ExportPatientsPayload,
} from "@/types/patient";
import {
  MIN_SEARCH_LENGTH,
  DEFAULT_PAGE_SIZE,
} from "@/constants/patient_constants";

// Stable, realistic mock dataset representing doctor-assigned patients
const MOCK_ASSIGNED_PATIENTS: Patient[] = [
  {
    id: "pat-101",
    patientId: "P-88201",
    name: "Ahmed Ali Mohamed",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01012345678",
    age: 45,
    gender: "Male",
    lastVisitDate: "12 May 2024",
    status: "Active",
    followUpStatus: "Overdue",
    urgentAttention: true,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-102",
    patientId: "P-88202",
    name: "Fatima Hassan El-Sayed",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01123456789",
    age: 32,
    gender: "Female",
    lastVisitDate: "18 Jun 2024",
    status: "In Consultation",
    followUpStatus: "Scheduled",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-103",
    patientId: "P-88203",
    name: "Mahmoud Ibrahim Farouk",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01234567890",
    age: 58,
    gender: "Male",
    lastVisitDate: "05 Jul 2024",
    status: "Follow-up Required",
    followUpStatus: "Overdue",
    urgentAttention: true,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-104",
    patientId: "P-88204",
    name: "Mona Mohamed Mansour",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01055543210",
    age: 27,
    gender: "Female",
    lastVisitDate: "22 Aug 2024",
    status: "Active",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-105",
    patientId: "P-88205",
    name: "Khaled Youssef Abdelrahman",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01557778899",
    age: 64,
    gender: "Male",
    lastVisitDate: "10 Sep 2024",
    status: "Inactive",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-106",
    patientId: "P-88206",
    name: "Nouran Ahmed Samir",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01012223344",
    age: 41,
    gender: "Female",
    lastVisitDate: "01 Oct 2024",
    status: "Active",
    followUpStatus: "Scheduled",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-107",
    patientId: "P-88207",
    name: "Tarek Mahmoud Al-Sharif",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01146669900",
    age: 50,
    gender: "Male",
    lastVisitDate: "15 Nov 2024",
    status: "Follow-up Required",
    followUpStatus: "Overdue",
    urgentAttention: true,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-108",
    patientId: "P-88208",
    name: "Salma Samir Hamdy",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01283334455",
    age: 29,
    gender: "Female",
    lastVisitDate: "03 Dec 2024",
    status: "Active",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-109",
    patientId: "P-88209",
    name: "Hassan Al-Sharif Ibrahim",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01098881122",
    age: 67,
    gender: "Male",
    lastVisitDate: "20 Jan 2025",
    status: "Archived",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-110",
    patientId: "P-88210",
    name: "Dina Mahmoud Farag",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01124447788",
    age: 38,
    gender: "Female",
    lastVisitDate: "14 Feb 2025",
    status: "Active",
    followUpStatus: "Completed",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-111",
    patientId: "P-88211",
    name: "Omar Farouk Abdelaziz",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01029990011",
    age: 53,
    gender: "Male",
    lastVisitDate: "08 Mar 2025",
    status: "Active",
    followUpStatus: "Scheduled",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-112",
    patientId: "P-88212",
    name: "Rania Hamdy Mostafa",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01151112233",
    age: 46,
    gender: "Female",
    lastVisitDate: "27 Mar 2025",
    status: "Follow-up Required",
    followUpStatus: "Overdue",
    urgentAttention: true,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-113",
    patientId: "P-88213",
    name: "Youssef Ahmed Taha",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01201114455",
    age: 34,
    gender: "Male",
    lastVisitDate: "11 Apr 2025",
    status: "Active",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-114",
    patientId: "P-88214",
    name: "Mariam Aly El-Ghandour",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01077778899",
    age: 26,
    gender: "Female",
    lastVisitDate: "02 May 2025",
    status: "In Consultation",
    followUpStatus: "Scheduled",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-115",
    patientId: "P-88215",
    name: "Sherif Gamal Said",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01188889900",
    age: 61,
    gender: "Male",
    lastVisitDate: "19 May 2025",
    status: "Active",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-116",
    patientId: "P-88216",
    name: "Noha Khaled Fathy",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01299990011",
    age: 39,
    gender: "Female",
    lastVisitDate: "04 Jun 2025",
    status: "Follow-up Required",
    followUpStatus: "Overdue",
    urgentAttention: true,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-117",
    patientId: "P-88217",
    name: "Eslam Mostafa Kamal",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01033334455",
    age: 48,
    gender: "Male",
    lastVisitDate: "21 Jun 2025",
    status: "Active",
    followUpStatus: "Completed",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-118",
    patientId: "P-88218",
    name: "Hoda Reda El-Bakry",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01144445566",
    age: 55,
    gender: "Female",
    lastVisitDate: "13 Jul 2025",
    status: "Inactive",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-119",
    patientId: "P-88219",
    name: "Amr Hussein Zaki",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01255556677",
    age: 42,
    gender: "Male",
    lastVisitDate: "30 Jul 2025",
    status: "Active",
    followUpStatus: "Scheduled",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-120",
    patientId: "P-88220",
    name: "Yasmin Nagy Soliman",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01066667788",
    age: 31,
    gender: "Female",
    lastVisitDate: "16 Aug 2025",
    status: "In Consultation",
    followUpStatus: "Scheduled",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-121",
    patientId: "P-88221",
    name: "Wael Saeed El-Naggar",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01177778899",
    age: 52,
    gender: "Male",
    lastVisitDate: "02 Sep 2025",
    status: "Active",
    followUpStatus: "None",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-122",
    patientId: "P-88222",
    name: "Laila Nabil Mansi",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01288889900",
    age: 28,
    gender: "Female",
    lastVisitDate: "20 Sep 2025",
    status: "Active",
    followUpStatus: "Completed",
    urgentAttention: false,
    assignedDoctorId: "doc-1",
  },
  {
    id: "pat-123",
    patientId: "P-88223",
    name: "Ziad Atef Badawy",
    avatarUrl: "/images/profile_icon.jpeg",
    phone: "01099990011",
    age: 36,
    gender: "Male",
    lastVisitDate: "07 Oct 2025",
    status: "Follow-up Required",
    followUpStatus: "Overdue",
    urgentAttention: true,
    assignedDoctorId: "doc-1",
  },
];

class PatientService {
  /**
   * Fetches paginated, filtered, and sorted patient records for the logged-in clinician.
   */
  public async getPatients(
    params: PatientQueryParams
  ): Promise<PatientListResponse> {
    await new Promise((resolve) => setTimeout(resolve, 30));

    let filteredPatients: Patient[] = [...MOCK_ASSIGNED_PATIENTS];

    if (params.search && params.search.trim().length >= MIN_SEARCH_LENGTH) {
      const normalizedQuery: string = params.search.trim().toLowerCase();

      filteredPatients = filteredPatients.filter((patient: Patient) => {
        const matchesName: boolean =
          patient.name.toLowerCase().startsWith(normalizedQuery) ||
          patient.name
            .toLowerCase()
            .split(" ")
            .some((word: string) => word.startsWith(normalizedQuery));

        const matchesId: boolean = patient.patientId
          .toLowerCase()
          .startsWith(normalizedQuery);

        const matchesPhone: boolean = patient.phone
          .toLowerCase()
          .startsWith(normalizedQuery);

        if (matchesName || matchesId || matchesPhone) {
          return true;
        } else {
          return false;
        }
      });
    } else {
      // Search query string is empty or below length threshold
    }

    if (params.filters) {
      const { gender, status, followUpStatus } = params.filters;

      if (gender && gender !== "All") {
        filteredPatients = filteredPatients.filter(
          (patient: Patient) => patient.gender === gender
        );
      } else {
        // No gender filter applied
      }

      if (status && status !== "All") {
        filteredPatients = filteredPatients.filter(
          (patient: Patient) => patient.status === status
        );
      } else {
        // No status filter applied
      }

      if (followUpStatus && followUpStatus !== "All") {
        filteredPatients = filteredPatients.filter(
          (patient: Patient) => patient.followUpStatus === followUpStatus
        );
      } else {
        // No follow-up status filter applied
      }
    } else {
      // Filters parameter omitted
    }

    const sortField = params.sortField || "lastVisitDate";
    const sortOrder = params.sortOrder || "desc";

    filteredPatients.sort((patientA: Patient, patientB: Patient) => {
      let comparisonValue: number = 0;

      if (sortField === "name") {
        comparisonValue = patientA.name.localeCompare(patientB.name);
      } else if (sortField === "gender") {
        comparisonValue = patientA.gender.localeCompare(patientB.gender);
      } else {
        const dateA: number = new Date(patientA.lastVisitDate).getTime();
        const dateB: number = new Date(patientB.lastVisitDate).getTime();
        comparisonValue = dateA - dateB;
      }

      if (sortOrder === "desc") {
        return -comparisonValue;
      } else {
        return comparisonValue;
      }
    });

    // Dynamic total records calculation from actual query results
    const totalRecords: number = filteredPatients.length;
    const pageSize: number = params.pageSize || DEFAULT_PAGE_SIZE;
    const totalPages: number = Math.ceil(totalRecords / pageSize) || 1;

    // Automatic page number clamping for invalid page requests
    let currentPage: number = params.page || 1;
    if (currentPage > totalPages) {
      currentPage = totalPages;
    } else if (currentPage < 1) {
      currentPage = 1;
    } else {
      // Current page is within valid range
    }

    const startIndex: number = (currentPage - 1) * pageSize;
    const paginatedPatients: Patient[] = filteredPatients.slice(
      startIndex,
      startIndex + pageSize
    );

    return {
      patients: paginatedPatients,
      totalRecords: totalRecords,
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: pageSize,
    };
  }

  /**
   * Schedules a follow-up appointment for a specific patient.
   */
  public async createFollowUp(
    payload: CreateFollowUpPayload
  ): Promise<FollowUpResponse> {
    await new Promise((resolve) => setTimeout(resolve, 300));

    if (!payload.patientId) {
      throw new Error("Patient ID is required to schedule a follow-up.");
    } else {
      // Patient ID is present
    }

    const selectedDate: Date = new Date(
      `${payload.appointmentDate}T${payload.appointmentTime}`
    );
    const currentDate: Date = new Date();

    if (selectedDate.getTime() <= currentDate.getTime()) {
      throw new Error("Appointment date and time must be in the future.");
    } else {
      // Appointment date is valid
    }

    const targetPatient = MOCK_ASSIGNED_PATIENTS.find(
      (patient) => patient.id === payload.patientId || patient.patientId === payload.patientId
    );

    if (targetPatient) {
      targetPatient.followUpStatus = "Scheduled";
      targetPatient.status = "Follow-up Required";
    } else {
      // Patient record not found in mock array
    }

    return {
      success: true,
      appointmentId: `apt-${Date.now()}`,
      message: "Follow-up appointment scheduled successfully.",
    };
  }

  /**
   * Generates a downloadable export file matching active search and filters.
   */
  public async exportPatients(
    payload: ExportPatientsPayload
  ): Promise<{ blobUrl: string; filename: string }> {
    await new Promise((resolve) => setTimeout(resolve, 400));

    const response = await this.getPatients({
      search: payload.search,
      filters: payload.filters,
      sortField: payload.sortField,
      sortOrder: payload.sortOrder,
      page: 1,
      pageSize: 1000,
    });

    if (response.patients.length === 0) {
      throw new Error("No data available to export with current filters.");
    } else {
      // Records found for export
    }

    const extension: string = payload.format;
    const filename: string = `patients_report_${new Date()
      .toISOString()
      .slice(0, 10)}.${extension}`;

    const exportContent: string = JSON.stringify(response.patients, null, 2);
    const blob: Blob = new Blob([exportContent], { type: "application/json" });
    const blobUrl: string = URL.createObjectURL(blob);

    return {
      blobUrl: blobUrl,
      filename: filename,
    };
  }
}

export const patientService = new PatientService();

/*
 * File Name: receptionist_mock_service.ts
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - @/types/receptionist
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Simulated asynchronous mock API service for clinic receptionists management with realistic Egyptian accounts, multi-clinic assignments, search/filter/sort algorithms, uniqueness validation, and pagination.
 */

import {
  Receptionist,
  ReceptionistFormData,
  DoctorClinic,
  ReceptionistQueryParams,
  ReceptionistListResponse,
  ReceptionistStats,
} from "@/types/receptionist";

const INITIAL_DOCTOR_CLINICS: DoctorClinic[] = [
  {
    id: "clinic-cairo-heart",
    name: "Cairo Heart & Vascular Center",
    address: "15 El-Batal Ahmed Abdel Aziz, Mohandessin",
    is_active: true,
  },
  {
    id: "clinic-zamalek-spec",
    name: "Zamalek Specialized Polyclinic",
    address: "22 Brazil Street, Zamalek, Cairo",
    is_active: true,
  },
  {
    id: "clinic-nasr-city-hub",
    name: "Nasr City Medical Hub",
    address: "88 Abbas El-Akkad St, Nasr City",
    is_active: true,
  },
  {
    id: "clinic-heliopolis-branch",
    name: "Heliopolis Diagnostic Clinic",
    address: "14 Baghdad Street, Korba, Heliopolis",
    is_active: true,
  },
  {
    id: "clinic-downtown-archived",
    name: "Old Downtown Branch (Archived)",
    address: "10 Talaat Harb St, Downtown Cairo",
    is_active: false,
  },
];

const INITIAL_RECEPTIONISTS: Receptionist[] = [
  {
    id: "rec-001",
    full_name: "Sara Ahmed Hassan",
    username: "sara_ahmed",
    phone_number: "01012345678",
    assigned_clinics: [
      { id: "clinic-cairo-heart", name: "Cairo Heart & Vascular Center", is_active: true },
      { id: "clinic-zamalek-spec", name: "Zamalek Specialized Polyclinic", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-01T09:30:00.000Z",
  },
  {
    id: "rec-002",
    full_name: "Mahmoud Hassan Tarek",
    username: "mahmoud_h",
    phone_number: "01198765432",
    assigned_clinics: [
      { id: "clinic-cairo-heart", name: "Cairo Heart & Vascular Center", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-03T11:15:00.000Z",
  },
  {
    id: "rec-003",
    full_name: "Nourhan Ali El-Sayed",
    username: "nourhan_ali",
    phone_number: "01234567890",
    assigned_clinics: [
      { id: "clinic-zamalek-spec", name: "Zamalek Specialized Polyclinic", is_active: true },
      { id: "clinic-nasr-city-hub", name: "Nasr City Medical Hub", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-05T14:45:00.000Z",
  },
  {
    id: "rec-004",
    full_name: "Youssef Ibrahim Mostafa",
    username: "youssef_i",
    phone_number: "01511223344",
    assigned_clinics: [
      { id: "clinic-downtown-archived", name: "Old Downtown Branch (Archived)", is_active: false },
    ],
    status: "inactive",
    created_at: "2026-08-06T10:00:00.000Z",
  },
  {
    id: "rec-005",
    full_name: "Mona Adel Fahmy",
    username: "mona_adel",
    phone_number: "01099887766",
    assigned_clinics: [
      { id: "clinic-heliopolis-branch", name: "Heliopolis Diagnostic Clinic", is_active: true },
      { id: "clinic-cairo-heart", name: "Cairo Heart & Vascular Center", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-07T08:20:00.000Z",
  },
  {
    id: "rec-006",
    full_name: "Karim Wael Mansour",
    username: "karim_w",
    phone_number: "01288776655",
    assigned_clinics: [
      { id: "clinic-nasr-city-hub", name: "Nasr City Medical Hub", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-09T13:10:00.000Z",
  },
  {
    id: "rec-007",
    full_name: "Dina Khaled Mostafa",
    username: "dina_k",
    phone_number: "01155443322",
    assigned_clinics: [
      { id: "clinic-zamalek-spec", name: "Zamalek Specialized Polyclinic", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-11T16:00:00.000Z",
  },
  {
    id: "rec-008",
    full_name: "Omar Sherif Zaki",
    username: "omar_sherif",
    phone_number: "01033221100",
    assigned_clinics: [
      { id: "clinic-cairo-heart", name: "Cairo Heart & Vascular Center", is_active: true },
      { id: "clinic-heliopolis-branch", name: "Heliopolis Diagnostic Clinic", is_active: true },
    ],
    status: "inactive",
    created_at: "2026-08-12T12:00:00.000Z",
  },
  {
    id: "rec-009",
    full_name: "Heba Tarek Radwan",
    username: "heba_tarek",
    phone_number: "01244332211",
    assigned_clinics: [
      { id: "clinic-nasr-city-hub", name: "Nasr City Medical Hub", is_active: true },
      { id: "clinic-zamalek-spec", name: "Zamalek Specialized Polyclinic", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-14T09:40:00.000Z",
  },
  {
    id: "rec-010",
    full_name: "Amr Nader Soliman",
    username: "amr_nader",
    phone_number: "01588774411",
    assigned_clinics: [
      { id: "clinic-heliopolis-branch", name: "Heliopolis Diagnostic Clinic", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-15T15:30:00.000Z",
  },
  {
    id: "rec-011",
    full_name: "Rania Hany Kamal",
    username: "rania_hany",
    phone_number: "01122334455",
    assigned_clinics: [
      { id: "clinic-cairo-heart", name: "Cairo Heart & Vascular Center", is_active: true },
    ],
    status: "active",
    created_at: "2026-08-17T11:00:00.000Z",
  },
  {
    id: "rec-012",
    full_name: "Tarek Essam Gamal",
    username: "tarek_essam",
    phone_number: "01066778899",
    assigned_clinics: [
      { id: "clinic-downtown-archived", name: "Old Downtown Branch (Archived)", is_active: false },
    ],
    status: "inactive",
    created_at: "2026-08-18T14:15:00.000Z",
  },
];

class ReceptionistMockService {
  private receptionists: Receptionist[] = [];
  private clinics: DoctorClinic[] = [];
  private passwords: Record<string, string> = {};

  constructor() {
    this.resetMockData();
  }

  private delay(ms = 250): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  public resetMockData(): void {
    this.receptionists = JSON.parse(JSON.stringify(INITIAL_RECEPTIONISTS));
    this.clinics = JSON.parse(JSON.stringify(INITIAL_DOCTOR_CLINICS));
  }

  public async getDoctorClinics(): Promise<DoctorClinic[]> {
    await this.delay();
    return [...this.clinics];
  }

  public async getReceptionistStats(): Promise<ReceptionistStats> {
    await this.delay();
    const total = this.receptionists.length;
    const active = this.receptionists.filter((r) => r.status === "active").length;
    const inactive = total - active;

    // Distinct active clinic IDs covered by at least one receptionist
    const coveredClinicIds = new Set<string>();
    for (const rec of this.receptionists) {
      if (rec.status === "active") {
        for (const c of rec.assigned_clinics) {
          if (c.is_active) {
            coveredClinicIds.add(c.id);
          } else {
            // Clinic inactive
          }
        }
      } else {
        // Receptionist inactive
      }
    }

    return {
      total,
      active,
      inactive,
      covered_clinics: coveredClinicIds.size,
    };
  }

  public async getReceptionists(params: ReceptionistQueryParams): Promise<ReceptionistListResponse> {
    await this.delay();
    let filtered = [...this.receptionists];

    // 1. Search Query Filter (name, username, phone)
    if (params.search && params.search.trim().length > 0) {
      const q = params.search.trim().toLowerCase();
      filtered = filtered.filter(
        (r) =>
          r.full_name.toLowerCase().includes(q) ||
          r.username.toLowerCase().includes(q) ||
          r.phone_number.includes(q)
      );
    } else {
      // No search query
    }

    // 2. Clinic Filter
    if (params.clinic_id && params.clinic_id !== "ALL" && params.clinic_id.trim().length > 0) {
      filtered = filtered.filter((r) =>
        r.assigned_clinics.some((c) => c.id === params.clinic_id)
      );
    } else {
      // All clinics
    }

    // 3. Status Filter
    if (params.status && params.status !== "ALL") {
      filtered = filtered.filter((r) => r.status === params.status);
    } else {
      // All statuses
    }

    // 4. Sorting with created_at DESC tie-breaker
    const sortOption = params.sort || "newest";
    filtered.sort((a, b) => {
      if (sortOption === "newest") {
        return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
      } else if (sortOption === "oldest") {
        return new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
      } else if (sortOption === "name_asc") {
        const nameComp = a.full_name.localeCompare(b.full_name, undefined, { sensitivity: "base" });
        if (nameComp !== 0) {
          return nameComp;
        } else {
          return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
        }
      } else if (sortOption === "name_desc") {
        const nameComp = b.full_name.localeCompare(a.full_name, undefined, { sensitivity: "base" });
        if (nameComp !== 0) {
          return nameComp;
        } else {
          return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
        }
      } else {
        return 0;
      }
    });

    const total = filtered.length;
    const limit = Math.max(1, params.limit || 10);
    const total_pages = Math.max(1, Math.ceil(total / limit));
    const page = Math.min(Math.max(1, params.page || 1), total_pages);

    const startIndex = (page - 1) * limit;
    const data = filtered.slice(startIndex, startIndex + limit);

    return {
      data,
      total,
      page,
      limit,
      total_pages,
    };
  }

  public async getReceptionistById(id: string): Promise<Receptionist | null> {
    await this.delay();
    const item = this.receptionists.find((r) => r.id === id);
    return item ? JSON.parse(JSON.stringify(item)) : null;
  }

  public async createReceptionist(data: ReceptionistFormData): Promise<Receptionist> {
    await this.delay();

    // 1. Uniqueness Scope - Username (case-insensitive)
    const normalizedUsername = data.username.trim().toLowerCase();
    const usernameExists = this.receptionists.some(
      (r) => r.username.trim().toLowerCase() === normalizedUsername
    );
    if (usernameExists) {
      const error: any = new Error("Username already exists. Please choose another.");
      error.code = 409;
      error.status = 409;
      throw error;
    } else {
      // Username unique
    }

    // 2. Uniqueness Scope - Phone Number
    const normalizedPhone = data.phone_number.trim();
    const phoneExists = this.receptionists.some((r) => r.phone_number === normalizedPhone);
    if (phoneExists) {
      const error: any = new Error("Phone number is already registered.");
      error.code = 409;
      error.status = 409;
      throw error;
    } else {
      // Phone unique
    }

    // 3. Validate at least 1 clinic
    if (!data.clinic_ids || data.clinic_ids.length === 0) {
      throw new Error("Please select at least one clinic.");
    } else {
      // Clinics selected
    }

    // 4. Resolve assigned clinics
    const assigned: { id: string; name: string; is_active: boolean }[] = [];
    for (const cid of data.clinic_ids) {
      const found = this.clinics.find((c) => c.id === cid);
      if (found) {
        assigned.push({
          id: found.id,
          name: found.name,
          is_active: found.is_active,
        });
      } else {
        // Clinic not found in mock list
      }
    }

    const newId = `rec-${Date.now()}`;
    const newReceptionist: Receptionist = {
      id: newId,
      full_name: data.full_name.trim(),
      username: data.username.trim(),
      phone_number: normalizedPhone,
      assigned_clinics: assigned,
      status: data.status,
      created_at: new Date().toISOString(),
    };

    if (data.password) {
      this.passwords[newId] = data.password;
    } else {
      // No initial password stored
    }

    this.receptionists.unshift(newReceptionist);
    return JSON.parse(JSON.stringify(newReceptionist));
  }

  public async updateReceptionist(id: string, data: ReceptionistFormData): Promise<Receptionist> {
    await this.delay();

    const existingIndex = this.receptionists.findIndex((r) => r.id === id);
    if (existingIndex === -1) {
      throw new Error("Receptionist account not found.");
    } else {
      // Found receptionist
    }

    // 1. Uniqueness Scope - Username (case-insensitive, excluding self)
    const normalizedUsername = data.username.trim().toLowerCase();
    const usernameExists = this.receptionists.some(
      (r) => r.id !== id && r.username.trim().toLowerCase() === normalizedUsername
    );
    if (usernameExists) {
      const error: any = new Error("Username already exists. Please choose another.");
      error.code = 409;
      error.status = 409;
      throw error;
    } else {
      // Username unique
    }

    // 2. Uniqueness Scope - Phone Number (excluding self)
    const normalizedPhone = data.phone_number.trim();
    const phoneExists = this.receptionists.some(
      (r) => r.id !== id && r.phone_number === normalizedPhone
    );
    if (phoneExists) {
      const error: any = new Error("Phone number is already registered.");
      error.code = 409;
      error.status = 409;
      throw error;
    } else {
      // Phone unique
    }

    // 3. Validate at least 1 clinic
    if (!data.clinic_ids || data.clinic_ids.length === 0) {
      throw new Error("Please select at least one clinic.");
    } else {
      // Clinics selected
    }

    // 4. Resolve assigned clinics
    const assigned: { id: string; name: string; is_active: boolean }[] = [];
    for (const cid of data.clinic_ids) {
      const found = this.clinics.find((c) => c.id === cid);
      if (found) {
        assigned.push({
          id: found.id,
          name: found.name,
          is_active: found.is_active,
        });
      } else {
        // Clinic not found in mock list
      }
    }

    const current = this.receptionists[existingIndex];
    const updated: Receptionist = {
      ...current,
      full_name: data.full_name.trim(),
      username: data.username.trim(),
      phone_number: normalizedPhone,
      assigned_clinics: assigned,
      status: data.status,
    };

    if (data.password && data.password.trim().length > 0) {
      this.passwords[id] = data.password;
    } else {
      // Password unchanged
    }

    this.receptionists[existingIndex] = updated;
    return JSON.parse(JSON.stringify(updated));
  }

  public async deleteReceptionist(id: string): Promise<boolean> {
    await this.delay();
    const initialLength = this.receptionists.length;
    this.receptionists = this.receptionists.filter((r) => r.id !== id);
    delete this.passwords[id];
    return this.receptionists.length < initialLength;
  }
}

export const receptionistMockService = new ReceptionistMockService();
export default receptionistMockService;

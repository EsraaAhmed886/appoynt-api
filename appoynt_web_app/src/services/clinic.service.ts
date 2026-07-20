import { clinics } from "@/data/clinics";

type Clinic = (typeof clinics)[number];

const STORAGE_KEY = "clinics";

export function getClinics(): Clinic[] {
  const storedClinics = localStorage.getItem(STORAGE_KEY);

  if (storedClinics) {
    return JSON.parse(storedClinics) as Clinic[];
  } else {
    return clinics;
  }
}

export function saveClinics(clinics: Clinic[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(clinics));
}

export function initializeClinics() {
  const storedClinics = localStorage.getItem(STORAGE_KEY);

  if (!storedClinics) {
    saveClinics(clinics);
  }
}
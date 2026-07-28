import { clinics as initialClinics } from "@/data/clinics";

export type Clinic = (typeof initialClinics)[number];

const STORAGE_KEY = "clinics";

// 1. قراءة العيادات من LocalStorage أو العودة بالبيانات الافتراضية
export function getClinics(): Clinic[] {
  if (typeof window === "undefined") {
    return initialClinics;
  }

  try {
    const storedClinics = localStorage.getItem(STORAGE_KEY);
    if (storedClinics) {
      return JSON.parse(storedClinics) as Clinic[];
    }
  } catch (error) {
    console.error("Error reading clinics from localStorage:", error);
  }

  return initialClinics;
}

// 2. حفظ قائمة العيادات في LocalStorage
export function saveClinics(clinics: Clinic[]) {
  if (typeof window === "undefined") return;

  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(clinics));
  } catch (error) {
    console.error("Error saving clinics to localStorage:", error);
  }
}

// 3. تهيئة البيانات لأول مرة فقط إن لم تكن مجهزة
export function initializeClinics() {
  if (typeof window === "undefined") return;

  const storedClinics = localStorage.getItem(STORAGE_KEY);

  // إذا لم تكن هناك بيانات محفوظة مطلقاً، نحفظ القائمة الافتراضية
  if (!storedClinics) {
    saveClinics(initialClinics);
  }
}
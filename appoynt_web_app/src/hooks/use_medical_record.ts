/*
 * File Name: use_medical_record.ts
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - @/services/medical_record_service
 *   - @/types/medical_record
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Custom React query hook managing asynchronous fetching of medical records, patient profiles, and medical history pagination with error resilient fallbacks.
 */

import { useState, useEffect, useCallback } from "react";
import {
  MedicalRecord,
  PatientSummary,
  MedicalHistoryItem,
} from "@/types/medical_record";
import { MedicalRecordService } from "@/services/medical_record_service";

export function useMedicalRecordQuery(appointmentId: string) {
  const [record, setRecord] = useState<MedicalRecord | null>(null);
  const [patient, setPatient] = useState<PatientSummary | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [isError, setIsError] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const fetchRecord = useCallback(async () => {
    if (!appointmentId) {
      return;
    } else {
      // Proceed with fetch
    }
    setIsLoading(true);
    setIsError(false);
    setErrorMessage(null);

    try {
      const fetchedRecord = await MedicalRecordService.getMedicalRecordByAppointment(
        appointmentId
      );
      setRecord(fetchedRecord);

      if (fetchedRecord.patientId) {
        const fetchedPatient = await MedicalRecordService.getPatientSummary(
          fetchedRecord.patientId
        );
        setPatient(fetchedPatient);
      } else {
        // No patient ID on record
      }
    } catch (err: unknown) {
      setIsError(true);
      setErrorMessage(
        err instanceof Error ? err.message : "Failed to load medical record"
      );
    } finally {
      setIsLoading(false);
    }
  }, [appointmentId]);

  useEffect(() => {
    fetchRecord();
  }, [fetchRecord]);

  return {
    record,
    patient,
    isLoading,
    isError,
    errorMessage,
    refetch: fetchRecord,
    setRecord,
  };
}

export function useMedicalHistoryQuery(
  patientId: string,
  initialPage: number = 1
) {
  const [historyItems, setHistoryItems] = useState<MedicalHistoryItem[]>([]);
  const [total, setTotal] = useState<number>(0);
  const [totalPages, setTotalPages] = useState<number>(1);
  const [page, setPage] = useState<number>(initialPage);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [filters, setFilters] = useState<{
    searchQuery?: string;
    status?: string;
    doctor?: string;
  }>({});

  const fetchHistory = useCallback(async () => {
    if (!patientId) {
      return;
    } else {
      // Proceed with history fetch
    }
    setIsLoading(true);
    try {
      const res = await MedicalRecordService.getMedicalHistory(
        patientId,
        page,
        10,
        filters
      );
      setHistoryItems(res.items);
      setTotal(res.total);
      setTotalPages(res.totalPages);
    } catch {
      // Graceful fallback
    } finally {
      setIsLoading(false);
    }
  }, [patientId, page, filters]);

  useEffect(() => {
    fetchHistory();
  }, [fetchHistory]);

  return {
    historyItems,
    total,
    totalPages,
    page,
    setPage,
    filters,
    setFilters,
    isLoading,
    refetch: fetchHistory,
  };
}

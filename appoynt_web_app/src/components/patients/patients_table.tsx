/**

File Name : patients_table.tsx
Author : Shimaa Salah
Created Date : 28/08/2026
Version : v1.0.0
Dependencies :
  - react
  - next/image
  - lucide-react
  - @/context/language_context
  - @/types/patient

Contributors : [Shimaa Salah]
Last Modified : Shimaa Salah - 28/08/2026
Description : Accessible, responsive patient data table component displaying Patient ID, avatar columns, phone numbers, visit dates, gender pill badges, and quick action triggers.

*/

"use client";

import React from "react";
import Image from "next/image";
import { Eye, FileText } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { Patient, Gender } from "@/types/patient";

type PatientsTableProps = {
  patients: Patient[];
  totalRecords: number;
  onViewProfile: (patient: Patient) => void;
  onViewMedicalRecord: (patient: Patient) => void;
};

export default function PatientsTable({
  patients,
  totalRecords,
  onViewProfile,
  onViewMedicalRecord,
}: PatientsTableProps) {
  const { translations } = useTranslation();

  const renderGenderBadge = (gender: Gender) => {
    if (gender === "Female") {
      return (
        <span className="inline-flex items-center justify-center gap-1 rounded-lg bg-pink-100 dark:bg-pink-950/60 px-3 py-1 text-xs font-bold text-pink-700 dark:text-pink-300 border border-pink-200 dark:border-pink-800">
          <span>♀</span>
          <span>{translations.gender_female}</span>
        </span>
      );
    } else {
      return (
        <span className="inline-flex items-center justify-center gap-1 rounded-lg bg-blue-100 dark:bg-blue-950/60 px-3 py-1 text-xs font-bold text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
          <span>♂</span>
          <span>{translations.gender_male}</span>
        </span>
      );
    }
  };

  return (
    <div className="overflow-hidden rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-[#0E1726] shadow-xs w-full">
      {/* Table Title Banner */}
      <div className="border-b border-slate-100 dark:border-slate-800 px-6 py-4 bg-white dark:bg-[#0E1726]">
        <h2 className="text-base font-bold text-slate-900 dark:text-slate-100">
          {translations.patients_all_count} ({totalRecords})
        </h2>
      </div>

      {/* Responsive Horizontal Scroll Container */}
      <div className="overflow-x-auto w-full">
        <table className="w-full text-left rtl:text-right text-xs border-collapse min-w-[700px]">
          <thead className="bg-slate-50/80 dark:bg-slate-900/60 text-slate-500 dark:text-slate-400 font-semibold border-b border-slate-100 dark:border-slate-800">
            <tr>
              <th scope="col" className="px-6 py-4">
                {translations.th_patient_id}
              </th>
              <th scope="col" className="px-6 py-4">
                {translations.th_patient}
              </th>
              <th scope="col" className="px-6 py-4">
                {translations.th_patient_phone}
              </th>
              <th scope="col" className="px-6 py-4">
                {translations.th_last_visit}
              </th>
              <th scope="col" className="px-6 py-4">
                {translations.th_gender}
              </th>
              <th scope="col" className="px-6 py-4 text-center">
                {translations.th_patient_actions}
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 dark:divide-slate-800 text-slate-800 dark:text-slate-200 font-medium">
            {patients.map((patient: Patient) => (
              <tr
                key={patient.id}
                className="hover:bg-slate-50/50 dark:hover:bg-slate-800/40 transition duration-150"
              >
                {/* Patient ID Column */}
                <td className="px-6 py-4 whitespace-nowrap font-mono font-semibold text-slate-500 dark:text-slate-400">
                  {patient.patientId}
                </td>

                {/* Name & Avatar Column */}
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="flex items-center gap-3">
                    <div className="relative h-10 w-10 overflow-hidden rounded-full border border-slate-200 dark:border-slate-700 shrink-0">
                      <Image
                        src={patient.avatarUrl || "/images/profile_icon.jpeg"}
                        alt={patient.name}
                        width={40}
                        height={40}
                        className="h-full w-full object-cover"
                      />
                    </div>
                    <span className="font-bold text-slate-900 dark:text-slate-100 text-sm">
                      {patient.name}
                    </span>
                  </div>
                </td>

                {/* Phone Number (Blue Text) Column */}
                <td className="px-6 py-4 whitespace-nowrap font-mono font-semibold text-blue-600 dark:text-blue-400">
                  {patient.phone}
                </td>

                {/* Last Visit Date Column */}
                <td className="px-6 py-4 whitespace-nowrap text-slate-600 dark:text-slate-400">
                  {patient.lastVisitDate}
                </td>

                {/* Gender Pill Badge Column */}
                <td className="px-6 py-4 whitespace-nowrap">
                  {renderGenderBadge(patient.gender)}
                </td>

                {/* Actions Icon Buttons Column */}
                <td className="px-6 py-4 whitespace-nowrap">
                  <div
                    dir="ltr"
                    className="flex items-center justify-center gap-2.5"
                  >
                    <button
                      type="button"
                      onClick={() => onViewProfile(patient)}
                      aria-label={`${translations.action_view_profile} ${patient.name}`}
                      title={translations.action_view_profile}
                      className="p-1.5 rounded-lg text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-300 hover:bg-blue-50 dark:hover:bg-blue-950/40 transition cursor-pointer"
                    >
                      <Eye className="h-4 w-4" />
                    </button>
                    <button
                      type="button"
                      onClick={() => onViewMedicalRecord(patient)}
                      aria-label={`${translations.action_medical_record} ${patient.name}`}
                      title={translations.action_medical_record}
                      className="p-1.5 rounded-lg text-emerald-600 hover:text-emerald-800 dark:text-emerald-400 dark:hover:text-emerald-300 hover:bg-emerald-50 dark:hover:bg-emerald-950/40 transition cursor-pointer"
                    >
                      <FileText className="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

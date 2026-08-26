/*
 * File Name: receptionist_table.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/receptionist
 *   - @/context/receptionist_context
 *   - @/context/language_context
 *   - @/components/receptionists/assigned_clinics_popover
 *   - @/components/receptionists/receptionist_pagination
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Main interactive data table displaying clinic receptionists with avatars, monospace usernames, formatted Egyptian phone numbers, multi-clinic popover triggers, status chips, and action handlers.
 */

"use client";

import React, { useState } from "react";
import {
  Edit2,
  Trash2,
  Building2,
  CheckCircle2,
  Clock,
  Phone,
  User,
  AlertTriangle,
} from "lucide-react";
import { Receptionist } from "@/types/receptionist";
import { useReceptionists } from "@/context/receptionist_context";
import { useTranslation } from "@/context/language_context";
import AssignedClinicsPopover from "@/components/receptionists/assigned_clinics_popover";
import ReceptionistPagination from "@/components/receptionists/receptionist_pagination";

interface ReceptionistTableProps {
  onEdit: (receptionist: Receptionist) => void;
  onDelete: (receptionist: Receptionist) => void;
}

// Formats Egyptian phone: 01XXXXXXXXX -> 01X XXXX XXXX
function formatEgyptianPhone(phone: string): string {
  if (phone.length === 11 && phone.startsWith("01")) {
    return `${phone.slice(0, 3)} ${phone.slice(3, 7)} ${phone.slice(7)}`;
  } else {
    return phone;
  }
}

// Get user initials for avatar
function getInitials(name: string): string {
  const parts = name.trim().split(" ");
  if (parts.length >= 2) {
    return `${parts[0][0]}${parts[1][0]}`.toUpperCase();
  } else {
    return name.slice(0, 2).toUpperCase();
  }
}

export default function ReceptionistTable({ onEdit, onDelete }: ReceptionistTableProps) {
  const { receptionists } = useReceptionists();
  const { translations } = useTranslation();

  const [popoverState, setPopoverState] = useState<{
    isOpen: boolean;
    receptionist: Receptionist | null;
  }>({
    isOpen: false,
    receptionist: null,
  });

  const handleOpenPopover = (receptionist: Receptionist) => {
    setPopoverState({ isOpen: true, receptionist });
  };

  const handleClosePopover = () => {
    setPopoverState({ isOpen: false, receptionist: null });
  };

  return (
    <div className="w-full bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs overflow-hidden">
      <div className="overflow-x-auto">
        <table className="w-full text-xs text-slate-700 dark:text-slate-200 text-start">
          <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800 uppercase text-[11px] font-bold text-slate-500 dark:text-slate-400">
            <tr>
              <th className="py-3.5 px-4 font-bold text-start">{translations.col_full_name || "Full Name"}</th>
              <th className="py-3.5 px-4 font-bold text-start">{translations.col_username || "Username"}</th>
              <th className="py-3.5 px-4 font-bold text-start">{translations.col_phone_number || "Phone Number"}</th>
              <th className="py-3.5 px-4 font-bold text-start min-w-[210px]">{translations.col_assigned_clinics || "Assigned Clinics"}</th>
              <th className="py-3.5 px-4 font-bold text-start">{translations.col_status || "Status"}</th>
              <th className="py-3.5 px-4 font-bold text-start">{translations.col_created_date || "Created Date"}</th>
              <th className="py-3.5 px-4 font-bold text-end">{translations.col_actions || "Actions"}</th>
            </tr>
          </thead>
          <tbody className="divide-y-2 divide-slate-100 dark:divide-slate-800/80">
            {receptionists.map((item) => {
              const firstClinic = item.assigned_clinics[0];
              const remainingClinicsCount = item.assigned_clinics.length - 1;

              return (
                <tr
                  key={item.id}
                  className="hover:bg-slate-50/80 dark:hover:bg-[#131E35]/60 transition"
                >
                  {/* 1. Full Name + Avatar */}
                  <td className="py-3.5 px-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full bg-linear-to-br from-blue-500 to-indigo-600 text-white font-bold text-xs flex items-center justify-center shadow-xs shrink-0">
                        {getInitials(item.full_name)}
                      </div>
                      <div className="min-w-0">
                        <p className="font-bold text-slate-900 dark:text-white text-xs md:text-sm truncate max-w-[180px]">
                          {item.full_name}
                        </p>
                      </div>
                    </div>
                  </td>

                  {/* 2. Username */}
                  <td className="py-3.5 px-4 font-mono">
                    <span className="inline-flex items-center px-2 py-0.5 rounded-md text-[11px] font-bold bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 border border-slate-200 dark:border-slate-700">
                      @{item.username}
                    </span>
                  </td>

                  {/* 3. Phone Number */}
                  <td className="py-3.5 px-4 font-mono text-slate-700 dark:text-slate-300 whitespace-nowrap">
                    <div className="flex items-center gap-1.5">
                      <Phone className="w-3.5 h-3.5 text-slate-400" />
                      <span>{formatEgyptianPhone(item.phone_number)}</span>
                    </div>
                  </td>

                  {/* 4. Assigned Clinics */}
                  <td className="py-3.5 px-4 min-w-[210px]">
                    <div className="flex items-center gap-1.5 flex-wrap max-w-xs">
                      {firstClinic && (
                        <span
                          className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-semibold border max-w-[200px] truncate ${
                            firstClinic.is_active
                              ? "bg-indigo-50 dark:bg-indigo-950/60 text-indigo-700 dark:text-indigo-300 border-indigo-200 dark:border-indigo-800"
                              : "bg-amber-50 dark:bg-amber-950/60 text-amber-700 dark:text-amber-300 border-amber-200 dark:border-amber-800"
                          }`}
                          title={firstClinic.name}
                        >
                          <Building2 className="w-3 h-3 shrink-0" />
                          <span className="truncate">{firstClinic.name}</span>
                          {!firstClinic.is_active && (
                            <AlertTriangle className="w-2.5 h-2.5 text-amber-500 shrink-0" />
                          )}
                        </span>
                      )}

                      {remainingClinicsCount > 0 && (
                        <button
                          type="button"
                          onClick={() => handleOpenPopover(item)}
                          className="inline-flex items-center px-2 py-1 rounded-full text-[11px] font-bold bg-slate-100 dark:bg-slate-800 text-blue-600 dark:text-blue-400 border border-slate-200 dark:border-slate-700 hover:bg-blue-50 dark:hover:bg-blue-950/60 transition cursor-pointer"
                        >
                          + {remainingClinicsCount}
                        </button>
                      )}
                    </div>
                  </td>

                  {/* 5. Status */}
                  <td className="py-3.5 px-4 whitespace-nowrap">
                    {item.status === "active" ? (
                      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
                        <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
                        <span>{translations.status_active || "Active"}</span>
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 border border-slate-200 dark:border-slate-700">
                        <Clock className="w-3 h-3" />
                        <span>{translations.status_inactive || "Inactive"}</span>
                      </span>
                    )}
                  </td>

                  {/* 6. Created Date */}
                  <td className="py-3.5 px-4 font-mono text-slate-500 dark:text-slate-400 whitespace-nowrap">
                    {item.created_at ? item.created_at.slice(0, 10) : "—"}
                  </td>

                  {/* 7. Actions */}
                  <td className="py-3.5 px-4 text-end">
                    <div className="flex items-center justify-end gap-1.5">
                      <button
                        type="button"
                        onClick={() => onEdit(item)}
                        className="p-1.5 text-blue-600 dark:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-950/60 rounded-lg transition cursor-pointer"
                        title={translations.edit_receptionist || "Edit Receptionist"}
                      >
                        <Edit2 className="w-4 h-4" />
                      </button>
                      <button
                        type="button"
                        onClick={() => onDelete(item)}
                        className="p-1.5 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-950/60 rounded-lg transition cursor-pointer"
                        title={translations.delete_receptionist || "Delete Receptionist"}
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      {/* Pagination Bar */}
      <ReceptionistPagination />

      {/* Assigned Clinics Popover Modal */}
      {popoverState.isOpen && popoverState.receptionist && (
        <AssignedClinicsPopover
          clinics={popoverState.receptionist.assigned_clinics}
          receptionistName={popoverState.receptionist.full_name}
          isOpen={popoverState.isOpen}
          onClose={handleClosePopover}
        />
      )}
    </div>
  );
}

/**
 * File Name : working_schedule_section.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/types/clinic, @/components/clinics/custom_select, @/lib/validators/clinic_validator
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Section 2 component managing Working Schedule table and Total Working Days pill badge matching visual reference.
 */

"use client";

import { useState } from "react";
import { Calendar, Plus, Edit2, Trash2, X } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { WorkingScheduleItem } from "@/types/clinic";
import CustomSelect from "../custom_select";
import { WORKING_DAYS } from "../clinic_form_constants";
import { validate_working_schedule_item } from "@/lib/validators/clinic_validator";

type WorkingScheduleSectionProps = {
  is_edit_mode: boolean;
  is_card_dirty?: boolean;
  schedule_list: WorkingScheduleItem[];
  doctor_occupied_days?: string[];
  doctor_existing_schedules?: WorkingScheduleItem[];
  on_add_schedule: (item: WorkingScheduleItem) => void;
  on_edit_schedule: (index: number, item: WorkingScheduleItem) => void;
  on_delete_schedule: (index: number) => void;
  on_toggle_edit: () => void;
  on_cancel?: () => void;
  on_save?: () => void;
};

export default function WorkingScheduleSection({
  is_edit_mode,
  is_card_dirty = false,
  schedule_list,
  doctor_occupied_days = [],
  doctor_existing_schedules = [],
  on_add_schedule,
  on_edit_schedule,
  on_delete_schedule,
  on_toggle_edit,
  on_cancel,
  on_save,
}: WorkingScheduleSectionProps) {
  const { translations } = useTranslation();
  const [is_modal_open, set_is_modal_open] = useState(false);
  const [editing_index, set_editing_index] = useState<number | null>(null);

  const [selected_day, set_selected_day] = useState("");
  const [start_time, set_start_time] = useState("");
  const [end_time, set_end_time] = useState("");
  const [validation_errors, set_validation_errors] = useState<{
    day_error?: string;
    start_error?: string;
    end_error?: string;
  }>({});

  const is_editing_item = null !== editing_index;

  const available_day_options = WORKING_DAYS.filter((day) => {
    if (is_editing_item && selected_day === day) {
      return true;
    } else {
      return !schedule_list.some((item) => item.day === day);
    }
  });

  const handle_open_modal = (index?: number) => {
    if (undefined !== index && null !== index) {
      set_editing_index(index);
      set_selected_day(schedule_list[index].day);
      set_start_time(schedule_list[index].startTime);
      set_end_time(schedule_list[index].endTime);
    } else {
      set_editing_index(null);
      set_selected_day("");
      set_start_time("");
      set_end_time("");
    }
    set_validation_errors({});
    set_is_modal_open(true);
  };

  const handle_close_modal = () => {
    set_is_modal_open(false);
    set_editing_index(null);
    set_validation_errors({});
  };

  const other_schedules =
    doctor_existing_schedules.length > 0
      ? doctor_existing_schedules
      : doctor_occupied_days;

  const validate_input = (day: string, start: string, end: string) => {
    const errs = validate_working_schedule_item(
      day,
      start,
      end,
      schedule_list,
      editing_index,
      other_schedules,
    );
    set_validation_errors(errs || {});
    return null === errs;
  };

  const handle_save_item = () => {
    const is_valid = validate_input(selected_day, start_time, end_time);
    if (!is_valid) {
      return;
    } else {
      const item = { day: selected_day, startTime: start_time, endTime: end_time };
      if (null !== editing_index) {
        on_edit_schedule(editing_index, item);
      } else {
        on_add_schedule(item);
      }
      handle_close_modal();
    }
  };

  const get_translated_day = (day_code: string) => {
    const key = `day_${day_code.toLowerCase()}` as keyof typeof translations;
    return translations[key] || day_code;
  };

  const total_days_count = schedule_list.length;

  return (
    <div className="rounded-2xl border border-app-border bg-app-surface p-6 shadow-sm space-y-6">
      {/* Section Header */}
      <div className="flex items-center justify-between border-b border-app-border pb-4">
        <h2 className="text-xl font-bold text-app-text-primary">
          {translations.lbl_section_schedule}
        </h2>

        <div className="flex items-center gap-3">
          {is_edit_mode ? (
            <>
              <button
                type="button"
                onClick={() => handle_open_modal()}
                className="flex items-center gap-1.5 rounded-lg bg-app-primary px-3 py-1.5 text-xs font-semibold text-white shadow-sm hover:opacity-90 transition-all"
              >
                <Plus size={14} />
                <span>{translations.btn_add_working_day}</span>
              </button>
              {is_card_dirty ? (
                <button
                  type="button"
                  onClick={on_save}
                  className="rounded-lg bg-app-primary px-3.5 py-1.5 text-xs font-semibold text-white shadow-sm hover:opacity-90 transition-all"
                >
                  {translations.btn_save_changes}
                </button>
              ) : null}
              <button
                type="button"
                onClick={on_cancel || on_toggle_edit}
                className="rounded-lg border border-app-border bg-app-surface px-3 py-1.5 text-xs font-semibold text-app-text-primary hover:bg-app-input_fill transition-all"
              >
                {translations.btn_cancel}
              </button>
            </>
          ) : (
            <button
              type="button"
              onClick={on_toggle_edit}
              className="flex items-center gap-1.5 rounded-lg border border-app-border bg-app-surface px-3 py-1.5 text-xs font-semibold text-app-primary hover:bg-app-input_fill transition-all"
            >
              <Edit2 size={14} />
              <span>{translations.lbl_edit_section}</span>
            </button>
          )}
        </div>
      </div>

      {/* Table Container */}
      <div className="overflow-hidden rounded-xl border border-app-border bg-app-surface">
        <table className="w-full text-start text-sm">
          <thead className="border-b border-app-border bg-app-input_fill text-app-text-secondary">
            <tr>
              <th className="px-5 py-3.5 text-start font-semibold">
                {translations.th_day}
              </th>
              <th className="px-5 py-3.5 text-start font-semibold">
                {translations.th_start_time}
              </th>
              <th className="px-5 py-3.5 text-start font-semibold">
                {translations.th_end_time}
              </th>
              {is_edit_mode ? (
                <th className="px-5 py-3.5 text-end font-semibold">
                  {translations.th_actions}
                </th>
              ) : null}
            </tr>
          </thead>
          <tbody className="divide-y divide-app-border text-app-text-primary">
            {0 === schedule_list.length ? (
              <tr>
                <td
                  colSpan={is_edit_mode ? 4 : 3}
                  className="px-5 py-6 text-center text-app-text-secondary font-medium"
                >
                  {translations.lbl_no_working_schedule}
                </td>
              </tr>
            ) : (
              schedule_list.map((item, index) => (
                <tr
                  key={`${item.day}_${index}`}
                  className="hover:bg-app-input_fill/50 transition-colors"
                >
                  <td className="px-5 py-3.5 font-medium text-start">
                    {get_translated_day(item.day)}
                  </td>
                  <td className="px-5 py-3.5 text-start text-app-text-secondary">
                    {item.startTime}
                  </td>
                  <td className="px-5 py-3.5 text-start text-app-text-secondary">
                    {item.endTime}
                  </td>
                  {is_edit_mode ? (
                    <td className="px-5 py-3.5 text-end">
                      <div className="flex items-center justify-end gap-2">
                        <button
                          type="button"
                          onClick={() => handle_open_modal(index)}
                          className="rounded-lg p-1.5 text-app-text-secondary hover:bg-app-primary/10 hover:text-app-primary transition-all"
                        >
                          <Edit2 size={16} />
                        </button>
                        <button
                          type="button"
                          onClick={() => on_delete_schedule(index)}
                          className="rounded-lg p-1.5 text-app-text-secondary hover:bg-red-500/10 hover:text-red-500 transition-all"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
                  ) : null}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Summary Pill Badge matching reference image */}
      <div className="pt-1">
        <div className="inline-flex items-center gap-2 rounded-xl border border-sky-200 bg-sky-50 px-3.5 py-1.5 text-xs font-semibold text-sky-700 dark:border-sky-900/40 dark:bg-sky-950/30 dark:text-sky-300">
          <Calendar size={14} className="text-sky-600 dark:text-sky-400" />
          <span>
            {0 === total_days_count
              ? translations.lbl_no_working_schedule
              : `${translations.lbl_total_working_days}: ${total_days_count} ${translations.lbl_days_count}`}
          </span>
        </div>
      </div>

      {/* Edit/Add Working Day Modal */}
      {is_modal_open ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-md space-y-4 rounded-2xl border border-app-border bg-app-surface p-6 shadow-2xl">
            <div className="flex items-center justify-between border-b border-app-border pb-3">
              <h3 className="text-lg font-bold text-app-text-primary">
                {is_editing_item
                  ? translations.btn_edit_working_day
                  : translations.btn_add_working_day}
              </h3>
              <button
                type="button"
                onClick={handle_close_modal}
                className="rounded-full p-1 text-app-text-secondary hover:text-app-text-primary transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            <div className="space-y-4">
              <CustomSelect
                label={translations.th_day}
                placeholder={translations.ph_select_day}
                value={selected_day}
                error={
                  validation_errors.day_error
                    ? translations[validation_errors.day_error as keyof typeof translations] ||
                      validation_errors.day_error
                    : ""
                }
                options={available_day_options}
                on_change={(val) => {
                  set_selected_day(val);
                  validate_input(val, start_time, end_time);
                }}
              />

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="mb-1 block text-xs font-semibold text-app-text-primary">
                    {translations.th_start_time} <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={start_time}
                    onChange={(e) => {
                      const val = e.target.value;
                      set_start_time(val);
                      validate_input(selected_day, val, end_time);
                    }}
                    className="w-full rounded-xl border border-app-border bg-app-input_fill px-3 py-2 text-sm text-app-text-primary outline-none focus:border-app-primary"
                  />
                </div>

                <div>
                  <label className="mb-1 block text-xs font-semibold text-app-text-primary">
                    {translations.th_end_time} <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={end_time}
                    onChange={(e) => {
                      const val = e.target.value;
                      set_end_time(val);
                      validate_input(selected_day, start_time, val);
                    }}
                    className="w-full rounded-xl border border-app-border bg-app-input_fill px-3 py-2 text-sm text-app-text-primary outline-none focus:border-app-primary"
                  />
                </div>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 border-t border-app-border pt-4">
              <button
                type="button"
                onClick={handle_close_modal}
                className="rounded-xl border border-app-border bg-app-surface px-4 py-2 text-xs font-semibold text-app-text-primary hover:bg-app-input_fill transition-all"
              >
                {translations.btn_cancel}
              </button>
              <button
                type="button"
                onClick={handle_save_item}
                className="rounded-xl bg-app-primary px-5 py-2 text-xs font-semibold text-white hover:opacity-90 transition-all"
              >
                {is_editing_item
                  ? translations.btn_save_changes
                  : translations.btn_add_working_day}
              </button>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}

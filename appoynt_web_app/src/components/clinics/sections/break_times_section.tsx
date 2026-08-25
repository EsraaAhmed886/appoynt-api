/**
 * File Name : break_times_section.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/types/clinic, @/components/clinics/custom_select, @/lib/validators/clinic_validator, @/lib/utils/time_utils
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Section 3 component managing Break Times table (Day, Break Start, Break End, Duration) matching reference image layout.
 */

"use client";

import { useState } from "react";
import { Plus, Edit2, Trash2, X } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { BreakTimeItem, WorkingScheduleItem } from "@/types/clinic";
import CustomSelect from "../custom_select";
import { validate_break_time_item } from "@/lib/validators/clinic_validator";
import { parse_time_to_minutes } from "@/lib/utils/time_utils";

type BreakTimesSectionProps = {
  is_edit_mode: boolean;
  is_card_dirty?: boolean;
  break_list: BreakTimeItem[];
  available_working_days: string[];
  schedule_list: WorkingScheduleItem[];
  on_add_break: (item: BreakTimeItem) => void;
  on_edit_break: (index: number, item: BreakTimeItem) => void;
  on_delete_break: (index: number) => void;
  on_toggle_edit: () => void;
  on_cancel?: () => void;
  on_save?: () => void;
};

export default function BreakTimesSection({
  is_edit_mode,
  is_card_dirty = false,
  break_list,
  available_working_days,
  schedule_list,
  on_add_break,
  on_edit_break,
  on_delete_break,
  on_toggle_edit,
  on_cancel,
  on_save,
}: BreakTimesSectionProps) {
  const { translations } = useTranslation();
  const [is_modal_open, set_is_modal_open] = useState(false);
  const [editing_index, set_editing_index] = useState<number | null>(null);

  const [selected_day, set_selected_day] = useState("");
  const [break_start, set_break_start] = useState("");
  const [break_end, set_break_end] = useState("");
  const [validation_errors, set_validation_errors] = useState<{
    day_error?: string;
    start_error?: string;
    end_error?: string;
  }>({});

  const is_editing_item = null !== editing_index;

  const handle_open_modal = (index?: number) => {
    if (undefined !== index && null !== index) {
      set_editing_index(index);
      set_selected_day(break_list[index].day);
      set_break_start(break_list[index].breakStart);
      set_break_end(break_list[index].breakEnd);
    } else {
      set_editing_index(null);
      set_selected_day("");
      set_break_start("");
      set_break_end("");
    }
    set_validation_errors({});
    set_is_modal_open(true);
  };

  const handle_close_modal = () => {
    set_is_modal_open(false);
    set_editing_index(null);
    set_validation_errors({});
  };

  const validate_input = (day: string, start: string, end: string) => {
    const errs = validate_break_time_item(
      day,
      start,
      end,
      schedule_list,
      break_list,
      editing_index,
    );
    set_validation_errors(errs || {});
    return null === errs;
  };

  const handle_save_item = () => {
    const is_valid = validate_input(selected_day, break_start, break_end);
    if (!is_valid) {
      return;
    } else {
      const item = { day: selected_day, breakStart: break_start, breakEnd: break_end };
      if (null !== editing_index) {
        on_edit_break(editing_index, item);
      } else {
        on_add_break(item);
      }
      handle_close_modal();
    }
  };

  const get_translated_day = (day_code: string) => {
    const key = `day_${day_code.toLowerCase()}` as keyof typeof translations;
    return translations[key] || day_code;
  };

  const calculate_duration_label = (start: string, end: string): string => {
    const start_mins = parse_time_to_minutes(start);
    const end_mins = parse_time_to_minutes(end);
    if (start_mins < 0 || end_mins < 0 || end_mins <= start_mins) {
      return "1h 0m";
    } else {
      const diff = end_mins - start_mins;
      const hours = Math.floor(diff / 60);
      const mins = diff % 60;
      return `${hours}h ${mins}m`;
    }
  };

  return (
    <div className="rounded-2xl border border-app-border bg-app-surface p-6 shadow-sm space-y-6">
      {/* Section Header */}
      <div className="flex items-center justify-between border-b border-app-border pb-4">
        <h2 className="text-xl font-bold text-app-text-primary">
          {translations.lbl_section_breaks}
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
                <span>{translations.btn_add_break}</span>
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
                {translations.th_break_start}
              </th>
              <th className="px-5 py-3.5 text-start font-semibold">
                {translations.th_break_end}
              </th>
              <th className="px-5 py-3.5 text-start font-semibold">
                {translations.lbl_duration}
              </th>
              {is_edit_mode ? (
                <th className="px-5 py-3.5 text-end font-semibold">
                  {translations.th_actions}
                </th>
              ) : null}
            </tr>
          </thead>
          <tbody className="divide-y divide-app-border text-app-text-primary">
            {0 === break_list.length ? (
              <tr>
                <td
                  colSpan={is_edit_mode ? 5 : 4}
                  className="px-5 py-6 text-center text-app-text-secondary"
                >
                  {translations.msg_no_break_times}
                </td>
              </tr>
            ) : (
              break_list.map((item, index) => (
                <tr
                  key={`${item.day}_${item.breakStart}_${index}`}
                  className="hover:bg-app-input_fill/50 transition-colors"
                >
                  <td className="px-5 py-3.5 font-medium text-start">
                    {get_translated_day(item.day)}
                  </td>
                  <td className="px-5 py-3.5 text-start text-app-text-secondary">
                    {item.breakStart}
                  </td>
                  <td className="px-5 py-3.5 text-start text-app-text-secondary">
                    {item.breakEnd}
                  </td>
                  <td className="px-5 py-3.5 text-start font-medium text-app-primary">
                    {calculate_duration_label(item.breakStart, item.breakEnd)}
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
                          onClick={() => on_delete_break(index)}
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

      {/* Edit/Add Break Modal */}
      {is_modal_open ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-md space-y-4 rounded-2xl border border-app-border bg-app-surface p-6 shadow-2xl">
            <div className="flex items-center justify-between border-b border-app-border pb-3">
              <h3 className="text-lg font-bold text-app-text-primary">
                {is_editing_item
                  ? translations.btn_edit_break
                  : translations.btn_add_break}
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
                placeholder={translations.ph_select_working_day}
                value={selected_day}
                error={
                  validation_errors.day_error
                    ? translations[validation_errors.day_error as keyof typeof translations] ||
                      validation_errors.day_error
                    : ""
                }
                options={available_working_days}
                on_change={(val) => {
                  set_selected_day(val);
                  validate_input(val, break_start, break_end);
                }}
              />

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="mb-1 block text-xs font-semibold text-app-text-primary">
                    {translations.th_break_start} <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={break_start}
                    onChange={(e) => {
                      const val = e.target.value;
                      set_break_start(val);
                      validate_input(selected_day, val, break_end);
                    }}
                    className={`w-full rounded-xl border bg-app-input_fill px-3 py-2 text-sm text-app-text-primary outline-none transition-all ${
                      validation_errors.start_error
                        ? "border-red-500"
                        : "border-app-border focus:border-app-primary"
                    }`}
                  />
                  {validation_errors.start_error ? (
                    <p className="mt-1 text-xs text-red-500 font-medium">
                      {translations[validation_errors.start_error as keyof typeof translations] ||
                        validation_errors.start_error}
                    </p>
                  ) : null}
                </div>

                <div>
                  <label className="mb-1 block text-xs font-semibold text-app-text-primary">
                    {translations.th_break_end} <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={break_end}
                    onChange={(e) => {
                      const val = e.target.value;
                      set_break_end(val);
                      validate_input(selected_day, break_start, val);
                    }}
                    className={`w-full rounded-xl border bg-app-input_fill px-3 py-2 text-sm text-app-text-primary outline-none transition-all ${
                      validation_errors.end_error
                        ? "border-red-500"
                        : "border-app-border focus:border-app-primary"
                    }`}
                  />
                  {validation_errors.end_error ? (
                    <p className="mt-1 text-xs text-red-500 font-medium">
                      {translations[validation_errors.end_error as keyof typeof translations] ||
                        validation_errors.end_error}
                    </p>
                  ) : null}
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
                  : translations.btn_add_break}
              </button>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}

/*
 * File Name: break_times_step.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 *   - @/types/clinic
 *   - @/components/clinics/custom_select
 *   - @/components/clinics/clinic_form_constants
 *   - @/lib/validators/clinic_validator
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Step 3 form view managing break times with CustomSelect dropdowns and real-time inline bounds validation against working schedules.
 */

"use client";

import { useState } from "react";
import { Plus, Edit2, Trash2, X } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { BreakTimeItem, WorkingScheduleItem } from "@/types/clinic";
import CustomSelect from "../custom_select";
import {
  LABEL_CLASS,
  INPUT_CLASS,
  ERROR_CLASS,
  BUTTON_CLASS,
} from "../clinic_form_constants";
import { validate_break_time_item } from "@/lib/validators/clinic_validator";

export type { BreakTimeItem };

type BreakTimesStepProps = {
  breakList: BreakTimeItem[];
  availableWorkingDays: string[];
  scheduleList: WorkingScheduleItem[];
  onAddBreak: (item: BreakTimeItem) => void;
  onEditBreak: (index: number, item: BreakTimeItem) => void;
  onDeleteBreak: (index: number) => void;
};

export default function BreakTimesStep({
  breakList,
  availableWorkingDays,
  scheduleList,
  onAddBreak,
  onEditBreak,
  onDeleteBreak,
}: BreakTimesStepProps) {
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

  const handle_open_modal = (index?: number) => {
    if (undefined !== index && null !== index) {
      set_editing_index(index);
      set_selected_day(breakList[index].day);
      set_break_start(breakList[index].breakStart);
      set_break_end(breakList[index].breakEnd);
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

  const validate_current_input = (day: string, start: string, end: string) => {
    const errs = validate_break_time_item(
      day,
      start,
      end,
      scheduleList,
      breakList,
      editing_index,
    );
    set_validation_errors(errs || {});
    return null === errs;
  };

  const handle_save_item = () => {
    const is_valid = validate_current_input(
      selected_day,
      break_start,
      break_end,
    );

    if (!is_valid) {
      return;
    } else {
      const new_item = {
        day: selected_day,
        breakStart: break_start,
        breakEnd: break_end,
      };

      if (null !== editing_index) {
        onEditBreak(editing_index, new_item);
      } else {
        onAddBreak(new_item);
      }

      handle_close_modal();
    }
  };

  const is_editing = null !== editing_index;

  const get_translated_day = (day_code: string) => {
    const key = `day_${day_code.toLowerCase()}` as keyof typeof translations;
    return translations[key] || day_code;
  };

  const get_error_message = (error_key: string | undefined): string => {
    if (!error_key) {
      return "";
    } else {
      const translated = translations[error_key as keyof typeof translations];
      return translated || error_key;
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h3 className="text-lg font-semibold text-app-text-primary">
            {translations.modal_step_3}
          </h3>
          <p className="text-sm text-app-text-secondary">
            {translations.lbl_break_times_desc}
          </p>
        </div>

        <button
          type="button"
          onClick={() => handle_open_modal()}
          className="flex items-center justify-center gap-2 rounded-xl bg-app-primary px-4 py-2.5 text-sm font-medium text-white hover:opacity-90 transition-all shadow-sm"
        >
          <Plus size={16} />
          {translations.btn_add_break}
        </button>
      </div>

      {/* Table Break List */}
      <div className="overflow-hidden rounded-xl border border-app-border bg-app-surface shadow-sm">
        <table className="w-full text-start text-sm">
          <thead className="border-b border-app-border bg-app-input_fill text-app-text-secondary">
            <tr>
              <th className="px-4 py-3 text-start font-semibold">
                {translations.th_day}
              </th>
              <th className="px-4 py-3 text-start font-semibold">
                {translations.th_break_start}
              </th>
              <th className="px-4 py-3 text-start font-semibold">
                {translations.th_break_end}
              </th>
              <th className="px-4 py-3 text-end font-semibold">
                {translations.th_actions}
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-app-border text-app-text-primary">
            {0 === breakList.length ? (
              <tr>
                <td
                  colSpan={4}
                  className="px-4 py-6 text-center text-app-text-secondary"
                >
                  {translations.msg_no_break_times}
                </td>
              </tr>
            ) : (
              breakList.map((item, index) => (
                <tr
                  key={`${item.day}_${item.breakStart}_${item.breakEnd}`}
                  className="hover:bg-app-input_fill/50 transition-colors"
                >
                  <td className="px-4 py-3 font-medium text-start">
                    {get_translated_day(item.day)}
                  </td>
                  <td className="px-4 py-3 text-start">{item.breakStart}</td>
                  <td className="px-4 py-3 text-start">{item.breakEnd}</td>
                  <td className="px-4 py-3 text-end">
                    <div className="flex items-center justify-end gap-2">
                      <button
                        type="button"
                        onClick={() => handle_open_modal(index)}
                        className="rounded-lg p-1.5 text-app-text-secondary hover:text-app-primary hover:bg-app-primary/10 transition-colors"
                      >
                        <Edit2 size={16} />
                      </button>
                      <button
                        type="button"
                        onClick={() => onDeleteBreak(index)}
                        className="rounded-lg p-1.5 text-app-text-secondary hover:text-red-500 hover:bg-red-500/10 transition-colors"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Modal: Add/Edit Break */}
      {is_modal_open ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-md rounded-2xl bg-app-surface p-6 shadow-2xl space-y-4 border border-app-border">
            <div className="flex items-center justify-between border-b border-app-border pb-3">
              <h3 className="text-lg font-bold text-app-text-primary">
                {is_editing
                  ? translations.btn_edit_break
                  : translations.btn_add_break}
              </h3>
              <button
                type="button"
                onClick={handle_close_modal}
                className="text-app-text-secondary hover:text-app-text-primary rounded-full p-1 transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            <div className="space-y-4">
              <CustomSelect
                label={translations.th_day}
                placeholder={translations.ph_select_working_day}
                value={selected_day}
                error={get_error_message(validation_errors.day_error)}
                options={availableWorkingDays}
                on_change={(val) => {
                  set_selected_day(val);
                  validate_current_input(val, break_start, break_end);
                }}
              />

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className={LABEL_CLASS}>
                    {translations.th_break_start}{" "}
                    <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={break_start}
                    onChange={(e) => {
                      const val = e.target.value;
                      set_break_start(val);
                      validate_current_input(selected_day, val, break_end);
                    }}
                    className={`${INPUT_CLASS} mt-1 ${
                      validation_errors.start_error ? "border-red-500" : ""
                    }`}
                  />
                  {validation_errors.start_error ? (
                    <p className={ERROR_CLASS}>
                      {get_error_message(validation_errors.start_error)}
                    </p>
                  ) : null}
                </div>

                <div>
                  <label className={LABEL_CLASS}>
                    {translations.th_break_end}{" "}
                    <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={break_end}
                    onChange={(e) => {
                      const val = e.target.value;
                      set_break_end(val);
                      validate_current_input(selected_day, break_start, val);
                    }}
                    className={`${INPUT_CLASS} mt-1 ${
                      validation_errors.end_error ? "border-red-500" : ""
                    }`}
                  />
                  {validation_errors.end_error ? (
                    <p className={ERROR_CLASS}>
                      {get_error_message(validation_errors.end_error)}
                    </p>
                  ) : null}
                </div>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 border-t border-app-border pt-4">
              <button
                type="button"
                onClick={handle_close_modal}
                className={`${BUTTON_CLASS} rounded-xl border border-app-border bg-app-surface px-4 py-2 text-app-text-primary hover:bg-app-input_fill`}
              >
                {translations.btn_cancel}
              </button>
              <button
                type="button"
                onClick={handle_save_item}
                className={`${BUTTON_CLASS} rounded-xl bg-app-primary px-5 py-2 text-white hover:opacity-90`}
              >
                {is_editing
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

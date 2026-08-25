/**
 * File Name : receptionists_section.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/types/clinic
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Section 4 component managing Assigned Receptionists table and assignment transfer modal matching visual reference design.
 */

"use client";

import { useState } from "react";
import { UserPlus, Trash2, Edit2, Search, X, ChevronRight } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import { ReceptionistItem } from "@/types/clinic";

const MOCK_ALL_RECEPTIONISTS: ReceptionistItem[] = [
  { id: "1", name: "Aya Samir", phone: "01023456789", status: "Active", initials: "AS" },
  { id: "2", name: "Mohamed Hesham", phone: "01009876543", status: "Active", initials: "MH" },
  { id: "3", name: "Nour Mohamed", phone: "01112233445", status: "Active", initials: "NM" },
  { id: "4", name: "Omar Tarek", phone: "01052223344", status: "Active", initials: "OT" },
  { id: "5", name: "Sara Ahmed", phone: "01063334455", status: "Active", initials: "SA" },
];

type ReceptionistsSectionProps = {
  is_edit_mode: boolean;
  is_card_dirty?: boolean;
  assigned_receptionists: ReceptionistItem[];
  on_update_assigned: (list: ReceptionistItem[]) => void;
  on_toggle_edit: () => void;
  on_cancel?: () => void;
  on_save?: () => void;
};

export default function ReceptionistsSection({
  is_edit_mode,
  is_card_dirty = false,
  assigned_receptionists,
  on_update_assigned,
  on_toggle_edit,
  on_cancel,
  on_save,
}: ReceptionistsSectionProps) {
  const { translations } = useTranslation();
  const [is_modal_open, set_is_modal_open] = useState(false);
  const [search_query, set_search_query] = useState("");
  const [temp_selected, set_temp_selected] = useState<ReceptionistItem[]>([]);
  const [checked_available_ids, set_checked_available_ids] = useState<string[]>([]);

  const handle_open_modal = () => {
    set_temp_selected([...assigned_receptionists]);
    set_checked_available_ids([]);
    set_search_query("");
    set_is_modal_open(true);
  };

  const handle_remove_assigned = (id: string) => {
    on_update_assigned(assigned_receptionists.filter((r) => r.id !== id));
  };

  const available_list = MOCK_ALL_RECEPTIONISTS.filter(
    (r) => !temp_selected.some((selected) => selected.id === r.id),
  ).filter(
    (r) =>
      r.name.toLowerCase().includes(search_query.toLowerCase()) ||
      r.phone.includes(search_query),
  );

  const handle_toggle_check_available = (id: string) => {
    set_checked_available_ids((prev) =>
      prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id],
    );
  };

  const handle_move_to_selected = () => {
    const items_to_move = MOCK_ALL_RECEPTIONISTS.filter((r) =>
      checked_available_ids.includes(r.id),
    );
    set_temp_selected((prev) => [...prev, ...items_to_move]);
    set_checked_available_ids([]);
  };

  const handle_remove_from_selected_modal = (id: string) => {
    set_temp_selected((prev) => prev.filter((item) => item.id !== id));
  };

  const handle_save_modal = () => {
    on_update_assigned(temp_selected);
    set_is_modal_open(false);
  };

  return (
    <div className="rounded-2xl border border-app-border bg-app-surface p-6 shadow-sm space-y-6">
      {/* Section Header */}
      <div className="flex items-center justify-between border-b border-app-border pb-4">
        <h2 className="text-xl font-bold text-app-text-primary">
          {translations.lbl_section_receptionists}
        </h2>

        <div className="flex items-center gap-3">
          {is_edit_mode ? (
            <>
              <button
                type="button"
                onClick={handle_open_modal}
                className="flex items-center gap-1.5 rounded-lg bg-app-primary px-3 py-1.5 text-xs font-semibold text-white shadow-sm hover:opacity-90 transition-all"
              >
                <UserPlus size={14} />
                <span>{translations.btn_assign_receptionist}</span>
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
                {translations.th_receptionist_name}
              </th>
              <th className="px-5 py-3.5 text-start font-semibold">
                {translations.lbl_phone}
              </th>
              <th className="px-5 py-3.5 text-start font-semibold">
                {translations.th_status}
              </th>
              {is_edit_mode ? (
                <th className="px-5 py-3.5 text-end font-semibold">
                  {translations.th_actions}
                </th>
              ) : null}
            </tr>
          </thead>
          <tbody className="divide-y divide-app-border text-app-text-primary">
            {0 === assigned_receptionists.length ? (
              <tr>
                <td
                  colSpan={is_edit_mode ? 4 : 3}
                  className="px-5 py-6 text-center text-app-text-secondary"
                >
                  {translations.msg_no_receptionists_assigned}
                </td>
              </tr>
            ) : (
              assigned_receptionists.map((item) => (
                <tr
                  key={item.id}
                  className="hover:bg-app-input_fill/50 transition-colors"
                >
                  <td className="px-5 py-3.5 font-medium text-start">
                    <div className="flex items-center gap-3">
                      <div className="flex h-8 w-8 items-center justify-center rounded-full bg-purple-100 text-xs font-bold text-purple-700 dark:bg-purple-950/40 dark:text-purple-300">
                        {item.initials || "AS"}
                      </div>
                      <span>{item.name}</span>
                    </div>
                  </td>
                  <td className="px-5 py-3.5 text-start text-app-text-secondary">
                    {item.phone}
                  </td>
                  <td className="px-5 py-3.5 text-start">
                    <span className="inline-flex items-center rounded-md bg-emerald-100 px-2.5 py-0.5 text-xs font-semibold text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-400">
                      {item.status || "Active"}
                    </span>
                  </td>
                  {is_edit_mode ? (
                    <td className="px-5 py-3.5 text-end">
                      <button
                        type="button"
                        onClick={() => handle_remove_assigned(item.id)}
                        className="rounded-lg p-1.5 text-app-text-secondary hover:bg-red-500/10 hover:text-red-500 transition-all"
                      >
                        <Trash2 size={16} />
                      </button>
                    </td>
                  ) : null}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Modal: Assign Receptionists */}
      {is_modal_open ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-2xl space-y-4 rounded-2xl border border-app-border bg-app-surface p-6 shadow-2xl">
            <div className="flex items-center justify-between border-b border-app-border pb-3">
              <h3 className="text-lg font-bold text-app-text-primary">
                {translations.btn_assign_receptionist}
              </h3>
              <button
                type="button"
                onClick={() => set_is_modal_open(false)}
                className="rounded-full p-1 text-app-text-secondary hover:text-app-text-primary transition-colors"
              >
                <X size={18} />
              </button>
            </div>

            {/* Search Input */}
            <div className="relative">
              <Search
                size={16}
                className="absolute left-3 top-1/2 -translate-y-1/2 text-app-text-secondary"
              />
              <input
                type="text"
                placeholder={translations.ph_search_receptionists}
                value={search_query}
                onChange={(e) => set_search_query(e.target.value)}
                className="w-full rounded-xl border border-app-border bg-app-input_fill pl-9 pr-4 py-2 text-sm text-app-text-primary outline-none focus:border-app-primary"
              />
            </div>

            {/* Transfer List Container */}
            <div className="grid grid-cols-[1fr_auto_1fr] items-center gap-3">
              <div className="h-60 space-y-2 overflow-y-auto rounded-xl border border-app-border p-3">
                <span className="mb-2 block text-xs font-semibold text-app-text-secondary">
                  {translations.lbl_available_receptionists}
                </span>
                {0 === available_list.length ? (
                  <p className="py-4 text-center text-xs text-app-text-secondary">
                    {translations.msg_no_available_receptionists}
                  </p>
                ) : (
                  available_list.map((r) => (
                    <label
                      key={r.id}
                      className="flex cursor-pointer items-center justify-between rounded-lg p-2 text-xs hover:bg-app-input_fill"
                    >
                      <div className="flex items-center gap-2">
                        <input
                          type="checkbox"
                          checked={checked_available_ids.includes(r.id)}
                          onChange={() => handle_toggle_check_available(r.id)}
                          className="rounded text-app-primary accent-app-primary"
                        />
                        <span className="font-medium text-app-text-primary">
                          {r.name}
                        </span>
                      </div>
                      <span className="text-app-text-secondary">{r.phone}</span>
                    </label>
                  ))
                )}
              </div>

              <div className="flex flex-col gap-2">
                <button
                  type="button"
                  onClick={handle_move_to_selected}
                  disabled={0 === checked_available_ids.length}
                  className="rounded-lg border border-app-border p-2 hover:bg-app-input_fill disabled:opacity-40"
                >
                  <ChevronRight size={16} />
                </button>
              </div>

              <div className="h-60 space-y-2 overflow-y-auto rounded-xl border border-app-border p-3">
                <span className="mb-2 block text-xs font-semibold text-app-text-secondary">
                  {translations.lbl_selected_receptionists}
                </span>
                {0 === temp_selected.length ? (
                  <p className="py-4 text-center text-xs text-app-text-secondary">
                    {translations.msg_none_selected}
                  </p>
                ) : (
                  temp_selected.map((r) => (
                    <div
                      key={r.id}
                      className="flex items-center justify-between rounded-lg border border-app-border bg-app-input_fill/50 p-2 text-xs"
                    >
                      <span className="font-medium text-app-text-primary">
                        {r.name}
                      </span>
                      <button
                        type="button"
                        onClick={() => handle_remove_from_selected_modal(r.id)}
                        className="text-red-500 hover:text-red-700"
                      >
                        <X size={14} />
                      </button>
                    </div>
                  ))
                )}
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 border-t border-app-border pt-4">
              <button
                type="button"
                onClick={() => set_is_modal_open(false)}
                className="rounded-xl border border-app-border bg-app-surface px-4 py-2 text-xs font-semibold text-app-text-primary hover:bg-app-input_fill"
              >
                {translations.btn_cancel}
              </button>
              <button
                type="button"
                onClick={handle_save_modal}
                className="rounded-xl bg-app-primary px-5 py-2 text-xs font-semibold text-white hover:opacity-90"
              >
                {translations.btn_save_changes}
              </button>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}

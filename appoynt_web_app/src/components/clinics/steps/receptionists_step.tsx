/*
 * File Name: receptionist_step.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/context/language_context
 *   - @/components/clinics/custom_select
 *   - @/components/clinics/clinic_form_constants
 *   - @/lib/validators/clinic_validator
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Step 1 form view for entering and validating receptionist information, including personal details, contact information, clinic assignment, and account credentials.
 */
import { useState } from "react";
import { useTranslation } from "@/context/language_context";
import {
  UserPlus,
  Trash2,
  Info,
  Search,
  X,
  ChevronRight,
  ChevronLeft,
} from "lucide-react";
import { BUTTON_CLASS } from "../clinic_form_constants";

export type ReceptionistItem = {
  id: string;
  name: string;
  phone: string;
  status: string;
  initials: string;
};

// ??? ???????? ??????????? ???????
const MOCK_ALL_RECEPTIONISTS: ReceptionistItem[] = [
  {
    id: "1",
    name: "Aya Samir",
    phone: "0102 345 6789",
    status: "Active",
    initials: "AS",
  },
  {
    id: "2",
    name: "Mohamed Hesham",
    phone: "0100 987 6543",
    status: "Active",
    initials: "MH",
  },
  {
    id: "3",
    name: "Nour Mohamed",
    phone: "0111 223 3445",
    status: "Active",
    initials: "NM",
  },
  {
    id: "4",
    name: "Omar Tarek",
    phone: "0105 222 3344",
    status: "Active",
    initials: "OT",
  },
  {
    id: "5",
    name: "Sara Ahmed",
    phone: "0106 333 4455",
    status: "Active",
    initials: "SA",
  },
  {
    id: "6",
    name: "Mostafa Ali",
    phone: "0107 444 5566",
    status: "Active",
    initials: "MA",
  },
  {
    id: "7",
    name: "Yasmine Mohamed",
    phone: "0108 555 6677",
    status: "Active",
    initials: "YM",
  },
];

type ReceptionistsStepProps = {
  assignedReceptionists: ReceptionistItem[];
  onUpdateAssigned: (list: ReceptionistItem[]) => void;
};

export default function ReceptionistsStep({
  assignedReceptionists,
  onUpdateAssigned,
}: ReceptionistsStepProps) {
  const { translations } = useTranslation();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [tempSelected, setTempSelected] = useState<ReceptionistItem[]>([]);
  const [checkedAvailableIds, setCheckedAvailableIds] = useState<string[]>([]);

  const handleOpenModal = () => {
    setTempSelected([...assignedReceptionists]);
    setCheckedAvailableIds([]);
    setSearchQuery("");
    setIsModalOpen(true);
  };

  const handleRemoveAssigned = (id: string) => {
    onUpdateAssigned(assignedReceptionists.filter((r) => r.id !== id));
  };

  // Receptionists available to assign
  const availableList = MOCK_ALL_RECEPTIONISTS.filter(
    (r) => !tempSelected.some((selected) => selected.id === r.id),
  ).filter(
    (r) =>
      r.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      r.phone.includes(searchQuery),
  );

  const handleToggleCheckAvailable = (id: string) => {
    setCheckedAvailableIds((prev) =>
      prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id],
    );
  };

  const handleMoveToSelected = () => {
    const itemsToMove = MOCK_ALL_RECEPTIONISTS.filter((r) =>
      checkedAvailableIds.includes(r.id),
    );
    setTempSelected((prev) => [...prev, ...itemsToMove]);
    setCheckedAvailableIds([]);
  };

  const handleRemoveFromSelectedModal = (id: string) => {
    setTempSelected((prev) => prev.filter((item) => item.id !== id));
  };

  const handleSaveModal = () => {
    onUpdateAssigned(tempSelected);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h3 className="text-lg font-semibold text-app-text-primary">
            {translations.modal_step_4 || "Assigned Receptionists"}
          </h3>
          <p className="text-sm text-app-text-secondary">
            {translations.lbl_receptionists_desc || "Assign receptionists who can manage appointments for this clinic."}
          </p>
        </div>

        <button
          type="button"
          onClick={handleOpenModal}
          className="flex items-center justify-center gap-2 rounded-lg bg-app-primary px-4 py-2 text-sm font-medium text-white hover:opacity-90 transition-all whitespace-nowrap shrink-0"
        >
          <UserPlus size={16} className="shrink-0" />
          <span>{translations.btn_assign_receptionist || "Assign Receptionist"}</span>
        </button>
      </div>

      {/* Table Assigned Receptionists */}
      <div className="overflow-hidden rounded-lg border border-app-border bg-app-surface">
        <table className="w-full text-left text-sm">
          <thead className="border-b border-app-border bg-app-input_fill text-app-text-secondary">
            <tr>
              <th className="px-4 py-3 font-medium">Name</th>
              <th className="px-4 py-3 font-medium">Phone Number</th>
              <th className="px-4 py-3 font-medium">Status</th>
              <th className="px-4 py-3 text-right font-medium">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-app-border text-app-text-primary">
            {assignedReceptionists.length === 0 ? (
              <tr>
                <td
                  colSpan={4}
                  className="px-4 py-6 text-center text-app-text-secondary"
                >
                  No receptionists assigned yet.
                </td>
              </tr>
            ) : (
              assignedReceptionists.map((item) => (
                <tr key={item.id} className="hover:bg-app-input_fill/50">
                  <td className="px-4 py-3 font-medium">
                    <div className="flex items-center gap-3">
                      <div className="flex h-8 w-8 items-center justify-center rounded-full bg-purple-100 text-xs font-semibold text-purple-700">
                        {item.initials}
                      </div>
                      <span>{item.name}</span>
                    </div>
                  </td>
                  <td className="px-4 py-3">{item.phone}</td>
                  <td className="px-4 py-3">
                    <span className="inline-block rounded-full bg-emerald-100 px-2.5 py-0.5 text-xs font-medium text-emerald-700">
                      {item.status}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-right">
                    <button
                      type="button"
                      onClick={() => handleRemoveAssigned(item.id)}
                      className="rounded p-1 text-app-text-secondary hover:text-red-500"
                    >
                      <Trash2 size={16} />
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      

      {/* Modal: Assign Receptionist */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-2xl rounded-xl bg-app-surface p-6 shadow-xl space-y-4">
            <div className="flex items-center justify-between border-b border-app-border pb-3">
              <h3 className="text-lg font-semibold text-app-text-primary">
                {translations.btn_assign_receptionist || "Assign Receptionist"}
              </h3>
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="text-app-text-secondary hover:text-app-text-primary"
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
                placeholder="Search receptionists..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full rounded-lg border border-app-border bg-app-surface pl-9 pr-4 py-2 text-sm focus:border-app-primary focus:outline-none"
              />
            </div>

            {/* Transfer Lists */}
            <div className="grid grid-cols-[1fr_auto_1fr] gap-3 items-center">
              {/* Available List */}
              <div className="border border-app-border rounded-lg p-3 h-60 overflow-y-auto space-y-2">
                <span className="text-xs font-semibold text-app-text-secondary block mb-2">
                  Available Receptionists
                </span>
                {availableList.length === 0 ? (
                  <p className="text-xs text-app-text-secondary py-4 text-center">
                    No available receptionists
                  </p>
                ) : (
                  availableList.map((r) => (
                    <label
                      key={r.id}
                      className="flex items-center justify-between p-2 rounded-lg hover:bg-app-input_fill cursor-pointer border border-transparent hover:border-app-border text-xs"
                    >
                      <div className="flex items-center gap-2">
                        <input
                          type="checkbox"
                          checked={checkedAvailableIds.includes(r.id)}
                          onChange={() => handleToggleCheckAvailable(r.id)}
                          className="rounded text-app-primary focus:ring-app-primary"
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

              {/* Transfer Controls */}
              <div className="flex flex-col gap-2">
                <button
                  type="button"
                  onClick={handleMoveToSelected}
                  disabled={checkedAvailableIds.length === 0}
                  className="p-2 border border-app-border rounded-lg hover:bg-app-input_fill disabled:opacity-40 disabled:cursor-not-allowed"
                >
                  <ChevronRight size={16} />
                </button>
              </div>

              {/* Selected List */}
              <div className="border border-app-border rounded-lg p-3 h-60 overflow-y-auto space-y-2">
                <span className="text-xs font-semibold text-app-text-secondary block mb-2">
                  Selected Receptionists
                </span>
                {tempSelected.length === 0 ? (
                  <p className="text-xs text-app-text-secondary py-4 text-center">
                    None selected
                  </p>
                ) : (
                  tempSelected.map((r) => (
                    <div
                      key={r.id}
                      className="flex items-center justify-between p-2 rounded-lg bg-app-input_fill/50 border border-app-border text-xs"
                    >
                      <div className="flex items-center gap-2">
                        <span className="font-medium text-app-text-primary">
                          {r.name}
                        </span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-app-text-secondary">
                          {r.phone}
                        </span>
                        <button
                          type="button"
                          onClick={() => handleRemoveFromSelectedModal(r.id)}
                          className="text-red-500 hover:text-red-700"
                        >
                          <X size={14} />
                        </button>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 border-t border-app-border pt-4">
              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className={`${BUTTON_CLASS} border border-app-border bg-app-surface px-4 py-2 text-app-text-primary`}
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleSaveModal}
                className={`${BUTTON_CLASS} bg-app-primary px-4 py-2 text-white`}
              >
                Save
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

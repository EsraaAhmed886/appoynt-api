import { useState } from "react";
import { Plus, Edit2, Trash2, Info, X } from "lucide-react";
import {
  LABEL_CLASS,
  INPUT_CLASS,
  BUTTON_CLASS,
  INFO_ALERT_CLASS,
} from "../clinic_form_constants";

export type BreakTimeItem = {
  day: string;
  breakStart: string;
  breakEnd: string;
};

type BreakTimesStepProps = {
  breakList: BreakTimeItem[];
  availableWorkingDays: string[];
  onAddBreak: (item: BreakTimeItem) => void;
  onEditBreak: (index: number, item: BreakTimeItem) => void;
  onDeleteBreak: (index: number) => void;
};

export default function BreakTimesStep({
  breakList,
  availableWorkingDays,
  onAddBreak,
  onEditBreak,
  onDeleteBreak,
}: BreakTimesStepProps) {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingIndex, setEditingIndex] = useState<number | null>(null);

  const [selectedDay, setSelectedDay] = useState("");
  const [breakStart, setBreakStart] = useState("");
  const [breakEnd, setBreakEnd] = useState("");

  const handleOpenModal = (index?: number) => {
    if (index !== undefined && index !== null) {
      setEditingIndex(index);
      setSelectedDay(breakList[index].day);
      setBreakStart(breakList[index].breakStart);
      setBreakEnd(breakList[index].breakEnd);
    } else {
      setEditingIndex(null);
      setSelectedDay("");
      setBreakStart("");
      setBreakEnd("");
    }
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setEditingIndex(null);
  };

  const handleSaveItem = () => {
    if (!selectedDay || !breakStart || !breakEnd) return;

    const newItem = { day: selectedDay, breakStart, breakEnd };

    if (editingIndex !== null) {
      onEditBreak(editingIndex, newItem);
    } else {
      onAddBreak(newItem);
    }

    handleCloseModal();
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-app-text-primary">
            Break Times
          </h3>
          <p className="text-sm text-app-text-secondary">
            Add break periods within the working hours.
          </p>
        </div>

        <button
          type="button"
          onClick={() => handleOpenModal()}
          className="flex items-center gap-2 rounded-lg bg-app-primary px-4 py-2 text-sm font-medium text-white hover:opacity-90 transition-all"
        >
          <Plus size={16} />
          Add Break
        </button>
      </div>

      {/* Table Break List */}
      <div className="overflow-hidden rounded-lg border border-app-border bg-app-surface">
        <table className="w-full text-left text-sm">
          <thead className="border-b border-app-border bg-app-input_fill text-app-text-secondary">
            <tr>
              <th className="px-4 py-3 font-medium">Working Day</th>
              <th className="px-4 py-3 font-medium">Break Start</th>
              <th className="px-4 py-3 font-medium">Break End</th>
              <th className="px-4 py-3 text-right font-medium">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-app-border text-app-text-primary">
            {breakList.length === 0 ? (
              <tr>
                <td
                  colSpan={4}
                  className="px-4 py-6 text-center text-app-text-secondary"
                >
                  No break times added yet.
                </td>
              </tr>
            ) : (
              breakList.map((item, index) => (
                <tr key={index} className="hover:bg-app-input_fill/50">
                  <td className="px-4 py-3 font-medium">{item.day}</td>
                  <td className="px-4 py-3">{item.breakStart}</td>
                  <td className="px-4 py-3">{item.breakEnd}</td>
                  <td className="px-4 py-3 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <button
                        type="button"
                        onClick={() => handleOpenModal(index)}
                        className="rounded p-1 text-app-text-secondary hover:text-app-primary"
                      >
                        <Edit2 size={16} />
                      </button>
                      <button
                        type="button"
                        onClick={() => onDeleteBreak(index)}
                        className="rounded p-1 text-app-text-secondary hover:text-red-500"
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
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-md rounded-xl bg-app-surface p-6 shadow-xl space-y-4">
            <div className="flex items-center justify-between border-b border-app-border pb-3">
              <h3 className="text-lg font-semibold text-app-text-primary">
                {editingIndex !== null ? "Edit Break" : "Add Break"}
              </h3>
              <button
                type="button"
                onClick={handleCloseModal}
                className="text-app-text-secondary hover:text-app-text-primary"
              >
                <X size={18} />
              </button>
            </div>

            <div className="space-y-4">
              <div>
                <label className={LABEL_CLASS}>
                  Working Day <span className="text-red-500">*</span>
                </label>
                <select
                  value={selectedDay}
                  onChange={(e) => setSelectedDay(e.target.value)}
                  className={`${INPUT_CLASS} mt-1`}
                >
                  <option value="">Select working day</option>
                  {availableWorkingDays.map((day) => (
                    <option key={day} value={day}>
                      {day}
                    </option>
                  ))}
                </select>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className={LABEL_CLASS}>
                    Break Start <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={breakStart}
                    onChange={(e) => setBreakStart(e.target.value)}
                    className={`${INPUT_CLASS} mt-1`}
                  />
                </div>

                <div>
                  <label className={LABEL_CLASS}>
                    Break End <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="time"
                    value={breakEnd}
                    onChange={(e) => setBreakEnd(e.target.value)}
                    className={`${INPUT_CLASS} mt-1`}
                  />
                </div>
              </div>

              
            </div>

            <div className="flex items-center justify-end gap-3 border-t border-app-border pt-4">
              <button
                type="button"
                onClick={handleCloseModal}
                className={`${BUTTON_CLASS} border border-app-border bg-app-surface px-4 py-2 text-app-text-primary`}
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleSaveItem}
                className={`${BUTTON_CLASS} bg-app-primary px-4 py-2 text-white`}
              >
                {editingIndex !== null ? "Save Changes" : "Add Break"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

import { X } from "lucide-react";
import { useState } from "react";

const days = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];

type AddClinicModalProps = {
  isOpen: boolean;
  onClose: () => void;
};

export default function AddClinicModal({
  isOpen,
  onClose,
}: AddClinicModalProps) {
  const [location, setLocation] = useState("");
  const [clinicName, setClinicName] = useState("");
  const [clinicNameError, setClinicNameError] = useState("");
  const handleSave = () => {
    let isValid = true;

    if (clinicName.trim() === "") {
      setClinicNameError("Clinic name is required");
      isValid = false;
    }

    if (!isValid) return;

    console.log("Form is valid");
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-black/50">
      <div className="w-[600px] rounded-xl bg-white p-6 shadow-xl">
        <div className="flex items-center justify-between border-b pb-4">
          <h2 className="text-xl font-semibold text-blue-600">
            Add New Clinic
          </h2>

          <button
            onClick={onClose}
            className="rounded-full p-1 text-gray-500 hover:bg-gray-200 hover:text-gray-700"
          >
            <X size={20} />
          </button>
        </div>

        <form
          className="mt-6 space-y-4"
          onSubmit={(e) => {
            e.preventDefault();
              handleSave();
          }}
        >
          <div className="flex flex-col">
            <label className="mb-2 text-sm font-semibold text-gray-700">
              Clinic Name <span className="text-red-500">*</span>
            </label>

            <input
              type="text"
              value={clinicName}
              onChange={(e) => {
                setClinicName(e.target.value);
                setClinicNameError("");
              }}
              placeholder="Enter clinic name"
              className={`w-full rounded-lg border px-4 py-2.5 outline-none focus:ring-2 ${
                clinicNameError
                  ? "border-red-500 focus:ring-red-200"
                  : "border-gray-300 focus:border-blue-500 focus:ring-blue-200"
              }`}
            />
            {clinicNameError && (
              <p className="mt-1 text-sm text-red-500">{clinicNameError}</p>
            )}
          </div>

          <div className="flex flex-col">
            <label className="mb-2 text-sm font-semibold text-gray-700">
              Phone Number <span className="text-red-500">*</span>
            </label>

            <input
              type="text"
              placeholder="Enter phone number"
              className="w-full rounded-lg border border-gray-300 px-4 py-2.5 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200"
            />
          </div>

          <div className="flex flex-col">
            <label className="mb-2 text-sm font-semibold text-gray-700">
              Location <span className="text-red-500">*</span>
            </label>

            <div className="relative">
              <select
                value={location}
                onChange={(e) => setLocation(e.target.value)}
                className={`w-full appearance-none rounded-lg border border-gray-300 bg-white px-4 py-2.5 pr-10 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200 ${
                  location ? "text-gray-900" : "text-gray-400"
                }`}
              >
                <option value="" disabled>
                  Select location
                </option>
                <option value="cairo" className="text-gray-900">
                  Cairo
                </option>
                <option value="giza" className="text-gray-900">
                  Giza
                </option>
                <option value="alex" className="text-gray-900">
                  Alexandria
                </option>
              </select>

              <svg
                className="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-500"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M5.23 7.21a.75.75 0 011.06.02L10 11.17l3.71-3.94a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"
                />
              </svg>
            </div>
          </div>

          <div className="flex flex-col">
            <label className="mb-2 text-sm font-semibold text-gray-700">
              Consultation Fee <span className="text-red-500">*</span>
            </label>

            <div className="flex">
              <input
                type="number"
                min={1}
                placeholder="Enter fee"
                className="w-full rounded-lg border border-gray-300 px-4 py-2.5 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200"
              />

              <div className="flex items-center rounded-r-lg border border-gray-300 bg-gray-50 px-4">
                EGP
              </div>
            </div>
          </div>

          <div className="flex flex-col">
            <label className="mb-2 text-sm font-semibold text-gray-700">
              Working Days <span className="text-red-500">*</span>
            </label>

            <div className="grid grid-cols-7 gap-2">
              {days.map((day) => (
                <button
                  key={day}
                  type="button"
                  className="w-full rounded-lg border border-gray-300 px-4 py-2.5 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200"
                >
                  {day}
                </button>
              ))}
            </div>
          </div>

          <div className="flex flex-col">
            <label className="mb-2 text-sm font-semibold text-gray-700">
              Status <span className="text-red-500">*</span>
            </label>

            <div className="flex items-center gap-8">
              <label className="flex items-center gap-2">
                <input
                  type="radio"
                  name="status"
                  value="Active"
                  defaultChecked
                />
                Active
              </label>

              <label className="flex items-center gap-2">
                <input type="radio" name="status" value="Inactive" />
                Inactive
              </label>
            </div>
          </div>

          <div className="mt-8 flex justify-end gap-4">
            <button
              type="button"
              onClick={onClose}
              className="h-10 rounded-md border border-gray-300 bg-white px-6 text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              Cancel
            </button>

            <button
              type="submit"
              className="h-10 rounded-md bg-blue-600 px-8 text-sm font-medium text-white hover:bg-blue-700"
            >
              Save Clinic
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

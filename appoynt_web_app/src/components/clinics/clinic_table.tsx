import { Pencil, Trash2 } from "lucide-react";
import { clinics } from "@/data/clinics";

export default function ClinicTable() {
  return (
    <div className="mt-6 overflow-hidden rounded-xl border border-gray-200 bg-white shadow-sm">
      <table className="w-full">
        <thead className="bg-gray-50">
          <tr className="text-left text-sm text-gray-600">
            <th className="px-6 py-4">Clinic Name</th>
            <th className="px-6 py-4">Location</th>
            <th className="px-6 py-4">Phone</th>
            <th className="px-6 py-4">Consultation Fee</th>
            <th className="px-6 py-4">Working Days</th>
            <th className="px-6 py-4">Status</th>
            <th className="px-6 py-4 text-center">Actions</th>
          </tr>
        </thead>

        <tbody>
          {clinics.map((clinic) => (
            <tr
              key={clinic.id}
              className="border-t border-gray-200 hover:bg-gray-50"
            >
              <td className="px-6 py-4 font-medium">{clinic.name}</td>

              <td className="px-6 py-4">{clinic.location}</td>

              <td className="px-6 py-4">{clinic.phone}</td>

              <td className="px-6 py-4">
                {clinic.consultationFee}
              </td>

              <td className="px-6 py-4">
                {clinic.workingDays}
              </td>

              <td className="px-6 py-4">
                <span
                  className={`rounded-full px-3 py-1 text-xs font-semibold ${
                    clinic.status === "Active"
                      ? "bg-green-100 text-green-700"
                      : "bg-red-100 text-red-700"
                  }`}
                >
                  {clinic.status}
                </span>
              </td>

              <td className="px-6 py-4">
                <div className="flex justify-center gap-4">
                  <button>
                    <Pencil className="h-5 w-5 text-blue-600 hover:text-blue-800" />
                  </button>

                  <button>
                    <Trash2 className="h-5 w-5 text-red-600 hover:text-red-800" />
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
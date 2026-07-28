import { Pencil, Trash2 } from "lucide-react";
import Link from "next/link";

type Clinic = {
  id: number;
  name: string;
  location: string;
  phone: string;
  consultationFee: string;
  workingDays: string;
  status: string;
};

type ClinicTableProps = {
  clinics: Clinic[];
  onDeleteClinic: (clinicId: number) => void;
};

export default function ClinicTable({
  clinics,
  onDeleteClinic,
}: ClinicTableProps) {
  return (
    <div className="mt-6 overflow-x-auto rounded-xl border border-app-border bg-app-surface shadow-sm">
      <table className="min-w-[900px] w-full">
        <thead className="border-b border-app-border bg-app-input_fill">
          <tr className="text-left text-sm text-app-text-secondary">
            <th className="px-4 py-3 text-sm lg:px-6 lg:py-4">Clinic Name</th>
            <th className="px-4 py-3 text-sm lg:px-6 lg:py-4">Location</th>
            <th className="px-4 py-3 text-sm lg:px-6 lg:py-4">Phone</th>
            <th className="px-4 py-3 text-sm lg:px-6 lg:py-4">
              Consultation Fee
            </th>
            <th className="px-4 py-3 text-sm lg:px-6 lg:py-4">Working Days</th>
            <th className="px-4 py-3 text-sm lg:px-6 lg:py-4">Status</th>
            <th className="px-4 py-3 text-sm lg:px-6 lg:py-4 text-center">
              Actions
            </th>
          </tr>
        </thead>

        <tbody>
          {clinics.map((clinic) => (
            <tr
              key={clinic.id}
              className="border-t border-app-border text-app-text-primary transition hover:bg-app-input_fill"
            >
              <td className="px-4 py-3 text-sm font-medium lg:px-6 lg:py-4">
                {clinic.name}
              </td>

              <td className="px-4 py-3 text-sm lg:px-6 lg:py-4">
                {clinic.location}
              </td>

              <td className="px-4 py-3 text-sm lg:px-6 lg:py-4">
                {clinic.phone}
              </td>

              <td className="px-4 py-3 text-sm lg:px-6 lg:py-4">
                {clinic.consultationFee}
              </td>

              <td className="px-4 py-3 text-sm lg:px-6 lg:py-4">
                {clinic.workingDays}
              </td>

              <td className="px-4 py-3 text-sm lg:px-6 lg:py-4">
                <span
                  className={`rounded-full px-3 py-1 text-xs font-semibold ${
                    clinic.status === "Active"
                      ? "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400"
                      : "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400"
                  }`}
                >
                  {clinic.status}
                </span>
              </td>

              <td className="px-4 py-3 text-sm lg:px-6 lg:py-4">
                <div className="flex justify-center gap-2 lg:gap-4">
                  <Link href={`/clinics/${clinic.id}/edit`}>
                  <button className="transition hover:scale-110">
                    <Pencil className="h-5 w-5 text-app-primary" />
                  </button>
                  </Link>

                  <button
                    onClick={() => onDeleteClinic(clinic.id)}
                    className="transition hover:scale-110"
                  >
                    <Trash2 className="h-5 w-5 text-red-500 hover:text-red-600" />
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
import { Search } from "lucide-react";

export default function ClinicSearch() {
  return (
    <div className="relative w-80">
        <Search
        className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"
        size={18}
      />
      <input
        type="text"
        placeholder="Search clinics..."
        className="w-full rounded-lg border border-gray-300 bg-white py-2.5 pl-10 pr-4 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
      />
    </div>
  );
}
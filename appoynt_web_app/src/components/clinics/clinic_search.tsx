import { Search } from "lucide-react";

type ClinicSearchProps = {
  search: string;
  onSearchChange: (value: string) => void;
};

export default function ClinicSearch({
  search,
  onSearchChange,
}: ClinicSearchProps) {
  return (
    <div className="relative w-80">
      <Search
        className="absolute left-3 top-1/2 -translate-y-1/2 text-app-text-secondary"
        size={18}
      />

      <input
        type="text"
        value={search}
        placeholder="Search clinics..."
        className="
          w-full
          rounded-lg
          border
          border-app-border
          bg-app-input_fill
          py-2.5
          pl-10
          pr-4
          text-app-text-primary
          shadow-sm
          placeholder:text-app-text-secondary
          focus:outline-none
          focus:ring-2
          focus:ring-app-primary/20
          focus:border-app-primary
        "
        onChange={(e) => onSearchChange(e.target.value)}
      />
    </div>
  );
}
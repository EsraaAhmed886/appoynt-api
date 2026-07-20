import ClinicSearch from "./clinic_search";
import AddClinicButton from "./add_clinic_button";
import ClinicSort from "./clinic_sort";

type ClinicToolbarProps = {
  onAddClinic: () => void;
  search: string;
  onSearchChange: (value: string) => void;
  sortOrder: string;
  onSortChange: (value: string) => void;
};

export default function ClinicToolbar({
  onAddClinic,
  search,
  onSearchChange,
  sortOrder,
  onSortChange,
}: ClinicToolbarProps) {
  return (
    <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center">
        <ClinicSearch search={search} onSearchChange={onSearchChange} />

        <ClinicSort sortOrder={sortOrder} onSortChange={onSortChange} />
      </div>

      <div className="self-start lg:self-auto">
        <AddClinicButton onClick={onAddClinic} />
      </div>
    </div>
  );
}
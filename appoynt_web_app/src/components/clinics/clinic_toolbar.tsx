import ClinicSearch from "../common/search_input";
import AddClinicButton from "./add_clinic_button";
import ClinicSort from "./clinic_sort";
import StatusFilter from "./status_filter";

type ClinicToolbarProps = {
  onAddClinic: () => void;
  search: string;
  onSearchChange: (value: string) => void;
  statusFilter: string;
  onStatusFilterChange: (value: string) => void;
  sortOrder: string;
  onSortChange: (value: string) => void;
};

export default function ClinicToolbar({
  onAddClinic,
  search,
  onSearchChange,
  statusFilter,
  onStatusFilterChange,
  sortOrder,
  onSortChange,
}: ClinicToolbarProps) {
  return (
    <div className="relative z-10 mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
      <div className="flex flex-wrap items-center gap-4">
        <ClinicSearch search={search} onSearchChange={onSearchChange} />

        <div className="flex items-start gap-4">
          <div className="flex flex-col">
            <StatusFilter
              value={statusFilter}
              onChange={onStatusFilterChange}
            />
          </div>
          <div className="self-start">
          <ClinicSort sortOrder={sortOrder} onSortChange={onSortChange} />
          </div>
        </div>
      </div>

      <div className="self-start lg:self-auto">
        <AddClinicButton onClick={onAddClinic} />
      </div>
    </div>
  );
}

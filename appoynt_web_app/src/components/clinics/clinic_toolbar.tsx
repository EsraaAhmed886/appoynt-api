import ClinicSearch from "./clinic_search";
import AddClinicButton from "./add_clinic_button";

type ClinicToolbarProps = {
  onAddClinic: () => void;
};

export default function ClinicToolbar({
  onAddClinic,
}: ClinicToolbarProps) {
  return (
    <div className="mb-6 flex items-center justify-between">
      <ClinicSearch />
      <AddClinicButton onClick={onAddClinic} />
    </div>
  );
}
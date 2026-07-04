import { Plus } from "lucide-react";

type AddClinicButtonProps = {
  onClick: () => void;
};

export default function AddClinicButton({
  onClick,
}: AddClinicButtonProps) {
  return (
    <button
     onClick={onClick}
      className="flex items-center gap-2 rounded-lg bg-blue-600 px-5 py-3 text-white shadow-sm hover:bg-blue-700"
    >
      <Plus size={18} />
      <span>Add Clinic</span>
    </button>
  );
}
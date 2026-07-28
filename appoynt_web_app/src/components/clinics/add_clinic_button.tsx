import { Plus } from "lucide-react";

type AddClinicButtonProps = {
  onClick: () => void;
};

export default function AddClinicButton({ onClick }: AddClinicButtonProps) {
  return (
    <button
      onClick={onClick}
      className="
        inline-flex
        items-center
        justify-center
        gap-2
        rounded-lg
        bg-app-primary
        px-5
        py-3
        text-sm
        font-medium
        text-white
        shadow-sm
        transition-all
        hover:opacity-90
        focus:outline-none
        focus:ring-2
        focus:ring-app-primary
        focus:ring-offset-2
      "
    >
      <Plus size={18} />
      <span>Add Clinic</span>
    </button>
  );
}

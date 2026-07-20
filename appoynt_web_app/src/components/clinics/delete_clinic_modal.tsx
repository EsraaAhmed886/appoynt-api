import { TriangleAlert } from "lucide-react";

type DeleteClinicModalProps = {
  isOpen: boolean;
  onClose: () => void;
  onDelete: () => void;
};

export default function DeleteClinicModal({
  isOpen,
  onClose,
  onDelete,
}: DeleteClinicModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 px-4">
      <div className="w-full max-w-md rounded-2xl bg-app-surface p-8 shadow-xl border border-app-border">
        <div className="mb-5 flex justify-center">
          <div className="flex h-16 w-16 items-center justify-center rounded-full bg-red-100 dark:bg-red-900/30">
            <TriangleAlert className="h-8 w-8 text-red-600 dark:text-red-400" />
          </div>
        </div>

        <h2 className="text-center text-2xl font-bold text-app-primary">
          Delete Clinic
        </h2>

        <p className="mt-4 text-center text-app-text-secondary">
          Are you sure you want to delete this clinic?
        </p>

        <div className="mt-8 flex justify-center gap-4">
          <button
            onClick={onDelete}
            className="
              rounded-lg
              bg-app-primary
              px-8
              py-2
              font-medium
              text-white
              transition
              hover:opacity-90
            "
          >
            Delete
          </button>

          <button
            onClick={onClose}
            className="
              rounded-lg
              border
              border-app-primary
              bg-transparent
              px-8
              py-2
              font-medium
              text-app-primary
              transition
              hover:bg-app-input_fill
            "
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
}
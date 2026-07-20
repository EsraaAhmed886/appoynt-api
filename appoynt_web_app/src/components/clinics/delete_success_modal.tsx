type DeleteSuccessModalProps = {
  isOpen: boolean;
  onClose: () => void;
};

export default function DeleteSuccessModal({
  isOpen,
  onClose,
}: DeleteSuccessModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[70] flex items-center justify-center bg-black/50 px-4">
      <div className="w-full max-w-sm rounded-2xl border border-app-border bg-app-surface p-8 shadow-xl">
        <h2 className="text-center text-xl font-bold text-app-primary">
          Clinic Deleted Successfully
        </h2>

        <p className="mt-5 text-center text-lg font-semibold text-app-text-primary">
          The clinic has been deleted successfully.
        </p>

        <div className="mt-8 flex justify-center">
          <button
            onClick={onClose}
            className="
              rounded-lg
              bg-app-primary
              px-10
              py-2
              font-medium
              text-white
              transition
              hover:opacity-90
            "
          >
            OK
          </button>
        </div>
      </div>
    </div>
  );
}
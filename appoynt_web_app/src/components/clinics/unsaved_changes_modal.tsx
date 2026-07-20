type UnsavedChangesModalProps = {
  isOpen: boolean;
  onStay: () => void;
  onLeave: () => void;
};

export default function UnsavedChangesModal({
  isOpen,
  onStay,
  onLeave,
}: UnsavedChangesModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-sm px-4">
      <div className="w-full max-w-md rounded-2xl border border-app-border bg-app-surface px-8 py-10 shadow-2xl">
        <h2 className="text-center text-4xl font-bold text-app-primary">
          Unsaved Changes
        </h2>

        <p className="mt-6 text-center text-lg font-semibold leading-7 text-app-text-primary">
          You have unsaved changes.
          <br />
          Are you sure you want to leave?
        </p>

        <div className="mt-10 flex items-center justify-center gap-4">
          <button
            onClick={onStay}
            className="
              min-w-[110px]
              rounded-lg
              bg-app-primary
              px-8
              py-3
              text-sm
              font-medium
              text-white
              transition
              hover:opacity-90
            "
          >
            Stay
          </button>

          <button
            onClick={onLeave}
            className="
              min-w-[110px]
              rounded-lg
              border
              border-app-primary
              bg-transparent
              px-8
              py-3
              text-sm
              font-medium
              text-app-primary
              transition
              hover:bg-app-input_fill
            "
          >
            Leave
          </button>
        </div>
      </div>
    </div>
  );
}
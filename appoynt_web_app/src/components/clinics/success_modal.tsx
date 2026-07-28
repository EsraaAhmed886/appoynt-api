import { CircleCheck } from "lucide-react";

type SuccessModalProps = {
  isOpen: boolean;
  onClose: () => void;
};

export default function SuccessModal({ isOpen, onClose }: SuccessModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/20 px-4">
      <div className="w-full max-w-[400px] rounded-2xl border border-app-border bg-app-surface px-8 py-10 shadow-2xl">
        <div className="mb-6 flex justify-center">
          <div className="flex h-16 w-16 items-center justify-center rounded-full bg-green-100 dark:bg-green-900/30">
            <CircleCheck className="h-8 w-8 text-green-600 dark:text-green-400" />
          </div>
        </div>

        <h2 className="text-center text-2xl font-bold text-app-primary">
          Clinic Added Successfully
        </h2>

        <p className="mt-4 text-center text-lg font-bold leading-7 text-app-text-primary">
          The clinic has been added successfully.
        </p>

        <div className="mt-8 flex justify-center">
          <button
            onClick={onClose}
            className="
              h-11
              w-28
              rounded-lg
              bg-app-primary
              text-base
              font-semibold
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

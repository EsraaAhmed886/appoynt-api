import { ChevronLeft, ChevronRight } from "lucide-react";

type PaginationProps = {
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
};

export default function Pagination({
  currentPage,
  totalPages,
  onPageChange,
}: PaginationProps) {
  return (
    <div className="mt-6 flex items-center justify-center gap-3">
      {/* Previous */}
      <button
        type="button"
        disabled={currentPage === 1}
        onClick={() => onPageChange(currentPage - 1)}
        className="
          flex h-8 w-8 items-center justify-center
          rounded-full
          bg-gray-100
          text-gray-500
          transition
          hover:bg-gray-200
          dark:bg-slate-700
          dark:text-gray-300
          dark:hover:bg-slate-600
          disabled:cursor-not-allowed
          disabled:opacity-50
        "
      >
        <ChevronLeft size={16} />
      </button>

      {/* Current Page */}
      <div
        className="
          flex h-8 w-8 items-center justify-center
          rounded-full
          bg-blue-600
          text-sm
          font-semibold
          text-white
        "
      >
        {currentPage}
      </div>

      {/* Next */}
      <button
        type="button"
        disabled={currentPage === totalPages}
        onClick={() => onPageChange(currentPage + 1)}
        className="
          flex h-8 w-8 items-center justify-center
          rounded-full
          bg-gray-100
          text-gray-500
          transition
          hover:bg-gray-200
          dark:bg-slate-700
          dark:text-gray-300
          dark:hover:bg-slate-600
          disabled:cursor-not-allowed
          disabled:opacity-50
        "
      >
        <ChevronRight size={16} />
      </button>
    </div>
  );
}
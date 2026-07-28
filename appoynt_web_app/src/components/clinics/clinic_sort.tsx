"use client";

import { useRef, useState } from "react";
import useClickOutside from "@/hooks/use_click_outside";
import { ChevronDown } from "lucide-react";

type ClinicSortProps = {
  sortOrder: string;
  onSortChange: (value: string) => void;
};

const options = [
  { label: "A → Z", value: "asc" },
  { label: "Z → A", value: "desc" },
  { label: "Newest", value: "newest" },
  { label: "Oldest", value: "oldest" },
];

export default function ClinicSort({
  sortOrder,
  onSortChange,
}: ClinicSortProps) {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useClickOutside(dropdownRef, () => {
    setIsOpen(false);
  });

  const selected =
    options.find((item) => item.value === sortOrder)?.label || "Sort By";

  return (
    <div ref={dropdownRef} className="relative w-[140px]">
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        className="
          flex
          h-11
          w-full
          items-center
          justify-between
          rounded-lg
          border
          border-app-border
          bg-app-surface
          px-4
          text-sm
          font-medium
          text-app-text-primary
          shadow-sm
          transition
          hover:border-app-primary
          focus:ring-2
          focus:ring-app-primary/20
        "
      >
        <span>{selected}</span>

        <ChevronDown
          size={18}
          className={`transition-transform duration-200 ${
            isOpen ? "rotate-180" : ""
          }`}
        />
      </button>

      <div
        className={`
          absolute
          left-0
          top-full
          z-[100]
          mt-2
          w-full
          origin-top
          overflow-hidden
          rounded-lg
          border
          border-app-border
          bg-app-surface
          shadow-lg
          transition-all
          duration-200
          ${
            isOpen
              ? "visible scale-100 opacity-100"
              : "invisible scale-95 opacity-0"
          }
        `}
      >
        {options.map((option) => (
          <button
            key={option.value}
            type="button"
            onClick={() => {
              onSortChange(option.value);
              setIsOpen(false);
            }}
            className={`
              block
              w-full
              px-4
              py-3
              text-left
              transition
              ${
                sortOrder === option.value
                  ? "bg-app-primary text-white font-medium"
                  : "text-app-text-primary hover:bg-app-input_fill"
              }
            `}
          >
            {option.label}
          </button>
        ))}
      </div>
    </div>
  );
}

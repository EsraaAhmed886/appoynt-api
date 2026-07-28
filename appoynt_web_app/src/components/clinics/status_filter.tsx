"use client";

import { useRef, useState } from "react";
import { ChevronDown } from "lucide-react";
import useClickOutside from "@/hooks/use_click_outside";

type StatusFilterProps = {
  value: string;
  onChange: (value: string) => void;
};

const STATUS_OPTIONS = ["All", "Active", "Inactive"];

export default function StatusFilter({ value, onChange }: StatusFilterProps) {
  const [isOpen, setIsOpen] = useState(false);

  const dropdownRef = useRef<HTMLDivElement>(null);

  useClickOutside(dropdownRef, () => {
    setIsOpen(false);
  });

  return (
    <div ref={dropdownRef} className="relative w-[140px] shrink-0">
      <button
        type="button"
        aria-haspopup="listbox"
        aria-expanded={isOpen}
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
          focus-visible:ring-2
          focus-visible:ring-app-primary/20
        "
      >
        <span>{value}</span>

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
    z-50
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
    ${isOpen ? "visible scale-100 opacity-100" : "invisible scale-95 opacity-0"}
  `}
      >
        {STATUS_OPTIONS.map((status) => (
          <button
            key={status}
            type="button"
            onClick={() => {
              onChange(status);
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
                value === status
                  ? "bg-app-primary text-white font-medium"
                  : "text-app-text-primary hover:bg-app-input_fill"
              }
            `}
          >
            {status}
          </button>
        ))}
      </div>
    </div>
  );
}

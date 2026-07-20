import { useRef, useState } from "react";
import useClickOutside from "@/hooks/use_click_outside";
import { ChevronDown } from "lucide-react";

type CustomSelectProps = {
  label: string;
  placeholder: string;
  value: string;
  error: string;
  options: string[];
  onChange: (value: string) => void;
  disabled?: boolean;
};

export default function CustomSelect({
  label,
  placeholder,
  value,
  error,
  options,
  onChange,
  disabled = false,
}: CustomSelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useClickOutside(dropdownRef, () => {
    setIsOpen(false);
  });

  return (
    <div ref={dropdownRef} className="flex flex-col">
      <label className="mb-2 text-sm font-semibold text-app-text-primary md:text-base">
        {label} <span className="text-red-500">*</span>
      </label>

      <div className="relative">
        <button
          type="button"
          disabled={disabled}
          onClick={() => {
            if (!disabled) {
              setIsOpen(!isOpen);
            }
          }}
          className={`
            flex
            w-full
            items-center
            justify-between
            gap-2
            rounded-lg
            border
            bg-app-input_fill
            px-4
            py-2.5
            text-left
            text-sm
            transition-all
            duration-200
            md:text-base
            ${
              error
                ? "border-red-500 ring-2 ring-red-200"
                : "border-app-border focus:border-app-primary focus:ring-2 focus:ring-app-primary/20"
            }
            ${value ? "text-app-text-primary" : "text-app-text-secondary"}
            ${
              disabled
                ? "cursor-not-allowed opacity-60"
                : ""
            }
          `}
        >
          <span>{value || placeholder}</span>

          <ChevronDown
            size={18}
            className={`
              shrink-0
              text-app-text-secondary
              transition-all
              duration-200
              ${isOpen ? "rotate-180 text-app-primary" : ""}
            `}
          />
        </button>

        <div
          className={`
            absolute
            left-0
            right-0
            z-50
            mt-2
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
              key={option}
              type="button"
              onClick={() => {
                onChange(option);
                setIsOpen(false);
              }}
              className="
                block
                w-full
                px-4
                py-3
                text-left
                text-app-text-primary
                transition-colors
                duration-150
                hover:bg-app-input_fill
                hover:text-app-primary
              "
            >
              {option}
            </button>
          ))}
        </div>
      </div>

      {error ? (
        <p className="mt-1 text-sm text-red-500">{error}</p>
      ) : null}
    </div>
  );
}
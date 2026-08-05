/*
 * File Name: custom_select.tsx
 * Author: shimaa salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/hooks/use_click_outside
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Customized responsive select dropdown input with smooth open transitions and RTL support.
 */

"use client";

import { useRef, useState } from "react";
import useClickOutside from "@/hooks/use_click_outside";
import { ChevronDown } from "lucide-react";

type CustomSelectProps = {
  label: string;
  placeholder: string;
  value: string;
  error?: string;
  options: string[];
  on_change: (value: string) => void;
  disabled?: boolean;
};

export default function CustomSelect({
  label,
  placeholder,
  value,
  error = "",
  options,
  on_change,
  disabled = false,
}: CustomSelectProps) {
  const [is_open, set_is_open] = useState(false);
  const dropdown_ref = useRef<HTMLDivElement>(null);

  useClickOutside(dropdown_ref, () => {
    set_is_open(false);
  });

  const has_error = "" !== error;

  return (
    <div ref={dropdown_ref} className="flex flex-col w-full">
      <label className="mb-2 text-sm font-semibold text-app-text-primary md:text-base">
        {label} <span className="text-red-500">*</span>
      </label>

      <div className="relative w-full">
        <button
          type="button"
          disabled={disabled}
          onClick={() => {
            if (!disabled) {
              set_is_open(!is_open);
            } else {
              // Disabled click ignored
            }
          }}
          className={`
            flex
            w-full
            items-center
            justify-between
            gap-2
            rounded-xl
            border
            bg-app-input_fill
            px-4
            py-2.5
            text-start
            text-sm
            transition-all
            duration-200
            md:text-base
            ${
              has_error
                ? "border-red-500 ring-2 ring-red-200"
                : "border-app-border focus:border-app-primary focus:ring-2 focus:ring-app-primary/20"
            }
            ${value ? "text-app-text-primary font-medium" : "text-app-text-secondary"}
            ${disabled ? "cursor-not-allowed opacity-60 bg-app-surface" : "hover:border-app-primary/50"}
          `}
        >
          <span className="truncate">{value || placeholder}</span>

          <ChevronDown
            size={18}
            className={`
              shrink-0
              text-app-text-secondary
              transition-transform
              duration-200
              ${is_open ? "rotate-180 text-app-primary" : ""}
            `}
          />
        </button>

        <div
          className={`
            absolute
            left-0
            right-0
            z-50
            mt-1.5
            max-h-60
            origin-top
            overflow-y-auto
            rounded-xl
            border
            border-app-border
            bg-app-surface
            p-1
            shadow-xl
            transition-all
            duration-200
            ${
              is_open
                ? "visible scale-100 opacity-100"
                : "invisible scale-95 opacity-0 pointer-events-none"
            }
          `}
        >
          {options.map((option) => {
            const is_selected = option === value;

            return (
              <button
                key={option}
                type="button"
                onClick={() => {
                  on_change(option);
                  set_is_open(false);
                }}
                className={`
                  block
                  w-full
                  rounded-lg
                  px-3.5
                  py-2.5
                  text-start
                  text-sm
                  transition-colors
                  duration-150
                  ${
                    is_selected
                      ? "bg-app-primary/10 font-semibold text-app-primary"
                      : "text-app-text-primary hover:bg-app-input_fill hover:text-app-primary"
                  }
                `}
              >
                {option}
              </button>
            );
          })}
        </div>
      </div>

      {has_error ? (
        <p className="mt-1 text-xs font-medium text-red-500">{error}</p>
      ) : null}
    </div>
  );
}
/*
 * File Name: dashboard_dropdown.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [shimaa salah - 26/08/2026]
 * File Description: Accessible, responsive custom select dropdown component with floating popover, click-outside dismissal, and bidirectional RTL support.
 */

"use client";

import React, { useState, useRef, useEffect } from "react";
import { ChevronDown, Check } from "lucide-react";

export interface DropdownOption {
  value: string;
  label: string;
  icon?: React.ReactNode;
}

interface DashboardDropdownProps {
  options: DropdownOption[];
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
  width?: string;
}

export const DashboardDropdown: React.FC<DashboardDropdownProps> = ({
  options,
  value,
  onChange,
  placeholder = "Select option...",
  className = "",
  width = "w-48 sm:w-56",
}) => {
  const [is_open, set_is_open] = useState(false);
  const dropdown_ref = useRef<HTMLDivElement>(null);

  const selected_option = options.find((opt) => opt.value === value);

  // Close dropdown on outside click
  useEffect(() => {
    const handle_click_outside = (event: MouseEvent) => {
      if (dropdown_ref.current && !dropdown_ref.current.contains(event.target as Node)) {
        set_is_open(false);
      } else {
        // Click was inside dropdown
      }
    };
    document.addEventListener("mousedown", handle_click_outside);
    return () => document.removeEventListener("mousedown", handle_click_outside);
  }, []);

  return (
    <div ref={dropdown_ref} className={`relative inline-block text-start ${className}`}>
      {/* Trigger Button */}
      <button
        type="button"
        aria-expanded={is_open}
        onClick={() => set_is_open(!is_open)}
        className={`flex items-center justify-between gap-2 px-3.5 py-2 text-xs sm:text-sm font-medium rounded-xl border transition-all duration-150 cursor-pointer ${width} ${
          is_open
            ? "border-blue-600 ring-2 ring-blue-500/10 bg-white dark:bg-gray-900 text-gray-900 dark:text-white"
            : "border-gray-200 dark:border-gray-700/80 bg-gray-50/60 dark:bg-gray-800/60 text-gray-700 dark:text-gray-200 hover:bg-white dark:hover:bg-gray-800 hover:border-gray-300 dark:hover:border-gray-600"
        }`}
      >
        <span className="truncate">{selected_option ? selected_option.label : placeholder}</span>
        <ChevronDown
          className={`w-4 h-4 transition-transform duration-200 shrink-0 ${
            is_open ? "rotate-180 text-blue-600" : "text-gray-400"
          }`}
        />
      </button>

      {/* Floating Menu Popover */}
      {is_open ? (
        <div
          className={`absolute end-0 z-50 mt-1.5 ${width} rounded-xl border border-gray-100 dark:border-gray-800 bg-white dark:bg-gray-900 p-1.5 shadow-xl shadow-gray-200/50 dark:shadow-gray-950/60 ring-1 ring-black/5 animate-in fade-in zoom-in-95 duration-100`}
        >
          {/* Scrollable list up to 50 clinics with custom scrollbar */}
          <div className="max-h-60 overflow-y-auto space-y-0.5 scrollbar-thin">
            {options.map((option) => {
              const is_selected = option.value === value;
              return (
                <button
                  key={option.value}
                  type="button"
                  onClick={() => {
                    onChange(option.value);
                    set_is_open(false);
                  }}
                  className={`w-full flex items-center justify-between px-3 py-2 text-xs sm:text-sm rounded-lg transition-colors text-start cursor-pointer ${
                    is_selected
                      ? "bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400 font-semibold"
                      : "text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800/70"
                  }`}
                >
                  <span className="truncate">{option.label}</span>
                  {is_selected ? (
                    <Check className="w-4 h-4 text-blue-600 dark:text-blue-400 shrink-0 ms-2" />
                  ) : null}
                </button>
              );
            })}
          </div>
        </div>
      ) : null}
    </div>
  );
};

export default DashboardDropdown;

/*
 * File Name: custom_select_dropdown.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/hooks/use_click_outside
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Highly polished custom searchable select dropdown with trailing SVG chevron, blue checkmark active item indicator, keyword search filtering, and bottom action link triggers.
 */

"use client";

import React, { useState, useRef, useMemo, useId } from "react";
import { ChevronDown, Check, Search, Plus, LucideIcon } from "lucide-react";
import useClickOutside from "@/hooks/use_click_outside";

export interface DropdownOption {
  value: string;
  label: string;
  subLabel?: string;
  icon?: LucideIcon;
}

export interface CustomSelectDropdownProps {
  label?: string;
  required?: boolean;
  options: DropdownOption[];
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  searchPlaceholder?: string;
  error?: string;
  helperText?: string;
  disabled?: boolean;
  searchable?: boolean;
  bottomActionText?: string;
  onBottomAction?: () => void;
  icon?: LucideIcon;
  className?: string;
}

export default function CustomSelectDropdown({
  label,
  required = false,
  options,
  value,
  onChange,
  placeholder = "Select an option...",
  searchPlaceholder = "Search...",
  error,
  helperText,
  disabled = false,
  searchable = true,
  bottomActionText,
  onBottomAction,
  icon: Icon,
  className = "",
}: CustomSelectDropdownProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const dropdownRef = useRef<HTMLDivElement>(null);
  const dropdownId = useId();

  useClickOutside(dropdownRef, () => setIsOpen(false));

  const selectedOption = useMemo(
    () => options.find((opt) => opt.value === value),
    [options, value]
  );

  const filteredOptions = useMemo(() => {
    if (!searchQuery.trim()) return options;
    const query = searchQuery.toLowerCase();
    return options.filter(
      (opt) =>
        opt.label.toLowerCase().includes(query) ||
        (opt.subLabel && opt.subLabel.toLowerCase().includes(query)) ||
        opt.value.toLowerCase().includes(query)
    );
  }, [options, searchQuery]);

  const handleSelect = (val: string) => {
    onChange(val);
    setIsOpen(false);
    setSearchQuery("");
  };

  return (
    <div ref={dropdownRef} className={`relative space-y-1.5 text-start ${className}`}>
      {label && (
        <label
          htmlFor={dropdownId}
          className="block text-xs font-semibold text-slate-700 dark:text-slate-300"
        >
          {label}
          {required && <span className="text-rose-500 ms-0.5">*</span>}
        </label>
      )}

      {/* Trigger Button */}
      <button
        id={dropdownId}
        type="button"
        disabled={disabled}
        onClick={() => !disabled && setIsOpen(!isOpen)}
        aria-haspopup="listbox"
        aria-expanded={isOpen}
        className={`
          w-full flex items-center justify-between
          bg-slate-50 dark:bg-[#131E35]
          border-2
          ${
            error
              ? "border-rose-500 focus:ring-rose-500/20"
              : isOpen
              ? "border-blue-600 dark:border-blue-500 ring-2 ring-blue-500/20"
              : "border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600"
          }
          rounded-xl px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium
          text-slate-800 dark:text-slate-100 shadow-2xs
          transition-all cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed
        `}
      >
        <div className="flex items-center gap-2.5 min-w-0">
          {Icon && <Icon className="w-4 h-4 text-slate-400 dark:text-slate-500 shrink-0" />}
          {selectedOption ? (
            <span className="truncate font-semibold text-slate-900 dark:text-white">
              {selectedOption.label}
            </span>
          ) : (
            <span className="text-slate-400 dark:text-slate-500 truncate">
              {placeholder}
            </span>
          )}
        </div>
        <ChevronDown
          className={`w-4 h-4 text-slate-400 dark:text-slate-500 shrink-0 transition-transform duration-200 ${
            isOpen ? "rotate-180 text-blue-600 dark:text-blue-400" : ""
          }`}
        />
      </button>

      {/* Dropdown Menu Overlay */}
      {isOpen && (
        <div
          role="listbox"
          className="absolute z-50 start-0 top-full mt-1.5 w-full bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-700 rounded-xl shadow-xl overflow-hidden animate-in fade-in zoom-in-95 duration-150"
        >
          {/* Search Bar */}
          {searchable && (
            <div className="p-2 border-b border-slate-100 dark:border-slate-800">
              <div className="relative">
                <Search className="absolute start-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-slate-400" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder={searchPlaceholder}
                  className="w-full bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-lg ps-8 pe-3 py-1.5 text-xs text-slate-800 dark:text-slate-100 placeholder-slate-400 focus:outline-none focus:border-blue-500"
                  autoFocus
                />
              </div>
            </div>
          )}

          {/* Options List */}
          <div className="max-h-56 overflow-y-auto p-1 space-y-0.5">
            {filteredOptions.length > 0 ? (
              filteredOptions.map((opt) => {
                const isSelected = opt.value === value;
                return (
                  <button
                    key={opt.value}
                    type="button"
                    role="option"
                    aria-selected={isSelected}
                    onClick={() => handleSelect(opt.value)}
                    className={`
                      w-full flex items-center justify-between px-3 py-2 rounded-lg text-xs md:text-sm text-start transition cursor-pointer
                      ${
                        isSelected
                          ? "bg-blue-50 dark:bg-blue-950/60 text-blue-700 dark:text-blue-300 font-bold"
                          : "text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-[#131E35]"
                      }
                    `}
                  >
                    <div className="min-w-0 pe-2">
                      <p className="truncate">{opt.label}</p>
                      {opt.subLabel && (
                        <p className="text-[11px] text-slate-400 dark:text-slate-500 truncate">
                          {opt.subLabel}
                        </p>
                      )}
                    </div>
                    {isSelected && (
                      <Check className="w-4 h-4 text-blue-600 dark:text-blue-400 shrink-0" />
                    )}
                  </button>
                );
              })
            ) : (
              <div className="px-3 py-4 text-center text-xs text-slate-400 dark:text-slate-500">
                No matching options found
              </div>
            )}
          </div>

          {/* Bottom Action Trigger Link */}
          {bottomActionText && onBottomAction && (
            <div className="p-2 border-t border-slate-100 dark:border-slate-800 bg-slate-50/70 dark:bg-[#131E35]/50">
              <button
                type="button"
                onClick={() => {
                  setIsOpen(false);
                  onBottomAction();
                }}
                className="w-full flex items-center justify-center gap-1.5 py-1.5 px-2 text-xs font-bold text-blue-600 dark:text-blue-400 hover:bg-blue-50 dark:hover:bg-blue-950/50 rounded-lg transition cursor-pointer"
              >
                <Plus className="w-3.5 h-3.5" />
                <span>{bottomActionText}</span>
              </button>
            </div>
          )}
        </div>
      )}

      {error ? (
        <p className="text-xs text-rose-500 font-medium">{error}</p>
      ) : helperText ? (
        <p className="text-[11px] text-slate-500 dark:text-slate-400">{helperText}</p>
      ) : null}
    </div>
  );
}

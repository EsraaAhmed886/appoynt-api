/*
 * File Name: custom_select_dropdown.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/hooks/use_click_outside
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Highly polished custom searchable select dropdown with clinical status indicator dots, trailing SVG chevron, blue checkmark active item indicator, keyword search filtering, and bottom action link triggers.
 */

"use client";

import React, { useState, useRef, useMemo, useId } from "react";
import { ChevronDown, Check, Search, Plus, LucideIcon } from "lucide-react";
import useClickOutside from "@/hooks/use_click_outside";
import { useTranslation } from "@/context/language_context";

export interface DropdownOption {
  value: string;
  label: string;
  subLabel?: string;
  dotColor?: string;
  badge?: string;
}

export interface CustomSelectDropdownProps {
  label?: string;
  placeholder?: string;
  searchPlaceholder?: string;
  options: DropdownOption[];
  value?: string;
  onChange: (value: string) => void;
  required?: boolean;
  disabled?: boolean;
  searchable?: boolean;
  error?: string;
  helperText?: string;
  icon?: LucideIcon;
  bottomActionText?: string;
  onBottomAction?: () => void;
  className?: string;
  triggerClassName?: string;
  menuClassName?: string;
}

export default function CustomSelectDropdown({
  label,
  placeholder,
  searchPlaceholder,
  options,
  value,
  onChange,
  required = false,
  disabled = false,
  searchable = true,
  error,
  helperText,
  icon: Icon,
  bottomActionText,
  onBottomAction,
  className = "",
  triggerClassName = "",
  menuClassName = "",
}: CustomSelectDropdownProps) {
  const { translations } = useTranslation();
  const defaultPlaceholder = placeholder || translations.select_option || "Select an option...";
  const defaultSearchPlaceholder = searchPlaceholder || translations.search || "Search...";

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
    if (!searchQuery.trim()) {
      return options;
    } else {
      // Filter options by search query
    }
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
    <div ref={dropdownRef} className={`flex flex-col gap-1.5 text-start w-full ${className}`}>
      {label && (
        <label
          htmlFor={dropdownId}
          className="block text-xs font-semibold text-slate-700 dark:text-slate-300"
        >
          {label}
          {required && <span className="text-rose-500 ms-0.5">*</span>}
        </label>
      )}

      {/* Dedicated Relative Anchor ONLY for button + listbox (NO space-y) */}
      <div className="relative w-full">
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
            border
            ${
              error
                ? "border-rose-500"
                : isOpen
                ? "border-blue-600 dark:border-blue-500"
                : "border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600"
            }
            rounded-xl shadow-2xs outline-none focus:outline-none
            text-slate-800 dark:text-slate-100
            cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed !transition-none
            ${triggerClassName || "px-3.5 py-2.5 h-11 text-xs md:text-sm font-medium"}
          `}
        >
          <div className="flex items-center gap-2 min-w-0">
            {Icon && <Icon className="w-4 h-4 text-slate-400 dark:text-slate-500 shrink-0" />}
            {selectedOption?.dotColor && (
              <span className={`w-2 h-2 rounded-full ${selectedOption.dotColor} shrink-0`} />
            )}
            {selectedOption ? (
              <span className="truncate font-semibold text-slate-900 dark:text-white">
                {selectedOption.label}
              </span>
            ) : (
              <span className="text-slate-400 dark:text-slate-500 truncate">
                {defaultPlaceholder}
              </span>
            )}
          </div>
          <ChevronDown
            className={`w-3.5 h-3.5 text-slate-400 dark:text-slate-500 shrink-0 transition-transform duration-150 ${
              isOpen ? "rotate-180 text-blue-600 dark:text-blue-400" : ""
            }`}
          />
        </button>

        {/* Dropdown Menu Overlay */}
        {isOpen && (
          <div
            role="listbox"
            style={{
              marginTop: "0px",
              animation: "none",
              transition: "none",
              transform: "none",
              contain: "paint layout",
            }}
            className={`!transition-none !transform-none !animate-none !m-0 !p-0 absolute top-[calc(100%+4px)] start-0 end-0 z-50 bg-white dark:bg-[#131E35] border border-slate-200 dark:border-slate-700/80 rounded-xl shadow-lg max-h-56 overflow-hidden flex flex-col ${menuClassName}`}
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
                    placeholder={defaultSearchPlaceholder}
                    className="w-full bg-slate-50 dark:bg-[#131E35] border border-slate-200 dark:border-slate-700 rounded-lg ps-8 pe-3 py-1.5 text-xs text-slate-800 dark:text-slate-100 placeholder-slate-400 focus:outline-none focus:border-blue-500"
                  />
                </div>
              </div>
            )}

            {/* Options List */}
            <div className="max-h-56 overflow-y-auto p-1 space-y-0.5 !transition-none">
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
                      <div className="min-w-0 pe-2 flex items-center gap-2">
                        {opt.dotColor && (
                          <span className={`w-2 h-2 rounded-full ${opt.dotColor} shrink-0`} />
                        )}
                        <div>
                          <p className="truncate">{opt.label}</p>
                          {opt.subLabel && (
                            <p className="text-[11px] text-slate-400 dark:text-slate-500 truncate">
                              {opt.subLabel}
                            </p>
                          )}
                        </div>
                      </div>
                      {isSelected && (
                        <Check className="w-4 h-4 text-blue-600 dark:text-blue-400 shrink-0" />
                      )}
                    </button>
                  );
                })
              ) : (
                <div className="px-3 py-4 text-center text-xs text-slate-400 dark:text-slate-500">
                  {translations.no_matching_options || "No matching options found"}
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
      </div>

      {error ? (
        <p className="text-xs text-rose-500 font-medium">{error}</p>
      ) : helperText ? (
        <p className="text-[11px] text-slate-500 dark:text-slate-400">{helperText}</p>
      ) : null}
    </div>
  );
}

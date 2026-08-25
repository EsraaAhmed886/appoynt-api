/*
 * File Name: custom_select.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Reusable Custom Select component providing polished OS-independent dropdown styling with custom Lucide ChevronDown, RTL alignment support, and accessible form integration.
 */

"use client";

import React, { forwardRef, SelectHTMLAttributes, useId } from "react";
import { ChevronDown, LucideIcon } from "lucide-react";

export interface CustomSelectProps
  extends SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  required?: boolean;
  error?: string;
  helperText?: string;
  icon?: LucideIcon;
  containerClassName?: string;
  selectClassName?: string;
}

export const CustomSelect = forwardRef<HTMLSelectElement, CustomSelectProps>(
  (
    {
      label,
      required = false,
      error,
      helperText,
      icon: Icon,
      containerClassName = "",
      selectClassName = "",
      id,
      children,
      disabled,
      ...rest
    },
    ref
  ) => {
    const generatedId = useId();
    const selectId = id || generatedId;

    return (
      <div className={`space-y-1.5 text-start ${containerClassName}`}>
        {label && (
          <label
            htmlFor={selectId}
            className="block text-xs font-semibold text-slate-700 dark:text-slate-300"
          >
            {label}
            {required && <span className="text-red-500 ms-0.5">*</span>}
          </label>
        )}

        <div className="relative">
          {Icon && (
            <div className="absolute start-3.5 top-1/2 -translate-y-1/2 pointer-events-none text-slate-400 dark:text-slate-500">
              <Icon className="w-4 h-4" />
            </div>
          )}

          <select
            ref={ref}
            id={selectId}
            disabled={disabled}
            className={`
              w-full
              appearance-none
              bg-slate-50 dark:bg-[#131E35]
              border
              ${
                error
                  ? "border-red-500 dark:border-red-500 focus:ring-red-500/20 focus:border-red-500"
                  : "border-slate-200 dark:border-slate-700 hover:border-slate-300 dark:hover:border-slate-600 focus:ring-blue-500/20 focus:border-blue-500"
              }
              rounded-xl
              px-4
              py-2.5
              h-11
              pe-10
              rtl:ps-4
              rtl:pe-10
              ${Icon ? "ps-10 rtl:ps-4 rtl:pe-10" : ""}
              text-sm
              font-medium
              text-slate-800 dark:text-slate-100
              shadow-2xs
              focus:outline-none
              focus:ring-2
              transition-all
              cursor-pointer
              disabled:opacity-50
              disabled:cursor-not-allowed
              ${selectClassName}
            `}
            {...rest}
          >
            {children}
          </select>

          <ChevronDown className="absolute end-3.5 top-1/2 -translate-y-1/2 pointer-events-none text-slate-400 dark:text-slate-500 w-4 h-4 rtl:left-3.5 rtl:right-auto shrink-0" />
        </div>

        {error ? (
          <p className="text-xs text-red-500">{error}</p>
        ) : helperText ? (
          <p className="text-[11px] text-slate-500 dark:text-slate-400">
            {helperText}
          </p>
        ) : null}
      </div>
    );
  }
);

CustomSelect.displayName = "CustomSelect";

export default CustomSelect;

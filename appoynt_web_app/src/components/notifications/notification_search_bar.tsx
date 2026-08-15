/*
 * File Name: notification_search_bar.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Reusable search bar input component for filtering notifications with dynamic clear button and input length restriction.
 */
import React from "react";
import { Search, X } from "lucide-react";

interface NotificationSearchBarProps {
  value: string;
  onChange: (value: string) => void;
  onClear?: () => void;
  placeholder?: string;
  maxLength?: number;
}

export default function NotificationSearchBar({
  value,
  onChange,
  onClear,
  placeholder = "Search notifications...",
  maxLength = 100,
}: NotificationSearchBarProps) {
  return (
    <div className="relative w-full md:w-80">
      <input
        type="text"
        value={value}
        maxLength={maxLength}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        aria-label="Search notifications"
        className="w-full pl-3.5 pr-10 py-2 text-sm rounded-xl border border-app-border bg-app-input-fill text-app-text-primary placeholder-app-text-secondary focus:outline-none focus:ring-2 focus:ring-app-primary/30 transition-all"
      />
      {value ? (
        <button
          type="button"
          onClick={() => {
            if (onClear) {
              onClear();
            } else {
              onChange("");
            }
          }}
          aria-label="Clear search"
          className="absolute right-3 top-2.5 text-app-text-secondary hover:text-app-text-primary transition-colors focus:outline-none"
        >
          <X className="w-4 h-4" />
        </button>
      ) : (
        <Search className="w-4 h-4 text-app-text-secondary absolute right-3 top-3 pointer-events-none" />
      )}
    </div>
  );
}

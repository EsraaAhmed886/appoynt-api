/*
 * File Name: language_toggle.tsx
 * Author: shimaa salah
 * Date of Creation: 29/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Language switcher button component toggling between English (LTR) and Arabic (RTL).
 */

"use client";

import { useTranslation } from "@/context/language_context";
import { Globe } from "lucide-react";

export default function LanguageToggle() {
  const { current_locale, change_locale } = useTranslation();
  const is_arabic = "ar" === current_locale;

  const toggle_language = () => {
    change_locale(is_arabic ? "en" : "ar");
  };

  return (
    <button
      type="button"
      onClick={toggle_language}
      aria-label="Toggle language"
      title={is_arabic ? "Switch to English" : "التحويل للغة العربية"}
      className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-xl border border-app-border bg-app-surface text-app-text-secondary hover:text-app-text-primary hover:bg-app-input_fill text-xs font-semibold transition-all focus:outline-none"
    >
      <Globe className="w-4 h-4 text-app-primary" />
      <span>{is_arabic ? "English" : "العربية"}</span>
    </button>
  );
}

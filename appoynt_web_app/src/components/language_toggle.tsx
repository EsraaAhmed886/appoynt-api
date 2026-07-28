"use client";

import { useTranslation } from "@/context/language_context";
import { Globe } from "lucide-react";

export default function LanguageToggle() {
  const { current_locale, change_locale } = useTranslation();
  const isArabic = current_locale === "ar";

  const toggleLanguage = () => {
    change_locale(isArabic ? "en" : "ar");
  };

  return (
    <button
      type="button"
      onClick={toggleLanguage}
      aria-label="Toggle language"
      title={isArabic ? "Switch to English" : "التحويل للغة العربية"}
      className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg border border-app-border bg-app-surface text-app-text-secondary hover:text-app-text-primary hover:bg-app-input-fill text-xs font-semibold transition-all focus:outline-none"
    >
      <Globe className="w-4 h-4 text-app-primary" />
      <span>{isArabic ? "English" : "العربية"}</span>
    </button>
  );
}

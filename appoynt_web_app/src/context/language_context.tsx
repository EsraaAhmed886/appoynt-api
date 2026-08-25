/*
 * File Name: language_context.tsx
 * Author: Kholoud Khaled
 * Created Date: 28/06/2026
 * Version: v1.2.0
 * Dependencies: react, @/constants/translations
 * Contributors: [Kholoud Khaled, shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Custom bilingual engine (EN/AR) using React Context with pre-paint locale initialization to prevent English flash.
 */

"use client";

import { createContext, useContext, useEffect, useState } from "react";
import { translation_en, translation_ar } from "@/constants/translations";

type LanguageContextType = {
  current_locale: "en" | "ar";
  translations: typeof translation_en;
  change_locale: (locale: "en" | "ar") => void;
  t: (key: keyof typeof translation_en) => string;
};

const language_react_context = createContext<LanguageContextType | undefined>(undefined);

export function LanguageProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  // Read stored locale synchronously on client initialization to eliminate English -> Arabic flash
  const [current_locale, set_current_locale] = useState<"en" | "ar">(() => {
    if ("undefined" !== typeof window) {
      try {
        const cached_language = localStorage.getItem("appoynt_locale");
        if ("ar" === cached_language) {
          return "ar";
        } else {
          return "en";
        }
      } catch (storage_error) {
        return "en";
      }
    } else {
      return "en";
    }
  });

  // Synchronize document direction, html lang, body font-family, and localStorage when current_locale changes
  useEffect(() => {
    try {
      localStorage.setItem("appoynt_locale", current_locale);
    } catch (storage_error) {
      console.warn("Local storage write blocked by browser settings:", storage_error);
    }

    if ("ar" === current_locale) {
      document.documentElement.dir = "rtl";
      document.documentElement.lang = "ar";
      document.body.style.fontFamily = "var(--font-cairo), sans-serif";
    } else {
      document.documentElement.dir = "ltr";
      document.documentElement.lang = "en";
      document.body.style.fontFamily = "var(--font-inter), sans-serif";
    }
  }, [current_locale]);

  const change_locale = (target_locale: "en" | "ar") => {
    set_current_locale(target_locale);
  };

  const active_dictionary = "ar" === current_locale ? translation_ar : translation_en;

  const t = (key: keyof typeof translation_en): string => {
    if (active_dictionary[key]) {
      return active_dictionary[key];
    } else if (translation_en[key]) {
      return translation_en[key];
    } else {
      return key;
    }
  };

  return (
    <language_react_context.Provider
      value={{
        current_locale,
        translations: active_dictionary,
        change_locale,
        t,
      }}
    >
      {children}
    </language_react_context.Provider>
  );
}

export function useTranslation() {
  const context_value = useContext(language_react_context);
  if (undefined === context_value) {
    throw new Error("useTranslation must be executed inside a LanguageProvider wrapper");
  } else {
    return context_value;
  }
}

/*
 * File Name: language_context.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Dependencies: react, @/constants/translations
 * Contributors: [Kholoud Khaled, shimaa salah]
 * Last Modified Date: [Kholoud Khaled - 05/08/2026]
 * File Description: Custom bilingual engine (EN/AR) using React Context with lazy locale state restoration to prevent page refresh flash.
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
  // Lazy state initialization to read cached locale synchronously before initial render
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
        console.warn("Local storage read blocked by browser settings:", storage_error);
        return "en";
      }
    } else {
      return "en";
    }
  });

  // Hook triggered on locale modification to update HTML direction and body typography
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
    return active_dictionary[key] || translation_en[key] || key;
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

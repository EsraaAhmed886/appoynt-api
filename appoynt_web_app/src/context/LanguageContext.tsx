"use client";

/*
 * File Name: LanguageContext.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/06/2026]
 * File Description: Custom bilingual engine (EN/AR) using React Context.
 */

// Importing createContext, useContext, useEffect, and useState hooks from react library
import { createContext, useContext, useEffect, useState } from "react";
// Importing English and Arabic dictionaries from translations constant file
import { translation_en, translation_ar } from "@/constants/translations";

// Defining type signature for the language context data interface structure
type LanguageContextType = {
  // Locale code representation string (either "en" or "ar")
  current_locale: "en" | "ar";
  // Active translation keys dictionary matching the active language
  translations: typeof translation_en;
  // Handler action function used to change system locale
  change_locale: (locale: "en" | "ar") => void;
};

// Instantiating the React context object block with undefined default value
const language_react_context = createContext<LanguageContextType | undefined>(undefined);

// Declaring and exporting the LanguageProvider context wrapper component function
export function LanguageProvider({
  // Destructuring child node elements parameters from props
  children,
}: {
  // Specifying type requirements for React child elements
  children: React.ReactNode;
}) {
  // Initializing state hook for the current system locale setting "en" as default
  const [current_locale, set_current_locale] = useState<"en" | "ar">("en");

  // Hook to handle initialization loading and synchronizing with localStorage
  useEffect(() => {
    // Opening try-catch block to gracefully handle local storage access blockages
    try {
      // Attempting to read language preference key from localStorage database
      const cached_language = localStorage.getItem("appoynt_locale");
      // Yoda check to see if cached preference value matches "ar" locale
      if ("ar" === cached_language) {
        // Adjusting state variable to match cached arabic preference
        set_current_locale("ar");
      } else {
        // Reverting to default English if no cached value is found
        set_current_locale("en");
      }
    } catch (storage_error) {
      // Logging warning message in console for debug checks
      console.warn("Local storage read blocked by browser security settings:", storage_error);
      // Falling back to English default
      set_current_locale("en");
    }
  }, []);

  // Hook triggered on locale state modification to update layout directions
  useEffect(() => {
    // Opening try-catch block for local storage writing operations
    try {
      // Saving the updated locale preference back to local storage cache
      localStorage.setItem("appoynt_locale", current_locale);
    } catch (storage_error) {
      // Logging write error warning in console
      console.warn("Local storage write blocked by browser security settings:", storage_error);
    }
    // Yoda style check for RTL alignment requirements of Arabic language
    if ("ar" === current_locale) {
      // Setting main HTML markup direction attribute to right-to-left
      document.documentElement.dir = "rtl";
      // Setting language code attribute value of HTML to Arabic representation
      document.documentElement.lang = "ar";
      // Applying dynamic styling classes for body tag to override layout fonts
      document.body.style.fontFamily = "var(--font-cairo), sans-serif";
    } else {
      // Setting main HTML markup direction attribute to left-to-right for LTR
      document.documentElement.dir = "ltr";
      // Setting language code attribute value of HTML to English representation
      document.documentElement.lang = "en";
      // Applying dynamic styling classes for body tag to override English font
      document.body.style.fontFamily = "var(--font-inter), sans-serif";
    }
  }, [current_locale]);

  // Method handler responsible for updates to active localization state
  const change_locale = (target_locale: "en" | "ar") => {
    // Triggering state updates with the selected language code
    set_current_locale(target_locale);
  };

  // Determining active dictionary object reference using Yoda comparison style
  const active_dictionary = "ar" === current_locale ? translation_ar : translation_en;

  // Render context provider wrapper wrapping React children hierarchy
  return (
    <language_react_context.Provider
      // Injecting active state properties down the provider stack
      value={{
        // Passing active locale state key
        current_locale,
        // Passing translation dictionary mapping
        translations: active_dictionary,
        // Passing language changer handler
        change_locale,
      }}
    >
      {/* Dynamic children layout render anchor */}
      {children}
    </language_react_context.Provider>
  );
}

// Declaring and exporting custom custom hook to consume translations easily
export function useTranslation() {
  // Fetching active context resource reference from react state engine
  const context_value = useContext(language_react_context);
  // Yoda comparison checking if hook is called outside provider
  if (undefined === context_value) {
    // Throwing error notification warning developers of incorrect context placement
    throw new Error("useTranslation must be executed inside a LanguageProvider wrapper");
  } else {
    // Safely returning validated translation context parameters to layout consumers
    return context_value;
  }
}

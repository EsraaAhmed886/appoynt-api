/*
 * File Name: tailwind.config.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/06/2026]
 * File Description: Defines design tokens, theme palettes, and font configurations for tailwind.
 */

// Importing Configuration type schema definitions from tailwind package
import type { Config } from "tailwindcss";

// Declaring tailwind_config configuration object block
const tailwind_config: Config = {
  // Specifying directory path templates to scan for CSS utility class injections
  content: [
    // Scanning source pages layouts
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    // Scanning source reusable layout elements
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    // Scanning modern app router folder contents
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  // Injecting custom styling parameters and values
  theme: {
    // Declaring extend block to merge custom styles into Tailwind defaults
    extend: {
      // Adding brand custom color variables linked to CSS parameters
      colors: {
        // App namespaces grouping design settings
        app: {
          // Dynamic primary color token mapping to brand blue
          primary: "var(--app-primary)",
          // Dynamic backdrop page background token mapping
          background: "var(--app-background)",
          // Dynamic container card backdrop token mapping
          surface: "var(--app-surface)",
          // Dynamic grid layout borders token mapping
          border: "var(--app-border)",
          // Nested grouping for layout typography text settings
          text: {
            // High contrast text labels configuration
            primary: "var(--app-text-primary)",
            // Low contrast secondary descriptive labels configuration
            secondary: "var(--app-text-secondary)",
          },
        },
      },
      // Registering Cairo and Inter font face mappings
      fontFamily: {
        // Cairo font setting for arabic content
        cairo: ["var(--font-cairo)", "sans-serif"],
        // Inter font setting for english content
        inter: ["var(--font-inter)", "sans-serif"],
      },
    },
  },
  // Active plugins list initialized empty
  plugins: [],
};

// Exporting tailwind configuration block for compiler use
export default tailwind_config;

/*
 * File Name: tailwind.config.ts
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: 1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/06/2026]
 * File Description: Tailwind CSS configurations for Appoynt Web App.
 */

// Importing Config type definitions from tailwindcss package
import type { Config } from "tailwindcss";

// Declaring tailwind_config object block configuration
const tailwind_config: Config = {
  // Specifying files directory pattern content for compiling utility classes
  content: [
    // Pages directory pattern matcher
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    // Components directory pattern matcher
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    // App directory pattern matcher
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  // Extending default theme configurations
  theme: {
    // Extend block of theme settings
    extend: {
      // Adding custom color properties mapping to CSS variables
      colors: {
        // Background color variable configuration
        background: "var(--background)",
        // Foreground color variable configuration
        foreground: "var(--foreground)",
      },
    },
  },
  // Declaring empty list for active tailwind plugins
  plugins: [],
};

// Exporting tailwind config block as default export module
export default tailwind_config;

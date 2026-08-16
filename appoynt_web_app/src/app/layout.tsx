/*
 * File Name: layout.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Dependencies: next, next/font/google, ./globals.css,
 *   @/context/language_context, @/store/store_provider
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: Defines the master Root Layout configuration for the Web application.
 */

// Importing Metadata specifications from next library package
import type { Metadata } from "next";
// Importing Google fonts loader hooks from next compiler assets
import { Inter, Cairo } from "next/font/google";
// Importing custom LanguageProvider context wrapper component function
import { LanguageProvider } from "@/context/language_context";
// Importing client state store provider wrapper container
import { StoreProvider } from "@/store/store_provider";
// Importing custom AppThemeProvider context wrapper component function
import AppThemeProvider from "@/components/theme_provider";
// Importing global CSS layouts definitions file
import "./globals.css";

// Configuring standard Inter Google Font for English typography styles
const font_inter = Inter({
  // Loading latin character groups subsets
  subsets: ["latin"],
  // Custom CSS variable reference name matching tailwind configurations
  variable: "--font-inter",
  // Enabling font swap transitions for smoother page loads
  display: "swap",
});

// Configuring standard Cairo Google Font for Arabic typography styles
const font_cairo = Cairo({
  // Loading arabic character groups subsets
  subsets: ["arabic"],
  // Custom CSS variable reference name matching tailwind configurations
  variable: "--font-cairo",
  // Enabling font swap transitions for smoother page loads
  display: "swap",
});

// Exporting Next.js layouts metadata configuration block
export const metadata: Metadata = {
  // Title string displayed in browser tab bars
  title: "Appoynt - Healthcare Platform",
  // Meta description tag useful for search optimizations
  description: "Appoynt Healthcare Ecosystem Dashboards Management portal.",
};

// Declaring and exporting main RootLayout layout component wrapper
export default function RootLayout({
  // Destructuring child node elements parameters from props
  children,
}: Readonly<{
  // Specifying type requirements for React child elements
  children: React.ReactNode;
}>) {
  // Returning the layout structure wrapping app pages
  return (
    // HTML wrapper node setting default language attributes
    <html lang="en" suppressHydrationWarning>
      {/* Root body element binding cairo and inter font face class settings */}
      <body
        // Assembling combined font classes along with browser antialiasing rules
        className={`${font_inter.variable} ${font_cairo.variable} antialiased`}
      >
        {/* Wrapping application pages hierarchy inside Redux state engine */}
        <StoreProvider>
          {/* Wrapping application pages layout inside Bilingual localization */}
          <LanguageProvider>
            {/* Wrapping application pages layout inside ThemeProvider */}
            <AppThemeProvider>
              {/* Injecting current page child elements into layout container */}
              {children}
            </AppThemeProvider>
          </LanguageProvider>
        </StoreProvider>
      </body>
    </html>
  );
}

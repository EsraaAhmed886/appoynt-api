/*
 * File Name: theme_provider.tsx
 * Author: shimaa salah
 * Date of Creation: 29/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next-themes
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Theme provider context wrapper integrating dark/light mode attribute management.
 */

"use client";

import { ThemeProvider } from "next-themes";

type ThemeProviderProps = {
  children: React.ReactNode;
};

export default function AppThemeProvider({ children }: ThemeProviderProps) {
  return (
    <ThemeProvider
      attribute="class"
      defaultTheme="light"
      enableSystem={false}
      disableTransitionOnChange
    >
      {children}
    </ThemeProvider>
  );
}

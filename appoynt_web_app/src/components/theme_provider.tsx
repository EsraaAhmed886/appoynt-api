/*
 * File Name: theme_provider.tsx
 * Author: shimaa salah
 * Created Date: 29/07/2026
 * Version: v1.1.0
 * Dependencies: react, next-themes
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Theme provider context wrapper integrating dark/light mode attribute management compatible with Next.js App Router and React 19.
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
      enableColorScheme={false}
      disableTransitionOnChange
    >
      {children}
    </ThemeProvider>
  );
}

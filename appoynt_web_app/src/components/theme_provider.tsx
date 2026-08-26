/*
 * File Name: theme_provider.tsx
 * Author: shimaa salah
 * Date of Creation: 29/07/2026
 * Version Information: v1.1.0
 * Dependencies:
 *   - react
 *   - next-themes
 * Contributors: [shimaa salah, Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Theme provider context wrapper integrating dark/light mode attribute management compatible with Next.js App Router and React 19.
 */

"use client";

import * as React from "react";
import { ThemeProvider as NextThemesProvider } from "next-themes";

export type ThemeProviderProps = React.ComponentProps<typeof NextThemesProvider>;

export default function AppThemeProvider({ children, ...props }: ThemeProviderProps) {
  return (
    <NextThemesProvider
      attribute="class"
      defaultTheme="light"
      enableSystem={false}
      enableColorScheme={false}
      disableTransitionOnChange
      {...props}
    >
      {children}
    </NextThemesProvider>
  );
}

"use client";

import { ThemeProvider } from "next-themes";

type ThemeProviderProps = {
  children: React.ReactNode;
};

export default function AppThemeProvider({
  children,
}: ThemeProviderProps) {
  return (
    <ThemeProvider
      attribute="class"
      defaultTheme="light"
      enableSystem={false}
    >
      {children}
    </ThemeProvider>
  );
}
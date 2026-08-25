/*
 * File Name: layout.tsx
 * Author: Kholoud Khaled
 * Created Date: 28/06/2026
 * Version: v1.2.0
 * Dependencies: next, next/font/google, ./globals.css,
 *   @/context/language_context, @/store/store_provider
 * Contributors: [Kholoud Khaled, shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Master Root Layout configuration with pre-paint locale & direction script to prevent language flash on initial page load.
 */

import type { Metadata } from "next";
import { Inter, Cairo } from "next/font/google";
import { LanguageProvider } from "@/context/language_context";
import { StoreProvider } from "@/store/store_provider";
import AppThemeProvider from "@/components/theme_provider";
import "./globals.css";

const font_inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

const font_cairo = Cairo({
  subsets: ["arabic"],
  variable: "--font-cairo",
  display: "swap",
});

export const metadata: Metadata = {
  title: "Appoynt - Healthcare Platform",
  description: "Appoynt Healthcare Ecosystem Dashboards Management portal.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        {/* Pre-paint anti-flash script establishing document direction and locale before initial render */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                try {
                  var locale = localStorage.getItem('appoynt_locale');
                  if ('ar' === locale) {
                    document.documentElement.dir = 'rtl';
                    document.documentElement.lang = 'ar';
                    document.body.style.fontFamily = 'var(--font-cairo), sans-serif';
                  } else {
                    document.documentElement.dir = 'ltr';
                    document.documentElement.lang = 'en';
                    document.body.style.fontFamily = 'var(--font-inter), sans-serif';
                  }
                } catch (e) {}
              })();
            `,
          }}
        />
      </head>
      <body
        className={`${font_inter.variable} ${font_cairo.variable} antialiased`}
      >
        <StoreProvider>
          <LanguageProvider>
            <AppThemeProvider>
              {children}
            </AppThemeProvider>
          </LanguageProvider>
        </StoreProvider>
      </body>
    </html>
  );
}
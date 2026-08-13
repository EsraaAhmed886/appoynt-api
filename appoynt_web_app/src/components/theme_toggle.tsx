/*
 * File Name: theme_toggle.tsx
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next-themes
 *   - lucide-react
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 13/08/2026]
 * File Description: Theme toggle button component switching between light and dark visual themes.
 */

"use client";

import { Moon, Sun } from "lucide-react";
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";

export default function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return null;
  } else {
    const is_dark = "dark" === theme;

    return (
      <button
        type="button"
        onClick={() => setTheme(is_dark ? "light" : "dark")}
        aria-label="Toggle theme"
        className="
          rounded-xl
          p-2
          text-app-sidebar_text_secondary
          transition-colors
          hover:bg-app-sidebar_hover
          hover:text-app-sidebar_text_primary
          focus:outline-none
        "
      >
        {is_dark ? <Sun size={20} /> : <Moon size={20} />}
      </button>
    );
  }
}

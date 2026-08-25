/*
 * File Name: theme_toggle.tsx
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next-themes
 *   - lucide-react
 * Contributors: shimaa salah, Kholoud Khaled
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Theme toggle button component switching between light and dark visual themes using next-themes resolvedTheme.
 */

"use client";

import { Moon, Sun } from "lucide-react";
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";

export default function ThemeToggle() {
  const { resolvedTheme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (
      <div className="w-9 h-9 rounded-xl p-2" />
    );
  } else {
    // Component mounted
  }

  const is_dark = "dark" === resolvedTheme;

  return (
    <button
      type="button"
      onClick={() => setTheme(is_dark ? "light" : "dark")}
      aria-label="Toggle theme"
      className="
        rounded-xl
        p-2
        text-slate-400
        dark:text-slate-400
        transition-colors
        hover:bg-slate-100
        dark:hover:bg-slate-800
        hover:text-slate-900
        dark:hover:text-slate-100
        focus:outline-none
      "
    >
      {is_dark ? <Sun size={20} className="text-amber-400" /> : <Moon size={20} className="text-slate-600" />}
    </button>
  );
}

/*
 * File Name: header.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - next/navigation
 *   - lucide-react
 *   - @/context/language_context
 *   - @/components/language_toggle
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 13/08/2026]
 * File Description: Top layout header bar containing mobile menu trigger, route title, language switcher, notifications, and profile avatar.
 */

"use client";

import Image from "next/image";
import { usePathname } from "next/navigation";
import { Bell, Menu } from "lucide-react";
import Link from "next/link";
import LanguageToggle from "@/components/language_toggle";
import { useTranslation } from "@/context/language_context";

type HeaderProps = {
  is_collapsed?: boolean;
  user_avatar?: string;
  has_unread_notifications?: boolean;
  on_notification_click?: () => void;
  on_profile_click?: () => void;
  on_menu_click?: () => void;
};

export default function LayoutHeader({
  user_avatar = "/images/profile_icon.jpeg",
  has_unread_notifications = true,
  on_profile_click,
  on_menu_click,
}: HeaderProps) {
  const pathname = usePathname();
  const { translations } = useTranslation();

  const get_page_title = (path: string | null): string => {
    if (null === path || "/" === path) {
      return translations.nav_dashboard;
    } else {
      const segments = path.split("/").filter(Boolean);
      const main_segment = segments[0];

      if (!main_segment) {
        return translations.nav_dashboard;
      } else if ("clinics" === main_segment) {
        return translations.nav_clinics;
      } else if ("appointments" === main_segment) {
        return translations.appointments_page_title || translations.nav_appointments || "Appointments";
      } else {
        return main_segment
          .split("-")
          .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
          .join(" ");
      }
    }
  };

  return (
    <header className="sticky top-0 z-30 flex h-16 w-full items-center justify-between border-b border-app-border bg-app-surface px-4 transition-colors duration-200 md:px-6 rtl:flex-row-reverse lg:rtl:flex-row">
      {/* Left Side (LTR) / Right Side on Desktop (RTL): Mobile Menu Button & Dynamic Title */}
      <div className="flex items-center gap-3 min-w-0 rtl:flex-row-reverse lg:rtl:flex-row">
        {on_menu_click ? (
          <button
            type="button"
            onClick={on_menu_click}
            aria-label="Open Menu"
            className="rounded-lg p-2 text-app-text-secondary hover:bg-app-input_fill lg:hidden focus:outline-none"
          >
            <Menu className="h-5 w-5" />
          </button>
        ) : null}

        <h1 className="text-xl font-bold tracking-tight text-app-text-primary md:text-2xl whitespace-nowrap">
          {get_page_title(pathname)}
        </h1>
      </div>

      {/* Right Side (LTR) / Left Side on Desktop (RTL): Actions & Profile */}
      <div className="flex items-center gap-2.5 shrink-0 md:gap-3 rtl:flex-row-reverse lg:rtl:flex-row">
        {/* Language Switcher Toggle */}
        <LanguageToggle />

        {/* Notification Button */}
        <Link
          href="/notifications"
          aria-label="Notifications"
          className="relative flex h-9 w-9 items-center justify-center rounded-lg text-app-text-secondary transition-colors hover:bg-app-input_fill hover:text-app-text-primary focus:outline-none"
        >
          <Bell className="h-5 w-5" />

          {has_unread_notifications ? (
            <span className="absolute right-2 top-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-app-surface" />
          ) : null}
        </Link>

        {/* Separator */}
        <div className="h-6 w-1px bg-app-border" />

        {/* Profile Avatar */}
        <button
          type="button"
          onClick={on_profile_click}
          aria-label="User Profile"
          className="relative flex h-9 w-9 overflow-hidden rounded-full ring-2 ring-transparent transition-all hover:ring-app-primary focus:outline-none"
        >
          <Image
            src={user_avatar}
            alt="User profile avatar"
            width={36}
            height={36}
            className="h-full w-full object-cover"
          />
        </button>
      </div>
    </header>
  );
}

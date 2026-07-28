"use client";

import Image from "next/image";
import { usePathname } from "next/navigation";
import { Bell, Menu } from "lucide-react";
import Link from "next/link";
import LanguageToggle from "@/components/language_toggle";

type HeaderProps = {
  isCollapsed?: boolean;
  userAvatar?: string;
  hasUnreadNotifications?: boolean;
  onNotificationClick?: () => void;
  onProfileClick?: () => void;
  onMenuClick?: () => void;
};

export default function Header({
  userAvatar = "/images/profile_icon.jpeg",
  hasUnreadNotifications = true,
  onProfileClick,
  onMenuClick,
}: HeaderProps) {
  const pathname = usePathname();

  const getPageTitle = (path: string | null) => {
    if (!path || path === "/") return "Dashboard";
    const segments = path.split("/").filter(Boolean);
    const mainSegment = segments[0];
    if (!mainSegment) return "Dashboard";

    return mainSegment
      .split("-")
      .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
      .join(" ");
  };

  return (
    <header className="sticky top-0 z-30 flex h-16 w-full items-center justify-between border-b border-app-border bg-app-surface px-4 transition-colors duration-200 md:px-6">
      {/* ── Left Side: Mobile Menu Button & Dynamic Title ────────────── */}
      <div className="flex items-center gap-3 min-w-0">
        {onMenuClick && (
          <button
            type="button"
            onClick={onMenuClick}
            aria-label="Open Menu"
            className="rounded-lg p-2 text-app-text-secondary hover:bg-app-input_fill lg:hidden focus:outline-none"
          >
            <Menu className="h-5 w-5" />
          </button>
        )}

        <h1 className="text-xl font-bold tracking-tight text-app-text-primary md:text-2xl whitespace-nowrap">
          {getPageTitle(pathname)}
        </h1>
      </div>

      {/* ── Right Side: Actions & Profile ────────────────────────────── */}
      <div className="flex items-center gap-2.5 shrink-0 md:gap-3">
        {/* Language Switcher Toggle */}
        <LanguageToggle />

        {/* Notification Button */}
        <Link
          href="/notifications"
          aria-label="Notifications"
          className="relative flex h-9 w-9 items-center justify-center rounded-lg text-app-text-secondary transition-colors hover:bg-app-input_fill hover:text-app-text-primary focus:outline-none"
        >
          <Bell className="h-5 w-5" />

          {hasUnreadNotifications && (
            <span className="absolute right-2 top-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-app-surface" />
          )}
        </Link>

        {/* Separator */}
        <div className="h-6 w-1px bg-app-border" />

        {/* Profile Avatar */}
        <button
          type="button"
          onClick={onProfileClick}
          aria-label="User Profile"
          className="relative flex h-9 w-9 overflow-hidden rounded-full ring-2 ring-transparent transition-all hover:ring-app-primary focus:outline-none"
        >
          <Image
            src={userAvatar}
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

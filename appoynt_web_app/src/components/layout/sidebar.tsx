/*
 * File Name: sidebar.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.1.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - lucide-react
 *   - @/context/language_context
 *   - @/components/layout/sidebar_item
 *   - @/components/theme_toggle
 * Contributors: [shimaa salah, Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Primary sidebar navigation drawer component with embedded brand logo, collapsibility, and localized navigation targets.
 */

"use client";

import Image from "next/image";
import SidebarItem from "./sidebar_item";
import ThemeToggle from "@/components/theme_toggle";
import { useTranslation } from "@/context/language_context";
import {
  PanelLeftClose,
  PanelLeftOpen,
  LayoutDashboard,
  CalendarDays,
  Users,
  UserRound,
  Building2,
  Clock3,
  Settings,
  LogOut,
  FileText,
  Bell,
} from "lucide-react";

type SidebarProps = {
  isCollapsed: boolean;
  onToggle: () => void;
  className?: string;
};

export default function Sidebar({
  isCollapsed,
  onToggle,
  className = "",
}: SidebarProps) {
  const { translations } = useTranslation();

  return (
    <aside
      className={`
        sticky
        top-0
        h-screen
        shrink-0
        flex
        flex-col
        overflow-visible
        bg-app-sidebar
        text-app-sidebar-text-primary
        transition-all
        duration-300
        z-40
        ${isCollapsed ? "w-20" : "w-64"}
        ${className}
      `}
    >
      {/* Header Container */}
      <div
        className={`
          flex
          h-16
          items-center
          px-4
          ${isCollapsed ? "justify-center" : "justify-between"}
        `}
      >
        <div
          onClick={isCollapsed ? onToggle : undefined}
          title={isCollapsed ? translations.app_name : undefined}
          className={`flex items-center gap-3 overflow-hidden ${
            isCollapsed ? "justify-center cursor-pointer" : ""
          }`}
        >
          <div className="flex h-[52px] w-[52px] shrink-0 items-center justify-center">
            <Image
              src="/images/APPOYNT ICON-WITHOUT B&T.png"
              alt="Appoynt Logo"
              width={52}
              height={52}
              className="h-[52px] w-[52px] object-contain transition-transform duration-200 hover:scale-105"
              priority
            />
          </div>

          {!isCollapsed ? (
            <h1 className="overflow-hidden whitespace-nowrap text-xl font-bold text-app-sidebar_text_primary transition-all duration-300">
              {translations.app_name}
            </h1>
          ) : null}
        </div>

        {!isCollapsed ? (
          <button
            type="button"
            onClick={onToggle}
            aria-label="Toggle Sidebar"
            className="
              rounded-lg
              p-2
              text-app-sidebar_text_secondary
              transition
              hover:bg-app-sidebar_hover
              hover:text-app-sidebar_text_primary
            "
          >
            <PanelLeftClose size={20} />
          </button>
        ) : (
          <button
            type="button"
            onClick={onToggle}
            aria-label="Expand Sidebar"
            className="sr-only"
          >
            <PanelLeftOpen size={20} />
          </button>
        )}
      </div>

      {/* Navigation List */}
      <nav className="flex-1 overflow-y-auto overflow-x-hidden space-y-2 p-4">
        <SidebarItem
          icon={LayoutDashboard}
          title={translations.nav_dashboard}
          href="/dashboard"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={CalendarDays}
          title={translations.nav_appointments}
          href="/appointments"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Users}
          title={translations.nav_patients}
          href="/patients"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={UserRound}
          title={translations.nav_receptionists}
          href="/receptionists"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Building2}
          title={translations.nav_clinics}
          href="/clinics"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Clock3}
          title={translations.nav_schedule}
          href="/schedule"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={FileText}
          title={translations.nav_medical_records}
          href="/medical-record"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Bell}
          title={translations.nav_notifications}
          href="/notifications"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Settings}
          title={translations.nav_settings}
          href="/settings"
          isCollapsed={isCollapsed}
        />
      </nav>

      {/* Footer Container */}
      <div className="mt-auto space-y-2 p-4 overflow-hidden">
        <div
          className={`flex overflow-hidden ${
            isCollapsed ? "justify-center" : "justify-start"
          }`}
        >
          <ThemeToggle />
        </div>

        <SidebarItem
          icon={LogOut}
          title={translations.btn_sign_out}
          href="#"
          isCollapsed={isCollapsed}
        />
      </div>
    </aside>
  );
}

"use client";

import SidebarItem from "./sidebar_item";
import ThemeToggle from "@/components/theme_toggle";
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
        bg-app-surface
        text-app-text-primary
        border-r
        border-app-border
        transition-all
        duration-300
        z-40
        ${isCollapsed ? "w-20" : "w-64"}
        ${className}
      `}
    >
      {/* Header */}
      <div
        className={`
          flex
          h-16
          items-center
          border-b
          border-app-border
          p-5
          ${isCollapsed ? "justify-center" : "justify-between"}
        `}
      >
        <h1
          className={`
            overflow-hidden
            whitespace-nowrap
            text-xl
            font-bold
            transition-all
            duration-300
            ${isCollapsed ? "w-0 opacity-0" : "w-auto opacity-100"}
          `}
        >
          Appoynt
        </h1>

        <button
          onClick={onToggle}
          className="
            rounded-lg
            p-2
            transition
            hover:bg-app-input_fill
          "
        >
          {isCollapsed ? (
            <PanelLeftOpen size={20} />
          ) : (
            <PanelLeftClose size={20} />
          )}
        </button>
      </div>

      <nav className="flex-1 overflow-y-auto overflow-x-hidden space-y-2 p-4">
        <SidebarItem
          icon={LayoutDashboard}
          title="Dashboard"
          href="/dashboard"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={CalendarDays}
          title="Appointments"
          href="/appointments"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Users}
          title="Patients"
          href="/patients"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={UserRound}
          title="Receptionists"
          href="/receptionists"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Building2}
          title="Clinics"
          href="/clinics"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Clock3}
          title="Schedule"
          href="/schedule"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={FileText}
          title="Medical Records"
          href="/medical-records"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Bell}
          title="Notifications"
          href="/notifications"
          isCollapsed={isCollapsed}
        />

        <SidebarItem
          icon={Settings}
          title="Settings"
          href="/settings"
          isCollapsed={isCollapsed}
        />
      </nav>

      {/* Footer */}
      <div className="mt-auto space-y-2 border-t border-app-border p-4 overflow-hidden">
        <div
          className={`flex overflow-hidden ${
            isCollapsed ? "justify-center" : "justify-start"
          }`}
        >
          <ThemeToggle />
        </div>

        <SidebarItem
          icon={LogOut}
          title="Log Out"
          href="#"
          isCollapsed={isCollapsed}
        />
      </div>
    </aside>
  );
}

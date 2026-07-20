"use client";

import { useState } from "react";
import { Menu } from "lucide-react";
import Sidebar from "./sidebar";

type DashboardLayoutProps = {
  children: React.ReactNode;
};

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);

  return (
    <div className="flex min-h-screen bg-[var(--app-background)] text-[var(--app-text-primary)] transition-colors">
      {/* Desktop Sidebar */}
      <Sidebar
        className="hidden lg:flex"
        isCollapsed={isCollapsed}
        onToggle={() => setIsCollapsed(!isCollapsed)}
      />

      {/* Mobile Overlay */}
      {isMobileSidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/50 lg:hidden"
          onClick={() => setIsMobileSidebarOpen(false)}
        />
      )}

      {/* Mobile Sidebar */}
      <Sidebar
        className={`
    fixed
    left-0
    top-0
    z-50
    lg:hidden
    transform
    transition-transform
    duration-300
    ${isMobileSidebarOpen ? "translate-x-0" : "-translate-x-full"}
  `}
        isCollapsed={false}
        onToggle={() => setIsMobileSidebarOpen(false)}
      />

      {/* Main Content */}
      <div className="flex flex-1 flex-col">
        {/* Mobile Header */}
        <header
          className="
    flex
    items-center
    justify-between
    border-b
    border-[var(--app-border)]
    bg-[var(--app-surface)]
    px-4
    py-3
    lg:hidden
    transition-colors
  "
        >
          <button
            onClick={() => setIsMobileSidebarOpen(true)}
            className="
rounded-lg
p-2
transition-colors
hover:bg-[var(--app-input-fill)]
"
          >
            <Menu size={24} />
          </button>

          <h1 className="text-lg font-semibold text-[var(--app-text-primary)]">
            Appoynt
          </h1>
        </header>

        <main
          className="
    flex-1
    bg-[var(--app-background)]
    text-[var(--app-text-primary)]
    p-6
    transition-colors
  "
        >
          {children}
        </main>
      </div>
    </div>
  );
}

"use client";

import { useState } from "react";
import Sidebar from "./sidebar";
import LayoutHeader from "./header";

type DashboardLayoutProps = {
  children: React.ReactNode;
};

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileSidebarOpen, setIsMobileSidebarOpen] = useState(false);

  return (
    <div className="relative flex min-h-screen w-full bg-app-bg text-app-text-primary">
      <Sidebar
        className="hidden lg:flex"
        isCollapsed={isCollapsed}
        onToggle={() => setIsCollapsed(!isCollapsed)}
      />

      {isMobileSidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/50 lg:hidden"
          onClick={() => setIsMobileSidebarOpen(false)}
        />
      )}

      <div
        className={`
          fixed inset-y-0 left-0 z-50 lg:hidden
          transform transition-transform duration-300 ease-in-out
          ${isMobileSidebarOpen ? "translate-x-0" : "-translate-x-full"}
        `}
      >
        <Sidebar
          isCollapsed={false}
          onToggle={() => setIsMobileSidebarOpen(false)}
        />
      </div>
      <div className="flex flex-1 min-w-0 w-full flex-col overflow-x-hidden">
        <LayoutHeader onMenuClick={() => setIsMobileSidebarOpen(true)} />

        <main className="flex-1 min-w-0 p-4 pt-6 md:p-6 md:pt-16 transition-colors">
          {children}
        </main>
      </div>
    </div>
  );
}

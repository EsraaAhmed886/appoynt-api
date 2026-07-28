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
    <div className="relative flex h-screen w-full overflow-hidden bg-app-bg text-app-text-primary">
      {/* Desktop Sidebar */}
      <Sidebar
        className="hidden lg:flex"
        isCollapsed={isCollapsed}
        onToggle={() => setIsCollapsed(!isCollapsed)}
      />

      {/* Mobile Sidebar Backdrop */}
      {isMobileSidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black/50 lg:hidden"
          onClick={() => setIsMobileSidebarOpen(false)}
        />
      )}

      {/* Mobile Sidebar */}
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

      {/* Main Content Area */}
      <div className="flex flex-1 min-w-0 w-full flex-col">
        {/* Sticky Fixed Header */}
        <div className="sticky top-0 z-30 w-full bg-app-bg border-b border-gray-200/60 dark:border-gray-800">
          <LayoutHeader onMenuClick={() => setIsMobileSidebarOpen(true)} />
        </div>

        {/* Scrollable Main Area */}
        <main className="flex-1 min-w-0 overflow-y-auto p-4 pt-6 md:p-6 transition-colors">
          {children}
        </main>
      </div>
    </div>
  );
}

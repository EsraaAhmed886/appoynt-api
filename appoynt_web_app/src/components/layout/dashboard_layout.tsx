/*
 * File Name: dashboard_layout.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/components/layout/sidebar
 *   - @/components/layout/header
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 24/08/2026]
 * File Description: Top-level layout container providing persistent sidebar navigation and fixed header.
 */

"use client";

import { useState } from "react";
import Sidebar from "./sidebar";
import LayoutHeader from "./header";

type DashboardLayoutProps = {
  children: React.ReactNode;
};

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  const [is_collapsed, set_is_collapsed] = useState(false);
  const [is_mobile_sidebar_open, set_is_mobile_sidebar_open] = useState(false);

  return (
    <div className="relative flex h-screen w-full overflow-hidden bg-app-bg text-app-text-primary">
      {/* Desktop Sidebar */}
      <Sidebar
        className="hidden lg:flex"
        isCollapsed={is_collapsed}
        onToggle={() => set_is_collapsed(!is_collapsed)}
      />

      {/* Mobile Sidebar Backdrop */}
      {is_mobile_sidebar_open ? (
        <div
          className="fixed inset-0 z-40 bg-black/50 lg:hidden"
          onClick={() => set_is_mobile_sidebar_open(false)}
        />
      ) : null}

      {/* Mobile Sidebar */}
      <div
        className={`
          fixed inset-y-0 left-0 z-50 lg:hidden
          transform transition-transform duration-300 ease-in-out
          ${is_mobile_sidebar_open ? "translate-x-0" : "-translate-x-full"}
        `}
      >
        <Sidebar
          isCollapsed={false}
          onToggle={() => set_is_mobile_sidebar_open(false)}
        />
      </div>

      {/* Main Content Area */}
      <div className="flex flex-1 min-w-0 w-full flex-col">
        {/* Sticky Fixed Header */}
        <div className="sticky top-0 z-30 w-full">
          <LayoutHeader on_menu_click={() => set_is_mobile_sidebar_open(true)} />
        </div>

        {/* Scrollable Main Area */}
        <main className="flex-1 min-w-0 overflow-y-auto p-4 pt-6 md:p-6 transition-colors">
          {children}
        </main>
      </div>
    </div>
  );
}

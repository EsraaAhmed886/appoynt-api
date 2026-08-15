/*
 * File Name: sidebar_item.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next/link
 *   - next/navigation
 *   - lucide-react
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 13/08/2026]
 * File Description: Individual navigation item link rendered within the sidebar drawer with active styling and portal tooltip.
 */

"use client";

import Link from "next/link";
import { LucideIcon } from "lucide-react";
import { usePathname } from "next/navigation";
import { useEffect, useRef, useState } from "react";
import { createPortal } from "react-dom";

type SidebarItemProps = {
  icon: LucideIcon;
  title: string;
  href: string;
  isCollapsed: boolean;
};

export default function SidebarItem({
  icon: Icon,
  title,
  href,
  isCollapsed,
}: SidebarItemProps) {
  const pathname = usePathname();

  const is_active = href === pathname;
  const item_ref = useRef<HTMLDivElement>(null);

  const [is_hovered, set_is_hovered] = useState(false);
  const [tooltip_position, set_tooltip_position] = useState({
    top: 0,
    left: 0,
  });

  useEffect(() => {
    if (is_hovered && item_ref.current) {
      const rect = item_ref.current.getBoundingClientRect();
      const is_rtl = "undefined" !== typeof document && "rtl" === document.documentElement.dir;
      set_tooltip_position({
        top: rect.top + rect.height / 2,
        left: is_rtl ? rect.left - 12 : rect.right + 12,
      });
    } else {
      // Not hovered or no ref
    }
  }, [is_hovered]);

  return (
    <div
      ref={item_ref}
      className="relative"
      onMouseEnter={() => set_is_hovered(true)}
      onMouseLeave={() => set_is_hovered(false)}
    >
      <Link
        href={href}
        className={`
          flex
          w-full
          items-center
          rounded-lg
          px-4
          py-3
          text-sm
          font-medium
          transition-all
          duration-300
          ${isCollapsed ? "justify-center" : "justify-start gap-3"}
          ${
            is_active
              ? "bg-app-primary text-white font-semibold shadow-sm"
              : "text-app-sidebar_text_secondary hover:bg-app-sidebar_hover hover:text-app-sidebar_text_primary"
          }
        `}
      >
        <Icon size={20} className="shrink-0" />

        {!isCollapsed && <span className="whitespace-nowrap">{title}</span>}
      </Link>

      {isCollapsed && is_hovered && "undefined" !== typeof window
        ? createPortal(
            <div
              className="
                pointer-events-none
                fixed
                z-9999
                -translate-y-1/2
                rtl:-translate-x-full
                whitespace-nowrap
                rounded-xl
                border
                border-app-border
                bg-app-surface
                px-3.5
                py-2
                text-sm
                font-medium
                text-app-text-primary
                shadow-xl
              "
              style={{
                top: tooltip_position.top,
                left: tooltip_position.left,
              }}
            >
              {title}
            </div>,
            document.body
          )
        : null}
    </div>
  );
}

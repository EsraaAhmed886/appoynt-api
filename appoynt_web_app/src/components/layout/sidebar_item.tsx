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

  const isActive = pathname === href;
  const itemRef = useRef<HTMLDivElement>(null);

  const [isHovered, setIsHovered] = useState(false);
  const [tooltipPosition, setTooltipPosition] = useState({
    top: 0,
    left: 0,
  });

  useEffect(() => {
    if (isHovered && itemRef.current) {
      const rect = itemRef.current.getBoundingClientRect();

      setTooltipPosition({
        top: rect.top + rect.height / 2,
        left: rect.right + 12,
      });
    }
  }, [isHovered]);

  return (
    <div
      ref={itemRef}
      className="relative"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
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
            isActive
              ? "bg-app-primary text-white"
              : "text-app-text-secondary hover:bg-app-input_fill hover:text-app-text-primary"
          }
        `}
      >
        <Icon size={20} className="shrink-0" />

        {!isCollapsed && <span className="whitespace-nowrap">{title}</span>}
      </Link>

      {isCollapsed &&
        isHovered &&
        typeof window !== "undefined" &&
        createPortal(
          <div
            className="
        pointer-events-none
        fixed
        z-`9999`
        -translate-y-1/2
        whitespace-nowrap
        rounded-lg
        border
        border-app-border
        bg-app-surface
        px-3
        py-2
        text-sm
        text-app-text-primary
        shadow-lg
      "
            style={{
              top: tooltipPosition.top,
              left: tooltipPosition.left,
            }}
          >
            {title}
          </div>,
          document.body,
        )}
    </div>
  );
}

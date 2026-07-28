"use client";

import Link from "next/link";
import { LucideIcon } from "lucide-react";
import { usePathname } from "next/navigation";

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

  return (
    <div className="group relative">
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

      {isCollapsed && (
        <div
          className="
            pointer-events-none
            absolute
            left-full
            top-1/2
            z-50
            ml-3
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
            opacity-0
            shadow-lg
            transition-all
            duration-200
            group-hover:opacity-100
          "
        >
          {title}
        </div>
      )}
    </div>
  );
}

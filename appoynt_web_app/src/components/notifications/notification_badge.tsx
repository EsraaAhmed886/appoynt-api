import React from "react";
import {
  XCircle,
  RefreshCw,
  Star,
  ShieldAlert,
  CreditCard,
  Calendar,
  Bell,
  LucideIcon,
} from "lucide-react";
import type { NotificationItem, NotificationType } from "@/types/notification";
import { useTranslation } from "@/context/language_context";

type StyleConfig = {
  icon: LucideIcon;
  bgColor: string;
  textColor: string;
};

const STYLES_BY_TYPE: Record<NotificationType, StyleConfig> = {
  cancellation: {
    icon: XCircle,
    bgColor: "bg-red-500/10",
    textColor: "text-red-500",
  },
  reschedule: {
    icon: RefreshCw,
    bgColor: "bg-amber-500/10",
    textColor: "text-amber-500",
  },
  review: {
    icon: Star,
    bgColor: "bg-purple-500/10",
    textColor: "text-purple-500",
  },
  security: {
    icon: ShieldAlert,
    bgColor: "bg-blue-500/10",
    textColor: "text-blue-500",
  },
  payment: {
    icon: CreditCard,
    bgColor: "bg-emerald-500/10",
    textColor: "text-emerald-500",
  },
  appointment: {
    icon: Calendar,
    bgColor: "bg-blue-500/10",
    textColor: "text-blue-500",
  },
  system: {
    icon: Bell,
    bgColor: "bg-gray-500/10",
    textColor: "text-gray-400",
  },
};

export function NotificationIcon({
  notificationItem,
}: {
  notificationItem: NotificationItem;
}) {
  const config = STYLES_BY_TYPE[notificationItem.type] || STYLES_BY_TYPE.system;
  const IconComponent = config.icon;

  return (
    <div
      className={`w-9 h-9 rounded-xl ${config.bgColor} ${config.textColor} flex items-center justify-center flex-shrink-0 transition-transform duration-200 group-hover:scale-105`}
    >
      <IconComponent className="w-5 h-5" />
    </div>
  );
}

export function PriorityBadge({ priority }: { priority?: string }) {
  const { t } = useTranslation();
  const isHighPriority = priority === "high";

  return (
    <span
      className={`px-2.5 py-0.5 rounded-md text-xs font-semibold whitespace-nowrap border ${
        isHighPriority
          ? "bg-red-500/10 text-red-500 border-red-500/20"
          : "bg-blue-500/10 text-blue-400 border-blue-500/20"
      }`}
    >
      {isHighPriority ? t("notif_priority_high") : t("notif_priority_normal")}
    </span>
  );
}

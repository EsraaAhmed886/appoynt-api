/*
 * File Name: notification_item_card.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/notification
 *   - ./notification_badge
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Interactive notification item card component with unread indicator, selection handling, priority badge, and delete trigger.
 */
import React from "react";
import { Trash2 } from "lucide-react";
import type { NotificationItem } from "@/types/notification";
import { NotificationIcon, PriorityBadge } from "./notification_badge";

interface NotificationItemCardProps {
  item: NotificationItem;
  isSelected: boolean;
  onSelect: (item: NotificationItem) => void;
  onDelete: (id: string) => void;
}

export default function NotificationItemCard({
  item,
  isSelected,
  onSelect,
  onDelete,
}: NotificationItemCardProps) {
  const isUnread = !item.isRead;

  return (
    <div
      role="button"
      tabIndex={0}
      onClick={() => onSelect(item)}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          onSelect(item);
        } else {
          // No action needed
        }
      }}
      aria-label={`Notification: ${item.title}`}
      className={`group flex flex-col sm:flex-row sm:items-center justify-between p-3.5 rounded-xl border transition-all duration-200 cursor-pointer gap-3 ${
        isSelected
          ? "border-app-primary bg-app-surface/80 shadow-sm ring-1 ring-app-primary/20"
          : "border-app-border hover:border-blue-500/40 bg-app-background hover:bg-app-surface/40"
      }`}
    >
      {/* Icon & Title Info */}
      <div className="flex items-start sm:items-center gap-3 flex-1 min-w-0">
        <div className="w-2 flex-shrink-0 pt-3 sm:pt-0">
          {isUnread && (
            <span
              aria-label="Unread notification"
              className="block w-2 h-2 rounded-full bg-app-primary animate-pulse"
            />
          )}
        </div>

        <NotificationIcon notificationItem={item} />

        <div className="space-y-0.5 min-w-0 flex-1">
          <h3 className="text-xs md:text-sm font-bold text-app-text-primary truncate">
            {item.title}
          </h3>
          <p className="text-[11px] md:text-xs text-app-text-secondary line-clamp-1">
            {item.description}
          </p>
        </div>
      </div>

      {/* Timestamp & Actions */}
      <div className="flex items-center justify-between sm:justify-end gap-3 flex-shrink-0 pt-2 sm:pt-0 border-t sm:border-t-0 border-app-border/40 pl-4 sm:pl-0">
        <span className="text-[10px] md:text-xs text-app-text-secondary whitespace-nowrap">
          {item.timestamp}
        </span>

        <div className="flex items-center gap-2">
          <PriorityBadge priority={item.priority} />

          <button
            type="button"
            aria-label="Delete notification"
            onClick={(e) => {
              e.stopPropagation();
              onDelete(item.id);
            }}
            className="p-1.5 rounded-lg text-app-text-secondary hover:text-red-500 hover:bg-red-500/10 transition-colors focus:outline-none"
            title="Delete notification"
          >
            <Trash2 className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );
}

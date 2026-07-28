import React from "react";
import type { NotificationCategory } from "@/types/notification";
import { useTranslation } from "@/context/language_context";
import { translation_en } from "@/constants/translations";

interface NotificationCategoryTabsProps {
  activeTab: NotificationCategory;
  countersMap: Record<NotificationCategory, number>;
  onTabChange: (tab: NotificationCategory) => void;
}

export default function NotificationCategoryTabs({
  activeTab,
  countersMap,
  onTabChange,
}: NotificationCategoryTabsProps) {
  const { t } = useTranslation();

  const categories: {
    keyId: NotificationCategory;
    labelKey: keyof typeof translation_en;
  }[] = [
    { keyId: "all", labelKey: "notif_tab_all" },
    { keyId: "unread", labelKey: "notif_tab_unread" },
    { keyId: "appointments", labelKey: "notif_tab_appointments" },
    { keyId: "reviews", labelKey: "notif_tab_reviews" },
  ];

  return (
    <div
      role="tablist"
      aria-label="Notification Categories"
      className="inline-flex p-1 bg-app-surface border border-app-border rounded-xl overflow-x-auto max-w-full no-scrollbar"
    >
      {categories.map(({ keyId, labelKey }) => {
        const isTabActive = activeTab === keyId;
        const count = countersMap[keyId] ?? 0;

        return (
          <button
            key={keyId}
            type="button"
            role="tab"
            aria-selected={isTabActive}
            onClick={() => onTabChange(keyId)}
            className={`px-3.5 py-1.5 rounded-lg text-xs md:text-sm font-semibold whitespace-nowrap transition-all duration-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-app-primary ${
              isTabActive
                ? "bg-app-primary text-white shadow-sm"
                : "text-app-text-secondary hover:text-app-text-primary hover:bg-app-border/30"
            }`}
          >
            {t(labelKey)} ({count})
          </button>
        );
      })}
    </div>
  );
}

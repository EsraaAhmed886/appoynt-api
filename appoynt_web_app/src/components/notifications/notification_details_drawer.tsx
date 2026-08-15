/*
 * File Name: notification_details_drawer.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/notification
 *   - @/lib/validators
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Side drawer component for displaying detailed notification metadata, patient details, status indicators, and validated internal target URLs.
 */
import React from "react";
import {
  X,
  ExternalLink,
  Calendar,
  User,
  Clock,
  ShieldAlert,
} from "lucide-react";
import type { NotificationItem } from "@/types/notification";
import { isSafeInternalUrl } from "@/lib/validators";
import { useTranslation } from "@/context/language_context";

interface NotificationDetailsDrawerProps {
  notification: NotificationItem | null;
  onClose: () => void;
}

export default function NotificationDetailsDrawer({
  notification,
  onClose,
}: NotificationDetailsDrawerProps) {
  const { t } = useTranslation();
  if (!notification) {
    return null;
  } else {
    const hasValidUrl = isSafeInternalUrl(notification.targetUrl);

    return (
      <>
        {/* Mobile Backdrop */}
        <div
          onClick={onClose}
          className="fixed inset-0 z-40 bg-black/40 backdrop-blur-xs lg:hidden transition-opacity"
        />

        {/* Drawer Container */}
        <aside
          aria-label="Notification details"
          className="fixed lg:relative inset-x-0 bottom-0 z-40 lg:z-auto w-full lg:w-72 bg-app-surface border border-app-border rounded-t-2xl lg:rounded-2xl p-4 shadow-xl lg:shadow-sm space-y-4 lg:order-2 sticky lg:top-4 animate-in fade-in slide-in-from-bottom-4 lg:slide-in-from-top-2 duration-200"
        >
          {/* Header */}
          <div className="flex items-center justify-between border-b border-app-border pb-2.5">
            <h2 className="text-xs font-bold uppercase tracking-wider text-app-text-secondary">
              {t("notif_details_title")}
            </h2>
            <button
              type="button"
              aria-label="Close details"
              onClick={onClose}
              className="p-1 rounded-lg text-app-text-secondary hover:text-app-text-primary hover:bg-app-border/40 transition-colors focus:outline-none"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          {/* Content */}
          <div className="space-y-2">
            <h3 className="text-sm font-bold text-app-text-primary leading-snug">
              {notification.title || "Notification"}
            </h3>
            <p className="text-xs text-app-text-secondary leading-relaxed">
              {notification.description || ""}
            </p>
          </div>

          {/* Metadata Details */}
          <div className="space-y-2 pt-2 border-t border-app-border/40 text-xs">
            {notification.date && (
              <div className="flex items-center gap-2 text-app-text-secondary">
                <Clock className="w-3.5 h-3.5 text-app-primary flex-shrink-0" />
                <span>{notification.date}</span>
              </div>
            )}
            {notification.patientName && (
              <div className="flex items-center gap-2 text-app-text-secondary">
                <User className="w-3.5 h-3.5 text-app-primary flex-shrink-0" />
                <span>
                  Patient:{" "}
                  <strong className="text-app-text-primary">
                    {notification.patientName}
                  </strong>
                </span>
              </div>
            )}
            {notification.status && (
              <div className="flex items-center gap-2 text-app-text-secondary">
                <Calendar className="w-3.5 h-3.5 text-app-primary flex-shrink-0" />
                <span>
                  Status:{" "}
                  <span className="font-semibold text-app-text-primary">
                    {notification.status}
                  </span>
                </span>
              </div>
            )}
          </div>

          {/* Action Link Button */}
          {notification.targetUrl && (
            <div className="pt-2">
              {hasValidUrl ? (
                <a
                  href={notification.targetUrl}
                  className="w-full py-2 px-4 rounded-xl bg-app-primary text-white font-bold text-xs flex items-center justify-center gap-2 shadow-sm hover:opacity-90 transition-opacity focus:outline-none focus:ring-2 focus:ring-app-primary/50"
                >
                  <span>{t("notif_view_details")}</span>
                  <ExternalLink className="w-3.5 h-3.5" />
                </a>
              ) : (
                <div className="flex items-center gap-2 p-2 rounded-xl bg-amber-500/10 text-amber-500 text-[11px]">
                  <ShieldAlert className="w-4 h-4 flex-shrink-0" />
                  <span>
                    External or untrusted target link disabled for security.
                  </span>
                </div>
              )}
            </div>
          )}
        </aside>
      </>
    );
  }
}

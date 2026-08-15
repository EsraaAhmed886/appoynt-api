/*
 * File Name: layout.tsx
 * Author: Shimaa Salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/components/layout/dashboard_layout
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Notifications Layout component responsible for wrapping
 *   the Notifications Management pages with the shared Dashboard Layout.
 */

import DashboardLayout from "@/components/layout/dashboard_layout";

export default function NotificationsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <DashboardLayout>{children}</DashboardLayout>;
}
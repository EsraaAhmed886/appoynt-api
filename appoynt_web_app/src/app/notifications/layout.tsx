import DashboardLayout from "@/components/layout/dashboard_layout";

export default function NotificationsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <DashboardLayout>{children}</DashboardLayout>;
}
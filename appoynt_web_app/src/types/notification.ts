export type NotificationType = 'appointment' | 'review' | 'system' | 'cancellation' | 'reschedule' | 'payment' | 'security';

export type NotificationPriority = 'high' | 'normal' | 'low';

export type NotificationCategory = 'all' | 'unread' | 'appointments' | 'reviews';

export interface NotificationItem {
  id: string;
  type: NotificationType;
  title: string;
  description: string;
  timestamp: string; // e.g., "Today, 09:30 AM"
  date: string;      // ISO string or formatted for details panel
  isRead: boolean;
  priority?: NotificationPriority;
  
  // Optional extra details for Details Drawer
  patientName?: string;
  status?: 'Upcoming' | 'Completed' | 'Cancelled';
  targetUrl?: string; // Link to target page (e.g. /appointments/1)
}
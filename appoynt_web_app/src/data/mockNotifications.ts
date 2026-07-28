import { NotificationItem } from '@/types/notification';

export const mockNotifications: NotificationItem[] = [
  {
    id: '1',
    type: 'appointment',
    title: 'New Appointment Booked',
    description: 'Ahmed Mohamed booked an appointment with you.',
    timestamp: 'Today, 09:30 AM',
    date: 'May 27, 2025 - 09:30 AM',
    isRead: false,
    priority: 'normal',
    patientName: 'Ahmed Mohamed',
    status: 'Upcoming',
    targetUrl: '/appointments/1'
  },
  {
    id: '2',
    type: 'cancellation',
    title: 'Appointment Cancelled',
    description: 'Sara Ali cancelled her appointment.',
    timestamp: 'Today, 10:45 AM',
    date: 'May 27, 2025 - 10:45 AM',
    isRead: false,
    priority: 'high',
    patientName: 'Sara Ali',
    status: 'Cancelled',
    targetUrl: '/appointments/2'
  },
  {
    id: '3',
    type: 'review',
    title: 'New Patient Review Received',
    description: 'Ahmed Mohamed rated your visit 5 stars.',
    timestamp: 'Yesterday, 08:15 PM',
    date: 'May 26, 2025 - 08:15 PM',
    isRead: false,
    priority: 'normal',
    targetUrl: '/reviews'
  },
  {
    id: '4',
    type: 'security',
    title: 'Login from a New Device',
    description: 'Your account was accessed from a new device.',
    timestamp: 'Yesterday, 06:40 PM',
    date: 'May 26, 2025 - 06:40 PM',
    isRead: true,
    priority: 'normal',
  },
  {
    id: '5',
    type: 'payment',
    title: 'Payment Received',
    description: 'Payment for Ahmed Mohamed\'s consultation has been received.',
    timestamp: 'Yesterday, 04:30 PM',
    date: 'May 26, 2025 - 04:30 PM',
    isRead: true,
    priority: 'normal',
  }
];
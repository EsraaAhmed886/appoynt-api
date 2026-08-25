/*
 * File Name: appointments_strings.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: flutter/widgets.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Defines complete English and Arabic localization dictionaries for the Appointments mobile module.
 */

import 'package:flutter/widgets.dart';

/// Centralized localization dictionary for the Appointments module.
class AppointmentsStrings {
  static const Map<String, Map<String, String>> localizedValues = {
    'en': {
      'appointments': 'Appointments',
      'tab_upcoming': 'Upcoming',
      'tab_completed': 'Completed',
      'tab_cancelled': 'Cancelled',
      'tab_all': 'All Appointments',
      'search_placeholder': 'Search in your appointments',
      'filter': 'Filter',
      'quick_actions': 'Quick Actions',
      'view_all': 'View All',
      'prescriptions': 'Prescriptions',
      'lab_results': 'Lab Results',
      'radiology_reports': 'Radiology Reports',
      'view_details': 'View Details',
      'reschedule': 'Reschedule',
      'cancel_appointment': 'Cancel',
      'join_call': 'Join Call',
      'book_again': 'Book Again',
      'book_now': 'Book Now',
      'no_upcoming': 'No Upcoming Appointments',
      'no_upcoming_sub': 'Use Quick Actions or search doctors to book your next consultation.',
      'no_completed': 'No Completed Appointments',
      'no_completed_sub': 'Your completed medical consultations will appear here.',
      'no_cancelled': 'No Cancelled Appointments',
      'no_cancelled_sub': 'Your cancelled appointments will appear here.',
      'no_all': 'No Appointments',
      'no_all_sub': 'You do not have any appointment records in this category.',
      'no_search_results': 'No appointments match your search',
      'no_filter_results': 'No appointments match the selected filters',
      'cancel_dialog_title': 'Cancel Appointment?',
      'cancel_dialog_desc': 'Are you sure you want to cancel your scheduled appointment with {name}?',
      'cancel_full_refund': 'Eligible for 100% Full Refund',
      'cancel_partial_refund': 'Eligible for Partial Refund (Fee applies)',
      'cancel_cutoff_warning': 'Appointments cannot be cancelled within 15 minutes of scheduled time.',
      'cancel_reason_hint': 'Reason for cancellation (optional)',
      'confirm_cancel': 'Confirm Cancellation',
      'keep_appointment': 'Keep Appointment',
      'reschedule_title': 'Reschedule Appointment',
      'select_date': 'Select New Date',
      'select_time': 'Select Available Time',
      'no_slots_available': 'No available time slots for this date.',
      'confirm_reschedule': 'Confirm Reschedule',
      'unavailable_doctor': 'Unavailable Doctor',
      'unavailable_facility': 'Unavailable Facility',
      'ask_ai': 'Ask AI',
      'apply_filter': 'Apply Filter',
      'reset': 'Reset',
      'filter_by_date': 'Date Range',
      'filter_by_specialty': 'Specialty',
      'filter_by_clinic': 'Clinic / Facility',
      'filter_by_type': 'Consultation Type',
      'in_clinic': 'In-Clinic',
      'online_video': 'Online Video Call',
      'start_date': 'From',
      'end_date': 'To',
      'all_specialties': 'All Specialties',
      'all_clinics': 'All Clinics',
      'appointment_cancelled_success': 'Appointment cancelled successfully.',
      'appointment_rescheduled_success': 'Appointment rescheduled successfully.',
      'recommended_doctors': 'Recommended For You',
      'routine_checkup': 'Routine Health Checkup',
      'consultation_fee': 'Fee',
      'reviews': 'reviews',
      'status_confirmed': 'Confirmed',
      'status_upcoming': 'Upcoming',
      'status_completed': 'Completed',
      'status_cancelled': 'Cancelled',
      'status_missed': 'Missed',
    },
    'ar': {
      'appointments': 'المواعيد',
      'tab_upcoming': 'القادمة',
      'tab_completed': 'المكتملة',
      'tab_cancelled': 'الملغاة',
      'tab_all': 'كل المواعيد',
      'search_placeholder': 'ابحث في مواعيدك',
      'filter': 'تصفية',
      'quick_actions': 'إجراءات سريعة',
      'view_all': 'عرض الكل',
      'prescriptions': 'الروشتات الطبية',
      'lab_results': 'نتائج التحاليل',
      'radiology_reports': 'تقارير الأشعة',
      'view_details': 'تفاصيل الموعد',
      'reschedule': 'تعديل الموعد',
      'cancel_appointment': 'إلغاء الموعد',
      'join_call': 'انضم للمكالمة',
      'book_again': 'إعادة الحجز',
      'book_now': 'احجز الآن',
      'no_upcoming': 'لا توجد مواعيد قادمة',
      'no_upcoming_sub': 'استخدم الإجراءات السريعة أو ابحث عن طبيب لحجز استشارتك القادمة.',
      'no_completed': 'لا توجد مواعيد مكتملة',
      'no_completed_sub': 'ستظهر هنا جميع استشاراتك الطبية المكتملة.',
      'no_cancelled': 'لا توجد مواعيد ملغاة',
      'no_cancelled_sub': 'ستظهر هنا جميع المواعيد التي تم إلغاؤها.',
      'no_all': 'لا توجد أي مواعيد مسجلة',
      'no_all_sub': 'لا يوجد لديك أي سجلات مواعيد في هذا القسم.',
      'no_search_results': 'لا توجد نتائج تطابق بحثك',
      'no_filter_results': 'لا توجد مواعيد تطابق الفلاتر المحددة',
      'cancel_dialog_title': 'هل تريد إلغاء هذا الموعد؟',
      'cancel_dialog_desc': 'هل أنت متأكد من رغبتك في إلغاء موعدك المحجوز مع {name}؟',
      'cancel_full_refund': 'مؤهل لاسترداد المبلغ بالكامل (100%)',
      'cancel_partial_refund': 'مؤهل لاسترداد جزئي للمبلغ (تطبق رسوم إلغاء)',
      'cancel_cutoff_warning': 'لا يمكن إلغاء الموعد قبل أقل من 15 دقيقة من موعد البدء.',
      'cancel_reason_hint': 'سبب الإلغاء (اختياري)',
      'confirm_cancel': 'تأكيد الإلغاء',
      'keep_appointment': 'الاحتفاظ بالموعد',
      'reschedule_title': 'تعديل موعد الكشف',
      'select_date': 'اختر تاريخاً جديداً',
      'select_time': 'اختر وقتاً متاحاً',
      'no_slots_available': 'لا توجد فترات متاحة في هذا اليوم.',
      'confirm_reschedule': 'تأكيد الموعد الجديد',
      'unavailable_doctor': 'طبيب غير متوفر',
      'unavailable_facility': 'عيادة غير متوفرة',
      'ask_ai': 'المساعد الطبي',
      'apply_filter': 'تطبيق التصفية',
      'reset': 'إعادة ضبط',
      'filter_by_date': 'الفترة الزمنية',
      'filter_by_specialty': 'التخصص الطبي',
      'filter_by_clinic': 'العيادة أو المركز',
      'filter_by_type': 'نوع الاستشارة',
      'in_clinic': 'كشف في العيادة',
      'online_video': 'استشارة فيديو أونلاين',
      'start_date': 'من',
      'end_date': 'إلى',
      'all_specialties': 'جميع التخصصات',
      'all_clinics': 'جميع العيادات',
      'appointment_cancelled_success': 'تم إلغاء الموعد بنجاح.',
      'appointment_rescheduled_success': 'تم تعديل موعد الكشف بنجاح.',
      'recommended_doctors': 'أطباء مقترحون لك',
      'routine_checkup': 'فحص طبي دوري',
      'consultation_fee': 'قيمة الكشف',
      'reviews': 'تقييم',
      'status_confirmed': 'مؤكد',
      'status_upcoming': 'قادم',
      'status_completed': 'مكتمل',
      'status_cancelled': 'ملغى',
      'status_missed': 'فائت',
    },
  };

  /// Returns localized string for the specified key given the active BuildContext locale.
  static String of(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    final langKey = localizedValues.containsKey(locale) ? locale : 'en';
    return localizedValues[langKey]?[key] ?? localizedValues['en']?[key] ?? key;
  }

  /// Returns localized string by explicitly passing boolean isArabic flag.
  static String get(String key, {bool isArabic = false}) {
    final langKey = isArabic ? 'ar' : 'en';
    return localizedValues[langKey]?[key] ?? localizedValues['en']?[key] ?? key;
  }
}

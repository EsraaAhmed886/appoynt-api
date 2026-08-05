/*
 * File Name: translations.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled , shimaa salah]
 * Last Modified Date: [Kholoud Khaled - 05/08/2026]
 * File Description: Defines English and Arabic localized dictionary collections.
 */

// Declaring translation database for English language localization
export const translation_en = {
  // Name of the app
  app_name: "Appoynt",
  // Banner title
  welcome_title: "Welcome to Appoynt",
  // Banner subtitle
  welcome_subtitle: "Ecosystem dashboard setup successfully initialized.",
  // System state
  system_operational: "System Operational",
  // English label
  lang_english: "English",
  // Arabic label
  lang_arabic: "Arabic",
  // Doctor label
  role_doctor: "Doctor Dashboard",
  // Receptionist label
  role_receptionist: "Receptionist Dashboard",
  // Admin label
  role_admin: "Admin Dashboard",
  // Email prompt
  placeholder_email: "Enter email address",
  // Password prompt
  placeholder_password: "Enter password",
  // Login trigger
  btn_sign_in: "Sign In",
  // Logout trigger
  btn_sign_out: "Sign Out",
  // User context
  active_user: "Logged in as",
  // Check API
  api_status: "API Server Status",
  // Connected indicator
  api_connected: "Connected",
  // Offline indicator
  api_disconnected: "Disconnected",
  // Pending API query
  api_checking: "Checking...",
  // Redux checking
  redux_test: "Redux State Verification",
  // Increment button
  counter_increment: "Increment Redux Counter",
  // Counter state message
  current_count: "Current Count Value",
  // Logo letter text
  logo_letter: "A",
  // Role selection prompt helper label
  prompt_select_role: "Select a dashboard role profile to dispatch mock session credentials into Redux store:",
  // Doctor role short translation
  role_doctor_short: "Doctor",
  // Receptionist role short translation
  role_receptionist_short: "Reception",
  // Admin role short translation
  role_admin_short: "Admin",
  // Role label prefix text
  label_role: "Role",
  // Stack configuration box header
  foundational_stack: "Foundational Stack Configuration",
  // Web framework parameter label
  param_framework: "Web Framework",
  // Language engine parameter label
  param_language: "Engine / Language",
  // Styling library parameter label
  param_styling: "Styling Library",
  // State management parameter label
  param_state: "State Core",
  // Network connection helper parameter label
  param_network: "Client Network",
  // System font parameter label
  param_font: "Active Locale Font",
  // Arabic cairo font display parameter label
  font_ar_label: "Cairo (Arabic RTL)",
  // English inter font display parameter label
  font_en_label: "Inter (English LTR)",
  // Title for the login form card container
  login_title: "Sign in to your account",
  // Subtitle explaining access rules for patients and clinicians
  login_subtitle: "Access your dashboard, appointments, and patient records.",
  // Welcome back greeting message for returning users
  login_welcome_back: "Welcome back",
  // Text label for the email identification input field
  login_email_label: "Email address",
  // Input placeholder text displaying example email
  login_email_placeholder: "you@clinic.com",
  // Text label for the password validation input field
  login_password_label: "Password",
  // Input placeholder mask representing password dots
  login_password_placeholder: "••••••••",
  // Underlined route link label to reset password
  login_forgot_password: "Forgot password?",
  // Persistent login checkbox description label
  login_remember_me: "Keep me signed in on this device",
  // Direct trigger button action text to log in
  login_sign_in_button: "Sign in",
  // Spinning indicator loading text for auth requests
  login_signing_in: "Signing in...",
  // Regulatory HIPAA compliance badge footer label
  login_security_badge: "Protected with end-to-end encryption · HIPAA compliant",
  // Primary hero marketing title statement
  login_hero_title: "A smarter way to manage healthcare, end to end.",
  // First section line describing standard features
  login_hero_subtitle_part1: "Connect patients, clinicians, and clinics on one secure platform",
  // Second section line describing the scheduling platform
  login_hero_subtitle_part2: "— appointments, records, and care, beautifully orchestrated.",
  // Label for automated appointment organizer feature
  login_feature_scheduling: "Effortless appointment scheduling",
  // Label for medical records directory verification feature
  login_feature_records: "Unified patient records & history",
  // Label for standard security certification feature
  login_feature_security: "HIPAA-grade security by default",
  // Standard copyright notice for app footer branding
  login_copyright: "© 2026 Appoynt Health. All rights reserved.",
  // Error prompt shown when email submission field is empty
  err_email_required: "Email address or phone is required",
  // Error prompt shown when password submission field is empty
  err_password_required: "Password is required",
  // Combined error prompt shown when both fields are empty
  err_both_required: "Email and Password are required",
  // Error prompt shown when backend rejects login parameters
  err_invalid_credentials: "Invalid email/phone or password",
  // General validation failure response notification label
  err_login_failed: "Login failed. Please check your credentials.",
  // Layout footer informational credentials text
  footer_text: "Developed in config/APPOYNT-68 branch. " +
    "All changes follow the team re-implementation plan guidelines.",
  // Notification localization keys
  notif_mark_all_read: "Mark all as read",
  notif_delete_all: "Delete all",
  notif_search_placeholder: "Search notifications...",
  notif_no_found: "No notifications found",
  notif_no_search_match: "No notifications match your search",
  notif_clear_search: "Clear Search",
  notif_tab_all: "All",
  notif_tab_unread: "Unread",
  notif_tab_appointments: "Appointments",
  notif_tab_reviews: "Reviews",
  notif_details_title: "Notification Details",
  notif_view_details: "View Related Details",
  notif_delete_modal_title: "Delete All Notifications?",
  notif_delete_modal_desc: "This action will permanently delete all notifications in your inbox. This cannot be undone.",
  notif_cancel: "Cancel",
  notif_confirm_delete: "Delete All",
  notif_deleted_toast: "Notification deleted",
  notif_undo: "Undo",
  notif_priority_high: "High",
  notif_priority_normal: "Normal",
  // Clinics module localization keys
  nav_clinics: "Clinics",
  nav_dashboard: "Dashboard",
  nav_appointments: "Appointments",
  nav_patients: "Patients",
  nav_receptionists: "Receptionists",
  nav_schedule: "Schedule",
  nav_medical_records: "Medical Records",
  nav_notifications: "Notifications",
  nav_settings: "Settings",
  clinic_search_placeholder: "Search clinic by name...",
  clinic_status_all: "All Statuses",
  clinic_status_active: "Active",
  clinic_status_inactive: "Inactive",
  clinic_sort_default: "Sort by...",
  clinic_sort_name_asc: "Name (A-Z)",
  clinic_sort_name_desc: "Name (Z-A)",
  clinic_sort_newest: "Newest First",
  clinic_sort_oldest: "Oldest First",
  clinic_sort_status: "Status",
  clinic_add_button: "Add New Clinic",
  th_clinic_name: "Clinic Name",
  th_location: "Location",
  th_phone: "Phone",
  th_consultation_fee: "Consultation Fee",
  th_working_days: "Working Days",
  th_status: "Status",
  th_actions: "Actions",
  modal_add_clinic_title: "Add New Clinic",
  modal_edit_clinic_title: "Edit Clinic",
  modal_step_1: "Clinic Information",
  modal_step_2: "Working Schedule",
  modal_step_3: "Break Times",
  modal_step_4: "Receptionists",
  modal_step_5: "Booking Settings",
  btn_back: "← Back",
  btn_next: "Next",
  btn_cancel: "Cancel",
  btn_save_changes: "✓ Save Changes",
  btn_update_clinic: "✓ Update Clinic",
  lbl_clinic_name: "Clinic Name",
  lbl_phone: "Phone Number",
  lbl_governorate: "Governorate",
  lbl_city: "City",
  lbl_address: "Detailed Address",
  lbl_consultation_fee: "Consultation Fee (EGP)",
  ph_select_governorate: "Select governorate",
  ph_select_city: "Select city",
  ph_clinic_name: "e.g. Health Care Clinic",
  ph_phone: "01xxxxxxxxx",
  ph_address: "Building number, street name...",
  ph_fee: "e.g. 300",
  val_clinic_name_req: "Clinic name is required",
  val_clinic_name_min: "Clinic name must be at least 2 characters",
  val_clinic_name_max: "Clinic name must not exceed 50 characters",
  val_clinic_name_spaces: "Clinic name cannot contain multiple consecutive spaces",
  val_clinic_name_invalid: "Clinic name contains invalid characters",
  val_phone_req: "Phone number is required and must be valid 11 digits",
  val_governorate_req: "Governorate is required",
  val_city_req: "City is required",
  val_address_req: "Address is required",
  val_address_min: "Address must be at least 2 characters",
  val_address_max: "Address must not exceed 100 characters",
  val_address_spaces: "Address cannot contain multiple consecutive spaces",
  val_address_trailing: "Address cannot end with spaces",
  val_address_invalid: "Address contains invalid characters",
  val_fee_req: "Consultation fee is required and must be a positive number",
  modal_add_success_title: "Clinic Added Successfully!",
  modal_add_success_desc: "The new clinic has been created and registered into your appoynt system.",
  modal_edit_success_title: "Clinic Updated Successfully!",
  modal_edit_success_desc: "The clinic details have been updated successfully.",
  modal_delete_title: "Delete Clinic?",
  modal_delete_desc: "Are you sure you want to delete this clinic? This action cannot be undone.",
  modal_delete_success_title: "Clinic Deleted",
  modal_delete_success_desc: "The clinic has been permanently removed.",
  modal_unsaved_title: "Unsaved Changes",
  modal_unsaved_desc: "You have unsaved changes. Are you sure you want to leave?",
  btn_stay: "Stay and Continue",
  btn_leave: "Discard & Leave",
  btn_done: "Done",
  btn_confirm_delete: "Delete",
  state_empty_title: "No Clinics Found",
  state_empty_desc: "You haven't added any clinics yet. Click 'Add New Clinic' to get started.",
  state_error_title: "No Matching Results",
  state_error_desc: "No clinics match your current search or filter criteria.",
  state_loading: "Loading Clinics...",
  pagination_previous: "Previous",
  pagination_next: "Next",
};

// Declaring translation database for Arabic language localization
export const translation_ar = {
  // Name of the app
  app_name: "أبوينت",
  // Banner title
  welcome_title: "مرحباً بك في أبوينت",
  // Banner subtitle
  welcome_subtitle: "تم تهيئة لوحة التحكم الخاصة بالنظام بنجاح.",
  // System state
  system_operational: "النظام يعمل بنجاح",
  // English label
  lang_english: "الإنجليزية",
  // Arabic label
  lang_arabic: "العربية",
  // Doctor label
  role_doctor: "لوحة تحكم الطبيب",
  // Receptionist label
  role_receptionist: "لوحة تحكم موظف الاستقبال",
  // Admin label
  role_admin: "لوحة تحكم المدير",
  // Email prompt
  placeholder_email: "أدخل البريد الإلكتروني",
  // Password prompt
  placeholder_password: "أدخل كلمة المرور",
  // Login trigger
  btn_sign_in: "تسجيل الدخول",
  // Logout trigger
  btn_sign_out: "تسجيل الخروج",
  // User context
  active_user: "تم تسجيل الدخول بصفتك",
  // Check API
  api_status: "حالة اتصال الخادم",
  // Connected indicator
  api_connected: "متصل",
  // Offline indicator
  api_disconnected: "غير متصل",
  // Pending API query
  api_checking: "جاري الفحص...",
  // Redux checking
  redux_test: "التحقق من حالة Redux",
  // Increment button
  counter_increment: "زيادة عداد Redux",
  // Counter state message
  current_count: "قيمة العداد الحالية",
  // Logo letter text in Arabic
  logo_letter: "أ",
  // Role selection prompt helper label in Arabic
  prompt_select_role: "اختر دورًا لإرسال بيانات المصادقة الوهمية إلى مخزن Redux:",
  // Doctor role short translation in Arabic
  role_doctor_short: "طبيب",
  // Receptionist role short translation in Arabic
  role_receptionist_short: "استقبال",
  // Admin role short translation in Arabic
  role_admin_short: "مدير",
  // Role label prefix text in Arabic
  label_role: "الدور",
  // Stack configuration box header in Arabic
  foundational_stack: "إعدادات البنية التحتية البرمجية",
  // Web framework parameter label in Arabic
  param_framework: "إطار عمل الويب",
  // Language engine parameter label in Arabic
  param_language: "المحرك / لغة البرمجة",
  // Styling library parameter label in Arabic
  param_styling: "مكتبة التنسيق",
  // State management parameter label in Arabic
  param_state: "إدارة الحالة",
  // Network connection helper parameter label in Arabic
  param_network: "عميل الاتصال",
  // System font parameter label in Arabic
  param_font: "خط اللغة النشط",
  // Arabic cairo font display parameter label in Arabic
  font_ar_label: "القاهرة (عربي - من اليمين لليسار)",
  // English inter font display parameter label in Arabic
  font_en_label: "إنتر (إنجليزي - من اليسار لليمين)",
  // Title for the login form card container in Arabic
  login_title: "تسجيل الدخول إلى حسابك",
  // Subtitle explaining access rules for patients and clinicians in Arabic
  login_subtitle: "الوصول إلى لوحة التحكم والمواعيد وسجلات المرضى الخاصة بك.",
  // Welcome back greeting message for returning users in Arabic
  login_welcome_back: "مرحباً بعودتك",
  // Text label for the email identification input field in Arabic
  login_email_label: "البريد الإلكتروني",
  // Input placeholder text displaying example email in Arabic
  login_email_placeholder: "you@clinic.com",
  // Text label for the password validation input field in Arabic
  login_password_label: "كلمة المرور",
  // Input placeholder mask representing password dots in Arabic
  login_password_placeholder: "••••••••",
  // Underlined route link label to reset password in Arabic
  login_forgot_password: "نسيت كلمة المرور؟",
  // Persistent login checkbox description label in Arabic
  login_remember_me: "بقائي مسجلاً للدخول على هذا الجهاز",
  // Direct trigger button action text to log in in Arabic
  login_sign_in_button: "تسجيل الدخول",
  // Spinning indicator loading text for auth requests in Arabic
  login_signing_in: "جاري تسجيل الدخول...",
  // Regulatory HIPAA compliance badge footer label in Arabic
  login_security_badge: "محمي بتشفير طرف إلى طرف · متوافق مع HIPAA",
  // Primary hero marketing title statement in Arabic
  login_hero_title: "طريقة أذكى لإدارة الرعاية الصحية، من البداية إلى النهاية.",
  // First section line describing standard features in Arabic
  login_hero_subtitle_part1: "ربط المرضى والأطباء والعيادات في منصة واحدة آمنة",
  // Second section line describing the scheduling platform in Arabic
  login_hero_subtitle_part2: "— المواعيد والسجلات والرعاية، منظمة بشكل جميل.",
  // Label for automated appointment organizer feature in Arabic
  login_feature_scheduling: "جدولة مواعيد سهلة وبدون مجهود",
  // Label for medical records directory verification feature in Arabic
  login_feature_records: "سجلات مرضى وتاريخ موحد",
  // Label for standard security certification feature in Arabic
  login_feature_security: "أمان بمستوى HIPAA بشكل افتراضي",
  // Standard copyright notice for app footer branding in Arabic
  login_copyright: "© 2026 أبوينت هيلث. جميع الحقوق محفوظة.",
  // Error prompt shown when email submission field is empty in Arabic
  err_email_required: "البريد الإلكتروني أو رقم الهاتف مطلوب",
  // Error prompt shown when password submission field is empty in Arabic
  err_password_required: "كلمة المرور مطلوبة",
  // Combined error prompt shown when both fields are empty in Arabic
  err_both_required: "البريد الإلكتروني وكلمة المرور مطلوبان",
  // Error prompt shown when backend rejects login parameters in Arabic
  err_invalid_credentials: "البريد الإلكتروني/الهاتف أو كلمة المرور غير صحيحة",
  // General validation failure response notification label in Arabic
  err_login_failed: "فشل تسجيل الدخول. يرجى التحقق من بيانات الاعتماد.",
  // Layout footer informational credentials text in Arabic
  footer_text: "تم التطوير في فرع config/APPOYNT-68. " +
    "جميع التغييرات تتبع إرشادات خطة إعادة التنفيذ المعتمدة.",
  // Notification localization keys in Arabic
  notif_mark_all_read: "تحديد الكل كمقروء",
  notif_delete_all: "حذف الكل",
  notif_search_placeholder: "البحث في الإشعارات...",
  notif_no_found: "لا توجد إشعارات",
  notif_no_search_match: "لا توجد إشعارات تطابق بحثك",
  notif_clear_search: "مسح البحث",
  notif_tab_all: "الكل",
  notif_tab_unread: "غير مقروء",
  notif_tab_appointments: "المواعيد",
  notif_tab_reviews: "التقييمات",
  notif_details_title: "تفاصيل الإشعار",
  notif_view_details: "عرض التفاصيل المرتبطة",
  notif_delete_modal_title: "حذف جميع الإشعارات؟",
  notif_delete_modal_desc: "هذا الإجراء سيقوم بحذف جميع الإشعارات نهائياً من صندوقك. لا يمكن التراجع عن هذا الإجراء.",
  notif_cancel: "إلغاء",
  notif_confirm_delete: "حذف الكل",
  notif_deleted_toast: "تم حذف الإشعار",
  notif_undo: "تراجع",
  notif_priority_high: "عالي",
  notif_priority_normal: "عادي",
  // Clinics module localization keys in Arabic
  nav_clinics: "العيادات",
  nav_dashboard: "لوحة التحكم",
  nav_appointments: "المواعيد",
  nav_patients: "المرضى",
  nav_receptionists: "موظفو الاستقبال",
  nav_schedule: "جدول المواعيد",
  nav_medical_records: "السجلات الطبية",
  nav_notifications: "الإشعارات",
  nav_settings: "الإعدادات",
  clinic_search_placeholder: "ابحث عن عيادة بالإسم...",
  clinic_status_all: "جميع الحالات",
  clinic_status_active: "نشط",
  clinic_status_inactive: "غير نشط",
  clinic_sort_default: "ترتيب حسب...",
  clinic_sort_name_asc: "الاسم (أ-ي)",
  clinic_sort_name_desc: "الاسم (ي-أ)",
  clinic_sort_newest: "الأحدث أولاً",
  clinic_sort_oldest: "الأقدم أولاً",
  clinic_sort_status: "الحالة",
  clinic_add_button: "إضافة عيادة جديدة",
  th_clinic_name: "اسم العيادة",
  th_location: "الموقع",
  th_phone: "رقم الهاتف",
  th_consultation_fee: "سعر الكشف",
  th_working_days: "أيام العمل",
  th_status: "الحالة",
  th_actions: "الإجراءات",
  modal_add_clinic_title: "إضافة عيادة جديدة",
  modal_edit_clinic_title: "تعديل العيادة",
  modal_step_1: "معلومات العيادة",
  modal_step_2: "جدول العمل",
  modal_step_3: "أوقات الاستراحة",
  modal_step_4: "موظفو الاستقبال",
  modal_step_5: "إعدادات الحجز",
  btn_back: "← السابق",
  btn_next: "التالي",
  btn_cancel: "إلغاء",
  btn_save_changes: "✓ حفظ التغييرات",
  btn_update_clinic: "✓ تحديث العيادة",
  lbl_clinic_name: "اسم العيادة",
  lbl_phone: "رقم الهاتف",
  lbl_governorate: "المحافظة",
  lbl_city: "المدينة",
  lbl_address: "العنوان التفصيلي",
  lbl_consultation_fee: "سعر الكشف (جنيه)",
  ph_select_governorate: "اختر المحافظة",
  ph_select_city: "اختر المدينة",
  ph_clinic_name: "مثال: عيادة الرعاية الصحية",
  ph_phone: "٠١xxxxxxxxx",
  ph_address: "رقم المبنى، اسم الشارع...",
  ph_fee: "مثال: ٣٠٠",
  val_clinic_name_req: "اسم العيادة مطلوب",
  val_clinic_name_min: "يجب أن يكون اسم العيادة حرفين على الأقل",
  val_clinic_name_max: "يجب ألا يتجاوز اسم العيادة 50 حرفاً",
  val_clinic_name_spaces: "لا يمكن أن يحتوي اسم العيادة على مسافات متتالية",
  val_clinic_name_invalid: "اسم العيادة يحتوي على رموز غير صالحة",
  val_phone_req: "رقم الهاتف مطلوب ويجب أن يكون 11 رقماً صحيحاً",
  val_governorate_req: "المحافظة مطلوبة",
  val_city_req: "المدينة مطلوبة",
  val_address_req: "العنوان التفصيلي مطلوب",
  val_address_min: "يجب أن يكون العنوان حرفين على الأقل",
  val_address_max: "يجب ألا يتجاوز العنوان 100 حرف",
  val_address_spaces: "لا يمكن أن يحتوي العنوان على مسافات متتالية",
  val_address_trailing: "لا يمكن أن ينتهي العنوان بمسافات",
  val_address_invalid: "العنوان يحتوي على رموز غير صالحة",
  val_fee_req: "سعر الكشف مطلوب ويجب أن يكون رقماً موجباً",
  modal_add_success_title: "تمت إضافة العيادة بنجاح!",
  modal_add_success_desc: "تم إنشاء وتسجيل العيادة الجديدة بنجاح في النظام.",
  modal_edit_success_title: "تم تحديث العيادة بنجاح!",
  modal_edit_success_desc: "تم تحديث تفاصيل العيادة بنجاح.",
  modal_delete_title: "حذف العيادة؟",
  modal_delete_desc: "هل أنت تأكد من أنك تريد حذف هذه العيادة؟ لا يمكن التراجع عن هذا الإجراء.",
  modal_delete_success_title: "تم حذف العيادة",
  modal_delete_success_desc: "تمت إزالة العيادة بنجاح.",
  modal_unsaved_title: "تغييرات غير محفوظة",
  modal_unsaved_desc: "لديك تغييرات غير محفوظة. هل أنت تأكد من الخروج؟",
  btn_stay: "البقاء والمتابعة",
  btn_leave: "التجاهل والخروج",
  btn_done: "تم",
  btn_confirm_delete: "حذف",
  state_empty_title: "لم يتم العثور على عيادات",
  state_empty_desc: "لم تقم بـإضافة أي عيادات بعد. انقر على 'إضافة عيادة جديدة' للبدء.",
  state_error_title: "لا توجد نتائج مطابقة",
  state_error_desc: "لا توجد عيادات تطابق معايير البحث أو التصفية الحالية.",
  state_loading: "جاري تحميل العيادات...",
  pagination_previous: "السابق",
  pagination_next: "التالي",
};


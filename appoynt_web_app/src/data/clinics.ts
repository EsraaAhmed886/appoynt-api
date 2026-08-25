/**
 * File Name : clinics.ts
 * Author : shimaa salah
 * Created Date : 2026-07-04
 * Version : v1.1.0
 * Dependencies : None
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Initial seed database records for system clinics.
 */

export const clinics = [
  {
    id: 1,
    doctor_id: "doc_1",
    name: "Smile Dental Clinic",
    location: "Cairo, Nasr City, Abbas Al Akkad St.",
    phone: "01012345678",
    consultation_fee: "300 EGP",
    consultationFee: "300 EGP",
    working_days: "Sat, Sun, Mon, Tue, Wed",
    workingDays: "Sat, Sun, Mon, Tue, Wed",
    status: "Active",
    schedule_list: [
      { day: "Sat", startTime: "09:00 AM", endTime: "05:00 PM" },
      { day: "Sun", startTime: "09:00 AM", endTime: "09:00 PM" },
      { day: "Mon", startTime: "09:00 AM", endTime: "05:00 PM" },
      { day: "Tue", startTime: "09:00 AM", endTime: "05:00 PM" },
      { day: "Wed", startTime: "09:00 AM", endTime: "05:00 PM" },
    ],
    break_list: [
      { day: "Sat", breakStart: "01:00 PM", breakEnd: "02:00 PM" },
    ],
    assigned_receptionists: [
      { id: "1", name: "Aya Samir", phone: "01023456789", status: "Active", initials: "AS" },
    ],
    appointment_duration: "30 Minutes",
    max_advance_booking: "30 Days",
  },
  {
    id: 2,
    doctor_id: "doc_2",
    name: "Care Medical Center",
    location: "Maadi",
    phone: "01198765432",
    consultation_fee: "250 EGP",
    consultationFee: "250 EGP",
    working_days: "Sun, Mon, Tue, Wed, Thu",
    workingDays: "Sun, Mon, Tue, Wed, Thu",
    status: "Inactive",
    schedule_list: [
      { day: "Sun", startTime: "10:00 AM", endTime: "04:00 PM" },
    ],
    break_list: [],
    assigned_receptionists: [],
    appointment_duration: "45 Minutes",
    max_advance_booking: "14 Days",
  },
  {
    id: 3,
    doctor_id: "doc_1",
    name: "Elite Clinic",
    location: "",
    phone: "01234567890",
    consultation_fee: "",
    consultationFee: "",
    working_days: "",
    workingDays: "",
    status: "Active",
    schedule_list: [],
    break_list: [],
    assigned_receptionists: [],
    appointment_duration: "",
    max_advance_booking: "",
  },
];
/**
 * File Name : clinic_view_edit_page.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, @/hooks/use_clinic_form, @/components/clinics/*, @/components/common/*
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Central Orchestrator component for Clinic View/Edit page rendering 5 vertical sections, sticky action bar, and modal workflows.
 */

"use client";

import { useRouter } from "next/navigation";
import ClinicDetailsHeader from "./clinic_details_header";
import ClinicInfoSection from "./sections/clinic_info_section";
import WorkingScheduleSection from "./sections/working_schedule_section";
import BreakTimesSection from "./sections/break_times_section";
import ReceptionistsSection from "./sections/receptionists_section";
import BookingSettingsSection from "./sections/booking_settings_section";
import ConflictDialog from "./conflict_dialog";
import UnsavedChangesModal from "@/components/common/unsaved_changes_modal";
import SuccessModal from "@/components/common/success_modal";
import { use_clinic_form } from "@/hooks/use_clinic_form";

type ClinicViewEditPageProps = {
  clinic_id: number;
};

export default function ClinicViewEditPage({
  clinic_id,
}: ClinicViewEditPageProps) {
  const router = useRouter();
  const {
    is_loaded,
    is_unsaved_modal_open,
    is_conflict_modal_open,
    is_success_modal_open,
    doctor_occupied_days,
    doctor_other_schedules,
    is_editing_info,
    is_editing_schedule,
    is_editing_breaks,
    is_editing_receptionists,
    is_editing_booking,
    is_info_dirty,
    is_schedule_dirty,
    is_breaks_dirty,
    is_receptionists_dirty,
    is_booking_dirty,
    form,
    actions,
  } = use_clinic_form(clinic_id);

  const is_any_dirty =
    is_info_dirty ||
    is_schedule_dirty ||
    is_breaks_dirty ||
    is_receptionists_dirty ||
    is_booking_dirty;

  const handle_back_click = (e: React.MouseEvent) => {
    if (is_any_dirty) {
      e.preventDefault();
      actions.openUnsavedModal();
    } else {
      // No action needed
    }
  };

  const handle_leave_unsaved = () => {
    actions.confirmDiscardChanges();
    router.push("/clinics");
  };

  if (!is_loaded) {
    return (
      <div className="flex min-h-[400px] items-center justify-center">
        <div className="text-center space-y-3">
          <div className="h-8 w-8 animate-spin rounded-full border-4 border-app-primary border-t-transparent mx-auto" />
          <p className="text-sm font-medium text-app-text-secondary">Loading clinic details...</p>
        </div>
      </div>
    );
  } else {
    // No action needed
  }

  const clinic_code = `CLN-${String(clinic_id).padStart(3, "0")}`;

  return (
    <div className="mx-auto max-w-7xl space-y-6 pb-20">
      {/* Page Header (No Top Edit Button) */}
        <ClinicDetailsHeader
          clinic_name={form.clinicName}
          status={form.status}
          clinic_code={clinic_code}
          on_back_click={handle_back_click}
        />

        {/* Section 1: Clinic Information */}
        <ClinicInfoSection
          is_edit_mode={is_editing_info}
          is_card_dirty={is_info_dirty}
          editing_clinic_id={clinic_id}
          form={form}
          actions={actions}
          on_toggle_edit={actions.toggleEditInfo}
          on_cancel={actions.cancelInfo}
          on_save={actions.saveInfoCard}
        />

        {/* Section 2: Working Schedule */}
        <WorkingScheduleSection
          is_edit_mode={is_editing_schedule}
          is_card_dirty={is_schedule_dirty}
          schedule_list={form.scheduleList}
          schedule_error={form.scheduleError}
          doctor_occupied_days={doctor_occupied_days}
          doctor_other_schedules={doctor_other_schedules}
          on_add_schedule={actions.addSchedule}
          on_edit_schedule={actions.editSchedule}
          on_delete_schedule={actions.deleteSchedule}
          on_toggle_edit={actions.toggleEditSchedule}
          on_cancel={actions.cancelSchedule}
          on_save={actions.saveScheduleCard}
        />

        {/* Section 3: Break Times */}
        <BreakTimesSection
          is_edit_mode={is_editing_breaks}
          is_card_dirty={is_breaks_dirty}
          break_list={form.breakList}
          available_working_days={form.scheduleList.map((s) => s.day)}
          schedule_list={form.scheduleList}
          on_add_break={actions.addBreak}
          on_edit_break={actions.editBreak}
          on_delete_break={actions.deleteBreak}
          on_toggle_edit={actions.toggleEditBreaks}
          on_cancel={actions.cancelBreaks}
          on_save={actions.saveBreaksCard}
        />

        {/* Section 4: Receptionists */}
        <ReceptionistsSection
          is_edit_mode={is_editing_receptionists}
          is_card_dirty={is_receptionists_dirty}
          assigned_receptionists={form.assignedReceptionists}
          on_update_assigned={actions.setAssignedReceptionists}
          on_toggle_edit={actions.toggleEditReceptionists}
          on_cancel={actions.cancelReceptionists}
          on_save={actions.saveReceptionistsCard}
        />

        {/* Section 5: Booking Settings */}
        <BookingSettingsSection
          is_edit_mode={is_editing_booking}
          is_card_dirty={is_booking_dirty}
          appointment_duration={form.appointmentDuration}
          max_advance_booking={form.maxAdvanceBooking}
          set_appointment_duration={actions.setAppointmentDuration}
          set_max_advance_booking={actions.setMaxAdvanceBooking}
          on_mark_dirty={actions.markAsDirty}
          on_toggle_edit={actions.toggleEditBooking}
          on_cancel={actions.cancelBooking}
          on_save={actions.saveBookingCard}
        />

        {/* Patient Appointment Conflict Dialog */}
        <ConflictDialog
          is_open={is_conflict_modal_open}
          on_close={actions.closeConflictModal}
          on_confirm_reschedule={() => {
            actions.closeConflictModal();
            actions.executeSave();
          }}
        />

        {/* Unsaved Changes Warning Modal */}
        <UnsavedChangesModal
          is_open={is_unsaved_modal_open}
          on_stay={actions.closeUnsavedModal}
          on_leave={handle_leave_unsaved}
        />

        {/* Save Success Modal */}
        <SuccessModal
          is_open={is_success_modal_open}
          on_close={actions.closeSuccessModal}
        />
      </div>
  );
}

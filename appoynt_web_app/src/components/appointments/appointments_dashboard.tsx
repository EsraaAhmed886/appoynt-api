/*
 * File Name: appointments_dashboard.tsx
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.5.0
 * Dependencies: react, @/context/language_context, @/services/appointment.service, @/types/appointment, @/hooks/use_consultation_timer, @/components/common/loading_state, @/components/common/error_state
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Interactive client dashboard container orchestrating appointments state, service calls, 10-min min duration & 5-min warning rules, and manual end consultation workflow.
 */

"use client";

import { useEffect, useState } from "react";
import { useTranslation } from "@/context/language_context";
import { appointment_service } from "@/services/appointment.service";
import { appointments_data_response } from "@/types/appointment";
import { use_consultation_timer } from "@/hooks/use_consultation_timer";
import LoadingState from "@/components/common/loading_state";
import ErrorState from "@/components/common/error_state";
import ActiveConsultationCard from "./active_consultation_card";
import AppointmentQueueList from "./appointment_queue_list";
import TimeSlotsPanel from "./time_slots_panel";
import ConfirmEndModal from "./confirm_end_modal";

export default function AppointmentsDashboard() {
  const { translations } = useTranslation();

  // Dashboard component states using snake_case
  const [appointments_data, set_appointments_data] =
    useState<appointments_data_response | null>(null);
  const [is_loading, set_is_loading] = useState<boolean>(true);
  const [has_error, set_has_error] = useState<boolean>(false);
  const [toast_message, set_toast_message] = useState<string | null>(null);

  // Modal interaction states
  const [is_end_modal_open, set_is_end_modal_open] = useState<boolean>(false);
  const [is_submitting_end, set_is_submitting_end] = useState<boolean>(false);

  // Track active consultation ID to fire 5-minute warning notification only once per patient
  const [warning_consultation_id, set_warning_consultation_id] = useState<
    string | null
  >(null);

  const active_consultation = appointments_data?.active_consultation;
  const timer_data = use_consultation_timer(active_consultation?.started_at);

  // Fetch initial appointments data from service layer
  const fetch_dashboard_data = async () => {
    set_is_loading(true);
    set_has_error(false);
    try {
      const response = await appointment_service.get_appointments_by_date();
      set_appointments_data(response);
    } catch (fetch_err) {
      console.error("Failed to fetch appointments dashboard data:", fetch_err);
      set_has_error(true);
    } finally {
      set_is_loading(false);
    }
  };

  useEffect(() => {
    fetch_dashboard_data();
  }, []);

  // Handle Toast notification auto-dismissal
  useEffect(() => {
    if (null !== toast_message) {
      const timer_id = setTimeout(() => {
        set_toast_message(null);
      }, 4000);
      return () => {
        clearTimeout(timer_id);
      };
    } else {
      // No active toast notification
    }
  }, [toast_message]);

  // Monitor consultation 5-minute warning threshold notification
  useEffect(() => {
    if (null === active_consultation || undefined === active_consultation) {
      return;
    } else {
      const slot_duration_mins =
        active_consultation.patient.visit_duration_mins ?? 30;
      const max_duration_seconds = slot_duration_mins * 60;
      const warning_threshold_seconds = Math.max(0, max_duration_seconds - 300);

      // Trigger 5-minute warning notification ONCE per active consultation session
      if (
        timer_data.elapsed_seconds >= warning_threshold_seconds &&
        timer_data.elapsed_seconds < max_duration_seconds &&
        warning_consultation_id !== active_consultation.consultation_id
      ) {
        set_warning_consultation_id(active_consultation.consultation_id);
        set_toast_message(translations.toast_5min_warning);
      } else {
        // Warning threshold not reached or already notified
      }
    }
  }, [
    timer_data.elapsed_seconds,
    active_consultation,
    warning_consultation_id,
    translations,
  ]);

  // Submit consultation completion request manually by doctor action
  const handle_confirm_end_consultation = async () => {
    if (
      null === appointments_data ||
      null === appointments_data.active_consultation
    ) {
      set_is_end_modal_open(false);
    } else {
      set_is_submitting_end(true);
      try {
        const active_id = appointments_data.active_consultation.consultation_id;
        const result = await appointment_service.end_consultation(active_id);

        if (true === result.success) {
          set_appointments_data(result.data);
          set_toast_message(translations.toast_consultation_ended);
        } else {
          set_toast_message(translations.toast_consultation_end_failed);
        }
      } catch (end_err) {
        console.error("Error ending consultation:", end_err);
        set_toast_message(translations.toast_consultation_end_failed);
      } finally {
        set_is_submitting_end(false);
        set_is_end_modal_open(false);
      }
    }
  };

  // Handle Loading UI State using existing LoadingState component
  if (true === is_loading) {
    return (
      <div className="w-full p-4 space-y-6">
        <LoadingState variant="list" rows={5} />
      </div>
    );
  } else {
    // No action needed
  }

  // Handle Error UI State using existing ErrorState component with Retry action
  if (true === has_error || null === appointments_data) {
    return (
      <div className="w-full flex flex-col items-center justify-center p-8 space-y-4">
        <ErrorState />
        <button
          type="button"
          onClick={fetch_dashboard_data}
          className="px-6 py-2.5 rounded-xl bg-app-primary text-white font-medium hover:opacity-90 transition shadow-xs"
        >
          {translations.btn_retry ?? "Retry"}
        </button>
      </div>
    );
  } else {
    // No action needed
  }

  return (
    <div className="w-full space-y-6 pb-8">
      {/* Toast Notification Banner */}
      {null !== toast_message ? (
        <div className="fixed bottom-6 right-6 z-50 flex items-center gap-3 px-5 py-3 rounded-xl bg-gray-900 text-white text-sm font-medium shadow-xl border border-gray-700 animate-bounce">
          <span>{toast_message}</span>
          <button
            type="button"
            onClick={() => set_toast_message(null)}
            className="text-gray-400 hover:text-white"
          >
            &times;
          </button>
        </div>
      ) : null}

      {/* Main Grid Layout: 2 Columns on Desktop (lg:12), Single Column on Mobile */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        {/* Left Column (8 cols on desktop): Active Consultation & Queue List */}
        <div className="lg:col-span-8 space-y-6">
          <ActiveConsultationCard
            consultation={appointments_data.active_consultation}
            on_end_click={() => set_is_end_modal_open(true)}
          />

          <AppointmentQueueList queue={appointments_data.queue} />
        </div>

        {/* Right Column (4 cols on desktop): Rigid Sticky Time Slots Panel */}
        <div className="lg:col-span-4 lg:sticky lg:top-0 self-start">
          <TimeSlotsPanel
            selected_date={appointments_data.selected_date}
            time_slots={appointments_data.time_slots}
          />
        </div>
      </div>

      {/* End Consultation Confirmation Modal */}
      <ConfirmEndModal
        is_open={is_end_modal_open}
        is_submitting={is_submitting_end}
        on_close={() => set_is_end_modal_open(false)}
        on_confirm={handle_confirm_end_consultation}
      />
    </div>
  );
}

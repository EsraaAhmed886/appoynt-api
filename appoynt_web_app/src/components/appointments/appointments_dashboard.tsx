/*
 * File Name: appointments_dashboard.tsx
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.1.0
 * Dependencies: react, @/context/language_context, @/services/appointment.service, @/types/appointment, @/components/common/loading_state, @/components/common/error_state
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Interactive client dashboard container orchestrating appointments state, service calls, section layouts, and end consultation workflow.
 */

"use client";

import { useEffect, useState } from "react";
import { useTranslation } from "@/context/language_context";
import { appointment_service } from "@/services/appointment.service";
import { appointments_data_response } from "@/types/appointment";
import LoadingState from "@/components/common/loading_state";
import ErrorState from "@/components/common/error_state";
import ActiveConsultationCard from "./active_consultation_card";
import AppointmentQueueList from "./appointment_queue_list";
import TimeSlotsPanel from "./time_slots_panel";
import ConfirmEndModal from "./confirm_end_modal";

export default function AppointmentsDashboard() {
  const { translations } = useTranslation();

  // Dashboard component states using snake_case
  const [appointments_data, set_appointments_data] = useState<appointments_data_response | null>(null);
  const [is_loading, set_is_loading] = useState<boolean>(true);
  const [has_error, set_has_error] = useState<boolean>(false);
  const [toast_message, set_toast_message] = useState<string | null>(null);

  // Modal interaction states
  const [is_end_modal_open, set_is_end_modal_open] = useState<boolean>(false);
  const [is_submitting_end, set_is_submitting_end] = useState<boolean>(false);

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

  // Submit consultation completion request
  const handle_confirm_end_consultation = async () => {
    if (null === appointments_data || null === appointments_data.active_consultation) {
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
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column (8 cols on desktop): Active Consultation & Queue List */}
        <div className="lg:col-span-8 space-y-6">
          <ActiveConsultationCard
            consultation={appointments_data.active_consultation}
            on_end_click={() => set_is_end_modal_open(true)}
          />

          <AppointmentQueueList queue={appointments_data.queue} />
        </div>

        {/* Right Column (4 cols on desktop): Time Slots Panel */}
        <div className="lg:col-span-4">
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

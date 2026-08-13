/*
 * File Name: clinics_dashboard.tsx
 * Author: shimaa salah
 * Date of Creation: 05/08/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/components/clinics/*
 *   - @/services/clinic.service
 *   - @/types/clinic
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 13/08/2026]
 * File Description:
 *   Client Component managing clinic listings, responsive pagination, search,
 *   filtering, sorting, and modal triggers (Add, Delete, Delete Success).
 */

"use client";

import { useEffect, useState } from "react";
import ClinicTable from "@/components/clinics/clinic_table";
import ClinicToolbar from "@/components/clinics/clinic_toolbar";
import AddClinicModal from "@/components/clinics/add_clinic_modal";
import DeleteClinicModal from "@/components/common/confirm_dialog";
import DeleteSuccessModal from "@/components/common/delete_success_modal";
import EmptyState from "@/components/common/empty_state";
import ErrorState from "@/components/common/error_state";
import LoadingState from "@/components/common/loading_state";
import Pagination from "@/components/common/pagination";
import { Clinic } from "@/types/clinic";
import {
  get_clinics,
  add_clinic,
  delete_clinic,
  initialize_clinics,
} from "@/services/clinic.service";

export default function ClinicsDashboard() {
  const [is_add_clinic_open, set_is_add_clinic_open] = useState(false);
  const [is_delete_open, set_is_delete_open] = useState(false);
  const [is_delete_success_open, set_is_delete_success_open] = useState(false);

  const [is_loading, set_is_loading] = useState(true);
  const [selected_clinic_id, set_selected_clinic_id] = useState<number | null>(null);

  const [clinics, set_clinics] = useState<Clinic[]>([]);
  const [search_query, set_search_query] = useState("");
  const [status_filter, set_status_filter] = useState("All");
  const [sort_order, set_sort_order] = useState("default");
  const [current_page, set_current_page] = useState(1);
  const [clinics_per_page, set_clinics_per_page] = useState(12);

  useEffect(() => {
    initialize_clinics();
    set_clinics(get_clinics());

    const timer_id = setTimeout(() => {
      set_is_loading(false);
    }, 100);

    return () => {
      clearTimeout(timer_id);
    };
  }, []);

  useEffect(() => {
    const update_rows_per_page = () => {
      if (window.innerWidth < 640) {
        set_clinics_per_page(6);
      } else if (window.innerWidth < 1024) {
        set_clinics_per_page(9);
      } else {
        set_clinics_per_page(12);
      }
    };

    update_rows_per_page();
    window.addEventListener("resize", update_rows_per_page);

    return () => {
      window.removeEventListener("resize", update_rows_per_page);
    };
  }, []);

  useEffect(() => {
    set_current_page(1);
  }, [search_query, sort_order, status_filter]);

  const handle_add_clinic = (new_clinic: Clinic) => {
    const updated_clinics = add_clinic(new_clinic);
    set_clinics(updated_clinics);
  };

  const handle_delete_clinic = (clinic_id: number) => {
    const updated_clinics = delete_clinic(clinic_id);
    set_clinics(updated_clinics);
  };

  const filtered_clinics = clinics.filter((clinic) => {
    const search_value = search_query.trim().toLowerCase();
    const matches_search =
      "" === search_value ||
      clinic.name.toLowerCase().startsWith(search_value);

    const matches_status =
      "All" === status_filter || clinic.status === status_filter;

    return matches_search && matches_status;
  });

  let sorted_clinics = [...filtered_clinics];

  if ("asc" === sort_order) {
    sorted_clinics.sort((a, b) => a.name.localeCompare(b.name));
  } else if ("desc" === sort_order) {
    sorted_clinics.sort((a, b) => b.name.localeCompare(a.name));
  } else if ("newest" === sort_order) {
    sorted_clinics.sort((a, b) => b.id - a.id);
  } else if ("oldest" === sort_order) {
    sorted_clinics.sort((a, b) => a.id - b.id);
  } else if ("status" === sort_order) {
    sorted_clinics.sort((a, b) => a.status.localeCompare(b.status));
  } else {
    // Default sorting preserved
  }

  const total_pages = Math.ceil(sorted_clinics.length / clinics_per_page);
  const start_index = (current_page - 1) * clinics_per_page;
  const end_index = start_index + clinics_per_page;
  const current_clinics = sorted_clinics.slice(start_index, end_index);

  const handle_open_delete_modal = (clinic_id: number) => {
    set_selected_clinic_id(clinic_id);
    set_is_delete_open(true);
  };

  return (
    <div className="overflow-x-hidden px-4 sm:px-5 lg:px-6">
      <div className="mt-0">
        <ClinicToolbar
          on_add_clinic={() => set_is_add_clinic_open(true)}
          search={search_query}
          on_search_change={set_search_query}
          status_filter={status_filter}
          on_status_filter_change={set_status_filter}
          sort_order={sort_order}
          on_sort_change={set_sort_order}
        />

        {is_loading ? (
          <LoadingState />
        ) : 0 === clinics.length ? (
          <EmptyState />
        ) : filtered_clinics.length > 0 ? (
          <ClinicTable
            clinics={current_clinics}
            on_delete_clinic={handle_open_delete_modal}
          />
        ) : (
          <ErrorState />
        )}

        {total_pages > 1 ? (
          <Pagination
            current_page={current_page}
            total_pages={total_pages}
            on_page_change={set_current_page}
          />
        ) : null}

        <AddClinicModal
          is_open={is_add_clinic_open}
          existing_clinics={clinics}
          on_close={() => set_is_add_clinic_open(false)}
          on_add_clinic={handle_add_clinic}
        />

        <DeleteClinicModal
          is_open={is_delete_open}
          on_close={() => {
            set_is_delete_open(false);
            set_selected_clinic_id(null);
          }}
          on_delete={() => {
            if (null !== selected_clinic_id) {
              handle_delete_clinic(selected_clinic_id);
            } else {
              // No selected clinic id
            }

            set_is_delete_open(false);
            set_selected_clinic_id(null);
            set_is_delete_success_open(true);
          }}
        />

        <DeleteSuccessModal
          is_open={is_delete_success_open}
          on_close={() => set_is_delete_success_open(false)}
        />
      </div>
    </div>
  );
}

/*
 * File Name: clinic_toolbar.tsx
 * Author: shimaa salah
 * Date of Creation: 04/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/components/common/search_input
 *   - @/components/clinics/add_clinic_button
 *   - @/components/clinics/clinic_sort
 *   - @/components/clinics/status_filter
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Top action toolbar container placing search, filter, sort, and add clinic trigger controls.
 */

"use client";

import ClinicSearch from "@/components/common/search_input";
import AddClinicButton from "./add_clinic_button";
import ClinicSort from "./clinic_sort";
import StatusFilter from "./status_filter";

type ClinicToolbarProps = {
  on_add_clinic: () => void;
  search: string;
  on_search_change: (value: string) => void;
  status_filter: string;
  on_status_filter_change: (value: string) => void;
  sort_order: string;
  on_sort_change: (value: string) => void;
};

export default function ClinicToolbar({
  on_add_clinic,
  search,
  on_search_change,
  status_filter,
  on_status_filter_change,
  sort_order,
  on_sort_change,
}: ClinicToolbarProps) {
  return (
    <div className="relative z-10 mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
      <div className="flex flex-wrap items-center gap-3 md:gap-4">
        <ClinicSearch search={search} on_search_change={on_search_change} />

        <div className="flex items-center gap-3">
          <StatusFilter
            value={status_filter}
            on_change={on_status_filter_change}
          />
          <ClinicSort
            sort_order={sort_order}
            on_sort_change={on_sort_change}
          />
        </div>
      </div>

      <div className="self-start lg:self-auto">
        <AddClinicButton on_click={on_add_clinic} />
      </div>
    </div>
  );
}

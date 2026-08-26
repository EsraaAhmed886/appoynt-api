/*
 * File Name: use_consultation_timer.ts
 * Author: shimaa salah
 * Created Date: 18/08/2026
 * Version: v1.1.0
 * Dependencies: react
 * Contributors: [shimaa salah]
 * Last Modified: [shimaa salah - 19/08/2026]
 * Description: Language-independent custom React hook calculating real-time consultation elapsed duration formatted as HH:MM:SS.
 */

"use client";

import { useEffect, useState } from "react";

export function use_consultation_timer(started_at_iso?: string) {
  const [elapsed_seconds, set_elapsed_seconds] = useState<number>(0);

  useEffect(() => {
    if (undefined === started_at_iso || "" === started_at_iso) {
      set_elapsed_seconds(0);
    } else {
      const start_timestamp = new Date(started_at_iso).getTime();

      const calculate_elapsed = () => {
        const current_timestamp = new Date().getTime();
        const difference_seconds = Math.max(
          0,
          Math.floor((current_timestamp - start_timestamp) / 1000)
        );
        set_elapsed_seconds(difference_seconds);
      };

      calculate_elapsed();
      const interval_id = setInterval(calculate_elapsed, 1000);

      return () => {
        clearInterval(interval_id);
      };
    }
  }, [started_at_iso]);

  // Compute numerical components
  const hours = Math.floor(elapsed_seconds / 3600);
  const minutes = Math.floor((elapsed_seconds % 3600) / 60);
  const seconds = elapsed_seconds % 60;

  // Language-independent standard HH:MM:SS string formatting
  const formatted_hours = String(hours).padStart(2, "0");
  const formatted_minutes = String(minutes).padStart(2, "0");
  const formatted_seconds = String(seconds).padStart(2, "0");

  const formatted_time = `${formatted_hours}:${formatted_minutes}:${formatted_seconds}`;

  return {
    elapsed_seconds,
    hours,
    minutes,
    seconds,
    formatted_time,
  };
}

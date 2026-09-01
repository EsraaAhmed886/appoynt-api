/*
 * File Name: use_current_time.ts
 * Author: Antigravity
 * Date of Creation: 31/08/2026
 * Version Information: v1.0.0
 * Dependencies: react
 * File Description: Custom React hook providing real-time formatted local clock time derived directly from the user's browser/device.
 */

"use client";

import { useEffect, useState } from "react";

export function format_device_time(date: Date = new Date()): string {
  return date.toLocaleTimeString("en-US", {
    hour: "2-digit",
    minute: "2-digit",
    hour12: true,
  });
}

export function use_current_time(): string {
  const [current_time, set_current_time] = useState<string>(() => format_device_time());

  useEffect(() => {
    const update_time = () => {
      set_current_time(format_device_time());
    };

    // Immediately sync to current local device clock
    update_time();

    // Check clock every 1 second to transition smoothly as soon as the minute rolls over
    const interval_id = setInterval(update_time, 1000);

    return () => {
      clearInterval(interval_id);
    };
  }, []);

  return current_time;
}

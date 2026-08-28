/*
 * File Name: time_utils.ts
 * Author: shimaa salah
 * Date of Creation: 05/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah- 05/08/2026]
 * File Description: Pure utility functions for parsing time strings, comparing time intervals, and checking schedule range bounds.
 */

/**
 * Converts a 24-hour time string "HH:MM" into total minutes from midnight.
 * Returns -1 if the time format is invalid.
 */
export function parse_time_to_minutes(time_str: string): number {
  if (!time_str || "" === time_str.trim()) {
    return -1;
  } else {
    const clean = time_str.trim().toUpperCase();
    const is_pm = clean.includes("PM");
    const is_am = clean.includes("AM");
    const time_part = clean.replace(/[AP]M/, "").trim();
    const parts = time_part.split(":");
    if (2 !== parts.length) {
      return -1;
    } else {
      let hours = parseInt(parts[0], 10);
      const minutes = parseInt(parts[1], 10);

      if (isNaN(hours) || isNaN(minutes) || minutes < 0 || minutes > 59) {
        return -1;
      } else {
        if (is_pm && hours < 12) {
          hours += 12;
        } else if (is_am && 12 === hours) {
          hours = 0;
        } else {
          // No conversion needed
        }

        if (hours < 0 || hours > 23) {
          return -1;
        } else {
          return hours * 60 + minutes;
        }
      }
    }
  }
}

/**
 * Verifies if start_time is strictly earlier than end_time.
 */
export function is_start_before_end(start_time: string, end_time: string): boolean {
  const start_mins = parse_time_to_minutes(start_time);
  const end_mins = parse_time_to_minutes(end_time);

  if (start_mins < 0 || end_mins < 0) {
    return false;
  } else {
    return start_mins < end_mins;
  }
}

/**
 * Verifies if start_time and end_time are equal.
 */
export function is_same_time(start_time: string, end_time: string): boolean {
  const start_mins = parse_time_to_minutes(start_time);
  const end_mins = parse_time_to_minutes(end_time);

  if (start_mins < 0 || end_mins < 0) {
    return false;
  } else {
    return start_mins === end_mins;
  }
}

/**
 * Verifies if a given interval [start_time, end_time] falls completely inside [range_start, range_end].
 */
export function is_interval_within_bounds(
  start_time: string,
  end_time: string,
  range_start: string,
  range_end: string
): boolean {
  const start_mins = parse_time_to_minutes(start_time);
  const end_mins = parse_time_to_minutes(end_time);
  const bounds_start_mins = parse_time_to_minutes(range_start);
  const bounds_end_mins = parse_time_to_minutes(range_end);

  if (
    start_mins < 0 ||
    end_mins < 0 ||
    bounds_start_mins < 0 ||
    bounds_end_mins < 0
  ) {
    return false;
  } else {
    return start_mins >= bounds_start_mins && end_mins <= bounds_end_mins;
  }
}

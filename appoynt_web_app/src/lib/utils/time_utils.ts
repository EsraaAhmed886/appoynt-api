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
 * Converts a 24-hour ("HH:MM") or 12-hour ("hh:mm AM/PM") time string into total minutes from midnight.
 * Returns -1 if the time format is invalid.
 */
export function parse_time_to_minutes(time_str: string): number {
  if (!time_str || "" === time_str.trim()) {
    return -1;
  } else {
    const match = time_str.trim().match(/^(\d{1,2}):(\d{2})(?:\s*(AM|PM))?$/i);
    if (!match) {
      return -1;
    } else {
      let hours = parseInt(match[1], 10);
      const minutes = parseInt(match[2], 10);
      const modifier = match[3] ? match[3].toUpperCase() : null;

      if (isNaN(hours) || isNaN(minutes) || minutes < 0 || minutes > 59) {
        return -1;
      } else {
        if (null !== modifier) {
          if (hours < 1 || hours > 12) {
            return -1;
          } else if ("PM" === modifier && hours < 12) {
            hours += 12;
          } else if ("AM" === modifier && 12 === hours) {
            hours = 0;
          } else {
            // No action needed
          }
        } else {
          if (hours < 0 || hours > 23) {
            return -1;
          } else {
            // No action needed
          }
        }

        return hours * 60 + minutes;
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

/**
 * Verifies whether two time intervals strictly overlap.
 * Back-to-back intervals (e.g. 09:00-13:00 and 13:00-17:00) do NOT overlap and are allowed.
 */
export function do_time_intervals_overlap(
  start1: string,
  end1: string,
  start2: string,
  end2: string
): boolean {
  const s1 = parse_time_to_minutes(start1);
  const e1 = parse_time_to_minutes(end1);
  const s2 = parse_time_to_minutes(start2);
  const e2 = parse_time_to_minutes(end2);

  if (s1 < 0 || e1 < 0 || s2 < 0 || e2 < 0) {
    return false;
  } else {
    return s1 < e2 && e1 > s2;
  }
}

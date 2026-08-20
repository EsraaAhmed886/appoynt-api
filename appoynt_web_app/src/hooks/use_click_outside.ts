/*
 * File Name: use_click_outside.ts
 * Author: shimaa salah
 * Date of Creation: 20/07/2026
 * Version Information: V1.1.0
 * Dependencies:
 *   - react
 * Contributors: [shimaa salah, Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Custom React hook for detecting mouse click events outside a specified DOM reference element and triggering callback functions.
 */

import { RefObject, useEffect } from "react";

export function useClickOutside(
  ref: RefObject<HTMLElement | null>,
  onOutsideClick: () => void,
) {
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (ref.current && !ref.current.contains(event.target as Node)) {
        onOutsideClick();
      }
    };

    document.addEventListener("mousedown", handleClickOutside);

    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [ref, onOutsideClick]);
}

export default useClickOutside;

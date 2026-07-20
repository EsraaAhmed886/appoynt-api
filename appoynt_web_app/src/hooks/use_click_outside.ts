import { RefObject, useEffect } from "react";

export default function useClickOutside(
  ref: RefObject<HTMLElement | null>,
  onOutsideClick: () => void,
) {
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (ref.current && !ref.current.contains(event.target as Node)) {
        onOutsideClick();
      } else {
        // Click inside component
      }
    };

    document.addEventListener("mousedown", handleClickOutside);

    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [ref, onOutsideClick]);
}

/*
 * File Name: empty_state.tsx
 * Author: shimaa salah
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 05/08/2026]
 * File Description: Empty state display view when no clinic records are present.
 */

"use client";

import Image from "next/image";
import { useTranslation } from "@/context/language_context";

export default function EmptyState() {
  const { translations } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center px-6 py-12 text-center">
      <Image
        src="/images/empty_clinic.jpeg"
        alt="No Clinics"
        width={220}
        height={220}
        priority
      />

      <h2 className="mx-auto max-w-xs text-center text-3xl font-semibold leading-tight text-app-text-primary sm:max-w-md sm:text-4xl lg:max-w-none lg:text-5xl">
        {translations.state_empty_title}
      </h2>

      <p className="mx-auto mt-4 max-w-xs text-center text-base leading-relaxed text-app-text-secondary sm:max-w-md sm:text-lg">
        {translations.state_empty_desc}
      </p>
    </div>
  );
}
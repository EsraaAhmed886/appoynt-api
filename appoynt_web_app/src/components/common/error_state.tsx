/*
 * File Name: error_state.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 05/08/2026]
 * File Description: Error and empty search filter results feedback component.
 */

"use client";

import Image from "next/image";
import { useTranslation } from "@/context/language_context";

export default function ErrorState() {
  const { translations } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center py-20">
      <Image
        src="/images/no_search.jpeg"
        alt="No Search Results"
        width={220}
        height={220}
        priority
      />

      <h2 className="mt-8 text-3xl font-bold text-app-text-primary">
        {translations.state_error_title}
      </h2>

      <p className="mt-2 text-center text-lg text-app-text-secondary">
        {translations.state_error_desc}
      </p>
    </div>
  );
}
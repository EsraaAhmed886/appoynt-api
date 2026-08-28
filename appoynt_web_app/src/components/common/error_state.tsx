/*
 * File Name: error_state.tsx
 * Author: shimaa salah
 * Date of Creation: 05/08/2026
 * Version Information: V1.1.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - @/context/language_context
 * Contributors: [Shimaa Salah]
 * Last Modified Date: [Shimaa Salah - 28/08/2026]
 * File Description: Reusable error and empty search/filter results feedback component supporting configurable title and description strings.
 */

"use client";

import Image from "next/image";
import { useTranslation } from "@/context/language_context";

type ErrorStateProps = {
  title?: string;
  description?: string;
};

export default function ErrorState({ title, description }: ErrorStateProps) {
  const { translations } = useTranslation();

  const displayTitle: string = title || translations.state_error_title;
  const displayDescription: string = description || translations.state_error_desc;

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
        {displayTitle}
      </h2>

      <p className="mt-2 text-center text-lg text-app-text-secondary">
        {displayDescription}
      </p>
    </div>
  );
}
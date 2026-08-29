/*
 * File Name: empty_state.tsx
 * Author: shimaa salah
 * Date of Creation: 20/06/2026
 * Version Information: V1.1.0
 * Dependencies:
 *   - react
 *   - next/image
 *   - @/context/language_context
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 29/08/2026]
 * File Description: Reusable and customizable empty state component supporting custom icons, images, titles, descriptions, and action triggers.
 */

"use client";

import Image from "next/image";
import { useTranslation } from "@/context/language_context";

export type EmptyStateProps = {
  title?: string;
  description?: string;
  icon?: React.ReactNode;
  image_src?: string;
  image_alt?: string;
  action?: React.ReactNode;
  className?: string;
};

function DefaultClinicIllustration() {
  return (
    <div className="relative mb-5 flex h-28 w-28 items-center justify-center rounded-3xl bg-blue-50/80 p-4 dark:bg-blue-950/30 border border-blue-100/60 dark:border-blue-900/30 shadow-xs">
      <svg
        viewBox="0 0 64 64"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className="h-16 w-16"
      >
        {/* Clinic Building Body */}
        <rect x="14" y="22" width="36" height="34" rx="3" fill="#EBF3FE" stroke="#3B82F6" strokeWidth="2.5" />
        {/* Roof */}
        <path d="M8 24L32 8L56 24" stroke="#EF4444" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" fill="none" />
        {/* Medical Cross */}
        <rect x="29" y="15" width="6" height="14" rx="1.5" fill="#EF4444" />
        <rect x="25" y="19" width="14" height="6" rx="1.5" fill="#EF4444" />
        {/* Windows */}
        <rect x="19" y="30" width="7" height="7" rx="1.5" fill="#93C5FD" stroke="#3B82F6" strokeWidth="1.5" />
        <rect x="38" y="30" width="7" height="7" rx="1.5" fill="#93C5FD" stroke="#3B82F6" strokeWidth="1.5" />
        {/* Door */}
        <rect x="27" y="42" width="10" height="14" rx="2" fill="#3B82F6" />
        <circle cx="34.5" cy="49" r="1" fill="#FFFFFF" />
      </svg>
    </div>
  );
}

export default function EmptyState({
  title,
  description,
  icon,
  image_src,
  image_alt,
  action,
  className = "",
}: EmptyStateProps) {
  const { translations } = useTranslation();

  const display_title = title ?? translations.state_empty_title;
  const display_description = description ?? translations.state_empty_desc;

  return (
    <div className={`flex flex-col items-center justify-center px-6 py-12 text-center ${className}`}>
      {icon ? (
        <div className="relative mb-5 flex h-24 w-24 items-center justify-center rounded-3xl bg-blue-50/80 p-4 dark:bg-blue-950/40 border border-blue-100 dark:border-blue-900/40 text-app-primary shadow-xs">
          {icon}
        </div>
      ) : image_src ? (
        <div className="relative mb-5 flex items-center justify-center">
          <Image
            src={image_src}
            alt={image_alt || display_title}
            width={180}
            height={180}
            className="object-contain"
            priority
          />
        </div>
      ) : (
        <DefaultClinicIllustration />
      )}

      <h2 className="mx-auto max-w-xs text-center text-2xl font-bold leading-tight text-app-text-primary sm:max-w-md sm:text-3xl">
        {display_title}
      </h2>

      {display_description ? (
        <p className="mx-auto mt-3 max-w-xs text-center text-sm leading-relaxed text-app-text-secondary sm:max-w-md sm:text-base">
          {display_description}
        </p>
      ) : null}

      {action ? <div className="mt-5">{action}</div> : null}
    </div>
  );
}
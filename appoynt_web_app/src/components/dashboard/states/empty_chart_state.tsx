/*
 * File Name: empty_chart_state.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, next/link, @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Renders clean empty clinical state with call-to-action button when zero clinics or records exist (BR-31).
 */

import React from "react";
import Link from "next/link";
import { Building2, Plus } from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface EmptyChartStateProps {
  title_key?: string;
  show_add_cta?: boolean;
}

export const EmptyChartState: React.FC<EmptyChartStateProps> = ({
  title_key = "no_clinic_data",
  show_add_cta = true,
}) => {
  const { t } = useTranslation();

  return (
    <div className="flex flex-col items-center justify-center p-8 text-center min-h-[260px]">
      <div className="w-14 h-14 rounded-2xl bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400 flex items-center justify-center mb-3 shadow-xs">
        <Building2 className="w-7 h-7" />
      </div>
      <p className="text-sm font-medium text-gray-600 dark:text-gray-300 mb-4">
        {/* @ts-expect-error dynamic key resolution */}
        {t(title_key) || t("no_clinic_data")}
      </p>
      {show_add_cta ? (
        <Link
          href="/clinics"
          className="inline-flex items-center gap-1.5 px-4 py-2 text-xs font-semibold text-white bg-blue-600 hover:bg-blue-700 active:scale-95 rounded-xl shadow-xs transition-all"
        >
          <Plus className="w-3.5 h-3.5" />
          {t("add_first_clinic")}
        </Link>
      ) : null}
    </div>
  );
};

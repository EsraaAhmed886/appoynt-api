/*
 * File Name: kpi_card_item.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, @/types/dashboard, @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Individual clinical metric statistics card rendering color-themed icon blocks, large formatted metrics, and previous-day comparison badges (BR-23 to BR-27).
 */

import React from "react";
import { TrendingUp, TrendingDown, Minus } from "lucide-react";
import { ComparisonData } from "@/types/dashboard";
import { useTranslation } from "@/context/language_context";

interface KpiCardItemProps {
  title_key: string;
  value: string | number;
  icon: React.ReactNode;
  icon_bg_class: string;
  comparison?: ComparisonData;
  currency?: string;
  is_negative_allowed?: boolean;
}

export const KpiCardItem: React.FC<KpiCardItemProps> = ({
  title_key,
  value,
  icon,
  icon_bg_class,
  comparison,
  currency,
}) => {
  const { t } = useTranslation();

  // Render Comparison Badge strictly following BR-23 to BR-27
  const render_comparison_badge = () => {
    if (!comparison) return null;

    if (comparison.is_zero_previous) {
      return (
        <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 border border-emerald-200/60 dark:border-emerald-900/40">
          <TrendingUp className="w-3 h-3" />
          <span>{t("increased_from_zero")}</span>
        </span>
      );
    }

    if (comparison.is_no_change || comparison.change_pct === 0) {
      return (
        <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[11px] font-semibold bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 border border-gray-200 dark:border-gray-700">
          <Minus className="w-3 h-3" />
          <span>{t("no_change")}</span>
        </span>
      );
    }

    const pct = comparison.change_pct ?? 0;
    const is_positive = pct > 0;

    return (
      <span
        className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[11px] font-semibold border ${
          is_positive
            ? "bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400 border-emerald-200/60 dark:border-emerald-900/40"
            : "bg-red-50 dark:bg-red-950/40 text-red-700 dark:text-red-400 border-red-200/60 dark:border-red-900/40"
        }`}
      >
        {is_positive ? <TrendingUp className="w-3 h-3" /> : <TrendingDown className="w-3 h-3" />}
        <span>
          {is_positive ? `+${pct.toFixed(1)}%` : `${pct.toFixed(1)}%`}{" "}
          <span className="font-normal opacity-80">{t("from_yesterday")}</span>
        </span>
      </span>
    );
  };

  return (
    <div className="relative overflow-hidden rounded-2xl border border-gray-200/80 dark:border-gray-800 bg-white/90 dark:bg-gray-900/90 p-5 shadow-xs hover:shadow-md transition-all duration-200 flex flex-col justify-between">
      {/* Top Header: Icon + Badge */}
      <div className="flex items-center justify-between gap-2">
        <div className={`w-12 h-12 rounded-xl flex items-center justify-center shadow-xs shrink-0 ${icon_bg_class}`}>
          {icon}
        </div>
        {render_comparison_badge()}
      </div>

      {/* Metric Content */}
      <div className="mt-4">
        <p className="text-xs sm:text-sm font-semibold text-gray-500 dark:text-gray-400">
          {/* @ts-expect-error dynamic key */}
          {t(title_key) || title_key}
        </p>
        <div className="mt-1 flex items-baseline gap-1.5 flex-wrap">
          <span className="text-2xl sm:text-3xl font-extrabold tracking-tight text-gray-900 dark:text-white">
            {typeof value === "number" ? value.toLocaleString() : value}
          </span>
          {currency ? (
            <span className="text-xs sm:text-sm font-bold text-gray-500 dark:text-gray-400 uppercase">
              {currency}
            </span>
          ) : null}
        </div>
      </div>
    </div>
  );
};

/*
 * File Name: dashboard_skeleton.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Defines matching pulse/shimmer skeleton state loaders for KPI cards, clinic bar charts, and bottom dashboard widgets.
 */

import React from "react";

export const KpiCardSkeleton: React.FC = () => {
  return (
    <div className="rounded-2xl border border-gray-200/70 dark:border-gray-800 bg-white/80 dark:bg-gray-900/80 p-5 shadow-xs animate-pulse">
      <div className="flex items-center justify-between">
        <div className="w-12 h-12 rounded-xl bg-gray-200 dark:bg-gray-800" />
        <div className="w-20 h-5 rounded-full bg-gray-100 dark:bg-gray-800/60" />
      </div>
      <div className="mt-4 space-y-2">
        <div className="w-28 h-4 rounded bg-gray-200 dark:bg-gray-800" />
        <div className="w-36 h-8 rounded-lg bg-gray-300 dark:bg-gray-700" />
      </div>
    </div>
  );
};

export const ChartSkeleton: React.FC = () => {
  return (
    <div className="rounded-2xl border border-gray-200/70 dark:border-gray-800 bg-white/80 dark:bg-gray-900/80 p-6 shadow-xs animate-pulse space-y-6">
      <div className="flex items-center justify-between">
        <div className="space-y-2">
          <div className="w-40 h-5 rounded bg-gray-300 dark:bg-gray-700" />
          <div className="w-56 h-3.5 rounded bg-gray-200 dark:bg-gray-800" />
        </div>
        <div className="w-32 h-9 rounded-xl bg-gray-200 dark:bg-gray-800" />
      </div>
      <div className="h-64 flex items-end justify-between gap-3 pt-6 border-b border-gray-100 dark:border-gray-800">
        {[40, 65, 85, 30, 95, 50, 75, 45, 60, 35, 20].map((h, i) => (
          <div key={i} className="flex-1 flex flex-col items-center gap-2">
            <div
              style={{ height: `${h}%` }}
              className="w-full rounded-t-md bg-gray-200 dark:bg-gray-800"
            />
            <div className="w-6 h-3 rounded bg-gray-100 dark:bg-gray-800/50" />
          </div>
        ))}
      </div>
      <div className="flex justify-between items-center pt-2">
        <div className="w-32 h-4 rounded bg-gray-200 dark:bg-gray-800" />
        <div className="w-40 h-4 rounded bg-gray-200 dark:bg-gray-800" />
      </div>
    </div>
  );
};

export const WidgetSkeleton: React.FC = () => {
  return (
    <div className="rounded-2xl border border-gray-200/70 dark:border-gray-800 bg-white/80 dark:bg-gray-900/80 p-6 shadow-xs animate-pulse space-y-5">
      <div className="flex justify-between items-center">
        <div className="w-32 h-5 rounded bg-gray-300 dark:bg-gray-700" />
        <div className="w-16 h-4 rounded bg-gray-200 dark:bg-gray-800" />
      </div>
      <div className="space-y-4">
        {[1, 2, 3, 4, 5].map((i) => (
          <div key={i} className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-lg bg-gray-200 dark:bg-gray-800 shrink-0" />
            <div className="flex-1 space-y-1.5">
              <div className="w-3/4 h-3.5 rounded bg-gray-200 dark:bg-gray-800" />
              <div className="w-1/3 h-2.5 rounded bg-gray-100 dark:bg-gray-800/60" />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

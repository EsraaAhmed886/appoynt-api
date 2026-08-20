/*
 * File Name: receptionist_table_skeleton.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Accessible pulse animation table skeleton rendering placeholder rows during asynchronous data fetching.
 */

"use client";

import React from "react";

export default function ReceptionistTableSkeleton() {
  const rows = Array.from({ length: 5 });

  return (
    <div className="bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-xs overflow-hidden">
      <div className="overflow-x-auto">
        <table className="w-full text-xs text-start">
          <thead className="bg-slate-50 dark:bg-[#131E35] border-b-2 border-slate-200 dark:border-slate-800">
            <tr>
              <th className="py-3.5 px-4"><div className="h-4 w-24 bg-slate-200 dark:bg-slate-700 rounded animate-pulse" /></th>
              <th className="py-3.5 px-4"><div className="h-4 w-20 bg-slate-200 dark:bg-slate-700 rounded animate-pulse" /></th>
              <th className="py-3.5 px-4"><div className="h-4 w-24 bg-slate-200 dark:bg-slate-700 rounded animate-pulse" /></th>
              <th className="py-3.5 px-4"><div className="h-4 w-28 bg-slate-200 dark:bg-slate-700 rounded animate-pulse" /></th>
              <th className="py-3.5 px-4"><div className="h-4 w-16 bg-slate-200 dark:bg-slate-700 rounded animate-pulse" /></th>
              <th className="py-3.5 px-4"><div className="h-4 w-20 bg-slate-200 dark:bg-slate-700 rounded animate-pulse" /></th>
              <th className="py-3.5 px-4 text-end"><div className="h-4 w-14 ms-auto bg-slate-200 dark:bg-slate-700 rounded animate-pulse" /></th>
            </tr>
          </thead>
          <tbody className="divide-y-2 divide-slate-100 dark:divide-slate-800/80">
            {rows.map((_, idx) => (
              <tr key={idx} className="animate-pulse">
                <td className="py-4 px-4">
                  <div className="flex items-center gap-3">
                    <div className="w-9 h-9 rounded-full bg-slate-200 dark:bg-slate-700" />
                    <div className="space-y-1.5">
                      <div className="h-3.5 w-32 bg-slate-200 dark:bg-slate-700 rounded" />
                      <div className="h-2.5 w-20 bg-slate-100 dark:bg-slate-800 rounded" />
                    </div>
                  </div>
                </td>
                <td className="py-4 px-4">
                  <div className="h-5 w-24 bg-slate-200 dark:bg-slate-700 rounded-full" />
                </td>
                <td className="py-4 px-4">
                  <div className="h-3.5 w-28 bg-slate-200 dark:bg-slate-700 rounded" />
                </td>
                <td className="py-4 px-4">
                  <div className="flex items-center gap-1.5">
                    <div className="h-5 w-28 bg-slate-200 dark:bg-slate-700 rounded-full" />
                    <div className="h-5 w-8 bg-slate-100 dark:bg-slate-800 rounded-full" />
                  </div>
                </td>
                <td className="py-4 px-4">
                  <div className="h-5 w-16 bg-slate-200 dark:bg-slate-700 rounded-full" />
                </td>
                <td className="py-4 px-4">
                  <div className="h-3.5 w-20 bg-slate-200 dark:bg-slate-700 rounded" />
                </td>
                <td className="py-4 px-4 text-end">
                  <div className="flex items-center justify-end gap-2">
                    <div className="w-7 h-7 rounded-lg bg-slate-200 dark:bg-slate-700" />
                    <div className="w-7 h-7 rounded-lg bg-slate-200 dark:bg-slate-700" />
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

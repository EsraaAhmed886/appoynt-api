/*
 * File Name: component_error_state.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: react, lucide-react, @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Isolated per-component error fallback providing descriptive error text and an interactive retry trigger without triggering full page reloads.
 */

import React from "react";
import { AlertTriangle, RefreshCw } from "lucide-react";
import { useTranslation } from "@/context/language_context";

interface ComponentErrorStateProps {
  message_key?: string;
  on_retry: () => void | Promise<void>;
  height?: string;
}

export const ComponentErrorState: React.FC<ComponentErrorStateProps> = ({
  message_key = "error_title",
  on_retry,
  height = "min-h-[220px]",
}) => {
  const { t } = useTranslation();
  const [is_retrying, set_is_retrying] = React.useState(false);

  const handle_retry = async () => {
    set_is_retrying(true);
    try {
      await on_retry();
    } finally {
      set_is_retrying(false);
    }
  };

  return (
    <div
      className={`flex flex-col items-center justify-center p-6 text-center rounded-2xl border border-red-200/60 dark:border-red-900/40 bg-red-50/40 dark:bg-red-950/20 ${height}`}
    >
      <div className="w-12 h-12 rounded-full bg-red-100 dark:bg-red-900/50 flex items-center justify-center text-red-600 dark:text-red-400 mb-3 shadow-xs">
        <AlertTriangle className="w-6 h-6" />
      </div>
      <p className="text-sm font-medium text-gray-700 dark:text-gray-200 mb-4 max-w-xs">
        {/* @ts-expect-error dynamic key resolution */}
        {t(message_key) || t("error_title")}
      </p>
      <button
        type="button"
        onClick={handle_retry}
        disabled={is_retrying}
        className="inline-flex items-center gap-2 px-4 py-2 text-xs font-semibold rounded-xl text-white bg-red-600 hover:bg-red-700 active:scale-95 disabled:opacity-50 transition-all shadow-xs"
      >
        <RefreshCw className={`w-3.5 h-3.5 ${is_retrying ? "animate-spin" : ""}`} />
        {t("retry")}
      </button>
    </div>
  );
};

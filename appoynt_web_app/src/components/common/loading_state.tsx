type LoadingStateProps = {
  variant?: "list" | "table" | "spinner";
  rows?: number;
};

export default function LoadingState({
  variant = "list",
  rows = 5,
}: LoadingStateProps) {
  // 🔹 حالة القوائم والكروت (مثالية للإشعارات، المواعيد، الكروت)
  if (variant === "list") {
    return (
      <div className="w-full space-y-3">
        {Array.from({ length: rows }).map((_, index) => (
          <div
            key={index}
            className="flex items-center justify-between p-3.5 rounded-xl border border-app-border bg-app-surface/50 animate-pulse gap-3"
          >
            <div className="flex items-center gap-3 flex-1">
              <div className="h-9 w-9 rounded-xl bg-app-border flex-shrink-0" />
              <div className="space-y-2 flex-1">
                <div className="h-3.5 w-1/3 bg-app-border rounded" />
                <div className="h-3 w-2/3 bg-app-border/60 rounded" />
              </div>
            </div>
            <div className="h-3 w-16 bg-app-border/80 rounded flex-shrink-0" />
          </div>
        ))}
      </div>
    );
  }

  // 🔹 حالة Spinner بكس بسيط (في حال أردتِ لودر دائرى مركز)
  if (variant === "spinner") {
    return (
      <div className="flex items-center justify-center p-8 w-full">
        <div className="h-8 w-8 animate-spin rounded-full border-4 border-app-border border-t-app-primary" />
      </div>
    );
  }

  // 🔹 حالة الجدول (للصفحات اللي فيها جداول زي العيادات)
  return (
    <div className="mt-4 w-full overflow-x-auto rounded-xl border border-app-border bg-app-surface shadow-sm">
      <div className="p-4 space-y-4">
        {Array.from({ length: rows }).map((_, index) => (
          <div
            key={index}
            className="flex items-center justify-between border-b border-app-border/40 pb-3 last:border-0 animate-pulse gap-4"
          >
            <div className="h-3.5 w-28 bg-app-border rounded" />
            <div className="h-3.5 w-24 bg-app-border rounded" />
            <div className="h-3.5 w-20 bg-app-border rounded" />
            <div className="h-3.5 w-16 bg-app-border rounded" />
            <div className="h-3.5 w-12 bg-app-border rounded" />
          </div>
        ))}
      </div>
    </div>
  );
}
export default function LoadingState() {
  return (
    <div className="mt-6 overflow-x-auto rounded-xl border border-app-border bg-app-surface shadow-sm">
      <table className="min-w-[900px] w-full">
        <thead className="bg-app-input_fill">
          <tr className="text-left text-sm text-app-text-secondary">
            <th className="px-6 py-4">Clinic Name</th>
            <th className="px-6 py-4">Phone</th>
            <th className="px-6 py-4">Location</th>
            <th className="px-6 py-4">Price</th>
            <th className="px-6 py-4">Working Days</th>
            <th className="px-6 py-4">Status</th>
            <th className="px-6 py-4 text-center">Actions</th>
          </tr>
        </thead>

        <tbody>
          {Array.from({ length: 5 }).map((_, index) => (
            <tr key={index} className="border-t border-app-border">
              <td className="px-6 py-6">
                <div className="h-3 w-28 animate-pulse rounded bg-app-border" />
              </td>

              <td className="px-6 py-6">
                <div className="h-3 w-24 animate-pulse rounded bg-app-border" />
              </td>

              <td className="px-6 py-6">
                <div className="h-3 w-24 animate-pulse rounded bg-app-border" />
              </td>

              <td className="px-6 py-6">
                <div className="h-3 w-16 animate-pulse rounded bg-app-border" />
              </td>

              <td className="px-6 py-6">
                <div className="h-3 w-24 animate-pulse rounded bg-app-border" />
              </td>

              <td className="px-6 py-6">
                <div className="h-3 w-16 animate-pulse rounded bg-app-border" />
              </td>

              <td className="px-6 py-6">
                <div className="mx-auto h-3 w-20 animate-pulse rounded bg-app-border" />
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
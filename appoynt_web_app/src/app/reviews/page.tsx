/**
 * File Name : page.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-28
 * Version : v1.0.0
 * Dependencies : react, @/components/layout/dashboard_layout, @/components/reviews/reviews_dashboard, @/components/common/loading_state
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-28
 * Description : Server Component entry route for Doctor Reviews & Ratings (/reviews), mounting ReviewsDashboard within DashboardLayout and Suspense boundary.
 */

import React, { Suspense } from "react";
import DashboardLayout from "@/components/layout/dashboard_layout";
import ReviewsDashboard from "@/components/reviews/reviews_dashboard";
import LoadingState from "@/components/common/loading_state";

export default function ReviewsPage() {
  return (
    <DashboardLayout>
      <Suspense
        fallback={
          <div className="p-6 sm:p-8 max-w-7xl mx-auto">
            <LoadingState variant="list" rows={5} />
          </div>
        }
      >
        <ReviewsDashboard />
      </Suspense>
    </DashboardLayout>
  );
}

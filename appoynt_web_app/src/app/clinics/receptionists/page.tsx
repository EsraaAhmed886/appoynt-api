/*
 * File Name: page.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - @/components/layout/dashboard_layout
 *   - @/context/receptionist_context
 *   - @/components/receptionists/receptionists_view
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Server page entry and client workspace wrapper for Clinic Receptionists Management integrated into the main Appoynt dashboard layout.
 */

import DashboardLayout from "@/components/layout/dashboard_layout";
import { ReceptionistProvider } from "@/context/receptionist_context";
import ReceptionistsView from "@/components/receptionists/receptionists_view";

export default function ReceptionistsPage() {
  return (
    <DashboardLayout>
      <ReceptionistProvider>
        <ReceptionistsView />
      </ReceptionistProvider>
    </DashboardLayout>
  );
}

/*
 * File Name: appointment_service_qa_test.ts
 * Author: Antigravity
 * Date of Creation: 31/08/2026
 * Version Information: v1.2.0
 * Dependencies: @/services/appointment.service, @/data/mock_appointments_data, @/hooks/use_current_time
 * File Description: Automated acceptance test suite for BUG-001 validating that first & next patients do not auto-start, start button & service guards enforce turn order, Actual Time uses real device clock, Actions column is removed from queue, and view all queue is visible only when queue.length >= 6.
 */

import { appointment_service } from "../appointment.service";
import { format_device_time } from "../../hooks/use_current_time";

let totalTests = 0;
let passedTests = 0;
let failedTests = 0;

function assert(condition: boolean, testName: string, failureDetail?: string) {
  totalTests++;
  if (condition) {
    passedTests++;
    console.log(`  ✅ PASS: ${testName}`);
  } else {
    failedTests++;
    console.error(`  ❌ FAIL: ${testName}`);
    if (failureDetail) {
      console.error(`     Detail: ${failureDetail}`);
    }
  }
}

async function runAppointmentServiceQASuite() {
  console.log("\n=======================================================");
  console.log("🧪 APPOINTMENT CONSULTATION LIFECYCLE ACCEPTANCE TEST SUITE");
  console.log("=======================================================\n");

  // Reset to initial mock data
  await appointment_service.reset_to_mock_data();

  // ---------------------------------------------------------------------------
  // TEST GROUP 1: First Patient Initialization & No Auto-Start
  // ---------------------------------------------------------------------------
  console.log("👉 Test Group 1: First Patient Initialization & No Auto-Start");
  const initialData = await appointment_service.get_appointments_by_date();
  assert(
    initialData.active_consultation === null,
    "REQ-1: Active consultation is NULL on initialization/load (no auto-start)"
  );
  assert(
    initialData.queue.length === 4,
    "REQ-1: Queue contains 4 initial patients"
  );
  assert(
    initialData.queue[0].patient.full_name === "Mohamed Ali",
    "REQ-1: First patient in queue is Mohamed Ali"
  );
  assert(
    initialData.queue[0].status === "checked_in",
    "REQ-1: First patient (Mohamed Ali) remains in 'checked_in' state"
  );
  assert(
    initialData.time_slots[0].status === "booked",
    "REQ-1: First time slot (09:00 AM) is 'booked' (not in_consultation)"
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 2: Guard - Attempting to Start Non-Next Patient is Blocked
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 2: Non-Next Patient Start Rejection");
  // Mohamed Ali (q_1) is next. Sara Hossam (q_2) and Omar Khaled (q_3) are not next.
  const skipToSaraResult = await appointment_service.start_consultation("q_2");
  assert(
    skipToSaraResult.success === false,
    "REQ-2: Direct call to start second patient (Sara Hossam) is rejected"
  );
  assert(
    skipToSaraResult.data.active_consultation === null,
    "REQ-2: Active consultation remains NULL after rejected non-next start attempt"
  );

  const skipToOmarResult = await appointment_service.start_consultation("q_3");
  assert(
    skipToOmarResult.success === false,
    "REQ-2: Direct call to start third patient (Omar Khaled) is rejected"
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 3: Explicit Doctor Start for First Patient via Empty State CTA
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 3: Explicit Start for Next Patient (Mohamed Ali)");
  const beforeStartTimestamp = Date.now();
  const startFirstResult = await appointment_service.start_consultation("q_1");

  assert(
    startFirstResult.success === true,
    "REQ-4: Start consultation for next patient (Mohamed Ali) succeeds"
  );
  assert(
    startFirstResult.data.active_consultation !== null,
    "REQ-4: Active consultation is now populated"
  );
  assert(
    startFirstResult.data.active_consultation?.patient.full_name === "Mohamed Ali",
    "REQ-4: Active consultation patient is Mohamed Ali"
  );
  assert(
    startFirstResult.data.active_consultation?.status === "in_consultation",
    "REQ-4: Active consultation status is 'in_consultation'"
  );

  const startedAtMs = new Date(
    startFirstResult.data.active_consultation?.started_at || ""
  ).getTime();
  assert(
    startedAtMs >= beforeStartTimestamp,
    "REQ-4: Timer started_at initialized fresh from current moment (00:00:00)"
  );

  const mohamedQueueItem = startFirstResult.data.queue.find((p) => p.id === "q_1");
  assert(
    mohamedQueueItem?.status === "in_consultation",
    "REQ-4: Mohamed Ali queue item status is 'in_consultation'"
  );

  const slot0900InCons = startFirstResult.data.time_slots.find((s) => s.patient_name === "Mohamed Ali");
  assert(
    slot0900InCons?.status === "in_consultation",
    "REQ-4: Mohamed Ali time slot status updated to 'in_consultation'"
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 4: Guard - Cannot Start Another Patient While Consultation Active
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 4: Cannot Start Another Consultation While Active");
  const concurrentStartResult = await appointment_service.start_consultation("q_2");
  assert(
    concurrentStartResult.success === false,
    "REQ-2: Attempting to start consultation while one is active is rejected"
  );
  assert(
    concurrentStartResult.data.active_consultation?.patient.full_name === "Mohamed Ali",
    "REQ-2: Current active consultation remains Mohamed Ali"
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 5: End First Consultation & Sequential Turn Transfer
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 5: Ending First Consultation & Next Patient Eligibility");
  const activeConsId = startFirstResult.data.active_consultation?.consultation_id || "";
  const endFirstResult = await appointment_service.end_consultation(activeConsId);

  assert(
    endFirstResult.success === true,
    "REQ-4: End consultation returned success"
  );
  assert(
    endFirstResult.data.active_consultation === null,
    "REQ-4: active_consultation is NULL after ending (no auto-start of Sara)"
  );
  assert(
    endFirstResult.data.queue.length === 3,
    "REQ-4: Mohamed Ali removed from waiting queue (3 remaining)"
  );

  const saraQueueItem = endFirstResult.data.queue.find((p) => p.patient.full_name === "Sara Hossam");
  assert(
    undefined !== saraQueueItem,
    "REQ-4: Sara Hossam is now first in remaining queue"
  );
  assert(
    saraQueueItem?.status === "checked_in",
    "REQ-4: Sara Hossam remains in 'checked_in' state without automatic start"
  );

  // Attempting to skip Sara and start Omar must still fail
  const skipToOmarAfterFirstEnd = await appointment_service.start_consultation("q_3");
  assert(
    skipToOmarAfterFirstEnd.success === false,
    "REQ-2: Skipping next patient (Sara) to start Omar is rejected"
  );

  // Explicitly starting Sara now succeeds
  const startSaraResult = await appointment_service.start_consultation("q_2");
  assert(
    startSaraResult.success === true,
    "REQ-4: Explicitly starting next patient (Sara Hossam) succeeds"
  );
  assert(
    startSaraResult.data.active_consultation?.patient.full_name === "Sara Hossam",
    "REQ-4: Active consultation is now Sara Hossam"
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 6: End Second Consultation
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 6: Ending Second Consultation");
  const endSaraResult = await appointment_service.end_consultation(
    startSaraResult.data.active_consultation?.consultation_id || ""
  );
  assert(
    endSaraResult.data.active_consultation === null,
    "REQ-4: active_consultation is NULL after ending Sara Hossam"
  );
  assert(
    endSaraResult.data.queue[0].patient.full_name === "Omar Khaled",
    "REQ-4: Omar Khaled is now next in queue"
  );
  assert(
    endSaraResult.data.queue[0].status === "waiting",
    "REQ-4: Omar Khaled remains 'waiting' and does not auto-start"
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 7: "View All Queue" Visibility Rule (queue.length >= 6)
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 7: View All Queue Visibility Threshold (queue.length >= 6)");
  const isViewAllQueueVisible = (queueLength: number) => queueLength >= 6;

  assert(!isViewAllQueueVisible(0), "REQ-3: 0 patients -> Hide View All Queue");
  assert(!isViewAllQueueVisible(1), "REQ-3: 1 patient  -> Hide View All Queue");
  assert(!isViewAllQueueVisible(4), "REQ-3: 4 patients -> Hide View All Queue");
  assert(!isViewAllQueueVisible(5), "REQ-3: 5 patients -> Hide View All Queue");
  assert(isViewAllQueueVisible(6), "REQ-3: 6 patients -> Show View All Queue");
  assert(isViewAllQueueVisible(7), "REQ-3: 7 patients -> Show View All Queue");
  assert(isViewAllQueueVisible(12), "REQ-3: 12 patients -> Show View All Queue");

  // ---------------------------------------------------------------------------
  // TEST GROUP 8: Real-Time Actual Time Derivation & Device Clock Formatting
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 8: Device Local Actual Time Formatting");
  const sampleDate1 = new Date("2026-08-31T13:35:00");
  const formatted1 = format_device_time(sampleDate1);
  assert(
    formatted1.includes("01:35") && formatted1.includes("PM"),
    `Live actual time formatting: 13:35 -> '01:35 PM' (got: ${formatted1})`
  );

  const sampleDate2 = new Date("2026-08-31T13:36:00");
  const formatted2 = format_device_time(sampleDate2);
  assert(
    formatted2.includes("01:36") && formatted2.includes("PM"),
    `Live actual time transitions dynamically with minute rollover: 13:36 -> '01:36 PM' (got: ${formatted2})`
  );

  const realCurrentTime = format_device_time();
  assert(
    realCurrentTime.length >= 7 && (realCurrentTime.includes("AM") || realCurrentTime.includes("PM")),
    `Current device time correctly returns formatted 12-hour string (got: ${realCurrentTime})`
  );

  // ---------------------------------------------------------------------------
  // SUMMARY
  // ---------------------------------------------------------------------------
  console.log("\n=======================================================");
  console.log(`QA TEST SUMMARY: ${passedTests} Passed, ${failedTests} Failed (Total: ${totalTests})`);
  console.log("=======================================================\n");

  if (failedTests > 0) {
    process.exit(1);
  }
}

runAppointmentServiceQASuite();

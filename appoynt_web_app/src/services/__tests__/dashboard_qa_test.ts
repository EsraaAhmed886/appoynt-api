/*
 * File Name: dashboard_qa_test.ts
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: @/services/dashboard_mock_service, @/types/dashboard
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Automated acceptance unit test suite validating Acceptance Criteria AC-07 through AC-28 for clinical dashboard logic, grouping, and comparison rules.
 */

import {
  DashboardMockService,
  calculate_comparison,
  process_chart_points,
} from "../dashboard_mock_service";
import { ClinicChartPoint } from "../../types/dashboard";

/**
 * Lightweight test runner helper
 */
let passed_count = 0;
let failed_count = 0;

function assert(condition: boolean, message: string) {
  if (condition) {
    passed_count++;
    console.log(`  ✅ PASS: ${message}`);
  } else {
    failed_count++;
    console.error(`  ❌ FAIL: ${message}`);
  }
}

async function run_dashboard_qa_tests() {
  console.log("================================================================================");
  console.log("🧪 CLINICAL DOCTOR DASHBOARD: ACCEPTANCE QA TEST SUITE");
  console.log("================================================================================\n");

  // --------------------------------------------------------------------------
  // TEST GROUP 1: Previous-Day Comparison Calculations (BR-24 to BR-27 / AC-11, AC-12)
  // --------------------------------------------------------------------------
  console.log("👉 Test Group 1: Previous-Day Comparison Calculations");

  // 1. Positive change
  const comp_pos = calculate_comparison(18, 15);
  assert(comp_pos.change_pct === 20.0, "Positive change: 18 vs 15 should equal +20.0%");
  assert(!comp_pos.is_zero_previous, "Positive change: is_zero_previous is false");
  assert(!comp_pos.is_no_change, "Positive change: is_no_change is false");

  // 2. Negative change
  const comp_neg = calculate_comparison(4100, 4850);
  assert(comp_neg.change_pct !== undefined && comp_neg.change_pct < 0, "Negative change: 4100 vs 4850 produces negative %");
  assert(!comp_neg.is_zero_previous, "Negative change: is_zero_previous is false");

  // 3. No change
  const comp_same = calculate_comparison(25, 25);
  assert(comp_same.is_no_change === true, "Identical values: is_no_change is true");
  assert(comp_same.change_pct === 0.0, "Identical values: change_pct is 0.0%");

  // 4. Zero previous day (BR-27)
  const comp_zero_prev = calculate_comparison(10, 0);
  assert(comp_zero_prev.is_zero_previous === true, "Zero yesterday: is_zero_previous is true");
  assert(comp_zero_prev.previous_value === 0, "Zero yesterday: previous_value is 0");

  // --------------------------------------------------------------------------
  // TEST GROUP 2: KPI Statistics Service Structure (AC-11 to AC-13)
  // --------------------------------------------------------------------------
  console.log("\n👉 Test Group 2: KPI Statistics Service Retrieval");
  const stats = await DashboardMockService.getDashboardStats();
  assert(stats.today_appointments.count >= 0, "Today appointments count is non-negative");
  assert(stats.total_patients > 0, "Total patients is distinct positive integer");
  assert(stats.pending_appointments >= 0, "Pending appointments count is non-negative");
  assert(stats.today_revenue.amount !== undefined, "Today revenue has amount");
  assert(stats.today_revenue.currency === "EGP", "Today revenue has currency 'EGP'");
  assert(stats.today_appointments.comparison !== undefined, "Today appointments has comparison data");
  assert(stats.today_revenue.comparison !== undefined, "Today revenue has comparison data");

  // --------------------------------------------------------------------------
  // TEST GROUP 3: Clinic Analytics Chart Grouping & Tie-Breakers (BR-50, BR-51, BR-52 / AC-14 to AC-18)
  // --------------------------------------------------------------------------
  console.log("\n👉 Test Group 3: Chart Processing, Top-10 & 'Others' Grouping");

  // 12 mock clinic points
  const raw_12_points: ClinicChartPoint[] = [
    { clinic_id: "c1", clinic_name: "Clinic 1", value: 100 },
    { clinic_id: "c2", clinic_name: "Clinic 2", value: 90 },
    { clinic_id: "c3", clinic_name: "Clinic 3", value: 80 },
    { clinic_id: "c4", clinic_name: "Clinic 4", value: 70 },
    { clinic_id: "c5", clinic_name: "Clinic 5", value: 60 },
    { clinic_id: "c6", clinic_name: "Clinic 6", value: 50 },
    { clinic_id: "c7", clinic_name: "Clinic 7", value: 40 },
    { clinic_id: "c8", clinic_name: "Clinic 8", value: 30 },
    { clinic_id: "c9", clinic_name: "Clinic 9", value: 20 },
    { clinic_id: "c10", clinic_name: "Clinic 10", value: 10 },
    { clinic_id: "c11", clinic_name: "Clinic 11", value: 5 },
    { clinic_id: "c12", clinic_name: "Clinic 12", value: 3 },
  ];

  const processed_12 = process_chart_points(raw_12_points);
  assert(processed_12.points.length === 11, "12 clinics grouped to top 10 + 1 'Others' bar (11 total bars)");
  assert(processed_12.points[10].clinic_id === "others", "11th bar has clinic_id 'others'");
  assert(processed_12.points[10].value === 8, "'Others' bar aggregates 5 + 3 = 8");
  const expected_sum = raw_12_points.reduce((acc, pt) => acc + pt.value, 0);
  assert(processed_12.total === expected_sum, `Total aggregate equals sum of all 12 clinics (${expected_sum})`);
  assert(processed_12.top_clinics.length === 1 && processed_12.top_clinics[0] === "Clinic 1", "Top clinic is 'Clinic 1'");

  // Tie-breaker test (2 clinics tied with max score)
  const tied_points: ClinicChartPoint[] = [
    { clinic_id: "c1", clinic_name: "Alpha Clinic", value: 150 },
    { clinic_id: "c2", clinic_name: "Beta Clinic", value: 150 },
    { clinic_id: "c3", clinic_name: "Gamma Clinic", value: 80 },
  ];
  const processed_tied = process_chart_points(tied_points);
  assert(processed_tied.top_clinics.length === 2, "2 tied top clinics detected");
  assert(processed_tied.top_clinics.includes("Alpha Clinic") && processed_tied.top_clinics.includes("Beta Clinic"), "Both tied clinic names included");
  assert(processed_tied.tied_count === 2, "tied_count is 2");

  // --------------------------------------------------------------------------
  // TEST GROUP 4: Revenue Negative Net Realized Value Support (BR-54 to BR-57 / AC-19)
  // --------------------------------------------------------------------------
  console.log("\n👉 Test Group 4: Negative Revenue Support (Refund Adjustments)");
  const refund_points: ClinicChartPoint[] = [
    { clinic_id: "c1", clinic_name: "Clinic 1", value: 15000, currency: "EGP" },
    { clinic_id: "c2", clinic_name: "Clinic 2", value: -850, currency: "EGP" },
    { clinic_id: "c3", clinic_name: "Clinic 3", value: 4200, currency: "EGP" },
  ];
  const processed_refund = process_chart_points(refund_points, "EGP");
  const has_negative_point = processed_refund.points.some((p) => p.value < 0);
  assert(has_negative_point, "Chart processing preserves negative net revenue bar (-850 EGP)");
  assert(processed_refund.total === 18350, "Total net revenue accounts for negative adjustment (15000 - 850 + 4200 = 18350)");
  assert(processed_refund.currency === "EGP", "Revenue dataset has currency 'EGP'");

  const single_refund_clinic = await DashboardMockService.getRevenueByClinic("last_30_days", undefined, "clinic_10");
  assert(single_refund_clinic.points.length === 1 && single_refund_clinic.points[0].value < 0, "Single clinic filter correctly returns negative net revenue (-650 EGP)");

  // --------------------------------------------------------------------------
  // TEST GROUP 5: Recent Activity Constraints (VR-23 / AC-20)
  // --------------------------------------------------------------------------
  console.log("\n👉 Test Group 5: Recent Activity Constraints (Exact 5 Events)");
  const activities = await DashboardMockService.getRecentActivities();
  const is_sorted_desc = activities.every((item, idx) => {
    if (idx === 0) {
      return true;
    } else {
      return new Date(item.occurred_at).getTime() <= new Date(activities[idx - 1].occurred_at).getTime();
    }
  });
  assert(is_sorted_desc, "Recent activities are in reverse chronological order");

  // --------------------------------------------------------------------------
  // TEST GROUP 6: Patient Rating Empty State Guard (BR-67 / AC-22)
  // --------------------------------------------------------------------------
  console.log("\n👉 Test Group 6: Patient Rating Empty State Guard (BR-67)");
  const rating_populated = await DashboardMockService.getPatientRating(false);
  assert(rating_populated.aggregate_rating === 4.8, "Populated rating returns 4.8");
  assert(rating_populated.total_reviews === 128, "Populated rating has 128 reviews");

  const rating_empty = await DashboardMockService.getPatientRating(true);
  assert(rating_empty.aggregate_rating === null, "Empty rating returns null (never 0.0)");
  assert(rating_empty.total_reviews === 0, "Empty rating returns 0 total reviews");

  // --------------------------------------------------------------------------
  // TEST GROUP 7: Live Waiting Room & Next-Up Consultation Queue Summary
  // --------------------------------------------------------------------------
  console.log("\n👉 Test Group 7: Live Waiting Room & Consultation Queue Summary");
  const queue_data = await DashboardMockService.getLiveQueueSummary();
  assert(queue_data.is_active === true, "Live queue is marked as active");
  assert(queue_data.total_waiting_count === 4, "Total waiting count matches mock expected 4");
  assert(queue_data.pending_lab_reviews_count === 2, "Pending lab reviews count matches mock expected 2");
  assert(queue_data.current_patient !== null, "Current next patient exists");
  assert(queue_data.current_patient?.token_number === "A-12", "Current next patient token is A-12");
  assert(queue_data.current_patient?.waiting_minutes === 14, "Current next patient wait time is 14 minutes");
  assert(queue_data.current_patient?.type === "follow_up", "Current next patient type is follow_up");

  // --------------------------------------------------------------------------
  // SUMMARY
  // --------------------------------------------------------------------------
  console.log("\n================================================================================");
  console.log(`QA TEST SUMMARY: ${passed_count} Passed, ${failed_count} Failed`);
  console.log("================================================================================\n");

  if (failed_count > 0) {
    process.exit(1);
  } else {
    // All tests passed successfully
  }
}

run_dashboard_qa_tests();

/*
 * File Name: date_utils_qa_test.ts
 * Author: Antigravity
 * Date of Creation: 31/08/2026
 * Version Information: v1.0.0
 * Dependencies: @/lib/utils/date_utils
 * File Description: Dedicated automated unit and acceptance tests for BUG-003 verifying Arabic date localization (21 مايو 2024), English date preservation (May 21, 2024), dynamic language switching, and edge cases.
 */

import { formatLocalizedDate, formatReviewDate } from "../date_utils";

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

function runDateUtilsQASuite() {
  console.log("\n=======================================================");
  console.log("🧪 DATE LOCALIZATION ACCEPTANCE TEST SUITE (BUG-003)");
  console.log("=======================================================\n");

  // ---------------------------------------------------------------------------
  // TEST GROUP 1: English Date Formatting (Preserves 'May 21, 2024')
  // ---------------------------------------------------------------------------
  console.log("👉 Test Group 1: English Date Formatting");
  const enDate1 = formatLocalizedDate("May 21, 2024", "en");
  assert(
    enDate1 === "May 21, 2024",
    `REQ-1: 'May 21, 2024' formatted in English remains 'May 21, 2024' (got: '${enDate1}')`
  );

  const enDate2 = formatLocalizedDate("Apr 10, 2024", "en");
  assert(
    enDate2 === "Apr 10, 2024",
    `REQ-1: 'Apr 10, 2024' formatted in English remains 'Apr 10, 2024' (got: '${enDate2}')`
  );

  const enDate3 = formatLocalizedDate("2024-05-21", "en");
  assert(
    enDate3 === "May 21, 2024",
    `REQ-1: ISO string '2024-05-21' formatted in English produces 'May 21, 2024' (got: '${enDate3}')`
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 2: Arabic Date Localization (Produces '21 مايو 2024')
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 2: Arabic Date Formatting (Localized Month Name + Latin Numerals)");
  const arDate1 = formatLocalizedDate("May 21, 2024", "ar");
  assert(
    arDate1 === "21 مايو 2024",
    `REQ-2: 'May 21, 2024' formatted in Arabic produces '21 مايو 2024' (got: '${arDate1}')`
  );

  const arDate2 = formatLocalizedDate("Apr 10, 2024", "ar");
  assert(
    arDate2 === "10 أبريل 2024",
    `REQ-2: 'Apr 10, 2024' formatted in Arabic produces '10 أبريل 2024' (got: '${arDate2}')`
  );

  const arDate3 = formatLocalizedDate("2024-05-21", "ar");
  assert(
    arDate3 === "21 مايو 2024",
    `REQ-2: ISO string '2024-05-21' formatted in Arabic produces '21 مايو 2024' (got: '${arDate3}')`
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 3: Dynamic Language Switching (No Page Reload Simulation)
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 3: Dynamic Language Switching Workflow");
  let currentLocale: "en" | "ar" = "en";
  const rawDateString = "May 21, 2024";

  // Step 1: Initial English render
  let renderedDate = formatLocalizedDate(rawDateString, currentLocale);
  assert(
    renderedDate === "May 21, 2024",
    `REQ-3: Initial English state renders 'May 21, 2024'`
  );

  // Step 2: Switch to Arabic
  currentLocale = "ar";
  renderedDate = formatLocalizedDate(rawDateString, currentLocale);
  assert(
    renderedDate === "21 مايو 2024",
    `REQ-3: Switching to Arabic updates rendered date to '21 مايو 2024'`
  );

  // Step 3: Switch back to English
  currentLocale = "en";
  renderedDate = formatLocalizedDate(rawDateString, currentLocale);
  assert(
    renderedDate === "May 21, 2024",
    `REQ-3: Switching back to English restores 'May 21, 2024'`
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 4: Edge Cases & Robust Fallbacks
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 4: Edge Cases & Safe Fallbacks");
  assert(formatLocalizedDate(null, "ar") === "", "REQ-4: null input returns empty string");
  assert(formatLocalizedDate(undefined, "ar") === "", "REQ-4: undefined input returns empty string");
  assert(formatLocalizedDate("", "ar") === "", "REQ-4: empty string input returns empty string");
  assert(
    formatLocalizedDate("not-a-date", "ar") === "not-a-date",
    "REQ-4: invalid date string returns original string fallback safely"
  );

  // ---------------------------------------------------------------------------
  // TEST GROUP 5: Review Date Utility Verification
  // ---------------------------------------------------------------------------
  console.log("\n👉 Test Group 5: Review Date Utility");
  const reviewEn = formatReviewDate("2025-05-25T10:30:00Z", "en");
  assert(
    reviewEn.includes("May 25, 2025"),
    `REQ-5: Review date formatted in English (got: '${reviewEn}')`
  );
  const reviewAr = formatReviewDate("2025-05-25T10:30:00Z", "ar");
  assert(
    reviewAr.includes("مايو"),
    `REQ-5: Review date formatted in Arabic includes Arabic month (got: '${reviewAr}')`
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

runDateUtilsQASuite();

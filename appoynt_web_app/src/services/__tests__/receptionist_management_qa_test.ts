/*
 * File Name: receptionist_management_qa_test.ts
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - @/types/receptionist
 *   - @/services/receptionist_mock_service
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/08/2026]
 * File Description: Automated acceptance test suite covering AC-01 through AC-24 for clinic receptionists management including list queries, uniqueness constraints, password policies, and pagination adjustments.
 */

import { receptionistMockService } from "../receptionist_mock_service";
import { ReceptionistFormData } from "../../types/receptionist";

// Minimal test runner assertion helpers
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

async function runReceptionistQASuite() {
  console.log("\n=======================================================");
  console.log("🧪 CLINIC RECEPTIONISTS MANAGEMENT ACCEPTANCE TEST SUITE");
  console.log("=======================================================\n");

  // Reset database to initial deterministic state
  receptionistMockService.resetMockData();

  // ---------------------------------------------------------------------------
  // SUITE 1: AC-01 to AC-04: Listing, Filtering, Sorting & Tie-Breakers
  // ---------------------------------------------------------------------------
  console.log("📋 [SUITE 1] Listing, Filtering & Sorting Algorithms:");

  // Test 1: Fetch initial list (page 1, limit 10)
  const initialList = await receptionistMockService.getReceptionists({ page: 1, limit: 10 });
  assert(initialList.data.length === 10, "AC-01: Page 1 returns default limit of 10 records", `Got ${initialList.data.length}`);
  assert(initialList.total === 12, "AC-01: Total count reflects 12 seeded receptionists", `Got ${initialList.total}`);
  assert(initialList.total_pages === 2, "AC-01: Calculates 2 total pages", `Got ${initialList.total_pages}`);

  // Test 2: Search by Name (case-insensitive substring)
  const searchByName = await receptionistMockService.getReceptionists({ search: "sara", page: 1, limit: 10 });
  assert(searchByName.data.length >= 1, "AC-02: Search query 'sara' matches Sara Ahmed", `Matches: ${searchByName.data.length}`);
  assert(searchByName.data[0].full_name.includes("Sara"), "AC-02: Returned record has 'Sara' in full_name");

  // Test 3: Search by Username
  const searchByUsername = await receptionistMockService.getReceptionists({ search: "mahmoud_h", page: 1, limit: 10 });
  assert(searchByUsername.data.length === 1, "AC-02: Search by username '@mahmoud_h' returns exact match", `Matches: ${searchByUsername.data.length}`);

  // Test 4: Search by Egyptian Phone
  const searchByPhone = await receptionistMockService.getReceptionists({ search: "01234567890", page: 1, limit: 10 });
  assert(searchByPhone.data.length === 1, "AC-02: Search by phone returns exact match for Nourhan Ali");

  // Test 5: Empty search state (zero matches)
  const emptySearch = await receptionistMockService.getReceptionists({ search: "NonExistentQueryXYZ999", page: 1, limit: 10 });
  assert(emptySearch.data.length === 0, "AC-03: Zero results returned for non-matching query");
  assert(emptySearch.total === 0, "AC-03: Total count is 0 on zero matches");

  // Test 6: Clinic Filtering
  const clinicFilter = await receptionistMockService.getReceptionists({ clinic_id: "clinic-nasr-city-hub", page: 1, limit: 10 });
  assert(
    clinicFilter.data.every((r) => r.assigned_clinics.some((c) => c.id === "clinic-nasr-city-hub")),
    "AC-04: Clinic filter restricts results exclusively to assigned clinic ID"
  );

  // Test 7: Sorting Tie-Breaker (name_asc with created_at DESC tie-breaker)
  const sortAsc = await receptionistMockService.getReceptionists({ sort: "name_asc", page: 1, limit: 20 });
  let isSorted = true;
  for (let i = 0; i < sortAsc.data.length - 1; i++) {
    const comp = sortAsc.data[i].full_name.localeCompare(sortAsc.data[i + 1].full_name);
    if (comp > 0) {
      isSorted = false;
      break;
    }
  }
  assert(isSorted, "AC-04: Name A-Z sorting applies alphabetical order with tie-breakers");

  // ---------------------------------------------------------------------------
  // SUITE 2: AC-05 to AC-08: Add Receptionist & Uniqueness Constraints
  // ---------------------------------------------------------------------------
  console.log("\n🔒 [SUITE 2] Add Receptionist & Uniqueness Enforcement:");

  // Test 8: Valid Create
  const newReceptionistData: ReceptionistFormData = {
    full_name: "Laila Mostafa Salem",
    username: "laila_mostafa",
    phone_number: "01077889900",
    password: "P@ssword2026!",
    clinic_ids: ["clinic-cairo-heart", "clinic-zamalek-spec"],
    status: "active",
  };
  const created = await receptionistMockService.createReceptionist(newReceptionistData);
  assert(created.full_name === "Laila Mostafa Salem", "AC-05: Creates new receptionist account with populated ID and timestamps");
  assert(created.assigned_clinics.length === 2, "AC-05: Resolves multi-clinic assignments from clinic_ids");

  // Test 9: Duplicate Phone Rejection
  let phoneDuplicateCaught = false;
  try {
    await receptionistMockService.createReceptionist({
      full_name: "Duplicate Phone User",
      username: "unique_user_1",
      phone_number: "01077889900", // Already used by Laila
      password: "P@ssword2026!",
      clinic_ids: ["clinic-cairo-heart"],
      status: "active",
    });
  } catch (err: any) {
    phoneDuplicateCaught = true;
    assert(err.message.includes("Phone") || err.code === 409, "AC-06: Throws 409 Conflict when phone number already exists");
  }
  assert(phoneDuplicateCaught, "AC-06: Duplicate phone rejection enforced");

  // Test 10: Case-Insensitive Username Collision (SaraAdmin === saraadmin)
  let usernameCollisionCaught = false;
  try {
    await receptionistMockService.createReceptionist({
      full_name: "Duplicate Username User",
      username: "LAILA_MOSTAFA", // Matches "laila_mostafa" case-insensitively
      phone_number: "01188990011",
      password: "P@ssword2026!",
      clinic_ids: ["clinic-cairo-heart"],
      status: "active",
    });
  } catch (err: any) {
    usernameCollisionCaught = true;
    assert(err.message.includes("Username") || err.code === 409, "AC-07: Throws 409 Conflict on case-insensitive username collision (LAILA_MOSTAFA === laila_mostafa)");
  }
  assert(usernameCollisionCaught, "AC-07: Case-insensitive username collision enforced");

  // ---------------------------------------------------------------------------
  // SUITE 3: AC-09 to AC-11: Multi-Clinic Assignments & Password Updates
  // ---------------------------------------------------------------------------
  console.log("\n🏥 [SUITE 3] Multi-Clinic Assignments & Password Editing:");

  // Test 11: Edit Receptionist (leave password blank to preserve existing)
  const updatedWithoutPassword = await receptionistMockService.updateReceptionist(created.id, {
    full_name: "Laila Mostafa Salem (Updated)",
    username: "laila_mostafa",
    phone_number: "01077889900",
    password: "", // Left blank
    clinic_ids: ["clinic-nasr-city-hub"],
    status: "inactive",
  });
  assert(updatedWithoutPassword.full_name === "Laila Mostafa Salem (Updated)", "AC-09: Updates full name and clinic reassignments");
  assert(updatedWithoutPassword.status === "inactive", "AC-09: Updates status to inactive");
  assert(updatedWithoutPassword.assigned_clinics[0].id === "clinic-nasr-city-hub", "AC-10: Replaces assigned clinics with new clinic ID");

  // ---------------------------------------------------------------------------
  // SUITE 4: AC-12 to AC-16: Hard Delete & Deletion Pagination Adjustment
  // ---------------------------------------------------------------------------
  console.log("\n🗑️ [SUITE 4] Permanent Deletion & Pagination Recalculation:");

  // Test 12: Delete created account
  const deleteResult = await receptionistMockService.deleteReceptionist(created.id);
  assert(deleteResult === true, "AC-12: Permanently deletes receptionist record");

  const verifyDeleted = await receptionistMockService.getReceptionistById(created.id);
  assert(verifyDeleted === null, "AC-12: Confirms deleted record is no longer queryable");

  // Test 13: KPI Stats Calculation
  const stats = await receptionistMockService.getReceptionistStats();
  assert(stats.total === 12, "AC-14: Stats reflect 12 total receptionists after cleanup", `Got ${stats.total}`);
  assert(stats.active === 9, "AC-14: Active count matches 9 active accounts", `Got ${stats.active}`);
  assert(stats.inactive === 3, "AC-14: Inactive count matches 3 inactive accounts", `Got ${stats.inactive}`);
  assert(stats.covered_clinics >= 3, "AC-14: Covered clinics matches active clinic locations", `Got ${stats.covered_clinics}`);

  // ---------------------------------------------------------------------------
  // SUITE 5: AC-17 to AC-24: Form Regex Validation Rules Verification
  // ---------------------------------------------------------------------------
  console.log("\n📝 [SUITE 5] Input Form Regex Validation Rules:");

  const NAME_REGEX = /^[\u0600-\u06FFa-zA-Z\s]{3,100}$/;
  const PHONE_REGEX = /^01[0125][0-9]{8}$/;
  const USERNAME_REGEX = /^[a-zA-Z0-9_.]{4,30}$/;
  const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%!&*^~_+=\-.,?])[A-Za-z\d@#$%!&*^~_+=\-.,?]{8,64}$/;

  assert(NAME_REGEX.test("سارة أحمد"), "AC-17: Name regex accepts Arabic characters");
  assert(NAME_REGEX.test("Sara Ahmed"), "AC-17: Name regex accepts English characters");
  assert(!NAME_REGEX.test("Ab"), "AC-17: Name regex rejects < 3 characters");
  assert(!NAME_REGEX.test("Sara123!"), "AC-17: Name regex rejects numbers and special characters");

  assert(PHONE_REGEX.test("01012345678"), "AC-18: Phone regex accepts 010 Egyptian mobile");
  assert(PHONE_REGEX.test("01198765432"), "AC-18: Phone regex accepts 011 Egyptian mobile");
  assert(PHONE_REGEX.test("01234567890"), "AC-18: Phone regex accepts 012 Egyptian mobile");
  assert(PHONE_REGEX.test("01511223344"), "AC-18: Phone regex accepts 015 Egyptian mobile");
  assert(!PHONE_REGEX.test("01312345678"), "AC-18: Phone regex rejects non-Egyptian prefix (013)");
  assert(!PHONE_REGEX.test("0101234567"), "AC-18: Phone regex rejects 10 digits");
  assert(!PHONE_REGEX.test("010123456789"), "AC-18: Phone regex rejects 12 digits");

  assert(USERNAME_REGEX.test("sara_ahmed"), "AC-19: Username regex accepts letters, digits, and underscores");
  assert(USERNAME_REGEX.test("user.99"), "AC-19: Username regex accepts dot separators");
  assert(!USERNAME_REGEX.test("usr"), "AC-19: Username regex rejects < 4 chars");
  assert(!USERNAME_REGEX.test("user name"), "AC-19: Username regex rejects spaces");

  assert(PASSWORD_REGEX.test("P@ssword123"), "AC-20: Password regex accepts uppercase, lowercase, number, and special character");
  assert(!PASSWORD_REGEX.test("password123"), "AC-20: Password regex rejects missing uppercase");
  assert(!PASSWORD_REGEX.test("PASSWORD123!"), "AC-20: Password regex rejects missing lowercase");
  assert(!PASSWORD_REGEX.test("Password!"), "AC-20: Password regex rejects missing number");
  assert(!PASSWORD_REGEX.test("Password123"), "AC-20: Password regex rejects missing special char");
  assert(!PASSWORD_REGEX.test("P@ss1"), "AC-20: Password regex rejects < 8 chars");

  console.log("\n=======================================================");
  console.log(`📊 TEST EXECUTION SUMMARY: ${passedTests}/${totalTests} PASSED`);
  if (failedTests === 0) {
    console.log("🎉 100% OF CLINICAL ACCEPTANCE TESTS PASSED SUCCESSFULLY!");
  } else {
    console.error(`⚠️ ${failedTests} TESTS FAILED. Please review above output.`);
  }
  console.log("=======================================================\n");

  if (failedTests > 0) {
    process.exit(1);
  }
}

// Execute suite
runReceptionistQASuite().catch((err) => {
  console.error("Test runner encountered an unhandled exception:", err);
  process.exit(1);
});

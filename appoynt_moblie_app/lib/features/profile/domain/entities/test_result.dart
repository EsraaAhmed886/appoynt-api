/*
 * File Name: test_result.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.1.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Declares the TestResult domain entity representing medical lab test or scanning records with clinical metadata.
 */

// Represents the structural TestResult domain entity
class TestResult {
  // Medical result filename description label
  final String document_name;
  // Execution timestamp date string
  final String date;
  // Local or remote file document path reference
  final String document_path;
  // Specific category classification type (e.g. lab_test / scan)
  final String type;
  // Name of the lab or clinic facility performing the test
  final String? facility_name;
  // Status indicator of the medical outcome: normal, abnormal, pending
  final String status;
  // Optional name of the prescribing physician
  final String? doctor_name;
  // Optional clinical notes or remarks
  final String? notes;

  // Constructor mapping the fields
  const TestResult({
    // Require document descriptor
    required this.document_name,
    // Require diagnostic date
    required this.date,
    // Require attachment reference
    required this.document_path,
    // Require report category type
    required this.type,
    // Optional facility name
    this.facility_name,
    // Default to normal if unspecified
    this.status = 'normal',
    // Optional prescribing physician name
    this.doctor_name,
    // Optional clinical notes
    this.notes,
  });
}

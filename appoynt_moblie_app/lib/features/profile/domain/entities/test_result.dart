/*
 * File Name: test_result.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Declares the TestResult domain entity representing medical lab test or scanning records.
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
  });
}

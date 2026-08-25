/*
 * File Name: quick_action_item_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Defines the data model holding counts of prescriptions, laboratory test results, and radiology reports for quick action cards.
 */

/// Data model representing the summary count of patient clinical resources.
class QuickActionsSummaryModel {
  final int prescriptionsCount;
  final int labResultsCount;
  final int radiologyReportsCount;

  const QuickActionsSummaryModel({
    required this.prescriptionsCount,
    required this.labResultsCount,
    required this.radiologyReportsCount,
  });

  /// Indicates if any resource exists (BR-34).
  /// If total count is 0, the entire Quick Actions section must be hidden.
  bool get hasAnyResources =>
      prescriptionsCount > 0 || labResultsCount > 0 || radiologyReportsCount > 0;
}

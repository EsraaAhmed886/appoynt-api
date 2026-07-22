/*
 * File Name: insurance_card.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Declares the InsuranceCard domain entity representing insurance coverage detail models.
 */

// Represents the structural InsuranceCard domain entity
class InsuranceCard {
  // Insurance plan card title or designation
  final String card_name;
  // Specific policy identification number
  final String card_number;
  // Provider name mapping target provider
  final String provider_name;
  // Linked digital attachment document reference path
  final String document_path;
  // Expiring timestamp or date string representation
  final String expiry_date;

  // Constructor mapping the fields
  const InsuranceCard({
    // Require card designation
    required this.card_name,
    // Require policy identifier
    required this.card_number,
    // Require provider name
    required this.provider_name,
    // Require document path
    required this.document_path,
    // Require expiry date
    required this.expiry_date,
  });
}

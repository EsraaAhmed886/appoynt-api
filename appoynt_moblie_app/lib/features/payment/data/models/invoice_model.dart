/*
 * File Name: invoice_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.1.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: Null-safe Invoice model deserializer for the payment history feature with nullable properties to allow UI null-coalescing.
 */

// Model representing payment transaction invoice details
class InvoiceModel {
  // Unique transaction identifier
  final String? id;
  // Formal invoice serial number code
  final String? invoiceNumber;
  // Specific medical category service type name
  final String? serviceName;
  // Doctor/specialist practitioner provider name
  final String? doctorName;
  // Cost pricing amount value representation
  final String? amount;
  // Calendar timestamp of transaction
  final String? date;
  // Settlement outcome state status
  final String? status;

  // Constant constructor initializing attributes
  const InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.serviceName,
    required this.doctorName,
    required this.amount,
    required this.date,
    required this.status,
  });

  // Factory constructor parsing JSON inputs with safe default fallbacks
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      // Coalesce ID string safely
      id: json['id']?.toString() ?? '',
      // Parse invoice code with fallback
      invoiceNumber: json['invoice_number']?.toString() ??
          (json['invoiceId']?.toString() ?? '#INV-0000'),
      // Parse medical service category type name
      serviceName: json['service_name']?.toString() ??
          (json['type']?.toString() ?? 'Medical Service'),
      // Parse practitioner doctor name
      doctorName: json['doctor_name']?.toString() ??
          (json['title']?.toString() ?? 'Specialist'),
      // Parse monetary cost value representation
      amount: json['amount']?.toString() ?? '0',
      // Parse date representation dynamically supporting DateTime objects
      date: json['date'] is DateTime
          ? (json['date'] as DateTime).toIso8601String()
          : (json['date']?.toString() ?? DateTime.now().toIso8601String()),
      // Parse settlement outcome state status
      status: json['status']?.toString() ?? 'Paid',
    );
  }
}

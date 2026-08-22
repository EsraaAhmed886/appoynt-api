/*
 * File Name: doctor_recommendation_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 22/08/2026
 * Version Information: v1.0.0
 * Dependencies: none
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 22/08/2026]
 * File Description: Defines the data model for recommended doctors shown conditionally on the appointments screen.
 */

/// Data model representing a recommended healthcare specialist or clinic checkup banner.
class DoctorRecommendationModel {
  final String id;
  final String name;
  final String specialty;
  final String? imageUrl;
  final double rating;
  final int reviewsCount;
  final String consultationFee;
  final String clinicName;
  final bool isVerified;

  const DoctorRecommendationModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.consultationFee,
    required this.clinicName,
    this.isVerified = true,
  });
}

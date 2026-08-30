/*
 * File Name: governorate_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.2.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 30/08/2026]
 * File Description: Defines GovernorateModel and CityModel DTOs for Egyptian administrative
 *   subdivisions using server-driven GUIDs and bilingual naming.
 */

/// Represents an Egyptian governorate lookup model fetched from the API.
class GovernorateModel {
  /// Unique GUID identifier of the governorate.
  final String id;

  /// English name representation.
  final String nameEn;

  /// Arabic name representation.
  final String nameAr;

  /// List of constituent cities belonging to this governorate.
  final List<CityModel> cities;

  const GovernorateModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    this.cities = const [],
  });

  /// Factory deserializer from JSON map
  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    var rawCities = json['cities'];
    List<CityModel> parsedCities = [];
    if (rawCities is List) {
      parsedCities = rawCities
          .whereType<Map<String, dynamic>>()
          .map((c) => CityModel.fromJson(c))
          .toList();
    } else {
      // No action needed
    }

    return GovernorateModel(
      id: json['id']?.toString() ?? '',
      nameAr: json['nameAr']?.toString() ??
          json['name_ar']?.toString() ??
          json['name']?.toString() ??
          '',
      nameEn: json['nameEn']?.toString() ??
          json['name_en']?.toString() ??
          json['name']?.toString() ??
          '',
      cities: parsedCities,
    );
  }

  /// Serializer to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'cities': cities.map((c) => c.toJson()).toList(),
    };
  }

  /// Resolves localized display name based on language code ('ar' or 'en').
  String getName(String langCode) {
    if (langCode == 'ar') {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    } else {
      return nameEn.isNotEmpty ? nameEn : nameAr;
    }
  }

  GovernorateModel copyWith({
    String? id,
    String? nameEn,
    String? nameAr,
    List<CityModel>? cities,
  }) {
    return GovernorateModel(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      cities: cities ?? this.cities,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GovernorateModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Represents an Egyptian city or district lookup model.
class CityModel {
  /// Unique GUID identifier of the city.
  final String id;

  /// Foreign key GUID identifier referencing the parent governorate.
  final String? governorateId;

  /// English name representation.
  final String nameEn;

  /// Arabic name representation.
  final String nameAr;

  const CityModel({
    required this.id,
    this.governorateId,
    required this.nameEn,
    required this.nameAr,
  });

  /// Factory deserializer from JSON map
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id']?.toString() ?? '',
      governorateId: json['governorateId']?.toString() ??
          json['governorate_id']?.toString(),
      nameEn: json['nameEn']?.toString() ??
          json['name_en']?.toString() ??
          json['name']?.toString() ??
          '',
      nameAr: json['nameAr']?.toString() ??
          json['name_ar']?.toString() ??
          json['name']?.toString() ??
          '',
    );
  }

  /// Serializer to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'governorateId': governorateId,
      'nameEn': nameEn,
      'nameAr': nameAr,
    };
  }

  /// Resolves localized display name based on language code ('ar' or 'en').
  String getName(String langCode) {
    if (langCode == 'ar') {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    } else {
      return nameEn.isNotEmpty ? nameEn : nameAr;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

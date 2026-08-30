/*
 * File Name: governorate_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 29/08/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 29/08/2026]
 * File Description: Defines the GovernorateModel and CityModel DTOs representing
 *   geographical administrative subdivisions in Egypt with localized naming and fallback data.
 */

/// Represents an Egyptian governorate lookup model.
class GovernorateModel {
  /// Unique identifier of the governorate (int, String, or Guid).
  final dynamic id;

  /// English name representation.
  final String nameEn;

  /// Arabic name representation.
  final String nameAr;

  /// List of constituent cities belonging to this governorate.
  final List<CityModel> cities;

  /// Constructor
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
      nameAr: json['name_ar']?.toString() ??
          json['nameAr']?.toString() ??
          json['name']?.toString() ??
          '',
      nameEn: json['name_en']?.toString() ??
          json['nameEn']?.toString() ??
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
    if ('ar' == langCode) {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    } else {
      return nameEn.isNotEmpty ? nameEn : nameAr;
    }
  }

  /// Implements value copy with modifications
  GovernorateModel copyWith({
    dynamic id,
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
          id.toString() == other.id.toString();

  @override
  int get hashCode => id.toString().hashCode;

  /// Default Egyptian Governorates and Major Cities offline fallback list.
  static List<GovernorateModel> get defaultGovernorates => const [
        GovernorateModel(
          id: 1,
          nameEn: 'Cairo',
          nameAr: 'القاهرة',
          cities: [
            CityModel(id: 101, governorateId: 1, nameEn: 'Nasr City', nameAr: 'مدينة نصر'),
            CityModel(id: 102, governorateId: 1, nameEn: 'New Cairo', nameAr: 'القاهرة الجديدة'),
            CityModel(id: 103, governorateId: 1, nameEn: 'Maadi', nameAr: 'المعادي'),
            CityModel(id: 104, governorateId: 1, nameEn: 'Heliopolis', nameAr: 'مصر الجديدة'),
            CityModel(id: 105, governorateId: 1, nameEn: 'Downtown', nameAr: 'وسط البلد'),
            CityModel(id: 106, governorateId: 1, nameEn: 'Zamalek', nameAr: 'الزمالك'),
            CityModel(id: 107, governorateId: 1, nameEn: 'Shubra', nameAr: 'شبرا'),
          ],
        ),
        GovernorateModel(
          id: 2,
          nameEn: 'Giza',
          nameAr: 'الجيزة',
          cities: [
            CityModel(id: 201, governorateId: 2, nameEn: 'Dokki', nameAr: 'الدقي'),
            CityModel(id: 202, governorateId: 2, nameEn: 'Mohandessin', nameAr: 'المهندسين'),
            CityModel(id: 203, governorateId: 2, nameEn: '6th of October', nameAr: 'السادس من أكتوبر'),
            CityModel(id: 204, governorateId: 2, nameEn: 'Sheikh Zayed', nameAr: 'الشيخ زايد'),
            CityModel(id: 205, governorateId: 2, nameEn: 'Haram', nameAr: 'الهرم'),
            CityModel(id: 206, governorateId: 2, nameEn: 'Faisal', nameAr: 'فيصل'),
          ],
        ),
        GovernorateModel(
          id: 3,
          nameEn: 'Alexandria',
          nameAr: 'الإسكندرية',
          cities: [
            CityModel(id: 301, governorateId: 3, nameEn: 'Smouha', nameAr: 'سموحة'),
            CityModel(id: 302, governorateId: 3, nameEn: 'Miami', nameAr: 'ميامي'),
            CityModel(id: 303, governorateId: 3, nameEn: 'Sidi Gaber', nameAr: 'سيدي جابر'),
            CityModel(id: 304, governorateId: 3, nameEn: 'Montaza', nameAr: 'المنتزه'),
            CityModel(id: 305, governorateId: 3, nameEn: 'Mansheya', nameAr: 'المنشية'),
          ],
        ),
        GovernorateModel(
          id: 4,
          nameEn: 'Dakahlia',
          nameAr: 'الدقهلية',
          cities: [
            CityModel(id: 401, governorateId: 4, nameEn: 'Mansoura', nameAr: 'المنصورة'),
            CityModel(id: 402, governorateId: 4, nameEn: 'Talkha', nameAr: 'طلخا'),
            CityModel(id: 403, governorateId: 4, nameEn: 'Mit Ghamr', nameAr: 'ميت غمر'),
          ],
        ),
        GovernorateModel(
          id: 5,
          nameEn: 'Red Sea',
          nameAr: 'البحر الأحمر',
          cities: [
            CityModel(id: 501, governorateId: 5, nameEn: 'Hurghada', nameAr: 'الغردقة'),
            CityModel(id: 502, governorateId: 5, nameEn: 'El Gouna', nameAr: 'الجونة'),
            CityModel(id: 503, governorateId: 5, nameEn: 'Safaga', nameAr: 'سفاجا'),
          ],
        ),
        GovernorateModel(
          id: 6,
          nameEn: 'Beheira',
          nameAr: 'البحيرة',
          cities: [
            CityModel(id: 601, governorateId: 6, nameEn: 'Damanhur', nameAr: 'دمنهور'),
            CityModel(id: 602, governorateId: 6, nameEn: 'Kafr El Dawwar', nameAr: 'كفر الدوار'),
          ],
        ),
        GovernorateModel(
          id: 7,
          nameEn: 'Fayoum',
          nameAr: 'الفيوم',
          cities: [
            CityModel(id: 701, governorateId: 7, nameEn: 'Fayoum City', nameAr: 'مدينة الفيوم'),
            CityModel(id: 702, governorateId: 7, nameEn: 'Sinnuris', nameAr: 'سنورس'),
          ],
        ),
        GovernorateModel(
          id: 8,
          nameEn: 'Gharbia',
          nameAr: 'الغربية',
          cities: [
            CityModel(id: 801, governorateId: 8, nameEn: 'Tanta', nameAr: 'طنطا'),
            CityModel(id: 802, governorateId: 8, nameEn: 'El Mahalla El Kubra', nameAr: 'المحلة الكبرى'),
          ],
        ),
        GovernorateModel(
          id: 9,
          nameEn: 'Ismailia',
          nameAr: 'الإسماعيلية',
          cities: [
            CityModel(id: 901, governorateId: 9, nameEn: 'Ismailia City', nameAr: 'مدينة الإسماعيلية'),
            CityModel(id: 902, governorateId: 9, nameEn: 'Fayed', nameAr: 'فايد'),
          ],
        ),
        GovernorateModel(
          id: 10,
          nameEn: 'Menofia',
          nameAr: 'المنوفية',
          cities: [
            CityModel(id: 1001, governorateId: 10, nameEn: 'Shibin El Kom', nameAr: 'شبين الكوم'),
            CityModel(id: 1002, governorateId: 10, nameEn: 'Menouf', nameAr: 'منوف'),
            CityModel(id: 1003, governorateId: 10, nameEn: 'Sadat City', nameAr: 'مدينة السادات'),
          ],
        ),
        GovernorateModel(
          id: 11,
          nameEn: 'Minya',
          nameAr: 'المنيا',
          cities: [
            CityModel(id: 1101, governorateId: 11, nameEn: 'Minya City', nameAr: 'مدينة المنيا'),
            CityModel(id: 1102, governorateId: 11, nameEn: 'Mallawi', nameAr: 'ملوي'),
          ],
        ),
        GovernorateModel(
          id: 12,
          nameEn: 'Qaliubiya',
          nameAr: 'القليوبية',
          cities: [
            CityModel(id: 1201, governorateId: 12, nameEn: 'Banha', nameAr: 'بنها'),
            CityModel(id: 1202, governorateId: 12, nameEn: 'Shubra El Kheima', nameAr: 'شبرا الخيمة'),
            CityModel(id: 1203, governorateId: 12, nameEn: 'Qalyub', nameAr: 'قليوب'),
          ],
        ),
        GovernorateModel(
          id: 13,
          nameEn: 'New Valley',
          nameAr: 'الوادي الجديد',
          cities: [
            CityModel(id: 1301, governorateId: 13, nameEn: 'Kharga', nameAr: 'الخارجة'),
            CityModel(id: 1302, governorateId: 13, nameEn: 'Dakhla', nameAr: 'الداخلة'),
          ],
        ),
        GovernorateModel(
          id: 14,
          nameEn: 'Suez',
          nameAr: 'السويس',
          cities: [
            CityModel(id: 1401, governorateId: 14, nameEn: 'Suez City', nameAr: 'مدينة السويس'),
            CityModel(id: 1402, governorateId: 14, nameEn: 'Arbaeen', nameAr: 'الأربعين'),
          ],
        ),
        GovernorateModel(
          id: 15,
          nameEn: 'Aswan',
          nameAr: 'أسوان',
          cities: [
            CityModel(id: 1501, governorateId: 15, nameEn: 'Aswan City', nameAr: 'مدينة أسوان'),
            CityModel(id: 1502, governorateId: 15, nameEn: 'Kom Ombo', nameAr: 'كوم أمبو'),
            CityModel(id: 1503, governorateId: 15, nameEn: 'Edfu', nameAr: 'إدفو'),
          ],
        ),
        GovernorateModel(
          id: 16,
          nameEn: 'Assiut',
          nameAr: 'أسيوط',
          cities: [
            CityModel(id: 1601, governorateId: 16, nameEn: 'Assiut City', nameAr: 'مدينة أسيوط'),
            CityModel(id: 1602, governorateId: 16, nameEn: 'Dairut', nameAr: 'ديروط'),
          ],
        ),
        GovernorateModel(
          id: 17,
          nameEn: 'Beni Suef',
          nameAr: 'بني سويف',
          cities: [
            CityModel(id: 1701, governorateId: 17, nameEn: 'Beni Suef City', nameAr: 'مدينة بني سويف'),
            CityModel(id: 1702, governorateId: 17, nameEn: 'Nasser', nameAr: 'ناصر'),
          ],
        ),
        GovernorateModel(
          id: 18,
          nameEn: 'Port Said',
          nameAr: 'بورسعيد',
          cities: [
            CityModel(id: 1801, governorateId: 18, nameEn: 'Port Said City', nameAr: 'مدينة بورسعيد'),
            CityModel(id: 1802, governorateId: 18, nameEn: 'Port Fouad', nameAr: 'بورفؤاد'),
          ],
        ),
        GovernorateModel(
          id: 19,
          nameEn: 'Damietta',
          nameAr: 'دمياط',
          cities: [
            CityModel(id: 1901, governorateId: 19, nameEn: 'Damietta City', nameAr: 'مدينة دمياط'),
            CityModel(id: 1902, governorateId: 19, nameEn: 'Ras El Bar', nameAr: 'رأس البر'),
            CityModel(id: 1903, governorateId: 19, nameEn: 'New Damietta', nameAr: 'دمياط الجديدة'),
          ],
        ),
        GovernorateModel(
          id: 20,
          nameEn: 'Sharkia',
          nameAr: 'الشرقية',
          cities: [
            CityModel(id: 2001, governorateId: 20, nameEn: 'Zagazig', nameAr: 'الزقازيق'),
            CityModel(id: 2002, governorateId: 20, nameEn: '10th of Ramadan', nameAr: 'العاشر من رمضان'),
            CityModel(id: 2003, governorateId: 20, nameEn: 'Belbeis', nameAr: 'بلبيس'),
          ],
        ),
        GovernorateModel(
          id: 21,
          nameEn: 'South Sinai',
          nameAr: 'جنوب سيناء',
          cities: [
            CityModel(id: 2101, governorateId: 21, nameEn: 'Sharm El Sheikh', nameAr: 'شرم الشيخ'),
            CityModel(id: 2102, governorateId: 21, nameEn: 'Dahab', nameAr: 'دهب'),
            CityModel(id: 2103, governorateId: 21, nameEn: 'Nuweiba', nameAr: 'نويبع'),
          ],
        ),
        GovernorateModel(
          id: 22,
          nameEn: 'Kafr El Sheikh',
          nameAr: 'كفر الشيخ',
          cities: [
            CityModel(id: 2201, governorateId: 22, nameEn: 'Kafr El Sheikh City', nameAr: 'مدينة كفر الشيخ'),
            CityModel(id: 2202, governorateId: 22, nameEn: 'Desouk', nameAr: 'دسوق'),
          ],
        ),
        GovernorateModel(
          id: 23,
          nameEn: 'Matrouh',
          nameAr: 'مطروح',
          cities: [
            CityModel(id: 2301, governorateId: 23, nameEn: 'Marsa Matrouh', nameAr: 'مرسى مطروح'),
            CityModel(id: 2302, governorateId: 23, nameEn: 'El Alamein', nameAr: 'العلمين'),
            CityModel(id: 2303, governorateId: 23, nameEn: 'Siwa', nameAr: 'سيوة'),
          ],
        ),
        GovernorateModel(
          id: 24,
          nameEn: 'Luxor',
          nameAr: 'الأقصر',
          cities: [
            CityModel(id: 2401, governorateId: 24, nameEn: 'Luxor City', nameAr: 'مدينة الأقصر'),
            CityModel(id: 2402, governorateId: 24, nameEn: 'Armant', nameAr: 'أرمنت'),
          ],
        ),
        GovernorateModel(
          id: 25,
          nameEn: 'Qena',
          nameAr: 'قنا',
          cities: [
            CityModel(id: 2501, governorateId: 25, nameEn: 'Qena City', nameAr: 'مدينة قنا'),
            CityModel(id: 2502, governorateId: 25, nameEn: 'Nag Hammadi', nameAr: 'نجع حمادي'),
          ],
        ),
        GovernorateModel(
          id: 26,
          nameEn: 'North Sinai',
          nameAr: 'شمال سيناء',
          cities: [
            CityModel(id: 2601, governorateId: 26, nameEn: 'Arish', nameAr: 'العريش'),
            CityModel(id: 2602, governorateId: 26, nameEn: 'Sheikh Zuweid', nameAr: 'الشيخ زويد'),
          ],
        ),
        GovernorateModel(
          id: 27,
          nameEn: 'Sohag',
          nameAr: 'سوهاج',
          cities: [
            CityModel(id: 2701, governorateId: 27, nameEn: 'Sohag City', nameAr: 'مدينة سوهاج'),
            CityModel(id: 2702, governorateId: 27, nameEn: 'Akhmim', nameAr: 'أخميم'),
            CityModel(id: 2703, governorateId: 27, nameEn: 'Girga', nameAr: 'جرجا'),
          ],
        ),
      ];
}

/// Represents an Egyptian city or district lookup model.
class CityModel {
  /// Unique identifier of the city.
  final dynamic id;

  /// Foreign key identifier referencing the parent governorate.
  final dynamic governorateId;

  /// English name representation.
  final String nameEn;

  /// Arabic name representation.
  final String nameAr;

  /// Constructor
  const CityModel({
    required this.id,
    required this.governorateId,
    required this.nameEn,
    required this.nameAr,
  });

  /// Factory deserializer from JSON map
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id']?.toString() ?? '',
      governorateId: json['governorateId']?.toString() ?? json['governorate_id']?.toString(),
      nameEn: json['name_en']?.toString() ??
          json['nameEn']?.toString() ??
          json['name']?.toString() ??
          '',
      nameAr: json['name_ar']?.toString() ??
          json['nameAr']?.toString() ??
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
    if ('ar' == langCode) {
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
          id.toString() == other.id.toString();

  @override
  int get hashCode => id.toString().hashCode;
}

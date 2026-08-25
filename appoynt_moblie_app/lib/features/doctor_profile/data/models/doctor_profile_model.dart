/*
 * File Name: doctor_profile_model.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the Data Transfer Objects (DTOs) for the Doctor Profile
 *   feature, including robust null-safe JSON serialization/deserialization and
 *   mapping to and from domain layer entities.
 */

// Import domain entities
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Data model representing an education credential.
class EducationModel extends EducationEntity {
  const EducationModel({
    required super.degree,
    required super.institution,
    required super.year,
  });

  /// Factory deserializer converting JSON map to EducationModel with null-safety.
  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'] as String? ?? json['Degree'] as String? ?? '',
      institution: json['institution'] as String? ??
          json['Institution'] as String? ??
          '',
      year: json['year']?.toString() ?? json['Year']?.toString() ?? '',
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'year': year,
    };
  }

  /// Converts domain entity to data model.
  factory EducationModel.fromEntity(EducationEntity entity) {
    return EducationModel(
      degree: entity.degree,
      institution: entity.institution,
      year: entity.year,
    );
  }
}

/// Data model representing a clinical career experience position.
class ExperienceModel extends ExperienceEntity {
  const ExperienceModel({
    required super.position,
    required super.hospital_or_clinic,
    required super.duration,
  });

  /// Factory deserializer converting JSON map to ExperienceModel.
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      position: json['position'] as String? ??
          json['Position'] as String? ??
          json['title'] as String? ??
          '',
      hospital_or_clinic: json['hospitalOrClinic'] as String? ??
          json['HospitalOrClinic'] as String? ??
          json['hospital_or_clinic'] as String? ??
          json['institution'] as String? ??
          '',
      duration: json['duration'] as String? ??
          json['Duration'] as String? ??
          json['period'] as String? ??
          '',
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'hospitalOrClinic': hospital_or_clinic,
      'duration': duration,
    };
  }

  /// Converts domain entity to data model.
  factory ExperienceModel.fromEntity(ExperienceEntity entity) {
    return ExperienceModel(
      position: entity.position,
      hospital_or_clinic: entity.hospital_or_clinic,
      duration: entity.duration,
    );
  }
}

/// Data model representing a medical certification.
class CertificateModel extends CertificateEntity {
  const CertificateModel({
    required super.id,
    required super.title,
    required super.image_url,
    required super.issue_date,
  });

  /// Factory deserializer converting JSON map to CertificateModel.
  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      title: json['title'] as String? ?? json['Title'] as String? ?? '',
      image_url: json['imageUrl'] as String? ??
          json['ImageUrl'] as String? ??
          json['image_url'] as String? ??
          '',
      issue_date: json['issueDate'] as String? ??
          json['IssueDate'] as String? ??
          json['issue_date'] as String? ??
          '',
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': image_url,
      'issueDate': issue_date,
    };
  }

  /// Converts domain entity to data model.
  factory CertificateModel.fromEntity(CertificateEntity entity) {
    return CertificateModel(
      id: entity.id,
      title: entity.title,
      image_url: entity.image_url,
      issue_date: entity.issue_date,
    );
  }
}

/// Data model representing multimedia items.
class DoctorMediaModel extends DoctorMediaEntity {
  const DoctorMediaModel({
    required super.id,
    required super.type,
    required super.url,
    required super.thumbnail_url,
  });

  /// Factory deserializer converting JSON map to DoctorMediaModel.
  factory DoctorMediaModel.fromJson(Map<String, dynamic> json) {
    final String type_str = (json['type'] as String? ??
            json['Type'] as String? ??
            'image')
        .toLowerCase();
    final DoctorMediaType resolved_type = type_str.contains('video')
        ? DoctorMediaType.video
        : DoctorMediaType.image;

    return DoctorMediaModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      type: resolved_type,
      url: json['url'] as String? ?? json['Url'] as String? ?? '',
      thumbnail_url: json['thumbnailUrl'] as String? ??
          json['ThumbnailUrl'] as String? ??
          json['thumbnail_url'] as String? ??
          json['url'] as String? ??
          '',
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type == DoctorMediaType.video ? 'video' : 'image',
      'url': url,
      'thumbnailUrl': thumbnail_url,
    };
  }

  /// Converts domain entity to data model.
  factory DoctorMediaModel.fromEntity(DoctorMediaEntity entity) {
    return DoctorMediaModel(
      id: entity.id,
      type: entity.type,
      url: entity.url,
      thumbnail_url: entity.thumbnail_url,
    );
  }
}

/// Data model representing medical procedures.
class ProcedureModel extends ProcedureEntity {
  const ProcedureModel({
    required super.id,
    required super.name,
  });

  /// Factory deserializer converting JSON map to ProcedureModel.
  factory ProcedureModel.fromJson(Map<String, dynamic> json) {
    return ProcedureModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      name: json['name'] as String? ?? json['Name'] as String? ?? '',
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// Converts domain entity to data model.
  factory ProcedureModel.fromEntity(ProcedureEntity entity) {
    return ProcedureModel(
      id: entity.id,
      name: entity.name,
    );
  }
}

/// Data model representing patient reviews.
class DoctorReviewModel extends DoctorReviewEntity {
  const DoctorReviewModel({
    required super.id,
    required super.patient_name,
    required super.rating,
    required super.comment,
    required super.date,
  });

  /// Factory deserializer converting JSON map to DoctorReviewModel.
  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) {
    return DoctorReviewModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      patient_name: json['patientName'] as String? ??
          json['PatientName'] as String? ??
          json['patient_name'] as String? ??
          'Patient',
      rating: (json['rating'] as num?)?.toDouble() ??
          (json['Rating'] as num?)?.toDouble() ??
          5.0,
      comment: json['comment'] as String? ?? json['Comment'] as String? ?? '',
      date: json['date'] as String? ??
          json['Date'] as String? ??
          json['createdAt'] as String? ??
          '',
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patient_name,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }

  /// Converts domain entity to data model.
  factory DoctorReviewModel.fromEntity(DoctorReviewEntity entity) {
    return DoctorReviewModel(
      id: entity.id,
      patient_name: entity.patient_name,
      rating: entity.rating,
      comment: entity.comment,
      date: entity.date,
    );
  }
}

/// Data model representing appointment availability slots.
class AppointmentSlotModel extends AppointmentSlotEntity {
  const AppointmentSlotModel({
    required super.date,
    required super.available_times,
  });

  /// Factory deserializer converting JSON map to AppointmentSlotModel.
  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> raw_times = json['availableTimes'] as List<dynamic>? ??
        json['AvailableTimes'] as List<dynamic>? ??
        json['available_times'] as List<dynamic>? ??
        json['slots'] as List<dynamic>? ??
        [];

    final List<String> times =
        raw_times.map((item) => item.toString()).toList();

    return AppointmentSlotModel(
      date: json['date'] as String? ?? json['Date'] as String? ?? '',
      available_times: times,
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'availableTimes': available_times,
    };
  }

  /// Converts domain entity to data model.
  factory AppointmentSlotModel.fromEntity(AppointmentSlotEntity entity) {
    return AppointmentSlotModel(
      date: entity.date,
      available_times: entity.available_times,
    );
  }
}

/// Complete DoctorProfileModel representing API payloads for a doctor's profile.
class DoctorProfileModel extends DoctorProfileEntity {
  const DoctorProfileModel({
    required super.doctor_id,
    required super.full_name,
    required super.specialty,
    required super.profile_photo_url,
    required super.is_verified,
    required super.average_rating,
    required super.reviews_count,
    required super.experience_years,
    required super.patients_count,
    required super.consultation_fee,
    required super.currency,
    required super.bio,
    required super.is_favorited,
    required super.is_available_today,
    required super.education_list,
    required super.experience_list,
    required super.certificates_list,
    required super.media_list,
    required super.procedures_list,
    required super.reviews_list,
  });

  /// Robust JSON deserializer mapping incoming API payload to DoctorProfileModel.
  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    // Parse nested collections safely
    final List<dynamic> raw_edu = json['education'] as List<dynamic>? ??
        json['Education'] as List<dynamic>? ??
        json['educationList'] as List<dynamic>? ??
        [];
    final List<EducationModel> edu_list = raw_edu
        .whereType<Map<String, dynamic>>()
        .map((item) => EducationModel.fromJson(item))
        .toList();

    final List<dynamic> raw_exp = json['experience'] as List<dynamic>? ??
        json['Experience'] as List<dynamic>? ??
        json['experienceList'] as List<dynamic>? ??
        [];
    final List<ExperienceModel> exp_list = raw_exp
        .whereType<Map<String, dynamic>>()
        .map((item) => ExperienceModel.fromJson(item))
        .toList();

    final List<dynamic> raw_cert = json['certificates'] as List<dynamic>? ??
        json['Certificates'] as List<dynamic>? ??
        json['certificatesList'] as List<dynamic>? ??
        [];
    final List<CertificateModel> cert_list = raw_cert
        .whereType<Map<String, dynamic>>()
        .map((item) => CertificateModel.fromJson(item))
        .toList();

    final List<dynamic> raw_media = json['media'] as List<dynamic>? ??
        json['Media'] as List<dynamic>? ??
        json['mediaList'] as List<dynamic>? ??
        [];
    final List<DoctorMediaModel> media_list = raw_media
        .whereType<Map<String, dynamic>>()
        .map((item) => DoctorMediaModel.fromJson(item))
        .toList();

    final List<dynamic> raw_proc = json['procedures'] as List<dynamic>? ??
        json['Procedures'] as List<dynamic>? ??
        json['proceduresList'] as List<dynamic>? ??
        [];
    final List<ProcedureModel> proc_list = raw_proc
        .whereType<Map<String, dynamic>>()
        .map((item) => ProcedureModel.fromJson(item))
        .toList();

    final List<dynamic> raw_rev = json['reviews'] as List<dynamic>? ??
        json['Reviews'] as List<dynamic>? ??
        json['reviewsList'] as List<dynamic>? ??
        [];
    final List<DoctorReviewModel> rev_list = raw_rev
        .whereType<Map<String, dynamic>>()
        .map((item) => DoctorReviewModel.fromJson(item))
        .toList();

    return DoctorProfileModel(
      doctor_id: json['doctorId']?.toString() ??
          json['DoctorId']?.toString() ??
          json['id']?.toString() ??
          json['Id']?.toString() ??
          '',
      full_name: json['fullName'] as String? ??
          json['FullName'] as String? ??
          json['name'] as String? ??
          json['Name'] as String? ??
          'Dr. Unknown',
      specialty: json['specialty'] as String? ??
          json['Specialty'] as String? ??
          json['specialization'] as String? ??
          'General Practitioner',
      profile_photo_url: json['profilePhotoUrl'] as String? ??
          json['ProfilePhotoUrl'] as String? ??
          json['avatarUrl'] as String? ??
          json['avatar_url'] as String? ??
          '',
      is_verified: json['isVerified'] as bool? ??
          json['IsVerified'] as bool? ??
          true,
      average_rating: (json['averageRating'] as num?)?.toDouble() ??
          (json['AverageRating'] as num?)?.toDouble() ??
          (json['rating'] as num?)?.toDouble() ??
          4.9,
      reviews_count: json['reviewsCount'] as int? ??
          json['ReviewsCount'] as int? ??
          json['reviews_count'] as int? ??
          120,
      experience_years: json['experienceYears'] as int? ??
          json['ExperienceYears'] as int? ??
          json['experience_years'] as int? ??
          10,
      patients_count: json['patientsCount'] as int? ??
          json['PatientsCount'] as int? ??
          json['patients_count'] as int? ??
          1500,
      consultation_fee: (json['consultationFee'] as num?)?.toDouble() ??
          (json['ConsultationFee'] as num?)?.toDouble() ??
          (json['fee'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          450.0,
      currency: json['currency'] as String? ??
          json['Currency'] as String? ??
          'EGP',
      bio: json['bio'] as String? ??
          json['Bio'] as String? ??
          json['about'] as String? ??
          '',
      is_favorited: json['isFavorited'] as bool? ??
          json['IsFavorited'] as bool? ??
          json['is_favorite'] as bool? ??
          false,
      is_available_today: json['isAvailableToday'] as bool? ??
          json['IsAvailableToday'] as bool? ??
          json['is_available'] as bool? ??
          true,
      education_list: edu_list,
      experience_list: exp_list,
      certificates_list: cert_list,
      media_list: media_list,
      procedures_list: proc_list,
      reviews_list: rev_list,
    );
  }

  /// Serializes model to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctor_id,
      'fullName': full_name,
      'specialty': specialty,
      'profilePhotoUrl': profile_photo_url,
      'isVerified': is_verified,
      'averageRating': average_rating,
      'reviewsCount': reviews_count,
      'experienceYears': experience_years,
      'patientsCount': patients_count,
      'consultationFee': consultation_fee,
      'currency': currency,
      'bio': bio,
      'isFavorited': is_favorited,
      'isAvailableToday': is_available_today,
      'education': education_list
          .map((item) => EducationModel.fromEntity(item).toJson())
          .toList(),
      'experience': experience_list
          .map((item) => ExperienceModel.fromEntity(item).toJson())
          .toList(),
      'certificates': certificates_list
          .map((item) => CertificateModel.fromEntity(item).toJson())
          .toList(),
      'media': media_list
          .map((item) => DoctorMediaModel.fromEntity(item).toJson())
          .toList(),
      'procedures': procedures_list
          .map((item) => ProcedureModel.fromEntity(item).toJson())
          .toList(),
      'reviews': reviews_list
          .map((item) => DoctorReviewModel.fromEntity(item).toJson())
          .toList(),
    };
  }

  /// Converts domain entity to data model.
  factory DoctorProfileModel.fromEntity(DoctorProfileEntity entity) {
    return DoctorProfileModel(
      doctor_id: entity.doctor_id,
      full_name: entity.full_name,
      specialty: entity.specialty,
      profile_photo_url: entity.profile_photo_url,
      is_verified: entity.is_verified,
      average_rating: entity.average_rating,
      reviews_count: entity.reviews_count,
      experience_years: entity.experience_years,
      patients_count: entity.patients_count,
      consultation_fee: entity.consultation_fee,
      currency: entity.currency,
      bio: entity.bio,
      is_favorited: entity.is_favorited,
      is_available_today: entity.is_available_today,
      education_list: entity.education_list,
      experience_list: entity.experience_list,
      certificates_list: entity.certificates_list,
      media_list: entity.media_list,
      procedures_list: entity.procedures_list,
      reviews_list: entity.reviews_list,
    );
  }
}

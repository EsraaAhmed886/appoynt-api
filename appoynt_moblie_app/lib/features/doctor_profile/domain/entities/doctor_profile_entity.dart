/*
 * File Name: doctor_profile_entity.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:equatable/equatable.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Defines the core domain entities representing a doctor's full
 *   profile, including academic credentials, career experience, certifications,
 *   media items, medical procedures offered, patient reviews, and appointment slots.
 */

// Import Equatable for value-based entity equality comparisons
import 'package:equatable/equatable.dart';

/// Represents education background and academic degrees earned by the doctor.
class EducationEntity extends Equatable {
  // Degree title (e.g., "M.D. in Cardiology", "Ph.D. in Internal Medicine")
  final String degree;
  // Academic institution / Medical school name
  final String institution;
  // Year of graduation or completion
  final String year;

  // Constant constructor mapping required education fields
  const EducationEntity({
    required this.degree,
    required this.institution,
    required this.year,
  });

  @override
  List<Object?> get props {
    return [degree, institution, year];
  }
}

/// Represents professional clinical career positions and hospital affiliations.
class ExperienceEntity extends Equatable {
  // Clinical job role / position (e.g., "Senior Consultant Cardiologist")
  final String position;
  // Hospital, medical center, or clinic name
  final String hospital_or_clinic;
  // Duration or time period of employment (e.g., "2018 - Present", "5 Years")
  final String duration;

  // Constant constructor mapping required experience fields
  const ExperienceEntity({
    required this.position,
    required this.hospital_or_clinic,
    required this.duration,
  });

  @override
  List<Object?> get props {
    return [position, hospital_or_clinic, duration];
  }
}

/// Represents official medical board certifications and accredited diplomas.
class CertificateEntity extends Equatable {
  // Unique certificate identifier
  final String id;
  // Certificate title (e.g., "Board Certified in Cardiovascular Disease")
  final String title;
  // Network image or document asset preview URL
  final String image_url;
  // Issue date or accreditation year
  final String issue_date;

  // Constant constructor mapping required certificate fields
  const CertificateEntity({
    required this.id,
    required this.title,
    required this.image_url,
    required this.issue_date,
  });

  @override
  List<Object?> get props {
    return [id, title, image_url, issue_date];
  }
}

/// Media type discriminator enum for gallery items.
enum DoctorMediaType {
  image,
  video,
}

/// Represents multimedia items (clinic tours, surgical guides, high-res photos).
class DoctorMediaEntity extends Equatable {
  // Unique media identifier
  final String id;
  // Media type (image or video)
  final DoctorMediaType type;
  // Resource stream or image URL
  final String url;
  // Video thumbnail preview image URL
  final String thumbnail_url;

  // Constant constructor mapping required media fields
  const DoctorMediaEntity({
    required this.id,
    required this.type,
    required this.url,
    required this.thumbnail_url,
  });

  @override
  List<Object?> get props {
    return [id, type, url, thumbnail_url];
  }
}

/// Represents specific medical procedures and clinical treatments offered.
class ProcedureEntity extends Equatable {
  // Unique procedure identifier
  final String id;
  // Procedure or service name (e.g., "Echocardiogram", "Cardiac Catheterization")
  final String name;

  // Constant constructor mapping required procedure fields
  const ProcedureEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props {
    return [id, name];
  }
}

/// Represents a verified patient review and rating feedback entry.
class DoctorReviewEntity extends Equatable {
  // Unique review identifier
  final String id;
  // Patient display name
  final String patient_name;
  // Numeric rating score out of 5
  final double rating;
  // Patient comment text
  final String comment;
  // Review submission date string
  final String date;

  // Constant constructor mapping required review fields
  const DoctorReviewEntity({
    required this.id,
    required this.patient_name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props {
    return [id, patient_name, rating, comment, date];
  }
}

/// Represents an appointment availability slot for a given date.
class AppointmentSlotEntity extends Equatable {
  // Slot date in ISO string format (e.g. "2026-08-17")
  final String date;
  // List of available appointment time strings (e.g., ["09:00 AM", "10:30 AM", "02:00 PM"])
  final List<String> available_times;

  // Constant constructor mapping required appointment slot fields
  const AppointmentSlotEntity({
    required this.date,
    required this.available_times,
  });

  @override
  List<Object?> get props {
    return [date, available_times];
  }
}

/// Core domain entity encapsulating the complete medical profile of a doctor.
class DoctorProfileEntity extends Equatable {
  // Unique doctor identifier
  final String doctor_id;
  // Full professional display name (e.g., "Dr. Sarah Jenkins, M.D.")
  final String full_name;
  // Medical specialization (e.g., "Cardiologist", "Neurologist")
  final String specialty;
  // Avatar portrait image URL
  final String profile_photo_url;
  // Medical license verified badge indicator flag
  final bool is_verified;
  // Average rating score (e.g., 4.9)
  final double average_rating;
  // Total count of patient reviews
  final int reviews_count;
  // Total years of professional medical practice experience
  final int experience_years;
  // Approximate total patient consultations served
  final int patients_count;
  // Base consultation fee amount
  final double consultation_fee;
  // Currency code (e.g., "EGP", "USD")
  final String currency;
  // Doctor biography narrative
  final String bio;
  // Favorite state for the current authenticated user
  final bool is_favorited;
  // Same-day immediate availability flag
  final bool is_available_today;
  // Academic education degrees list
  final List<EducationEntity> education_list;
  // Clinical career positions and hospital affiliations list
  final List<ExperienceEntity> experience_list;
  // Official board certificates and credentials list
  final List<CertificateEntity> certificates_list;
  // Clinic multimedia gallery items
  final List<DoctorMediaEntity> media_list;
  // Medical procedures and services offered
  final List<ProcedureEntity> procedures_list;
  // Patient reviews and testimonials list
  final List<DoctorReviewEntity> reviews_list;

  // Constant constructor mapping all doctor profile domain properties
  const DoctorProfileEntity({
    required this.doctor_id,
    required this.full_name,
    required this.specialty,
    required this.profile_photo_url,
    required this.is_verified,
    required this.average_rating,
    required this.reviews_count,
    required this.experience_years,
    required this.patients_count,
    required this.consultation_fee,
    required this.currency,
    required this.bio,
    required this.is_favorited,
    required this.is_available_today,
    required this.education_list,
    required this.experience_list,
    required this.certificates_list,
    required this.media_list,
    required this.procedures_list,
    required this.reviews_list,
  });

  /// Creates a copy with modified values for state transitions.
  DoctorProfileEntity copyWith({
    String? doctor_id,
    String? full_name,
    String? specialty,
    String? profile_photo_url,
    bool? is_verified,
    double? average_rating,
    int? reviews_count,
    int? experience_years,
    int? patients_count,
    double? consultation_fee,
    String? currency,
    String? bio,
    bool? is_favorited,
    bool? is_available_today,
    List<EducationEntity>? education_list,
    List<ExperienceEntity>? experience_list,
    List<CertificateEntity>? certificates_list,
    List<DoctorMediaEntity>? media_list,
    List<ProcedureEntity>? procedures_list,
    List<DoctorReviewEntity>? reviews_list,
  }) {
    return DoctorProfileEntity(
      doctor_id: doctor_id ?? this.doctor_id,
      full_name: full_name ?? this.full_name,
      specialty: specialty ?? this.specialty,
      profile_photo_url: profile_photo_url ?? this.profile_photo_url,
      is_verified: is_verified ?? this.is_verified,
      average_rating: average_rating ?? this.average_rating,
      reviews_count: reviews_count ?? this.reviews_count,
      experience_years: experience_years ?? this.experience_years,
      patients_count: patients_count ?? this.patients_count,
      consultation_fee: consultation_fee ?? this.consultation_fee,
      currency: currency ?? this.currency,
      bio: bio ?? this.bio,
      is_favorited: is_favorited ?? this.is_favorited,
      is_available_today: is_available_today ?? this.is_available_today,
      education_list: education_list ?? this.education_list,
      experience_list: experience_list ?? this.experience_list,
      certificates_list: certificates_list ?? this.certificates_list,
      media_list: media_list ?? this.media_list,
      procedures_list: procedures_list ?? this.procedures_list,
      reviews_list: reviews_list ?? this.reviews_list,
    );
  }

  @override
  List<Object?> get props {
    return [
      doctor_id,
      full_name,
      specialty,
      profile_photo_url,
      is_verified,
      average_rating,
      reviews_count,
      experience_years,
      patients_count,
      consultation_fee,
      currency,
      bio,
      is_favorited,
      is_available_today,
      education_list,
      experience_list,
      certificates_list,
      media_list,
      procedures_list,
      reviews_list,
    ];
  }
}

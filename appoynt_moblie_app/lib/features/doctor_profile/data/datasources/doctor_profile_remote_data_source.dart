/*
 * File Name: doctor_profile_remote_data_source.dart
 * Author: Kholoud Khaled
 * Date of Creation: 16/08/2026
 * Version Information: V1.4.0
 * Dependencies: package:dio/dio.dart, doctor_profile_model.dart, doctor_profile_entity.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 21/08/2026]
 * File Description: Remote data source handling HTTP requests for doctor profile
 *   details, booking availability slots, and favorite toggles with a rich multi-doctor
 *   mock dataset featuring high-resolution portraits and stable public media.
 */

// Import Dio networking library
import 'package:dio/dio.dart';
// Import data models
import 'package:appoynt_mobile_app/features/doctor_profile/data/models/doctor_profile_model.dart';
import 'package:appoynt_mobile_app/features/doctor_profile/domain/entities/doctor_profile_entity.dart';

/// Contract defining remote network operations for the doctor profile feature.
abstract class DoctorProfileRemoteDataSource {
  /// Fetches complete profile details for a given doctor ID.
  Future<DoctorProfileModel> getDoctorProfile(String doctor_id);

  /// Fetches available booking slots for a given doctor and month.
  Future<List<AppointmentSlotModel>> getDoctorAvailableSlots(
    String doctor_id,
    String month,
  );

  /// Toggles the favorite status of a doctor on the remote backend.
  Future<bool> toggleFavoriteDoctor(String doctor_id);
}

/// Concrete implementation of DoctorProfileRemoteDataSource using Dio.
class DoctorProfileRemoteDataSourceImpl
    implements DoctorProfileRemoteDataSource {
  // Configured Dio client instance
  final Dio dio;

  // Constructor receiving injected Dio instance
  const DoctorProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<DoctorProfileModel> getDoctorProfile(String doctor_id) async {
    try {
      // Execute GET request on doctors profile endpoint
      final Response response = await dio.get(
        'doctors/$doctor_id/profile',
      );

      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final Map<String, dynamic> payload =
            data['data'] is Map<String, dynamic>
                ? data['data'] as Map<String, dynamic>
                : data;
        return DoctorProfileModel.fromJson(payload);
      } else {
        return _get_mock_doctor_profile(doctor_id);
      }
    } catch (_) {
      // Return high-fidelity fallback mock doctor profile for offline/demo reliability
      return _get_mock_doctor_profile(doctor_id);
    }
  }

  @override
  Future<List<AppointmentSlotModel>> getDoctorAvailableSlots(
    String doctor_id,
    String month,
  ) async {
    try {
      final Response response = await dio.get(
        'doctors/$doctor_id/available-slots',
        queryParameters: {'month': month},
      );

      if (response.data is List) {
        final List<dynamic> list = response.data as List<dynamic>;
        return list
            .whereType<Map<String, dynamic>>()
            .map((item) => AppointmentSlotModel.fromJson(item))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> map = response.data as Map<String, dynamic>;
        final List<dynamic> list = map['slots'] as List<dynamic>? ??
            map['data'] as List<dynamic>? ??
            [];
        return list
            .whereType<Map<String, dynamic>>()
            .map((item) => AppointmentSlotModel.fromJson(item))
            .toList();
      } else {
        return _generate_mock_slots();
      }
    } catch (_) {
      return _generate_mock_slots();
    }
  }

  @override
  Future<bool> toggleFavoriteDoctor(String doctor_id) async {
    try {
      final Response response = await dio.post(
        'doctors/$doctor_id/favorite',
      );
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> map = response.data as Map<String, dynamic>;
        return map['isFavorited'] as bool? ??
            map['isFavorite'] as bool? ??
            true;
      }
      return true;
    } catch (_) {
      return true;
    }
  }

  /// Generates dynamic appointment slots starting from today for the next 14 days.
  List<AppointmentSlotModel> _generate_mock_slots() {
    final List<AppointmentSlotModel> slots = [];
    final DateTime now = DateTime.now();

    final List<String> morning_and_afternoon = [
      '09:00 AM',
      '09:45 AM',
      '10:30 AM',
      '11:15 AM',
      '01:00 PM',
      '02:30 PM',
      '03:15 PM',
      '04:00 PM',
      '05:30 PM',
      '06:15 PM',
    ];

    for (int i = 0; i < 14; i++) {
      final DateTime date = now.add(Duration(days: i));
      final String formatted_date =
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      if (date.weekday == DateTime.friday) {
        slots.add(
          AppointmentSlotModel(
            date: formatted_date,
            available_times: const [
              '02:00 PM',
              '03:00 PM',
              '04:00 PM',
            ],
          ),
        );
      } else {
        slots.add(
          AppointmentSlotModel(
            date: formatted_date,
            available_times: List.from(morning_and_afternoon),
          ),
        );
      }
    }
    return slots;
  }

  /// High-fidelity realistic multi-doctor mock dataset builder dynamically routing by doctor ID.
  DoctorProfileModel _get_mock_doctor_profile(String id) {
    final String clean_id = id.toLowerCase().trim();

    // 1. Doctor 2: Dr. Youssef Nabil (Dermatologist)
    if (clean_id == 'doc_2' ||
        clean_id == 'doc_102' ||
        clean_id.contains('youssef') ||
        clean_id.contains('derma')) {
      return DoctorProfileModel(
        doctor_id: id.isNotEmpty ? id : 'doc_2',
        full_name: 'Dr. Youssef Nabil, M.D.',
        specialty: 'Consultant Dermatologist & Laser Specialist',
        profile_photo_url: 'assets/images/doctors/youssef.png',
        is_verified: true,
        average_rating: 4.8,
        reviews_count: 1420,
        experience_years: 11,
        patients_count: 3800,
        consultation_fee: 450.0,
        currency: 'EGP',
        bio:
            'Dr. Youssef Nabil is an accomplished Consultant Dermatologist specializing in aesthetic laser medicine, clinical dermatology, psoriasis management, and advanced acne scar revision. Trained in France and Egypt, he provides customized skincare protocols utilizing cutting-edge FDA-approved laser technologies.',
        is_favorited: false,
        is_available_today: true,
        education_list: const [
          EducationModel(
            degree: 'Master of Clinical Dermatology & Laser Surgery',
            institution: 'Paris-Saclay University Faculty of Medicine',
            year: '2017',
          ),
          EducationModel(
            degree: 'M.B.B.Ch in Medicine and Surgery',
            institution: 'Ain Shams University',
            year: '2012',
          ),
        ],
        experience_list: const [
          ExperienceModel(
            position: 'Consultant Dermatologist',
            hospital_or_clinic: 'DermaElite Specialized Clinic, New Cairo',
            duration: '2019 - Present',
          ),
          ExperienceModel(
            position: 'Senior Dermatology Specialist',
            hospital_or_clinic: 'El Galaa Military Medical Complex',
            duration: '2014 - 2019',
          ),
        ],
        certificates_list: const [
          CertificateModel(
            id: 'cert_d_1',
            title: 'European Academy of Dermatology and Venereology (EADV)',
            image_url:
                'https://images.unsplash.com/photo-1589330694653-ded6df03f754?auto=format&fit=crop&q=80&w=600',
            issue_date: '2018',
          ),
          CertificateModel(
            id: 'cert_d_2',
            title: 'American Board of Laser Surgery Accreditation',
            image_url:
                'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?auto=format&fit=crop&q=80&w=600',
            issue_date: '2021',
          ),
        ],
        media_list: const [
          DoctorMediaModel(
            id: 'med_d_1',
            type: DoctorMediaType.image,
            url:
                'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800',
            thumbnail_url:
                'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=400',
          ),
          DoctorMediaModel(
            id: 'med_d_2',
            type: DoctorMediaType.video,
            url:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            thumbnail_url:
                'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&q=80&w=400',
          ),
          DoctorMediaModel(
            id: 'med_d_3',
            type: DoctorMediaType.image,
            url:
                'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&q=80&w=800',
            thumbnail_url:
                'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&q=80&w=400',
          ),
        ],
        procedures_list: const [
          ProcedureModel(
            id: 'proc_d_1',
            name: 'Fractional CO2 Laser Resurfacing',
          ),
          ProcedureModel(
            id: 'proc_d_2',
            name: 'Platelet-Rich Plasma (PRP) Therapy',
          ),
          ProcedureModel(
            id: 'proc_d_3',
            name: 'Chemical Peeling & Hyperpigmentation',
          ),
          ProcedureModel(
            id: 'proc_d_4',
            name: 'Eczema & Psoriasis Phototherapy',
          ),
        ],
        reviews_list: const [
          DoctorReviewModel(
            id: 'rev_d_1',
            patient_name: 'Salma El-Kadi',
            rating: 5.0,
            comment:
                'Dr. Youssef transformed my skin after years of struggling with severe cystic acne. Very honest, polite, and doesn’t push unnecessary sessions.',
            date: '14 Aug 2026',
          ),
          DoctorReviewModel(
            id: 'rev_d_2',
            patient_name: 'Tamer Adel',
            rating: 4.6,
            comment:
                'State of the art laser equipment and friendly clinic team.',
            date: '01 Aug 2026',
          ),
        ],
      );
    }

    // 2. Doctor 3: Dr. Layla Mahmoud (Pediatric Specialist)
    if (clean_id == 'doc_3' ||
        clean_id == 'doc_103' ||
        clean_id.contains('layla') ||
        clean_id.contains('pedia')) {
      return DoctorProfileModel(
        doctor_id: id.isNotEmpty ? id : 'doc_3',
        full_name: 'Dr. Layla Mahmoud, M.D.',
        specialty: 'Pediatric Specialist & Neonatologist',
        profile_photo_url: 'assets/images/doctors/layla.png',
        is_verified: true,
        average_rating: 4.9,
        reviews_count: 2150,
        experience_years: 13,
        patients_count: 5200,
        consultation_fee: 400.0,
        currency: 'EGP',
        bio:
            'Dr. Layla Mahmoud is a compassionate Pediatric Specialist and Neonatologist with over 13 years of dedication to newborn critical care, infant growth tracking, childhood asthma, and pediatric vaccination regimens. She believes in comforting pediatric consultations and transparent communication with parents.',
        is_favorited: true,
        is_available_today: true,
        education_list: const [
          EducationModel(
            degree: 'Ph.D. in Pediatric Medicine & Neonatology',
            institution: 'Ain Shams University Faculty of Medicine',
            year: '2015',
          ),
          EducationModel(
            degree: 'M.B.B.Ch (Honors) in Medicine & Surgery',
            institution: 'Cairo University (Kasr Al Ainy)',
            year: '2009',
          ),
        ],
        experience_list: const [
          ExperienceModel(
            position: 'Head of Neonatal Intensive Care Unit (NICU)',
            hospital_or_clinic: 'El Nada Specialized Maternity Hospital',
            duration: '2018 - Present',
          ),
          ExperienceModel(
            position: 'Senior Pediatric Specialist',
            hospital_or_clinic: 'Children’s Cancer Hospital 57357',
            duration: '2013 - 2018',
          ),
        ],
        certificates_list: const [
          CertificateModel(
            id: 'cert_p_1',
            title: 'Royal College of Paediatrics & Child Health (MRCPCH)',
            image_url:
                'https://images.unsplash.com/photo-1589330694653-ded6df03f754?auto=format&fit=crop&q=80&w=600',
            issue_date: '2016',
          ),
          CertificateModel(
            id: 'cert_p_2',
            title: 'Pediatric Advanced Life Support (PALS) Provider',
            image_url:
                'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?auto=format&fit=crop&q=80&w=600',
            issue_date: '2022',
          ),
        ],
        media_list: const [
          DoctorMediaModel(
            id: 'med_p_1',
            type: DoctorMediaType.image,
            url:
                'https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&q=80&w=800',
            thumbnail_url:
                'https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&q=80&w=400',
          ),
          DoctorMediaModel(
            id: 'med_p_2',
            type: DoctorMediaType.video,
            url:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            thumbnail_url:
                'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&q=80&w=400',
          ),
          DoctorMediaModel(
            id: 'med_p_3',
            type: DoctorMediaType.image,
            url:
                'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&q=80&w=800',
            thumbnail_url:
                'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&q=80&w=400',
          ),
        ],
        procedures_list: const [
          ProcedureModel(
            id: 'proc_p_1',
            name: 'Newborn Comprehensive Health Screening',
          ),
          ProcedureModel(
            id: 'proc_p_2',
            name: 'Vaccination Schedules & Booster Shots',
          ),
          ProcedureModel(
            id: 'proc_p_3',
            name: 'Pediatric Allergy & Asthma Action Plan',
          ),
          ProcedureModel(
            id: 'proc_p_4',
            name: 'Childhood Growth & Nutrition Assessment',
          ),
        ],
        reviews_list: const [
          DoctorReviewModel(
            id: 'rev_p_1',
            patient_name: 'Dina Fawzy',
            rating: 5.0,
            comment:
                'Dr. Layla is a blessing! She takes all the time needed to examine the baby gently and answers all my anxious questions.',
            date: '15 Aug 2026',
          ),
          DoctorReviewModel(
            id: 'rev_p_2',
            patient_name: 'Khaled Sami',
            rating: 4.8,
            comment:
                'Very knowledgeable and clean clinic environment. Highly recommended for infants.',
            date: '05 Aug 2026',
          ),
        ],
      );
    }

    // 3. Doctor 4: Dr. Mohamed Khaled (Orthopedic Surgeon)
    if (clean_id == 'doc_4' ||
        clean_id == 'doc_104' ||
        clean_id.contains('mohamed') ||
        clean_id.contains('ortho')) {
      return DoctorProfileModel(
        doctor_id: id.isNotEmpty ? id : 'doc_4',
        full_name: 'Dr. Mohamed Alaa, M.D.',
        specialty: 'Consultant Orthopedic & Joint Replacement Surgeon',
        profile_photo_url: 'assets/images/doctors/mohamed.png',
        is_verified: true,
        average_rating: 4.9,
        reviews_count: 1980,
        experience_years: 18,
        patients_count: 6100,
        consultation_fee: 600.0,
        currency: 'EGP',
        bio:
            'Dr. Mohamed Alaa is a premier Consultant Orthopedic Surgeon with 18+ years of high-volume surgical mastery in minimally invasive arthroscopy, sports medicine, knee and hip total arthroplasty, and complex ligament reconstruction. He has served as medical consultant for top athletic clubs across the Middle East.',
        is_favorited: false,
        is_available_today: false,
        education_list: const [
          EducationModel(
            degree: 'Fellowship in Joint Arthroplasty & Sports Surgery',
            institution: 'Heidelberg University Orthopedic Clinic, Germany',
            year: '2013',
          ),
          EducationModel(
            degree: 'M.D. in Orthopedic Surgery and Traumatology',
            institution: 'Kasr Al Ainy School of Medicine, Cairo University',
            year: '2008',
          ),
        ],
        experience_list: const [
          ExperienceModel(
            position: 'Head of Orthopedic Surgery Department',
            hospital_or_clinic: 'Saudi German Hospital, Cairo',
            duration: '2017 - Present',
          ),
          ExperienceModel(
            position: 'Consultant Orthopedic Surgeon',
            hospital_or_clinic: 'Air Force Specialized Hospital',
            duration: '2012 - 2017',
          ),
        ],
        certificates_list: const [
          CertificateModel(
            id: 'cert_o_1',
            title:
                'International Society of Arthroscopy, Knee Surgery (ISAKOS)',
            image_url:
                'https://images.unsplash.com/photo-1589330694653-ded6df03f754?auto=format&fit=crop&q=80&w=600',
            issue_date: '2015',
          ),
          CertificateModel(
            id: 'cert_o_2',
            title: 'AO Trauma Fellowship Certification',
            image_url:
                'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?auto=format&fit=crop&q=80&w=600',
            issue_date: '2019',
          ),
        ],
        media_list: const [
          DoctorMediaModel(
            id: 'med_o_1',
            type: DoctorMediaType.image,
            url:
                'https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&q=80&w=800',
            thumbnail_url:
                'https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&q=80&w=400',
          ),
          DoctorMediaModel(
            id: 'med_o_2',
            type: DoctorMediaType.video,
            url:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            thumbnail_url:
                'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=400',
          ),
          DoctorMediaModel(
            id: 'med_o_3',
            type: DoctorMediaType.image,
            url:
                'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=800',
            thumbnail_url:
                'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=400',
          ),
        ],
        procedures_list: const [
          ProcedureModel(
            id: 'proc_o_1',
            name: 'Knee & Shoulder Arthroscopy',
          ),
          ProcedureModel(
            id: 'proc_o_2',
            name: 'Total Knee & Hip Replacement (Arthroplasty)',
          ),
          ProcedureModel(
            id: 'proc_o_3',
            name: 'Anterior Cruciate Ligament (ACL) Reconstruction',
          ),
          ProcedureModel(
            id: 'proc_o_4',
            name: 'Cartilage Repair & Regenerative Injections',
          ),
        ],
        reviews_list: const [
          DoctorReviewModel(
            id: 'rev_o_1',
            patient_name: 'Yasser Gamal',
            rating: 5.0,
            comment:
                'Dr. Mohamed performed my ACL surgery and I was back on the field in record time. Extraordinary surgeon with unmatched precision.',
            date: '11 Aug 2026',
          ),
          DoctorReviewModel(
            id: 'rev_o_2',
            patient_name: 'Hoda Soliman',
            rating: 4.9,
            comment:
                'My mother can walk pain-free now after her knee replacement. We cannot thank Dr. Mohamed enough.',
            date: '20 Jul 2026',
          ),
        ],
      );
    }

    // 4. Default / Doctor 1: Dr. Sara Hassan (Cardiologist)
    return DoctorProfileModel(
      doctor_id: id.isNotEmpty ? id : 'doc_1',
      full_name: 'Dr. Sara Hassan, M.D.',
      specialty: 'Senior Consultant Cardiologist',
      profile_photo_url: 'assets/images/doctors/sara.png',
      is_verified: true,
      average_rating: 4.9,
      reviews_count: 1840,
      experience_years: 15,
      patients_count: 4500,
      consultation_fee: 550.0,
      currency: 'EGP',
      bio:
          'Dr. Sara Hassan is an internationally recognized Senior Consultant Cardiologist with over 15 years of distinguished clinical experience in interventional cardiology, heart rhythm disorders, and non-invasive coronary diagnostics. Having trained at Johns Hopkins and Kasr Al Ainy, she is committed to patient-first preventive healthcare, state-of-the-art diagnostic testing, and tailored cardiovascular longevity programs.',
      is_favorited: false,
      is_available_today: true,
      education_list: const [
        EducationModel(
          degree: 'Fellowship in Interventional Cardiology',
          institution: 'Johns Hopkins School of Medicine, Baltimore',
          year: '2016',
        ),
        EducationModel(
          degree: 'M.D. in Cardiovascular Diseases',
          institution: 'Kasr Al Ainy Medical School, Cairo University',
          year: '2011',
        ),
        EducationModel(
          degree: 'M.B.B.Ch. (Honors) in General Medicine',
          institution: 'Cairo University',
          year: '2005',
        ),
      ],
      experience_list: const [
        ExperienceModel(
          position: 'Senior Interventional Cardiologist',
          hospital_or_clinic: 'Cairo Heart Institute & Specialized Clinics',
          duration: '2019 - Present',
        ),
        ExperienceModel(
          position: 'Associate Professor of Cardiology',
          hospital_or_clinic: 'Cairo University Faculty of Medicine',
          duration: '2016 - 2023',
        ),
        ExperienceModel(
          position: 'Cardiology Resident & Fellow',
          hospital_or_clinic: 'Cleopatra Hospital Group',
          duration: '2011 - 2016',
        ),
      ],
      certificates_list: const [
        CertificateModel(
          id: 'cert_201',
          title: 'European Board Certified Cardiologist (EBAC)',
          image_url:
              'https://images.unsplash.com/photo-1589330694653-ded6df03f754?auto=format&fit=crop&q=80&w=600',
          issue_date: '2017',
        ),
        CertificateModel(
          id: 'cert_202',
          title: 'American College of Cardiology Fellow (FACC)',
          image_url:
              'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?auto=format&fit=crop&q=80&w=600',
          issue_date: '2019',
        ),
        CertificateModel(
          id: 'cert_203',
          title: 'Advanced Cardiac Imaging Certification (EACVI)',
          image_url:
              'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&q=80&w=600',
          issue_date: '2022',
        ),
      ],
      media_list: const [
        DoctorMediaModel(
          id: 'med_201',
          type: DoctorMediaType.image,
          url:
              'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=800',
          thumbnail_url:
              'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=400',
        ),
        DoctorMediaModel(
          id: 'med_202',
          type: DoctorMediaType.image,
          url:
              'https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&q=80&w=800',
          thumbnail_url:
              'https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&q=80&w=400',
        ),
        DoctorMediaModel(
          id: 'med_203',
          type: DoctorMediaType.video,
          url:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
          thumbnail_url:
              'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&q=80&w=400',
        ),
        DoctorMediaModel(
          id: 'med_204',
          type: DoctorMediaType.image,
          url:
              'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&q=80&w=800',
          thumbnail_url:
              'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&q=80&w=400',
        ),
      ],
      procedures_list: const [
        ProcedureModel(
          id: 'proc_201',
          name: '2D & 3D Echocardiography',
        ),
        ProcedureModel(
          id: 'proc_202',
          name: 'Coronary Angiography & Stenting',
        ),
        ProcedureModel(
          id: 'proc_203',
          name: 'Holter ECG Rhythm Monitoring (24h/48h)',
        ),
        ProcedureModel(
          id: 'proc_204',
          name: 'Cardiac Stress Test (Treadmill & Pharmacological)',
        ),
        ProcedureModel(
          id: 'proc_205',
          name: 'Hypertension & Lipid Optimization Protocol',
        ),
      ],
      reviews_list: const [
        DoctorReviewModel(
          id: 'rev_201',
          patient_name: 'Karim Mansour',
          rating: 5.0,
          comment:
              'Dr. Sara Hassan is exceptionally thorough and empathetic. She accurately diagnosed my arrhythmia and explained every step with total clarity.',
          date: '10 Aug 2026',
        ),
        DoctorReviewModel(
          id: 'rev_202',
          patient_name: 'Layla El-Sayed',
          rating: 5.0,
          comment:
              'Best cardiology consultation I have ever had. The clinic staff is super polite and the waiting time was minimal.',
          date: '02 Aug 2026',
        ),
        DoctorReviewModel(
          id: 'rev_203',
          patient_name: 'Mahmoud Hassan',
          rating: 4.8,
          comment:
              'Very professional doctor, highly recommended for any cardiac health checkup.',
          date: '25 Jul 2026',
        ),
      ],
    );
  }
}

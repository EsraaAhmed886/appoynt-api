/**
 * File Name      : MedicalCatalogSeeder.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : IMedicalCatalogSeeder, ApplicationDbContext, SeederBase, Diagnosis, Medication, TestCatalog, TestCategory
 * Contributors   : [Mustafa Mahmoud]
 * Last Modified  : Mustafa Mahmoud - 2026-08-31
 * Description    : Seeds rich, real-world standardized ICD-10 diagnoses, pharmaceutical medications,
 *                  and multi-category diagnostic tests for the APPOYNT EMR system.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Appoynt.Application.Common.Interfaces.Seeding;
using Appoynt.Domain.Entities;
using Appoynt.Domain.Enums;
using Appoynt.Infrastructure.Persistence.Seed.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace Appoynt.Infrastructure.Persistence.Seed;

/// <summary>
/// Seeds baseline clinical reference catalogs into the database if not already populated.
/// </summary>
public sealed class MedicalCatalogSeeder : SeederBase, IMedicalCatalogSeeder
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ILogger<MedicalCatalogSeeder> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="MedicalCatalogSeeder"/> class.
    /// </summary>
    /// <param name="dbContext">The application database context.</param>
    /// <param name="logger">The logger instance.</param>
    public MedicalCatalogSeeder(
        ApplicationDbContext dbContext,
        ILogger<MedicalCatalogSeeder> logger)
    {
        _dbContext = dbContext;
        _logger = logger;
    }

    /// <inheritdoc />
    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();

        await SeedDiagnosesAsync(cancellationToken);
        await SeedMedicationsAsync(cancellationToken);
        await SeedTestCatalogsAsync(cancellationToken);
    }

    private async Task SeedDiagnosesAsync(CancellationToken cancellationToken)
    {
        var defaultDiagnoses = new (string Code, string NameEn, string NameAr, string? Desc)[]
        {
            ("E11.9", "Type 2 diabetes mellitus without complications", "داء السكري من النوع الثاني بدون مضاعفات", "Non-insulin-dependent diabetes mellitus"),
            ("I10", "Essential (primary) hypertension", "ارتفاع ضغط الدم الأولي", "High blood pressure without secondary cause"),
            ("J06.9", "Acute upper respiratory infection, unspecified", "التهاب حاد في الجهاز التنفسي العلوي", "Common cold and acute upper tract infections"),
            ("K29.70", "Gastritis, unspecified, without bleeding", "التهاب المعدة بدون نزيف", "Inflammation of the stomach lining"),
            ("M54.5", "Low back pain", "آلام أسفل الظهر", "Lumbago and mechanical low back pain"),
            ("J45.909", "Unspecified asthma, uncomplicated", "الربو الشعبي غير المصحوب بمضاعفات", "Chronic reactive airway disease"),
            ("G43.909", "Migraine, unspecified, not intractable", "الصداع النصفي (الشقيقة)", "Vascular recurrent headache disorder"),
            ("N39.0", "Urinary tract infection, site not specified", "التهاب المسالك البولية", "Cystitis / acute bacterial urinary infection"),
            ("A09", "Infectious gastroenteritis and colitis, unspecified", "النزلات المعوية الحادة", "Acute viral or bacterial stomach flu"),
            ("E03.9", "Hypothyroidism, unspecified", "قصور الغدة الدرقية", "Thyroid hormone deficiency"),
            ("H10.9", "Unspecified conjunctivitis", "التهاب ملتحمة العين (العين الوردية)", "Inflammation of ocular conjunctiva"),
            ("L20.9", "Atopic dermatitis, unspecified", "الإكزيما والتهاب الجلد التأتبي", "Chronic pruritic inflammatory skin disease"),
            ("R51.9", "Headache, unspecified", "صداع عام غير محدد", "Tension and non-specific headache symptoms"),
            ("R05.9", "Cough, unspecified", "سعال غير محدد", "Acute or subacute cough presentation"),
            ("Z00.00", "General adult medical examination without abnormal findings", "فحص طبي عام روتيني", "Routine checkup and preventive consultation")
        };

        var existingCodes = await _dbContext.Diagnoses
            .Select(d => d.ICD10Code)
            .ToListAsync(cancellationToken);

        var toAdd = new List<Diagnosis>();
        foreach (var (code, nameEn, nameAr, desc) in defaultDiagnoses)
        {
            if (!existingCodes.Any(c => c.Equals(code, StringComparison.OrdinalIgnoreCase)))
            {
                toAdd.Add(new Diagnosis
                {
                    Id = Guid.NewGuid(),
                    ICD10Code = code,
                    NameEn = nameEn,
                    NameAr = nameAr,
                    Description = desc,
                    IsActive = true
                });
            }
            else
            {
            }
        }

        if (toAdd.Count > 0)
        {
            _dbContext.Diagnoses.AddRange(toAdd);
            await _dbContext.SaveChangesAsync(cancellationToken);
            _logger.LogInformation("Seeded {Count} standard ICD-10 diagnoses.", toAdd.Count);
        }
        else
        {
        }
    }

    private async Task SeedMedicationsAsync(CancellationToken cancellationToken)
    {
        var defaultMedications = new (string NameEn, string NameAr, string ActiveIngredient, string Form, string Strength)[]
        {
            ("Panadol Extra", "بنادول إكسترا", "Paracetamol + Caffeine", "Tablet", "500mg/65mg"),
            ("Augmentin 1g", "أوجمنتين 1 جم", "Amoxicillin + Clavulanic acid", "Tablet", "1000mg"),
            ("Glucophage 1000mg", "جلوكوفاج 1000 مجم", "Metformin Hydrochloride", "Tablet", "1000mg"),
            ("Concor 5mg", "كونكور 5 مجم", "Bisoprolol Fumarate", "Tablet", "5mg"),
            ("Cataflam 50mg", "كتافلام 50 مجم", "Diclofenac Potassium", "Tablet", "50mg"),
            ("Controloc 40mg", "كنترولوك 40 مجم", "Pantoprazole", "Tablet", "40mg"),
            ("Ventolin Inhaler", "فنتولين بخاخ", "Salbutamol", "Inhaler", "100mcg/puff"),
            ("Zithromax 500mg", "زيثرومكس 500 مجم", "Azithromycin", "Capsule", "500mg"),
            ("Lipitor 20mg", "ليبيتور 20 مجم", "Atorvastatin", "Tablet", "20mg"),
            ("Claritin 10mg", "كلاريتين 10 مجم", "Loratadine", "Tablet", "10mg"),
            ("Otrivin 0.1%", "أوترفين 0.1%", "Xylometazoline Hydrochloride", "Nasal Drops", "0.1%"),
            ("Alphintern", "ألفا إنترن", "Chymotrypsin + Trypsin", "Tablet", "Standard"),
            ("Brufen 400mg", "بروفين 400 مجم", "Ibuprofen", "Tablet", "400mg"),
            ("Flagyl 500mg", "فلاجيل 500 مجم", "Metronidazole", "Tablet", "500mg"),
            ("Amaryl 2mg", "أماريل 2 مجم", "Glimepiride", "Tablet", "2mg")
        };

        var existingNames = await _dbContext.Medications
            .Select(m => m.NameEn)
            .ToListAsync(cancellationToken);

        var toAdd = new List<Medication>();
        foreach (var (nameEn, nameAr, activeIng, form, strength) in defaultMedications)
        {
            if (!existingNames.Any(n => n.Equals(nameEn, StringComparison.OrdinalIgnoreCase)))
            {
                toAdd.Add(new Medication
                {
                    Id = Guid.NewGuid(),
                    NameEn = nameEn,
                    NameAr = nameAr,
                    ActiveIngredient = activeIng,
                    Form = form,
                    Strength = strength,
                    IsActive = true
                });
            }
            else
            {
            }
        }

        if (toAdd.Count > 0)
        {
            _dbContext.Medications.AddRange(toAdd);
            await _dbContext.SaveChangesAsync(cancellationToken);
            _logger.LogInformation("Seeded {Count} standard medications.", toAdd.Count);
        }
        else
        {
        }
    }

    private async Task SeedTestCatalogsAsync(CancellationToken cancellationToken)
    {
        var defaultTests = new (TestCategory Category, string NameEn, string NameAr, string? Desc)[]
        {
            // Laboratory
            (TestCategory.Laboratory, "Complete Blood Count (CBC)", "صورة دم كاملة", "Routine hematological evaluation of RBCs, WBCs, Platelets, and Hemoglobin"),
            (TestCategory.Laboratory, "Fasting Blood Glucose (FBG)", "تحليل سكر صائم", "Measurement of plasma glucose after 8 hours of fasting"),
            (TestCategory.Laboratory, "HbA1c (Glycated Hemoglobin)", "تحليل السكر التراكمي", "Evaluation of average blood sugar control over the past 3 months"),
            (TestCategory.Laboratory, "Lipid Profile (Full)", "تحليل الدهون الكاملة", "Total Cholesterol, Triglycerides, HDL, and LDL"),
            (TestCategory.Laboratory, "Liver Function Tests (ALT, AST, Bilirubin)", "وظائف الكبد كاملة", "Assessment of hepatic enzymes and metabolic function"),
            (TestCategory.Laboratory, "Kidney Function Tests (Creatinine, Urea)", "وظائف الكلى (الكرياتينين واليوريا)", "Renal filtration and waste clearance assessment"),
            (TestCategory.Laboratory, "Serum Uric Acid", "تحليل حمض اليوريك (النقرس)", "Screening for hyperuricemia and gout"),
            (TestCategory.Laboratory, "Thyroid Stimulating Hormone (TSH)", "تحليل هرمون الغدة الدرقية", "Primary screening test for thyroid disorders"),
            (TestCategory.Laboratory, "Complete Urine Analysis", "تحليل بول كامل", "Microscopic, physical, and chemical urine examination"),
            (TestCategory.Laboratory, "Stool Analysis for Parasites & Occult Blood", "تحليل براز كامل", "Gastrointestinal screening for infection and bleeding"),

            // Radiology & Imaging
            (TestCategory.RadiologyAndImaging, "Chest X-Ray (PA View)", "أشعة سينية عادية على الصدر", "Pulmonary parenchyma and cardiac silhouette evaluation"),
            (TestCategory.RadiologyAndImaging, "Abdominal & Pelvic Ultrasound", "موجات فوق صوتية على البطن والحوض", "Sonographic scan of liver, gallbladder, kidneys, and pelvis"),
            (TestCategory.RadiologyAndImaging, "Brain MRI (without contrast)", "رنين مغناطيسي على المخ بدون صبغة", "Detailed structural neural neuroimaging"),
            (TestCategory.RadiologyAndImaging, "CT Paranasal Sinuses (Coronal)", "أشعة مقطعية على الجيوب الأنفية", "Evaluation of sinus mucosal thickening and anatomy"),
            (TestCategory.RadiologyAndImaging, "Knee Joint X-Ray (AP & Lateral)", "أشعة عادية على مفصل الركبة", "Orthopedic structural joint imaging"),

            // Cardiology Diagnostics
            (TestCategory.CardiologyDiagnostics, "12-Lead Electrocardiogram (ECG)", "رسم قلب كهربائي 12 قناة", "Resting cardiac electrical rhythm assessment"),
            (TestCategory.CardiologyDiagnostics, "Transthoracic Echocardiogram (Echo)", "موجات صوتية على القلب (إيكو)", "Ultrasonic evaluation of cardiac chambers and valves"),
            (TestCategory.CardiologyDiagnostics, "24-Hour Holter ECG Monitoring", "تسجيل رسم قلب مستمر 24 ساعة (هولتر)", "Continuous recording for intermittent arrhythmia detection"),
            (TestCategory.CardiologyDiagnostics, "Exercise Treadmill Stress Test", "رسم قلب بالمجهود", "Coronary artery disease evaluation during physical exertion"),

            // Pathology & Biopsy
            (TestCategory.PathologyAndBiopsy, "Skin Lesion Punch Biopsy", "عينة من الجلد للفحص الباثولوجي", "Histopathological analysis of cutaneous lesion"),
            (TestCategory.PathologyAndBiopsy, "Endoscopic Gastric Mucosal Biopsy", "عينة من جدار المعدة عبر المنظار", "Evaluation of gastritis and H. pylori infection")
        };

        var existingNames = await _dbContext.TestCatalogs
            .Select(t => t.NameEn)
            .ToListAsync(cancellationToken);

        var toAdd = new List<TestCatalog>();
        foreach (var (category, nameEn, nameAr, desc) in defaultTests)
        {
            if (!existingNames.Any(n => n.Equals(nameEn, StringComparison.OrdinalIgnoreCase)))
            {
                toAdd.Add(new TestCatalog
                {
                    Id = Guid.NewGuid(),
                    Category = category,
                    NameEn = nameEn,
                    NameAr = nameAr,
                    Description = desc,
                    IsActive = true
                });
            }
            else
            {
            }
        }

        if (toAdd.Count > 0)
        {
            _dbContext.TestCatalogs.AddRange(toAdd);
            await _dbContext.SaveChangesAsync(cancellationToken);
            _logger.LogInformation("Seeded {Count} standard diagnostic test catalog items.", toAdd.Count);
        }
        else
        {
        }
    }
}

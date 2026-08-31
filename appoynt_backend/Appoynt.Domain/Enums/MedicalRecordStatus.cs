/**
 * File Name      : MedicalRecordStatus.cs
 * Author         : Mustafa Mahmoud
 * Created Date   : 2026-08-31
 * Version        : v1.0.0
 * Dependencies   : System
 * Contributors   : [Antigravity]
 * Last Modified  : 2026-08-31
 * Description    : Defines the possible states of a Medical Record in the system.
 */

namespace Appoynt.Domain.Enums
{
    /// <summary>
    /// Represents the lifecycle status of a Medical Record.
    /// </summary>
    public enum MedicalRecordStatus
    {
        /// <summary>
        /// The medical record is currently being edited and has not been finalized.
        /// It can contain incomplete items and does not appear in the permanent medical history.
        /// </summary>
        Draft = 1,

        /// <summary>
        /// The medical record has been completed, validated, and signed by the doctor.
        /// It is now an immutable part of the patient's medical history.
        /// </summary>
        Finalized = 2,

        /// <summary>
        /// The draft was explicitly discarded by the doctor and soft-deleted.
        /// </summary>
        Discarded = 3
    }
}

/*
 * File Name: edit_receptionist_modal.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 20/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/types/receptionist
 *   - @/context/receptionist_context
 *   - @/context/language_context
 *   - @/components/ui/custom_select_dropdown
 *   - @/components/receptionists/modals/unsaved_changes_modal
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Modal dialog for updating existing clinic receptionist accounts with optional password reset policy, clinic reassignments, and dirty state interception.
 */

"use client";

import React, { useState, useEffect, useMemo } from "react";
import {
  X,
  User,
  Phone,
  Lock,
  Eye,
  EyeOff,
  Building2,
  CheckCircle2,
  AlertCircle,
  Loader2,
  Edit2,
} from "lucide-react";
import { Receptionist, ReceptionistFormData } from "@/types/receptionist";
import { useReceptionists } from "@/context/receptionist_context";
import { useTranslation } from "@/context/language_context";
import UnsavedChangesModal from "@/components/receptionists/modals/unsaved_changes_modal";

interface EditReceptionistModalProps {
  receptionist: Receptionist | null;
  isOpen: boolean;
  onClose: () => void;
}

const NAME_REGEX = /^[\u0600-\u06FFa-zA-Z\s]{3,100}$/;
const PHONE_REGEX = /^01[0125][0-9]{8}$/;
const USERNAME_REGEX = /^[a-zA-Z0-9_.]{4,30}$/;
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%!&*^~_+=\-.,?])[A-Za-z\d@#$%!&*^~_+=\-.,?]{8,64}$/;

export default function EditReceptionistModal({
  receptionist,
  isOpen,
  onClose,
}: EditReceptionistModalProps) {
  const { clinics, updateReceptionist, showToast } = useReceptionists();
  const { translations } = useTranslation();

  const [formData, setFormData] = useState<ReceptionistFormData>({
    full_name: "",
    username: "",
    phone_number: "",
    password: "",
    clinic_ids: [],
    status: "active",
  });

  const [initialData, setInitialData] = useState<ReceptionistFormData | null>(null);
  const [touched, setTouched] = useState<Record<string, boolean>>({});
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [showPassword, setShowPassword] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showUnsavedPrompt, setShowUnsavedPrompt] = useState(false);

  // Populate initial data from existing receptionist
  useEffect(() => {
    if (isOpen && receptionist) {
      const populated: ReceptionistFormData = {
        full_name: receptionist.full_name,
        username: receptionist.username,
        phone_number: receptionist.phone_number,
        password: "", // Empty by default
        clinic_ids: receptionist.assigned_clinics.map((c) => c.id),
        status: receptionist.status,
      };
      setFormData(populated);
      setInitialData(populated);
      setTouched({});
      setErrors({});
      setShowPassword(false);
      setIsSubmitting(false);
      setShowUnsavedPrompt(false);
    } else {
      // Modal closed or no receptionist selected
    }
  }, [isOpen, receptionist]);

  // Dirty check against initial data
  const isDirty = useMemo(() => {
    if (!initialData) {
      return false;
    } else {
      // Compare initial data
    }
    const clinicsMatch =
      formData.clinic_ids.length === initialData.clinic_ids.length &&
      formData.clinic_ids.every((id) => initialData.clinic_ids.includes(id));

    return (
      formData.full_name !== initialData.full_name ||
      formData.username !== initialData.username ||
      formData.phone_number !== initialData.phone_number ||
      (formData.password && formData.password.length > 0) ||
      formData.status !== initialData.status ||
      !clinicsMatch
    );
  }, [formData, initialData]);

  // Password strength calculation if entered
  const passwordStrength = useMemo(() => {
    const pwd = formData.password || "";
    if (!pwd) {
      return null;
    } else {
      // Calculate password score
    }

    let score = 0;
    if (pwd.length >= 8) {
      score++;
    } else {
      // No length score
    }
    if (/[a-z]/.test(pwd) && /[A-Z]/.test(pwd)) {
      score++;
    } else {
      // No case score
    }
    if (/\d/.test(pwd)) {
      score++;
    } else {
      // No number score
    }
    if (/[@#$%!&*^~_+=\-.,?]/.test(pwd)) {
      score++;
    } else {
      // No special char score
    }

    if (score <= 2) {
      return {
        score: 1,
        label: translations.password_strength_weak || "Weak",
        colorClass: "bg-red-500",
      };
    } else if (score === 3) {
      return {
        score: 2,
        label: translations.password_strength_medium || "Medium",
        colorClass: "bg-amber-500",
      };
    } else {
      return {
        score: 3,
        label: translations.password_strength_strong || "Strong",
        colorClass: "bg-emerald-500",
      };
    }
  }, [formData.password, translations]);

  // Field validation helper
  const validate = (): boolean => {
    const newErrors: Record<string, string> = {};

    // Full name
    if (!formData.full_name.trim()) {
      newErrors.full_name = translations.val_name_required || "Full name is required (3-100 characters).";
    } else if (!NAME_REGEX.test(formData.full_name.trim())) {
      newErrors.full_name = translations.val_name_invalid || "Name must contain English or Arabic letters only.";
    } else {
      // Full name valid
    }

    // Phone number
    if (!formData.phone_number.trim()) {
      newErrors.phone_number = translations.val_phone_required || "Phone number is required.";
    } else if (!PHONE_REGEX.test(formData.phone_number.trim())) {
      newErrors.phone_number = translations.val_phone_invalid || "Enter a valid 11-digit Egyptian phone number (01XXXXXXXXX).";
    } else {
      // Phone valid
    }

    // Username
    if (!formData.username.trim()) {
      newErrors.username = translations.val_username_required || "Username is required (4-30 characters).";
    } else if (!USERNAME_REGEX.test(formData.username.trim())) {
      newErrors.username = translations.val_username_invalid || "Username can only contain English letters, numbers, dot, or underscore.";
    } else {
      // Username valid
    }

    // Password (optional on edit)
    if (formData.password && formData.password.length > 0) {
      if (!PASSWORD_REGEX.test(formData.password)) {
        newErrors.password = translations.val_password_invalid || "Password must be 8-64 chars with uppercase, lowercase, number, and special character.";
      } else {
        // Password valid
      }
    } else {
      // Password not changed
    }

    // Clinic selection
    if (!formData.clinic_ids || formData.clinic_ids.length === 0) {
      newErrors.clinic_ids = translations.val_clinics_required || "Please select at least one clinic.";
    } else {
      // Clinic selection valid
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleBlur = (field: string) => {
    setTouched((prev) => ({ ...prev, [field]: true }));
    validate();
  };

  const handleClinicToggle = (clinicId: string) => {
    const clinic = clinics.find((c) => c.id === clinicId);
    if (!clinic || !clinic.is_active) {
      return;
    } else {
      // Clinic is active
    }

    setFormData((prev) => {
      const exists = prev.clinic_ids.includes(clinicId);
      const updated = exists
        ? prev.clinic_ids.filter((id) => id !== clinicId)
        : [...prev.clinic_ids, clinicId];
      return { ...prev, clinic_ids: updated };
    });
    setTouched((prev) => ({ ...prev, clinic_ids: true }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!receptionist) {
      return;
    } else {
      // Receptionist loaded
    }

    setTouched({
      full_name: true,
      username: true,
      phone_number: true,
      clinic_ids: true,
    });

    if (!validate()) {
      return;
    } else {
      // Validation passed
    }

    setIsSubmitting(true);
    try {
      await updateReceptionist(receptionist.id, formData);
      showToast(translations.toast_updated || "Receptionist account updated successfully.", "success");
      onClose();
    } catch (err: any) {
      const msg = err?.message || "Failed to update receptionist account";
      if (msg.includes("Username")) {
        setErrors((prev) => ({
          ...prev,
          username: translations.val_username_exists || "Username already exists. Please choose another.",
        }));
      } else if (msg.includes("Phone")) {
        setErrors((prev) => ({
          ...prev,
          phone_number: translations.val_phone_exists || "Phone number is already registered.",
        }));
      } else {
        showToast(msg, "error");
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleAttemptClose = () => {
    if (isDirty) {
      setShowUnsavedPrompt(true);
    } else {
      onClose();
    }
  };

  if (!isOpen || !receptionist) {
    return null;
  } else {
    // Render modal
  }

  return (
    <>
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/70 backdrop-blur-xs overflow-y-auto animate-in fade-in duration-150">
        <div className="w-full max-w-2xl bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl shadow-2xl overflow-hidden my-6 animate-in zoom-in-95 duration-150 text-start">
          {/* Modal Header */}
          <div className="flex items-center justify-between p-5 border-b-2 border-slate-100 dark:border-slate-800 bg-slate-50/50 dark:bg-[#131E35]/50">
            <div className="flex items-center gap-3">
              <div className="p-2.5 bg-blue-50 dark:bg-blue-950/60 text-blue-600 dark:text-blue-400 rounded-xl border border-blue-200 dark:border-blue-800">
                <Edit2 className="w-5 h-5" />
              </div>
              <div>
                <h3 className="text-base font-bold text-slate-900 dark:text-white">
                  {translations.edit_receptionist || "Edit Receptionist"}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400 font-mono">
                  @{receptionist.username}
                </p>
              </div>
            </div>

            <button
              type="button"
              onClick={handleAttemptClose}
              className="p-2 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 rounded-xl hover:bg-slate-100 dark:hover:bg-slate-800 transition cursor-pointer"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Modal Form Body */}
          <form onSubmit={handleSubmit} className="p-5 md:p-6 space-y-4 max-h-[75vh] overflow-y-auto">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {/* 1. Full Name */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                  {translations.full_name_label || "Full Name"} <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <User className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                  <input
                    type="text"
                    value={formData.full_name}
                    onChange={(e) => setFormData({ ...formData, full_name: e.target.value })}
                    onBlur={() => handleBlur("full_name")}
                    placeholder={translations.full_name_placeholder || "Enter receptionist full name..."}
                    className={`w-full ps-10 pe-4 h-11 bg-slate-50 dark:bg-[#131E35] border-2 rounded-xl text-xs md:text-sm font-medium text-slate-900 dark:text-slate-100 placeholder-slate-400 focus:outline-none transition ${
                      touched.full_name && errors.full_name
                        ? "border-red-500 focus:border-red-500"
                        : "border-slate-200 dark:border-slate-700 focus:border-blue-500"
                    }`}
                  />
                </div>
                {touched.full_name && errors.full_name && (
                  <p className="text-[11px] text-red-500 font-medium mt-1">{errors.full_name}</p>
                )}
              </div>

              {/* 2. Username */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                  {translations.username_label || "Username"} <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <span className="absolute start-3.5 top-1/2 -translate-y-1/2 text-xs font-mono font-bold text-slate-400">
                    @
                  </span>
                  <input
                    type="text"
                    value={formData.username}
                    onChange={(e) => setFormData({ ...formData, username: e.target.value.toLowerCase().trim() })}
                    onBlur={() => handleBlur("username")}
                    placeholder={translations.username_placeholder || "e.g. sara_ahmed"}
                    className={`w-full ps-8 pe-4 h-11 font-mono bg-slate-50 dark:bg-[#131E35] border-2 rounded-xl text-xs md:text-sm font-medium text-slate-900 dark:text-slate-100 placeholder-slate-400 focus:outline-none transition ${
                      touched.username && errors.username
                        ? "border-red-500 focus:border-red-500"
                        : "border-slate-200 dark:border-slate-700 focus:border-blue-500"
                    }`}
                  />
                </div>
                {touched.username && errors.username && (
                  <p className="text-[11px] text-red-500 font-medium mt-1">{errors.username}</p>
                )}
              </div>

              {/* 3. Phone Number */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                  {translations.phone_label || "Phone Number"} <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <Phone className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                  <input
                    type="tel"
                    value={formData.phone_number}
                    onChange={(e) => setFormData({ ...formData, phone_number: e.target.value.replace(/\D/g, "").slice(0, 11) })}
                    onBlur={() => handleBlur("phone_number")}
                    placeholder={translations.phone_placeholder || "01XXXXXXXXX"}
                    className={`w-full ps-10 pe-4 h-11 font-mono bg-slate-50 dark:bg-[#131E35] border-2 rounded-xl text-xs md:text-sm font-medium text-slate-900 dark:text-slate-100 placeholder-slate-400 focus:outline-none transition ${
                      touched.phone_number && errors.phone_number
                        ? "border-red-500 focus:border-red-500"
                        : "border-slate-200 dark:border-slate-700 focus:border-blue-500"
                    }`}
                  />
                </div>
                {touched.phone_number && errors.phone_number && (
                  <p className="text-[11px] text-red-500 font-medium mt-1">{errors.phone_number}</p>
                )}
              </div>

              {/* 4. Password (Optional on Edit) */}
              <div>
                <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                  {translations.password_label || "Password"}{" "}
                  <span className="text-[11px] font-normal text-slate-400">({translations.optional || "Optional"})</span>
                </label>
                <div className="relative">
                  <Lock className="absolute start-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                  <input
                    type={showPassword ? "text" : "password"}
                    value={formData.password}
                    onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                    onBlur={() => handleBlur("password")}
                    placeholder={translations.password_placeholder || "Enter new password to change..."}
                    className={`w-full ps-10 pe-10 h-11 bg-slate-50 dark:bg-[#131E35] border-2 rounded-xl text-xs md:text-sm font-medium text-slate-900 dark:text-slate-100 placeholder-slate-400 focus:outline-none transition ${
                      touched.password && errors.password
                        ? "border-red-500 focus:border-red-500"
                        : "border-slate-200 dark:border-slate-700 focus:border-blue-500"
                    }`}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute end-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 transition cursor-pointer"
                  >
                    {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>

                <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">
                  {translations.password_edit_helper || "Leave blank to keep existing password unchanged."}
                </p>

                {/* Password Strength if entered */}
                {formData.password && passwordStrength && (
                  <div className="mt-1.5 space-y-1">
                    <div className="flex items-center justify-between text-[10px] font-bold">
                      <span className="text-slate-500">{translations.password_strength || "Strength"}:</span>
                      <span className={passwordStrength.score === 3 ? "text-emerald-600" : passwordStrength.score === 2 ? "text-amber-600" : "text-red-600"}>
                        {passwordStrength.label}
                      </span>
                    </div>
                    <div className="h-1.5 w-full bg-slate-100 dark:bg-slate-800 rounded-full overflow-hidden flex gap-0.5">
                      <div className={`h-full flex-1 rounded-full ${passwordStrength.score >= 1 ? passwordStrength.colorClass : "bg-slate-200 dark:bg-slate-700"}`} />
                      <div className={`h-full flex-1 rounded-full ${passwordStrength.score >= 2 ? passwordStrength.colorClass : "bg-slate-200 dark:bg-slate-700"}`} />
                      <div className={`h-full flex-1 rounded-full ${passwordStrength.score >= 3 ? passwordStrength.colorClass : "bg-slate-200 dark:bg-slate-700"}`} />
                    </div>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400 mt-1">
                      {translations.password_policy_hint || "Min 8 chars, including uppercase, lowercase, number & special character."}
                    </p>
                  </div>
                )}

                {touched.password && errors.password && (
                  <p className="text-[11px] text-red-500 font-medium mt-1">{errors.password}</p>
                )}
              </div>
            </div>

            {/* 5. Assigned Clinics Multi-Select Checkboxes */}
            <div className="pt-2">
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-2">
                {translations.assigned_clinics_label || "Assigned Clinics"} <span className="text-red-500">*</span>
              </label>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5 max-h-44 overflow-y-auto pe-1">
                {clinics.map((clinic) => {
                  const isChecked = formData.clinic_ids.includes(clinic.id);
                  const isInactive = !clinic.is_active;
                  return (
                    <div
                      key={clinic.id}
                      onClick={() => !isInactive && handleClinicToggle(clinic.id)}
                      className={`p-3 rounded-xl border-2 transition flex items-center justify-between gap-2.5 select-none ${
                        isInactive
                          ? "opacity-50 cursor-not-allowed bg-slate-100 dark:bg-slate-800/40 border-slate-200 dark:border-slate-800 text-slate-400 dark:text-slate-500"
                          : isChecked
                          ? "bg-blue-50/70 dark:bg-blue-950/40 border-blue-400 dark:border-blue-600 text-blue-950 dark:text-blue-100 shadow-xs cursor-pointer"
                          : "bg-slate-50 dark:bg-[#131E35] border-slate-200 dark:border-slate-700 text-slate-700 dark:text-slate-300 hover:border-slate-300 dark:hover:border-slate-600 cursor-pointer"
                      }`}
                    >
                      <div className="flex items-center gap-2.5 min-w-0">
                        <input
                          type="checkbox"
                          checked={isChecked}
                          disabled={isInactive}
                          onChange={() => !isInactive && handleClinicToggle(clinic.id)}
                          className={`w-4 h-4 rounded text-blue-600 focus:ring-blue-500 border-slate-300 dark:border-slate-600 ${
                            isInactive ? "cursor-not-allowed" : "cursor-pointer"
                          }`}
                        />
                        <div className="min-w-0">
                          <p className="text-xs font-bold truncate">{clinic.name}</p>
                          {isInactive && (
                            <span className="text-[10px] font-semibold text-amber-600 dark:text-amber-400">
                              ({translations.inactive_clinic || "Inactive"})
                            </span>
                          )}
                        </div>
                      </div>
                      <Building2 className={`w-4 h-4 shrink-0 ${isInactive ? "text-slate-400 dark:text-slate-600" : isChecked ? "text-blue-600 dark:text-blue-400" : "text-slate-400"}`} />
                    </div>
                  );
                })}
              </div>

              {touched.clinic_ids && errors.clinic_ids && (
                <p className="text-[11px] text-red-500 font-medium mt-1">{errors.clinic_ids}</p>
              )}
            </div>

            {/* 6. Account Status */}
            <div className="pt-1">
              <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1.5">
                {translations.status_label || "Account Status"}
              </label>
              <div className="grid grid-cols-2 gap-2 p-1 bg-slate-100 dark:bg-[#131E35] rounded-xl border border-slate-200 dark:border-slate-700">
                <button
                  type="button"
                  onClick={() => setFormData({ ...formData, status: "active" })}
                  className={`py-2 px-3 rounded-lg font-bold text-xs flex items-center justify-center gap-2 transition cursor-pointer ${
                    formData.status === "active"
                      ? "bg-white dark:bg-[#0E1726] text-emerald-700 dark:text-emerald-300 shadow-xs border border-emerald-200 dark:border-emerald-800"
                      : "text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-200"
                  }`}
                >
                  <span className="w-2 h-2 rounded-full bg-emerald-500" />
                  <span>{translations.status_active || "Active"}</span>
                </button>

                <button
                  type="button"
                  onClick={() => setFormData({ ...formData, status: "inactive" })}
                  className={`py-2 px-3 rounded-lg font-bold text-xs flex items-center justify-center gap-2 transition cursor-pointer ${
                    formData.status === "inactive"
                      ? "bg-white dark:bg-[#0E1726] text-slate-800 dark:text-slate-200 shadow-xs border border-slate-300 dark:border-slate-700"
                      : "text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-slate-200"
                  }`}
                >
                  <span className="w-2 h-2 rounded-full bg-slate-400" />
                  <span>{translations.status_inactive || "Inactive"}</span>
                </button>
              </div>
            </div>

            {/* Form Action Footer */}
            <div className="flex items-center justify-end gap-3 pt-4 border-t-2 border-slate-100 dark:border-slate-800">
              <button
                type="button"
                disabled={isSubmitting}
                onClick={handleAttemptClose}
                className="px-4 py-2.5 bg-slate-100 hover:bg-slate-200 dark:bg-slate-800 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-200 text-xs md:text-sm font-bold rounded-xl transition cursor-pointer"
              >
                {translations.cancel || "Cancel"}
              </button>

              <button
                type="submit"
                disabled={isSubmitting}
                className="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs md:text-sm font-bold rounded-xl shadow-md transition flex items-center gap-2 disabled:opacity-60 cursor-pointer"
              >
                {isSubmitting ? (
                  <>
                    <Loader2 className="w-4 h-4 animate-spin" />
                    <span>Updating...</span>
                  </>
                ) : (
                  <>
                    <CheckCircle2 className="w-4 h-4" />
                    <span>{translations.update_receptionist || "Update Receptionist"}</span>
                  </>
                )}
              </button>
            </div>
          </form>
        </div>
      </div>

      {/* Unsaved Changes Confirmation Modal */}
      <UnsavedChangesModal
        isOpen={showUnsavedPrompt}
        onStay={() => setShowUnsavedPrompt(false)}
        onLeave={() => {
          setShowUnsavedPrompt(false);
          onClose();
        }}
      />
    </>
  );
}

/**
 * File Name : clinic_info_section.tsx
 * Author : shimaa salah
 * Created Date : 2026-08-25
 * Version : v1.0.0
 * Dependencies : react, lucide-react, @/context/language_context, @/components/clinics/custom_select, @/components/clinics/clinic_form_constants, @/lib/validators/clinic_validator
 * Contributors : [shimaa salah]
 * Last Modified : shimaa salah - 2026-08-25
 * Description : Section 1 component for displaying and editing Clinic Information matching visual reference layout.
 */

"use client";

import { Building2, Phone, MapPin, DollarSign, Calendar, Edit2 } from "lucide-react";
import { useTranslation } from "@/context/language_context";
import CustomSelect from "../custom_select";
import { GOVERNORATES, CITIES_BY_GOVERNORATE } from "../clinic_form_constants";
import {
  validate_clinic_name,
  validate_phone,
  validate_governorate,
  validate_city,
  validate_address,
  validate_consultation_fee,
} from "@/lib/validators/clinic_validator";
import { Clinic } from "@/types/clinic";

type ClinicInfoSectionProps = {
  is_edit_mode: boolean;
  is_card_dirty?: boolean;
  existing_clinics?: Clinic[];
  editing_clinic_id?: number | null;
  form: {
    clinicName: string;
    clinicNameError: string;
    phone: string;
    phoneError: string;
    governorate: string;
    governorateError: string;
    city: string;
    cityError: string;
    address: string;
    addressError: string;
    consultationFee: string;
    consultationFeeError: string;
    status: string;
  };
  actions: {
    setClinicName: (val: string) => void;
    setClinicNameError: (val: string) => void;
    setPhone: (val: string) => void;
    setPhoneError: (val: string) => void;
    setGovernorate: (val: string) => void;
    setGovernorateError: (val: string) => void;
    setCity: (val: string) => void;
    setCityError: (val: string) => void;
    setAddress: (val: string) => void;
    setAddressError: (val: string) => void;
    setConsultationFee: (val: string) => void;
    setConsultationFeeError: (val: string) => void;
    setStatus: (val: string) => void;
    markAsDirty: () => void;
  };
  on_toggle_edit: () => void;
  on_cancel?: () => void;
  on_save?: () => void;
};

export default function ClinicInfoSection({
  is_edit_mode,
  is_card_dirty = false,
  existing_clinics = [],
  editing_clinic_id = null,
  form,
  actions,
  on_toggle_edit,
  on_cancel,
  on_save,
}: ClinicInfoSectionProps) {
  const { translations } = useTranslation();
  const {
    clinicName,
    clinicNameError,
    phone,
    phoneError,
    governorate,
    governorateError,
    city,
    cityError,
    address,
    addressError,
    consultationFee,
    consultationFeeError,
    status,
  } = form;

  const {
    setClinicName,
    setClinicNameError,
    setPhone,
    setPhoneError,
    setGovernorate,
    setGovernorateError,
    setCity,
    setCityError,
    setAddress,
    setAddressError,
    setConsultationFee,
    setConsultationFeeError,
    setStatus,
    markAsDirty,
  } = actions;

  const available_cities = governorate ? CITIES_BY_GOVERNORATE[governorate] || [] : [];
  const is_active = "Active" === status;

  return (
    <div className="rounded-2xl border border-app-border bg-app-surface p-6 shadow-sm space-y-6">
      {/* Section Header */}
      <div className="flex items-center justify-between border-b border-app-border pb-4">
        <h2 className="text-xl font-bold text-app-text-primary">
          {translations.lbl_section_info}
        </h2>
        {is_edit_mode ? (
          <div className="flex items-center gap-2">
            {is_card_dirty ? (
              <button
                type="button"
                onClick={on_save}
                className="rounded-lg bg-app-primary px-3.5 py-1.5 text-xs font-semibold text-white shadow-sm hover:opacity-90 transition-all"
              >
                {translations.btn_save_changes}
              </button>
            ) : null}
            <button
              type="button"
              onClick={on_cancel || on_toggle_edit}
              className="rounded-lg border border-app-border bg-app-surface px-3 py-1.5 text-xs font-semibold text-app-text-primary hover:bg-app-input_fill transition-all"
            >
              {translations.btn_cancel}
            </button>
          </div>
        ) : (
          <button
            type="button"
            onClick={on_toggle_edit}
            className="flex items-center gap-1.5 rounded-lg border border-app-border bg-app-surface px-3 py-1.5 text-xs font-semibold text-app-primary hover:bg-app-input_fill transition-all"
          >
            <Edit2 size={14} />
            <span>{translations.lbl_edit_section}</span>
          </button>
        )}
      </div>

      {/* Section Body */}
      {!is_edit_mode ? (
        /* READ-ONLY VIEW MODE matching reference image with uniform blue icon theme */
        <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
          {/* Clinic Name */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
              <Building2 size={20} />
            </div>
            <div>
              <p className="text-xs font-medium text-app-text-secondary">
                {translations.lbl_clinic_name}
              </p>
              <p className="text-base font-bold text-app-text-primary mt-0.5">
                {clinicName || "—"}
              </p>
            </div>
          </div>

          {/* Consultation Fee */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
              <DollarSign size={20} />
            </div>
            <div>
              <p className="text-xs font-medium text-app-text-secondary">
                {translations.lbl_consultation_fee}
              </p>
              <p className="text-base font-bold text-app-text-primary mt-0.5">
                {consultationFee ? `${consultationFee} EGP` : "—"}
              </p>
            </div>
          </div>

          {/* Phone Number */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
              <Phone size={20} />
            </div>
            <div>
              <p className="text-xs font-medium text-app-text-secondary">
                {translations.lbl_phone}
              </p>
              <p className="text-base font-bold text-app-text-primary mt-0.5">
                {phone || "—"}
              </p>
            </div>
          </div>

          {/* Clinic Status */}
          <div className="flex items-start gap-3.5">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
              <Calendar size={20} />
            </div>
            <div>
              <p className="text-xs font-medium text-app-text-secondary">
                {translations.th_status}
              </p>
              <div className="mt-1">
                <span
                  className={`inline-flex items-center rounded-md px-2.5 py-0.5 text-xs font-semibold ${
                    is_active
                      ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-400"
                      : "bg-red-100 text-red-700 dark:bg-red-950/40 dark:text-red-400"
                  }`}
                >
                  {is_active
                    ? translations.clinic_status_active
                    : translations.clinic_status_inactive}
                </span>
              </div>
            </div>
          </div>

          {/* Location */}
          <div className="flex items-start gap-3.5 md:col-span-2">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-blue-100 text-blue-600 dark:bg-blue-950/40 dark:text-blue-400">
              <MapPin size={20} />
            </div>
            <div>
              <p className="text-xs font-medium text-app-text-secondary">
                {translations.th_location}
              </p>
              <p className="text-base font-bold text-app-text-primary mt-0.5">
                {[governorate, city, address].filter(Boolean).join(", ") || "—"}
              </p>
            </div>
          </div>
        </div>
      ) : (
        /* EDIT FORM MODE */
        <div className="space-y-4 pt-2">
          <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
            {/* Clinic Name */}
            <div>
              <label className="mb-1.5 block text-xs font-semibold text-app-text-primary">
                {translations.lbl_clinic_name} <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={clinicName}
                onChange={(e) => {
                  const val = e.target.value;
                  setClinicName(val);
                  setClinicNameError(validate_clinic_name(val) || "");
                  markAsDirty();
                }}
                className={`w-full rounded-xl border bg-app-input_fill px-4 py-2.5 text-sm text-app-text-primary outline-none transition-all ${
                  clinicNameError ? "border-red-500" : "border-app-border focus:border-app-primary"
                }`}
              />
              {clinicNameError ? (
                <p className="mt-1 text-xs text-red-500 font-medium">
                  {translations[clinicNameError as keyof typeof translations] || clinicNameError}
                </p>
              ) : null}
            </div>

            {/* Phone Number */}
            <div>
              <label className="mb-1.5 block text-xs font-semibold text-app-text-primary">
                {translations.lbl_phone} <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={phone}
                onChange={(e) => {
                  const val = e.target.value;
                  setPhone(val);
                  setPhoneError(validate_phone(val, existing_clinics, editing_clinic_id) || "");
                  markAsDirty();
                }}
                className={`w-full rounded-xl border bg-app-input_fill px-4 py-2.5 text-sm text-app-text-primary outline-none transition-all ${
                  phoneError ? "border-red-500" : "border-app-border focus:border-app-primary"
                }`}
              />
              {phoneError ? (
                <p className="mt-1 text-xs text-red-500 font-medium">
                  {translations[phoneError as keyof typeof translations] || phoneError}
                </p>
              ) : null}
            </div>

            {/* Governorate */}
            <CustomSelect
              label={translations.lbl_governorate}
              placeholder={translations.ph_select_governorate}
              value={governorate}
              error={translations[governorateError as keyof typeof translations] || governorateError}
              options={GOVERNORATES}
              on_change={(val) => {
                setGovernorate(val);
                setGovernorateError(validate_governorate(val) || "");
                setCity("");
                setCityError("");
                markAsDirty();
              }}
            />

            {/* City */}
            <CustomSelect
              label={translations.lbl_city}
              placeholder={translations.ph_select_city}
              value={city}
              error={translations[cityError as keyof typeof translations] || cityError}
              options={available_cities}
              disabled={!governorate}
              on_change={(val) => {
                setCity(val);
                setCityError(validate_city(val) || "");
                markAsDirty();
              }}
            />

            {/* Address */}
            <div className="md:col-span-2">
              <label className="mb-1.5 block text-xs font-semibold text-app-text-primary">
                {translations.lbl_address} <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={address}
                onChange={(e) => {
                  const val = e.target.value;
                  setAddress(val);
                  setAddressError(validate_address(val) || "");
                  markAsDirty();
                }}
                className={`w-full rounded-xl border bg-app-input_fill px-4 py-2.5 text-sm text-app-text-primary outline-none transition-all ${
                  addressError ? "border-red-500" : "border-app-border focus:border-app-primary"
                }`}
              />
              {addressError ? (
                <p className="mt-1 text-xs text-red-500 font-medium">
                  {translations[addressError as keyof typeof translations] || addressError}
                </p>
              ) : null}
            </div>

            {/* Consultation Fee */}
            <div>
              <label className="mb-1.5 block text-xs font-semibold text-app-text-primary">
                {translations.lbl_consultation_fee} <span className="text-red-500">*</span>
              </label>
              <div className="flex w-full">
                <input
                  type="number"
                  min="1"
                  value={consultationFee}
                  onChange={(e) => {
                    const val = e.target.value;
                    setConsultationFee(val);
                    setConsultationFeeError(validate_consultation_fee(val) || "");
                    markAsDirty();
                  }}
                  className={`w-full rounded-l-xl border bg-app-input_fill px-4 py-2.5 text-sm text-app-text-primary outline-none transition-all ${
                    consultationFeeError ? "border-red-500" : "border-app-border focus:border-app-primary"
                  }`}
                />
                <div className="flex items-center rounded-r-xl border border-l-0 border-app-border bg-app-input_fill px-4 text-xs font-semibold text-app-text-secondary">
                  EGP
                </div>
              </div>
              {consultationFeeError ? (
                <p className="mt-1 text-xs text-red-500 font-medium">
                  {translations[consultationFeeError as keyof typeof translations] || consultationFeeError}
                </p>
              ) : null}
            </div>

            {/* Clinic Status */}
            <div>
              <label className="mb-1.5 block text-xs font-semibold text-app-text-primary">
                {translations.th_status} <span className="text-red-500">*</span>
              </label>
              <div className="flex items-center gap-6 pt-2">
                <label className="flex items-center gap-2 cursor-pointer text-sm font-medium text-app-text-primary">
                  <input
                    type="radio"
                    name="clinic_status"
                    value="Active"
                    checked={"Active" === status}
                    onChange={() => {
                      setStatus("Active");
                      markAsDirty();
                    }}
                    className="h-4 w-4 accent-app-primary"
                  />
                  {translations.clinic_status_active}
                </label>
                <label className="flex items-center gap-2 cursor-pointer text-sm font-medium text-app-text-primary">
                  <input
                    type="radio"
                    name="clinic_status"
                    value="Inactive"
                    checked={"Inactive" === status}
                    onChange={() => {
                      setStatus("Inactive");
                      markAsDirty();
                    }}
                    className="h-4 w-4 accent-app-primary"
                  />
                  {translations.clinic_status_inactive}
                </label>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

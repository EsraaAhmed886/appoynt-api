/*
 * File Name: clinic_information_step.tsx
 * Author: shimaa salah
 * Date of Creation: 28/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - react
 *   - @/context/language_context
 *   - @/components/clinics/custom_select
 *   - @/components/clinics/clinic_form_constants
 *   - @/lib/validators/clinic_validator
 * Contributors: shimaa salah
 * Last Modified Date: [shimaa salah - 15/08/2026]
 * File Description: Step 1 form view with real-time inline validation for clinic name, phone, governorate, city, address, fee, and status.
 */

"use client";

import CustomSelect from "../custom_select";
import { useTranslation } from "@/context/language_context";
import { Clinic } from "@/types/clinic";
import {
  LABEL_CLASS,
  INPUT_CLASS,
  ERROR_CLASS,
  GOVERNORATES,
} from "../clinic_form_constants";
import {
  validate_clinic_name,
  validate_phone,
  validate_governorate,
  validate_city,
  validate_address,
  validate_consultation_fee,
} from "@/lib/validators/clinic_validator";

type ClinicInformationStepProps = {
  existingClinics?: Clinic[];
  editingClinicId?: number | null;
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
    workingDays: string[];
    workingDaysError: string;
    status: string;
    availableCities: string[];
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
    getInputBorderClass: (hasError: boolean) => string;
  };
};

export default function ClinicInformationStep({
  existingClinics = [],
  editingClinicId = null,
  form,
  actions,
}: ClinicInformationStepProps) {
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
    availableCities,
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
    getInputBorderClass,
  } = actions;

  const get_error_message = (error_key: string): string => {
    if (!error_key) {
      return "";
    } else {
      const translated = translations[error_key as keyof typeof translations];
      return translated || error_key;
    }
  };

  const has_name_error = "" !== clinicNameError;
  const has_phone_error = "" !== phoneError;
  const has_gov_error = "" !== governorateError;
  const has_city_error = "" !== cityError;
  const has_address_error = "" !== addressError;
  const has_fee_error = "" !== consultationFeeError;

  return (
    <div className="space-y-4">
      {/* Clinic Name */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          {translations.lbl_clinic_name} <span className="text-red-500">*</span>
        </label>

        <input
          type="text"
          value={clinicName}
          onChange={(e) => {
            const val = e.target.value;
            setClinicName(val);
            const err = validate_clinic_name(val);
            setClinicNameError(err || "");
            markAsDirty();
          }}
          onBlur={() => {
            const err = validate_clinic_name(clinicName);
            setClinicNameError(err || "");
          }}
          placeholder={translations.ph_clinic_name}
          className={`${INPUT_CLASS} ${getInputBorderClass(has_name_error)}`}
        />
        {has_name_error ? (
          <p className={ERROR_CLASS}>{get_error_message(clinicNameError)}</p>
        ) : null}
      </div>

      {/* Phone Number */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          {translations.lbl_phone} <span className="text-red-500">*</span>
        </label>

        <input
          type="text"
          value={phone}
          onChange={(e) => {
            const val = e.target.value;
            setPhone(val);
            const err = validate_phone(val, existingClinics, editingClinicId);
            setPhoneError(err || "");
            markAsDirty();
          }}
          onBlur={() => {
            const err = validate_phone(phone, existingClinics, editingClinicId);
            setPhoneError(err || "");
          }}
          placeholder={translations.ph_phone}
          className={`${INPUT_CLASS} ${getInputBorderClass(has_phone_error)}`}
        />
        {has_phone_error ? (
          <p className={ERROR_CLASS}>{get_error_message(phoneError)}</p>
        ) : null}
      </div>

      {/* Location */}
      <div className="space-y-4">
        {/* Governorate + City */}
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          {/* Governorate */}
          <CustomSelect
            label={translations.lbl_governorate}
            placeholder={translations.ph_select_governorate}
            value={governorate}
            error={get_error_message(governorateError)}
            options={GOVERNORATES}
            on_change={(val) => {
              setGovernorate(val);
              const err = validate_governorate(val);
              setGovernorateError(err || "");
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
            error={get_error_message(cityError)}
            options={availableCities}
            disabled={!governorate}
            on_change={(val) => {
              setCity(val);
              const err = validate_city(val);
              setCityError(err || "");
              markAsDirty();
            }}
          />
        </div>

        {/* Detailed Address */}
        <div className="flex flex-col">
          <label className={LABEL_CLASS}>
            {translations.lbl_address} <span className="text-red-500">*</span>
          </label>

          <input
            type="text"
            value={address}
            onChange={(e) => {
              const val = e.target.value;
              setAddress(val);
              const err = validate_address(val);
              setAddressError(err || "");
              markAsDirty();
            }}
            onBlur={() => {
              const err = validate_address(address);
              setAddressError(err || "");
            }}
            placeholder={translations.ph_address}
            className={`${INPUT_CLASS} ${getInputBorderClass(has_address_error)}`}
          />

          {has_address_error ? (
            <p className={ERROR_CLASS}>{get_error_message(addressError)}</p>
          ) : null}
        </div>
      </div>

      {/* Consultation Fee */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          {translations.lbl_consultation_fee}{" "}
          <span className="text-red-500">*</span>
        </label>

        <div className="flex w-full">
          <input
            type="number"
            min="1"
            max={100000}
            value={consultationFee}
            onChange={(e) => {
              const val = e.target.value;
              setConsultationFee(val);
              const err = validate_consultation_fee(val);
              setConsultationFeeError(err || "");
              markAsDirty();
            }}
            onBlur={() => {
              const err = validate_consultation_fee(consultationFee);
              setConsultationFeeError(err || "");
            }}
            placeholder={translations.ph_fee}
            className={`${INPUT_CLASS} ${getInputBorderClass(has_fee_error)} rounded-r-none rtl:rounded-r-xl rtl:rounded-l-none`}
          />

          <div
            className="flex items-center rounded-r-xl border border-l-0 border-app-border
          bg-app-input_fill
          text-app-text-secondary px-4 text-sm font-semibold rtl:rounded-r-none rtl:rounded-l-xl rtl:border-l rtl:border-r-0"
          >
            EGP
          </div>
        </div>
        {has_fee_error ? (
          <p className={ERROR_CLASS}>
            {get_error_message(consultationFeeError)}
          </p>
        ) : null}
      </div>

      {/* Status */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          {translations.th_status} <span className="text-red-500">*</span>
        </label>

        <div className="flex flex-col gap-3 sm:flex-row sm:gap-8">
          <label className="flex items-center gap-2 text-app-text-primary cursor-pointer">
            <input
              type="radio"
              name="status"
              value="Active"
              checked={"Active" === status}
              onChange={() => {
                setStatus("Active");
                markAsDirty();
              }}
              className="accent-app-primary h-4 w-4"
            />
            {translations.clinic_status_active}
          </label>

          <label className="flex items-center gap-2 text-app-text-primary cursor-pointer">
            <input
              type="radio"
              name="status"
              value="Inactive"
              checked={"Inactive" === status}
              onChange={() => {
                setStatus("Inactive");
                markAsDirty();
              }}
              className="accent-app-primary h-4 w-4"
            />
            {translations.clinic_status_inactive}
          </label>
        </div>
      </div>
    </div>
  );
}

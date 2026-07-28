import CustomSelect from "../custom_select";
import {
  LABEL_CLASS,
  INPUT_CLASS,
  ERROR_CLASS,
  GOVERNORATES,
} from "../clinic_form_constants";

type ClinicInformationStepProps = {
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
    setClinicName: React.Dispatch<React.SetStateAction<string>>;
    setClinicNameError: React.Dispatch<React.SetStateAction<string>>;

    setPhone: React.Dispatch<React.SetStateAction<string>>;
    setPhoneError: React.Dispatch<React.SetStateAction<string>>;

    setGovernorate: React.Dispatch<React.SetStateAction<string>>;
    setGovernorateError: React.Dispatch<React.SetStateAction<string>>;

    setCity: React.Dispatch<React.SetStateAction<string>>;
    setCityError: React.Dispatch<React.SetStateAction<string>>;

    setAddress: React.Dispatch<React.SetStateAction<string>>;
    setAddressError: React.Dispatch<React.SetStateAction<string>>;

    setConsultationFee: React.Dispatch<React.SetStateAction<string>>;
    setConsultationFeeError: React.Dispatch<React.SetStateAction<string>>;

    setStatus: React.Dispatch<React.SetStateAction<string>>;

    validateClinicName: (
      clinicName: string,
      setError: React.Dispatch<React.SetStateAction<string>>,
    ) => boolean;
    validateAddress: (
      address: string,
      setError: React.Dispatch<React.SetStateAction<string>>,
    ) => boolean;

    handleDayClick: (day: string) => void;

    markAsDirty: () => void;

    getInputBorderClass: (hasError: boolean) => string;
  };
};

export default function ClinicInformationStep({
  form,
  actions,
}: ClinicInformationStepProps) {
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
    validateClinicName,
    validateAddress,
    markAsDirty,
    getInputBorderClass,
  } = actions;

  return (
    <div className="space-y-4">
      {/* Clinic Name */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          Clinic Name <span className="text-red-500">*</span>
        </label>

        <input
          type="text"
          value={clinicName}
          onChange={(e) => {
            const value = e.target.value;
            setClinicName(value);
            validateClinicName(value, setClinicNameError);
            markAsDirty();
          }}
          placeholder="Enter clinic name"
          className={`${INPUT_CLASS} ${getInputBorderClass(!!clinicNameError)}`}
        />
        {clinicNameError && <p className={ERROR_CLASS}>{clinicNameError}</p>}
      </div>

      {/* Phone Number */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          Phone Number <span className="text-red-500">*</span>
        </label>

        <input
          type="number"
          value={phone}
          onChange={(e) => {
            setPhone(e.target.value);
            setPhoneError("");
            markAsDirty();
          }}
          placeholder="Enter phone number"
          className={`${INPUT_CLASS} ${getInputBorderClass(!!phoneError)}`}
        />
        {phoneError ? <p className={ERROR_CLASS}>{phoneError}</p> : null}
      </div>

      {/* Location */}
      <div className="space-y-4">
        {/* Governorate + City */}
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          {/* Governorate */}
          <CustomSelect
            label="Governorate"
            placeholder="Select Governorate"
            value={governorate}
            error={governorateError}
            options={GOVERNORATES}
            onChange={(value) => {
              setGovernorate(value);
              setGovernorateError("");

              setCity("");
              setCityError("");

              markAsDirty();
            }}
          />

          {/* City */}
          <CustomSelect
            label="City"
            placeholder="Select City"
            value={city}
            error={cityError}
            options={availableCities}
            disabled={!governorate}
            onChange={(value) => {
              setCity(value);
              setCityError("");
              markAsDirty();
            }}
          />
        </div>

        {/* Detailed Address */}
        <div className="flex flex-col">
          <label className={LABEL_CLASS}>
            Detailed Address <span className="text-red-500">*</span>
          </label>

          <input
            type="text"
            value={address}
            onChange={(e) => {
              const value = e.target.value;

              setAddress(value);
              validateAddress(value, setAddressError);
              markAsDirty();
            }}
            placeholder="Enter clinic address"
            className={`${INPUT_CLASS} ${getInputBorderClass(!!addressError)}`}
          />

          {addressError ? <p className={ERROR_CLASS}>{addressError}</p> : null}
        </div>
      </div>

      {/* Consultation Fee */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          Consultation Fee <span className="text-red-500">*</span>
        </label>

        <div className="flex w-full">
          <input
            type="number"
            min="1"
            max={100000}
            value={consultationFee}
            onChange={(e) => {
              setConsultationFee(e.target.value);
              setConsultationFeeError("");
              markAsDirty();
            }}
            placeholder="Enter fee"
            className={`${INPUT_CLASS} ${getInputBorderClass(!!consultationFeeError)} rounded-r-none`}
          />

          <div
            className="flex items-center rounded-r-lg border border-l-0 border-app-border
          bg-app-input_fill
          text-app-text-secondary px-4"
          >
            EGP
          </div>
        </div>
        {consultationFeeError ? (
          <p className={ERROR_CLASS}>{consultationFeeError}</p>
        ) : null}
      </div>

      {/* Status */}
      <div className="flex flex-col">
        <label className={LABEL_CLASS}>
          Status <span className="text-red-500">*</span>
        </label>

        <div className="flex flex-col gap-3 sm:flex-row sm:gap-8">
          <label className="flex items-center gap-2 text-app-text-primary">
            <input
              type="radio"
              name="status"
              value="Active"
              checked={status === "Active"}
              onChange={() => {
                setStatus("Active");
                markAsDirty();
              }}
            />
            Active
          </label>

          <label className="flex items-center gap-2 text-app-text-primary">
            <input
              type="radio"
              name="status"
              value="Inactive"
              checked={status === "Inactive"}
              onChange={() => {
                setStatus("Inactive");
                markAsDirty();
              }}
            />
            Inactive
          </label>
        </div>
      </div>
    </div>
  );
}

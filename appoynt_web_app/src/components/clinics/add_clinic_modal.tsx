import { X } from "lucide-react";
import { useEffect, useState } from "react";
import CustomSelect from "./custom_select";
import SuccessModal from "./success_modal";
import UnsavedChangesModal from "./unsaved_changes_modal";

const WORKING_DAYS = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
const GOVERNORATES = ["Cairo", "Giza", "Alexandria"];
const CITIES_BY_GOVERNORATE: Record<string, string[]> = {
  Cairo: ["Nasr City", "Heliopolis", "Maadi", "New Cairo", "Shoubra"],

  Giza: ["Dokki", "Mohandessin", "6th October", "Sheikh Zayed", "Haram"],

  Alexandria: ["Smouha", "Stanley", "Miami", "Sidi Gaber", "Gleem"],
};

const PHONE_REGEX = /^01[0125][0-9]{8}$/;

const VALIDATION_MESSAGES = {
  clinicNameRequired: "Clinic name is required",
  clinicNameMin: "Clinic name must be at least 2 characters",
  clinicNameMax: "Clinic name must not exceed 50 characters",
  clinicNameSpaces: "Multiple consecutive spaces are not allowed",
  clinicNameInvalid: "Clinic name must contain at least one letter",
  phone: "Enter a valid phone number",
  governorate: "Please select a governorate",
  city: "Please select a city",
  addressRequired: "Clinic address is required",
  addressMin: "Clinic address must be at least 2 characters",
  addressMax: "Clinic address must not exceed 100 characters",
  addressSpaces: "Multiple consecutive spaces are not allowed",
  addressTrailingSpaces: "Address must not end with spaces",
  addressInvalid: "Enter a valid clinic address",
  consultationFee: "Invalid consultation fee",
  workingDays: "Invalid working days",
};

const LABEL_CLASS =
  "mb-2 text-sm font-semibold text-app-text-primary md:text-base lg:text-lg";

const INPUT_CLASS =
  "w-full rounded-lg border bg-app-input_fill px-4 py-2.5 text-app-text-primary outline-none transition-all";
const ERROR_CLASS = "mt-1 text-sm text-red-500 md:text-base lg:text-lg";
const DAY_BUTTON_CLASS = "rounded-lg border px-4 py-2.5 transition-all";

const BUTTON_CLASS =
  "h-10 rounded-md font-medium text-sm md:text-base lg:text-lg";

const getInputBorderClass = (hasError: boolean) => {
  if (hasError) {
    return "border-red-500 ring-2 ring-red-200";
  } else {
   return "border-app-border focus:border-app-primary focus:ring-2 focus:ring-app-primary/20";
  }
};

type ErrorSetter = React.Dispatch<React.SetStateAction<string>>;

type Clinic = {
  id: number;
  name: string;
  location: string;
  phone: string;
  consultationFee: string;
  workingDays: string;
  status: string;
};

type AddClinicModalProps = {
  isOpen: boolean;
  onClose: () => void;
  onAddClinic: (clinic: Clinic) => void;
};

export default function AddClinicModal({
  isOpen,
  onClose,
  onAddClinic,
}: AddClinicModalProps) {
  const [clinicName, setClinicName] = useState("");
  const [clinicNameError, setClinicNameError] = useState("");
  const [phone, setPhone] = useState("");
  const [phoneError, setPhoneError] = useState("");
  const [governorate, setGovernorate] = useState("");
  const [governorateError, setGovernorateError] = useState("");
  const [city, setCity] = useState("");
  const [cityError, setCityError] = useState("");
  const [address, setAddress] = useState("");
  const [addressError, setAddressError] = useState("");
  const [consultationFee, setConsultationFee] = useState("");
  const [consultationFeeError, setConsultationFeeError] = useState("");
  const [workingDays, setWorkingDays] = useState<string[]>([]);
  const [workingDaysError, setWorkingDaysError] = useState("");
  const [status, setStatus] = useState("Active");

  const availableCities = governorate ? CITIES_BY_GOVERNORATE[governorate] : [];

  const [isSuccessOpen, setIsSuccessOpen] = useState(false);

  const [isDirty, setIsDirty] = useState(false);
  const [isUnsavedModalOpen, setIsUnsavedModalOpen] = useState(false);

  const validateClinicName = (clinicName: string, setError: ErrorSetter) => {
    const trimmedName = clinicName.trim();

    if (trimmedName === "") {
      setError(VALIDATION_MESSAGES.clinicNameRequired);
      return false;
    } else if (trimmedName.length < 2) {
      setError(VALIDATION_MESSAGES.clinicNameMin);
      return false;
    } else if (trimmedName.length > 50) {
      setError(VALIDATION_MESSAGES.clinicNameMax);
      return false;
    } else if (/\s{2,}/.test(trimmedName)) {
      setError(VALIDATION_MESSAGES.clinicNameSpaces);
      return false;
    } else if (!/[A-Za-z]/.test(trimmedName)) {
      setError(VALIDATION_MESSAGES.clinicNameInvalid);
      return false;
    } else if (/<[^>]*>|javascript:/i.test(trimmedName)) {
      setError(VALIDATION_MESSAGES.clinicNameInvalid);
      return false;
    } else {
      setError("");
      return true;
    }
  };

  const validateRequiredField = (
    value: string,
    setError: ErrorSetter,
    message: string,
  ) => {
    if (value.trim() === "") {
      setError(message);
      return false;
    } else {
      setError("");
      return true;
    }
  };

  const validatePhoneNumber = (phone: string, setError: ErrorSetter) => {
    if (phone.trim() === "") {
      setError(VALIDATION_MESSAGES.phone);
      return false;
    } else if (!PHONE_REGEX.test(phone)) {
      setError(VALIDATION_MESSAGES.phone);
      return false;
    } else {
      setError("");
      return true;
    }
  };

  const validateAddress = (address: string, setError: ErrorSetter) => {
    const trimmedAddress = address.trim();

    if (trimmedAddress === "") {
      setError(VALIDATION_MESSAGES.addressRequired);
      return false;
    } else if (trimmedAddress.length < 2) {
      setError(VALIDATION_MESSAGES.addressMin);
      return false;
    } else if (trimmedAddress.length > 100) {
      setError(VALIDATION_MESSAGES.addressMax);
      return false;
    } else if (/\s{2,}/.test(trimmedAddress)) {
      setError(VALIDATION_MESSAGES.addressSpaces);
      return false;
    } else if (address !== address.trimEnd()) {
      setError(VALIDATION_MESSAGES.addressTrailingSpaces);
      return false;
    } else if (!/[A-Za-z]/.test(trimmedAddress)) {
      setError(VALIDATION_MESSAGES.addressInvalid);
      return false;
    } else if (/<[^>]*>|javascript:/i.test(trimmedAddress)) {
      setError(VALIDATION_MESSAGES.addressInvalid);
      return false;
    } else {
      setError("");
      return true;
    }
  };

  const validateConsultationFee = (fee: string, setError: ErrorSetter) => {
    if (fee.trim() === "") {
      setError(VALIDATION_MESSAGES.consultationFee);
      return false;
    } else if (Number(fee) <= 0) {
      setError(VALIDATION_MESSAGES.consultationFee);
      return false;
    } else {
      setError("");
      return true;
    }
  };

  const validateRequiredArray = (
    value: string[],
    setError: ErrorSetter,
    message: string,
  ) => {
    if (value.length === 0) {
      setError(message);
      return false;
    } else {
      setError("");
      return true;
    }
  };

  const handleDayClick = (day: string) => {
    if (workingDays.includes(day)) {
      setWorkingDays(workingDays.filter((item) => item !== day));
    } else {
      setWorkingDays([...workingDays, day]);
    }

    setWorkingDaysError("");
    markAsDirty();
  };

  const resetForm = () => {
    setClinicName("");
    setClinicNameError("");

    setPhone("");
    setPhoneError("");

    setGovernorate("");
    setGovernorateError("");

    setCity("");
    setCityError("");

    setAddress("");
    setAddressError("");

    setConsultationFee("");
    setConsultationFeeError("");

    setWorkingDays([]);
    setWorkingDaysError("");

    setStatus("Active");

    setIsDirty(false);
  };

  const markAsDirty = () => {
    if (!isDirty) {
      setIsDirty(true);
    } else {
      // Already marked as dirty
    }
  };

  const handleClose = () => {
    if (isDirty) {
      setIsUnsavedModalOpen(true);
    } else {
      onClose();
    }
  };

  useEffect(() => {
    const handleBeforeUnload = (event: BeforeUnloadEvent) => {
      if (isDirty) {
        event.preventDefault();
        event.returnValue = "";
      } else {
        // No action needed
      }
    };

    window.addEventListener("beforeunload", handleBeforeUnload);

    return () => {
      window.removeEventListener("beforeunload", handleBeforeUnload);
    };
  }, [isDirty]);

  const handleSave = () => {
    let isValid = true;

    if (!validateClinicName(clinicName, setClinicNameError)) {
      isValid = false;
    } else {
      // No action needed
    }
    if (!validatePhoneNumber(phone, setPhoneError)) {
      isValid = false;
    } else {
      // No action needed
    }

    if (
      !validateRequiredField(
        governorate,
        setGovernorateError,
        VALIDATION_MESSAGES.governorate,
      )
    ) {
      isValid = false;
    } else {
      // No action needed
    }

    if (!validateRequiredField(city, setCityError, VALIDATION_MESSAGES.city)) {
      isValid = false;
    } else {
      // No action needed
    }

    if (!validateAddress(address, setAddressError)) {
      isValid = false;
    } else {
      // No action needed
    }

    if (!validateConsultationFee(consultationFee, setConsultationFeeError)) {
      isValid = false;
    } else {
      // No action needed
    }

    if (
      !validateRequiredArray(
        workingDays,
        setWorkingDaysError,
        VALIDATION_MESSAGES.workingDays,
      )
    ) {
      isValid = false;
    } else {
      // No action needed
    }

    if (!isValid) {
      return;
    } else {
      const newClinic: Clinic = {
        id: Date.now(),
        name: clinicName,
        location: `${city}, ${governorate}`,
        phone,
        consultationFee: `${consultationFee} EGP`,
        workingDays: workingDays.join(", "),
        status,
      };

      onAddClinic(newClinic);

      resetForm();

      setIsSuccessOpen(true);
    }
  };

  if (!isOpen) {
    return null;
  } else {
    return (
      <>
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4"
          onClick={handleClose}
        >
          <div
            className="max-h-[90vh] w-full max-w-[600px] overflow-y-auto rounded-xl bg-app-surface p-4 shadow-xl sm:p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between border-b pb-4">
              <h2 className="text-xl font-semibold text-app-text-primary">
                Add New Clinic
              </h2>

              <button
                onClick={handleClose}
                className="rounded-full p-1 text-app-text-secondary
hover:bg-app-input_fill
hover:text-app-text-primary"
              >
                <X size={20} />
              </button>
            </div>

            <form
              className="mt-6 space-y-4"
              onSubmit={(e) => {
                e.preventDefault();
                handleSave();
              }}
            >
              {/*clinic name*/}
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
                {clinicNameError && (
                  <p className={ERROR_CLASS}>{clinicNameError}</p>
                )}
              </div>

              {/*phone number*/}
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
                {phoneError ? (
                  <p className={ERROR_CLASS}>{phoneError}</p>
                ) : null}
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

                  {addressError ? (
                    <p className={ERROR_CLASS}>{addressError}</p>
                  ) : null}
                </div>
              </div>

              {/*fee*/}
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
                    className={`${INPUT_CLASS} ${getInputBorderClass(!!consultationFeeError)}`}
                  />

                  <div className="flex items-center rounded-r-lg border border-app-border
bg-app-input_fill
text-app-text-primary px-4">
                    EGP
                  </div>
                </div>
                {consultationFeeError ? (
                  <p className={ERROR_CLASS}>{consultationFeeError}</p>
                ) : null}
              </div>

              {/*working day*/}
              <div className="flex flex-col">
                <label className={LABEL_CLASS}>
                  Working Days <span className="text-red-500">*</span>
                </label>

                <div className="grid grid-cols-2 gap-2 sm:grid-cols-4 lg:grid-cols-7">
                  {WORKING_DAYS.map((day) => (
                    <button
                      key={day}
                      type="button"
                      onClick={() => handleDayClick(day)}
                      className={`
                       ${DAY_BUTTON_CLASS}
                       ${
                         workingDays.includes(day)
                           ? "bg-blue-primary text-white border-app-primary"
                           : getInputBorderClass(!!workingDaysError)
                       }
                    `}
                    >
                      {day}
                    </button>
                  ))}
                </div>
                {workingDaysError ? (
                  <p className={ERROR_CLASS}>{workingDaysError}</p>
                ) : null}
              </div>

              {/*status*/}
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

              <div className="mt-8 flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">
                <button
                  type="submit"
                  className={`${BUTTON_CLASS} w-full bg-app-primary px-8 text-white hover:opacity-90 sm:w-auto`}
                >
                  Save Clinic
                </button>
                <button
                  type="button"
                  onClick={handleClose}
                  className={`${BUTTON_CLASS} w-full border border-app-border bg-app-surface px-6 text-app-text-primary hover:bg-app-input_fill sm:w-auto`}
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>

        <UnsavedChangesModal
          isOpen={isUnsavedModalOpen}
          onStay={() => {
            setIsUnsavedModalOpen(false);
          }}
          onLeave={() => {
            setIsUnsavedModalOpen(false);
            resetForm();
            onClose();
          }}
        />

        <SuccessModal
          isOpen={isSuccessOpen}
          onClose={() => {
            setIsSuccessOpen(false);

            resetForm();

            onClose();
          }}
        />
      </>
    );
  }
}

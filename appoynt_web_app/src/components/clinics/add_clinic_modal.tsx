import { X, ArrowLeft, Check, ChevronRight } from "lucide-react";
import { useEffect, useState } from "react";
import SuccessModal from "./success_modal";
import UnsavedChangesModal from "./unsaved_changes_modal";
import ClinicInformationStep from "./steps/clinic_information_step";
import WorkingScheduleStep, {
  WorkingScheduleItem,
} from "./steps/working_schedule_step";
import BreakTimesStep, { BreakTimeItem } from "./steps/break_times_step";
import ReceptionistsStep, {
  ReceptionistItem,
} from "./steps/receptionists_step";
import BookingSettingsStep from "./steps/booking_settings_step";

import {
  CITIES_BY_GOVERNORATE,
  VALIDATION_MESSAGES,
  PHONE_REGEX,
  BUTTON_CLASS,
} from "./clinic_form_constants";

const STEPS = [
  "Clinic Information",
  "Working Schedule",
  "Break Times",
  "Receptionists",
  "Booking Settings",
];

const DEFAULT_SCHEDULES: WorkingScheduleItem[] = [];
const DEFAULT_BREAKS: BreakTimeItem[] = [];
const DEFAULT_RECEPTIONISTS: ReceptionistItem[] = [];

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
  const [currentStep, setCurrentStep] = useState(1);
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
  const availableCities = governorate
    ? CITIES_BY_GOVERNORATE[governorate] || []
    : [];
  const [isSuccessOpen, setIsSuccessOpen] = useState(false);
  const [isDirty, setIsDirty] = useState(false);
  const [isUnsavedModalOpen, setIsUnsavedModalOpen] = useState(false);

  const [scheduleList, setScheduleList] =
    useState<WorkingScheduleItem[]>(DEFAULT_SCHEDULES);
  const [breakList, setBreakList] = useState<BreakTimeItem[]>(DEFAULT_BREAKS);
  const [assignedReceptionists, setAssignedReceptionists] = useState<
    ReceptionistItem[]
  >(DEFAULT_RECEPTIONISTS);
  const [appointmentDuration, setAppointmentDuration] = useState("30 Minutes");
  const [maxAdvanceBooking, setMaxAdvanceBooking] = useState("30 Days");

  useEffect(() => {
    if (isOpen) {
      resetForm();
    }
  }, [isOpen]);

  const resetForm = () => {
    setCurrentStep(1);
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

    setScheduleList(DEFAULT_SCHEDULES);
    setBreakList(DEFAULT_BREAKS);
    setAssignedReceptionists(DEFAULT_RECEPTIONISTS);
    setAppointmentDuration("30 Minutes");
    setMaxAdvanceBooking("30 Days");

    setIsDirty(false);
  };

  const nextStep = () => {
    if (currentStep < 5) {
      setCurrentStep((prev) => prev + 1);
    }
  };

  const previousStep = () => {
    if (currentStep > 1) {
      setCurrentStep((prev) => prev - 1);
    }
  };

  const handleAddSchedule = (newItem: WorkingScheduleItem) => {
    setScheduleList((prev) => [...prev, newItem]);
    markAsDirty();
  };

  const handleEditSchedule = (
    index: number,
    updatedItem: WorkingScheduleItem,
  ) => {
    setScheduleList((prev) =>
      prev.map((item, i) => (i === index ? updatedItem : item)),
    );
    markAsDirty();
  };

  const handleDeleteSchedule = (index: number) => {
    setScheduleList((prev) => prev.filter((_, i) => i !== index));
    markAsDirty();
  };

  const handleAddBreak = (newItem: BreakTimeItem) => {
    setBreakList((prev) => [...prev, newItem]);
    markAsDirty();
  };

  const handleEditBreak = (index: number, updatedItem: BreakTimeItem) => {
    setBreakList((prev) =>
      prev.map((item, i) => (i === index ? updatedItem : item)),
    );
    markAsDirty();
  };

  const handleDeleteBreak = (index: number) => {
    setBreakList((prev) => prev.filter((_, i) => i !== index));
    markAsDirty();
  };

  const handleUpdateAssigned = (newList: ReceptionistItem[]) => {
    setAssignedReceptionists(newList);
    markAsDirty();
  };

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

  const handleDayClick = (day: string) => {
    if (workingDays.includes(day)) {
      setWorkingDays(workingDays.filter((item) => item !== day));
    } else {
      setWorkingDays([...workingDays, day]);
    }

    setWorkingDaysError("");
    markAsDirty();
  };

  const markAsDirty = () => {
    if (!isDirty) {
      setIsDirty(true);
    }
  };

  const handleClose = () => {
    if (isDirty) {
      setIsUnsavedModalOpen(true);
    } else {
      resetForm();
      onClose();
    }
  };

  useEffect(() => {
    const handleBeforeUnload = (event: BeforeUnloadEvent) => {
      if (isDirty) {
        event.preventDefault();
        event.returnValue = "";
      }
    };

    window.addEventListener("beforeunload", handleBeforeUnload);

    return () => {
      window.removeEventListener("beforeunload", handleBeforeUnload);
    };
  }, [isDirty]);

  const handleSave = () => {
    let isValid = true;

    if (!validateClinicName(clinicName, setClinicNameError)) isValid = false;
    if (!validatePhoneNumber(phone, setPhoneError)) isValid = false;

    if (
      !validateRequiredField(
        governorate,
        setGovernorateError,
        VALIDATION_MESSAGES.governorate,
      )
    ) {
      isValid = false;
    }

    if (!validateRequiredField(city, setCityError, VALIDATION_MESSAGES.city)) {
      isValid = false;
    }

    if (!validateAddress(address, setAddressError)) isValid = false;

    if (!validateConsultationFee(consultationFee, setConsultationFeeError)) {
      isValid = false;
    }

    if (!isValid) {
      setCurrentStep(1);
      return;
    } else {
      const newClinic: Clinic = {
        id: Date.now(),
        name: clinicName,
        location: `${city}, ${governorate}`,
        phone,
        consultationFee: `${consultationFee} EGP`,
        workingDays: scheduleList.map((s) => s.day).join(", "),
        status,
      };

      onAddClinic(newClinic);
      resetForm();
      setIsSuccessOpen(true);
    }
  };

  const getInputBorderClass = (hasError: boolean) => {
    if (hasError) {
      return "border-red-500 ring-2 ring-red-200";
    } else {
      return "border-gray-200 dark:border-gray-700 focus:border-blue-600 focus:ring-2 focus:ring-blue-600/20";
    }
  };

  const clinicForm = {
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
    workingDays,
    workingDaysError,
    status,
    availableCities,
  };

  const clinicActions = {
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
    handleDayClick,
    markAsDirty,
    getInputBorderClass,
  };

  if (!isOpen) {
    return null;
  }

  return (
    <>
      <div
        className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4"
        onClick={handleClose}
      >
        <div
          className="max-h-[90vh] w-full max-w-[640px] overflow-y-auto rounded-2xl bg-[var(--app-surface)] text-[var(--app-text-primary)] p-6 shadow-2xl transition-colors border border-[var(--app-border)]"
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header */}
          <div className="flex items-center justify-between pb-6">
            <h2 className="text-xl font-bold text-app-text-primary">
              Add New Clinic
            </h2>

            <button
              onClick={handleClose}
              className="rounded-full p-1.5 text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-600 dark:hover:text-gray-200 transition-colors"
            >
              <X size={18} />
            </button>
          </div>

          {/* Stepper */}
          <div className="mb-12 flex items-center justify-between px-2">
            {STEPS.map((step, index) => {
              const stepNumber = index + 1;
              const isActive = currentStep === stepNumber;
              const isCompleted = currentStep > stepNumber;

              return (
                <div
                  key={step}
                  className="flex flex-1 items-center last:flex-none"
                >
                  <div className="flex flex-col items-center relative">
                    <div
                      className={`
                        flex h-8 w-8 shrink-0 items-center justify-center rounded-full text-xs font-semibold transition-all
                        ${
                          isCompleted
                            ? "bg-emerald-600 text-white"
                            : isActive
                              ? "bg-blue-600 text-white"
                              : "border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-500 dark:text-gray-400"
                        }
                      `}
                    >
                      {isCompleted ? (
                        <Check size={16} strokeWidth={2.5} />
                      ) : (
                        stepNumber
                      )}
                    </div>

                    <span
                      className={`
                        absolute top-10 whitespace-nowrap text-[11px] font-medium transition-colors
                        ${
                          isActive
                            ? "font-bold text-blue-600 dark:text-blue-400"
                            : isCompleted
                              ? "text-gray-700 dark:text-gray-300"
                              : "text-gray-400 dark:text-gray-500"
                        }
                      `}
                    >
                      {step}
                    </span>
                  </div>

                  {index < STEPS.length - 1 && (
                    <div className="mx-3 h-[1px] flex-1 bg-gray-200 dark:bg-gray-800" />
                  )}
                </div>
              );
            })}
          </div>

          <form
            className="space-y-4 pt-2"
            onSubmit={(e) => {
              e.preventDefault();
              if (currentStep === 5) {
                handleSave();
              } else {
                nextStep();
              }
            }}
          >
            {/* Step 1 */}
            {currentStep === 1 && (
              <ClinicInformationStep
                form={clinicForm}
                actions={clinicActions}
              />
            )}

            {/* Step 2 */}
            {currentStep === 2 && (
              <WorkingScheduleStep
                scheduleList={scheduleList}
                onAddSchedule={handleAddSchedule}
                onEditSchedule={handleEditSchedule}
                onDeleteSchedule={handleDeleteSchedule}
              />
            )}

            {/* Step 3 */}
            {currentStep === 3 && (
              <BreakTimesStep
                breakList={breakList}
                availableWorkingDays={scheduleList.map((s) => s.day)}
                onAddBreak={handleAddBreak}
                onEditBreak={handleEditBreak}
                onDeleteBreak={handleDeleteBreak}
              />
            )}

            {/* Step 4 */}
            {currentStep === 4 && (
              <ReceptionistsStep
                assignedReceptionists={assignedReceptionists}
                onUpdateAssigned={handleUpdateAssigned}
              />
            )}

            {/* Step 5 */}
            {currentStep === 5 && (
              <BookingSettingsStep
                appointmentDuration={appointmentDuration}
                setAppointmentDuration={(val) => {
                  setAppointmentDuration(val);
                  markAsDirty();
                }}
                maxAdvanceBooking={maxAdvanceBooking}
                setMaxAdvanceBooking={(val) => {
                  setMaxAdvanceBooking(val);
                  markAsDirty();
                }}
                onMarkDirty={markAsDirty}
              />
            )}

            {/* Footer Buttons */}
            <div className="mt-8 flex items-center justify-between border-t border-app-border pt-5">
              <div>
                {currentStep > 1 && (
                  <button
                    type="button"
                    onClick={previousStep}
                    className="rounded-xl border border-app-border bg-app-surface px-5 py-2 text-sm font-medium text-app-text-primary hover:border-app-primary/50 hover:text-app-primary transition-all"
                  >
                    ← Back
                  </button>
                )}
              </div>

              <div className="flex items-center gap-3">
                <button
                  type="button"
                  onClick={handleClose}
                  className="rounded-xl border border-app-border bg-app-surface px-5 py-2 text-sm font-medium text-app-text-primary hover:border-app-primary/50 hover:text-app-primary transition-all"
                >
                  Cancel
                </button>

                <button
                  type="submit"
                  className="rounded-xl bg-app-primary px-6 py-2 text-sm font-medium text-white shadow-md hover:opacity-90 transition-all"
                >
                  {currentStep === 5 ? "✓ Save Changes" : "Next"}
                </button>
              </div>
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

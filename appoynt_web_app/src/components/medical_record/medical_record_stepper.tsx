/*
 * File Name: medical_record_stepper.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 18/08/2026
 * Version Information: v1.0.0
 * Dependencies:
 *   - react
 *   - lucide-react
 *   - @/context/medical_record_context
 *   - @/context/language_context
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 26/08/2026]
 * File Description: Scaled 3-step workflow Stepper component for the Medical Record consultation tabs, providing prominent pill dimensions, badge circles, typography, and responsive horizontal dividers.
 */

"use client";

import React from "react";
import { Check } from "lucide-react";
import { useMedicalRecordWorkflow } from "@/context/medical_record_context";
import { useTranslation } from "@/context/language_context";

interface MedicalRecordStepperProps {
  className?: string;
}

export default function MedicalRecordStepper({ className = "" }: MedicalRecordStepperProps) {
  const { currentStep, setCurrentStep } = useMedicalRecordWorkflow();
  const { translations } = useTranslation();

  const steps = [
    {
      step: 1 as const,
      label: translations.diagnoses_and_notes || "1. Diagnoses & Notes",
    },
    {
      step: 2 as const,
      label: translations.medications_and_prescriptions || "2. Medications & Prescriptions",
    },
    {
      step: 3 as const,
      label: translations.tests_and_attachments || "3. Tests & Attachments",
    },
  ];

  return (
    <div
      className={`w-full bg-white dark:bg-[#0E1726] border-2 border-slate-200 dark:border-slate-800 rounded-2xl py-4 md:py-5 px-6 md:px-8 shadow-xs flex items-center justify-center ${className}`}
    >
      <div className="flex flex-wrap items-center justify-center gap-3 md:gap-6">
        {steps.map((item, index) => {
          const isCurrent = currentStep === item.step;
          const isCompleted = currentStep > item.step;
          const isUpcoming = currentStep < item.step;

          return (
            <React.Fragment key={item.step}>
              {/* Step Pill */}
              <button
                type="button"
                onClick={() => setCurrentStep(item.step)}
                className={`transition-all cursor-pointer ${
                  isCurrent
                    ? "bg-blue-600 text-white px-5 py-2.5 md:px-6 md:py-3 rounded-full flex items-center gap-3 shadow-sm"
                    : isCompleted
                    ? "bg-emerald-50 dark:bg-emerald-950/40 border border-emerald-300 dark:border-emerald-800 text-emerald-800 dark:text-emerald-200 px-5 py-2.5 md:px-6 md:py-3 rounded-full flex items-center gap-3 hover:border-emerald-400"
                    : "bg-slate-100 dark:bg-[#131E35] border border-slate-200/80 dark:border-slate-700/60 text-slate-600 dark:text-slate-300 px-5 py-2.5 md:px-6 md:py-3 rounded-full flex items-center gap-3 hover:border-slate-300 dark:hover:border-slate-600"
                }`}
              >
                {/* Number / Check Badge */}
                <span
                  className={`w-7 h-7 md:w-8 md:h-8 rounded-full flex items-center justify-center shrink-0 ${
                    isCurrent
                      ? "bg-white text-blue-600 font-extrabold text-sm md:text-base shadow-xs"
                      : isCompleted
                      ? "bg-emerald-600 text-white font-bold text-sm md:text-base shadow-xs"
                      : "bg-slate-200 dark:bg-slate-700 text-slate-700 dark:text-slate-200 font-bold text-sm md:text-base"
                  }`}
                >
                  {isCompleted ? <Check className="w-4 h-4 md:w-5 md:h-5 stroke-[2.5]" /> : item.step}
                </span>

                {/* Label Text */}
                <span
                  className={`${
                    isCurrent
                      ? "text-sm md:text-base font-bold tracking-tight"
                      : isCompleted
                      ? "text-sm md:text-base font-bold"
                      : "text-sm md:text-base font-semibold"
                  }`}
                >
                  {item.label}
                </span>
              </button>

              {/* Connecting Divider between steps */}
              {index < steps.length - 1 && (
                <div
                  className={`w-8 md:w-14 h-0.5 rounded-full shrink-0 ${
                    currentStep > item.step
                      ? "bg-emerald-500/70 dark:bg-emerald-600/70"
                      : "bg-slate-200 dark:bg-slate-700"
                  }`}
                />
              )}
            </React.Fragment>
          );
        })}
      </div>
    </div>
  );
}

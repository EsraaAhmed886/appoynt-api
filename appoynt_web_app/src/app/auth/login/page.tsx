/*
 * File Name: page.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 03/07/2026
 * Version Information: V1.0.0
 * Dependencies: react, next/image, lucide-react,
 *   @/hooks/use_auth, @/context/language_context, @/types
 * Contributors: [Kholoud Khaled ,shimaa salah]
 * Last Modified Date: [shimaa salah - 30/08/2026]
 * File Description: Interactive login page using Redux-integrated use_auth
 *   hook, design tokens, and bilingual context.
 */

"use client";

// Importing React state, form submit event, and memoization hooks
import { useState, FormEvent, useMemo } from "react";
// Importing optimized image loader components from Next framework assets
import Image from "next/image";
// Importing layout outline display icons from lucide catalog library
import {
  Eye,
  EyeOff,
  Activity,
  Globe,
  Calendar,
  RefreshCw,
  ShieldCheck,
} from "lucide-react";
// Importing type-safe custom authorization hook controller
import { use_auth } from "@/hooks/use_auth";
// Importing custom translation context interface hook utility
import { useTranslation } from "@/context/language_context";
// Importing credentials structure layout schema definition type
import type { login_credentials } from "@/types";

// Defining and exporting the main login_page react component block
export default function login_page() {
  // Pulling active authentication tools and loading variables from custom hook
  const {
    // Destructuring login action caller
    login,
    // Destructuring loader status variable flag
    is_loading,
    // Destructuring backend response validation errors
    error_message,
    // Destructuring error dismission callback handler
    dismiss_error,
  } = use_auth();

  // Pulling localized translation catalogs from language engine context
  const {
    // Active translations object database
    translations,
    // Active current system language code selection
    current_locale,
    // System locale switcher handler action hook
    change_locale,
  } = useTranslation();

  // Determining active layout directionality flag using standard locale match
  const is_rtl = "ar" === current_locale;

  // Local state parameter storing values from email and password form inputs
  const [login_params, set_login_params] = useState<login_credentials>({
    // Initializing login identification email string to empty
    email_address: "",
    // Initializing login secret password verification key to empty
    secret_password: "",
    // Setting persistent session checkbox boolean trigger flag to false
    remember_me: false,
  });

  // Local state controlling password visibility mask characters overlay
  const [show_password, set_show_password] = useState<boolean>(false);

  // Local state tracking input field verification validation flags
  const [validation_errors, set_validation_errors] = useState<{
    // Conditional email address validation flag indicator
    email_address?: boolean;
    // Conditional password validation flag indicator
    secret_password?: boolean;
  }>({});

    // Memoized resolution handler determining active error warning prompt text
  const active_error_message = useMemo(() => {
    // Yoda style check validating if API returns failure message parameters
    if (null !== error_message) {
      // Returning active dynamic error message from API or fallback
      return error_message;
    } else if (
      true === validation_errors.email_address &&
      true === validation_errors.secret_password
    ) {
      // Returning unified both fields required warning message label
      return translations.err_both_required;
    } else if (true === validation_errors.email_address) {
      // Returning email required warning message label
      return translations.err_email_required;
    } else if (true === validation_errors.secret_password) {
      // Returning password required warning message label
      return translations.err_password_required;
    } else {
      // Fallback state returning null value when credentials verify
      return null;
    }
  }, [error_message, validation_errors, translations]);

  // Method handler executing submit actions on credentials form validation checks
  const handle_submit = async (event_obj: FormEvent) => {
    // Preventing default browser form post reload action triggers
    event_obj.preventDefault();
    // Instantiating temporary tracking container mapping validation fields
    const new_errors: {
      email_address?: boolean;
      secret_password?: boolean;
    } = {};
    // Yoda check validating if email address input content contains length
    if (0 === login_params.email_address.trim().length) {
      // Flagging email address input as invalid error state
      new_errors.email_address = true;
    } else {
      // Email is provided
    }
    // Yoda check validating if secret password input content contains length
    if (0 === login_params.secret_password.trim().length) {
      // Flagging secret password input as invalid error state
      new_errors.secret_password = true;
    } else {
      // Password is provided
    }
    // Updating validation errors state tracker parameters
    set_validation_errors(new_errors);
    // Yoda check validating if any errors are caught in local validation map
    if (0 < Object.keys(new_errors).length) {
      // Blocking thunk pipeline trigger calls
      return;
    } else {
      // Attempting login thunk execution mapping parameters
      await login(login_params);
    }
  };

  // Higher-order method handler updating parameters state values
  const handle_change = (field_key: keyof login_credentials) => {
    // Returning event callback processor receiver
    return (event_obj: React.ChangeEvent<HTMLInputElement>) => {
      // Wiping out active API authorization response error warning alerts
      dismiss_error();
      // Clearing validation flag variables mapped to updated field key
      set_validation_errors((previous_errors) => {
        // Returning modified error settings registry
        return {
          // Preserving unaffected validation states
          ...previous_errors,
          // De-asserting validation error state flag
          [field_key]: false,
        };
      });
      // Updating credentials fields variables state parameters
      set_login_params((previous_params) => {
        // Yoda check to see if target input element is remember_me checkbox
        const field_value =
          "remember_me" === field_key
            ? event_obj.target.checked
            : event_obj.target.value;
        // Returning modified credentials properties configuration
        return {
          // Preserving unmodified inputs parameter keys
          ...previous_params,
          // Injecting modified inputs parameter values
          [field_key]: field_value,
        };
      });
    };
  };

  // Switch handler changing current locale settings between English and Arabic
  const toggle_language = () => {
    // Yoda style check verifying if english locale is active
    if ("en" === current_locale) {
      // Switch system locale configuration to arabic language code
      change_locale("ar");
    } else {
      // Revert system locale configuration to english language code
      change_locale("en");
    }
  };

  // Assembling outer layout structure returning UI template blocks
  return (
    // Root container wrapping layout sections mapping font variables
    <div
      className={[
        "min-h-screen flex flex-row bg-app-background text-app-text-primary",
        is_rtl ? "font-cairo" : "font-sans",
      ].join(" ")}
    >
      {/* ── Left Panel: Hero Section ────────────────────────────── */}
      <div
        // Container block utilizing custom styling classes and token gradient
        className={[
          "hidden lg:flex lg:w-1/2 flex-col justify-between",
          "p-10 relative overflow-hidden",
        ].join(" ")}
        // Applying brand gradient background directly for compiler robustness
        style={{ background: "var(--brand-gradient)" }}
      >
        {/* Subtle radial decorative dots pattern overlay overlaying section */}
        <div
          // Position absolute layout properties
          className="absolute inset-0 opacity-10"
          style={{
            // Creating a dot layout background using native canvas grids
            backgroundImage:
              "radial-gradient(circle, #ffffff 1px, transparent 1px)",
            // Configuring canvas tile pattern scale spacing
            backgroundSize: "32px 32px",
          }}
        />

        {/* Brand identity header grouping logo image and branding text */}
        <div className="relative z-10 flex items-center gap-4">
          {/* Logo container wrapper block applying hover scale transitions */}
          <div
            // Layout styling classes
            className={[
              "w-14 h-14 bg-white rounded-2xl flex items-center",
              "justify-center shadow-xl transition-transform",
              "hover:scale-105 overflow-hidden",
            ].join(" ")}
          >
            {/* Optimized next image loading appoynt health logo asset */}
            <Image
              // Target assets directory file location path
              src="/images/appoynt_logo.png"
              // Image alt identification label
              alt="Appoynt Logo"
              // Absolute width matching box bounds
              width={66}
              // Absolute height matching box bounds
              height={66}
              // Contain layout class to avoid edge clippings
              className="object-contain p-0"
            />
          </div>
          {/* Main system title label */}
          <span
            className={[
              "text-white font-bold text-2xl tracking-wide uppercase",
              is_rtl ? "font-cairo" : "font-sans",
            ].join(" ")}
          >
            {translations.app_name}
          </span>
        </div>

        {/* Hero marketing statement blocks listing product features */}
        <div className="relative z-10 space-y-8">
          {/* Primary value catchphrase title */}
          <h1 className="text-white text-5xl font-bold leading-tight">
            {translations.login_hero_title}
          </h1>
          {/* Subtitle statement description separated on two display lines */}
          <p className="text-blue-100 text-lg leading-relaxed whitespace-nowrap">
            {/* Value statement line segment one */}
            {translations.login_hero_subtitle_part1}
            <br />
            {/* Value statement line segment two */}
            {translations.login_hero_subtitle_part2}
          </p>
          {/* Features list arrangement bullet items */}
          <ul className="space-y-4">
            {/* Generating mapping array rendering bullet items */}
            {[
              {
                // Calendar icon node mapping
                icon_node: <Calendar className="w-5 h-5 text-white" />,
                // Label string translation mapping
                label_text: translations.login_feature_scheduling,
              },
              {
                // Refresh data sync icon node mapping
                icon_node: <RefreshCw className="w-5 h-5 text-white" />,
                // Label string translation mapping
                label_text: translations.login_feature_records,
              },
              {
                // Shield check icon node mapping
                icon_node: <ShieldCheck className="w-5 h-5 text-white" />,
                // Label string translation mapping
                label_text: translations.login_feature_security,
              },
            ].map(({ icon_node, label_text }, item_index) => {
              // Returning individual features list item markup
              return (
                <li key={item_index} className="flex items-center gap-3">
                  {/* Bubble wrapper for icons */}
                  <span className={[
                    "w-9 h-9 rounded-full bg-white/10",
                    "flex items-center justify-center",
                  ].join(" ")}>
                    {/* Injecting features icon node */}
                    {icon_node}
                  </span>
                  {/* Display text label */}
                  <span className="text-white/90 text-base font-medium">
                    {label_text}
                  </span>
                </li>
              );
            })}
          </ul>
        </div>

        {/* Copyright branding label aligned to dynamic starting border */}
        <p
          className={[
            "relative z-10 text-blue-300 text-sm w-full",
            is_rtl ? "text-right" : "text-left",
          ].join(" ")}
        >
          {/* Copyright notice string translation */}
          {translations.login_copyright}
        </p>
      </div>

      {/* ── Right Panel: Login Interaction Area ────────────────── */}
      <div className="flex-1 flex flex-col items-center justify-center bg-white px-6 py-12">
        {/* Interaction layout box wrapper sizing bounds */}
        <div className="w-full max-w-md">
          {/* Top header region containing language toggle button */}
          <div className="w-full flex justify-end mb-4">
            {/* Switch switcher trigger layout button */}
            <button
              type="button"
              // Swapping active system locale configurations
              onClick={toggle_language}
              // Design layouts classes forcing clean light slate theme
              className={[
                "flex items-center gap-2 px-3 py-1.5 rounded-lg",
                "border border-slate-200 hover:bg-slate-50",
                "transition-all text-sm font-semibold",
                "text-slate-700 shadow-sm",
              ].join(" ")}
            >
              {/* Globe icon wrapper indicator */}
              <Globe className="w-4 h-4 text-blue-600" />
              {/* Conditional label text formatting depending on language */}
              {"en" === current_locale ? "العربية" : "English"}
            </button>
          </div>

          {/* Welcome status badge container indicating navigation status */}
          <div
            // Design classes
            className={[
              "inline-flex items-center gap-1.5 bg-blue-50",
              "border border-blue-100 rounded-full px-3 py-1 mb-6",
            ].join(" ")}
          >
            {/* Activity icon marker element */}
            <Activity className="w-3.5 h-3.5 text-blue-600" />
            {/* Welcome greeting translation label text */}
            <span className="text-blue-600 text-sm font-bold">
              {translations.login_welcome_back}
            </span>
          </div>

          {/* Portal layout forms header titles */}
          <h2 className="text-3xl font-bold text-slate-900 mb-1">
            {translations.login_title}
          </h2>
          {/* Description header subtitle */}
          <p className="text-slate-500 text-sm">
            {translations.login_subtitle}
          </p>

          {/* 
              ── Reserved Error Space ──────────────────────────────────
              Guarantees fixed vertical boundaries preventing content shifting.
          */}
          <div className="h-10 mt-4 mb-2 flex items-center">
            {/* Yoda check validating error state parameters for display */}
            {null !== active_error_message && (
              // Warning notification feedback modal container
              <div
                // Warning panel classes
                className={[
                  "w-full bg-rose-50 text-rose-600 text-[13px]",
                  "font-bold px-3 py-2 rounded-lg flex items-center",
                  "gap-2 border border-rose-100 animate-shake",
                ].join(" ")}
              >
                {/* Visual error status dot indicator */}
                <div className="w-1.5 h-1.5 rounded-full bg-rose-500" />
                {/* Resolved warning error text string */}
                {active_error_message}
              </div>
            )}
          </div>

          {/* Form wrapper element boundaries */}
          <div className="w-full">
            {/* Main credentials input submission form */}
            <form
              // Form submission action triggers
              onSubmit={handle_submit}
              // De-asserting default browser validation controls
              noValidate
              // Forms layout spacing classes
              className="space-y-6"
            >
              {/* Email identification address input box block */}
              <div className="space-y-1.5">
                {/* Inputs title description label */}
                <label
                  htmlFor="email_address"
                  className="block text-sm font-bold text-slate-700"
                >
                  {/* Email address translation label text */}
                  {translations.login_email_label}
                </label>
                {/* Input relative layout container wrapper */}
                <div className="relative">
                  {/* Email verification input element field */}
                  <input
                    // Unique input identifier
                    id="email_address"
                    // Standard email field layout type
                    type="email"
                    // Target autofocus attribute loading on page viewport mount
                    autoFocus
                    // Browser autocomplete hint mappings
                    autoComplete="email"
                    // Requiring values for form validations
                    required
                    // Forcing left-to-right alignment text inputs on email
                    dir="ltr"
                    // Hint input display description label
                    placeholder={translations.login_email_placeholder}
                    // State binding value mapping
                    value={login_params.email_address}
                    // Value adjustment event listeners callbacks
                    onChange={handle_change("email_address")}
                    // Dynamic conditional input styling border configurations
                    className={[
                      "w-full px-4 py-3 border rounded-xl text-sm",
                      "text-slate-900 placeholder-slate-400",
                      "focus:outline-none focus:ring-2 focus:ring-blue-500",
                      "transition-all bg-slate-50 shadow-sm text-left",
                      is_rtl ? "font-cairo" : "font-sans",
                      true === validation_errors.email_address
                        ? "border-rose-500 ring-1 ring-rose-500"
                        : "border-slate-300",
                    ].join(" ")}
                  />
                </div>
              </div>

              {/* Password key code verification input box block */}
              <div className="space-y-1.5">
                {/* Inputs title description label */}
                <label
                  htmlFor="secret_password"
                  className="block text-sm font-bold text-slate-700"
                >
                  {/* Password translation label text */}
                  {translations.login_password_label}
                </label>
                {/* Input relative layout container wrapper */}
                <div className="relative">
                  {/* Password verification input element field */}
                  <input
                    // Unique input identifier
                    id="secret_password"
                    // Conditional input text type depending on visibility boolean
                    type={true === show_password ? "text" : "password"}
                    // Browser autocomplete hint mappings
                    autoComplete="current-password"
                    // Requiring values for form validations
                    required
                    // Forcing left-to-right alignment text inputs on password
                    dir="ltr"
                    // Hint input mask display placeholder dots
                    placeholder={translations.login_password_placeholder}
                    // State binding value mapping
                    value={login_params.secret_password}
                    // Value adjustment event listeners callbacks
                    onChange={handle_change("secret_password")}
                    // Dynamic conditional input styling border configurations
                    className={[
                      "w-full pr-12 pl-4 py-3 border rounded-xl text-sm",
                      "text-slate-900 placeholder-slate-400",
                      "focus:outline-none focus:ring-2 focus:ring-blue-500",
                      "transition-all bg-slate-50 shadow-sm text-left",
                      is_rtl ? "font-cairo" : "font-sans",
                      true === validation_errors.secret_password
                        ? "border-rose-500 ring-1 ring-rose-500"
                        : "border-slate-300",
                    ].join(" ")}
                  />
                  {/* Visibility toggler button placed physically on right side */}
                  <button
                    type="button"
                    // Toggling visibility boolean state trigger parameters
                    onClick={() => {
                      // Adjusting state visibility parameters
                      return set_show_password((previous_state) => {
                        // Returning reversed visibility state value
                        return !previous_state;
                      });
                    }}
                    // Button absolute alignment position classes
                    className={[
                      "absolute right-3 top-1/2 -translate-y-1/2",
                      "text-slate-400 hover:text-blue-600 transition-colors",
                    ].join(" ")}
                  >
                    {/* Conditional eye icon visibility rendering */}
                    {true === show_password ? (
                      <Eye className="w-5 h-5" />
                    ) : (
                      <EyeOff className="w-5 h-5" />
                    )}
                  </button>
                </div>
                {/* Forgot password access link wrapper */}
                <div
                  className={`w-full flex ${
                    is_rtl ? "justify-start" : "justify-end"
                  }`}
                >
                  {/* Underlined forgot password transition navigation link */}
                  <a
                    // Forgot password reset URL route location path
                    href="/auth/forgot-password"
                    // Link styling class settings
                    className={[
                      "text-sm text-blue-600 hover:text-blue-700 font-bold",
                      "transition-colors underline-offset-4 hover:underline",
                    ].join(" ")}
                  >
                    {/* Forgot password translation label text */}
                    {translations.login_forgot_password}
                  </a>
                </div>
              </div>

              {/* Remember me persistent session checker select badge */}
              <label className={[
                "flex items-center gap-2.5 cursor-pointer",
                "select-none group w-fit",
              ].join(" ")}>
                {/* Select state input element */}
                <input
                  // Checkbox layout type representation
                  type="checkbox"
                  // Checked state binding value mapping
                  checked={login_params.remember_me}
                  // Change selection listener callback
                  onChange={handle_change("remember_me")}
                  // Checkbox layout styling classes
                  className={[
                    "w-4 h-4 rounded border-slate-300 text-blue-600",
                    "focus:ring-blue-500 cursor-pointer transition-colors",
                  ].join(" ")}
                />
                {/* Checkbox description label text */}
                <span className={[
                  "text-sm text-slate-600 group-hover:text-slate-800",
                  "transition-colors font-medium",
                ].join(" ")}>
                  {/* Remember me translation text */}
                  {translations.login_remember_me}
                </span>
              </label>

              {/* Form submit dispatch action trigger button */}
              <button
                type="submit"
                // Disable button triggers when loading calls are busy
                disabled={true === is_loading}
                // Button styling design tokens transition configurations
                className={[
                  "w-full py-3.5 rounded-xl bg-blue-600 hover:bg-blue-700",
                  "text-white font-bold text-sm transition-all shadow-md",
                  "active:scale-[0.98] disabled:opacity-60",
                  "disabled:cursor-not-allowed flex items-center",
                  "justify-center gap-2",
                ].join(" ")}
              >
                {/* Conditional spinner element loading checks */}
                {true === is_loading ? (
                  // React fragment layout wrapper containing loading states
                  <>
                    {/* Spinning loader visual SVG icon */}
                    <svg
                      // Spinner classes
                      className="animate-spin w-4 h-4 text-white"
                      viewBox="0 0 24 24"
                      fill="none"
                    >
                      {/* Spinner background track ring circle element */}
                      <circle
                        className="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        strokeWidth="4"
                      />
                      {/* Spinner foreground arc path segment element */}
                      <path
                        className="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8v4l3-3-3-3v4a8 8 0 00-8 8h4z"
                      />
                    </svg>
                    {/* Signing in progress state translation label text */}
                    {translations.login_signing_in}
                  </>
                ) : (
                  // Default sign in text translation label
                  translations.login_sign_in_button
                )}
              </button>
            </form>
          </div>

          {/* HIPAA regulatory protection compliance badge block */}
          <p
            // Sizing classes
            className={[
              "flex items-center justify-center gap-1.5 text-[10px]",
              "text-slate-400 mt-16 font-bold uppercase",
              "tracking-widest text-center w-full",
            ].join(" ")}
          >
            {/* Visual shield security outline SVG icon element */}
            <svg
              width="12"
              height="12"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="3"
            >
              {/* Path descriptor outlining shield boundaries */}
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
            </svg>
            {/* Security badge HIPAA protection translation text */}
            {translations.login_security_badge}
          </p>
        </div>
      </div>
    </div>
  );
}

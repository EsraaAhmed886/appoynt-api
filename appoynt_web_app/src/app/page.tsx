/*
 * File Name: page.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/06/2026]
 * File Description: Interactive portal verifying redux state, bilingual, and Axios.
 */

"use client";
// Importing React state and effect hooks from standard React package
import { useEffect, useState } from "react";
// Importing Redux hooks to dispatch actions and select store state variables
import { useDispatch, useSelector } from "react-redux";
// Importing custom translation hook to query bilingual catalog dictionaries
import { useTranslation } from "@/context/LanguageContext";
// Importing Redux auth slice action mutations for session management
import { login_success, logout_action } from "@/store/authSlice";
// Importing local store root state interface type configuration
import type { RootState } from "@/store/index";
// Importing customized Axios client helper to perform connectivity tests
import { api_client } from "@/lib/api";

// Declaring and exporting the Home page component function
export default function Home() {
  // Pulling translations, current language, and changer handler from context hook
  const { translations, current_locale, change_locale } = useTranslation();
  // Instantiating standard Redux action dispatcher engine trigger hook
  const store_dispatcher = useDispatch();
  // Fetching authentication status objects tree from Redux store state container
  const auth_profile = useSelector((global_state: RootState) => {
    // Returning authorization segment slice data
    return global_state.auth;
  });
  // Declaring state variable to track backend API endpoint connection check state
  const [api_state, set_api_state] = useState<"checking" | "connected" | "disconnected">("checking");
  // Declaring state variable representing local counter clicks inside UI
  const [local_clicks, set_local_clicks] = useState<number>(0);

  // Hook run on component launch to execute live API connection health verification
  useEffect(() => {
    // Declaring asynchronous callback function to contact backend api routes
    const test_network_connection = async () => {
      // Opening structured try-catch execution block for network requests
      try {
        // Triggering mock GET network query to test backend health status endpoint
        const response_data = await api_client.get("/health");
        // Yoda check to verify if server responds with HTTP OK code
        if (200 === response_data.status) {
          // Setting connectivity state variable to success connected indicator
          set_api_state("connected");
        } else {
          // Setting connectivity state variable to error disconnected indicators
          set_api_state("disconnected");
        }
      } catch (network_error) {
        // Logging connection exception logs into browser console for analysis
        console.error("API check failed:", network_error);
        // Setting state flag to disconnected indicator on request catch crashes
        set_api_state("disconnected");
      }
    };
    // Executing the structured network check connection function call
    test_network_connection();
  }, []);

  // Method handler triggered to inject mock login profiles to verify Redux state
  const execute_mock_login = (selected_role: "Doctor" | "Receptionist" | "Admin") => {
    // Dispatching authenticated session action variables with mock payload details
    store_dispatcher(
      // Calling action creator wrapper and mapping mock variables object
      login_success({
        // Access token token hash string matching payload schema
        access_token: "mock_jwt_access_token_token",
        // Email string composed dynamically from user selection role title
        user_email: `${selected_role.toLowerCase()}@appoynt.com`,
        // Active role details parameter matching profiles schema
        user_role: selected_role,
      })
    );
  };

  // Method handler triggered to flush active authentication profile from Redux
  const execute_logout = () => {
    // Dispatching cleanup action trigger to clear state configurations
    store_dispatcher(logout_action());
  };

  // Method handler to increment click counter demonstrating layout interactivity
  const handle_increment = () => {
    // Incrementing counter variable state by one unit
    set_local_clicks((previous_count) => {
      // Returning current click count plus unit increment
      return previous_count + 1;
    });
  };

  // Assembling dynamic color classes for connection indicator text
  let status_color_class = "text-amber-400 animate-pulse";
  // Yoda check to apply green text for connected state
  if ("connected" === api_state) {
    // Setting color to bright emerald theme
    status_color_class = "text-emerald-400";
  } else {
    // Yoda check to apply red text for offline state
    if ("disconnected" === api_state) {
      // Setting color to warning red theme
      status_color_class = "text-rose-500";
    } else {
      // Keeping default amber pulse for active checking states
    }
  }

  // Returning interface template structure wrapping all dashboard portal assets
  return (
    // Outer page layout background container styled with design token colors
    <main className="flex min-h-screen flex-col items-center justify-center p-8 bg-app-background text-app-text-primary font-sans transition-colors duration-200">
      {/* Decorative gradient overlay block to add rich visual depth effects */}
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(15,98,254,0.03),transparent_60%)] pointer-events-none" />

      {/* Main card box container applying backdrop blur and transparent borders from tokens */}
      <div className="z-10 w-full max-w-4xl p-8 rounded-2xl backdrop-blur-md bg-app-surface/40 border border-app-border shadow-2xl space-y-8 transition-colors duration-200">
        
        {/* Top header flex box layout containing logo references and lang buttons */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 border-b border-app-border pb-6">
          {/* Site brand identity and logo section */}
          <div className="flex items-center gap-3">
            {/* Visual logo placeholder block container using primary brand color */}
            <div className="w-10 h-10 rounded-lg bg-app-primary flex items-center justify-center font-bold text-white shadow-lg shadow-blue-500/20">
              {/* Dynamic logo letter translated based on active language */}
              {translations.logo_letter}
            </div>
            {/* Branding titles */}
            <div>
              {/* Primary title display */}
              <h1 className="text-2xl font-bold bg-gradient-to-r from-blue-500 to-indigo-400 bg-clip-text text-transparent">
                {translations.app_name}
              </h1>
              {/* System state indicators */}
              <p className="text-xs text-app-text-secondary">
                {translations.system_operational}
              </p>
            </div>
          </div>

          {/* Bilingual selector controller toggle buttons section */}
          <div className="flex items-center gap-2 bg-app-surface/65 p-1 rounded-lg border border-app-border">
            {/* English translation selection toggle button */}
            <button
              // Trigger locale switch logic to english code
              onClick={() => {
                // Switching language state to English
                change_locale("en");
              }}
              // Applying dynamic hover states and background highlights depending on locale
              className={`px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                "en" === current_locale
                  ? "bg-app-primary text-white shadow-md shadow-blue-500/10"
                  : "text-app-text-secondary hover:text-app-text-primary"
              }`}
            >
              {translations.lang_english}
            </button>
            
            {/* Arabic translation selection toggle button */}
            <button
              // Trigger locale switch logic to arabic code
              onClick={() => {
                // Switching language state to Arabic
                change_locale("ar");
              }}
              // Applying dynamic hover states and background highlights depending on locale
              className={`px-3 py-1.5 rounded-md text-xs font-medium transition-all ${
                "ar" === current_locale
                  ? "bg-app-primary text-white shadow-md shadow-blue-500/10"
                  : "text-app-text-secondary hover:text-app-text-primary"
              }`}
            >
              {translations.lang_arabic}
            </button>
          </div>
        </div>

        {/* Center content grid splitting page controls and info logs */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          
          {/* Left partition managing interactive testing controllers */}
          <div className="space-y-6">
            {/* Header segment for localization and state actions */}
            <div>
              {/* Category main title */}
              <h2 className="text-lg font-semibold text-app-primary">
                {translations.welcome_title}
              </h2>
              {/* Category description subtitle */}
              <p className="text-sm text-app-text-secondary mt-1">
                {translations.welcome_subtitle}
              </p>
            </div>

            {/* Redux State testing controller buttons card segment */}
            <div className="p-5 rounded-xl bg-app-surface/10 border border-app-border space-y-4">
              {/* Title description label for Redux state section */}
              <h3 className="text-sm font-semibold text-app-text-primary">
                {translations.redux_test}
              </h3>
              
              {/* Render actions when user is logged out */}
              {null === auth_profile.access_token ? (
                // Wrapper div grouping login options
                <div className="space-y-3">
                  {/* Explanatory helper warning label using translated keys */}
                  <p className="text-xs text-app-text-secondary">
                    {translations.prompt_select_role}
                  </p>
                  {/* Grid arrangement for mock roles triggers */}
                  <div className="grid grid-cols-3 gap-2">
                    {/* Doctor login action trigger button */}
                    <button
                      // Dispatch doctor login credentials
                      onClick={() => {
                        // Launching doctor login dispatcher
                        execute_mock_login("Doctor");
                      }}
                      // Tailwind aesthetic button tags using design token colors
                      className="px-2 py-2 bg-app-surface hover:bg-app-border text-app-text-primary rounded-lg text-xs font-medium transition border border-app-border"
                    >
                      {translations.role_doctor_short}
                    </button>
                    {/* Receptionist login action trigger button */}
                    <button
                      // Dispatch receptionist login credentials
                      onClick={() => {
                        // Launching receptionist login dispatcher
                        execute_mock_login("Receptionist");
                      }}
                      // Tailwind aesthetic button tags using design token colors
                      className="px-2 py-2 bg-app-surface hover:bg-app-border text-app-text-primary rounded-lg text-xs font-medium transition border border-app-border"
                    >
                      {translations.role_receptionist_short}
                    </button>
                    {/* Admin login action trigger button */}
                    <button
                      // Dispatch admin login credentials
                      onClick={() => {
                        // Launching admin login dispatcher
                        execute_mock_login("Admin");
                      }}
                      // Tailwind aesthetic button tags using design token colors
                      className="px-2 py-2 bg-app-surface hover:bg-app-border text-app-text-primary rounded-lg text-xs font-medium transition border border-app-border"
                    >
                      {translations.role_admin_short}
                    </button>
                  </div>
                </div>
              ) : (
                // Wrapper layout displaying current active session and logout trigger
                <div className="space-y-3">
                  {/* Displaying information about the current session email */}
                  <div className="p-3 bg-app-primary/10 border border-app-primary/20 rounded-lg text-xs text-app-primary space-y-1">
                    <div>
                      {/* Active profile text */}
                      {translations.active_user}:
                    </div>
                    {/* User email string */}
                    <div className="font-mono font-bold text-app-text-primary">
                      {auth_profile.user_email}
                    </div>
                    {/* Active profile system role label */}
                    <div className="text-[10px] uppercase tracking-wider text-app-text-secondary mt-1">
                      {translations.label_role}: {auth_profile.user_role}
                    </div>
                  </div>
                  {/* Logout session flush trigger button */}
                  <button
                    // Flashing authentication credentials and state settings
                    onClick={execute_logout}
                    // Tailwind red layout button indicators using warning tokens
                    className="w-full py-2 bg-rose-950/20 hover:bg-rose-900/30 border border-rose-500/20 text-rose-400 rounded-lg text-xs font-medium transition"
                  >
                    {translations.btn_sign_out}
                  </button>
                </div>
              )}
            </div>

            {/* Local state interactivity click checks component */}
            <div className="p-5 rounded-xl bg-app-surface/10 border border-app-border flex items-center justify-between">
              {/* Displaying current count tag */}
              <div>
                {/* Count description title */}
                <h4 className="text-xs font-semibold text-app-text-secondary">
                  {translations.current_count}
                </h4>
                {/* Count value numeric indicator */}
                <p className="text-2xl font-mono font-bold text-app-text-primary mt-1">
                  {local_clicks}
                </p>
              </div>
              {/* Click trigger action button */}
              <button
                // Increments counter state value
                onClick={handle_increment}
                // Tailwind design highlight tags
                className="px-4 py-2 bg-app-primary hover:opacity-90 text-white rounded-lg text-xs font-medium shadow-lg shadow-blue-500/10 transition-all active:scale-95"
              >
                {translations.counter_increment}
              </button>
            </div>
          </div>

          {/* Right partition holding network check logs and framework metadata details */}
          <div className="space-y-6 flex flex-col justify-between">
            {/* Info table holding setup specifications and active variables state details */}
            <div className="p-6 rounded-xl bg-app-surface/10 border border-app-border space-y-4 flex-grow">
              {/* Section descriptor title */}
              <h3 className="text-sm font-semibold text-app-text-primary">
                {translations.foundational_stack}
              </h3>
              
              {/* Parameters list arrangement */}
              <ul className="space-y-3 text-xs text-app-text-secondary">
                {/* Frame row */}
                <li className="flex items-center justify-between border-b border-app-border pb-2">
                  <span>{translations.param_framework}:</span>
                  <span className="font-mono text-app-text-primary">Next.js 15.0 (App Router)</span>
                </li>
                {/* Compiler row */}
                <li className="flex items-center justify-between border-b border-app-border pb-2">
                  <span>{translations.param_language}:</span>
                  <span className="font-mono text-app-text-primary">React 19 / TypeScript</span>
                </li>
                {/* Stylings row */}
                <li className="flex items-center justify-between border-b border-app-border pb-2">
                  <span>{translations.param_styling}:</span>
                  <span className="font-mono text-app-text-primary">Tailwind CSS 3.4</span>
                </li>
                {/* State Engine row */}
                <li className="flex items-center justify-between border-b border-app-border pb-2">
                  <span>{translations.param_state}:</span>
                  <span className="font-mono text-app-text-primary">Redux Toolkit (`@reduxjs/toolkit`)</span>
                </li>
                {/* Network Layer row */}
                <li className="flex items-center justify-between border-b border-app-border pb-2">
                  <span>{translations.param_network}:</span>
                  <span className="font-mono text-app-text-primary">Axios (`axios` client helper)</span>
                </li>
                {/* Current Local active selection font display row */}
                <li className="flex items-center justify-between">
                  <span>{translations.param_font}:</span>
                  <span className="font-mono text-app-text-primary">
                    {/* Dynamic font descriptions */}
                    {"ar" === current_locale ? translations.font_ar_label : translations.font_en_label}
                  </span>
                </li>
              </ul>
            </div>

            {/* Network client Axios connectivity live health check warning banner */}
            <div className="p-4 rounded-xl bg-app-surface/10 border border-app-border flex items-center justify-between">
              {/* Check details text labels */}
              <div className="flex items-center gap-2">
                {/* Circular pulsing status light indicator */}
                <div
                  // Dynamic class bindings matching API checks
                  className={`w-2.5 h-2.5 rounded-full ${
                    "connected" === api_state
                      ? "bg-emerald-400 shadow-md shadow-emerald-500/20"
                      : "checking" === api_state
                      ? "bg-amber-400 animate-pulse"
                      : "bg-rose-500"
                  }`}
                />
                {/* Check category identifier label text */}
                <span className="text-xs text-app-text-secondary">
                  {translations.api_status}:
                </span>
              </div>
              {/* Endpoint response string indicator */}
              <span className={`text-xs font-bold font-mono ${status_color_class}`}>
                {/* Conditional translations based on status state */}
                {"connected" === api_state
                  ? translations.api_connected
                  : "checking" === api_state
                  ? translations.api_checking
                  : translations.api_disconnected}
              </span>
            </div>
          </div>
        </div>

        {/* Footer section providing clean helper notes to developers */}
        <div className="text-center pt-4 border-t border-app-border text-[10px] text-app-text-secondary/50">
          {translations.footer_text}
        </div>
      </div>
    </main>
  );
}

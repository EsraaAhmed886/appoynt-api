/*
 * File Name: authSlice.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: 1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/06/2026]
 * File Description: Defines Redux Toolkit auth slice for managing user login session states.
 */

// Importing createSlice helper function from Redux Toolkit dependency
import { createSlice } from "@reduxjs/toolkit";

// Declaring typing interface structure representing schema of authentication state
export interface AuthState {
  // String reference containing the JWT access token or empty state
  access_token: string | null;
  // Username or client email display title identifier
  user_email: string | null;
  // System role mapped to current profile (doctor, receptionist, admin, etc.)
  user_role: string | null;
  // Dynamic boolean marker identifying busy asynchronous network calls
  is_loading: boolean;
  // Validation or backend network response error message text
  error_message: string | null;
}

// Declaring initialization defaults object matching state schema interface
const initial_auth_state: AuthState = {
  // Access token starts as null representing guest state
  access_token: null,
  // User email is initialized as null
  user_email: null,
  // User role remains empty until verification completes
  user_role: null,
  // Loading status starts set to false
  is_loading: false,
  // Clear any default error message strings
  error_message: null,
};

// Instantiating slice configuration mapping reducers and states
export const auth_slice = createSlice({
  // Setting the unique state partition namespace identifier in store
  name: "auth",
  // Injecting state initialization constant defaults object
  initialState: initial_auth_state,
  // Declaring reducer functions matching state action mutations
  reducers: {
    // Action handler to register active authenticated session payloads
    login_success: (state_draft, action_payload) => {
      // Setting token value from action dispatcher payload parameter
      state_draft.access_token = action_payload.payload.access_token;
      // Extracting user identity email value from incoming payload
      state_draft.user_email = action_payload.payload.user_email;
      // Storing authorized access role context key in state
      state_draft.user_role = action_payload.payload.user_role;
      // Clearing any active flags after successful operations
      state_draft.is_loading = false;
      // Resetting active log error warnings to clear status
      state_draft.error_message = null;
    },
    // Action handler to destroy session and wipe security credentials
    logout_action: (state_draft) => {
      // Setting token values to null to reset auth headers
      state_draft.access_token = null;
      // Wiping cached user details email string from memory
      state_draft.user_email = null;
      // Nullifying user roles variables to block private routes
      state_draft.user_role = null;
      // Terminating pending spinners
      state_draft.is_loading = false;
      // Resetting validation error labels
      state_draft.error_message = null;
    },
    // Action helper to control interface spinner overlays
    set_loading: (state_draft, action_payload) => {
      // Direct boolean assignment from loader state parameter
      state_draft.is_loading = action_payload.payload;
    },
    // Action helper to store runtime response errors
    set_error: (state_draft, action_payload) => {
      // Updating error message parameters to display modal warnings
      state_draft.error_message = action_payload.payload;
      // Stopping spinners when system triggers error alerts
      state_draft.is_loading = false;
    },
  },
});

// Exporting reducer action triggers to connect layout buttons to store actions
export const { login_success, logout_action, set_loading, set_error } = auth_slice.actions;

// Exporting slice core reducer callback to inject in store orchestrator
export default auth_slice.reducer;

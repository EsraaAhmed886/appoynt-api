/*
 * File Name: auth_slice.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Dependencies: @reduxjs/toolkit, axios, @/lib/api, @/lib/api/auth.api, @/types
 * Contributors: [Kholoud Khaled, shimaa salah]
 * Last Modified Date: [shimaa salah - 30/08/2026]
 * File Description: Defines Redux Toolkit auth slice for managing user login session states.
 */

// Importing createAsyncThunk and createSlice utilities from Redux Toolkit package
import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
// Importing AxiosError for exceptions matching safety
import { AxiosError } from "axios";
// Importing storage helpers from API configuration utility
import { set_safe_storage, remove_safe_storage, get_safe_storage } from "@/lib/api";
// Importing auth endpoints definitions from auth api registry
import { auth_api } from "@/lib/api/auth.api";
// Importing login credentials interface type schema
import type { login_credentials } from "@/types";
// Asynchronous thunk action handler to perform login API verification requests
export const login_thunk = createAsyncThunk(
  // The unique string identifier representation of action thunk trigger
  "auth/login_thunk",
  // The payload creator callback executing network verification requests
  async (credentials: login_credentials, { rejectWithValue }) => {
    // Opening try-catch execution block for volatile network client calls
    try {
      // Calling authentication api endpoint passing parameters
      const response = await auth_api.login_call(credentials);

      // Extracting JWT access token string from response payload
      const access_token: string =
        response.data?.accessToken || response.data?.access_token || "";

      // Initializing default user credentials fallback values
      let user_role: string = "Doctor";
      let user_email: string = credentials.email_address;

      // Yoda style comparison checking if access token string exists
      if ("" !== access_token) {
        // Opening try-catch block for safe token decoding
        try {
          // Splitting JWT token string to extract base64 payload segment
          const payload_base64 = access_token.split(".")[1];
          // Parsing base64 decoded string into JSON object
          const decoded_payload = JSON.parse(atob(payload_base64));

          // Resolving user role claim from decoded claims
          user_role =
            decoded_payload.role ||
            decoded_payload[
            "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
            ] ||
            "Doctor";

          // Resolving user email identification from decoded claims
          user_email =
            decoded_payload.email ||
            decoded_payload.sub ||
            credentials.email_address;
        } catch (decode_error) {
          // Fallback to default credentials when JWT parsing encounters errors
        }

        // Saving the JWT access token in browser local storage safely
        set_safe_storage("appoynt_token", access_token);
      } else {
        // Explicit empty action block when access token is empty
      }

      // Returning successfully authenticated payload parameters to reducer
      return { access_token, user_email, user_role };
    } catch (network_error) {
      // Casting general error response to AxiosError type configuration
      const error_obj = network_error as AxiosError<{
        message?: string;
        title?: string;
      }>;

      // Extracting descriptive validation message from server response object
      const message_str: string =
        error_obj.response?.data?.message ||
        error_obj.response?.data?.title ||
        "Invalid email or password";

      // Propagating rejected warning message down the thunk payload line
      return rejectWithValue(message_str);
    }
  }
);

// Asynchronous thunk action handler to perform logout API request calls
export const logout_thunk = createAsyncThunk(
  // The unique string identifier representation of action thunk trigger
  "auth/logout_thunk",
  // The payload creator callback executing logout requests
  async () => {
    // Opening try-catch execution block for network client requests
    try {
      // Pulling active refresh token from browser local storage safely
      const refresh_token = get_safe_storage("appoynt_refresh_token") || "";
      // Triggering backend invalidation call passing active refresh token
      await auth_api.logout_call(refresh_token);
    } catch (network_error) {
      // Print warning notifications to console for analysis checks
      console.warn("Server logout could not complete successfully:", network_error);
    } finally {
      // Wiping JWT access token from browser local storage safely
      remove_safe_storage("appoynt_token");
      // Wiping JWT refresh token from browser local storage safely
      remove_safe_storage("appoynt_refresh_token");
    }
  }
);

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
  // Configuring extra reducers block to handle async thunk life cycles
  extraReducers: (builder_instance) => {
    // Setting up cases block on builder instance
    builder_instance
      // Case handling login request pending state
      .addCase(login_thunk.pending, (state_draft) => {
        // Setting busy loading spinner flag to true state
        state_draft.is_loading = true;
        // Wiping out old validation error messages in state
        state_draft.error_message = null;
      })
      // Case handling login request successful verification state
      .addCase(login_thunk.fulfilled, (state_draft, action_payload) => {
        // Turning off busy loading spinner flag
        state_draft.is_loading = false;
        // Setting access token in state from thunk response payload
        state_draft.access_token = action_payload.payload.access_token;
        // Setting user email in state from thunk response payload
        state_draft.user_email = action_payload.payload.user_email;
        // Setting user role in state from thunk response payload
        state_draft.user_role = action_payload.payload.user_role;
        // Resetting any active validation warnings
        state_draft.error_message = null;
      })
      // Case handling login request rejected failure state
      .addCase(login_thunk.rejected, (state_draft, action_payload) => {
        // Turning off busy loading spinner flag
        state_draft.is_loading = false;
        // Injecting returned validation error message string to state
        state_draft.error_message = action_payload.payload as string;
      })
      // Case handling logout request fulfilled state
      .addCase(logout_thunk.fulfilled, (state_draft) => {
        // Resetting access token in state
        state_draft.access_token = null;
        // Resetting user email in state
        state_draft.user_email = null;
        // Resetting user role in state
        state_draft.user_role = null;
        // Resetting loading flag in state
        state_draft.is_loading = false;
        // Resetting error warning in state
        state_draft.error_message = null;
      })
      // Case handling logout request rejected failure state
      .addCase(logout_thunk.rejected, (state_draft) => {
        // Resetting access token in state
        state_draft.access_token = null;
        // Resetting user email in state
        state_draft.user_email = null;
        // Resetting user role in state
        state_draft.user_role = null;
        // Resetting loading flag in state
        state_draft.is_loading = false;
        // Resetting error warning in state
        state_draft.error_message = null;
      });
  },
});

// Exporting reducer action triggers to connect layout buttons to store actions
export const { login_success, logout_action, set_loading, set_error } = auth_slice.actions;

// Exporting slice core reducer callback to inject in store orchestrator
export default auth_slice.reducer;

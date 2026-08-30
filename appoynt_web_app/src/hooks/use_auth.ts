/*
 * File Name: use_auth.ts
 * Author: Kholoud Khaled
 * Date of Creation: 03/07/2026
 * Version Information: V1.0.0
 * Dependencies: react, next/navigation, react-redux,
 *   @/store/auth_slice, @/store/index, @/types
 * Contributors: [Kholoud Khaled, shimaa salah]
 * Last Modified Date: [shimaa salah - 30/08/2026]
 * File Description: A custom authentication hook interfacing components with Redux auth state.
 */

// Enabling client-side rendering context for this React hook file
"use client";

// Importing useCallback utility hook from standard React package
import { useCallback } from "react";
// Importing next navigation router hook controller
import { useRouter } from "next/navigation";
// Importing Redux state selector and action dispatcher hooks
import { useDispatch, useSelector } from "react-redux";
// Importing async thunk actions and action creators from auth slice
import { login_thunk, logout_thunk, set_error } from "@/store/auth_slice";
// Importing state interface type definitions
import type { AppDispatch, RootState } from "@/store/index";
// Importing credentials interface layout structure
import type { login_credentials } from "@/types";

// Defining and exporting the use_auth custom react hook function
export function use_auth() {
  // Instantiating standard Redux action dispatcher engine hook
  const dispatcher = useDispatch<AppDispatch>();
  // Instantiating Next.js navigation router action helper
  const router = useRouter();

  // Querying and destructuring authentication state variables from store
  const { access_token, user_email, user_role, is_loading, error_message } =
    useSelector((global_state: RootState) => {
      // Returning active authentication segment state slice
      return global_state.auth;
    });

  // Helper routine determining landing page route based on profile role keys
  const dashboard_path = useCallback((current_role: string): string => {
    // Evaluating target landing layout directory depending on role profile keys
    switch (current_role) {
      // Case mapping to administrator dashboard layouts
      case "Admin": {
        // Returning admin landing page directory url
        return "/admin";
      }
      // Case mapping to medical practitioner dashboard layouts
      case "Doctor": {
        // Returning doctor landing page directory url
        return "/dashboard";
      }
      // Case mapping to clinic staff dashboard layouts
      case "Receptionist": {
        // Returning receptionist landing page directory url
        return "/receptionist";
      }
      // Fallback default landing route path
      default: {
        // Returning standard root portal layout
        return "/dashboard";
      }
    }
  }, []);

  // Async helper execution callback dispatching credential parameters to thunks
  const login = useCallback(
    async (credentials: login_credentials) => {
      // Executing and dispatching the login async thunk action
      const action_result = await dispatcher(login_thunk(credentials));

      // Yoda check to verify if the async action resolved successfully
      if (login_thunk.fulfilled.match(action_result)) {
        // Extracting user role identifier from action payload parameters
        const user_role_key = action_result.payload.user_role ?? "";
        // Resolving correct landing layout URL route using role checks
        const landing_url = dashboard_path(user_role_key);
        // Directing web page view to resolved landing URL route location
        router.replace(landing_url);
      } else {
        // Async actions handles loading states and errors automatically in slice
      }
    },
    [dispatcher, router, dashboard_path]
  );

  // Async helper execution callback clearing active session configurations
  const logout = useCallback(async () => {
    // Executing and dispatching the logout thunk callback routine
    await dispatcher(logout_thunk());
    // Redirecting user back to standard credential submission layout
    router.replace("/auth/login");
  }, [dispatcher, router]);

  // Helper function to dismiss current active state error notification warnings
  const dismiss_error = useCallback(() => {
    // Dispatching error state mutation action with null values
    dispatcher(set_error(null));
  }, [dispatcher]);

  // Returning hook public variables and helpers interface to layout consumers
  return {
    // Returns active session access token
    access_token,
    // Returns authenticated account email string
    user_email,
    // Returns verified account privilege role
    user_role,
    // Returns active loader status flag
    is_loading,
    // Returns active warning notification message string
    error_message,
    // Returns login executor function handler
    login,
    // Returns logout executor function handler
    logout,
    // Returns dashboard path calculator helper function
    dashboard_path,
    // Returns error dismission executor function handler
    dismiss_error,
  };
}

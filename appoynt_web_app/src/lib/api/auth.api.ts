/*
 * File Name: auth.api.ts
 * Author: Kholoud Khaled
 * Date of Creation: 03/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - @/lib/api
 *   - @/types
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 03/07/2026]
 * File Description: Defines the collection of authentication-related API endpoints.
 */

// Importing the base configured Axios client instance
import { api_client } from "@/lib/api";
// Importing type requirements for login credentials
import type { login_credentials } from "@/types";

// Defining the auth_api registry object to group auth network endpoints
export const auth_api = {
  // Post request handler function sending credential payload to login route
  login_call: (login_params: login_credentials) => {
    // Calling login route endpoint passing login parameters data
    return api_client.post("/auth/login", login_params);
  },

  // Post request handler function sending refresh token payload to refresh route
  refresh_call: (refresh_token: string) => {
    // Calling refresh route endpoint passing refresh token value parameter
    return api_client.post("/auth/refresh", { refresh_token });
  },

  // Post request handler function sending refresh token to logout route
  logout_call: (refresh_token: string) => {
    // Calling logout route endpoint passing active refresh token parameter
    return api_client.post("/auth/logout", { refresh_token });
  },

  // Get request handler function fetching verified user profile data details
  me_call: () => {
    // Calling user profile route endpoint to fetch details
    return api_client.get("/auth/me");
  },
};

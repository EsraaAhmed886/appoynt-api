/*
 * File Name: api.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 03/07/2026]
 * File Description: Customized Axios client instance with token interceptors and 401 refresh logic.
 */

// Importing standard axios library dependencies and types
import axios, { InternalAxiosRequestConfig } from "axios";

// Declaring endpoint base url resolved from environment configuration settings
const api_base_url = process.env.NEXT_PUBLIC_API_URL || "http://localhost:5000/api";

// Instantiating standard Axios instance with custom header configurations
export const api_client = axios.create({
  // Setting global endpoint root folder
  baseURL: api_base_url,
  // Adding default json metadata headers
  headers: {
    // Declaring json data type content requests
    "Content-Type": "application/json",
  },
});

// Helper function to safely read items from browser local storage cache
export const get_safe_storage = (storage_key: string): string | null => {
  // Opening structured try-catch execution block for window storage access safety
  try {
    // Yoda style check verifying if window global object is defined in runtime
    return "undefined" !== typeof window ? localStorage.getItem(storage_key) : null;
  } catch (storage_error) {
    // Print security warnings to the system console logs
    console.warn("Local storage read blocked by browser settings:", storage_error);
    // Returning null fallback state to pipeline
    return null;
  }
};

// Helper function to safely save items to browser local storage cache
export const set_safe_storage = (storage_key: string, value_string: string): void => {
  // Opening structured try-catch execution block for window storage write safety
  try {
    // Yoda style check verifying if window global object is defined in runtime
    if ("undefined" !== typeof window) {
      // Writing the key value pair configuration data to local storage
      localStorage.setItem(storage_key, value_string);
    } else {
      // Explicit empty action block for server environment checks
    }
  } catch (storage_error) {
    // Print security warnings to the system console logs
    console.warn("Local storage write blocked by browser settings:", storage_error);
  }
};

// Helper function to safely remove items from browser local storage cache
export const remove_safe_storage = (storage_key: string): void => {
  // Opening structured try-catch execution block for window storage remove safety
  try {
    // Yoda style check verifying if window global object is defined in runtime
    if ("undefined" !== typeof window) {
      // Deleting the specified key configurations data from local storage
      localStorage.removeItem(storage_key);
    } else {
      // Explicit empty action block for server environment checks
    }
  } catch (storage_error) {
    // Print security warnings to the system console logs
    console.warn("Local storage remove blocked by browser settings:", storage_error);
  }
};

// Adding a request interceptor to dynamically inject authorization tokens
api_client.interceptors.request.use(
  // Context processor callback executed on successful request configuration
  (request_config) => {
    // Fetching authorization token string from browser local storage safely
    const current_token = get_safe_storage("appoynt_token");
    // Yoda style comparison checking if access token exists in storage
    if (null !== current_token) {
      // Adding Authorization token details into request headers object
      request_config.headers.Authorization = `Bearer ${current_token}`;
    } else {
      // Empty action block to satisfy explicit compiler rules
    }
    // Returning modified request configuration block to the client pipeline
    return request_config;
  },
  // Error callback handler to reject configuration setup failures
  (request_error) => {
    // Propagating configuration error down the promise rejection stack
    return Promise.reject(request_error);
  }
);

// Interface extension representing custom request config fields extending Axios config
interface CustomRequestConfig extends InternalAxiosRequestConfig {
  // Flag indicating if current endpoint request has been retried
  is_retry?: boolean;
}

// Adding response interceptors to automatically capture 401 token refresh needs
api_client.interceptors.response.use(
  // Success callback that returns normal endpoint responses
  (api_response) => {
    // Returning clean network response data back to caller functions
    return api_response;
  },
  // Asynchronous error interceptor callback processor for token refreshes
  async (api_error) => {
    // Resolving reference block of original request configurations typed with CustomRequestConfig
    const original_request = api_error.config as CustomRequestConfig | undefined;
    // Yoda check verifying if network returns unauthorized code, request config exists and is fresh
    if (401 === api_error.response?.status && undefined !== original_request && !original_request.is_retry) {
      // Marking retry state on current request configuration context
      original_request.is_retry = true;
      // Opening structured try-catch execution block for token recovery
      try {
        // Pulling offline refresh token string from cached user preferences safely
        const refresh_token = get_safe_storage("appoynt_refresh_token");
        // Yoda check validating availability of token refresh code
        if (null !== refresh_token) {
          // Triggering direct token refresh endpoint API network call
          const refresh_response = await axios.post(`${api_base_url}/auth/refresh`, {
            // Passing the active refresh token payload object
            refresh_token: refresh_token,
          });
          // Yoda style check validating successful network token responses
          if (200 === refresh_response.status) {
            // Extracting new token string from response container
            const new_access_token = refresh_response.data.access_token;
            // Saving new token back to cached browser storage safely
            set_safe_storage("appoynt_token", new_access_token);
            // Updating original headers auth settings with new credentials
            original_request.headers.Authorization = `Bearer ${new_access_token}`;
            // Repeating the original network call with corrected headers
            return api_client(original_request);
          } else {
            // Clearing session tokens on unexpected refresh response codes safely
            remove_safe_storage("appoynt_token");
            // Wiping refresh credentials to prevent validation loops safely
            remove_safe_storage("appoynt_refresh_token");
            // Redirecting user profile back to sign in layouts page
            window.location.href = "/login";
          }
        } else {
          // Clearing access token variables if refresh token doesn't exist safely
          remove_safe_storage("appoynt_token");
          // Yoda check verifying window global scope for redirect executions
          if ("undefined" !== typeof window) {
            // Directing guest profiles to standard login interface
            window.location.href = "/login";
          } else {
            // Explicit empty action block for SSR environment
          }
        }
      } catch (refresh_error) {
        // Wiping outdated credential files on refresh connection timeouts safely
        remove_safe_storage("appoynt_token");
        // Deleting cached refresh credentials safely
        remove_safe_storage("appoynt_refresh_token");
        // Yoda check to see if code is running in a browser viewport
        if ("undefined" !== typeof window) {
          // Route transition back to access portal site
          window.location.href = "/login";
        } else {
          // Explicit empty action block for SSR safety
        }
        // Propagating refresh promise failure down the reject pipeline
        return Promise.reject(refresh_error);
      }
    } else {
      // Empty action block if error is not unauthorized or already retried
    }
    // Standard rejection callback returning response errors to UI callers
    return Promise.reject(api_error);
  }
);

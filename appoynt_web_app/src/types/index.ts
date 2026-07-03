/*
 * File Name: index.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 03/07/2026]
 * File Description: Declares common TypeScript interface types for Appoynt web application.
 */

// Exporting user session structure representing user session data payload
export interface UserSession {
  // Username email address of user
  user_email: string;
  // Account role (e.g., Doctor, Receptionist, Admin)
  user_role: string;
  // JWT security access token string
  access_token: string;
}

// Exporting login credentials interface required for user authentication
export interface login_credentials {
  // The email address input string used for verification
  email_address: string;
  // The secret password string used for authentication
  secret_password: string;
  // Optional flag to persist the login session
  remember_me?: boolean;
}


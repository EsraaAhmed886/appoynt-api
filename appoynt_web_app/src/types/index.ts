/*
 * File Name: index.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: 1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/06/2026]
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

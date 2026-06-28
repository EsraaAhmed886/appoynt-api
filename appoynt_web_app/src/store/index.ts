/*
 * File Name: index.ts
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: 1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/06/2026]
 * File Description: Main Redux store configuration and state engine.
 */

// Importing configureStore utility from Redux Toolkit module package
import { configureStore } from "@reduxjs/toolkit";
// Importing slice reducer callback to mount authorization logic on store
import auth_reducer from "@/store/authSlice";

// Instantiating application global state store mapping reducer functions
export const app_store = configureStore({
  // Root reducer declarations mapping state slices to keys
  reducer: {
    // Mounting authentication slice slice onto app store state
    auth: auth_reducer,
  },
});

// Defining type definitions representing whole store state structure tree
export type RootState = ReturnType<typeof app_store.getState>;
// Exporting type structure of global dispatch actions controller
export type AppDispatch = typeof app_store.dispatch;

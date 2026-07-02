"use client";

/*
 * File Name: StoreProvider.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 28/06/2026
 * Version Information: V1.0.0
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/06/2026]
 * File Description: Client component wrapping react-redux Provider for Next.js App Router.
 */

// Importing React node utility type from standard React package
import React from "react";
// Importing Provider component wrapper from react-redux dependency
import { Provider } from "react-redux";
// Importing application state store orchestrator setup configuration
import { app_store } from "@/store/index";

// Declaring and exporting the StoreProvider component wrapper function
export function StoreProvider({
  // Destructuring child node elements parameters from props
  children,
}: {
  // Specifying type requirements for React child elements
  children: React.ReactNode;
}) {
  // Rendering provider wrapping children elements with the store state
  return (
    <Provider
      // Injecting configuration reference value of the store
      store={app_store}
    >
      {/* Root layout component rendering anchor */}
      {children}
    </Provider>
  );
}

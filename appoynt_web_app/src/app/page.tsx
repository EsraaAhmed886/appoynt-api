/*
 * File Name: page.tsx
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 17/06/2026]
 * File Description: Default home page displaying setup success.
 */

// Declaring and exporting the Home page component function
export default function Home() {
  // Returning the JSX template structure for the homepage
  return (
    // Outer main layout container styled with Tailwind CSS flexbox
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-slate-900 text-white">
      {/* Centered card container for the content */}
      <div className="z-10 max-w-5xl w-full items-center justify-center font-mono text-sm flex flex-col gap-4">
        {/* Main title header */}
        <h1 className="text-4xl font-bold text-teal-400">
          Appoynt Web App
        </h1>
        {/* Subtitle message indicating successful setup */}
        <p className="text-lg text-slate-400">
          Next.js 14 and Tailwind CSS project setup successfully initialized.
        </p>
      </div>
    </main>
  );
}

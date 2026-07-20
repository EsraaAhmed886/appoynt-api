import Image from "next/image";

export default function EmptyState() {
  return (
    <div className="flex flex-col items-center justify-center px-6 py-12 text-center">
      <Image
        src="/images/empty_clinic.jpeg"
        alt="No Clinics"
        width={220}
        height={220}
        priority
      />

      <h2 className="mx-auto max-w-xs text-center text-3xl font-bold leading-tight text-app-text-primary sm:max-w-md sm:text-4xl lg:max-w-none lg:text-5xl">
        You don't have any clinics yet
      </h2>

      <p className="mx-auto mt-4 max-w-xs text-center text-base leading-relaxed text-app-text-secondary sm:max-w-md sm:text-lg">
        Add your first clinic to get started.
      </p>
    </div>
  );
}
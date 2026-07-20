import Image from "next/image";

export default function ErrorState() {
  return (
    <div className="flex flex-col items-center justify-center py-20">
      <Image
        src="/images/no_search.jpeg"
        alt="No Search Results"
        width={220}
        height={220}
        priority
      />

      <h2 className="mt-8 text-3xl font-bold text-app-text-primary">
        No Search Results
      </h2>

      <p className="mt-2 text-center text-lg text-app-text-secondary">
        We couldn’t find any clinics matching your search.
      </p>
    </div>
  );
}
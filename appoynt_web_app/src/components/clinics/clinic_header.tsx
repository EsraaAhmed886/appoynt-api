export default function ClinicHeader() {
  return (
    <div className="mb-8 flex flex-col gap-5 sm:flex-row sm:items-center sm:justify-between">
      {/* Left Side */}
      <div>
        <h1 className="text-2xl font-bold text-app-text-primary sm:text-3xl">
          Clinics Management
        </h1>

        <p className="mt-1 text-sm text-app-text-secondary sm:text-base">
          Manage your clinics, locations and consultation fees
        </p>
      </div>

      {/* Right Side */}
      <div className="flex items-center gap-3 self-start sm:self-auto">
        <img
          src="/images/profile_icon.jpeg"
          alt="Doctor"
          className="h-10 w-10 rounded-full object-cover sm:h-11 sm:w-11"
        />

        <div>
          <p className="font-medium text-app-text-primary">
            Dr. Ahmed Samir
          </p>
        </div>
      </div>
    </div>
  );
}
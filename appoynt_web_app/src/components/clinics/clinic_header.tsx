export default function ClinicHeader() {
    return (
    <div className="flex items-center justify-between mb-8">
      {/* Left Side */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">
          Clinics Management
        </h1>

        <p className="mt-1 text-gray-500">
          Manage your clinics, locations and consultation fees
        </p>
      </div>

      {/* Right Side */}
      <div className="flex items-center gap-3">
        <img
          src="/doctor.png"
          alt="Doctor"
          className="w-10 h-10 rounded-full object-cover"
        />

        <div>
          <p className="font-medium text-gray-900">
            Dr. Ahmed Samir
          </p>
        </div>
      </div>
    </div>
  );
}
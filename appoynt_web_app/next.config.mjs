/*
 * File Name: next.config.mjs
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: V1.1.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled, Shimaa Salah]
 * Last Modified Date: [Shimaa Salah - 30/08/2026]
 * File Description: Next.js configuration settings with API proxy rewrites to bypass CORS.
 */

// Declaring NextConfig object block configuration
const next_config = {
  // Configuring async rewrites to proxy API requests and resolve CORS in development
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: "http://appoynt.runasp.net/api/:path*",
      },
    ];
  },
};

// Exporting NextConfig block as default export module
export default next_config;

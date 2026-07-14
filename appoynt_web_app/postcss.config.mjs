/*
 * File Name: postcss.config.mjs
 * Author: Kholoud Khaled
 * Date of Creation: 17/06/2026
 * Version Information: V1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/07/2026]
 * File Description: PostCSS configuration settings for Appoynt Web App.
 */

// Declaring postcss_config object configuration
const postcss_config = {
  // Adding CSS processing plugins settings mapping
  plugins: {
    // Enable @tailwindcss/postcss processor
    "@tailwindcss/postcss": {},
  },
};

// Exporting postcss config block as default export module
export default postcss_config;

/*
 * File Name: app_assets.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: 1.0.0
 * Dependencies: None
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/06/2026]
 * File Description: Defines constants for image asset paths used in the Appoynt mobile application.
 */

// Centralized asset path class for managing static images and icons
class AppAssets {
  // Base directory path for all image asset files
  static const String _images_path = 'assets/images/';

  // Path to the solid color version of the Appoynt brand logo
  static const String appoynt_solid = '${_images_path}APPOYNT - SOLID.png';

  // Path to the Appoynt icon without background and text components
  static const String appoynt_icon_without_bt = '${_images_path}APPOYNT ICON-WITHOUT B&T.png';

  // Path to the standard Appoynt icon with background and details
  static const String appoynt_icon = '${_images_path}APPOYNT ICON.png';

  // Path to the primary brand logo design variant 01
  static const String appoynt_01 = '${_images_path}APPOYNT-01.png';

  // Path to the dark/black theme representation of the Appoynt logo
  static const String appoynt_black = '${_images_path}APPOYNT-BLACK.png';

  // Path to the light/white theme representation of the Appoynt logo
  static const String appoynt_white = '${_images_path}APPOYNT-WHITE.png';

  // Path to the Appoynt logo image file without background shadow or fill
  static const String appoynt_without_back = '${_images_path}APPOYNT-WITHOUT BACK.png';
}
// End of app_assets.dart

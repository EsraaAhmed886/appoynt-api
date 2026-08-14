/*
 * File Name: favorite_heart_button.dart
 * Author: Kholoud Khaled
 * Date of Creation: 14/08/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart, app_spacing.dart, app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 14/08/2026]
 * File Description: Unified reusable ECG Heart Pulse favorite button component
 *   shared across Doctors, Offers, and Clinics cards for 100% visual consistency.
 */

// Import standard Flutter material design widgets
import 'package:flutter/material.dart';
// Import layout design spacing tokens
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Import central theme color palette
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Local layout dimension constants to strictly eliminate magic numbers
class _LocalDimensions {
  // Default logical icon size (28.0 logical pixels)
  static const double default_icon_size = 28.0;
  // Default circular progress spinner size (20.0 logical pixels)
  static const double spinner_size = 20.0;
  // Circular progress indicator line thickness (2.0 logical pixels)
  static const double spinner_stroke = 2.0;
  // ECG pulse line stroke width (1.8 logical pixels)
  static const double ecg_stroke_width = 1.8;
  // ECG path coordinate scale ratios
  static const double scale_0_15 = 0.15;
  static const double scale_0_32 = 0.32;
  static const double scale_0_35 = 0.35;
  static const double scale_0_38 = 0.38;
  static const double scale_0_42 = 0.42;
  static const double scale_0_50 = 0.50;
  static const double scale_0_58 = 0.58;
  static const double scale_0_62 = 0.62;
  static const double scale_0_66 = 0.66;
  static const double scale_0_85 = 0.85;
}

// Reusable FavoriteHeartButton widget representation
class FavoriteHeartButton extends StatelessWidget {
  // Favorite state boolean flag
  final bool is_favorite;
  // Asynchronous removal loading status flag
  final bool is_removing;
  // Logical icon size dimension
  final double size;
  // Tap callback invocation
  final VoidCallback? on_tap;

  // Constant constructor mapping properties
  const FavoriteHeartButton({
    super.key,
    this.is_favorite = true,
    this.is_removing = false,
    this.size = _LocalDimensions.default_icon_size,
    this.on_tap,
  });

  @override
  // Build method constructing layered ECG heart button
  Widget build(BuildContext context) {
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return responsive InkWell wrapper
    return InkWell(
      // Disable tap while removal is in progress using Yoda condition
      onTap: true == is_removing ? null : on_tap,
      // Custom circular press boundary
      customBorder: const CircleBorder(),
      // Internal touch target padding
      child: Padding(
        // Padding using design tokens
        padding: const EdgeInsets.all(AppSpacing.space_s),
        // Switch between loading spinner and ECG heart stack
        child: true == is_removing
            ? const SizedBox(
                // Spinner width constraint
                width: _LocalDimensions.spinner_size,
                // Spinner height constraint
                height: _LocalDimensions.spinner_size,
                // Progress indicator widget
                child: CircularProgressIndicator(
                  // Line thickness
                  strokeWidth: _LocalDimensions.spinner_stroke,
                  // Brand primary indicator color
                  color: AppColors.primary_color,
                ),
              )

            : Stack(
                // Center ECG trace over base heart icon
                alignment: Alignment.center,
                // Children list
                children: [
                  // Base heart icon
                  Icon(
                    // Filled or outline heart based on state
                    true == is_favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    // Active red or inactive theme muted color
                    color: true == is_favorite
                        ? AppColors.dummy_custom_red
                        : (true == is_dark
                            ? AppColors.text_dark_secondary
                            : AppColors.text_light_secondary),
                    // Icon size constraint
                    size: size,
                  ),
                  // Overlay CustomPaint drawing the ECG pulse line trace
                  CustomPaint(
                    // Match size bounds with icon
                    size: Size(size, size),
                    // ECG pulse line painter
                    painter: EcgHeartLinePainter(
                      // White pulse line for filled heart, muted for outline
                      color: true == is_favorite
                          ? AppColors.white
                          : (true == is_dark
                              ? AppColors.text_dark_secondary
                              : AppColors.text_light_secondary),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Custom painter drawing the ECG pulse line trace across the middle of the heart icon
class EcgHeartLinePainter extends CustomPainter {
  // Line color matching active state
  final Color color;

  // Constructor mapping color parameter
  const EcgHeartLinePainter({
    required this.color,
  });

  @override
  // Draw the pulse line trace path on the canvas bounds
  void paint(Canvas canvas, Size size) {
    // ECG line paint styling properties configuration
    final paint = Paint()
      ..color = color
      ..strokeWidth = _LocalDimensions.ecg_stroke_width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Construct the zig-zag ECG path centered vertically
    final path = Path();
    final double w = size.width;
    final double h = size.height;

    // Flat line -> small dip -> medium peak -> deep dip -> small peak -> flat line
    path.moveTo(w * _LocalDimensions.scale_0_15, h * _LocalDimensions.scale_0_50);
    path.lineTo(w * _LocalDimensions.scale_0_35, h * _LocalDimensions.scale_0_50);
    path.lineTo(w * _LocalDimensions.scale_0_42, h * _LocalDimensions.scale_0_38);
    path.lineTo(w * _LocalDimensions.scale_0_50, h * _LocalDimensions.scale_0_62);
    path.lineTo(w * _LocalDimensions.scale_0_58, h * _LocalDimensions.scale_0_32);
    path.lineTo(w * _LocalDimensions.scale_0_66, h * _LocalDimensions.scale_0_50);
    path.lineTo(w * _LocalDimensions.scale_0_85, h * _LocalDimensions.scale_0_50);

    // Render path coordinates onto canvas using paint settings
    canvas.drawPath(path, paint);
  }

  @override
  // Prevent unnecessary repaints for static paint properties
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return false representation
    return false;
  }
}

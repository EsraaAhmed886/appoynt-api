/*
 * File Name: no_internet_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:appoynt_mobile_app/core/routing/route_export.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 28/05/2026]
 * File Description: A reusable global error screen displayed when the
 *   application detects a lack of internet connectivity.
 */

// Centralized barrel for UI dependencies
import 'package:appoynt_mobile_app/core/routing/route_export.dart';

/// A global screen widget for handling internet connection failures.
class NoInternetPage extends StatefulWidget {
  /// Callback executed when the user attempts to reconnect.
  final VoidCallback on_retry;

  /// Constructor requiring the retry callback.
  const NoInternetPage({super.key, required this.on_retry});

  @override
  State<NoInternetPage> createState() {
    return _NoInternetPageState();
  }
}

/// The state class for NoInternetPage managing animations and retry logic.
class _NoInternetPageState extends State<NoInternetPage>
    with SingleTickerProviderStateMixin {
  /// Controller for the pulsing effect of the WiFi illustration.
  late AnimationController _pulse_ctrl;
  
  /// Animation object defining the scale range of the pulse.
  late Animation<double> _pulse_anim;
  
  /// Flag tracking whether a retry attempt is currently in progress.
  bool _is_retrying = false;

  @override
  void initState() {
    super.initState();
    
    /// Initializing the pulse animation controller with a 1.4s duration.
    _pulse_ctrl = AnimationController(
      vsync: this, // Providing TickerProvider for smooth animation
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true); // Looping the animation back and forth

    /// Creating a subtle scale animation from 92% to 100%.
    _pulse_anim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulse_ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    /// Disposing the animation controller to prevent memory leaks.
    _pulse_ctrl.dispose();
    super.dispose(); // Final disposal
  }

  /// Handles the retry logic with a simulated network delay.
  Future<void> _handle_retry() async {
    /// Activating the loading state.
    setState(() {
      _is_retrying = true;
    });
    
    /// Simulating a network check delay.
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      /// Deactivating loading and triggering the external retry callback.
      setState(() {
        _is_retrying = false;
      });
      widget.on_retry();
    } else {
      // Do nothing since widget is no longer in tree
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Retrieving localized strings.
    final s = AppStrings.of(context);
    final bool is_arabic = s.is_arabic;
    
    /// Check if system brightness matches dark mode.
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    
    /// Dynamically resolved colors.
    final Color background_color = true == is_dark
        ? AppColors.background_dark
        : AppColors.onboarding_background;
    final Color text_primary = true == is_dark
        ? AppColors.text_dark_primary
        : AppColors.text_light_primary;
    final Color text_secondary = true == is_dark
        ? AppColors.text_dark_secondary
        : AppColors.text_light_secondary;

    return Scaffold(
      backgroundColor: background_color, // Applying theme background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32), // Content padding
          child: Column(
            children: [
              const Spacer(flex: 2), // Flexible top spacing

              /// Pulsing WiFi illustration drawn with CustomPaint.
              ScaleTransition(
                scale: _pulse_anim,
                child: CustomPaint(
                  size: const Size(220, 200), // Responsive size for the illustration
                  painter: _WifiPainter(), // Linking to the custom painter logic
                ),
              ),

              const SizedBox(height: 24), // Spacing before text

              /// Localized Title for the error state.
              Text(
                s.no_internet_title,
                textAlign: TextAlign.center,
                style: AppTextStyles.get_no_internet_title(context, is_arabic).copyWith(
                  color: text_primary, // Dynamic primary text color
                ),
              ),

              const SizedBox(height: 14), // Gap before subtitle

              /// Localized Subtitle with instructions.
              Text(
                s.no_internet_sub,
                textAlign: TextAlign.center,
                style: AppTextStyles.get_no_internet_subtitle(context, is_arabic).copyWith(
                  color: text_secondary, // Dynamic secondary text color
                ),
              ),

              const Spacer(flex: 3), // Pushing the button to the bottom area

              /// The primary retry action button.
              SizedBox(
                width: double.infinity,
                height: 56, // Standard accessible height
                child: ElevatedButton(
                  /// Disabling button interaction when retrying.
                  onPressed: _is_retrying ? null : _handle_retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary_color, // Brand primary color
                    /// Semi-transparent color when disabled.
                    disabledBackgroundColor: AppColors.primary_color.withValues(alpha: 0.6),
                    elevation: 0, // Flat design
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Stylized corners
                    ),
                  ),
                  /// Displaying either a progress spinner or localized text.
                  child: true == _is_retrying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white, // Standard white spinner
                          ),
                        )
                      : Text(
                          s.retry,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white, // High contrast text
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32), // Bottom safe margin
            ],
          ),
        ),
      ),
    );
  }
}

/// A specialized CustomPainter to render the WiFi signal icon.
class _WifiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// Defining the core paint style for the arcs.
    final Paint paint = Paint()
      ..color = AppColors.primary_color // Using brand primary color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round // Rounded line ends
      ..strokeJoin = StrokeJoin.round;

    /// Calculating the anchor point for the illustration.
    final double cx = size.width / 2;
    final double cy = size.height * 0.62;

    // ── Dot (Signal Origin) ──────────────────────────────
    final Paint dot_paint = Paint()
      ..color = AppColors.primary_color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 18, dot_paint);

    // ── 3 Concentric Arcs (Signal waves) ──────────────────
    final List<_ArcData> arcs = [
      const _ArcData(radius: 95, stroke_width: 22), // Inner wave
      const _ArcData(radius: 148, stroke_width: 22), // Middle wave
      const _ArcData(radius: 200, stroke_width: 22), // Outer wave
    ];

    /// Defining the angles for the signal arc (top-centered segment).
    const double start_angle = 3.14159 * 1.2;
    const double sweep_angle = 3.14159 * 0.6;

    for (final _ArcData arc in arcs) {
      /// Setting thickness for the current arc.
      paint.strokeWidth = arc.stroke_width.toDouble();
      /// Creating the bounding box for the arc.
      final Rect rect = Rect.fromCenter(
        center: Offset(cx, cy),
        width: arc.radius * 2,
        height: arc.radius * 2,
      );
      /// Drawing the arc onto the canvas.
      canvas.drawArc(rect, start_angle, sweep_angle, false, paint);
    }
  }

  @override
  /// Optimization: No need to repaint as the pulse is handled by a ScaleTransition wrapper.
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/// Internal helper class to store arc geometry data.
class _ArcData {
  final int radius;
  final int stroke_width;
  const _ArcData({required this.radius, required this.stroke_width});
}

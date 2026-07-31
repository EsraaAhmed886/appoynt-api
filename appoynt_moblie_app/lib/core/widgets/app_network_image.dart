/*
 * File Name: app_network_image.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/07/2026
 * Version Information: V1.0.0
 * Dependencies: flutter/material.dart, app_colors.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 19/07/2026]
 * File Description: Memory-optimized network image widget with fade transitions, shimmers, and fallbacks.
 */

// Import standard UI framework
import 'package:flutter/material.dart';
// Import central color palette tokens
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';

// Public generic optimized network image component
class AppNetworkImage extends StatelessWidget {
  // Image endpoint URL address
  final String image_url;
  // Bounded width layout dimension
  final double width;
  // Bounded height layout dimension
  final double height;
  // Bounded outer corners rounded radius
  final double border_radius;
  // Optional downscale decode width limit
  final int? cache_width;
  // Optional downscale decode height limit
  final int? cache_height;
  // Fallback vector icon representation
  final IconData fallback_icon;

  // Constant constructor initializing custom configurations parameters
  const AppNetworkImage({
    super.key,
    required this.image_url,
    required this.width,
    required this.height,
    required this.border_radius,
    this.cache_width,
    this.cache_height,
    this.fallback_icon = Icons.person_rounded,
  });

  @override
  // Render visual bounding tree mapping state status
  Widget build(BuildContext context) {
    // Resolve theme brightness modes context
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return container applying outer border highlights to satisfy visual alignment specs
    return Container(
      // Set outer boundary width limit
      width: width,
      // Set outer boundary height limit
      height: height,
      // Design decoration configurations mapping borders and corners shape
      decoration: BoxDecoration(
        // Shape matching border radius configuration
        borderRadius: BorderRadius.circular(border_radius),
        // Subtle gray border outline matching the mockup
        border: Border.all(
          // Slate gray border color adapting dynamically to theme modes using AppColors tokens
          color: true == is_dark ? AppColors.avatar_border_dark : AppColors.avatar_border_light,
          // Set thickness to 2.0 pixels to match screenshot spec
          width: 2.0,
        ),
      ),
      // Clip child inside rounded corners to avoid content bleeding over borders
      child: ClipRRect(
        // Bind corner radius subtracting border thickness to align layout curves
        borderRadius: BorderRadius.circular(border_radius > 2.0 ? border_radius - 2.0 : border_radius),
        // Bounded box matching specified layout limits
        child: SizedBox(
          // Set layout width
          width: width,
          // Set layout height
          height: height,
          // Render network image loader
          child: Image.network(
            // Load image endpoint URL
            image_url,
            // Crop and fill boundary coordinates
            fit: BoxFit.cover,
            // Set image cache width constraint
            cacheWidth: cache_width,
            // Set image cache height constraint
            cacheHeight: cache_height,
            // Fade-in frame builder preventing layout shift spikes
            frameBuilder: (context, child, frame, was_synchronously_loaded) {
              // Check if image is already loaded synchronously (Yoda comparison)
              if (true == was_synchronously_loaded) {
                // Return image widget immediately without animation
                return child;
              } else {
                // Return AnimatedOpacity transition fading in the image
                return AnimatedOpacity(
                  // Set visible opacity if frame decodes (Yoda comparison)
                  opacity: null == frame ? 0.0 : 1.0,
                  // Transition speed duration (300ms)
                  duration: const Duration(milliseconds: 300),
                  // Smooth ease out curve layout
                  curve: Curves.easeOut,
                  // Enclose child layout
                  child: child,
                );
              }
            },
            // Loading progress indicator callback returning animated pulse placeholders
            loadingBuilder: (context, child, loading_progress) {
              // Check if image bytes download completes (Yoda comparison)
              if (null == loading_progress) {
                // Display successfully loaded child image
                return child;
              } else {
                // Display custom pulsing shimmer placeholder
                return _PulsePlaceholder(
                  // Match widget width
                  width: width,
                  // Match widget height
                  height: height,
                  // Match widget border radius subtracting border thickness
                  border_radius: border_radius > 2.0 ? border_radius - 2.0 : border_radius,
                );
              }
            },
            // Recover gracefully from loading failures (network offline or broken URL)
            errorBuilder: (context, error, stack_trace) {
              // Return container representing fallback layout
              return Container(
                // Match width layout boundary
                width: width,
                // Match height layout boundary
                height: height,
                // Card decorations style mappings
                decoration: BoxDecoration(
                  // Pulsing color matching background skeletons
                  color: true == is_dark ? AppColors.surface_dark : AppColors.search_chip_bg,
                  // Rounded corners borders representation subtracting border thickness
                  borderRadius: BorderRadius.circular(border_radius > 2.0 ? border_radius - 2.0 : border_radius),
                ),
                // Draw fallback vector icon inside center coordinates
                child: Center(
                  // Default fallback profile icon
                  child: Icon(
                    // Set fallback icon
                    fallback_icon,
                    // Scale icon size relative to box height
                    size: height / 2.0,
                    // Muted color matching secondary labels text
                    color: AppColors.text_light_secondary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Stateful widget to manage pulsing skeleton animation
class _PulsePlaceholder extends StatefulWidget {
  // Width dimension representation
  final double width;
  // Height dimension representation
  final double height;
  // Bounding corner radius config
  final double border_radius;

  // Constant constructor initializing properties
  const _PulsePlaceholder({
    required this.width,
    required this.height,
    required this.border_radius,
  });

  @override
  // Create state instance
  State<_PulsePlaceholder> createState() {
    // Return state class representation
    return _PulsePlaceholderState();
  }
}

// State class managing animation controller for the pulsing effect
class _PulsePlaceholderState extends State<_PulsePlaceholder>
    with SingleTickerProviderStateMixin {
  // Animation controller orchestrating timing loop
  late final AnimationController _controller;
  // Animation driving double opacity values
  late final Animation<double> _opacity_animation;

  @override
  // Initialize animation state variables
  void initState() {
    // Invoke parent initialization
    super.initState();
    // Instantiate animation controller with 1 second repeat duration
    _controller = AnimationController(
      // Bind state context ticker provider
      vsync: this,
      // Loop duration setting
      duration: const Duration(milliseconds: 1000),
    );

    // Setup linear tween animating opacity values
    _opacity_animation = Tween<double>(
      // Lower bound opacity
      begin: 0.3,
      // Upper bound opacity
      end: 0.8,
    ).animate(
      // Curve wrapping controller execution
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Run animation continuously in a reverse loop
    _controller.repeat(reverse: true);
  }

  @override
  // Dispose animation resource safely
  void dispose() {
    // Dispose ticker animation controller
    _controller.dispose();
    // Invoke parent resource hygiene cleanup
    super.dispose();
  }

  @override
  // Draw pulsing container box matching theme configs
  Widget build(BuildContext context) {
    // Resolve theme brightness modes context
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    // Return FadeTransition driving widget opacity
    return FadeTransition(
      // Bind opacity animation tween
      opacity: _opacity_animation,
      // Draw static container shape
      child: Container(
        // Constrain width boundary
        width: widget.width,
        // Constrain height boundary
        height: widget.height,
        // Card styling configurations options representation
        decoration: BoxDecoration(
          // Pulsing color matching background skeletons
          color: true == is_dark ? AppColors.surface_dark : AppColors.search_chip_bg,
          // Rounded corners borders representation
          borderRadius: BorderRadius.circular(widget.border_radius),
        ),
      ),
    );
  }
}

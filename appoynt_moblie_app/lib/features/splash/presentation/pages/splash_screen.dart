/*
 * File Name: splash_screen.dart
 * Author: Kholoud Khaled
 * Date of Creation: 19/06/2026
 * Version Information: V1.2.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:flutter_bloc/flutter_bloc.dart
 *   - package:appoynt_mobile_app/features/splash/presentation/cubit/splash_cubit.dart
 *   - package:appoynt_mobile_app/main.dart
 *   - package:appoynt_mobile_app/features/auth/presentation/pages/register_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description: Presentation page for the splash screen displaying animated Appoynt brand logo with a shiny sweep.
 */

// Importing central presentation and UI barrel exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing flutter bloc package for state management listeners
import 'package:flutter_bloc/flutter_bloc.dart';
// Importing splash screen state management cubit
import 'package:appoynt_mobile_app/features/splash/presentation/cubit/splash_cubit.dart';
// Importing onboarding screen to route to after splash completes
import 'package:appoynt_mobile_app/features/onboarding/presentation/pages/onboarding_page.dart';
// Importing login screen page widget representation
import 'package:appoynt_mobile_app/features/auth/presentation/pages/login_page.dart';
// Importing registration screen page widget representation
import 'package:appoynt_mobile_app/features/auth/presentation/pages/register_page.dart';
// Importing OTP verification screen page widget representation
import 'package:appoynt_mobile_app/features/auth/presentation/pages/otp_page.dart';

// Stateful widget representing the initial landing splash screen
class SplashScreen extends StatefulWidget {
  // Constructor initializing the widget key
  const SplashScreen({super.key});

  // Create state function returning the splash screen state
  @override
  State<SplashScreen> createState() {
    // Return state instance for the splash screen
    return _SplashScreenState();
  }
}

// State class for SplashScreen widget with ticker providers for logo and sheen animations
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Animation controller to drive the logo entrance transitions
  late AnimationController _entrance_controller;

  // Animation controller to drive the sheen sweep transition overlay
  late AnimationController _sheen_controller;

  // Fade animation to animate logo opacity from invisible to fully visible
  late Animation<double> _fade_animation;

  // Scale animation to gently scale up the brand logo during entrance
  late Animation<double> _scale_animation;

  // Linear animation value mapping for the sheen sweep progress stops
  late Animation<double> _sheen_animation;

  // Initialize state method setting up animations
  @override
  void initState() {
    // Invoke parent class initializer logic
    super.initState();

    // Instantiate animation controller for entrance with defined splash duration
    _entrance_controller = AnimationController(
      // Bind vertical sync to this state class ticker provider
      vsync: this,
      // Retrieve animation duration from central spacing definitions
      duration: const Duration(
        // Set duration in milliseconds
        milliseconds: AppSpacing.duration_splash_animation_ms,
      ),
    );

    // Instantiate animation controller for sheen sweep effect
    _sheen_controller = AnimationController(
      // Bind vertical sync to this state class ticker provider
      vsync: this,
      // Set duration of sheen animation sweep in milliseconds
      duration: const Duration(
        // Set sheen animation sweep duration in milliseconds
        milliseconds: AppSpacing.duration_sheen_sweep_ms,
      ),
    );

    // Define fade animation path using curved opacity scale
    _fade_animation = Tween<double>(
      // Initial value representing fully transparent logo
      begin: AppSpacing.opacity_none,
      // Target value representing fully visible opaque logo
      end: AppSpacing.opacity_full,
    ).animate(
      // Configure animation easing curve
      CurvedAnimation(
        // Set animation controller dependency
        parent: _entrance_controller,
        // Set ease-in curve transition behavior
        curve: Curves.easeIn,
      ),
    );

    // Define scale animation path using an elegant ease-out back curve
    _scale_animation = Tween<double>(
      // Start logo size at sixty percent of regular scale for more dramatic entry
      begin: 0.6,
      // End logo size at normal scale constraint
      end: 1.0,
    ).animate(
      // Configure animation easing curve
      CurvedAnimation(
        // Set animation controller dependency
        parent: _entrance_controller,
        // Set ease-out back curve for a playful elastic feel
        curve: Curves.easeOutBack,
      ),
    );

    // Define sheen animation sweep path mapping from left/top to right/bottom
    _sheen_animation = Tween<double>(
      // Start animation value completely offset to the top-left
      begin: -2.0,
      // End animation value completely offset to the bottom-right
      end: 2.0,
    ).animate(
      // Configure animation easing curve for uniform sheen pass
      CurvedAnimation(
        // Set animation controller dependency
        parent: _sheen_controller,
        // Linear curve transition behavior for smooth sweeping pace
        curve: Curves.easeInOut,
      ),
    );

    // Start running the logo entrance animations forwards
    _entrance_controller.forward().then((value) {
      // Check if state is mounted before starting sheen sweep using Yoda style comparison
      if (true == mounted) {
        // Start the sheen sweep animation once the entrance animation settles
        _sheen_controller.forward();
      }
      // Else block to handle the case where widget is unmounted after animation
      else {
        // Do nothing since screen is no longer active
      }
    });
  }

  // Helper method to navigate to the onboarding screen of the application
  void _navigate_to_onboarding() {
    // Check if the state object remains active in widget tree using Yoda comparison
    if (true == mounted) {
      // Transition by replacing splash page with onboarding page
      Navigator.of(context).pushReplacement(
        // Define page route with cross-fade transition behavior
        PageRouteBuilder(
          // Set target page to OnboardingPage instance
          pageBuilder: (context, animation, secondary_animation) {
            // Return onboarding page layout widget
            return OnboardingPage(
              // Define callback triggered when onboarding completes
              on_done: () {
                // Check if the active route context remains active in widget tree using Yoda comparison
                if (true == context.mounted) {
                  // Transition to the login page using cross-fade route builder
                  Navigator.of(context).pushReplacement(
                    // Define page route with cross-fade transition behavior
                    PageRouteBuilder(
                      // Set target page to LoginPage instance
                      pageBuilder: (context, anim, secAnim) {
                        // Return root login gateway page widget
                        return LoginPage(
                          // Set success redirect callback
                          on_login_success: () {
                            // Print dynamic logs
                            debugPrint('User logged in successfully');
                          },
                          // Set register redirect callback
                          on_go_to_register: () {
                            // Check if context remains active in widget tree using Yoda comparison
                            if (true == context.mounted) {
                              // Push RegisterPage onto navigation stack
                              Navigator.of(context).push(
                                // Create fade transition route builder
                                PageRouteBuilder(
                                  // Set target page to RegisterPage instance
                                  pageBuilder: (context, anim, secAnim) {
                                    // Return register page layout
                                    return RegisterPage(
                                       // Callback to navigate to OTP page, passing phone number
                                       on_go_to_otp: (phone) {
                                         // Check if context remains active in widget tree using Yoda comparison
                                         if (true == context.mounted) {
                                           // Push OtpPage onto navigation stack
                                           Navigator.of(context).push(
                                             // Create fade transition route builder
                                             PageRouteBuilder(
                                               // Set target page to OtpPage instance
                                               pageBuilder: (context, anim, secAnim) {
                                                 // Return OTP verification page layout
                                                 return OtpPage(
                                                   phone: phone,
                                                   // Callback when OTP verification succeeds
                                                   on_verified: () {
                                                     // Print log for verification
                                                     debugPrint('OTP verified successfully!');
                                                     // Pop back to the initial login screen
                                                     Navigator.of(context).popUntil((route) => route.isFirst);
                                                   },
                                                   // Callback to pop OTP screen
                                                   on_back: () {
                                                     // Pop the OTP screen from route stack
                                                     Navigator.of(context).pop();
                                                   },
                                                   // Callback to toggle language
                                                   on_toggle_language: () {
                                                     // Call global cubit toggle language logic
                                                     context.read<GlobalCubit>().toggle_language();
                                                   },
                                                 );
                                               },
                                               // Build transition animations
                                               transitionsBuilder: (context, anim, secAnim, child) {
                                                 // Return cross-fade transition representation
                                                 return FadeTransition(
                                                   // Bind anim properties
                                                   opacity: anim,
                                                   // child representation
                                                   child: child,
                                                 );
                                               },
                                               // Set standard cross-fade transition duration from spacing constants
                                               transitionDuration: const Duration(milliseconds: AppSpacing.duration_fade_ms),
                                             ),
                                           );
                                         } else {
                                           // Empty action block to satisfy compiler
                                         }
                                       },
                                      // Callback to return back to Login
                                      on_go_to_login: () {
                                        // Pop the registration screen from route stack
                                        Navigator.of(context).pop();
                                      },
                                      // Callback to toggle language
                                      on_toggle_language: () {
                                        // Call global cubit toggle language logic
                                        context.read<GlobalCubit>().toggle_language();
                                      },
                                    );
                                  },
                                  // Build transition animations
                                  transitionsBuilder: (context, anim, secAnim, child) {
                                    // Return cross-fade transition representation
                                    return FadeTransition(
                                      // Bind anim properties
                                      opacity: anim,
                                      // child representation
                                      child: child,
                                    );
                                  },
                                  // Set standard cross-fade transition duration from spacing constants
                                  transitionDuration: const Duration(milliseconds: AppSpacing.duration_fade_ms),
                                ),
                              );
                            } else {
                              // Empty action block to satisfy compiler
                            }
                          },
                          // Set forgot password redirect callback
                          on_forgot_password: () {
                            // Print dynamic logs
                            debugPrint('User clicked forgot password');
                          },
                          // Set language toggle selection callback
                          on_toggle_language: () {
                            // Call global cubit toggle language logic
                            context.read<GlobalCubit>().toggle_language();
                          },
                        );
                      },
                      // Build custom transition animation logic
                      transitionsBuilder: (context, anim, secAnim, child) {
                        // Return fade transition widget mapping logic
                        return FadeTransition(
                          // Bind transition opacity to route animation progress
                          opacity: anim,
                          // Return child route widget tree
                          child: child,
                        );
                      },
                      // Retrieve transition duration constant from app spacing definition
                      transitionDuration: const Duration(
                        // Set transition duration in milliseconds
                        milliseconds: AppSpacing.duration_fade_ms,
                      ),
                    ),
                  );
                }
                // Else block to ensure explicit control flow paths are handled
                else {
                  // Do nothing since widget is unmounted from the tree
                }
              },
            );
          },
          // Build custom transition animation logic
          transitionsBuilder: (context, animation, secondary_animation, child) {
            // Return fade transition widget mapping logic
            return FadeTransition(
              // Bind transition opacity to route animation progress
              opacity: animation,
              // Return child route widget tree
              child: child,
            );
          },
          // Retrieve transition duration constant from app spacing definition
          transitionDuration: const Duration(
            // Set transition duration in milliseconds
            milliseconds: AppSpacing.duration_fade_ms,
          ),
        ),
      );
    }
    // Else block to ensure explicit control flow paths are handled
    else {
      // Do nothing since widget is unmounted from the tree
    }
  }

  // Dispose method releasing animation controllers
  @override
  void dispose() {
    // Dispose and release the entrance animation controller resources
    _entrance_controller.dispose();

    // Dispose and release the sheen animation controller resources
    _sheen_controller.dispose();

    // Invoke parent class dispose logic
    super.dispose();
  }

  // Build method rendering the splash screen UI elements
  @override
  Widget build(BuildContext context) {
    // Retrieve the transparent Appoynt logo path constant directly
    const String resolved_logo_asset = AppAssets.appoynt_without_back;

    // Return BlocProvider supplying the SplashCubit state to widget tree
    return BlocProvider<SplashCubit>(
      // Create and trigger the startup flow inside SplashCubit
      create: (context) {
        // Return Cubit instance and trigger the app initialization sequence
        return SplashCubit()..app_started();
      },
      // Bind listener widget to intercept state changes
      child: BlocListener<SplashCubit, SplashState>(
        // Callback function triggered when cubit emits a new state
        listener: (context, state) {
          // Check if state is SplashDone indicating delay complete using Yoda style comparison
          if (state is SplashDone) {
            // Trigger transition routing to the onboarding screen
            _navigate_to_onboarding();
          }
          // Else block representing other state emissions
          else {
            // Do nothing since the initialization flow is still running
          }
        },
        // Root scaffold layout widget containing visual logo layers
        child: Scaffold(
          // Center column layout containing logo container
          body: Center(
            // Scale transition animated builder widget wrapping the logo child
            child: ScaleTransition(
              // Bind scale property factor to active scale animation
              scale: _scale_animation,
              // Fade transition animated builder widget wrapping the scale transition
              child: FadeTransition(
                // Bind opacity property factor to active fade animation
                opacity: _fade_animation,
                // Centered visual logo image wrapper container
                child: Container(
                  // Set logo container height constraint from constants
                  height: AppSpacing.size_logo_box,
                  // Set logo container width constraint from constants
                  width: AppSpacing.size_logo_box,
                  // Apply brand logo image alignment styling
                  alignment: Alignment.center,
                  // Inner padding spacing configuration around the logo image
                  padding: const EdgeInsets.all(
                    // Retrieve tiny padding size from central spacing tokens
                    AppSpacing.padding_logo_tiny,
                  ),
                  // Stack layout to place the sheen effect layer exactly above the base image
                  child: AnimatedBuilder(
                    // Bind rebuild updates to the sheen animation changes
                    animation: _sheen_animation,
                    // Builder method returning the stacked images
                    builder: (context, child) {
                      // Return Stack containing the base logo and sheen mask overlay
                      return Stack(
                        // Fit constraints to match the container dimensions
                        fit: StackFit.expand,
                        // Child elements list of stack layout
                        children: [
                          // Base logo layer showing original colors
                          Image.asset(
                            // Bind asset image file path
                            resolved_logo_asset,
                            // Contain image scaling within bounds cleanly
                            fit: BoxFit.contain,
                          ),
                          // Sheen sweep highlight overlay mask
                          ShaderMask(
                            // Replace mask colors but preserve the alpha transparency channel
                            blendMode: BlendMode.srcIn,
                            // Shader callback creating the linear gradient light sweep
                            shaderCallback: (bounds) {
                               // Return linear gradient creating the bright sheen sweep highlight
                               return LinearGradient(
                                 // Shift begin alignment dynamically to control sheen starting offset
                                 begin: Alignment(
                                   // Offset horizontal coordinate using animation value
                                   _sheen_animation.value - 1.5,
                                   // Offset vertical coordinate using animation value
                                   _sheen_animation.value - 1.5,
                                 ),
                                 // Shift end alignment dynamically to control sheen ending offset
                                 end: Alignment(
                                   // Offset horizontal coordinate using animation value
                                   _sheen_animation.value,
                                   // Offset vertical coordinate using animation value
                                   _sheen_animation.value,
                                 ),
                                 // Bright white highlight color list representing light sheen (with increased opacity)
                                 colors: const [
                                   Colors.transparent,
                                   Colors.white30,
                                   Colors.white,
                                   Colors.white30,
                                   Colors.transparent,
                                 ],
                                 // Fixed stops within standard range to prevent out of bounds assertion errors
                                 stops: const [
                                   0.0,
                                   0.35,
                                   0.5,
                                   0.65,
                                   1.0,
                                 ],
                               ).createShader(bounds);
                            },
                            // Image child defining the target shape boundaries of the mask
                            child: Image.asset(
                              // Bind same asset image file path
                              resolved_logo_asset,
                              // Contain image scaling within bounds cleanly
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// End of splash_screen.dart

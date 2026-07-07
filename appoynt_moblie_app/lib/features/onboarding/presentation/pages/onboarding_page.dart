/*
 * File Name: onboarding_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 20/06/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:appoynt_mobile_app/core/routing/route_export.dart
 *   - package:appoynt_mobile_app/features/onboarding/presentation/cubit/onboarding_cubit.dart
 *   - package:appoynt_mobile_app/features/onboarding/presentation/widgets/dot_indicator.dart
 *   - package:flutter_bloc/flutter_bloc.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 20/06/2026]
 * File Description: Renders the onboarding page screen flow, handling transitions and multilingual layouts.
 */

// Importing central UI and route exports barrel file
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing cubit state manager file for page changes
import 'package:appoynt_mobile_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
// Importing dot indicator widgets for active slides
import 'package:appoynt_mobile_app/features/onboarding/presentation/widgets/dot_indicator.dart';
// Importing flutter bloc package for state management
import 'package:flutter_bloc/flutter_bloc.dart';

// Stateful widget class representing onboarding flow
class OnboardingPage extends StatefulWidget {
  // Callback function property triggered on onboarding completion
  final VoidCallback on_done;

  // Constructor mapping the completion callback and key parameters
  const OnboardingPage({super.key, required this.on_done});

  // Create state method producing the state controller instance
  @override
  State<OnboardingPage> createState() {
    // Return state class instance
    return _OnboardingPageState();
  }
}

// State class managing animations and layout configurations
class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  // Controller managing horizontal page swiping
  final PageController _page_controller = PageController();

  // Controller managing logo or illustration entrance scaling pop
  late AnimationController _illustration_controller;

  // Animation mapping the scaling path for slides
  late Animation<double> _illustration_animation;

  // List holding the static asset paths for the onboarding images
  final List<String> _images = const [
    // Asset path token referencing onboarding slide one image
    AppAssets.onboarding_1_light,
    // Asset path token referencing onboarding slide two image
    AppAssets.onboarding_2_light,
    // Asset path token referencing onboarding slide three image
    AppAssets.onboarding_3_light,
  ];

  // Initialize state method launching layout controllers
  @override
  void initState() {
    // Invoke parent widget class initialization logic
    super.initState();

    // Create animation controller running the scaling transitions
    _illustration_controller = AnimationController(
      // Set ticker provider sync dependency
      vsync: this,
      // Set duration utilizing central spacing constants
      duration: const Duration(
        // Set duration in milliseconds
        milliseconds: AppSpacing.duration_illustration_pop_ms,
      ),
    );

    // Create curve mapping with ease-out elasticity path
    _illustration_animation = CurvedAnimation(
      // Set animation parent controller
      parent: _illustration_controller,
      // Apply elastic backing transition curve
      curve: Curves.easeOutBack,
    );

    // Start running the scale animation sequence forward
    _illustration_controller.forward();
  }

  // Helper method resetting and re-running slide animations
  void _animate_illustration() {
    // Reset illustration controller values to zero
    _illustration_controller.reset();
    // Play scale transitions forward
    _illustration_controller.forward();
  }

  // Dispose method releasing controller resources to avoid memory leaks
  @override
  void dispose() {
    // Dispose the page view swiping controller resources
    _page_controller.dispose();
    // Dispose the illustration animation controller resources
    _illustration_controller.dispose();
    // Invoke parent class dispose logic
    super.dispose();
  }

  // Build method drawing the layout layers
  @override
  Widget build(BuildContext context) {
    // Look up and load active localizations dictionary configurations
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Bind boolean value checking if active system language direction is Arabic
    final bool is_arabic = localizations.is_arabic;

    // Return BlocProvider setup wrapping the onboarding screen widgets
    return BlocProvider<OnboardingCubit>(
      // Create and initialize new cubit instance
      create: (context) {
        // Return initialized cubit state tracker
        return OnboardingCubit();
      },
      // Bind consumer widget to intercept state changes
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        // Listener callback tracking completions or redirects
        listener: (context, state) {
          // Check if emitted state is completed type
          if (state is OnboardingCompleted) {
            // Trigger onboarding finish navigation callback
            widget.on_done();
          }
          // Else block representing other unhandled state events
          else {
            // Do nothing since state is not completed
          }
        },
        // Builder rendering UI components based on active indices
        builder: (context, state) {
          // Declare index pointer tracker initialized to zero
          int current_page = 0;
          // Check if emitted state maps index updates
          if (state is OnboardingPageUpdate) {
            // Update page index pointer from state parameters
            current_page = state.page_index;
          }
          // Else block representing other state update fallbacks
          else {
            // Keep default zero index value
          }
          // Bind boolean checking if active screen represents the final slide index
          final bool is_last = (_images.length - 1) == current_page;

          // Bind boolean checking active brightness mode
          final bool is_dark = Theme.of(context).brightness == Brightness.dark;

          // Return scaffold container hosting the sliding screen layout
          return Scaffold(
            // Apply customized background color token adapting to theme mode
            backgroundColor: true == is_dark
                // Dark background color
                ? AppColors.background_dark
                // Light background color
                : AppColors.onboarding_background,
            // Wrap contents in safe area layout to prevent notch overlaps
            body: SafeArea(
              // Wrap contents in stack to layer floaters above slider
              child: Stack(
                // Position children layered on top of each other
                children: [
                  // PageView builder creating responsive slider content
                  PageView.builder(
                    // Bind horizontal page view controller
                    controller: _page_controller,
                    // Define event callback when slide changes
                    onPageChanged: (int index) {
                      // Trigger page changed method in onboarding cubit
                      context.read<OnboardingCubit>().page_changed(index);
                      // Trigger entry animation pop for new slide illustration
                      _animate_illustration();
                    },
                    // Specify total slide count
                    itemCount: _images.length,
                    // Builder producing slide index layout trees
                    itemBuilder: (context, index) {
                      // Return column structuring vertical visual nodes
                      return Column(
                        // Contain children widgets inside list
                        children: [
                          // Top vertical spacer margin
                          const SizedBox(
                            // Set space height from central constants
                            height: AppSpacing.spacing_onboarding_top,
                          ),
                          // Expanded container nesting illustration layout
                          Expanded(
                            // Allocate layout weight ratio
                            flex: 5,
                            // Scale transition wrapping the illustration image
                            child: ScaleTransition(
                              // Bind scale path to illustration animation
                              scale: _illustration_animation,
                              // Padding enclosing the illustration image bounds
                              child: Padding(
                                // Symmetric padding configurations
                                padding: const EdgeInsets.symmetric(
                                  // Set horizontal padding
                                  horizontal: AppSpacing.space_xxxl,
                                  // Set vertical padding
                                  vertical: AppSpacing.space_xl,
                                ),
                                // Render illustration asset image
                                child: Image.asset(
                                  // Load active image path from string list dynamically based on dark mode status
                                  AppAssets.get_onboarding_asset(index, is_dark),
                                  // Maintain image scaling ratio
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          // Padding widget surrounding indicator dots row
                          Padding(
                            // Set custom spacing margins
                            padding: const EdgeInsets.only(
                              // Set top padding space
                              top: AppSpacing.space_l,
                              // Set bottom padding space
                              bottom: AppSpacing.spacing_dot_bottom,
                            ),
                            // Row containing indicator dots
                            child: Row(
                              // Center elements horizontally
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Generate child indicators list
                              children: List.generate(
                                // Total number of slide indicators
                                _images.length,
                                // Generator callback setting active status
                                (i) {
                                  // Return indicator widget mapping index equality
                                  return DotIndicator(
                                    // Highlight indicator if indices match
                                    active: i == current_page,
                                  );
                                },
                              ),
                            ),
                          ),
                          // Expanded container holding localized text description
                          Expanded(
                            // Allocate layout weight ratio
                            flex: 3,
                            // Padding widget surrounding text elements
                            child: Padding(
                              // Set horizontal padding margins
                              padding: const EdgeInsets.symmetric(
                                // Set horizontal margins from spacing token
                                horizontal: AppSpacing.padding_onboarding_content,
                              ),
                              // Column widget nesting titles and subtitles
                              child: Column(
                                // Align text layouts to start from top
                                mainAxisAlignment: MainAxisAlignment.start,
                                // Children list containing title elements
                                children: [
                                  // RichText widget for styling title highlights differently
                                  RichText(
                                    // Center text block horizontally
                                    textAlign: TextAlign.center,
                                    // TextSpan node hosting children spans
                                    text: TextSpan(
                                      // Pull default typographic styling configuration
                                      style: AppTextStyles.get_onboarding_title(
                                        // Pass context dependency
                                        context,
                                        // Pass language direction flag
                                        is_arabic,
                                      ),
                                      // Children list of inline text spans
                                      children: [
                                        // Normal title prefix text span
                                        TextSpan(
                                          // Set text string from localizations list
                                          text: localizations.onboarding_titles_prefix[index],
                                        ),
                                        // Accent highlighted title keyword text span
                                        TextSpan(
                                          // Set text string from localizations list
                                          text: localizations.onboarding_titles_accent[index],
                                          // Apply accent primary color token styling
                                          style: const TextStyle(
                                            // Set text color to primary brand color
                                            color: AppColors.primary_color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Height spacer separating title block from description text
                                  const SizedBox(
                                    // Set height spacer value from spacing token
                                    height: AppSpacing.spacing_title_subtitle,
                                  ),
                                  // Text widget rendering descriptive subtitles
                                  Text(
                                    // Set text string from localizations list
                                    localizations.onboarding_subtitles[index],
                                    // Center subtitle text block horizontally
                                    textAlign: TextAlign.center,
                                    // Pull typographic subtitle styling configuration
                                    style: AppTextStyles.get_onboarding_subtitle(
                                      // Pass context dependency
                                      context,
                                      // Pass language direction flag
                                      is_arabic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacing margin height reserved at page bottom
                          const SizedBox(
                            // Set height spacing constraint from constants
                            height: AppSpacing.spacing_bottom_reserve,
                          ),
                        ],
                      );
                    },
                  ),
                  // Positioned widget placement containing Skip action button
                  Positioned(
                    // Set top constraint edge offset
                    top: AppSpacing.space_l,
                    // Check if direction is Arabic using Yoda style comparison
                    left: true == is_arabic
                        // Position button on left side for Arabic
                        ? AppSpacing.offset_skip_button
                        // Disable left constraint for English
                        : null,
                    // Check if direction is Arabic using Yoda style comparison
                    right: true == is_arabic
                        // Disable right constraint for Arabic
                        ? null
                        // Position button on right side for English
                        : AppSpacing.offset_skip_button,
                    // Animated opacity container to hide skip button on final page
                    child: AnimatedOpacity(
                      // Check if last slide is active to set transparent opacity
                      opacity: true == is_last
                          // Hide button on final slide
                          ? AppSpacing.opacity_none
                          // Show button on other slides
                          : AppSpacing.opacity_full,
                      // Define fading transition length
                      duration: const Duration(
                        // Set transition duration in milliseconds
                        milliseconds: AppSpacing.duration_onboarding_fade_ms,
                      ),
                      // IgnorePointer widget preventing hits when hidden
                      child: IgnorePointer(
                        // Disable button interactions if screen represents final slide
                        ignoring: is_last,
                        // TextButton widget wrapping skip action
                        child: TextButton(
                          // Set tap callback function
                          onPressed: () {
                            // Trigger onboarding completion in cubit state manager
                            context.read<OnboardingCubit>().onboarding_completed();
                          },
                          // Button style properties
                          style: TextButton.styleFrom(
                            // Symmetric internal padding configuration
                            padding: const EdgeInsets.symmetric(
                              // Set horizontal padding
                              horizontal: AppSpacing.space_xl,
                              // Set vertical padding
                              vertical: AppSpacing.space_m,
                            ),
                          ),
                          // Text label child of button
                          child: Text(
                            // Set button label string from localizations
                            localizations.skip,
                            // Style properties for skip label
                            style: const TextStyle(
                              // Set color to primary brand color
                              color: AppColors.primary_color,
                              // Set font size from spacing constants
                              fontSize: AppSpacing.font_size_skip_button,
                              // Set semi-bold weight helper constant
                              fontWeight: FontWeightHelper.semi_bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned widget placement containing bottom navigation button
                  Positioned(
                    // Set bottom constraint offset
                    bottom: AppSpacing.space_xxxl,
                    // Set left constraint margin
                    left: AppSpacing.space_xxl,
                    // Set right constraint margin
                    right: AppSpacing.space_xxl,
                    // SizedBox container sizing button width
                    child: SizedBox(
                      // Set width to fill horizontal layout parent
                      width: double.infinity,
                      // Set height to standard button height constraint
                      height: AppSpacing.size_logo_box_small,
                      // ElevatedButton widget navigating to next slide
                      child: ElevatedButton(
                        // Set tap action callback function
                        onPressed: () {
                          // Check if active index represents a sliding page index
                          if (current_page < (_images.length - 1)) {
                            // Slide horizontal view page to next index
                            _page_controller.animateToPage(
                              // Specify next target page index
                              current_page + 1,
                              // Define sliding transition duration
                              duration: const Duration(
                                // Set page animation sliding speed
                                milliseconds: AppSpacing.duration_page_slide_ms,
                              ),
                              // Apply uniform easing curve transition
                              curve: Curves.easeInOut,
                            );
                          }
                          // Else block representing click events on final page
                          else {
                            // Trigger onboarding completion in cubit state manager
                            context.read<OnboardingCubit>().onboarding_completed();
                          }
                        },
                        // Button layout styling properties
                        style: ElevatedButton.styleFrom(
                          // Apply primary brand background color
                          backgroundColor: AppColors.primary_color,
                          // Remove shadow elevation to keep layout flat
                          elevation: 0.0,
                          // Apply rounded borders constraint shape
                          shape: RoundedRectangleBorder(
                            // Set border radius using extra large radius token
                            borderRadius: BorderRadius.circular(
                              // Set border radius
                              AppSpacing.radius_xl,
                            ),
                          ),
                        ),
                        // Text label representing current button action stage
                        child: Text(
                          // Determine dynamic label string based on active index
                          true == is_last
                              // Return Get Started label string on last page
                              ? localizations.get_started
                              // Return Next label string on other pages
                              : localizations.next,
                          // Style properties for action button label
                          style: const TextStyle(
                            // Set font size from spacing constants
                            fontSize: AppSpacing.font_size_action_button,
                            // Set bold weight helper constant
                            fontWeight: FontWeightHelper.bold,
                            // Set text color to white for contrast
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

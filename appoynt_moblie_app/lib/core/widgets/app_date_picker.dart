/*
 * File Name: app_date_picker.dart
 * Author: Kholoud Khaled
 * Date of Creation: 24/07/2026
 * Version Information: V1.0.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/theme/colors/app_colors.dart,
 *   package:appoynt_mobile_app/constants/app_spacing.dart,
 *   package:appoynt_mobile_app/core/localization/app_localizations.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 24/07/2026]
 * File Description: A custom, reusable high-fidelity calendar date picker dialog
 *   matching the design specifications.
 */

// Importing flutter material framework components
import 'package:flutter/material.dart';
// Importing design color tokens definitions
import 'package:appoynt_mobile_app/core/theme/colors/app_colors.dart';
// Importing design spacing tokens definitions
import 'package:appoynt_mobile_app/constants/app_spacing.dart';
// Importing bilingual localization definitions
import 'package:appoynt_mobile_app/core/localization/app_localizations.dart';

/// A custom calendar date picker dialog that aligns with the centralized design system.
class AppDatePickerDialog extends StatefulWidget {
  /// The initial date selected when the dialog opens
  final DateTime initialDate;
  /// The earliest date the user is allowed to select
  final DateTime firstDate;
  /// The latest date the user is allowed to select
  final DateTime lastDate;

  /// Constructor initializing constraints of calendar picker dialog
  const AppDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<AppDatePickerDialog> createState() {
    // Return state class tracking picker interactions
    return _AppDatePickerDialogState();
  }
}

/// State tracking logic for the custom date picker dialog
class _AppDatePickerDialogState extends State<AppDatePickerDialog> {
  /// Date indicating the current active month being viewed
  late DateTime _currentMonth;
  /// The actively selected date element
  DateTime? _selectedDate;

  @override
  // Initialize date parameters upon lifecycle state creation
  void initState() {
    // Invoke parent widget initialization
    super.initState();
    // Resolve start viewing month from the initialDate parameter
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    // Bind initial selected date to the initialDate parameter
    _selectedDate = widget.initialDate;
  }

  // Helper method checking if two date instances match the same day
  bool _isSameDay(DateTime date1, DateTime? date2) {
    // Return false if compared target is null (Yoda style check)
    if (null == date2) {
      // Exit early on null comparison
      return false;
    } else {
      // Empty action block to satisfy compiler
    }
    // Perform equality checks on year, month, and day components
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Helper method checking if the day matches the current system day
  bool _isToday(DateTime date) {
    // Retrieve system local time representation
    final DateTime now = DateTime.now();
    // Perform equality comparisons on day parameters
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  // Draw the custom high-fidelity calendar picker dialog card
  Widget build(BuildContext context) {
    // Fetch active system brightness mode configuration
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Load translation catalog dictionary mappings
    final AppLocalizations localizations = AppLocalizations.of(context);

    // Number of days in the month
    final int days_in_month =
        DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    // Day of the week of the 1st of the month (1 for Monday, 7 for Sunday)
    final int first_day_weekday =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;

    // Months translation maps
    final List<String> months_en = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final List<String> months_ar = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    // Resolve month label text (Yoda style check)
    final String month_text = true == localizations.is_arabic
        ? months_ar[_currentMonth.month - 1]
        : months_en[_currentMonth.month - 1];

    // Resolve year label text
    final String year_text = '${_currentMonth.year}';

    // Weekdays headers
    final List<String> weekdays_en = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final List<String> weekdays_ar = ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'];
    // Resolve weekday labels based on active language (Yoda style check)
    final List<String> weekdays =
        true == localizations.is_arabic ? weekdays_ar : weekdays_en;

    // Days grid building offsets
    final int offset = first_day_weekday - 1;
    // Total cells in months layout grid
    final int total_cells = days_in_month + offset;

    // Determine navigation boundaries using Yoda style checks
    final bool can_go_back = _currentMonth.year > widget.firstDate.year ||
        (_currentMonth.year == widget.firstDate.year &&
            _currentMonth.month > widget.firstDate.month);

    // Determine navigation boundaries using Yoda style checks
    final bool can_go_forward = _currentMonth.year < widget.lastDate.year ||
        (_currentMonth.year == widget.lastDate.year &&
            _currentMonth.month < widget.lastDate.month);

    // Dialog layout structure configuration
    return Dialog(
      // Clear legacy background fills
      backgroundColor: Colors.transparent,
      // Suppress drop shadows
      elevation: 0.0,
      // Apply standard layout horizontal padding
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space_xxl,
        vertical: AppSpacing.space_xxl,
      ),
      // Dialog floating card container
      child: Container(
        // Set dialog width derived from spacing tokens
        width: AppSpacing.calendar_dialog_width,
        // Card decorations
        decoration: BoxDecoration(
          // Resolve background color adapting to theme (Yoda style check)
          color: true == is_dark ? AppColors.surface_dark : Colors.white,
          // Rounded corners derived from spacing tokens
          borderRadius: BorderRadius.circular(AppSpacing.calendar_dialog_radius),
          // Outline border bounds resolving
          border: Border.all(
            // Resolve border color adapting to theme (Yoda style check)
            color: true == is_dark ? AppColors.border_dark : AppColors.border_light,
            // Thin border line width
            width: AppSpacing.border_width_thin,
          ),
          // Soft outer shadows
          boxShadow: [
            BoxShadow(
              // Shadow color mapping
              color: Colors.black.withValues(alpha: 0.12),
              // Soft blur radius
              blurRadius: 12.0,
              // Spread bounds
              spreadRadius: 2.0,
              // Shadow offset coordinates
              offset: const Offset(0.0, 4.0),
            ),
          ],
        ),
        // Inset padding margins derived from spacing tokens
        padding: const EdgeInsets.all(AppSpacing.calendar_dialog_padding),
        // Vertical layout children column
        child: Column(
          // Wrap content tight to children size
          mainAxisSize: MainAxisSize.min,
          // Visual children list
          children: [
            // Top Row Header: Month / Year + Navigation Controls
            Row(
              // Distribute month text and chevrons to edges
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // children list
              children: [
                // Display month/year text header
                Text(
                  '$month_text $year_text',
                  // Typography styles
                  style: TextStyle(
                    // Title font size derived from spacing tokens
                    fontSize: AppSpacing.calendar_title_font_size,
                    // Bold emphasis
                    fontWeight: FontWeight.bold,
                    // Colors adapt to theme (Yoda style check)
                    color: true == is_dark
                        ? Colors.white
                        : AppColors.text_light_primary,
                  ),
                ),
                // Chevrons row controls
                Row(
                  // children list
                  children: [
                    // GestureDetector mapping navigation backward
                    IconButton(
                      // Left chevron icon
                      icon: const Icon(Icons.chevron_left_rounded, size: AppSpacing.icon_size_m),
                      // Adaptive icon colors resolving (Yoda style check)
                      color: true == can_go_back
                          ? (true == is_dark ? Colors.white54 : Colors.black45)
                          : (true == is_dark ? Colors.white10 : Colors.black12),
                      // Clear button inner margins
                      padding: EdgeInsets.zero,
                      // Shrink targets
                      constraints: const BoxConstraints(),
                      // Navigation trigger (Yoda style check)
                      onPressed: true == can_go_back
                          ? () {
                              setState(() {
                                // Decr month counter
                                int prev_month = _currentMonth.month - 1;
                                int prev_year = _currentMonth.year;
                                // Reset month boundary count (Yoda style check)
                                if (0 == prev_month) {
                                  // Set to December
                                  prev_month = 12;
                                  // Decr year index
                                  prev_year--;
                                } else {
                                  // Empty action block to satisfy compiler
                                }
                                // Update view month coordinate
                                _currentMonth = DateTime(prev_year, prev_month);
                              });
                            }
                          : null,
                    ),
                    // Margin gap between chevrons
                    const SizedBox(width: AppSpacing.space_m),
                    // GestureDetector mapping navigation forward
                    IconButton(
                      // Right chevron icon
                      icon: const Icon(Icons.chevron_right_rounded, size: AppSpacing.icon_size_m),
                      // Adaptive icon colors resolving (Yoda style check)
                      color: true == can_go_forward
                          ? (true == is_dark ? Colors.white54 : Colors.black45)
                          : (true == is_dark ? Colors.white10 : Colors.black12),
                      // Clear button inner margins
                      padding: EdgeInsets.zero,
                      // Shrink targets
                      constraints: const BoxConstraints(),
                      // Navigation trigger (Yoda style check)
                      onPressed: true == can_go_forward
                          ? () {
                              setState(() {
                                // Incr month counter
                                int next_month = _currentMonth.month + 1;
                                int next_year = _currentMonth.year;
                                // Reset month boundary count (Yoda style check)
                                if (13 == next_month) {
                                  // Set to January
                                  next_month = 1;
                                  // Incr year index
                                  next_year++;
                                } else {
                                  // Empty action block to satisfy compiler
                                }
                                // Update view month coordinate
                                _currentMonth = DateTime(next_year, next_month);
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            // Spacer vertical gap
            const SizedBox(height: AppSpacing.space_xl),
            // Weekdays Header Row (M T W T F S S)
            Row(
              // Space weekday letters evenly
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Map letters to widgets
              children: weekdays.map((day) {
                // Return fixed width container
                return SizedBox(
                  // Set day box width derived from spacing tokens
                  width: AppSpacing.calendar_grid_cell_size,
                  // Center letters
                  child: Text(
                    day,
                    // Text align center
                    textAlign: TextAlign.center,
                    // Muted typography styles
                    style: const TextStyle(
                      // Font size derived from spacing tokens
                      fontSize: AppSpacing.font_size_body_small,
                      // Font weight
                      fontWeight: FontWeight.w600,
                      // Muted grey color using inner container border design token
                      color: AppColors.inner_container_border_light,
                    ),
                  ),
                );
              }).toList(),
            ),
            // Spacer vertical gap
            const SizedBox(height: AppSpacing.space_m),
            // Month days display grid
            GridView.builder(
              // Shrink wrap layout to children sizes
              shrinkWrap: true,
              // Disable independent scrolling
              physics: const NeverScrollableScrollPhysics(),
              // Set total grid cell count
              itemCount: total_cells,
              // Set 7-column layout delegate
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                // 7 columns matching standard week grid
                crossAxisCount: 7,
                // Vertical grid lines gap
                mainAxisSpacing: AppSpacing.space_s,
                // Horizontal grid lines gap
                crossAxisSpacing: AppSpacing.space_s,
                // Square aspect ratio
                childAspectRatio: 1.0,
              ),
              // Grid cell builder
              itemBuilder: (context, index) {
                // Render empty container for prepended offset padding (Yoda style check)
                if (index < offset) {
                  // Return empty widget
                  return const SizedBox.shrink();
                } else {
                  // Empty action block to satisfy compiler
                }

                // Resolve day number coordinate representation
                final int day_num = index - offset + 1;
                // Resolve specific day date time instance
                final DateTime date =
                    DateTime(_currentMonth.year, _currentMonth.month, day_num);
                
                // Validate day bounds constraints using Yoda style check
                final bool is_before_first = date.isBefore(
                    DateTime(widget.firstDate.year, widget.firstDate.month, widget.firstDate.day));
                final bool is_after_last = date.isAfter(
                    DateTime(widget.lastDate.year, widget.lastDate.month, widget.lastDate.day));
                // Set availability flag
                final bool is_enabled = !is_before_first && !is_after_last;

                // Validate selection matching flags
                final bool is_selected = _isSameDay(date, _selectedDate);
                // Validate today matching flags
                final bool is_today_date = _isToday(date);

                // GestureDetector intercepts selections
                return GestureDetector(
                  // Handle day selection tap (Yoda style check)
                  onTap: true == is_enabled
                      ? () {
                          setState(() {
                            // Update selected date state
                            _selectedDate = date;
                          });
                        }
                      : null,
                  // Dynamic custom styled day cell container
                  child: Container(
                    // Center numbers
                    alignment: Alignment.center,
                    // Layout decorations
                    decoration: BoxDecoration(
                      // Day shape coordinates circle border format
                      shape: BoxShape.circle,
                      // Active selected day colored blue (Yoda style check)
                      color: true == is_selected
                          ? AppColors.primary_color
                          : Colors.transparent,
                      // Today has outline borders if not selected (Yoda style check)
                      border: true == is_today_date && false == is_selected
                          ? Border.all(color: AppColors.primary_color, width: AppSpacing.border_width_thin)
                          : null,
                      // Apply glow shadows only when selected (Yoda style check)
                      boxShadow: true == is_selected
                          ? [
                              BoxShadow(
                                // Soft primary shadow
                                color: AppColors.primary_color.withValues(alpha: 0.3),
                                // Blur factor
                                blurRadius: 6.0,
                                // Offset alignment coordinates
                                offset: const Offset(0.0, 2.0),
                              )
                            ]
                          : null,
                    ),
                    // Display day text representation
                    child: Text(
                      '$day_num',
                      // Typography styling configurations
                      style: TextStyle(
                        // Font size derived from spacing tokens
                        fontSize: AppSpacing.calendar_day_font_size,
                        // Highlight selected font weights (Yoda style check)
                        fontWeight: true == is_selected ? FontWeight.bold : FontWeight.normal,
                        // Resolve text color depending on state (Yoda style check)
                        color: true == is_selected
                            ? Colors.white
                            : (false == is_enabled
                                ? (true == is_dark ? Colors.white24 : Colors.black12)
                                : (true == is_dark ? Colors.white : AppColors.text_light_primary)),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Spacer vertical gap
            const SizedBox(height: AppSpacing.space_xxl),
            // Dialog Footer buttons action row
            Row(
              // children list
              children: [
                // Left CTA Action button: Cancel
                Expanded(
                  // Wrap in fixed height layout bounds
                  child: SizedBox(
                    // Height constraint derived from spacing tokens
                    height: AppSpacing.calendar_action_button_height,
                    // Cancel button
                    child: ElevatedButton(
                      // Visual button style overrides
                      style: ElevatedButton.styleFrom(
                        // Muted background colors resolving using design tokens (Yoda style check)
                        backgroundColor: true == is_dark
                            ? AppColors.border_dark
                            : AppColors.border_light,
                        // Suppress shadows
                        elevation: 0.0,
                        // Rounded pill boundary shapes
                        shape: RoundedRectangleBorder(
                          // Pill corners curves derived from spacing tokens
                          borderRadius: BorderRadius.circular(AppSpacing.calendar_dialog_radius),
                        ),
                      ),
                      // Click event pop callback
                      onPressed: () {
                        // Return null representing cancel action
                        Navigator.pop(context, null);
                      },
                      // Cancel label widget
                      child: Text(
                        // Localized cancel label string (Yoda style check)
                        true == localizations.is_arabic ? 'إلغاء' : 'Cancel',
                        // Label styles
                        style: TextStyle(
                          // Muted label text color resolving using design tokens (Yoda style check)
                          color: true == is_dark
                              ? Colors.white70
                              : AppColors.text_light_secondary,
                          // Label font size derived from spacing tokens
                          fontSize: AppSpacing.font_size_label,
                          // Medium weight emphasis
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // Horizontal divider space
                const SizedBox(width: AppSpacing.space_l),
                // Right CTA Action button: Confirm
                Expanded(
                  // Wrap in fixed height layout bounds
                  child: SizedBox(
                    // Height constraint derived from spacing tokens
                    height: AppSpacing.calendar_action_button_height,
                    // Confirm button
                    child: ElevatedButton(
                      // Visual button style overrides
                      style: ElevatedButton.styleFrom(
                        // Primary brand theme colors mapping
                        backgroundColor: AppColors.primary_color,
                        // Suppress shadows
                        elevation: 0.0,
                        // Rounded pill boundary shapes
                        shape: RoundedRectangleBorder(
                          // Pill corners curves derived from spacing tokens
                          borderRadius: BorderRadius.circular(AppSpacing.calendar_dialog_radius),
                        ),
                      ),
                      // Click event pop callback
                      onPressed: () {
                        // Return selected date on confirmation
                        Navigator.pop(context, _selectedDate);
                      },
                      // Confirm label widget
                      child: Text(
                        // Localized confirm label string (Yoda style check)
                        true == localizations.is_arabic ? 'تأكيد' : 'Confirm',
                        // Label styles
                        style: const TextStyle(
                          // Standard white labels on active CTA
                          color: Colors.white,
                          // Label font size derived from spacing tokens
                          fontSize: AppSpacing.font_size_label,
                          // Bold emphasis
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Global helper function exposing custom date picker dialog to application pages
Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  // Push custom dialog page route representation onto the navigator
  return showDialog<DateTime>(
    // Pass active build context
    context: context,
    // Apply soft dimming overlay barrier color
    barrierColor: AppColors.barrier_color,
    // Enable clicks outside boundaries dismissals
    barrierDismissible: true,
    // Dialog content builder
    builder: (BuildContext dialog_context) {
      // Return custom structured calendar picker dialog
      return AppDatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    },
  );
}

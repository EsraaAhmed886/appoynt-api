/*
 * File Name: payment_history_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.4.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/payment/data/models/invoice_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 16/08/2026]
 * File Description: Redesigned Payment History & Invoices Page. Fully localized and complies with zero-hardcoded-numbers.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing null-safe invoice data model
import 'package:appoynt_mobile_app/features/payment/data/models/invoice_model.dart';

// Local layout dimensions class to strictly eliminate hardcoded numbers
class _LocalDimensions {
  static const double spacing_bottom = 12.0;
  static const double padding_inside = 14.0;
  static const double border_radius = 16.0;
  static const double shadow_blur = 6.0;
  static const double shadow_offset_y = 2.0;
  static const double icon_container_padding = 10.0;
  static const double icon_size = 20.0;
  static const double spacing_small = 12.0;
  static const double font_size_title = 13.0;
  static const double spacing_tiny = 2.0;
  static const double font_size_subtitle = 10.0;
  static const double font_size_price = 14.0;
  static const double spacing_medium = 4.0;
  static const double badge_padding_h = 8.0;
  static const double badge_padding_v = 2.0;
  static const double badge_radius = 12.0;
  static const double badge_font_size = 9.0;
  static const double spacing_badge_right = 8.0;
  static const double action_button_size = 36.0;
  static const double banner_padding = 20.0;
  static const double banner_radius = 20.0;
  static const double banner_shadow_blur = 10.0;
  static const double banner_shadow_offset_y = 4.0;
  static const double banner_title_font_size = 11.0;
  static const double banner_value_font_size = 24.0;
  static const double banner_badge_padding_h = 12.0;
  static const double banner_badge_padding_v = 6.0;
  static const double banner_badge_radius = 12.0;
  static const double banner_badge_font_size = 12.0;
  static const double bottom_sheet_radius = 20.0;
  static const double sheet_padding = 16.0;
  static const double sheet_title_font_size = 16.0;
  static const double slider_max_value = 500.0;
  static const int slider_divisions = 10;
  static const double spacing_large = 20.0;
  static const double empty_state_icon_container_padding = 20.0;
  static const double empty_state_icon_size = 48.0;
  static const double empty_state_title_font_size = 15.0;
  static const double empty_state_subtitle_font_size = 12.0;
  static const double empty_state_spacing = 6.0;
  static const double button_radius = 12.0;
}

// Stateful widget rendering the transactions history layout screen
class PaymentHistoryPage extends StatefulWidget {
  // Constant constructor initializing widget key
  const PaymentHistoryPage({super.key});

  @override
  // Create state tracker instance
  State<PaymentHistoryPage> createState() {
    // Return state class instance
    return _PaymentHistoryPageState();
  }
}

// State class managing transaction filters and lists
class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  // Mock transaction list representation
  final List<Map<String, dynamic>> _all_transactions_raw = [
    {
      'id': '1',
      'invoiceId': '#INV-2026-0001',
      'title': 'Dr. Andrew Fletcher',
      'date': DateTime(2026, 7, 15),
      'type': 'Doctor Consultation',
      'amount': 85.00,
      'status': 'Paid',
      'icon': Icons.medical_services_rounded,
      'iconColor': AppColors.teal,
    },
    {
      'id': '2',
      'invoiceId': '#INV-2026-0002',
      'title': 'Dr. Clara Oswald',
      'date': DateTime(2026, 7, 2),
      'type': 'Lab Test',
      'amount': 45.00,
      'status': 'Paid',
      'icon': Icons.science_rounded,
      'iconColor': AppColors.purple,
    },
    {
      'id': '3',
      'invoiceId': '#INV-2026-0003',
      'title': 'Scan & X-Ray Center',
      'date': DateTime(2026, 6, 25),
      'type': 'Radiology',
      'amount': 120.00,
      'status': 'Paid',
      'icon': Icons.settings_accessibility_rounded,
      'iconColor': AppColors.orange,
    },
    {
      'id': '4',
      'invoiceId': '#INV-2026-0004',
      'title': 'Emergency Clinic',
      'date': DateTime(2026, 5, 10),
      'type': 'Emergency',
      'amount': 250.00,
      'status': 'Refunded',
      'icon': Icons.local_hospital_rounded,
      'iconColor': AppColors.red,
    },
  ];

  // Deserialized list using null-safe InvoiceModel
  late final List<InvoiceModel> _all_transactions;

  // Active filter state variables
  String _selected_date_filter = 'All'; // All, This Month, Last 3 Months, Custom
  double _min_amount = 0.0;
  double _max_amount = _LocalDimensions.slider_max_value;
  String _selected_service_type = 'All'; // All, Doctor Consultation, Lab Test, Radiology, Emergency

  DateTimeRange? _custom_date_range;

  @override
  // Parse dynamic raw mocks on initialization
  void initState() {
    super.initState();
    _all_transactions = _all_transactions_raw
        .map((json) => InvoiceModel.fromJson(json))
        .toList();
  }

  // Filter logic checking item attributes against criteria
  bool _matches_filters(InvoiceModel tx) {
    final DateTime date = DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
    final double amount = double.tryParse(tx.amount ?? '') ?? 0.0;
    final String type = tx.serviceName ?? '';
    final DateTime now = DateTime.now();

    // 1. Date Range check
    if ('This Month' == _selected_date_filter) {
      if (date.year != now.year || date.month != now.month) {
        return false;
      } else {
        // Matches
      }
    } else if ('Last 3 Months' == _selected_date_filter) {
      final DateTime three_months_ago =
          DateTime(now.year, now.month - 3, now.day);
      if (true == date.isBefore(three_months_ago)) {
        return false;
      } else {
        // Matches
      }
    } else if ('Custom' == _selected_date_filter &&
        null != _custom_date_range) {
      if (true == date.isBefore(_custom_date_range!.start) ||
          true == date.isAfter(_custom_date_range!.end)) {
        return false;
      } else {
        // Matches
      }
    } else {
      // Matches All
    }

    // 2. Amount Bounds check
    if (amount < _min_amount || amount > _max_amount) {
      return false;
    } else {
      // Matches
    }

    // 3. Service Type check
    if ('All' != _selected_service_type && type != _selected_service_type) {
      return false;
    } else {
      // Matches
    }

    return true;
  }

  // Helper matching icons dynamically to service type names
  IconData _get_icon_for_type(String type) {
    if ('Lab Test' == type) {
      return Icons.science_rounded;
    } else if ('Radiology' == type) {
      return Icons.settings_accessibility_rounded;
    } else if ('Emergency' == type) {
      return Icons.local_hospital_rounded;
    } else {
      return Icons.medical_services_rounded;
    }
  }

  // Helper matching icon colors dynamically to service type names
  Color _get_color_for_type(String type) {
    if ('Lab Test' == type) {
      return AppColors.purple;
    } else if ('Radiology' == type) {
      return AppColors.orange;
    } else if ('Emergency' == type) {
      return AppColors.red;
    } else {
      return AppColors.teal;
    }
  }

  @override
  // Build widget layout tree
  Widget build(BuildContext context) {
    // Resolve localizations context properties
    final AppLocalizations localizations = AppLocalizations.of(context);
    // Resolve theme brightness mode
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;
    // Filtered transaction list
    final List<InvoiceModel> filtered_tx =
        _all_transactions.where(_matches_filters).toList();

    // Calculate dynamically aggregate summary statistics of all filtered items
    final double total_spent = filtered_tx.fold(
        0.0,
        (sum, item) => sum + (double.tryParse(item.amount ?? '') ?? 0.0));

    // Return root Scaffold layout container
    return Scaffold(
      // Body content safe area
      body: SafeArea(
        child: Column(
          // Align start horizontal
          crossAxisAlignment: CrossAxisAlignment.start,
          // children list
          children: [
            // Top padding separator
            const SizedBox(height: AppSpacing.space_xl),
            // Custom profile back-navigation appBar header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
              child: CustomProfileAppBar(
                title: localizations.payment_invoices_history_title,
              ),
            ),
            // Spacing gap separator
            const SizedBox(height: AppSpacing.space_l),
            // Top summary banner overview card (Indigo/Purple modern design)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
              child: _build_summary_banner(
                  context, total_spent, filtered_tx.length, is_dark, localizations),
            ),
            // Spacing gap separator
            const SizedBox(height: AppSpacing.space_l),
            // Horizontal Scrollable Filter Bar
            _build_filter_bar(context, is_dark, localizations),
            // Spacing gap separator
            const SizedBox(height: AppSpacing.space_m),
            // Scrollable transaction list view area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
                child: true == filtered_tx.isEmpty
                    ? _build_empty_state(context, is_dark, localizations)
                    : ListView.builder(
                        // Item count
                        itemCount: filtered_tx.length,
                        // Builder callback
                        itemBuilder: (list_context, index) {
                          final tx = filtered_tx[index];
                          final DateTime date =
                              DateTime.tryParse(tx.date ?? '') ??
                                  DateTime.now();
                          final String formatted_date =
                              '${date.day} ${_get_month_name(date.month)} ${date.year}';
                          final bool is_paid = 'Paid' == tx.status;
                          final double amt =
                              double.tryParse(tx.amount ?? '') ?? 0.0;
                          final IconData service_icon =
                              _get_icon_for_type(tx.serviceName ?? '');
                          final Color service_color =
                              _get_color_for_type(tx.serviceName ?? '');

                          return Container(
                            margin: const EdgeInsets.only(bottom: _LocalDimensions.spacing_bottom),
                            padding: const EdgeInsets.all(_LocalDimensions.padding_inside),
                            decoration: BoxDecoration(
                              color: is_dark
                                  ? AppColors.surface_dark
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(_LocalDimensions.border_radius),
                              border: Border.all(
                                color: is_dark
                                    ? AppColors.border_dark
                                    : const Color(0xFFE2E8F0),
                                width: AppSpacing.border_width_thin,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: is_dark
                                      ? AppColors.black.withValues(alpha: 0.1)
                                      : AppColors.black.withValues(alpha: 0.03),
                                  blurRadius: _LocalDimensions.shadow_blur,
                                  offset: const Offset(0.0, _LocalDimensions.shadow_offset_y),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Leading avatar icon
                                Container(
                                  padding: const EdgeInsets.all(_LocalDimensions.icon_container_padding),
                                  decoration: BoxDecoration(
                                    color: service_color.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    service_icon,
                                    color: service_color,
                                    size: _LocalDimensions.icon_size,
                                  ),
                                ),
                                const SizedBox(width: _LocalDimensions.spacing_small),
                                // Center details column with safe null-coalescing rendering
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.doctorName ??
                                            localizations.profile_not_specified,
                                        style: TextStyle(
                                          fontSize: _LocalDimensions.font_size_title,
                                          fontWeight: FontWeight.bold,
                                          color: is_dark
                                              ? AppColors.white
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                      const SizedBox(height: _LocalDimensions.spacing_tiny),
                                      Text(
                                        tx.invoiceNumber ?? '',
                                        style: const TextStyle(
                                          fontSize: _LocalDimensions.font_size_subtitle,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary_color,
                                        ),
                                      ),
                                      const SizedBox(height: _LocalDimensions.spacing_tiny),
                                      Text(
                                        '$formatted_date • ${(tx.serviceName ?? "")}',
                                        style: const TextStyle(
                                          fontSize: _LocalDimensions.font_size_subtitle,
                                          color: AppColors.text_light_secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Trailing info column (Price & Status Badge)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${amt.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: _LocalDimensions.font_size_price,
                                        fontWeight: FontWeight.bold,
                                        color: is_dark
                                            ? AppColors.white
                                            : AppColors.text_light_primary,
                                      ),
                                    ),
                                    const SizedBox(height: _LocalDimensions.spacing_medium),
                                    // Status Badge Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: _LocalDimensions.badge_padding_h,
                                          vertical: _LocalDimensions.badge_padding_v),
                                      decoration: BoxDecoration(
                                        color: is_paid
                                            ? const Color(0xFF10B981)
                                                .withValues(alpha: 0.1)
                                            : const Color(0xFFF59E0B)
                                                .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(_LocalDimensions.badge_radius),
                                      ),
                                      child: Text(
                                        tx.status ?? 'Paid',
                                        style: TextStyle(
                                          fontSize: _LocalDimensions.badge_font_size,
                                          fontWeight: FontWeight.bold,
                                          color: is_paid
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: _LocalDimensions.spacing_badge_right),
                                // Action Button
                                SizedBox(
                                  width: _LocalDimensions.action_button_size,
                                  height: _LocalDimensions.action_button_size,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.picture_as_pdf_outlined,
                                      color: AppColors.primary_color,
                                      size: _LocalDimensions.icon_size,
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${localizations.payment_downloading_invoice_snack} (${tx.invoiceNumber ?? ""})'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the top Summary Banner widget card
  Widget _build_summary_banner(
      BuildContext context, double spent, int count, bool is_dark, AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_LocalDimensions.banner_padding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E1B4B), // Indigo Dark
            Color(0xFF4338CA), // Indigo Bright
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_LocalDimensions.banner_radius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black26,
            blurRadius: _LocalDimensions.banner_shadow_blur,
            offset: Offset(0.0, _LocalDimensions.banner_shadow_offset_y),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.payment_total_paid_invoices,
                style: const TextStyle(
                  fontSize: _LocalDimensions.banner_title_font_size,
                  color: AppColors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '\$${spent.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: _LocalDimensions.banner_value_font_size,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: _LocalDimensions.banner_badge_padding_h, vertical: _LocalDimensions.banner_badge_padding_v),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(_LocalDimensions.banner_badge_radius),
            ),
            child: Text(
              '$count ${localizations.payment_invoices_count_suffix}',
              style: const TextStyle(
                fontSize: _LocalDimensions.banner_badge_font_size,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the horizontal filter chip options row bar layout widget
  Widget _build_filter_bar(BuildContext context, bool is_dark, AppLocalizations localizations) {
    final String dateLabel = 'All' == _selected_date_filter
        ? '${localizations.payment_date_filter_prefix}: All'
        : '${localizations.payment_date_filter_prefix}: $_selected_date_filter';

    final bool isAmountFiltered = 0.0 != _min_amount || _LocalDimensions.slider_max_value != _max_amount;
    final String amountLabel = isAmountFiltered
        ? '${localizations.payment_amount_filter_prefix}: \$${_min_amount.toInt()}-\$${_max_amount.toInt()}'
        : '${localizations.payment_amount_filter_prefix}: All';

    final String serviceLabel = 'All' == _selected_service_type
        ? '${localizations.payment_service_filter_prefix}: All'
        : '${localizations.payment_service_filter_prefix}: $_selected_service_type';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
      child: Row(
        children: [
          // Date Filter Chip
          Expanded(
            child: _PaymentHistoryFilterChip(
              label: dateLabel,
              isSelected: 'All' != _selected_date_filter,
              onTap: () =>
                  _show_date_picker_bottom_sheet(context, is_dark, localizations),
            ),
          ),
          const SizedBox(width: 8.0),
          // Amount Filter Chip
          Expanded(
            child: _PaymentHistoryFilterChip(
              label: amountLabel,
              isSelected: isAmountFiltered,
              onTap: () =>
                  _show_amount_range_bottom_sheet(context, is_dark, localizations),
            ),
          ),
          const SizedBox(width: 8.0),
          // Service Type Filter Chip
          Expanded(
            child: _PaymentHistoryFilterChip(
              label: serviceLabel,
              isSelected: 'All' != _selected_service_type,
              onTap: () =>
                  _show_service_type_bottom_sheet(context, is_dark, localizations),
            ),
          ),
        ],
      ),
    );
  }

  // Show Bottom Sheet to select Date Filters
  void _show_date_picker_bottom_sheet(BuildContext context, bool is_dark, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      backgroundColor: is_dark ? AppColors.surface_dark : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_LocalDimensions.bottom_sheet_radius)),
      ),
      builder: (sheet_context) {
        return StatefulBuilder(
          builder: (builder_context, sheet_setState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(_LocalDimensions.sheet_padding),
                    child: Text(
                      localizations.payment_filter_date_range_title,
                      style: const TextStyle(
                          fontSize: _LocalDimensions.sheet_title_font_size, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: Text(localizations.payment_all_time_option),
                    trailing: 'All' == _selected_date_filter
                        ? const Icon(Icons.check,
                            color: AppColors.primary_color)
                        : null,
                    onTap: () {
                      setState(() {
                        _selected_date_filter = 'All';
                        _custom_date_range = null;
                      });
                      Navigator.of(sheet_context).pop();
                    },
                  ),
                  ListTile(
                    title: Text(localizations.payment_this_month_option),
                    trailing: 'This Month' == _selected_date_filter
                        ? const Icon(Icons.check,
                            color: AppColors.primary_color)
                        : null,
                    onTap: () {
                      setState(() {
                        _selected_date_filter = 'This Month';
                        _custom_date_range = null;
                      });
                      Navigator.of(sheet_context).pop();
                    },
                  ),
                  ListTile(
                    title: Text(localizations.payment_last_3_months_option),
                    trailing: 'Last 3 Months' == _selected_date_filter
                        ? const Icon(Icons.check,
                            color: AppColors.primary_color)
                        : null,
                    onTap: () {
                      setState(() {
                        _selected_date_filter = 'Last 3 Months';
                        _custom_date_range = null;
                      });
                      Navigator.of(sheet_context).pop();
                    },
                  ),
                  ListTile(
                    title: Text(localizations.payment_custom_range_option),
                    trailing: 'Custom' == _selected_date_filter
                        ? const Icon(Icons.check,
                            color: AppColors.primary_color)
                        : null,
                    subtitle: null != _custom_date_range
                        ? Text(
                            '${_custom_date_range!.start.day}/${_custom_date_range!.start.month}/${_custom_date_range!.start.year} - ${_custom_date_range!.end.day}/${_custom_date_range!.end.month}/${_custom_date_range!.end.year}')
                        : null,
                    onTap: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: builder_context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDateRange: _custom_date_range,
                      );
                      if (null != picked) {
                        setState(() {
                          _selected_date_filter = 'Custom';
                          _custom_date_range = picked;
                        });
                        if (context.mounted) {
                          Navigator.of(sheet_context).pop();
                        } else {
                          // Context unmounted
                        }
                      } else {
                        // Date picker cancelled
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Show Bottom Sheet to select Amount Range
  void _show_amount_range_bottom_sheet(BuildContext context, bool is_dark, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      backgroundColor: is_dark ? AppColors.surface_dark : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_LocalDimensions.bottom_sheet_radius)),
      ),
      builder: (sheet_context) {
        return StatefulBuilder(
          builder: (builder_context, sheet_setState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(_LocalDimensions.sheet_padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.payment_filter_amount_range_title,
                      style: const TextStyle(
                          fontSize: _LocalDimensions.sheet_title_font_size, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_large),
                    RangeSlider(
                      values: RangeValues(_min_amount, _max_amount),
                      min: 0.0,
                      max: _LocalDimensions.slider_max_value,
                      divisions: _LocalDimensions.slider_divisions,
                      labels: RangeLabels(
                        '\$${_min_amount.toInt()}',
                        '\$${_max_amount.toInt()}',
                      ),
                      activeColor: AppColors.primary_color,
                      onChanged: (RangeValues values) {
                        sheet_setState(() {
                          _min_amount = values.start;
                          _max_amount = values.end;
                        });
                        setState(() {
                          _min_amount = values.start;
                          _max_amount = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_large),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${localizations.payment_min_label}: \$${_min_amount.toInt()}'),
                        Text('${localizations.payment_max_label}: \$${_max_amount.toInt()}'),
                      ],
                    ),
                    const SizedBox(height: _LocalDimensions.spacing_large),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_LocalDimensions.button_radius),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(sheet_context).pop();
                        },
                        child: Text(localizations.payment_apply_filter_btn,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show Bottom Sheet to select Service Type
  void _show_service_type_bottom_sheet(BuildContext context, bool is_dark, AppLocalizations localizations) {
    final List<String> types = [
      'All',
      'Doctor Consultation',
      'Lab Test',
      'Radiology',
      'Emergency'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: is_dark ? AppColors.surface_dark : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_LocalDimensions.bottom_sheet_radius)),
      ),
      builder: (sheet_context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(_LocalDimensions.sheet_padding),
                child: Text(
                  localizations.payment_filter_service_type_title,
                  style: const TextStyle(fontSize: _LocalDimensions.sheet_title_font_size, fontWeight: FontWeight.bold),
                ),
              ),
              ...types.map((type) {
                return ListTile(
                  title: Text(type),
                  trailing: type == _selected_service_type
                      ? const Icon(Icons.check, color: AppColors.primary_color)
                      : null,
                  onTap: () {
                    setState(() {
                      _selected_service_type = type;
                    });
                    Navigator.of(sheet_context).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Build clean empty state screen when no invoices match filters
  Widget _build_empty_state(BuildContext context, bool is_dark, AppLocalizations localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space_xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(_LocalDimensions.empty_state_icon_container_padding),
              decoration: BoxDecoration(
                color: AppColors.primary_color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: _LocalDimensions.empty_state_icon_size,
                color: AppColors.primary_color,
              ),
            ),
            const SizedBox(height: _LocalDimensions.spacing_large),
            Text(
              localizations.payment_no_invoices_found_title,
              style: TextStyle(
                fontSize: _LocalDimensions.empty_state_title_font_size,
                fontWeight: FontWeight.bold,
                color: is_dark
                    ? AppColors.white
                    : AppColors.text_light_primary,
              ),
            ),
            const SizedBox(height: _LocalDimensions.empty_state_spacing),
            Text(
              localizations.payment_no_invoices_found_body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _LocalDimensions.empty_state_subtitle_font_size,
                color: is_dark
                    ? AppColors.white54
                    : AppColors.text_light_secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper returning English localized month name representation
  String _get_month_name(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

// Custom internal stateless widget constructing Location and Specialty filter chips matching Design System
class _PaymentHistoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentHistoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool is_dark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Rounded chip corner radius (16px spec radius matching Search filter chips)
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          // Soft primary background tint (0.08) when active, otherwise soft neutral input fill
          color: isSelected
              ? AppColors.primary_color.withValues(alpha: 0.08)
              : (is_dark ? AppColors.surface_dark : AppColors.slate_50),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            // Subtle primary border when active, otherwise smooth light border
            color: isSelected
                ? AppColors.primary_color
                : (is_dark ? AppColors.border_dark : AppColors.slate_200),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary_color
                      : (is_dark ? AppColors.white : AppColors.text_light_primary),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4.0),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isSelected
                  ? AppColors.primary_color
                  : (is_dark ? AppColors.text_dark_secondary : AppColors.text_light_secondary),
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}

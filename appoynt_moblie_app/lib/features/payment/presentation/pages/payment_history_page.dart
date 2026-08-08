/*
 * File Name: payment_history_page.dart
 * Author: Kholoud Khaled
 * Date of Creation: 08/08/2026
 * Version Information: V1.3.0
 * Dependencies: package:flutter/material.dart,
 *   package:appoynt_mobile_app/core/routing/route_export.dart,
 *   package:appoynt_mobile_app/features/payment/data/models/invoice_model.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 08/08/2026]
 * File Description: Redesigned Payment History & Invoices Page displaying transaction histories, filters, and null-safe invoice models. Fully localized.
 */

// Importing global route exports
import 'package:appoynt_mobile_app/core/routing/route_export.dart';
// Importing null-safe invoice data model
import 'package:appoynt_mobile_app/features/payment/data/models/invoice_model.dart';

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
      'iconColor': Colors.teal,
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
      'iconColor': Colors.purple,
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
      'iconColor': Colors.orange,
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
      'iconColor': Colors.red,
    },
  ];

  // Deserialized list using null-safe InvoiceModel
  late final List<InvoiceModel> _all_transactions;

  // Active filter state variables
  String _selected_date_filter = 'All'; // All, This Month, Last 3 Months, Custom
  double _min_amount = 0.0;
  double _max_amount = 500.0;
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
      return Colors.purple;
    } else if ('Radiology' == type) {
      return Colors.orange;
    } else if ('Emergency' == type) {
      return Colors.red;
    } else {
      return Colors.teal;
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

    // Calculate dynamically aggregate summary statistics
    final double total_spent = filtered_tx
        .where((tx) => 'Paid' == tx.status)
        .fold(0.0,
            (sum, item) => sum + (double.tryParse(item.amount ?? '') ?? 0.0));

    // Return root Scaffold layout container
    return Scaffold(
      // Body content safe area
      body: SafeArea(
        child: Padding(
          // Outer padding bounds
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space_xl),
          // Column stack layout
          child: Column(
            // Align start horizontal
            crossAxisAlignment: CrossAxisAlignment.start,
            // children list
            children: [
              // Top padding separator
              const SizedBox(height: AppSpacing.space_xl),
              // Custom profile back-navigation appBar header
              CustomProfileAppBar(
                title: localizations.payment_invoices_history_title,
              ),
              // Spacing gap separator
              const SizedBox(height: AppSpacing.space_l),
              // Top summary banner overview card (Indigo/Purple modern design)
              _build_summary_banner(
                  context, total_spent, filtered_tx.length, is_dark, localizations),
              // Spacing gap separator
              const SizedBox(height: AppSpacing.space_l),
              // Horizontal Scrollable Filter Bar
              _build_filter_bar(context, is_dark, localizations),
              // Spacing gap separator
              const SizedBox(height: AppSpacing.space_m),
              // Scrollable transaction list view area
              Expanded(
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
                            margin: const EdgeInsets.only(bottom: 12.0),
                            padding: const EdgeInsets.all(14.0),
                            decoration: BoxDecoration(
                              color: true == is_dark
                                  ? AppColors.surface_dark
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: true == is_dark
                                    ? AppColors.border_dark
                                    : const Color(0xFFE2E8F0),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: true == is_dark
                                      ? Colors.black.withValues(alpha: 0.1)
                                      : Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6.0,
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Leading avatar icon
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: service_color.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    service_icon,
                                    color: service_color,
                                    size: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
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
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: true == is_dark
                                              ? Colors.white
                                              : AppColors.text_light_primary,
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        tx.invoiceNumber ?? '',
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary_color,
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        '$formatted_date • ${(tx.serviceName ?? "")}',
                                        style: const TextStyle(
                                          fontSize: 10.0,
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
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: true == is_dark
                                            ? Colors.white
                                            : AppColors.text_light_primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    // Status Badge Pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: true == is_paid
                                            ? const Color(0xFF10B981)
                                                .withValues(alpha: 0.1)
                                            : const Color(0xFFF59E0B)
                                                .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Text(
                                        tx.status ?? 'Paid',
                                        style: TextStyle(
                                          fontSize: 9.0,
                                          fontWeight: FontWeight.bold,
                                          color: true == is_paid
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFF59E0B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8.0),
                                // Action Button
                                SizedBox(
                                  width: 36.0,
                                  height: 36.0,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.picture_as_pdf_outlined,
                                      color: AppColors.primary_color,
                                      size: 20.0,
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
            ],
          ),
        ),
      ),
    );
  }

  // Build the top Summary Banner widget card
  Widget _build_summary_banner(
      BuildContext context, double spent, int count, bool is_dark, AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E1B4B), // Indigo Dark
            Color(0xFF4338CA), // Indigo Bright
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 4.0),
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
                  fontSize: 11.0,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '\$${spent.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              '$count ${localizations.payment_invoices_count_suffix}',
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the horizontal filter chip options row bar layout widget
  Widget _build_filter_bar(BuildContext context, bool is_dark, AppLocalizations localizations) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Date Filter Chip
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text('${localizations.payment_date_filter_prefix}: $_selected_date_filter ▾'),
              selected: 'All' != _selected_date_filter,
              onSelected: (_) =>
                  _show_date_picker_bottom_sheet(context, is_dark, localizations),
              selectedColor: AppColors.primary_color.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary_color,
            ),
          ),
          // Amount Filter Chip
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(
                  '${localizations.payment_amount_filter_prefix}: \$${_min_amount.toInt()} - \$${_max_amount.toInt()} ▾'),
              selected: 0.0 != _min_amount || 500.0 != _max_amount,
              onSelected: (_) =>
                  _show_amount_range_bottom_sheet(context, is_dark, localizations),
              selectedColor: AppColors.primary_color.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary_color,
            ),
          ),
          // Service Type Filter Chip
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text('${localizations.payment_service_filter_prefix}: $_selected_service_type ▾'),
              selected: 'All' != _selected_service_type,
              onSelected: (_) =>
                  _show_service_type_bottom_sheet(context, is_dark, localizations),
              selectedColor: AppColors.primary_color.withValues(alpha: 0.15),
              checkmarkColor: AppColors.primary_color,
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
      backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheet_context) {
        return StatefulBuilder(
          builder: (builder_context, sheet_setState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      localizations.payment_filter_date_range_title,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
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
      backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheet_context) {
        return StatefulBuilder(
          builder: (builder_context, sheet_setState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.payment_filter_amount_range_title,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    RangeSlider(
                      values: RangeValues(_min_amount, _max_amount),
                      min: 0.0,
                      max: 500.0,
                      divisions: 10,
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
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${localizations.payment_min_label}: \$${_min_amount.toInt()}'),
                        Text('${localizations.payment_max_label}: \$${_max_amount.toInt()}'),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(sheet_context).pop();
                        },
                        child: Text(localizations.payment_apply_filter_btn,
                            style: const TextStyle(
                                color: Colors.white,
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
      backgroundColor: true == is_dark ? AppColors.surface_dark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheet_context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localizations.payment_filter_service_type_title,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.primary_color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 48.0,
                color: AppColors.primary_color,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              localizations.payment_no_invoices_found_title,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: true == is_dark
                    ? Colors.white
                    : AppColors.text_light_primary,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              localizations.payment_no_invoices_found_body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: true == is_dark
                    ? Colors.white54
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

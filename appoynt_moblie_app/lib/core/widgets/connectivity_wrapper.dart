/*
 * File Name: connectivity_wrapper.dart
 * Author: Kholoud Khaled
 * Date of Creation: 02/07/2026
 * Version Information: V1.0.0
 * Dependencies:
 *   - package:flutter/material.dart
 *   - package:connectivity_plus/connectivity_plus.dart
 *   - package:appoynt_mobile_app/core/widgets/no_internet_page.dart
 * Contributors: [Kholoud Khaled]
 * Last Modified Date: [Kholoud Khaled - 02/07/2026]
 * File Description:
 *   A wrapper widget that listens to global connectivity changes and displays 
 *   NoInternetPage when the application goes offline.
 */

import 'dart:async'; // Subscription handling import
import 'package:flutter/material.dart'; // Standard Flutter material widgets
import 'package:connectivity_plus/connectivity_plus.dart'; // Connectivity listener library
import 'package:appoynt_mobile_app/core/widgets/no_internet_page.dart'; // Fallback No Internet UI representation

/// Root wrapper stateful widget checking connection status dynamically.
class ConnectivityWrapper extends StatefulWidget {
  /// The underlying child navigation tree layout.
  final Widget child;

  /// Constructor mapping the child widget parameter.
  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() {
    return _ConnectivityWrapperState();
  }
}

/// State implementation managing stream subscriptions and UI toggle states.
class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  /// Core connectivity check instance representation.
  final Connectivity _connectivity = Connectivity();
  
  /// Active subscription receiver handling incoming connectivity change packets.
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  
  /// Toggle flag identifying whether the network remains offline.
  bool _is_offline = false;

  @override
  void initState() {
    super.initState();
    // Run initialization async checks
    _check_initial_connectivity();
    // Register listener tracking network configuration changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _update_connection_status(results);
    });
  }

  @override
  void dispose() {
    // Unsubscribe listener tracking connectivity changes
    _subscription?.cancel();
    super.dispose();
  }

  /// Initial state asynchronous check querying the connectivity status.
  Future<void> _check_initial_connectivity() async {
    try {
      // Query current active network interfaces
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      // Delegate result parsing
      _update_connection_status(result);
    } catch (e) {
      // Log connection check anomalies
      debugPrint('Connectivity check failed: $e');
    }
  }

  /// Updates connection status state after analyzing the results list.
  void _update_connection_status(List<ConnectivityResult> results) {
    // Parse list to check if none is the only active status
    final bool offline = results.isEmpty || (1 == results.length && ConnectivityResult.none == results.first);
    
    // Toggle state properties if a mismatch is detected using Yoda comparison
    if (offline != _is_offline) {
      setState(() {
        _is_offline = offline;
      });
    } else {
      // Do nothing since connection state remains stable
    }
  }

  /// Re-check connectivity manual helper bound to retry button.
  Future<void> _retry_connection() async {
    try {
      // Query connectivity state again on user request
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      // Delegate results parsing
      _update_connection_status(result);
    } catch (e) {
      // Log connection retry check anomalies
      debugPrint('Connectivity retry check failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return NoInternetPage if offline using Yoda comparison checks
    if (true == _is_offline) {
      return NoInternetPage(
        on_retry: () async {
          await _retry_connection();
        },
      );
    } else {
      // Return standard application stack if online
      return widget.child;
    }
  }
}

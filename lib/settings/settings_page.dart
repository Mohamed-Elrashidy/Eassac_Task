/// ****************** FILE INFO ******************
/// File Name: settings_page.dart
/// Purpose: Settings page for configuring web URL and accessing network devices
/// Author: Mohamed Elrashidy
/// Created At: 21/11/2025

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ****************** CLASS: SettingsPage ******************
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _urlController = TextEditingController();
  final NetworkInfo _networkInfo = NetworkInfo();
  String? _selectedDevice;
  List<String> _networkDevices = [];
  bool _isLoadingDevices = false;
  bool _isBluetoothScanning = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
    _loadNetworkDevices();
  }

  /// Function Name: _loadSavedUrl
  ///
  /// Purpose: Load the previously saved URL from SharedPreferences
  ///
  /// Parameters: None
  ///
  /// Returns: Future<void>
  Future<void> _loadSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('web_url') ?? '';
    setState(() {
      _urlController.text = savedUrl;
    });
  }

  /// Function Name: _saveUrl
  ///
  /// Purpose: Save the entered URL to SharedPreferences
  ///
  /// Parameters: None
  ///
  /// Returns: Future<void>
  Future<void> _saveUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('web_url', _urlController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Function Name: _loadNetworkDevices
  ///
  /// Purpose: Load network devices (WiFi and Bluetooth) with proper permissions
  ///
  /// Parameters: None
  ///
  /// Returns: Future void
  Future<void> _loadNetworkDevices() async {
    setState(() {
      _isLoadingDevices = true;
      _networkDevices = [];
    });

    List<String> devices = [];

    try {
      // Request permissions
      if (Platform.isAndroid) {
        var locationStatus = await Permission.location.request();
        var bluetoothScanStatus = await Permission.bluetoothScan.request();
        var bluetoothConnectStatus = await Permission.bluetoothConnect
            .request();

        if (locationStatus.isGranted) {
          // Get WiFi information
          try {
            final wifiName = await _networkInfo.getWifiName();
            final wifiIP = await _networkInfo.getWifiIP();
            final wifiBSSID = await _networkInfo.getWifiBSSID();

            if (wifiName != null) {
              devices.add(
                'WiFi: $wifiName${wifiIP != null ? " ($wifiIP)" : ""}',
              );
            }
            if (wifiBSSID != null) {
              devices.add('WiFi BSSID: $wifiBSSID');
            }
          } catch (e) {
            debugPrint('Error getting WiFi info: $e');
          }
        }

        // Scan for Bluetooth devices
        if (bluetoothScanStatus.isGranted && bluetoothConnectStatus.isGranted) {
          await _scanBluetoothDevices(devices);
        } else {
          devices.add('Bluetooth: Permission denied');
        }
      } else if (Platform.isIOS) {
        var locationStatus = await Permission.location.request();

        if (locationStatus.isGranted) {
          // Get WiFi information for iOS
          try {
            final wifiName = await _networkInfo.getWifiName();
            final wifiIP = await _networkInfo.getWifiIP();

            if (wifiName != null) {
              devices.add(
                'WiFi: $wifiName${wifiIP != null ? " ($wifiIP)" : ""}',
              );
            }
          } catch (e) {
            debugPrint('Error getting WiFi info: $e');
          }
        }

        var bluetoothStatus = await Permission.bluetooth.request();
        if (bluetoothStatus.isGranted) {
          await _scanBluetoothDevices(devices);
        } else {
          devices.add('Bluetooth: Permission denied');
        }
      }
    } catch (e) {
      debugPrint('Error loading network devices: $e');
      devices.add('Error loading devices: ${e.toString()}');
    }

    setState(() {
      _networkDevices = devices.isEmpty ? ['No devices found'] : devices;
      _isLoadingDevices = false;
    });
  }

  /// Function Name: _scanBluetoothDevices
  ///
  /// Purpose: Scan for nearby Bluetooth devices
  ///
  /// Parameters:
  /// - devices: List to add found Bluetooth devices
  ///
  /// Returns: Future void
  Future<void> _scanBluetoothDevices(List<String> devices) async {
    try {
      // Check if Bluetooth is supported
      if (await FlutterBluePlus.isSupported == false) {
        devices.add('Bluetooth: Not supported on this device');
        return;
      }

      // Check if Bluetooth is turned on
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        devices.add('Bluetooth: Please turn on Bluetooth');

        // Try to turn on Bluetooth (Android only)
        if (Platform.isAndroid) {
          try {
            await FlutterBluePlus.turnOn();
          } catch (e) {
            debugPrint('Cannot turn on Bluetooth automatically: $e');
          }
        }
        return;
      }

      setState(() {
        _isBluetoothScanning = true;
      });

      // Get already connected devices
      final connectedDevices = await FlutterBluePlus.systemDevices([]);
      for (var device in connectedDevices) {
        devices.add(
          'Bluetooth (Connected): ${device.platformName.isNotEmpty ? device.platformName : device.remoteId.toString()}',
        );
      }

      // Start scanning for devices
      final scanResults = <String>{};

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 4),
        androidUsesFineLocation: true,
      );

      // Listen to scan results
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          final deviceName = result.device.platformName.isNotEmpty
              ? result.device.platformName
              : 'Unknown Device';
          final deviceId = result.device.remoteId.toString();
          final rssi = result.rssi;

          scanResults.add(
            'Bluetooth: $deviceName ($deviceId) [Signal: $rssi dBm]',
          );
        }
      });

      // Wait for scan to complete
      await Future.delayed(const Duration(seconds: 4));

      // Stop scanning
      await FlutterBluePlus.stopScan();

      // Add scanned devices
      if (scanResults.isNotEmpty) {
        devices.addAll(scanResults);
      } else {
        devices.add('Bluetooth: No devices found nearby');
      }

      setState(() {
        _isBluetoothScanning = false;
      });
    } catch (e) {
      debugPrint('Error scanning Bluetooth devices: $e');
      devices.add('Bluetooth: Error scanning - ${e.toString()}');
      setState(() {
        _isBluetoothScanning = false;
      });
    }
  }

  /// Function Name: _showDeviceDialog
  ///
  /// Purpose: Show a dialog with information about the selected device
  ///
  /// Parameters:
  /// - device: The selected device name
  ///
  /// Returns: void
  void _showDeviceDialog(String device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Selected'),
        content: Text('You selected: $device'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings'),
            if (user != null)
              Text(
                user.email ?? 'User',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              // Show confirmation dialog
              final shouldSignOut = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );

              if (shouldSignOut == true && context.mounted) {
                try {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error signing out: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Web URL Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Web URL Configuration',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: 'Enter Website URL',
                        hintText: 'https://example.com',
                        prefixIcon: const Icon(Icons.link),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveUrl,
                        icon: const Icon(Icons.save),
                        label: const Text('Save URL'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_urlController.text.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              '/webview',
                              arguments: _urlController.text,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a URL first'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Open in WebView'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Network Devices Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.devices,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Network Devices',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (_isBluetoothScanning)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Scanning BT...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        IconButton(
                          onPressed: _loadNetworkDevices,
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Refresh devices',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingDevices)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[50],
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Device',
                            prefixIcon: const Icon(Icons.print),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          items: _networkDevices.map((device) {
                            return DropdownMenuItem(
                              value: device,
                              child: Text(
                                device,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDevice = value;
                            });
                            if (value != null) {
                              _showDeviceDialog(value);
                            }
                          },
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (_selectedDevice != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue[700],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Selected: $_selectedDevice',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Info Card
            Card(
              elevation: 2,
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber[900]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Configure the website URL to display in the WebView. Select network devices like WiFi, Bluetooth, or printers from the dropdown.',
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<BluetoothDevice> _devices = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanSubscription;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _scanSubscription.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _devices.clear();
    });

    _scanSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        setState(() {
          for (var result in results) {
            if (!_devices.contains(result.device)) {
              _devices.add(result.device);
            }
          }
        });
      },
      onError: (error) {
        setState(() {
          _isScanning = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error scanning: $error')));
      },
    );

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan for Devices'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.stop : Icons.search),
            onPressed: _isScanning ? _stopScan : _startScan,
          ),
        ],
      ),
      body:
          _devices.isEmpty
              ? const Center(
                child: Text(
                  'No devices found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return ListTile(
                    title: Text(
                      device.name.isEmpty ? 'Unknown Device' : device.name,
                    ),
                    subtitle: Text(device.id.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.bluetooth),
                      onPressed: () {
                        // Add logic to connect to the device
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Connecting to ${device.name}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}

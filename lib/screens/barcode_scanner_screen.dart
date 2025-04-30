import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatelessWidget {
  final void Function(String barcode, String type) onScanned;
  const BarcodeScannerScreen({Key? key, required this.onScanned}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Card Barcode')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final barcode = barcodes.first;
            final rawValue = barcode.rawValue;
            final type = barcode.type.name;
            if (rawValue != null) {
              onScanned(rawValue, type);
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }
}

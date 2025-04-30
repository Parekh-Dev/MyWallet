import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/loyalty_card.dart';

class BarcodeDisplay extends StatelessWidget {
  final LoyaltyCard card;
  final double size;

  const BarcodeDisplay({
    Key? key,
    required this.card,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Center(
        child: _buildBarcode(),
      ),
    );
  }

  Widget _buildBarcode() {
    switch (card.barcodeType.toLowerCase()) {
      case 'qr':
        return QrImageView(
          data: card.barcodeData,
          size: size,
        );
      case 'code128':
        return BarcodeWidget(
          barcode: Barcode.code128(),
          data: card.barcodeData,
          width: size,
          height: size * 0.5,
        );
      default:
        return Text(
          'Unsupported barcode type: ${card.barcodeType}',
          style: const TextStyle(color: Colors.red),
        );
    }
  }
}

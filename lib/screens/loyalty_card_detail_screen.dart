import 'package:flutter/material.dart';
import '../models/loyalty_card.dart';
import '../widgets/barcode_display.dart';
import 'package:hive/hive.dart';
import '../services/loyalty_card_service.dart';
import 'add_edit_loyalty_card_screen.dart';

class LoyaltyCardDetailScreen extends StatelessWidget {
  final LoyaltyCard card;
  const LoyaltyCardDetailScreen({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(card.cardName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () async {
              final updated = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditLoyaltyCardScreen(card: card),
                ),
              );
              if (updated == true && context.mounted) {
                Navigator.of(context).pop(true); // Pop and trigger refresh
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Card'),
                  content: const Text('Are you sure you want to delete this card?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                // Delete from Hive
                final box = await Hive.openBox('loyalty_cards');
                await box.delete(card.id);
                await LoyaltyCardService().deleteCardFromCloud(card.id);
                if (context.mounted) {
                  Navigator.of(context).pop(true); // Pop and trigger refresh
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BarcodeDisplay(card: card, size: 220),
                const SizedBox(height: 24),
                Text('Card Number: ${card.cardNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                if (card.expirationDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Expires: ${card.expirationDate!.toLocal().toString().split(' ')[0]}', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                  ),
                if (card.notes != null && card.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Text('Notes: ${card.notes!}', style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

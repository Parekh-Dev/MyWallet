import 'package:flutter/material.dart';
import '../models/loyalty_card.dart';
import '../services/loyalty_card_service.dart';
import 'add_edit_loyalty_card_screen.dart';
import 'loyalty_card_detail_screen.dart';

class LoyaltyCardListScreen extends StatefulWidget {
  const LoyaltyCardListScreen({Key? key}) : super(key: key);

  @override
  State<LoyaltyCardListScreen> createState() => _LoyaltyCardListScreenState();
}

class _LoyaltyCardListScreenState extends State<LoyaltyCardListScreen> {
  List<LoyaltyCard> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => isLoading = true);
    await LoyaltyCardService().syncFromCloudToLocal();
    cards = await LoyaltyCardService().getAllCards();
    setState(() => isLoading = false);
  }

  void _navigateToAddCard() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEditLoyaltyCardScreen(),
      ),
    );
    if (result == true) {
      _loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Loyalty Cards')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cards.isEmpty
              ? const Center(child: Text('No cards yet. Tap + to add.'))
              : ListView.separated(
                  itemCount: cards.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 10),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                          child: Icon(Icons.card_membership, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text(card.cardName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: card.expirationDate != null
                            ? Text('Expires: ${card.expirationDate!.toLocal().toString().split(' ')[0]}', style: TextStyle(color: Theme.of(context).colorScheme.secondary))
                            : null,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoyaltyCardDetailScreen(card: card),
                            ),
                          );
                          _loadCards();
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCard,
        child: const Icon(Icons.add),
        tooltip: 'Add Card',
      ),
    );
  }
}

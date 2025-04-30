import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/loyalty_card.dart';
import '../services/loyalty_card_service.dart';
import '../services/notification_service.dart';
import 'barcode_scanner_screen.dart';

const List<String> barcodeTypes = ['qr', 'code128'];

class AddEditLoyaltyCardScreen extends StatefulWidget {
  final LoyaltyCard? card;
  const AddEditLoyaltyCardScreen({Key? key, this.card}) : super(key: key);

  @override
  State<AddEditLoyaltyCardScreen> createState() => _AddEditLoyaltyCardScreenState();
}

class _AddEditLoyaltyCardScreenState extends State<AddEditLoyaltyCardScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _cardName;
  late String _cardNumber;
  late TextEditingController _barcodeDataController;
  late String _barcodeType;
  DateTime? _expirationDate;
  String? _notes;
  String? _selectedBarcodeType;

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _cardName = widget.card!.cardName;
      _cardNumber = widget.card!.cardNumber;
      _barcodeDataController = TextEditingController(text: widget.card!.barcodeData);
      _barcodeType = widget.card!.barcodeType;
      _expirationDate = widget.card!.expirationDate;
      _notes = widget.card!.notes;
      _selectedBarcodeType = widget.card!.barcodeType;
    } else {
      _cardName = '';
      _cardNumber = '';
      _barcodeDataController = TextEditingController();
      _barcodeType = barcodeTypes.first;
      _selectedBarcodeType = barcodeTypes.first;
      _expirationDate = null;
      _notes = '';
    }
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final now = DateTime.now();
      final card = LoyaltyCard(
        id: widget.card?.id ?? const Uuid().v4(),
        cardName: _cardName,
        cardNumber: _cardNumber,
        barcodeData: _barcodeDataController.text,
        barcodeType: _barcodeType,
        expirationDate: _expirationDate,
        notes: _notes,
        createdAt: widget.card?.createdAt ?? now,
        updatedAt: now,
        isSynced: false,
      );
      if (widget.card == null) {
        await LoyaltyCardService().addCard(card);
        await LoyaltyCardService().uploadCardToCloud(card);
      } else {
        await LoyaltyCardService().updateCard(card);
        await LoyaltyCardService().updateCardInCloud(card);
      }
      // Schedule expiration notification if expirationDate is set
      if (card.expirationDate != null) {
        await NotificationService.scheduleExpirationNotification(card.cardName, card.expirationDate!);
      }
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.card == null ? 'Add Loyalty Card' : 'Edit Loyalty Card')),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text('Card Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
              TextFormField(
                initialValue: _cardName,
                decoration: const InputDecoration(labelText: 'Card Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card name';
                  }
                  return null;
                },
                onSaved: (value) => _cardName = value!,
              ),
              TextFormField(
                initialValue: _cardNumber,
                decoration: const InputDecoration(labelText: 'Card Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  return null;
                },
                onSaved: (value) => _cardNumber = value!,
              ),
              DropdownButtonFormField<String>(
                value: _selectedBarcodeType,
                items: barcodeTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Barcode Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a barcode type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedBarcodeType = value;
                  });
                },
                onSaved: (value) => _barcodeType = value!,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeDataController,
                      decoration: const InputDecoration(labelText: 'Barcode/QR Data'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter barcode or QR data';
                        }
                        return null;
                      },
                      onSaved: (value) {}, // Not needed, use controller
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    tooltip: 'Scan Barcode',
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BarcodeScannerScreen(
                            onScanned: (barcode, type) {
                              setState(() {
                                _barcodeDataController.text = barcode;
                                // Map scanner type to supported dropdown type if possible
                                if (type.toLowerCase().contains('qr')) {
                                  _selectedBarcodeType = 'qr';
                                } else if (type.toLowerCase().contains('code128')) {
                                  _selectedBarcodeType = 'code128';
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text(_expirationDate == null
                    ? 'No Expiration Date'
                    : 'Expires: ${_expirationDate!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _expirationDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _expirationDate = picked;
                    });
                  }
                },
              ),
              TextFormField(
                initialValue: _notes,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                onSaved: (value) => _notes = value,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCard,
                child: Text(widget.card == null ? 'Add Card' : 'Save Changes'),
              ),
            ],
          ), // closes ListView
        ),   // closes Form
      ),     // closes Padding
    ),       // closes Card
  ),         // closes Center
);           // closes Scaffold
  }
}


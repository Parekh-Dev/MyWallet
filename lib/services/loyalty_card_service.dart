import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/loyalty_card.dart';


class LoyaltyCardService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  static final LoyaltyCardService _instance = LoyaltyCardService._internal();
  factory LoyaltyCardService() => _instance;
  LoyaltyCardService._internal();

  final String _boxName = 'loyaltyCardBox';

  Future<Box<LoyaltyCard>> _getBox() async {
    return await Hive.openBox<LoyaltyCard>(_boxName);
  }

  Future<List<LoyaltyCard>> getAllCards() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> addCard(LoyaltyCard card) async {
    final box = await _getBox();
    await box.put(card.id, card);
  }

  Future<void> updateCard(LoyaltyCard card) async {
    final box = await _getBox();
    await box.put(card.id, card);
  }

  Future<void> deleteCard(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Future<LoyaltyCard?> getCard(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  Future<void> clearAllCards() async {
    final box = await _getBox();
    await box.clear();
  }

  // --- CLOUD FIRESTORE METHODS ---

  Future<void> uploadCardToCloud(LoyaltyCard card) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('loyalty_cards')
        .doc(card.id)
        .set(card.toJson());
  }

  Future<void> updateCardInCloud(LoyaltyCard card) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('loyalty_cards')
        .doc(card.id)
        .update(card.toJson());
  }

  Future<void> deleteCardFromCloud(String id) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('loyalty_cards')
        .doc(id)
        .delete();
  }

  Future<List<LoyaltyCard>> fetchCardsFromCloud() async {
    if (_uid == null) return [];
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('loyalty_cards')
        .get();
    return snapshot.docs
        .map((doc) => LoyaltyCard.fromJson(doc.data()))
        .toList();
  }

  /// Fetch all cards from Firestore and save/overwrite them in Hive.
  Future<void> syncFromCloudToLocal() async {
    final cloudCards = await fetchCardsFromCloud();
    final box = await _getBox();
    for (final card in cloudCards) {
      await box.put(card.id, card);
    }
  }
}


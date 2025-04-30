import 'package:hive/hive.dart';

part 'loyalty_card.g.dart';

@HiveType(typeId: 0)
class LoyaltyCard extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String cardName;

  @HiveField(2)
  String cardNumber;

  @HiveField(3)
  String barcodeData;

  @HiveField(4)
  String barcodeType;

  @HiveField(5)
  DateTime? expirationDate;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  String? imagePath;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  @HiveField(10)
  bool isSynced;

  LoyaltyCard({
    required this.id,
    required this.cardName,
    required this.cardNumber,
    required this.barcodeData,
    required this.barcodeType,
    this.expirationDate,
    this.notes,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'cardName': cardName,
    'cardNumber': cardNumber,
    'barcodeData': barcodeData,
    'barcodeType': barcodeType,
    'expirationDate': expirationDate?.toIso8601String(),
    'notes': notes,
    'imagePath': imagePath,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isSynced': isSynced,
  };

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) => LoyaltyCard(
    id: json['id'] as String,
    cardName: json['cardName'] as String,
    cardNumber: json['cardNumber'] as String,
    barcodeData: json['barcodeData'] as String,
    barcodeType: json['barcodeType'] as String,
    expirationDate: json['expirationDate'] != null ? DateTime.parse(json['expirationDate']) : null,
    notes: json['notes'] as String?,
    imagePath: json['imagePath'] as String?,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    isSynced: json['isSynced'] ?? false,
  );
}

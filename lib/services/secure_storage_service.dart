import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureStorageService {
  static final _secureStorage = FlutterSecureStorage();
  static const _keyName = 'encryptionKey';

  // Generate or retrieve the encryption key
  static Future<encrypt.Key> getEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: _keyName);
    if (keyString == null) {
      final key = encrypt.Key.fromSecureRandom(32);
      await _secureStorage.write(key: _keyName, value: base64UrlEncode(key.bytes));
      return key;
    }
    return encrypt.Key(base64Url.decode(keyString));
  }

  // Encrypt data
  static Future<String> encryptField(String data) async {
    final key = await getEncryptionKey();
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    // Store IV with ciphertext (base64: iv:ciphertext)
    return base64UrlEncode(iv.bytes) + ':' + encrypted.base64;
  }

  // Decrypt data
  static Future<String> decryptField(String encryptedData) async {
    final key = await getEncryptionKey();
    final parts = encryptedData.split(':');
    if (parts.length != 2) throw Exception('Invalid encrypted data');
    final iv = encrypt.IV(base64Url.decode(parts[0]));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(parts[1], iv: iv);
    return decrypted;
  }
}

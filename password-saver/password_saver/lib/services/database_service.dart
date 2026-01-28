import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_saver/models/password_entry.dart';
import 'package:password_saver/services/encryption_service.dart';

class DatabaseService {
  static const String boxName = 'password_box';
  late Box<PasswordEntry> _box;
  final EncryptionService _encryptionService = EncryptionService();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PasswordEntryAdapter());
    _box = await Hive.openBox<PasswordEntry>(boxName);
  }

  Future<void> addPassword(String place, String username, String password, {String? customFieldLabel, String? customField}) async {
    final encrypted = _encryptionService.encryptPassword(password);
    final entry = PasswordEntry(
      place: place,
      username: username,
      password: encrypted,
      createdAt: DateTime.now(),
      customFieldLabel: customFieldLabel,
      customField: customField,
    );
    await _box.add(entry);
  }

  List<PasswordEntry> getAllPasswords() {
    final entries = _box.values.toList();
    // Decrypt passwords for display
    for (var entry in entries) {
      try {
        entry.password = _encryptionService.decryptPassword(entry.password);
      } catch (e) {
        // Password already decrypted or invalid
      }
    }
    return entries;
  }

  PasswordEntry? getPassword(int index) {
    if (index < _box.length) {
      final entry = _box.getAt(index);
      if (entry != null) {
        try {
          entry.password = _encryptionService.decryptPassword(entry.password);
        } catch (e) {
          // Password already decrypted
        }
      }
      return entry;
    }
    return null;
  }

  Future<void> updatePassword(int index, String place, String username, String password, {String? customFieldLabel, String? customField}) async {
    if (index < _box.length) {
      final encrypted = _encryptionService.encryptPassword(password);
      final entry = PasswordEntry(
        place: place,
        username: username,
        password: encrypted,
        createdAt: DateTime.now(),
        customFieldLabel: customFieldLabel,
        customField: customField,
      );
      await _box.putAt(index, entry);
    }
  }

  Future<void> deletePassword(int index) async {
    if (index < _box.length) {
      await _box.deleteAt(index);
    }
  }

  List<PasswordEntry> searchPasswords(String query) {
    final allPasswords = getAllPasswords();
    return allPasswords
        .where((entry) =>
            entry.place.toLowerCase().contains(query.toLowerCase()) ||
            entry.username.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  int get passwordCount => _box.length;

  Future<void> clearAll() async {
    await _box.clear();
  }
}

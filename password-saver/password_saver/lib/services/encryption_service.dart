import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  late encrypt.Key _key;
  late encrypt.IV _iv;

  EncryptionService() {
    // Generate a fixed key for local storage (in production, use secure key management)
    _key = encrypt.Key.fromBase64('PQvbP+VgKkVBJ4WD1LN5XCWK9aqLb5YTGNxjU2nVZg0=');
    _iv = encrypt.IV.fromBase64('1234567890123456');
  }

  String encryptPassword(String password) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(password, iv: _iv);
    return encrypted.base64;
  }

  String decryptPassword(String encryptedPassword) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: _iv);
    return decrypted;
  }
}

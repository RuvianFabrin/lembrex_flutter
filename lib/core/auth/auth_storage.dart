import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'jwt_token';
  static const _keyUsuario = 'usuario_json';
  static const _keyPin = 'app_pin';
  static const _keyEmail = 'usuario_email';

  static Future<void> salvarSessao(
    String token,
    Map<String, dynamic> usuario,
  ) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyUsuario, value: jsonEncode(usuario));
    // Salva email para exibir na tela de lock
    final email = usuario['email'] as String?;
    if (email != null) {
      await _storage.write(key: _keyEmail, value: email);
    }
  }

  static Future<String?> lerToken() => _storage.read(key: _keyToken);
  static Future<String?> lerUsuario() => _storage.read(key: _keyUsuario);
  static Future<String?> lerEmail() => _storage.read(key: _keyEmail);

  // PIN local de desbloqueio (usado no Linux como fallback de biometria)
  static Future<void> salvarPin(String pin) =>
      _storage.write(key: _keyPin, value: pin);

  static Future<bool> pinDefinido() async =>
      (await _storage.read(key: _keyPin)) != null;

  static Future<bool> validarPin(String pin) async =>
      (await _storage.read(key: _keyPin)) == pin;

  static Future<void> limpar() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUsuario);
    await _storage.delete(key: _keyEmail);
    // PIN mantido intencionalmente — pertence ao dispositivo, não à sessão
  }
}

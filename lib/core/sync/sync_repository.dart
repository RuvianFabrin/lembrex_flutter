import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../auth/auth_storage.dart';
import '../database/app_database.dart';

class SyncException implements Exception {
  final String mensagem;
  const SyncException(this.mensagem);
  @override
  String toString() => 'SyncException: $mensagem';
}

class SyncRepository {
  final String baseUrl;

  const SyncRepository({required this.baseUrl});

  Future<Map<String, String>> get _headers async {
    final token = await AuthStorage.lerToken();
    return {
      'Authorization': 'Bearer ${token ?? ''}',
      'Content-Type': 'application/json',
      'X-App-Client': 'lembrex-flutter/1.0',
    };
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final uri = Uri.parse('$base$path');
    return query != null ? uri.replace(queryParameters: query) : uri;
  }

  Future<bool> ping() async {
    try {
      final resp = await http.get(_uri('/api/ping')).timeout(const Duration(seconds: 10));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> push(List<Registro> registros) async {
    if (registros.isEmpty) return;

    // Envia em lotes de 500
    for (var i = 0; i < registros.length; i += 500) {
      final lote = registros.sublist(i, i + 500 > registros.length ? registros.length : i + 500);
      final payload = {'registros': lote.map(_registroParaJson).toList()};
      final body = jsonEncode(payload);

      debugPrint('[SYNC] push ${lote.length} registros');
      debugPrint('[SYNC] payload: $body');

      http.Response resp;
      try {
        resp = await http
            .post(_uri('/api/sync/push'), headers: await _headers, body: body)
            .timeout(const Duration(seconds: 30));
      } catch (e) {
        throw SyncException('Erro de rede no push: $e');
      }

      debugPrint('[SYNC] push status=${resp.statusCode} body=${resp.body}');

      if (resp.statusCode == 401) throw const SyncException('Token inválido (401)');
      if (resp.statusCode >= 500) throw SyncException('Erro no servidor (${resp.statusCode})');
      if (resp.statusCode != 200) throw SyncException('Push falhou (${resp.statusCode})');
    }
  }

  Future<List<Map<String, dynamic>>> pull(DateTime? since) async {
    final query = since != null
        ? {'since': since.toUtc().toIso8601String()}
        : <String, String>{};

    http.Response resp;
    try {
      resp = await http
          .get(_uri('/api/sync/pull', query.isNotEmpty ? query : null), headers: await _headers)
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      throw SyncException('Erro de rede no pull: $e');
    }

    if (resp.statusCode == 401) throw const SyncException('Token inválido (401)');
    if (resp.statusCode >= 500) throw SyncException('Erro no servidor (${resp.statusCode})');
    if (resp.statusCode != 200) throw SyncException('Pull falhou (${resp.statusCode})');

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return (data['registros'] as List).cast<Map<String, dynamic>>();
  }

  static Map<String, dynamic> _registroParaJson(Registro r) => {
        'id': r.id,
        'categoria_id': r.categoriaId,
        'titulo': r.titulo,
        'conteudo': r.conteudo,
        'extras': r.extras,
        'deletado': r.deletado ? 1 : 0,
        'data': r.data?.toUtc().toIso8601String(),
        'lembrete': r.lembrete?.toUtc().toIso8601String(),
        'created_at': r.createdAt.toUtc().toIso8601String(),
        'updated_at': r.updatedAt.toUtc().toIso8601String(),
      };
}

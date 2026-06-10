import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _localScheme = 'local://';

// Caminho relativo ao servidor — portável entre dispositivos.
// Formato: srv://uploads/<registroId>/<id>.<ext>
// Cada dispositivo resolve para http://<baseUrl>/uploads/...
const _srvScheme = 'srv://';

/// Converte um nome de arquivo em URL portável armazenada no JSON do editor.
/// Ex: "foto.jpg" → "local://foto.jpg"
String toLocalUrl(String nomeArquivo) => '$_localScheme$nomeArquivo';

/// Converte um caminho relativo do servidor em URL portável.
/// Ex: "uploads/regId/id.jpg" → "srv://uploads/regId/id.jpg"
String toSrvUrl(String caminho) => '$_srvScheme$caminho';

/// Retorna true se a URL é uma referência local portável.
bool isLocalUrl(String url) => url.startsWith(_localScheme);

/// Retorna true se a URL é um caminho relativo de servidor.
bool isSrvUrl(String url) => url.startsWith(_srvScheme);

/// Resolve "local://nome.jpg" para o path absoluto no dispositivo atual.
Future<String> resolverLocalUrl(String url) async {
  final nome = url.substring(_localScheme.length);
  final dir = await getApplicationDocumentsDirectory();
  return p.join(dir.path, 'anexos', nome);
}

/// Resolve "srv://uploads/regId/id.jpg" para URL absoluta usando o baseUrl.
String resolverSrvUrl(String url, String baseUrl) {
  final caminho = url.substring(_srvScheme.length);
  final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
  return '$base/$caminho';
}

/// Percorre o JSON do documento AppFlowy e normaliza todas as URLs de imagem:
///
/// 1. "srv://uploads/..."            → URL absoluta usando baseUrl
/// 2. "local://nome.jpg"             → path absoluto do dispositivo atual
/// 3. "/data/user/0/.../nome.jpg"    → path absoluto do dispositivo atual (legado)
/// 4. "/home/user/.../nome.jpg"      → path absoluto do dispositivo atual (legado)
/// 5. URLs http(s)://                → mantém como está (imagem no servidor)
///
/// Se o arquivo não existir localmente, mantém a URL original.
Future<Map<String, dynamic>> resolverPathsLocais(
    Map<String, dynamic> docJson, {String? baseUrl}) async {
  final dir = await getApplicationDocumentsDirectory();
  final anexosDir = p.join(dir.path, 'anexos');

  final texto = jsonEncode(docJson);
  final temPathLocal =
      RegExp(r'"url"\s*:\s*"(srv://|local://|/)').hasMatch(texto);
  if (!temPathLocal) return docJson;

  return _resolverNosNodes(docJson, anexosDir, baseUrl);
}

/// Percorre o JSON do documento AppFlowy, faz upload de imagens locais que
/// existem neste dispositivo mas ainda não têm URL de servidor, converte URLs
/// absolutas existentes para o formato portável `srv://`, e retorna o JSON
/// atualizado.
///
/// Retorna (jsonAtualizado, foiModificado).
Future<(Map<String, dynamic>, bool)> migrarPathsLegados({
  required Map<String, dynamic> docJson,
  required String baseUrl,
  required String token,
  required String registroId,
}) async {
  final dir = await getApplicationDocumentsDirectory();
  final anexosDir = p.join(dir.path, 'anexos');
  final texto = jsonEncode(docJson);

  // Processa se houver URL local, path absoluto ou URL absoluta com uploads
  final temMigravel = RegExp(r'"url"\s*:\s*"(srv://|local://|/|http)').hasMatch(texto);
  if (!temMigravel) return (docJson, false);

  bool modificado = false;

  Future<Map<String, dynamic>> processarNode(
      Map<String, dynamic> node) async {
    final resultado = <String, dynamic>{};
    for (final entry in node.entries) {
      if (entry.key == 'url' && entry.value is String) {
        final url = entry.value as String;
        final urlNova =
            await _tentarMigrar(url, anexosDir, baseUrl, token, registroId);
        if (urlNova != url) modificado = true;
        resultado[entry.key] = urlNova;
      } else if (entry.value is Map<String, dynamic>) {
        resultado[entry.key] =
            await processarNode(entry.value as Map<String, dynamic>);
      } else if (entry.value is List) {
        resultado[entry.key] = await _processarLista(
            entry.value as List, processarNode);
      } else {
        resultado[entry.key] = entry.value;
      }
    }
    return resultado;
  }

  final jsonAtualizado = await processarNode(docJson);
  return (jsonAtualizado, modificado);
}

Future<List<dynamic>> _processarLista(
    List<dynamic> lista,
    Future<Map<String, dynamic>> Function(Map<String, dynamic>) fn) async {
  final resultado = <dynamic>[];
  for (final item in lista) {
    if (item is Map<String, dynamic>) {
      resultado.add(await fn(item));
    } else if (item is List) {
      resultado.add(await _processarLista(item, fn));
    } else {
      resultado.add(item);
    }
  }
  return resultado;
}

/// Migra uma URL para o formato portável `srv://`:
/// - URL absoluta http(s) com /uploads/ → extrai caminho relativo → srv://
/// - URL local (local:// ou path absoluto) → faz upload → srv://
/// - Já é srv:// → mantém
/// - Outros → mantém
Future<String> _tentarMigrar(
  String url,
  String anexosDir,
  String baseUrl,
  String token,
  String registroId,
) async {
  // Já no formato portável — nada a fazer
  if (url.startsWith(_srvScheme)) return url;

  // URL absoluta do servidor (http/https) com caminho uploads/ → extrair relativo
  if (url.startsWith('http://') || url.startsWith('https://')) {
    final idx = url.indexOf('/uploads/');
    if (idx != -1) {
      return toSrvUrl(url.substring(idx + 1)); // "uploads/regId/id.ext"
    }
    return url;
  }

  // Arquivo local: faz upload e retorna srv://
  return _tentarUpload(url, anexosDir, baseUrl, token, registroId);
}

/// Tenta fazer upload da URL local para o servidor.
/// Se a URL já é http(s) ou o arquivo não existe localmente, retorna a URL original.
/// Se o upload falhar, retorna a URL original sem quebrar.
Future<String> _tentarUpload(
  String url,
  String anexosDir,
  String baseUrl,
  String token,
  String registroId,
) async {
  // Já é URL do servidor — não precisa de nada
  if (url.startsWith('http://') || url.startsWith('https://')) return url;

  // Resolve o path físico do arquivo
  String pathFisico;
  if (url.startsWith(_localScheme)) {
    pathFisico = p.join(anexosDir, url.substring(_localScheme.length));
  } else if (url.startsWith('/')) {
    // Path absoluto legado: pode estar em anexosDir ou em outro lugar (ex: /home/ru/Imagens/)
    pathFisico = File(p.join(anexosDir, p.basename(url))).existsSync()
        ? p.join(anexosDir, p.basename(url))
        : url;
  } else {
    return url;
  }

  if (!File(pathFisico).existsSync()) return url;

  try {
    final id = _gerarId();
    final ext = p.extension(pathFisico);
    final base =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final uri = Uri.parse('$base/api/anexos/upload');
    final agora = DateTime.now().toIso8601String();

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['X-App-Client'] = 'lembrex-flutter/1.0'
      ..fields['id'] = id
      ..fields['registro_id'] = registroId
      ..fields['created_at'] = agora
      ..fields['updated_at'] = agora
      ..files.add(await http.MultipartFile.fromPath('arquivo', pathFisico));

    final resp =
        await request.send().timeout(const Duration(seconds: 30));
    if (resp.statusCode == 201) {
      // Retorna caminho relativo portável, não URL absoluta
      return toSrvUrl('uploads/$registroId/$id$ext');
    }
  } catch (_) {}

  return url;
}

Map<String, dynamic> _resolverNosNodes(
    Map<String, dynamic> node, String anexosDir, String? baseUrl) {
  final resultado = <String, dynamic>{};
  for (final entry in node.entries) {
    if (entry.key == 'url' && entry.value is String) {
      resultado[entry.key] =
          _normalizarUrl(entry.value as String, anexosDir, baseUrl);
    } else if (entry.value is Map<String, dynamic>) {
      resultado[entry.key] =
          _resolverNosNodes(entry.value as Map<String, dynamic>, anexosDir, baseUrl);
    } else if (entry.value is List) {
      resultado[entry.key] = _resolverNaLista(entry.value as List, anexosDir, baseUrl);
    } else {
      resultado[entry.key] = entry.value;
    }
  }
  return resultado;
}

List<dynamic> _resolverNaLista(List<dynamic> lista, String anexosDir, String? baseUrl) {
  return lista.map((item) {
    if (item is Map<String, dynamic>) return _resolverNosNodes(item, anexosDir, baseUrl);
    if (item is List) return _resolverNaLista(item, anexosDir, baseUrl);
    return item;
  }).toList();
}

String _normalizarUrl(String url, String anexosDir, String? baseUrl) {
  // URL absoluta http(s) — mantém (já resolvida ou externa)
  if (url.startsWith('http://') || url.startsWith('https://')) return url;

  // Caminho relativo do servidor → resolve para URL absoluta com baseUrl
  if (url.startsWith(_srvScheme)) {
    if (baseUrl != null && baseUrl.isNotEmpty) {
      return resolverSrvUrl(url, baseUrl);
    }
    return url; // sem baseUrl não resolve, mantém como está
  }

  String nomeArquivo;
  if (url.startsWith(_localScheme)) {
    nomeArquivo = url.substring(_localScheme.length);
  } else if (url.startsWith('/')) {
    nomeArquivo = p.basename(url);
  } else {
    return url;
  }

  // Tenta na pasta anexos do app
  final pathLocal = p.join(anexosDir, nomeArquivo);
  if (File(pathLocal).existsSync()) return pathLocal;

  // Path absoluto legado fora da pasta anexos (ex: /home/ru/Imagens/x.png)
  if (url.startsWith('/') && File(url).existsSync()) return url;

  return url;
}

String _gerarId() {
  final agora = DateTime.now();
  String d(int v) => v.toString().padLeft(2, '0');
  return '${agora.year}${d(agora.month)}${d(agora.day)}'
      '${d(agora.hour)}${d(agora.minute)}${d(agora.second)}'
      '${agora.microsecond.toString().padLeft(6, '0')}';
}

/// Verifica se o arquivo local existe no dispositivo.
Future<bool> arquivoLocalExiste(String nomeArquivo) async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, 'anexos', nomeArquivo)).exists();
}

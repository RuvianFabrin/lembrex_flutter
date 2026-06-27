import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../auth/auth_storage.dart';
import 'imagem_path_utils.dart';

/// Copia um arquivo de imagem para a pasta local de anexos do app.
/// Retorna o path absoluto da cópia, ou null em caso de erro.
Future<String?> copiarImagemParaLocal(String origem, String? ext) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final pasta = Directory(p.join(dir.path, 'anexos'));
    if (!await pasta.exists()) await pasta.create(recursive: true);
    final sufixo = ext != null && ext.isNotEmpty ? '.$ext' : '';
    final destino = p.join(pasta.path, '${gerarIdImagem()}$sufixo');
    await File(origem).copy(destino);
    return destino;
  } catch (_) {
    return null;
  }
}

/// Faz upload de uma imagem para o servidor e retorna a URL portável `srv://`.
/// Retorna null se offline, sem token, ou se o upload falhar.
Future<String?> uploadImagemParaServidor({
  required String caminho,
  required String id,
  required String registroId,
  required String baseUrl,
  String? mimeType,
}) async {
  try {
    final token = await AuthStorage.lerToken();
    if (token == null) return null;

    final base =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final uri = Uri.parse('$base/api/anexos/upload');
    final agora = DateTime.now().toIso8601String();
    final ext = p.extension(caminho);

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['X-App-Client'] = 'lembrex-flutter/1.0'
      ..fields['id'] = id
      ..fields['registro_id'] = registroId
      ..fields['created_at'] = agora
      ..fields['updated_at'] = agora
      ..files.add(await http.MultipartFile.fromPath(
        'arquivo',
        caminho,
        contentType: mimeType != null ? _parseMime(mimeType) : null,
      ));

    final streamed = await request.send().timeout(const Duration(seconds: 30));
    if (streamed.statusCode == 201) {
      return toSrvUrl('uploads/$registroId/$id$ext');
    }
    return null;
  } catch (_) {
    return null;
  }
}

/// Gera ID único baseado em timestamp com microsegundos.
String gerarIdImagem() {
  final agora = DateTime.now();
  String d(int v) => v.toString().padLeft(2, '0');
  return '${agora.year}${d(agora.month)}${d(agora.day)}'
      '${d(agora.hour)}${d(agora.minute)}${d(agora.second)}'
      '${agora.microsecond.toString().padLeft(6, '0')}';
}

http.MediaType? _parseMime(String mime) {
  final parts = mime.split('/');
  if (parts.length == 2) return http.MediaType(parts[0], parts[1]);
  return null;
}

String mimeDeExtensao(String? ext) {
  switch (ext?.toLowerCase()) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    default:
      return 'image/jpeg';
  }
}

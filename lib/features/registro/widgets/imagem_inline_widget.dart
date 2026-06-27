import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/auth/auth_storage.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/imagem_path_utils.dart';
import '../../../core/utils/platform_utils.dart';
import '../../configuracoes/configuracoes_provider.dart';

/// Botão na toolbar do editor rico que permite inserir uma imagem inline.
/// No desktop usa FilePicker; no mobile usa ImagePicker (galeria/câmera).
/// Tenta upload imediato para o servidor e usa URL portável no imageNode.
/// Se offline, usa path local como fallback (só funciona neste dispositivo).
class ImagemInlineWidget extends ConsumerStatefulWidget {
  final EditorState editorState;
  final String registroId;
  // Último caminho do cursor antes do foco sair — garante inserção no lugar certo
  final List<int>? lastCursorPath;

  const ImagemInlineWidget({
    super.key,
    required this.editorState,
    required this.registroId,
    this.lastCursorPath,
  });

  @override
  ConsumerState<ImagemInlineWidget> createState() => _ImagemInlineWidgetState();
}

class _ImagemInlineWidgetState extends ConsumerState<ImagemInlineWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.image_outlined, size: 18),
            label: const Text('Inserir imagem'),
            onPressed: _inserirImagem,
          ),
        ],
      ),
    );
  }

  Future<void> _inserirImagem() async {
    final (caminhoCopia, mimeType) = isDesktop
        ? await _selecionarDesktop()
        : await _selecionarMobile();

    if (caminhoCopia == null || !mounted) return;

    final id = _gerarId();

    // Captura ref-dependentes antes de qualquer await
    final db = ref.read(databaseProvider);
    final cfg = ref.read(configuracoesProvider).valueOrNull;

    String? urlServidor;
    if (cfg != null) {
      urlServidor = await _uploadParaServidor(
        caminhoCopia: caminhoCopia,
        id: id,
        mimeType: mimeType,
        baseUrl: cfg.apiUrl,
      );
    }

    if (!mounted) return;

    final nomeArquivo = p.basename(caminhoCopia);
    final agora = DateTime.now().toIso8601String();
    await db.anexosDao.inserir(
      AnexosCompanion.insert(
        id: id,
        registroId: widget.registroId.isEmpty ? id : widget.registroId,
        nomeArquivo: nomeArquivo,
        caminhoLocal: nomeArquivo, // só o nome — cada dispositivo resolve o path
        mimeType: Value(mimeType),
        tamanhoBytes: Value(await File(caminhoCopia).length()),
        sincronizado: Value(urlServidor != null),
        createdAt: agora,
        updatedAt: agora,
      ),
    );

    // URL do servidor se disponível; caso contrário URL local portável
    final urlPortavel = urlServidor ?? toLocalUrl(nomeArquivo);

    // Resolve srv:// → URL absoluta para renderização imediata no editor
    final baseUrl = cfg?.apiUrl;
    final urlImagem =
        isSrvUrl(urlPortavel) && baseUrl != null && baseUrl.isNotEmpty
            ? resolverSrvUrl(urlPortavel, baseUrl)
            : urlPortavel;

    _inserirBlocoImagem(urlImagem);
  }

  Future<(String?, String?)> _selecionarDesktop() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return (null, null);

    final picked = result.files.first;
    if (picked.path == null) return (null, null);

    final caminhoCopia = await _copiarParaLocal(picked.path!, picked.extension);
    final mime = _mimeDeExtensao(picked.extension);
    return (caminhoCopia, mime);
  }

  Future<(String?, String?)> _selecionarMobile() async {
    if (!mounted) return (null, null);
    final origem = await _escolherOrigemMobile();
    if (origem == null) return (null, null);

    final XFile? arquivo = await ImagePicker().pickImage(source: origem);
    if (arquivo == null) return (null, null);

    final caminhoCopia = await _copiarParaLocal(
      arquivo.path,
      p.extension(arquivo.path).replaceFirst('.', ''),
    );
    return (caminhoCopia, arquivo.mimeType);
  }

  Future<ImageSource?> _escolherOrigemMobile() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Câmera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _copiarParaLocal(String origem, String? ext) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final pasta = Directory(p.join(dir.path, 'anexos'));
      if (!await pasta.exists()) await pasta.create(recursive: true);
      final sufixo = ext != null && ext.isNotEmpty ? '.$ext' : '';
      final destino = p.join(pasta.path, '${_gerarId()}$sufixo');
      await File(origem).copy(destino);
      return destino;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _uploadParaServidor({
    required String caminhoCopia,
    required String id,
    required String? mimeType,
    required String baseUrl,
  }) async {
    try {
      final token = await AuthStorage.lerToken();
      if (token == null) return null;

      final base = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;
      final uri = Uri.parse('$base/api/anexos/upload');
      final agora = DateTime.now().toIso8601String();
      final regId = widget.registroId.isEmpty ? id : widget.registroId;

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['X-App-Client'] = 'lembrex-flutter/1.0'
        ..fields['id'] = id
        ..fields['registro_id'] = regId
        ..fields['created_at'] = agora
        ..fields['updated_at'] = agora
        ..files.add(await http.MultipartFile.fromPath(
          'arquivo',
          caminhoCopia,
          contentType: mimeType != null ? _parseMime(mimeType) : null,
        ));

      final streamed =
          await request.send().timeout(const Duration(seconds: 30));
      if (streamed.statusCode == 201) {
        final ext = p.extension(caminhoCopia);
        // Retorna caminho relativo portável — cada dispositivo resolve com seu baseUrl
        return toSrvUrl('uploads/$regId/$id$ext');
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  http.MediaType? _parseMime(String mime) {
    final parts = mime.split('/');
    if (parts.length == 2) return http.MediaType(parts[0], parts[1]);
    return null;
  }

  String _mimeDeExtensao(String? ext) {
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

  void _inserirBlocoImagem(String url) {
    final selection = widget.editorState.selection;
    // Usa: seleção atual > lastCursorPath salvo > final do documento
    final path = selection?.end.path ??
        widget.lastCursorPath ??
        [widget.editorState.document.root.children.length];

    final imagemNode = imageNode(url: url);
    final transaction = widget.editorState.transaction;
    transaction.insertNode(path, imagemNode);
    widget.editorState.apply(transaction);
  }

  String _gerarId() {
    final agora = DateTime.now();
    return '${agora.year}${_d(agora.month)}${_d(agora.day)}'
        '${_d(agora.hour)}${_d(agora.minute)}${_d(agora.second)}'
        '${agora.microsecond.toString().padLeft(6, '0')}';
  }

  String _d(int v) => v.toString().padLeft(2, '0');
}

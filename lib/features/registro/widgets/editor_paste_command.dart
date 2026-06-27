import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/clipboard_imagem_desktop.dart';
import '../../../core/utils/imagem_path_utils.dart';
import '../../../core/utils/imagem_upload_utils.dart';
import '../../../core/utils/platform_utils.dart';

/// Substitui o [pasteCommand] padrão do AppFlowy.
///
/// Desktop (Windows / Linux):
///   • Clipboard tem PNG → salva em temp, faz upload e insere bloco de imagem.
///   • Caso contrário  → delega ao comportamento padrão AppFlowy (texto/HTML).
///
/// Não usa super_clipboard / super_native_extensions (conflito TSF no Windows).
/// A leitura de imagem usa Win32 FFI no Windows e xclip/wl-clipboard no Linux.
CommandShortcutEvent buildPasteComImagemCommand({
  required String registroId,
  required String Function() getRegistroId,
  required String? Function() getBaseUrl,
}) {
  return CommandShortcutEvent(
    key: 'paste the content',
    getDescription: () => 'Colar (com suporte a imagem)',
    command: 'ctrl+v',
    macOSCommand: 'cmd+v',
    handler: (editorState) {
      _handlePasteAsync(editorState, getRegistroId, getBaseUrl);
      return KeyEventResult.handled;
    },
  );
}

Future<void> _handlePasteAsync(
  EditorState editorState,
  String Function() getRegistroId,
  String? Function() getBaseUrl,
) async {
  // Leitura de imagem do clipboard só faz sentido no desktop
  if (isDesktop) {
    // Verificação síncrona rápida no Windows; no Linux tenta ler diretamente
    final temImagem =
        Platform.isWindows ? temImagemPngNoClipboard() : true;

    if (temImagem) {
      final pngBytes = await lerPngDoClipboard();
      if (pngBytes != null && pngBytes.isNotEmpty) {
        await _inserirImagemDeBytes(
            editorState, pngBytes, getRegistroId, getBaseUrl);
        return;
      }
    }
  }

  // Sem imagem — comportamento padrão do AppFlowy (texto / HTML)
  handlePaste(editorState);
}

Future<void> _inserirImagemDeBytes(
  EditorState editorState,
  List<int> pngBytes,
  String Function() getRegistroId,
  String? Function() getBaseUrl,
) async {
  final tmpDir = await getTemporaryDirectory();
  final id = gerarIdImagem();
  final tmpPath = p.join(tmpDir.path, '$id.png');
  await File(tmpPath).writeAsBytes(pngBytes);

  final regId = getRegistroId();
  final baseUrl = getBaseUrl();
  String? url;

  if (baseUrl != null && baseUrl.isNotEmpty) {
    url = await uploadImagemParaServidor(
      caminho: tmpPath,
      id: id,
      registroId: regId.isEmpty ? id : regId,
      baseUrl: baseUrl,
    );
  }
  url ??= toLocalUrl(p.basename(tmpPath));

  final urlExibicao =
      isSrvUrl(url) && baseUrl != null && baseUrl.isNotEmpty
          ? resolverSrvUrl(url, baseUrl)
          : url;

  final selection = editorState.selection;
  final path =
      selection?.end.path ?? [editorState.document.root.children.length];
  final transaction = editorState.transaction
    ..insertNode(path, imageNode(url: urlExibicao));
  editorState.apply(transaction);
}

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../../core/utils/imagem_path_utils.dart';
import '../../../core/utils/imagem_upload_utils.dart';

const _imagensSuportadas = {'.jpg', '.jpeg', '.png', '.webp', '.gif'};

/// Envolve o AppFlowyEditor com suporte a drag & drop de arquivos do SO.
///
/// - Ao arrastar sobre o editor: mostra a linha de drop do AppFlowy
/// - Ao soltar uma imagem: faz upload e insere o bloco no nó mais próximo
/// - Ao sair da área: remove a linha de drop
class EditorDropZone extends StatefulWidget {
  final Widget child;
  final EditorState editorState;
  final String Function() getRegistroId;
  final String? Function() getBaseUrl;

  const EditorDropZone({
    super.key,
    required this.child,
    required this.editorState,
    required this.getRegistroId,
    required this.getBaseUrl,
  });

  @override
  State<EditorDropZone> createState() => _EditorDropZoneState();
}

class _EditorDropZoneState extends State<EditorDropZone> {
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragUpdated: (details) {
        widget.editorState.service.selectionService
            .renderDropTargetForOffset(details.globalPosition);
      },
      onDragExited: (_) {
        widget.editorState.service.selectionService.removeDropTarget();
      },
      onDragDone: (details) {
        _processarArquivosSoltos(details);
      },
      child: widget.child,
    );
  }

  Future<void> _processarArquivosSoltos(DropDoneDetails details) async {
    // Captura o nó alvo antes de remover a linha guia
    Node? targetNode;
    try {
      final dropData = widget.editorState.service.selectionService
          .getDropTargetRenderData(details.globalPosition);
      widget.editorState.service.selectionService.removeDropTarget();
      targetNode = dropData?.dropTarget;
    } catch (_) {
      try {
        widget.editorState.service.selectionService.removeDropTarget();
      } catch (_) {}
    }

    final imagens = details.files
        .where((f) => _imagensSuportadas
            .contains(p.extension(f.path).toLowerCase()))
        .toList();
    if (imagens.isEmpty) return;

    final insertPath = targetNode?.path ??
        [widget.editorState.document.root.children.length];

    // Insere as imagens em sequência no path alvo
    var currentPath = insertPath;
    for (final xfile in imagens) {
      final ext = p.extension(xfile.path).replaceFirst('.', '');
      final id = gerarIdImagem();
      final caminhoCopia = await copiarImagemParaLocal(xfile.path, ext);
      if (caminhoCopia == null) continue;

      final baseUrl = widget.getBaseUrl();
      final regId = widget.getRegistroId();
      String? url;
      if (baseUrl != null && baseUrl.isNotEmpty) {
        url = await uploadImagemParaServidor(
          caminho: caminhoCopia,
          id: id,
          registroId: regId.isEmpty ? id : regId,
          baseUrl: baseUrl,
          mimeType: mimeDeExtensao(ext),
        );
      }
      url ??= toLocalUrl(p.basename(caminhoCopia));

      // Resolve srv:// → URL absoluta para renderização imediata no editor
      final baseUrlAtual = widget.getBaseUrl();
      final urlExibicao =
          isSrvUrl(url) && baseUrlAtual != null && baseUrlAtual.isNotEmpty
              ? resolverSrvUrl(url, baseUrlAtual)
              : url;

      if (!mounted) return;
      final transaction = widget.editorState.transaction
        ..insertNode(currentPath, imageNode(url: urlExibicao));
      await widget.editorState.apply(transaction);

      // Próxima imagem vai imediatamente após a que acabou de ser inserida
      if (currentPath.length == 1) {
        currentPath = [currentPath.first + 1];
      } else {
        currentPath = [
          ...currentPath.sublist(0, currentPath.length - 1),
          currentPath.last + 1,
        ];
      }
    }
  }
}

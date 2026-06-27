import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/clipboard_imagem_desktop.dart';
import '../../../core/utils/imagem_path_utils.dart';
import '../../../core/utils/platform_utils.dart';
import 'imagem_context_menu_widget.dart';

/// Substitui o builder padrão de imagem no AppFlowy.
/// Envolve o widget de imagem original com [ImagemContextMenu]:
/// - Desktop : clique direito → popup
/// - Mobile  : toque longo  → BottomSheet
class ImagemComMenuBuilder extends BlockComponentBuilder {
  ImagemComMenuBuilder({super.configuration});

  @override
  BlockComponentWidget build(BlockComponentContext blockComponentContext) {
    final node = blockComponentContext.node;
    return _ImagemWrapper(
      key: node.key,
      node: node,
      showActions: showActions(node),
      configuration: configuration,
      actionBuilder: (ctx, state) =>
          actionBuilder(blockComponentContext, state),
    );
  }

  @override
  bool validate(Node node) => node.delta == null && node.children.isEmpty;
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget wrapper: delega tudo ao ImageBlockComponentWidget mas envolve com
// GestureDetector para capturar clique direito / long press.
// ─────────────────────────────────────────────────────────────────────────────

class _ImagemWrapper extends BlockComponentStatefulWidget {
  const _ImagemWrapper({
    super.key,
    required super.node,
    super.showActions,
    super.actionBuilder,
    super.configuration = const BlockComponentConfiguration(),
  });

  @override
  State<_ImagemWrapper> createState() => _ImagemWrapperState();
}

class _ImagemWrapperState extends State<_ImagemWrapper>
    with SelectableMixin, BlockComponentConfigurable {
  @override
  BlockComponentConfiguration get configuration => widget.configuration;

  @override
  Node get node => widget.node;

  String get _url =>
      (node.attributes[ImageBlockKeys.url] as String?) ?? '';

  // Delegamos SelectableMixin para o state interno via GlobalKey
  final _innerKey = GlobalKey<ImageBlockComponentWidgetState>();

  @override
  Widget build(BuildContext context) {
    final inner = ImageBlockComponentWidget(
      key: _innerKey,
      node: node,
      showActions: widget.showActions,
      configuration: configuration,
      actionBuilder: widget.actionBuilder,
      showMenu: false,
    );

    return ImagemContextMenu(
      onSalvar: () => _salvarImagem(context),
      onCopiar: () => _copiarImagem(context),
      child: inner,
    );
  }

  // ── SelectableMixin — delega ao estado interno quando disponível ──────────

  @override
  Position start() =>
      _innerKey.currentState?.start() ??
      Position(path: node.path, offset: 0);

  @override
  Position end() =>
      _innerKey.currentState?.end() ??
      Position(path: node.path, offset: 1);

  @override
  Position getPositionInOffset(Offset start) =>
      _innerKey.currentState?.getPositionInOffset(start) ?? end();

  @override
  bool get shouldCursorBlink => false;

  @override
  CursorStyle get cursorStyle => CursorStyle.cover;

  @override
  Rect getBlockRect({bool shiftWithBaseOffset = false}) =>
      _innerKey.currentState
          ?.getBlockRect(shiftWithBaseOffset: shiftWithBaseOffset) ??
      Rect.zero;

  @override
  Rect? getCursorRectInPosition(Position position,
          {bool shiftWithBaseOffset = false}) =>
      _innerKey.currentState?.getCursorRectInPosition(position,
          shiftWithBaseOffset: shiftWithBaseOffset);

  @override
  List<Rect> getRectsInSelection(Selection selection,
          {bool shiftWithBaseOffset = false}) =>
      _innerKey.currentState?.getRectsInSelection(selection,
          shiftWithBaseOffset: shiftWithBaseOffset) ??
      [];

  @override
  Selection getSelectionInRange(Offset start, Offset end) =>
      _innerKey.currentState?.getSelectionInRange(start, end) ??
      Selection.single(path: node.path, startOffset: 0, endOffset: 1);

  @override
  Offset localToGlobal(Offset offset, {bool shiftWithBaseOffset = false}) =>
      _innerKey.currentState?.localToGlobal(offset,
          shiftWithBaseOffset: shiftWithBaseOffset) ??
      (context.findRenderObject() as RenderBox).localToGlobal(offset);

  // ── Salvar imagem ─────────────────────────────────────────────────────────

  Future<void> _salvarImagem(BuildContext ctx) async {
    try {
      final bytes = await _baixarBytes(_url);
      if (!ctx.mounted) return;
      if (bytes == null) {
        _snack(ctx, 'Não foi possível carregar a imagem.');
        return;
      }
      if (isDesktop) {
        await _salvarDesktop(ctx, bytes);
      } else {
        await _salvarAndroid(ctx, bytes);
      }
    } catch (e) {
      if (ctx.mounted) _snack(ctx, 'Erro ao salvar: $e');
    }
  }

  Future<void> _salvarDesktop(BuildContext ctx, Uint8List bytes) async {
    final ext = _extDaUrl(_url);
    final destino = await FilePicker.platform.saveFile(
      dialogTitle: 'Salvar imagem',
      fileName: 'imagem$ext',
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      type: FileType.image,
    );
    if (destino == null) return;
    await File(destino).writeAsBytes(bytes);
    if (ctx.mounted) _snack(ctx, 'Imagem salva!');
  }

  Future<void> _salvarAndroid(BuildContext ctx, Uint8List bytes) async {
    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      if (ctx.mounted) _snack(ctx, 'Não foi possível acessar o armazenamento.');
      return;
    }
    final pasta = Directory(
        p.join(dir.path, '..', '..', '..', '..', 'Pictures', 'Lembrex'));
    if (!await pasta.exists()) await pasta.create(recursive: true);
    final nome =
        'lembrex_${DateTime.now().millisecondsSinceEpoch}${_extDaUrl(_url)}';
    await File(p.join(pasta.path, nome)).writeAsBytes(bytes);
    if (ctx.mounted) _snack(ctx, 'Imagem salva em Imagens/Lembrex/');
  }

  // ── Copiar imagem ─────────────────────────────────────────────────────────

  Future<void> _copiarImagem(BuildContext ctx) async {
    try {
      final bytes = await _baixarBytes(_url);
      if (!ctx.mounted) return;
      if (bytes == null) {
        _snack(ctx, 'Não foi possível carregar a imagem.');
        return;
      }

      // Converte para PNG se necessário (a API de clipboard aceita PNG)
      final pngBytes = _extDaUrl(_url).toLowerCase() == '.png'
          ? bytes
          : await _converterParaPng(bytes);

      final ok = await escreverPngNoClipboard(pngBytes);
      if (ctx.mounted) {
        _snack(ctx, ok ? 'Imagem copiada!' : 'Clipboard não disponível.');
      }
    } catch (e) {
      if (ctx.mounted) _snack(ctx, 'Erro ao copiar: $e');
    }
  }

  /// Converte bytes JPEG/WEBP para PNG usando dart:ui.
  Future<Uint8List> _converterParaPng(Uint8List src) async {
    final codec = await ui.instantiateImageCodec(src);
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(
        format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? src;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<Uint8List?> _baixarBytes(String src) async {
    if (src.startsWith('http://') || src.startsWith('https://')) {
      final resp =
          await http.get(Uri.parse(src)).timeout(const Duration(seconds: 20));
      if (resp.statusCode == 200) return resp.bodyBytes;
      return null;
    }
    // Caminho absoluto Unix (/...) ou Windows (\... ou C:\...)
    if (src.startsWith('/') || src.startsWith(r'\') || _ePathWindowsAbsoluto(src)) {
      final f = File(src);
      if (await f.exists()) return f.readAsBytes();
    }
    if (isLocalUrl(src)) {
      final path = await resolverLocalUrl(src);
      final f = File(path);
      if (await f.exists()) return f.readAsBytes();
    }
    return null;
  }

  /// Retorna true para caminhos Windows como "C:\..." ou "C:/..."
  bool _ePathWindowsAbsoluto(String src) =>
      src.length >= 3 && src[1] == ':' && (src[2] == r'\' || src[2] == '/');


  String _extDaUrl(String src) {
    final ext = p.extension(src.split('?').first);
    return ext.isNotEmpty ? ext : '.jpg';
  }

  void _snack(BuildContext ctx, String msg) {
    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
    );
  }
}


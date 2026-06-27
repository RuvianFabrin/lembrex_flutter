import 'package:flutter/gestures.dart' show kSecondaryMouseButton;
import 'package:flutter/material.dart';

import '../../../core/utils/platform_utils.dart';

/// Envolve uma imagem do editor com menu de contexto:
/// - Mobile: toque longo → BottomSheet
/// - Desktop: clique direito → menu popup
class ImagemContextMenu extends StatelessWidget {
  final Widget child;
  final VoidCallback onSalvar;
  final VoidCallback onCopiar;

  const ImagemContextMenu({
    super.key,
    required this.child,
    required this.onSalvar,
    required this.onCopiar,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      // Listener opera antes do GestureDetector do AppFlowy — captura o
      // botão direito sem ser consumido pelo editor.
      return Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          if (event.buttons == kSecondaryMouseButton) {
            _mostrarMenuDesktop(context, event.position);
          }
        },
        child: child,
      );
    }
    return GestureDetector(
      onLongPress: () => _mostrarBottomSheetMobile(context),
      child: child,
    );
  }

  void _mostrarMenuDesktop(BuildContext context, Offset position) {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(value: 'salvar', child: _ItemMenu(Icons.download_outlined, 'Salvar imagem')),
        const PopupMenuItem(value: 'copiar', child: _ItemMenu(Icons.copy_outlined, 'Copiar imagem')),
      ],
    ).then((value) {
      if (value == 'salvar') onSalvar();
      if (value == 'copiar') onCopiar();
    });
  }

  void _mostrarBottomSheetMobile(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Salvar imagem'),
              onTap: () {
                Navigator.pop(ctx);
                onSalvar();
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Copiar imagem'),
              onTap: () {
                Navigator.pop(ctx);
                onCopiar();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ItemMenu(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

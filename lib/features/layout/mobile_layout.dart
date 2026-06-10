import 'package:flutter/material.dart';

import '../configuracoes/configuracoes_page.dart';
import '../dashboard/dashboard_page.dart';
import '../registro/registro_list_page.dart';

class _Cat {
  final String id;
  final String label;
  final String emoji;
  const _Cat(this.id, this.label, this.emoji);
}

const _categorias = [
  _Cat('CAT001', 'Nota Livre', '📝'),
  _Cat('CAT002', 'Evento', '📅'),
  _Cat('CAT003', 'Contato', '👤'),
  _Cat('CAT004', 'Financeiro', '💰'),
  _Cat('CAT005', 'Saúde', '❤️'),
  _Cat('CAT006', 'Documento', '📄'),
  _Cat('CAT007', 'Tarefa', '✅'),
  _Cat('CAT008', 'Aprendizado', '🎓'),
];

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _indice = 0;
  String? _categoriaId;
  String _categoriaTitulo = '';

  Future<void> _abrirCategorias() async {
    final cat = await showModalBottomSheet<_Cat>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Categorias',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _categorias.length,
                itemBuilder: (ctx, i) {
                  final c = _categorias[i];
                  return ListTile(
                    leading: Text(c.emoji, style: const TextStyle(fontSize: 22)),
                    title: Text(c.label),
                    onTap: () => Navigator.of(ctx).pop(c),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (cat != null) {
      setState(() {
        _categoriaId = cat.id;
        _categoriaTitulo = cat.label;
        _indice = 1;
      });
    }
  }

  Widget get _pagina {
    if (_indice == 2) return const ConfiguracoesPage();
    if (_categoriaId != null) {
      return RegistroListPage(
        key: ValueKey(_categoriaId),
        categoriaId: _categoriaId!,
        titulo: _categoriaTitulo,
      );
    }
    return const DashboardPage();
  }

  int get _selectedIndex => _categoriaId != null ? 1 : _indice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pagina,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          if (i == 1) {
            _abrirCategorias();
            return;
          }
          setState(() {
            _indice = i;
            _categoriaId = null;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Categorias',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Config',
          ),
        ],
      ),
    );
  }
}

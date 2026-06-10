import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../configuracoes/configuracoes_page.dart';
import '../dashboard/dashboard_page.dart';
import '../registro/registro_edit_page.dart';
import '../registro/registro_list_page.dart';
import 'painel_lateral.dart';

// Mapa de categoriaId → nome legível para o AppBar do editor
const _nomeCategoria = {
  'CAT001': 'Nota Livre',
  'CAT002': 'Evento',
  'CAT003': 'Contato',
  'CAT004': 'Financeiro',
  'CAT005': 'Saúde',
  'CAT006': 'Documento',
  'CAT007': 'Tarefa',
  'CAT008': 'Aprendizado',
};

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  // null = Dashboard
  String? _categoriaId;

  void _abrirBusca() {
    // Placeholder — busca global implementada em fase futura
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Busca global — em breve'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget get _conteudo {
    if (_categoriaId == null) return const DashboardPage();
    if (_categoriaId == '__config') return const ConfiguracoesPage();
    return RegistroListPage(
      categoriaId: _categoriaId!,
      titulo: _nomeCategoria[_categoriaId!] ?? _categoriaId!,
    );
  }

  void _novoRegistro() {
    if (_categoriaId == null || _categoriaId == '__config') return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistroEditPage(
          categoriaId: _categoriaId!,
          categoriaTitulo: _nomeCategoria[_categoriaId!] ?? _categoriaId!,
          registro: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyN, control: true):
            _novoRegistro,
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            _abrirBusca,
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.maybePop(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Row(
            children: [
              PainelLateral(
                categoriaIdSelecionada: _categoriaId,
                onCategoriaSelecionada: (id) =>
                    setState(() => _categoriaId = id),
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: _conteudo),
            ],
          ),
        ),
      ),
    );
  }
}

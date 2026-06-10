import 'package:flutter/material.dart';

class _ItemNav {
  final String categoriaId;
  final String label;
  final String icone;
  const _ItemNav(this.categoriaId, this.label, this.icone);
}

const _itens = [
  _ItemNav('CAT001', 'Nota Livre', '📝'),
  _ItemNav('CAT002', 'Evento', '📅'),
  _ItemNav('CAT003', 'Contato', '👤'),
  _ItemNav('CAT004', 'Financeiro', '💰'),
  _ItemNav('CAT005', 'Saúde', '❤️'),
  _ItemNav('CAT006', 'Documento', '📄'),
  _ItemNav('CAT007', 'Tarefa', '✅'),
  _ItemNav('CAT008', 'Aprendizado', '🎓'),
];

class PainelLateral extends StatelessWidget {
  final String? categoriaIdSelecionada;
  final ValueChanged<String?> onCategoriaSelecionada;

  const PainelLateral({
    super.key,
    required this.categoriaIdSelecionada,
    required this.onCategoriaSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Text(
              'Lembrex',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Início'),
                  selected: categoriaIdSelecionada == null,
                  selectedTileColor: colorScheme.primaryContainer,
                  selectedColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  onTap: () => onCategoriaSelecionada(null),
                ),
                const Divider(height: 16, indent: 12, endIndent: 12),
                ..._itens.map((item) {
                  final selecionado = item.categoriaId == categoriaIdSelecionada;
                  return ListTile(
                    leading: Text(item.icone, style: const TextStyle(fontSize: 20)),
                    title: Text(item.label),
                    selected: selecionado,
                    selectedTileColor: colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    onTap: () => onCategoriaSelecionada(item.categoriaId),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
            selected: categoriaIdSelecionada == '__config',
            onTap: () => onCategoriaSelecionada('__config'),
          ),
        ],
      ),
    );
  }
}
